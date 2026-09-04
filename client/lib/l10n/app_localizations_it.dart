// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Gioco di mafia';

  @override
  String get login => 'Login';

  @override
  String get register => 'Registro';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get usernameLabel => 'NOME UTENTE';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get usernamePlaceholder => 'Nome utente';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get registerButton => 'REGISTRO';

  @override
  String get forgotPassword => 'Ha dimenticato la password?';

  @override
  String get usernameRequired => 'Inserisci un nome utente';

  @override
  String get passwordRequired => 'Inserisci una password';

  @override
  String get passwordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get invalidCredentials => 'Nome utente o password errati';

  @override
  String get loginSuccessful => 'Accesso riuscito!';

  @override
  String get registrationSuccessful => 'Registrazione riuscita!';

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
  String get loginFailed => 'Accesso non riuscito';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get emailRequired => 'Inserisci un indirizzo email';

  @override
  String get emailInvalid => 'Si prega di inserire un indirizzo email valido';

  @override
  String get forgotPasswordTitle => 'Reimposta password';

  @override
  String get forgotPasswordDescription =>
      'Inserisci il tuo indirizzo email e ti invieremo un collegamento per reimpostare la password.';

  @override
  String get resetPasswordButton => 'INVIA LINK DI RESET';

  @override
  String get emailSent =>
      'Reimposta collegamento inviato! Controlla la tua email.';

  @override
  String get backToLogin => 'Torna all\'accesso';

  @override
  String welcome(String username) {
    return 'Benvenuto, $username!';
  }

  @override
  String get dashboardTimeouts => 'Timeout';

  @override
  String get dashboardTimeoutCrime => 'Crimine';

  @override
  String get dashboardTimeoutJob => 'Lavoro';

  @override
  String get dashboardTimeoutTravel => 'Viaggio';

  @override
  String get dashboardTimeoutVehicleTheft => 'Rubare l\'auto';

  @override
  String get dashboardTimeoutBoatTheft => 'Rubare la barca';

  @override
  String get dashboardTimeoutNightclubSeason => 'Stagione delle discoteche';

  @override
  String get dashboardTimeoutAmmo => 'Acquista proiettili';

  @override
  String get dashboardTimeoutShootingRange => 'Poligono di tiro';

  @override
  String get dashboardTimeoutGym => 'Palestra';

  @override
  String get dashboardTimeoutGymStrength => 'Gym: strength';

  @override
  String get dashboardTimeoutGymSpeed => 'Gym: speed';

  @override
  String get dashboardTimeoutGymStamina => 'Gym: stamina';

  @override
  String get dashboardInfoDrugsGrams => 'Droga (grammi)';

  @override
  String get dashboardInfoNightclubs => 'Discoteche';

  @override
  String get dashboardInfoNightclubRevenue => 'Entrate delle discoteche';

  @override
  String get dashboard => 'Pannello di controllo';

  @override
  String get crimes => 'Crimini';

  @override
  String get errorLoadingCrimes => 'Impossibile caricare i crimini';

  @override
  String connectionError(String error) {
    return 'Errore di connessione: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Paga: €$min - €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Richiede il grado $rank';
  }

  @override
  String get requiresVehicle => 'Richiede veicolo';

  @override
  String get federalCrimeWarning => '⚠️ Crimine federale - Calore dell\'FBI';

  @override
  String get crimePickpocketName => 'Borseggio';

  @override
  String get crimePickpocketDesc => 'Rubare i portafogli ai passanti';

  @override
  String get crimeShopliftName => 'Taccheggio';

  @override
  String get crimeShopliftDesc => 'Rubare merce da un negozio';

  @override
  String get crimeStealBikeName => 'Rubare la bicicletta';

  @override
  String get crimeStealBikeDesc => 'Rubare una bicicletta da una rastrelliera';

  @override
  String get crimeCarTheftName => 'Furto d\'auto';

  @override
  String get crimeCarTheftDesc => 'Rubare un\'auto parcheggiata';

  @override
  String get crimeBurglaryName => 'Furto';

  @override
  String get crimeBurglaryDesc => 'Irrompere in una casa';

  @override
  String get crimeRobStoreName => 'Rapina in negozio';

  @override
  String get crimeRobStoreDesc => 'Rapina un piccolo negozio';

  @override
  String get crimeMugPersonName => 'Aggressione';

  @override
  String get crimeMugPersonDesc => 'Aggredire qualcuno per strada';

  @override
  String get crimeStealCarPartsName => 'Rubare parti di automobili';

  @override
  String get crimeStealCarPartsDesc => 'Ruba parti dalle auto parcheggiate';

  @override
  String get crimeHijackTruckName => 'Dirottare il camion';

  @override
  String get crimeHijackTruckDesc => 'Dirotta un camion che trasporta merci';

  @override
  String get crimeAtmTheftName => 'Furto bancomat';

  @override
  String get crimeAtmTheftDesc => 'Irrompere in un bancomat';

  @override
  String get crimeJewelryHeistName => 'Furto di gioielli';

  @override
  String get crimeJewelryHeistDesc => 'Derubare un gioielliere';

  @override
  String get crimeVandalismName => 'Vandalismo';

  @override
  String get crimeVandalismDesc =>
      'Danneggiare la proprietà in cambio di denaro';

  @override
  String get crimeGraffitiName => 'Graffiti';

  @override
  String get crimeGraffitiDesc => 'Spruzza graffiti per le bande locali';

  @override
  String get crimeDrugDealSmallName => 'Piccolo spaccio di droga';

  @override
  String get crimeDrugDealSmallDesc => 'Vendi una piccola quantità di droga';

  @override
  String get crimeDrugDealLargeName => 'Grande affare di droga';

  @override
  String get crimeDrugDealLargeDesc => 'Vendere una grande quantità di farmaci';

  @override
  String get crimeExtortionName => 'Estorsione';

  @override
  String get crimeExtortionDesc => 'Estorcere denaro alle imprese locali';

  @override
  String get crimeKidnappingName => 'Rapimento';

  @override
  String get crimeKidnappingDesc => 'Rapisci qualcuno per ottenere un riscatto';

  @override
  String get crimeArsonName => 'Incendio doloso';

  @override
  String get crimeArsonDesc => 'Dai fuoco a un edificio';

  @override
  String get crimeSmugglingName => 'Contrabbando';

  @override
  String get crimeSmugglingDesc => 'Contrabbandare merci oltre confine';

  @override
  String get crimeAssassinationName => 'Assassinio';

  @override
  String get crimeAssassinationDesc => 'Esegui un omicidio su commissione';

  @override
  String get crimeHackAccountName => 'Hackerare l\'account';

  @override
  String get crimeHackAccountDesc => 'Hackerare un conto bancario';

  @override
  String get crimeCounterfeitMoneyName => 'Denaro contraffatto';

  @override
  String get crimeCounterfeitMoneyDesc => 'Guadagna soldi falsi';

  @override
  String get crimeIdentityTheftName => 'Furto d\'identità';

  @override
  String get crimeIdentityTheftDesc =>
      'Rubare l\'identità di qualcuno per frode';

  @override
  String get crimeRobArmoredTruckName => 'Rapina al camion blindato';

  @override
  String get crimeRobArmoredTruckDesc => 'Ruba un camion blindato';

  @override
  String get crimeArtTheftName => 'Furto d\'arte';

  @override
  String get crimeArtTheftDesc => 'Ruba opere d\'arte di valore';

  @override
  String get crimeProtectionRacketName => 'Racchetta di protezione';

  @override
  String get crimeProtectionRacketDesc => 'Far pagare alle imprese il pizzo';

  @override
  String get crimeCasinoHeistName => 'Rapina al casinò';

  @override
  String get crimeCasinoHeistDesc => 'Derubare un casinò';

  @override
  String get crimeBankRobberyName => 'Rapina in banca';

  @override
  String get crimeBankRobberyDesc => 'Rapinare una banca';

  @override
  String get crimeStealYachtName => 'Rubare Yacht';

  @override
  String get crimeStealYachtDesc => 'Ruba uno yacht di lusso';

  @override
  String get crimeCorruptOfficialName => 'Corrompere il funzionario';

  @override
  String get crimeCorruptOfficialDesc =>
      'Corrompere un funzionario per ottenere favori';

  @override
  String get crimeEliminateWitnessName => 'Elimina testimone';

  @override
  String get crimeEliminateWitnessDesc =>
      'Eliminare un testimone prima del processo';

  @override
  String get crimeDiamondHeistName => 'Colpo al trasporto di diamanti';

  @override
  String get crimeDiamondHeistDesc => 'Dirotta un trasporto di diamanti grezzi';

  @override
  String get crimeEvidenceRoomHeistName => 'Rapina alla stanza delle prove';

  @override
  String get crimeEvidenceRoomHeistDesc => 'Ruba prove da un deposito federale';

  @override
  String get crimeMuseumHeistName => 'Rapina al museo';

  @override
  String get crimeMuseumHeistDesc => 'Ruba manufatti di valore da un museo';

  @override
  String get crimeBossAssassinationName => 'Assassinio del boss rivale';

  @override
  String get crimeBossAssassinationDesc =>
      'Elimina il leader di un\'organizzazione rivale';

  @override
  String get crimeCriminalRecordWipeName => 'Cancella la fedina penale';

  @override
  String get tooltipCrimeRequiresTools => 'Strumenti richiesti';

  @override
  String get tooltipCrimeRequiresVehicle => 'Veicolo richiesto';

  @override
  String get tooltipCrimeRequiresDrugs => 'Necessari farmaci';

  @override
  String get tooltipCrimeHighValue => 'Operazione di alto valore';

  @override
  String get tooltipCrimeRequiresViolence => 'Violenza necessaria';

  @override
  String get tooltipCrimeRequiresWeapon => 'Arma richiesta';

  @override
  String get tooltipCrimeRequirementsHeading => 'Necessaria:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Cancella tutta la tua fedina penale in caso di successo. Disponibile solo se hai già delle condanne.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Hai bisogno di almeno ${quantity}g di: $drugs';
  }

  @override
  String get jobs => 'Lavori';

  @override
  String get errorLoadingJobs => 'Impossibile caricare i lavori';

  @override
  String get jobNewspaperDeliveryName => 'Consegna del giornale';

  @override
  String get jobNewspaperDeliveryDesc =>
      'Consegnare i giornali la mattina presto';

  @override
  String get jobCarWashName => 'Autolavaggio';

  @override
  String get jobCarWashDesc => 'Lavare le auto all\'autolavaggio';

  @override
  String get jobGroceryBaggerName => 'Insaccatore di generi alimentari';

  @override
  String get jobGroceryBaggerDesc => 'Scaffali di magazzino al supermercato';

  @override
  String get jobDishwasherName => 'Lavastoviglie';

  @override
  String get jobDishwasherDesc => 'Lavare i piatti in un ristorante';

  @override
  String get jobStreetSweeperName => 'Spazzino stradale';

  @override
  String get jobStreetSweeperDesc => 'Spazzare le strade';

  @override
  String get jobPizzaDeliveryName => 'Consegna pizza';

  @override
  String get jobPizzaDeliveryDesc => 'Consegnare pizze in città';

  @override
  String get jobTaxiDriverName => 'Tassista';

  @override
  String get jobTaxiDriverDesc => 'Guida un taxi per la città';

  @override
  String get jobWarehouseWorkerName => 'Magazziniere';

  @override
  String get jobWarehouseWorkerDesc => 'Lavorare in un magazzino';

  @override
  String get jobConstructionWorkerName => 'Operaio edile';

  @override
  String get jobConstructionWorkerDesc => 'Lavorare in un cantiere edile';

  @override
  String get jobBartenderName => 'Barista';

  @override
  String get jobBartenderDesc => 'Versare la birra e mescolare i cocktail';

  @override
  String get jobSecurityGuardName => 'Guardia di sicurezza';

  @override
  String get jobSecurityGuardDesc => 'Sorveglia un edificio';

  @override
  String get jobTruckDriverName => 'Camionista';

  @override
  String get jobTruckDriverDesc => 'Guidare un camion per lunghe distanze';

  @override
  String get jobMechanicName => 'Meccanica';

  @override
  String get jobMechanicDesc => 'Riparare le auto in un garage';

  @override
  String get jobElectricianName => 'Elettricista';

  @override
  String get jobElectricianDesc =>
      'Installazione e riparazione impianti elettrici';

  @override
  String get jobPlumberName => 'Idraulica';

  @override
  String get jobPlumberDesc => 'Riparazione tubi e impianti idraulici';

  @override
  String get jobChefName => 'Capocuoca';

  @override
  String get jobChefDesc => 'Cucinare in un ristorante';

  @override
  String get jobParamedicName => 'Paramedica';

  @override
  String get jobParamedicDesc => 'Aiuta le persone bisognose';

  @override
  String get jobProgrammerName => 'Programmatrice';

  @override
  String get jobProgrammerDesc => 'Scrivere software per le aziende';

  @override
  String get jobAccountantName => 'Contabile';

  @override
  String get jobAccountantDesc => 'Gestire le finanze per le imprese';

  @override
  String get jobLawyerName => 'Avvocatessa';

  @override
  String get jobLawyerDesc => 'Difendere i clienti in tribunale';

  @override
  String get jobRealEstateAgentName => 'Agente immobiliare';

  @override
  String get jobRealEstateAgentDesc => 'Vendere case ed edifici';

  @override
  String get jobStockbrokerName => 'Agente di cambio';

  @override
  String get jobStockbrokerDesc => 'Azioni commerciali';

  @override
  String get jobDoctorName => 'Medico';

  @override
  String get jobDoctorDesc => 'Trattare i pazienti in ospedale';

  @override
  String get jobAirlinePilotName => 'Pilota';

  @override
  String get jobAirlinePilotDesc => 'Volare su aerei passeggeri';

  @override
  String jobSuccessChancePercent(String percent) {
    return '$percent% di probabilità';
  }

  @override
  String jobXpRewardShort(String xp) {
    return '+$xp XP';
  }

  @override
  String jobPayRangeEuro(String min, String max) {
    return '€$min-€$max';
  }

  @override
  String get travel => 'Viaggio';

  @override
  String get errorLoadingCountries => 'Impossibile caricare i paesi';

  @override
  String get currentLocation => 'Posizione attuale';

  @override
  String get current => 'Attuale';

  @override
  String get travelTo => 'Viaggio';

  @override
  String travelCost(String amount) {
    return 'Costo: €$amount';
  }

  @override
  String get travelJourneyTitle => 'Iniziare il viaggio?';

  @override
  String get travelRouteLabel => 'Itinerario:';

  @override
  String travelLegsLabel(String count) {
    return 'Gambe: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Costo per tratta: €$amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Costo totale: €$amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Recupero: $minutes min per gamba';
  }

  @override
  String get travelRiskPerLeg =>
      'Rischio: per gamba (può essere imprigionato e perdere tutti i beni)';

  @override
  String get travelStart => 'Inizio';

  @override
  String travelInTransitTo(String country) {
    return 'In transito verso $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Gamba $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Prossima fermata: $country';
  }

  @override
  String get travelContinue => 'Continuare';

  @override
  String get travelCancelJourney => 'Annulla il viaggio';

  @override
  String get travelJourneyCanceled => 'Viaggio annullato';

  @override
  String get travelNotInTransit => 'Non sei in viaggio.';

  @override
  String get travelDirect => 'Diretto';

  @override
  String travelVia(String countries) {
    return 'tramite $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count gambe';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Rimarrai in prigione per altri $minutes minuti';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Ho viaggiato fino a $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity oggetti $item confiscati!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item danneggiato (perdita di valore del $percent%)!';
  }

  @override
  String get countryNetherlands => 'Paesi Bassi';

  @override
  String get countryBelgium => 'Belgio';

  @override
  String get countryGermany => 'Germania';

  @override
  String get countryFrance => 'Francia';

  @override
  String get countrySpain => 'Spagna';

  @override
  String get countryItaly => 'Italia';

  @override
  String get countryUk => 'Regno Unito';

  @override
  String get countrySwitzerland => 'Svizzera';

  @override
  String get crew => 'Equipaggio';

  @override
  String get profile => 'Profilo';

  @override
  String get logout => 'Esci';

  @override
  String get logOut => 'Esci';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Account';

  @override
  String get userAccountMenuTooltip => 'Menù conto';

  @override
  String get myProfile => 'Il mio profilo';

  @override
  String get messages => 'Messaggi';

  @override
  String get noDirectMessagesYet => 'Nessun messaggio ancora';

  @override
  String get sendMessageToFriendsHint => 'Invia un messaggio ai tuoi amici!';

  @override
  String errorLoadingConversations(String error) {
    return 'Errore durante il caricamento delle conversazioni: $error';
  }

  @override
  String get messageSystemBadge => 'SISTEMA';

  @override
  String get messageSystemInboxPreview => 'Risultati e messaggi di sistema';

  @override
  String get messageSystemThreadSubtitle => 'Risultati e messaggi di sistema';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Gli obiettivi e i messaggi di sistema vengono visualizzati qui automaticamente.';

  @override
  String get messageSendFirst => 'Invia il primo messaggio!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Classifica $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Errore durante il caricamento dei messaggi: $error';
  }

  @override
  String get messageDeleteOwnOnly => 'Puoi eliminare solo i tuoi messaggi';

  @override
  String get messageDeleteTitle => 'Elimina messaggio';

  @override
  String get messageDeleteBody =>
      'Questo messaggio verrà eliminato definitivamente.';

  @override
  String get messageSendFailed => 'Impossibile inviare il messaggio';

  @override
  String get messageDeleteFailed => 'Impossibile eliminare il messaggio';

  @override
  String get investigationWindowExpired =>
      'Il periodo di indagine è scaduto (24 ore).';

  @override
  String get investigationStartedInboxHint =>
      'Avviate le indagini. Controlla la tua casella di posta per il rapporto del detective.';

  @override
  String get investigationAlreadyInProgress =>
      'Questa indagine è già in corso o completata.';

  @override
  String investigationStartFailed(String error) {
    return 'Impossibile avviare l\'indagine: $error';
  }

  @override
  String get investigationExpired => 'Istruttoria scaduta';

  @override
  String get investigationStarted => 'Avviate le indagini';

  @override
  String get investigationStarting => 'Di partenza...';

  @override
  String get startMurderInvestigation => 'Avvia l\'indagine per omicidio';

  @override
  String get systemMessagesReadOnlyHint =>
      'Non è possibile rispondere ai messaggi di sistema';

  @override
  String get helpAndGuide => 'Aiuto e guida';

  @override
  String get helpUiManualTitle => 'Manuale del gioco';

  @override
  String get helpUiSearchHint => 'Cerca per modulo, spiegazione o suggerimento';

  @override
  String get helpUiTopicLabel => 'Argomento';

  @override
  String get helpUiAllChip => 'Tutto';

  @override
  String get helpUiNoResultsTitle => 'Nessun argomento trovato';

  @override
  String get helpUiNoResultsBody =>
      'Modifica la ricerca o la categoria per visualizzare nuovamente i risultati.';

  @override
  String get helpUiHowItWorks => 'Come funziona';

  @override
  String get helpUiTips => 'Suggerimenti';

  @override
  String get quickActions => 'Azioni rapide';

  @override
  String get mobileNavCrimes => 'Crimini';

  @override
  String get mobileNavSteal => 'Rubare';

  @override
  String get mobileNavWork => 'Lavoro';

  @override
  String get mobileNavBank => 'Banca';

  @override
  String get mobileNavCrew => 'Equipaggio';

  @override
  String get mobileNavReady => 'Pronta';

  @override
  String get menuSearchHint => 'Menù di ricerca';

  @override
  String get menuSearchNoResults => 'Nessuna pagina corrispondente';

  @override
  String get menuNavCategoryActions => 'Azioni';

  @override
  String get menuNavCategoryWorld => 'Mondo';

  @override
  String get menuNavCategorySocial => 'Sociale';

  @override
  String get menuNavCategoryEconomy => 'Economia';

  @override
  String get menuNavCategoryEmpire => 'Impero';

  @override
  String get menuNavCategoryAssets => 'Attività';

  @override
  String get menuNavCategoryMore => 'Di più';

  @override
  String get liveEvents => 'La mia attività';

  @override
  String get worldFeedHint => 'Solo le tue azioni recenti.';

  @override
  String get support => 'Supporto';

  @override
  String get events => 'Eventi';

  @override
  String get liveEventRailOpenEvents => 'Open events';

  @override
  String seasonPassTitle(String season) {
    return 'Season Pass $season';
  }

  @override
  String get seasonPassSubtitle =>
      '56 obiettivi mensili: crimini, veicoli, contrabbando, droga, soldi guadagnati, XP e reclutamento prostituzione. Premio evento gratis e bonus Event Pass (premium) per riga.';

  @override
  String seasonPassGoalProstitution(int count) {
    return 'Recluta $count lavoratrici';
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
  String get aviation => 'Aviazione';

  @override
  String get premiumAndCredits => 'Premi e crediti';

  @override
  String get bank => 'Banca';

  @override
  String get tradeGoods => 'Beni commerciali';

  @override
  String get drugs => 'Droghe';

  @override
  String get nightclub => 'Discoteca';

  @override
  String get crypto => 'Criptovaluta';

  @override
  String get smuggling => 'Contrabbando';

  @override
  String get tools => 'utensili';

  @override
  String get vehicleHeist => 'Furto di veicoli';

  @override
  String get vehicleHeistTitle => 'Furto di veicoli';

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
      'Ruba auto per contanti e pezzi di ricambio.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Ruba motociclette in cambio di contanti e pezzi di ricambio.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Ruba barche in cambio di contanti e pezzi di ricambio.';

  @override
  String get vehicleHeistReady => 'Pronta';

  @override
  String get vehicleHeistMotorStorage => 'Deposito moto';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'La capacità dell\'auto è condivisa tra tutti i furti d\'auto.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'La capacità della motocicletta è condivisa tra tutte le rapine in moto.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'La capacità della barca è condivisa tra tutti i colpi di barca.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Grado richiesto: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Deposito: $stored/$total (corsia livello $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Rubare l\'auto';

  @override
  String get vehicleHeistStealMotorcycle => 'Rubare la moto';

  @override
  String get vehicleHeistStealBoat => 'Rubare la barca';

  @override
  String get vehicleHeistGenericVehicle => 'veicolo';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Successo: $vehicle rubato.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Tempo di recupero attivo: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Sei stato arrestato ($minutes min carcere).';
  }

  @override
  String get vehicleHeistUntil => 'Fino a';

  @override
  String get vehicleHeistRegionalLockActive => 'Blocco regionale attivo.';

  @override
  String get vehicleHeistStealFailed => 'Azione di furto non riuscita.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Aggiornamento completato.';

  @override
  String get vehicleHeistUpgradeFailed => 'Aggiornamento non riuscito.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Auto disponibili';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Moto disponibili';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Barche disponibili';

  @override
  String get vehicleHeistCatalogEmpty => 'Nessun veicolo in questo catalogo.';

  @override
  String get vehicleHeistRarityCommon => 'Comune';

  @override
  String get vehicleHeistRarityUncommon => 'Non comune';

  @override
  String get vehicleHeistRarityRare => 'Rara';

  @override
  String get vehicleHeistRarityEpic => 'Epica';

  @override
  String get vehicleHeistRarityLegendary => 'Leggendaria';

  @override
  String get vehicleHeistEventOnlyTag => 'Solo evento';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Valore: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Classifica: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Disponibilità nel gioco: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Più comune in: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Paesi: $countries';
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
    return 'Aggiornamento ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Aggiornamento bloccato: grado $rank richiesto';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Aggiornamento bloccato';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Accelera per $credits crediti';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Accelera (schermata successiva)';

  @override
  String get vehicleHeistExpand => 'Espandere';

  @override
  String get vehicleHeistCollapse => 'Crollo';

  @override
  String get vehicleHeistActive => 'ATTIVA';

  @override
  String get vehicleHeistOff => 'spenta';

  @override
  String get catalog => 'Catalogare';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Esegui Hotspot';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Esecuzione dell\'hotspot';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Corsa all\'hotspot completata: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Cooldown dell\'hotspot attivo ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'L\'hotspot non è riuscito. Il calore è aumentato.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Crew op';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Crew op';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Operazione Crew completata: hai guadagnato $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Crew richiesto.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Tempo di recupero dell\'operazione Crew attivo ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'Operazione dell\'Crew fallita.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Unisciti a un Crew per sbloccare le azioni dell\'Crew';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew richiesto: sì';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew richiesto: no (unisciti prima a un Crew)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Acquista parti';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Acquista parti';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Acquistare quali parti? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Parti acquistate: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'Acquisto delle parti non riuscito.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Richiedi contratto';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Reclamare il contratto';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contratto completato: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Nessun veicolo idoneo nell\'inventario per questo contratto.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Tempo di recupero del contratto attivo ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'La richiesta di contratto non è riuscita.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Assicurazione';

  @override
  String get vehicleHeistOpsInsuranceTitle =>
      'Assicurazione contro il contrabbando';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Scegli un livello di copertura per questa categoria di veicoli.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Di base';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pro';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Assicurazione attiva ($tier) per $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'L\'acquisto dell\'assicurazione non è riuscito.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Partita dell\'Crew';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Partita dell\'Crew vinta: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Partita dell\'Crew persa: +$reward consolazione';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed =>
      'Il matchmaking dell\'Crew è fallito.';

  @override
  String get vehicleHeistOpsCounterButton => 'Contatrice';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Successo contro-intercettazione: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Controintercettazione non disponibile o fallita.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Contratto operativo';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Contratto operativo';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Contratto operativo completato: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Contratto operativo fallito o in ricarica.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Rivendica controversia';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'Nessuna richiesta di risarcimento assicurativa aperta.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'Nessuna richiesta valida trovata.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Reclamo approvato: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Reclamo rifiutato: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'La risoluzione del reclamo non è riuscita.';

  @override
  String get vehicleHeistOpsIntelTitle => 'Intelligenza operativa dei veicoli';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Aggiorna l\'intelligenza';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Tocca per espandere e visualizzare tutte le azioni.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Calore $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Polizia: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Rappresentazione livello $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Mercato dei ricambi: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Punto caldo: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Ricompensa: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Perché ottieni contanti: le azioni operative di successo pagano direttamente nel denaro del portafoglio.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Contanti: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Tu: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Contanti: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contratti: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| da $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Prezzi parziali (auto/moto/barca): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Aggiornamento mercato ricambi: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size membri)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Ricompensa contratto Chop: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Finestra di intercettazione: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Lista nera: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Lista nera: nessuna';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Assicurazione: $tier attiva';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine =>
      'Assicurazione: inattiva';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Modificatore paese: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Stagione dell\'Crew: $season | punti $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contratti: $count | tempo di recupero $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Tempo di recupero del contatore: $cooldown | reclami aperti: $claims';
  }

  @override
  String get tuneShop => 'Negozio di sintonizzazione';

  @override
  String get tuneShopIntro =>
      'Rottama i veicoli per ricavarne parti e migliora la velocità, la furtività e l\'armatura. Le parti sono condivise per categoria (auto/moto/barca), quindi puoi mettere a punto qualsiasi veicolo all\'interno della stessa categoria.';

  @override
  String get tuneShopCarPartsLabel => 'Parti di automobili';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Parti di motociclette';

  @override
  String get tuneShopBoatPartsLabel => 'Parti di barche';

  @override
  String get tuneShopEmptyTitle =>
      'Nessun veicolo disponibile per la messa a punto';

  @override
  String get tuneShopEmptyBody =>
      'Ruba prima alcuni veicoli e rottamane alcuni per le parti.';

  @override
  String get tuneShopVehicleTypeCar => 'Auto';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motociclo';

  @override
  String get tuneShopVehicleTypeBoat => 'Barca';

  @override
  String get tuneShopStatSpeed => 'Velocità';

  @override
  String get tuneShopStatStealth => 'Furtività';

  @override
  String get tuneShopStatArmor => 'Armatura';

  @override
  String get tuneShopValueMultiplierPrefix => 'Valorex';

  @override
  String get tuneShopUpgradeButton => 'Aggiornamento';

  @override
  String get tuneShopMaxLabel => 'MASSIMO';

  @override
  String get tuneShopPartsAbbrev => 'punti';

  @override
  String get tuneShopUpgradeCompleted => 'Aggiornamento completato';

  @override
  String get tuneShopUpgradeFailed => 'Aggiornamento non riuscito';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning bloccato: il veicolo è in transito.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning bloccato: il veicolo è in riparazione.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tempo di recupero dell\'ottimizzazione attivo: $duration rimanenti.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Veicolo non trovato';

  @override
  String get tuneShopErrorNotOwner => 'Non possiedi questo veicolo';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning bloccato: il veicolo è in transito.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning bloccato: il veicolo è in riparazione.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Non abbastanza soldi';

  @override
  String get tuneShopErrorInsufficientParts => 'Parti insufficienti';

  @override
  String get tuneShopErrorStatMaxed =>
      'Questo livello di sintonizzazione è al massimo';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tempo di recupero dell\'ottimizzazione attivo: $duration rimanenti.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Limite raggiunto: max $max sintonizzazione simultanea, attualmente $active.';
  }

  @override
  String get tuneShopErrorInvalidStat =>
      'Statistica di ottimizzazione non valida';

  @override
  String get territory => 'Territorio';

  @override
  String get achievements => 'Risultati';

  @override
  String get menuCrackVault => 'Scassina il caveau';

  @override
  String get vaultHeroTagline => 'Indovina il codice e vinci grandi premi.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Stagione: $range';
  }

  @override
  String get vaultYourCredits => 'I tuoi crediti';

  @override
  String get vaultChooseStake => 'Scegli la tua puntata';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake crediti',
      one: '$stake credito',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Premio previsto: +$reward crediti';
  }

  @override
  String get vaultCodeLabel => 'Codice';

  @override
  String get vaultSubmitStake => 'Invia puntata';

  @override
  String get vaultWrongCodesTitle => 'Codici errati (questo mese)';

  @override
  String get vaultShowWrongCodes => 'Mostra';

  @override
  String get vaultHideWrongCodes => 'Nascondi';

  @override
  String get vaultNoWrongCodesYet => 'Nessun codice errato ancora salvato.';

  @override
  String get couldNotLoadVaultStatus => 'Impossibile caricare lo stato.';

  @override
  String get vaultEnterFourDigitCode => 'Inserisci un codice di 4 cifre.';

  @override
  String get vaultAttemptSuccessGeneric => 'Successo.';

  @override
  String get vaultAttemptFailedGeneric => 'Fallito.';

  @override
  String get vaultAttemptFailedRetry => 'Fallito. Per favore riprova.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count nuovi messaggi';
  }

  @override
  String get rankProgress => 'Avanzamento di grado';

  @override
  String get cash => 'Contanti';

  @override
  String get sessionRecap => 'Riepilogo della sessione';

  @override
  String get nameLabel => 'Nome';

  @override
  String get countryLabel => 'Paese';

  @override
  String get wantedLevel => 'Livello ricercato';

  @override
  String get fbiHeat => 'Calore dell\'FBI';

  @override
  String get properties => 'Proprietà';

  @override
  String get vehicles => 'Veicoli';

  @override
  String get netWorth => 'Patrimonio netto';

  @override
  String get securityLabel => 'Sicurezza';

  @override
  String get noSecurity => 'Nessuna sicurezza';

  @override
  String get weaponLabel => 'Arma';

  @override
  String get vehicleLabel => 'Veicolo';

  @override
  String get none => 'Nessuno';

  @override
  String get statistics => 'Statistiche';

  @override
  String get breakouts => 'Breakout';

  @override
  String get murders => 'Omicidi';

  @override
  String get hitlistContracts => 'Contratti di hitlist';

  @override
  String get carsStolen => 'Auto rubate';

  @override
  String get boatsStolen => 'Barche rubate';

  @override
  String get crimeAttempts => 'Tentativi di crimine';

  @override
  String get successful => 'Riuscita';

  @override
  String get jobAttempts => 'Tentativi di lavoro';

  @override
  String get streetProstitutes => 'Prostitute di strada';

  @override
  String get rldProstitutes => 'Prostitute RLD';

  @override
  String get travels => 'Viaggi';

  @override
  String get bullets => 'Proiettili';

  @override
  String get moneyStatusLabel => 'Stato del denaro';

  @override
  String get moneyStatusPoor => 'Povera';

  @override
  String get moneyStatusRising => 'In aumento';

  @override
  String get moneyStatusRich => 'Ricca';

  @override
  String get moneyStatusMultimillionaire => 'Multimilionaria';

  @override
  String get rankBeginner => 'Principiante';

  @override
  String get rankCriminal => 'Penale';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Mafiosa';

  @override
  String get rankEmptySuit => 'Abito vuoto';

  @override
  String get rankDeliveryBoy => 'Ragazzo delle consegne';

  @override
  String get rankPicciotto => 'Picciotto';

  @override
  String get rankShoplifter => 'Taccheggiatore';

  @override
  String get rankPickpocket => 'Borsaiolo';

  @override
  String get rankThief => 'Ladro';

  @override
  String get rankAssociate => 'Socio';

  @override
  String get rankCadet => 'Cadetto';

  @override
  String get rankSoldier => 'Soldato';

  @override
  String get rankSwindler => 'Truffatore';

  @override
  String get rankAssassin => 'Assassino';

  @override
  String get rankLocalChief => 'Capo locale';

  @override
  String get rankChief => 'Capo';

  @override
  String get rankDrugLord => 'Signore della droga';

  @override
  String get rankGodfather => 'Padrino';

  @override
  String get rankDon => 'Don';

  @override
  String get rankOverlord => 'Signore supremo';

  @override
  String get rankLegend => 'Leggenda';

  @override
  String get rankUnknown => 'Sconosciuto';

  @override
  String get dailyGoalTitle_crime_3 => 'Compi 3 crimini';

  @override
  String get dailyGoalTitle_job_2 => 'Lavorare 2 volte';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Ruba 1 veicolo';

  @override
  String get dailyGoalTitle_travel_1 => 'Completa 1 viaggio';

  @override
  String get dailyGoalTitle_training_combo_1 =>
      'Train gym + shooting range (same day)';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Settimanale: 20 crimini';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Settimanale: lavora 10 volte';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Settimanale: ruba 5 veicoli';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Settimanale: 3 viaggi';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Ricompensa: +$cash e +$xp XP';
  }

  @override
  String get justNow => 'Proprio adesso';

  @override
  String secondsAgo(String seconds) {
    return '${seconds}s fa';
  }

  @override
  String minutesAgo(String count) {
    return '$count minuti fa';
  }

  @override
  String hoursAgo(String count) {
    return '$count ore fa';
  }

  @override
  String get last10EventsLive => 'Ultimi 10 eventi (dal vivo).';

  @override
  String get noEventsYetSession => 'Nessun evento ancora in questa sessione.';

  @override
  String get clearRecap => 'Riepilogo chiaro';

  @override
  String get weeklyGoalClaimed => 'Obiettivo settimanale rivendicato!';

  @override
  String get dailyGoalClaimed => 'Obiettivo giornaliero rivendicato!';

  @override
  String get failed => 'Fallito.';

  @override
  String get failedPleaseTryAgain => 'Fallito. Per favore riprova.';

  @override
  String get dailyGoals => 'Obiettivi quotidiani';

  @override
  String get weeklyGoals => 'Obiettivi settimanali';

  @override
  String get claimed => 'Reclamata';

  @override
  String get ready => 'Pronta';

  @override
  String get claim => 'Reclamo';

  @override
  String readyToClaim(String count) {
    return '$count pronto a reclamare';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total completato';
  }

  @override
  String get noPlayerData => 'Nessun dato del giocatore';

  @override
  String get economy24h => 'Economico 24 ore su 24';

  @override
  String get grossIncome => 'Reddito lordo';

  @override
  String get propertySpend => 'Spesa immobiliare';

  @override
  String get netCashflow => 'Flusso di cassa netto';

  @override
  String get trendVsPrevious => 'Tendenza rispetto al precedente';

  @override
  String get activity7d => 'Attività 7d';

  @override
  String get vehicleThefts => 'Furti di veicoli';

  @override
  String get opsOverview => 'Panoramica delle operazioni';

  @override
  String get activeCooldowns => 'Cooldown attivi';

  @override
  String get longestTimer => 'Il timer più lungo';

  @override
  String get activeProduction => 'Produzione attiva';

  @override
  String get productionReadyIn => 'Produzione pronta';

  @override
  String get nightclubEvents => 'Eventi in discoteca';

  @override
  String get nextEventStartsIn => 'Il prossimo evento inizia tra';

  @override
  String get vehiclesActiveListedTransit =>
      'Veicoli attivi/quotati/in transito';

  @override
  String get livePlayerEvents => 'Eventi dei giocatori dal vivo';

  @override
  String get openEvents => 'Eventi aperti';

  @override
  String get notificationsAndRisk => 'Notifiche e rischi';

  @override
  String get unreadDm => 'DM non letto';

  @override
  String get supportWaitingOnYou => 'Il supporto ti aspetta';

  @override
  String get eventsLast24h => 'Gli eventi durano 24 ore';

  @override
  String get riskScore => 'Punteggio di rischio';

  @override
  String get recruitProstitute => 'Recluta una prostituta';

  @override
  String get free => 'GRATUITA';

  @override
  String get crewWars => 'Guerre tra equipaggi';

  @override
  String get status => 'Stato';

  @override
  String get canDeclare => 'Può dichiarare';

  @override
  String get yes => 'SÌ';

  @override
  String get no => 'NO';

  @override
  String get type => 'Tipa';

  @override
  String get opponent => 'Avversaria';

  @override
  String get crewPoints => 'Punti Crew';

  @override
  String get warRank => 'Grado di guerra';

  @override
  String get seasonRank => 'Classifica stagionale';

  @override
  String get openTargets => 'Obiettivi aperti';

  @override
  String get phaseEndsIn => 'La fase termina tra';

  @override
  String get crewTerritory => 'Territorio dell\'Crew';

  @override
  String get regions => 'Regioni';

  @override
  String get countriesCaptured => 'Paesi catturati';

  @override
  String get payout => 'Pagamento';

  @override
  String get earningPerHour => 'Guadagna ora ogni ora';

  @override
  String get earningPerDay => 'Guadagna ora al giorno';

  @override
  String get totalEarned => 'Totale guadagnato';

  @override
  String get crewBank => 'Banca dell\'Crew';

  @override
  String get dashboardEconomy24h => 'Economia 24 h';

  @override
  String get dashboardGrossIncome => 'Reddito lordo';

  @override
  String get dashboardPropertySpend => 'Spesa immobiliare';

  @override
  String get dashboardNetCashflow => 'Flusso di cassa netto';

  @override
  String get dashboardTrendVsPrevious => 'Tendenza vs periodo precedente';

  @override
  String get dashboardActivity7d => 'Attività (7 giorni)';

  @override
  String get dashboardVehicleThefts => 'Furti di veicoli';

  @override
  String get dashboardOpsOverview => 'Panoramica operazioni';

  @override
  String get dashboardActiveCooldowns => 'Cooldown attivi';

  @override
  String get dashboardLongestTimer => 'Timer più lungo';

  @override
  String get dashboardActiveProduction => 'Produzione attiva';

  @override
  String get dashboardProductionReadyIn => 'Produzione pronta tra';

  @override
  String get dashboardNightclubEvents => 'Eventi in discoteca';

  @override
  String get dashboardNextEventStartsIn => 'Prossimo evento tra';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Veicoli attivi/in vendita/in transito';

  @override
  String get dashboardLivePlayerEvents => 'Eventi giocatori dal vivo';

  @override
  String get dashboardOpenEvents => 'Eventi aperti';

  @override
  String get dashboardNotificationsAndRisk => 'Notifiche e rischio';

  @override
  String get dashboardUnreadDm => 'DM non letti';

  @override
  String get dashboardSupportWaitingOnYou => 'Il supporto ti attende';

  @override
  String get dashboardEventsLast24h => 'Eventi ultime 24 ore';

  @override
  String get dashboardRiskScore => 'Punteggio di rischio';

  @override
  String get dashboardRecruitProstitute => 'Recluta una prostituta';

  @override
  String get dashboardWarTheater => 'War theater';

  @override
  String get dashboardHotRegions => 'Hot regions';

  @override
  String get dashboardCrewWars => 'Guerre tra crew';

  @override
  String get dashboardStatusLabel => 'Stato';

  @override
  String get dashboardCanDeclare => 'Può dichiarare guerra';

  @override
  String get dashboardTypeLabel => 'Tipo';

  @override
  String get dashboardOpponent => 'Avversario';

  @override
  String get dashboardCrewPoints => 'Punti crew';

  @override
  String get dashboardWarRank => 'Grado di guerra';

  @override
  String get dashboardSeasonRank => 'Classifica stagionale';

  @override
  String get dashboardOpenTargets => 'Obiettivi aperti';

  @override
  String get dashboardPhaseEndsIn => 'Fine fase tra';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'In prigione ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Preparazione';

  @override
  String get dashboardCrewWarStatusActive => 'In corso';

  @override
  String get dashboardCrewWarStatusLockdown => 'Lockdown';

  @override
  String get dashboardCrewWarStatusResolved => 'Conclusa';

  @override
  String get dashboardCrewWarStatusArchived => 'Archiviata';

  @override
  String get dashboardCrewWarStatusCancelled => 'Annullata';

  @override
  String get dashboardCrewWarStatusNone => 'Nessuna guerra attiva';

  @override
  String get dashboardCrewWarTypeKill => 'Guerra di eliminazione';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerra economica';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerra territoriale';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerra totale';

  @override
  String get dashboardClicks => 'Click';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Offerta speciale';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'non configurato';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'ogni $hours ore',
      one: 'ogni ora',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'ogni $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Territorio crew';

  @override
  String get dashboardRegions => 'Regioni';

  @override
  String get dashboardCountriesCaptured => 'Paesi conquistati';

  @override
  String get dashboardPayout => 'Pagamento';

  @override
  String get dashboardEarningPerHour => 'Guadagni attuali / ora';

  @override
  String get dashboardEarningPerDay => 'Guadagni attuali / giorno';

  @override
  String get dashboardTotalEarned => 'Totale guadagnato';

  @override
  String get dashboardVehicleOps => 'Operazioni veicoli';

  @override
  String get dashboardKillProgress => 'Progresso eliminazioni';

  @override
  String get vehicleOpsHeat => 'Calore';

  @override
  String get vehicleOpsHeatLevelLow => 'Basso';

  @override
  String get vehicleOpsHeatLevelMedium => 'Medio';

  @override
  String get vehicleOpsHeatLevelHigh => 'Alto';

  @override
  String get vehicleOpsReputation => 'Rappresentante';

  @override
  String get vehicleOpsPartsTrendUp => 'mercato dei ricambi in crescita';

  @override
  String get vehicleOpsPartsTrendDown => 'mercato dei ricambi in calo';

  @override
  String get vehicleOpsPartsTrendStable => 'mercato dei ricambi stabile';

  @override
  String get vehicleOpsBlacklistActive => 'Lista nera attiva';

  @override
  String get vehicleOpsNoBlacklist => 'Nessuna lista nera';

  @override
  String get prisonTitle => 'Prigione';

  @override
  String get prisonLoadFailed => 'Impossibile caricare i prigionieri';

  @override
  String get prisonNoPrisonersFound => 'Nessun prigioniero trovato';

  @override
  String prisonRankLine(String rank) {
    return 'Classifica: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Grado: $rank · Tu';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Tempo rimanente: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Cauzione: €$amount';
  }

  @override
  String get prisonPayBailButton => 'Paga la cauzione';

  @override
  String get prisonBuyOutButton => 'Acquistare';

  @override
  String get prisonAttemptEscapeButton => 'Tentativo di fuga';

  @override
  String get prisonJailbreakButton => 'Jailbreak';

  @override
  String get prisonActionFailed => '❌ Azione fallita';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Acquistato $username per €$amount';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Hai pagato la cauzione di €$amount e sei libero';
  }

  @override
  String get prisonEscapeSuccess => '✅ Fuga riuscita! Sei libero.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ Fuga fallita. Frase estesa di $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Cooldown attivo: attendi $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Fuga fallita';

  @override
  String get prisonErrorInsufficientFunds => '❌Non abbastanza soldi';

  @override
  String get prisonErrorTargetNotJailed => '❌ Target non è più in prigione';

  @override
  String get prisonErrorCannotBuyoutSelf => '❌ Non puoi comprarti';

  @override
  String get prisonErrorPlayerNotFound => '❌ Giocatore non trovato';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak riuscito! Il prigioniero è libero.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Jailbreak fallito, sei stato catturato ($minutes min jail).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Il jailbreak non è riuscito. Il prigioniero è ancora rinchiuso.';

  @override
  String get prisonErrorRescuerJailed => '❌ Anche tu sei in prigione';

  @override
  String get prisonJailbreakGenericFailure => '❌ Il jailbreak non è riuscito';

  @override
  String get crewJailbreakTitle => '🚔 Crew in prigione';

  @override
  String get crewJailbreakLoadFailed =>
      'Impossibile caricare i membri incarcerati';

  @override
  String get crewJailbreakEmptyTitle => '🎉 Nessuno in carcere!';

  @override
  String get crewJailbreakEmptyBody => 'Tutti i membri dell\'Crew sono liberi';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Tentativo di jailbreak per $username:';
  }

  @override
  String get crewJailbreakRiskSuccess =>
      'In caso di successo: giocatore liberato!';

  @override
  String get crewJailbreakRiskFailChance =>
      'Se fallisce: 60% di possibilità di essere catturato';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Catturato: 30-60 minuti di prigione + ricercato +10';

  @override
  String get crewJailbreakTip =>
      'Le possibilità di successo aumentano con il grado e il bonus dell\'Crew!';

  @override
  String get crewJailbreakAttemptButton => 'Tentativo di jailbreak';

  @override
  String get crewJailbreakActionFailed => '❌ Azione fallita';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minuti di carcere';
  }

  @override
  String get crewJailbreakRescueButton => 'Salvare';

  @override
  String get crewRoleLeader => 'Leader';

  @override
  String get crewRoleCoLeader => 'Co-leader';

  @override
  String get crewRoleMember => 'Membro';

  @override
  String get vehicleOpsHotspot => 'Punto caldo';

  @override
  String get vehicleOpsCrew => 'Equipaggio';

  @override
  String get vehicleOpsCrewMatch => 'Partita dell\'Crew';

  @override
  String get vehicleOpsChop => 'Taglio';

  @override
  String get vehicleOpsContract => 'Contrarre';

  @override
  String get vehicleOpsCounter => 'Contatrice';

  @override
  String get vehicleOpsContracts => 'Contratti';

  @override
  String get vehicleOpsClaims => 'Affermazioni';

  @override
  String get vehicleOpsSeason => 'Stagione';

  @override
  String get dashboardCar => 'Auto';

  @override
  String get dashboardMotorcycle => 'Motociclo';

  @override
  String get dashboardBoat => 'Barca';

  @override
  String get dashboardCrewAccess => 'Accesso dell\'Crew';

  @override
  String get dashboardCrewRole => 'Ruolo dell\'Crew';

  @override
  String get dashboardUnavailable => 'non disponibile';

  @override
  String get vehicleOps => 'Operazioni sui veicoli';

  @override
  String get car => 'Auto';

  @override
  String get motorcycle => 'Motociclo';

  @override
  String get boat => 'Barca';

  @override
  String get crewAccess => 'Accesso dell\'Crew';

  @override
  String get crewRole => 'Ruolo dell\'Crew';

  @override
  String get unavailable => 'non disponibile';

  @override
  String get quickActionsCrimesSubtitle => 'Commettere atti criminali';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Auto, moto e barca';

  @override
  String get quickActionsTuneShopSubtitle => 'Parti e aggiornamenti';

  @override
  String get quickActionsEventsSubtitle => 'Eventi attivi e futuri';

  @override
  String get quickActionsJobsSubtitle => 'Guadagna denaro legale';

  @override
  String get quickActionsCasinoSubtitle => 'Scommetti i tuoi soldi';

  @override
  String get quickActionsBankSubtitle => 'Gestisci il tuo saldo globale';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Salute';

  @override
  String get rank => 'Rango';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Impostazioni';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => 'Avatar aggiornato!';

  @override
  String get avatarChangeFailed => 'Impossibile cambiare avatar';

  @override
  String get settingsMyPortraits => 'My portraits';

  @override
  String get settingsPortraitFromSelfieTitle => 'Ritratto da selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Trasforma un selfie in un ritratto in stile gangster. $credits crediti ciascuno.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'Questo costa $credits crediti. Continuare?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'Accetto che la mia foto possa essere trasformata in un ritratto stilizzato nel gioco (vedi Termini). Non ho meno di 13 anni.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'Crediti insufficienti (ne servono $need, ne hai $have).';
  }

  @override
  String get settingsPortraitCreated => 'Ritratto aggiunto alla tua libreria!';

  @override
  String get settingsPortraitGenerationFailed =>
      'Impossibile creare il ritratto. Prova un\'altra foto.';

  @override
  String get settingsPortraitSelectActive => 'Utilizzare come avatar';

  @override
  String get settingsPortraitDelete => 'Rimuovi il ritratto';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Limite ritratto raggiunto ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Ritratto personalizzato attivo';

  @override
  String get settingsPresetAvatars => 'Avatar preimpostati';

  @override
  String get settingsPortraitDeleteConfirm =>
      'Rimuovere questo ritratto dalla tua libreria?';

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
      'Scarica questo ritratto come PNG';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Rimuovi questo ritratto dalla tua libreria';

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
    return 'Errore: $error';
  }

  @override
  String get changeLanguage => 'Lingua/Taal';

  @override
  String get languageChanged => 'La lingua è cambiata in inglese';

  @override
  String languageChangeFailed(String code) {
    return 'Cambio lingua non riuscito ($code)';
  }

  @override
  String get chooseLanguage => 'Scegli la lingua / Taal Kiezen';

  @override
  String get dutch => 'Paesi Bassi';

  @override
  String get english => 'Inglese';

  @override
  String get cancel => 'Cancellare';

  @override
  String get changeUsername => 'Cambia nome utente';

  @override
  String get usernameHint => '3-20 caratteri';

  @override
  String get change => 'Modifica';

  @override
  String get minChars => 'Minimo 3 caratteri';

  @override
  String get usernameUpdated => 'Nome utente aggiornato!';

  @override
  String get usernameTaken => 'Nome utente già preso';

  @override
  String get usernameChangeFailed => 'Impossibile modificare il nome utente';

  @override
  String get oncePerMonth => 'Cambiare una volta al mese';

  @override
  String get privacy => 'Privacy';

  @override
  String get allowMessages => 'Consenti messaggi';

  @override
  String get allowMessagesDesc => 'Altri giocatori possono inviarti messaggi';

  @override
  String get settingsSystemNotificationsTitle =>
      'Notifiche di sistema per l\'app';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Autorizzazione: consentita, dispositivo collegato';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Autorizzazione: consentita, il dispositivo si sta ricollegando';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Autorizzazione: provvisoria, collegata al dispositivo';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Autorizzazione: provvisoria, il dispositivo si sta ricollegando';

  @override
  String get settingsPushPermissionDenied => 'Autorizzazione: negata';

  @override
  String get settingsPushPermissionNotRequested =>
      'Autorizzazione: non ancora richiesta';

  @override
  String get settingsPushPermissionUnknown => 'Autorizzazione: sconosciuta';

  @override
  String get settingsDeviceTokenRegistered =>
      'Token del dispositivo registrato sul server';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Nessun token dispositivo ancora registrato';

  @override
  String get settingsPushHelpText =>
      'Utilizza questo pulsante per richiedere nuovamente l\'autorizzazione del browser/iPhone e registrare il tuo token push.';

  @override
  String get working => 'Lavorando...';

  @override
  String get settingsEnablePush => 'Abilita spinta';

  @override
  String get settingsPushEnabledToast =>
      'Notifiche push abilitate. Ora verranno ricevute nuove notifiche.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push è disabilitato nelle impostazioni del tuo browser/iPhone. Abilita le notifiche per questa app.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Impossibile abilitare le notifiche push: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Eventi dei giocatori';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push: eventi dei giocatori dal vivo';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Inizio e fine degli eventi ricorrenti della competizione (ad esempio i round con il punteggio più alto).';

  @override
  String get settingsCryptoNotificationsTitle => 'Notifiche crittografiche';

  @override
  String get settingsCryptoPushTradesTitle => 'Push: scambi';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Notifica push per operazioni di acquisto/vendita';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: avvisi sui prezzi';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Notifica push per movimenti di prezzo rilevanti';

  @override
  String get settingsCryptoPushOrdersTitle => 'Push: ordini';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Notifica push quando l\'ordine viene attivato o eseguito';

  @override
  String get settingsCryptoPushMissionsTitle => 'Spingi: Missioni';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Notifica push quando una missione crittografica viene completata';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Spinta: classifica';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Notifica push per i premi della classifica crittografica';

  @override
  String get settingsCryptoInAppTradesTitle => 'In-app: scambi';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Mostra gli eventi commerciali nel feed degli eventi';

  @override
  String get settingsCryptoInAppPriceAlertsTitle => 'In-app: avvisi sui prezzi';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Mostra gli eventi di avviso di prezzo nel tuo feed eventi';

  @override
  String get settingsCryptoInAppOrdersTitle => 'In-app: Ordini';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Mostra gli eventi dell\'ordine nel tuo feed eventi';

  @override
  String get settingsCryptoInAppMissionsTitle => 'Nell\'app: missioni';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Mostra i completamenti delle missioni nel feed degli eventi';

  @override
  String get settingsCryptoInAppLeaderboardTitle => 'In-app: classifica';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Mostra i premi della classifica nel feed dell\'evento';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Puoi cambiare il tuo avatar solo una volta alla settimana';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Puoi modificare il tuo nome utente solo una volta al mese';

  @override
  String get settingsSaved => 'Impostazioni salvate';

  @override
  String get vipStatus => 'Stato VIP';

  @override
  String activeUntil(String date) {
    return 'Attivo fino alle $date';
  }

  @override
  String get unknown => 'Sconosciuta';

  @override
  String get chooseAvatar => 'Scegli un avatar';

  @override
  String get freeAvatars => 'Avatar gratuiti';

  @override
  String get vipAvatars => 'Avatar VIP';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Non effettuato l\'accesso';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get foodAndDrink => 'Cibo e bevande';

  @override
  String get invalidItem => 'Questo articolo non esiste';

  @override
  String get foodBroodje => 'Sandwich';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'hamburger';

  @override
  String get foodSteak => 'Bistecca';

  @override
  String get drinkWater => 'Acqua';

  @override
  String get drinkSoda => 'Soda';

  @override
  String get drinkCoffee => 'Caffè';

  @override
  String get drinkBeer => 'Birra';

  @override
  String get foodInfo3 =>
      '• Acquista cibo e bevande per mantenere alte le tue statistiche';

  @override
  String get foodHunger => 'Fame';

  @override
  String get foodThirst => 'Sete';

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
      'Fame e sete scendono piano. Mangia e bevi in tempo.';

  @override
  String get friends => 'Amiche';

  @override
  String get friendActivity => 'Attività dell\'amico';

  @override
  String get friendsUiTabActivity => 'Attività';

  @override
  String get friendsUiTabRequests => 'Richieste';

  @override
  String get friendsUiTabSearch => 'Ricerca';

  @override
  String get friendsUiEmptyListTitle => 'Nessun amico ancora';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Cerca giocatori e aggiungili come amici!';

  @override
  String get friendsUiNoRequests => 'Nessuna richiesta';

  @override
  String friendsUiLineRank(String rank) {
    return 'Classifica: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Luogo: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Salute: $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Amici dal: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Rimuovi amico';

  @override
  String get friendsUiRemoveDialogBody =>
      'Sei sicuro di voler rimuovere questo amico?';

  @override
  String get friendsUiRemoveConfirm => 'Rimuovere';

  @override
  String get friendsUiBlockDialogTitle => 'Blocca giocatore';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Sei sicuro di voler bloccare $username? Non sarai in grado di inviare o ricevere messaggi.';
  }

  @override
  String get friendsUiBlockButton => 'Bloccare';

  @override
  String get friendsUiSnackRequestSent => 'Richiesta di amicizia inviata';

  @override
  String get friendsUiSnackRequestAccepted => 'Richiesta di amicizia accettata';

  @override
  String get friendsUiSnackRequestRejected => 'Richiesta di amicizia respinta';

  @override
  String get friendsUiSnackFriendRemoved => 'Amico rimosso';

  @override
  String get friendsUiSnackPlayerBlocked => 'Giocatore bloccato';

  @override
  String friendsUiSnackError(String details) {
    return 'Errore: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Cerca giocatore';

  @override
  String get friendsUiSearchHint => 'Digita almeno 2 caratteri';

  @override
  String get friendsUiSearchMinChars =>
      'Digita almeno 2 caratteri per la ricerca';

  @override
  String get friendsUiNoPlayersFound => 'Nessun giocatore trovato';

  @override
  String get friendsUiMenuBlock => 'Bloccare';

  @override
  String get friendsUiMenuRemove => 'Rimuovere';

  @override
  String get friendsUiChipFriend => 'Amica';

  @override
  String get friendsUiChipPending => 'In attesa di';

  @override
  String get friendsUiAccept => 'Accettare';

  @override
  String get friendsUiReject => 'Rifiutare';

  @override
  String get friendsUiActivityEmpty => 'Nessuna attività degli amici ancora';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Livello $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Equipaggi';

  @override
  String get crewUiTabMyCrew => 'Panoramica';

  @override
  String get crewUiTabCrewHq => 'Quartier generale e potenziamenti';

  @override
  String get crewUiTabStorageHub => 'Magazzinaggio';

  @override
  String get crewUiTabMembers => 'Membri';

  @override
  String get crewUiTabWarRoom => 'Sala della Guerra';

  @override
  String get crewUiTabCrewMissions => 'Missioni dell\'Crew';

  @override
  String get crewUiTabCarStorage => 'Deposito auto/moto';

  @override
  String get crewUiTabBoatStorage => 'Rimessaggio barche';

  @override
  String get crewUiTabWeaponStorage => 'Deposito armi';

  @override
  String get crewUiTabAmmoStorage => 'Deposito di munizioni';

  @override
  String get crewUiTabDrugStorage => 'Conservazione dei farmaci';

  @override
  String get crewUiTabCashStorage => 'Deposito contanti';

  @override
  String get crewUiTabAllCrews => 'Equipaggi';

  @override
  String get crewUiTabChat => 'Chiacchierata';

  @override
  String get crewUiActionCreateCrewShort => 'Crea Crew (€50k)';

  @override
  String get crewUiStateNotInCrewYet => 'Non fai ancora parte di un Crew';

  @override
  String get crewUiActionCreateCrew => 'Crea Crew (€50.000)';

  @override
  String get crewUiLabelCrewBank => 'Banca dell\'Crew:';

  @override
  String get crewUiLabelDeposit => 'Depositare';

  @override
  String get crewUiLabelWithdraw => 'Ritirare';

  @override
  String get crewUiLabelMyTrustScore => 'Il mio punteggio di fiducia:';

  @override
  String get crewUiActionDeleteCrew => 'Elimina l\'Crew';

  @override
  String get crewUiLabelCrewStats => 'Statistiche dell\'Crew:';

  @override
  String get crewUiActionLeaveCrew => 'Lascia l\'Crew';

  @override
  String get crewUiSectionBuildings => 'Quartier generale e potenziamenti';

  @override
  String get crewUiHintBuildingsTabs =>
      'Apri quartier generale e potenziamenti per gestire il quartier generale e tutti gli edifici dell\'Crew da un unico posto.';

  @override
  String get crewUiSectionCrewStorage => 'Deposito Crew';

  @override
  String get crewUiStateNoStorageData =>
      'Nessun dato di archiviazione caricato';

  @override
  String get crewUiActionAddCar => 'Aggiungi auto/moto';

  @override
  String get crewUiActionAddBoat => 'Aggiungi barca';

  @override
  String get crewUiActionAddWeapon => 'Aggiungi arma';

  @override
  String get crewUiActionAddAmmo => 'Aggiungi munizioni';

  @override
  String get crewUiActionAddDrugs => 'Aggiungi farmaci';

  @override
  String get crewUiSectionMembersOverview => 'Panoramica dei membri';

  @override
  String get crewUiHintMembersTab =>
      'Apri la scheda Membri in alto per l\'elenco dei membri e le richieste di partecipazione.';

  @override
  String get crewUiActionGoToMembers => 'Vai a Membri';

  @override
  String get crewUiLabelCrewHq => 'Quartier generale dell\'Crew';

  @override
  String get crewUiActionGoToCrewHq => 'Vai al quartier generale dell\'Crew';

  @override
  String get crewUiActionGoToStorage => 'Vai a Archiviazione';

  @override
  String get crewUiStateJoinCrewFirst => 'Crea o unisciti prima a un Crew';

  @override
  String get crewUiStateJoinRequests => 'Partecipa alle richieste';

  @override
  String get crewUiStateNoJoinRequests => 'Nessuna richiesta in sospeso';

  @override
  String get crewUiStateNoCrewsFound => 'Nessun Crew trovato';

  @override
  String get crewUiLabelMemberCount => 'Membri';

  @override
  String get crewUiBadgeMyCrew => 'Il mio Crew';

  @override
  String get crewUiActionJoin => 'Giuntura';

  @override
  String get crewUiStateNotInCrew => 'Non fai parte di un Crew';

  @override
  String get crewUiHintChatJoinCrew =>
      'Crea o unisciti a una squadra per chattare!';

  @override
  String get crewUiStatusNotOwned => 'Non di proprietà';

  @override
  String get crewUiLabelLevel => 'Livello';

  @override
  String get crewUiLabelCapacity => 'Capacità';

  @override
  String get crewUiLabelMemberCap => 'Limite membri';

  @override
  String get crewUiLabelParking => 'Parcheggio';

  @override
  String get crewUiActionPurchase => 'Acquistare';

  @override
  String get crewUiActionUpgrade => 'Aggiornamento';

  @override
  String get crewUiActionDetails => 'Dettagli';

  @override
  String get crewUiHelpCapsTitle => 'Panoramica del livello';

  @override
  String get crewUiHelpLevel => 'Livello';

  @override
  String get crewUiHelpCapacity => 'Cap';

  @override
  String get crewUiHelpUpgradeCost => 'Costo';

  @override
  String get crewUiHelpClose => 'Vicina';

  @override
  String get crewUiHelpShowCaps => 'Mostra maiuscole';

  @override
  String get crewUiSectionUpgradeHub => 'Quartier generale e potenziamenti';

  @override
  String get crewUiSectionStorageHub => 'Hub di archiviazione';

  @override
  String get crewUiHintStorageTab =>
      'Utilizza la scheda Archiviazione per depositi, saldi e azioni di archiviazione rapide.';

  @override
  String get crewUiHintUpgradeHub =>
      'Gestisci il quartier generale e tutti i potenziamenti dell\'Crew da un unico posto qui.';

  @override
  String get crewUiSectionCrewMissions => 'Missioni dell\'Crew';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Nessuna missione dell\'Crew ancora disponibile';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Unisciti o crea un Crew per iniziare le missioni.';

  @override
  String get crewUiActionStartMission => 'Inizia missione';

  @override
  String get crewUiActionConfigureAndStartMission => 'Configura e avvia';

  @override
  String get crewUiActionResolveMission => 'Risolvere la missione';

  @override
  String get crewUiActionClaimRewards => 'Richiedi premi';

  @override
  String get crewUiActionSpeedupCooldown => 'Accelera il raffreddamento';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Conferma l\'accelerazione';

  @override
  String get crewUiLabelActiveMission => 'Missione attiva';

  @override
  String get crewUiLabelRecentMissions => 'Missioni recenti';

  @override
  String get crewUiLabelMissionDuration => 'Durata';

  @override
  String get crewUiLabelMissionCooldown => 'Raffreddare';

  @override
  String get crewUiLabelMissionTier => 'Livello';

  @override
  String get crewUiLabelMissionRewards => 'Premi';

  @override
  String get crewUiLabelMissionTradeCargo =>
      'Carico commerciale (magazzino crew)';

  @override
  String get crewUiHintMissionTradeCargo =>
      'Deposita le merci elencate nel magazzino crew prima di iniziare.';

  @override
  String get crewUiErrorMissionTradeRequirementsNotMet =>
      'Merci insufficienti nel magazzino crew per questa missione.';

  @override
  String get crewUiLabelCrewMissionProgress =>
      'Progressione della missione dell\'Crew';

  @override
  String get crewUiLabelCrewMissionXp => 'XP missione Crew';

  @override
  String get crewUiLabelCrewMissionLevelBonus =>
      'Bonus in contanti per l\'Crew';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus =>
      'Bonus di livello successivo';

  @override
  String get crewUiLabelMissionStatus => 'Stato';

  @override
  String get crewUiLabelCooldownActive => 'Recupero attivo';

  @override
  String get crewUiLabelRoleContributions => 'Contributi di ruolo';

  @override
  String get crewUiLabelContribution => 'contributo';

  @override
  String get crewUiLabelMultiplier => 'moltiplicatore';

  @override
  String get crewUiStatusMissionLocked => 'Bloccato';

  @override
  String get crewUiStatusInProgress => 'In corso';

  @override
  String get crewUiStatusCompleted => 'Completato';

  @override
  String get crewUiStatusReady => 'Pronta';

  @override
  String get crewUiStatusRewardsClaimed => 'Premi rivendicati';

  @override
  String get crewUiStateMissionActionBusy =>
      'L\'azione è in fase di elaborazione...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Solo il leader/co-leader può avviare e risolvere le missioni.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Assegnare ruoli';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Scegli un ruolo di missione per membro dell\'Crew.';

  @override
  String get crewUiLabelRoleNone => 'Non assegnato';

  @override
  String get crewUiLabelRolePlanner => 'Pianificatrice';

  @override
  String get crewUiLabelRoleEnforcer => 'Tutrice';

  @override
  String get crewUiLabelRoleLogistics => 'Logistica';

  @override
  String get crewUiLabelRoleTech => 'Tecnologia';

  @override
  String get crewUiHintRoleBonus =>
      'Ogni ruolo unico: +3% probabilità di successo, -2% durata (massimo +12% / -8%).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'Nessun membro dell\'Crew trovato.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Seleziona almeno 1 ruolo.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'Il livello 2 richiede membri HQ 5+ e 2+.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'Il livello 3 richiede membri HQ 9+ e 3+.';

  @override
  String get crewUiHintMissionLockedDefault => 'La missione è ancora bloccata.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Impossibile caricare le missioni dell\'Crew.';

  @override
  String get crewUiMessageMissionStarted => 'La missione è iniziata';

  @override
  String get crewUiMessageMissionResolved => 'Missione risolta';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Premi rivendicati';

  @override
  String get crewUiMessageMissionCooldownSpedUp =>
      'Il tempo di recupero è stato accelerato';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Impossibile caricare il prezzo di accelerazione.';

  @override
  String get crewUiDialogSpeedupTitle => 'Accelerare il raffreddamento?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'La finitura istantanea costa $credits crediti ($minutes min rimanenti).';
  }

  @override
  String get crewUiLabelCredits => 'crediti';

  @override
  String get crewUiStateLoadingPrice => 'Caricamento prezzo...';

  @override
  String get crewUiActionCancel => 'Cancellare';

  @override
  String get crewUiHintMissionUnlockCta =>
      'Le missioni di livello alto si aprono quando HQ e crew crescono. Potenzia l’HQ o recluta per il Tier 2+.';

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
    return 'Migliora prima tutti gli edifici laterali almeno al livello $level. \n\nMancante: \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 minuto';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get crewUiMissionNoHistory => 'Nessuna storia ancora.';

  @override
  String get crewUiBuildingHq => 'Quartier generale dell\'Crew';

  @override
  String get crewUiBuildingCarStorage => 'Deposito auto/moto';

  @override
  String get crewUiBuildingBoatStorage => 'Rimessaggio barche';

  @override
  String get crewUiBuildingWeaponStorage => 'Deposito armi';

  @override
  String get crewUiBuildingAmmoStorage => 'Deposito di munizioni';

  @override
  String get crewUiBuildingDrugStorage => 'Conservazione dei farmaci';

  @override
  String get crewUiBuildingCashStorage => 'Deposito contanti';

  @override
  String get crewUiWarActionKill => 'Uccisione';

  @override
  String get crewUiWarActionMug => 'Tazza';

  @override
  String get crewUiWarActionSabotage => 'Sabotaggio';

  @override
  String get crewUiWarActionIntel => 'Intel';

  @override
  String get crewUiWarActionRaid => 'Incursione';

  @override
  String get crewUiWarActionShield => 'Scudo';

  @override
  String get crewUiWarActionBoost => 'Aumento';

  @override
  String get crewUiWarActionTerritory => 'Territorio';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count membri)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Errore durante il caricamento dei messaggi: $error';
  }

  @override
  String get crewChatMessageTooLong =>
      'Messaggio troppo lungo (max 500 caratteri)';

  @override
  String crewChatErrorSending(String error) {
    return 'Errore nell\'invio del messaggio: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Impossibile eliminare il messaggio: $error';
  }

  @override
  String get crewChatDeleteTitle => 'Eliminare il messaggio?';

  @override
  String get crewChatDeleteBody =>
      'Questo messaggio verrà eliminato definitivamente.';

  @override
  String get crewChatCancel => 'Cancellare';

  @override
  String get crewChatDelete => 'Eliminare';

  @override
  String get crewChatNoMessages => 'Nessun messaggio ancora';

  @override
  String get crewChatEmptyHint => 'Invia il primo messaggio al tuo Crew!';

  @override
  String get aviationUiBuyConfirmTitle => 'Acquistare aerei?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Vuoi acquistare $name per $price?';
  }

  @override
  String get aviationUiPurchaseFailed => 'Acquisto fallito.';

  @override
  String get aviationUiPurchasedSuccess => 'Aereo acquistato.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'Licenza attiva ($type). Upgrade per aerei più pesanti, se necessario. È richiesta anche una formazione pilota completa (Aviation 5 + certificati).';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'School Aviation 5/5 da sola non basta: acquista qui una licenza di aviazione a pagamento prima di poter acquistare l\'aereo.';

  @override
  String get aviationUiLicensesTitle => 'Licenze aeronautiche';

  @override
  String get aviationUiLicenseBasic => 'Base (leggero/turboelica)';

  @override
  String get aviationUiLicenseCommercial =>
      'Commerciale (jet d\'affari/di lusso)';

  @override
  String get aviationUiLicenseCargo =>
      'Cargo (carico e navi da carico pesanti)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Grado minimo $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Acquista la licenza';

  @override
  String get aviationUiUpgradeLicense => 'Licenza di aggiornamento';

  @override
  String get aviationUiLicenseBuyConfirmTitle =>
      'Acquistare la licenza aeronautica?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return 'Acquistare $name per $price? Richiede una scuola di aviazione completata (livello 5 + certificazioni).';
  }

  @override
  String get aviationUiLicensePurchaseFailed =>
      'Acquisto della licenza non riuscito.';

  @override
  String get aviationUiLicensePurchasedSuccess =>
      'Acquistata licenza aeronautica.';

  @override
  String get aviationUiYourAircraft => 'Il tuo aereo';

  @override
  String get aviationUiNoOwnedAircraft => 'Non possiedi ancora alcun aereo.';

  @override
  String get aviationUiAvailableAircraft => 'Aerei disponibili';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Carburante: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Prezzo: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Grado minimo: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Velocità x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Carico: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Aereo';

  @override
  String aviationUiLoadError(String error) {
    return 'Impossibile caricare i dati sull\'aviazione: $error';
  }

  @override
  String get crewUiTr0 => 'Requisiti di aggiornamento del quartier generale';

  @override
  String get crewUiTr1 =>
      'Aggiorna il tuo attuale stile HQ al livello massimo per sbloccare lo stile successivo';

  @override
  String get crewUiTr2 => 'Raggiunto lo stile HQ finale';

  @override
  String get crewUiTr3 =>
      'Quartier generale VIP richiesto per il livello 11-15';

  @override
  String get crewUiTr4 =>
      'Migliora prima tutti gli edifici laterali al livello richiesto per questo stile HQ';

  @override
  String get crewUiTr5 => 'Immobile già di proprietà';

  @override
  String get crewUiTr6 => 'Fondi bancari dell\'Crew insufficienti';

  @override
  String get crewUiTr7 =>
      'La progressione del QG è troppo bassa per questo aggiornamento';

  @override
  String get crewUiTr8 => 'VIP dell\'Crew richiesto per il livello 11+';

  @override
  String get crewUiTr9 =>
      'Deposito iniziale raggiunto. Acquista prima il deposito contanti per sbloccare più spazio nella banca dell\'Crew.';

  @override
  String get crewUiTr10 => 'Azione fallita';

  @override
  String get crewUiTr11 => 'C\'è già una missione dell\'Crew attiva.';

  @override
  String get crewUiTr12 =>
      'Il tempo di recupero della missione è ancora attivo. Aspetta che finisca o acceleralo con i crediti.';

  @override
  String get crewUiTr13 => 'Missione non trovata.';

  @override
  String get crewUiTr14 => 'Questo livello è ancora bloccato.';

  @override
  String get crewUiTr15 => 'Esecuzione della missione non trovata.';

  @override
  String get crewUiTr16 => 'La missione è già risolta.';

  @override
  String get crewUiTr17 => 'La missione non è ancora completata.';

  @override
  String get crewUiTr18 => 'Nessun tempo di recupero attivo.';

  @override
  String get crewUiTr19 => 'Crediti insufficienti.';

  @override
  String get crewUiTr20 => 'Impossibile avviare la missione.';

  @override
  String get crewUiTr21 => 'Impossibile risolvere la missione.';

  @override
  String get crewUiTr22 => 'Impossibile richiedere i premi.';

  @override
  String get crewUiTr23 => 'Impossibile accelerare il tempo di recupero.';

  @override
  String get crewUiTr24 => 'Non fai parte di un Crew.';

  @override
  String get crewUiTr25 => 'Solo il capo dell\'Crew può farlo.';

  @override
  String get crewUiTr26 => 'Crew bersaglio non trovato.';

  @override
  String get crewUiTr27 => 'Questa squadra è già in guerra.';

  @override
  String get crewUiTr28 => 'Sono necessari almeno 3 membri dell\'Crew.';

  @override
  String get crewUiTr29 => 'Guerra non trovata.';

  @override
  String get crewUiTr30 => 'Questa guerra non è attiva.';

  @override
  String get crewUiTr31 => 'Non puoi unirti a questa guerra adesso.';

  @override
  String get crewUiTr32 => 'Questa azione richiede un giocatore bersaglio.';

  @override
  String get crewUiTr33 => 'Blocco anti-farm: scegli un altro bersaglio.';

  @override
  String get crewUiTr34 => 'Per questa azione è richiesto un giocatore VIP.';

  @override
  String get crewUiTr35 => 'Per questa azione è necessaria una squadra VIP.';

  @override
  String get crewUiTr36 => 'Limite di azione raggiunto per ora.';

  @override
  String crewUiTr37(String remaining) {
    return 'Cooldown attivo: attendi altri $remaining minuti.';
  }

  @override
  String get crewUiTr38 => 'Territorio selezionato non valido.';

  @override
  String get crewUiTr39 => 'L\'azione di guerra dell\'Crew fallì.';

  @override
  String get crewUiTr40 => 'Giocatore bersaglio';

  @override
  String get crewUiTr41 => 'Uccide';

  @override
  String get crewUiTr42 => 'Morta';

  @override
  String get crewUiTr43 => 'Cancellare';

  @override
  String get crewUiTr44 => 'Confermare';

  @override
  String get crewUiTr45 => 'Leader';

  @override
  String get crewUiTr46 => 'Co-leader';

  @override
  String get crewUiTr47 => 'Membro';

  @override
  String get crewUiTr48 => 'Capitale';

  @override
  String get crewUiTr49 => 'Porto';

  @override
  String get crewUiTr50 => 'Industria';

  @override
  String get crewUiTr51 => 'Confine';

  @override
  String get crewUiTr52 => 'Logistica';

  @override
  String get crewUiTr53 => 'Reclamo';

  @override
  String get crewUiTr54 => 'Tic tac';

  @override
  String get crewUiTr55 => 'Seleziona territorio';

  @override
  String get crewUiTr56 => 'Seleziona prima un Crew target.';

  @override
  String get crewUiTr57 => 'Dichiarata guerra all\'Crew.';

  @override
  String get crewUiTr58 => 'Impossibile dichiarare guerra all\'Crew.';

  @override
  String get crewUiTr59 => 'Ti sei unito alla guerra.';

  @override
  String get crewUiTr60 => 'Impossibile unirsi alla guerra.';

  @override
  String get crewUiTr61 => 'Azione di guerra tra equipaggi completata.';

  @override
  String get crewUiTr62 => 'Uccidi la guerra';

  @override
  String get crewUiTr63 => 'Guerra economica';

  @override
  String get crewUiTr64 => 'Guerra del territorio';

  @override
  String get crewUiTr65 => 'Guerra totale';

  @override
  String get crewUiTr66 => 'Preparazione';

  @override
  String get crewUiTr67 => 'Attiva';

  @override
  String get crewUiTr68 => 'Confinamento';

  @override
  String get crewUiTr69 => 'Risolta';

  @override
  String get crewUiTr70 => 'Archiviata';

  @override
  String get crewUiTr71 => 'Annullata';

  @override
  String get crewUiTr72 => 'Crew VIP';

  @override
  String get crewUiTr73 => '€ 9,99/mese';

  @override
  String get crewUiTr74 => '€ 4,99/mese';

  @override
  String get crewUiTr75 => 'Acquisti una tantum';

  @override
  String get crewUiTr76 => 'Solo il leader può acquistare l\'Crew VIP';

  @override
  String get crewUiTr77 => 'Prodotto non valido';

  @override
  String get crewUiTr78 =>
      'Errore durante l\'apertura della pagina di pagamento';

  @override
  String get crewUiTr79 => 'Sei sicuro?';

  @override
  String get crewUiTr80 => 'Lascia l\'Crew';

  @override
  String get crewUiTr81 => 'Sei sicuro di voler lasciare l\'Crew?';

  @override
  String get crewUiTr82 => 'Partire';

  @override
  String get crewUiTr83 => 'Crew sinistro';

  @override
  String get crewUiTr84 => 'Deposito alla banca dell\'Crew';

  @override
  String get crewUiTr85 => 'Prelevare dalla banca dell\'Crew';

  @override
  String get crewUiTr86 => 'Quantità';

  @override
  String get crewUiTr87 => 'Importo non valido';

  @override
  String get crewUiTr88 => 'Non abbastanza contanti a portata di mano';

  @override
  String get crewUiTr89 =>
      'Acquista prima il deposito di contanti per la banca dell\'Crew';

  @override
  String get crewUiTr90 => 'Il deposito contanti dell\'Crew è pieno';

  @override
  String get crewUiTr91 => 'Elimina l\'Crew';

  @override
  String get crewUiTr92 =>
      'Sei sicuro di voler eliminare questo Crew? Questa operazione non può essere annullata.';

  @override
  String get crewUiTr93 => 'Eliminare';

  @override
  String get crewUiTr94 => 'Livello successivo';

  @override
  String get crewUiTr95 => 'Costo';

  @override
  String get crewUiTr96 => 'Livello massimo raggiunto';

  @override
  String get crewUiTr97 => 'Immobile non di proprietà';

  @override
  String get crewUiTr98 => 'Aggiungi auto/moto';

  @override
  String get crewUiTr99 => 'Aggiungi barca';

  @override
  String get crewUiTr100 => 'Motociclo';

  @override
  String get crewUiTr101 => 'Barca';

  @override
  String get crewUiTr102 => 'Auto';

  @override
  String get crewUiTr103 => 'Selezionare';

  @override
  String get crewUiTr104 => 'Aggiungere';

  @override
  String get crewUiTr105 => 'Aggiungi arma';

  @override
  String get crewUiTr106 => 'Arma';

  @override
  String get crewUiTr107 => 'Quantità';

  @override
  String get crewUiTr108 => 'Aggiungi munizioni';

  @override
  String get crewUiTr109 => 'Tipo di munizioni';

  @override
  String get crewUiTr110 => 'Aggiungi merce';

  @override
  String get crewUiTr111 => 'Tipo di merce';

  @override
  String get crewUiTr112 =>
      'Unisciti prima a una squadra per utilizzare Crew Wars.';

  @override
  String get crewUiTr113 =>
      'Nessun membro dell\'Crew avversario può essere preso di mira.';

  @override
  String get crewUiTr114 => 'Seleziona il giocatore di destinazione';

  @override
  String get crewUiTr115 => 'Panoramica della stagione';

  @override
  String get crewUiTr116 => 'Stagione attiva';

  @override
  String get crewUiTr117 => 'Il mio ruolo';

  @override
  String get crewUiTr118 => 'L\'Crew può dichiarare';

  @override
  String get crewUiTr119 => 'SÌ';

  @override
  String get crewUiTr120 => 'NO';

  @override
  String get crewUiTr121 => 'Dichiarare nuova guerra';

  @override
  String get crewUiTr122 => 'Squadra bersaglio';

  @override
  String get crewUiTr123 => 'Tipo di guerra';

  @override
  String get crewUiTr124 => 'Dichiarare guerra';

  @override
  String get crewUiTr125 => 'Territori di guerra';

  @override
  String get crewUiTr126 => 'Neutra';

  @override
  String get crewUiTr127 => 'Crew avversario';

  @override
  String get crewUiTr128 => 'Attivo da';

  @override
  String get crewUiTr129 => 'Unisciti alla guerra';

  @override
  String get crewUiTr130 => 'Classifiche';

  @override
  String get crewUiTr131 => 'Territori';

  @override
  String get crewUiTr132 => 'Azioni recenti';

  @override
  String get crewUiTr133 => 'Nessuna azione di guerra ancora.';

  @override
  String get crewUiTr134 => 'contro';

  @override
  String get crewUiTr135 => 'Classifica della stagione';

  @override
  String get crewUiTr136 => 'Nessun punto stagionale ancora.';

  @override
  String get crewUiTr137 => 'Bottino';

  @override
  String get crewUiTr138 => 'Guerre recenti';

  @override
  String get crewUiTr139 => 'Nessuna guerra recente ancora.';

  @override
  String get crewUiTr140 => 'Solo il leader può acquistare o aggiornare';

  @override
  String get crewUiTr141 =>
      'Aggiornamento HQ bloccato: edifici laterali prima a L\$requiredSideLevel';

  @override
  String get crewUiTr142 =>
      'Il prossimo aggiornamento non è ancora disponibile';

  @override
  String get crewUiTr143 => 'Progressione HQ troppo bassa';

  @override
  String get crewUiTr144 =>
      'Livello HQ troppo basso per il prossimo aggiornamento';

  @override
  String get premiumUiLoadError => 'Impossibile caricare i dati premium.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Acquisto ricevuto. Aggiornamento dei tuoi crediti e panoramica dei premi.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Pagamento VIP dell\'Crew ricevuto. Aggiornamento della panoramica premium.';

  @override
  String get premiumUiRedirectPaidVip =>
      'Pagamento VIP ricevuto. Aggiornamento della panoramica premium.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Acquisto annullato.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Pagamento annullato.';

  @override
  String get premiumUiRedirectFailedOneTime =>
      'Acquisto non riuscito o scaduto.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'Pagamento non riuscito o scaduto.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'Impossibile aprire la pagina di pagamento.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Questo oggetto richiede la selezione del veicolo e verrà riscattato dalla schermata del veicolo.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Crediti riscattati.';

  @override
  String get premiumUiRedeemFailed => 'Impossibile riscattare i crediti.';

  @override
  String get premiumUiPerMonthShort => 'mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Aumento di cassa';

  @override
  String get premiumUiCreditThemeSecurity => 'Sicurezza';

  @override
  String get premiumUiCreditThemeGarage => 'Garage';

  @override
  String get premiumUiCreditThemeTuneShop => 'Negozio di sintonizzazione';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Tempo di recupero: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset =>
      'Ripristino del tempo di recupero';

  @override
  String get premiumUiCreditThemeEvents => 'Eventi';

  @override
  String get premiumUiCreditThemePremium => 'Premio';

  @override
  String get premiumUiKpiPlayerVip => 'Giocatore VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew VIP';

  @override
  String get premiumUiCreditsLabel => 'Crediti';

  @override
  String get premiumUiStatusActive => 'Attiva';

  @override
  String get premiumUiStatusInactive => 'Inattiva';

  @override
  String get premiumUiNoCrew => 'Nessun Crew';

  @override
  String get premiumUiSectionVipTitle => 'Abbonamenti VIP';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Piastre VIP professionali con prezzi, status e vantaggi chiari.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Vantaggi esclusivi dell\'account, sblocco di avatar e QoL premium.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Attivo fino alle $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP';

  @override
  String get premiumUiExtendVip => 'Estendi VIP';

  @override
  String get premiumUiBuyVip => 'Acquista VIP';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'Vantaggi VIP per i giocatori';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Vantaggi del giocatore VIP: \n- Timeout/cooldown delle azioni più brevi del 10% (il tempo di prigionia rimane invariato). \n- Nella produzione di farmaci, ottieni un pulsante lampo VIP su ogni carta di produzione per acquistare i materiali mancanti con un clic (dopo la conferma del costo). \n- Alla morte, perdi denaro in disponibilità ma ricominci con 500.000 euro in contanti. \n- Il tuo grado viene dimezzato anziché ripristinato completamente. \n- I progressi educativi e i risultati sbloccati vengono preservati. \n- Il saldo bancario e le criptovalute vengono preservati. \n- Le proprietà, i veicoli, le prostitute, l\'inventario trasportato e gli oggetti immagazzinati vengono rimossi. \n- Il progresso dei farmaci e le scorte dei farmaci vengono ripristinati. \n- Ricevi 100 crediti premium settimanalmente mentre VIP è attivo.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Devi far parte di una crew prima di poter attivare Crew VIP.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Per potenziamenti dell\'Crew, edifici secondari di livello 11-15 e vantaggi condivisi.';

  @override
  String get premiumUiBadgeCrewNeeded => 'C\'è bisogno di Crew';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Crew richiesto';

  @override
  String get premiumUiExtendCrewVip => 'Estendi l\'Crew VIP';

  @override
  String get premiumUiBuyCrewVip => 'Acquista Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Vantaggi VIP per l\'Crew';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Devi unirti a una crew prima di acquistare Crew VIP. Crew VIP sblocca vantaggi specifici per l\'Crew e una maggiore progressione degli aggiornamenti.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew VIP garantisce l\'accesso a miglioramenti extra dell\'Crew e vantaggi premium condivisi per il flusso del tuo Crew. Dopo l\'acquisto, lo stato attivo e la scadenza vengono aggiornati immediatamente.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Acquista crediti';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Scegli un pacchetto tramite riquadri visivi. La popolare opzione da 1000 crediti ottiene i riflettori.';

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
      'Non ci sono pacchetti di crediti attivi al momento.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Pacchetto di crediti';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Crediti istantanei per il tuo portafoglio premium.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Acquista $amount crediti';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count crediti';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Affare ultra';

  @override
  String get premiumUiBadgeTopDeal => 'Ottimo affare';

  @override
  String get premiumUiBadgeCredits => 'Crediti';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine per $price. \n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'Negozio di credito';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Ogni oggetto utilizza una tessera a tema in base all\'effetto che stai acquistando.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Articolo premium';

  @override
  String get premiumUiShopItemFallbackDescription =>
      'Vantaggio premio diretto.';

  @override
  String get premiumUiShopNoActiveCooldown => 'Nessun tempo di recupero attivo';

  @override
  String get premiumUiShopNotEnoughCredits => 'Crediti insufficienti';

  @override
  String get premiumUiShopRedeem => 'Riscattare';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nTema: $theme \nCosto: $cost crediti';
  }

  @override
  String get premiumUiBadgeShop => 'Negozio';

  @override
  String get premiumUiActiveEffectsTitle => 'Effetti premium attivi';

  @override
  String get premiumUiIntroSubtitle =>
      'Qui i giocatori gestiscono gli abbonamenti VIP, i pacchetti di crediti e gli articoli del negozio di crediti.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

  @override
  String get propertiesAvailable => 'Disponibile';

  @override
  String get myProperties => 'Le mie proprietà';

  @override
  String get errorLoadingMyProperties =>
      'Errore durante il caricamento delle mie proprietà';

  @override
  String get errorBuyingProperty => 'Errore nell\'acquisto dell\'immobile';

  @override
  String get errorCollectingIncome => 'Errore nella riscossione dei proventi';

  @override
  String get noAvailableProperties => 'Nessuna proprietà disponibile';

  @override
  String get noOwnedProperties => 'Non possiedi ancora alcuna proprietà';

  @override
  String get buyFirstPropertyHint =>
      'Acquista il tuo primo immobile nella scheda \"Disponibili\".';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Vuoi acquistare $name per €$price?';
  }

  @override
  String get propertyPrice => 'Prezzo';

  @override
  String get propertyMinLevel => 'Livello richiesto';

  @override
  String get propertyIncomePerHour => 'Reddito/ora';

  @override
  String get propertyMaxLevel => 'Livello massimo';

  @override
  String get propertyUniquePerCountry => '⚠️ Unico - 1 per paese';

  @override
  String get propertyIncomeReady => '✅ Reddito pronto da riscuotere!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Prossimo reddito tra $duration';
  }

  @override
  String get propertyBuyAction => 'Acquista proprietà';

  @override
  String get propertyCollectAction => 'Raccogliere';

  @override
  String get propertyUpgradeAction => 'Aggiornamento';

  @override
  String get propertyMax => 'MASSIMO';

  @override
  String propertyLevel(String level) {
    return 'Livello $level';
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
  String get propertyTypeHouse => 'Casa';

  @override
  String get propertyTypeWarehouse => 'Magazzino';

  @override
  String get propertyTypeCasino => 'Casinò';

  @override
  String get propertyTypeHotel => 'Albergo';

  @override
  String get propertyTypeFactory => 'Fabbrica';

  @override
  String get propertyTypeBusiness => 'Attività commerciale';

  @override
  String get propertyCasinoName => 'Casinò';

  @override
  String get propertyWarehouseName => 'Magazzino';

  @override
  String get propertyNightclubName => 'Discoteca';

  @override
  String get propertyHouseName => 'Casa';

  @override
  String get propertyApartmentName => 'Appartamento';

  @override
  String get propertyShopName => 'Negozio';

  @override
  String get propertiesConfirmPurchaseTitle => 'Sei sicuro?';

  @override
  String get propertyTypeApartment => 'Appartamento';

  @override
  String get propertyTypeNightclub => 'Discoteca';

  @override
  String get propertyTypeShop => 'Negozio';

  @override
  String get propertyStatStorageLabel => '📦 Deposito';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to slot';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Capacità abitativa';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to lavoratori';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount slot';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current lavoratori (max $max al livello $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current lavoratori • max';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count slot extra';
  }

  @override
  String get propertyManageNightclub => 'Gestisci la discoteca';

  @override
  String get blackMarket => 'Mercato nero';

  @override
  String get garage => 'Garage';

  @override
  String get garageCapacity => 'Capacità del garage';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total veicoli';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Livello massimo';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Livello $level | $spots posti rimasti';
  }

  @override
  String get noCarsInGarage => 'Niente auto nel tuo garage';

  @override
  String get stealCarsToStart => 'Ruba alcune auto per iniziare!';

  @override
  String get stealFailed => 'Ruba fallita';

  @override
  String get garageUpgradeFailed => 'Impossibile aggiornare il garage';

  @override
  String get saleFailed => 'Vendita fallita';

  @override
  String get vehicleTransported => 'Veicolo trasportato con successo!';

  @override
  String get vehicleTransportFailed => 'Impossibile trasportare il veicolo';

  @override
  String get listOnMarket => 'Elenco sul mercato';

  @override
  String marketValue(String amount) {
    return 'Valore di mercato: €$amount';
  }

  @override
  String get askingPrice => 'Prezzo richiesto (€)';

  @override
  String get enterPrice => 'Inserisci il prezzo';

  @override
  String get list => 'Lista';

  @override
  String get invalidPrice => 'Prezzo non valido';

  @override
  String get vehicleListed => 'Veicolo quotato sul mercato!';

  @override
  String get listVehicleFailed => 'Impossibile elencare il veicolo';

  @override
  String get marina => 'Marina';

  @override
  String get hospital => 'Ospedale';

  @override
  String get court => 'Tribunale';

  @override
  String get casino => 'Casinò';

  @override
  String get errorLoadingCasinoStatus =>
      'Impossibile verificare lo stato del casinò';

  @override
  String get errorLoadingCasinoGames =>
      'Impossibile caricare i giochi del casinò';

  @override
  String casinoPrice(String amount) {
    return 'Prezzo: €$amount';
  }

  @override
  String get startingCapital => 'Capitale iniziale';

  @override
  String get bankrollHelper => 'Questo sarà il bankroll del casinò';

  @override
  String get casinoOwnershipInfoTitle =>
      'Informazioni sulla proprietà del casinò:';

  @override
  String get casinoClosedTitle => 'CASINÒ CHIUSO';

  @override
  String get casinoOwnedByLabel => 'Questo casinò è di proprietà di:';

  @override
  String get casinoNoOwner => 'Questo casinò non ha ancora un proprietario';

  @override
  String get casinoPurchasePriceLabel => 'Prezzo d\'acquisto:';

  @override
  String get casinoOwnerInfo =>
      'Come proprietario gestisci il bankroll del casinò e guadagni soldi quando i giocatori perdono!';

  @override
  String get casinoGameSlotsName => 'Slot machine';

  @override
  String get casinoGameSlotsDesc =>
      'Gira i rulli e vinci fino a 100 volte la tua scommessa!';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Batti il ​​dealer e vinci fino a 2 volte la tua scommessa!';

  @override
  String get casinoGameRouletteName => 'Roulette';

  @override
  String get casinoGameRouletteDesc =>
      'Scegli il tuo numero e vinci fino a 35 volte la tua scommessa!';

  @override
  String get casinoGameDiceName => 'Dadi';

  @override
  String get casinoGameDiceDesc =>
      'Lancia i dadi e vinci fino a 6 volte la tua scommessa!';

  @override
  String get difficultyEasy => 'FACILE';

  @override
  String get difficultyMedium => 'MEDIA';

  @override
  String get difficultyHard => 'DIFFICILE';

  @override
  String get casinoDepositTitle => 'Depositare denaro';

  @override
  String get casinoWithdrawTitle => 'Prelevare denaro';

  @override
  String get amount => 'Quantità';

  @override
  String get deposit => 'Depositare';

  @override
  String get withdraw => 'Ritirare';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount depositati nel bankroll del casinò';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount prelevati dal bankroll del casinò';
  }

  @override
  String get casinoDepositError => 'Errore durante il deposito';

  @override
  String get casinoWithdrawError => 'Errore nel ritiro';

  @override
  String get casinoMinBankroll => 'Nel bankroll devono rimanere almeno 10.000€';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Massimo: €$amount';
  }

  @override
  String get casinoManagementTitle => 'Gestione del casinò';

  @override
  String casinoBankruptWarning(String amount) {
    return 'ATTENZIONE: bankroll del casinò troppo basso! \nDeposita almeno €$amount per evitare il fallimento.';
  }

  @override
  String get casinoBankroll => 'Soldi del casinò';

  @override
  String get casinoStatsTitle => 'Statistiche';

  @override
  String get casinoTotalReceived => 'Totale ricevuto:';

  @override
  String get casinoTotalPaidOut => 'Totale pagato:';

  @override
  String get casinoNetProfit => 'Utile netto:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Margine di profitto: $percent%';
  }

  @override
  String get casinoManagementInfoTitle =>
      'Informazioni sulla gestione del casinò';

  @override
  String get casinoManagementInfo5 =>
      '• Puoi depositare o prelevare denaro in qualsiasi momento';

  @override
  String get casinoHubChooseGameHint =>
      'Scegli un gioco e piazza la tua scommessa';

  @override
  String get casinoPlayButton => 'Giocare';

  @override
  String get casinoGameBaccaratName => 'Baccarat';

  @override
  String get casinoGameBaccaratDesc =>
      'Scommetti sul giocatore, sul banco o sul pareggio con quote strategiche.';

  @override
  String get casinoGameVideoPokerName => 'Videopoker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Pesca 5 carte e ottieni combo fino alla Scala Reale.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Acquista casinò (bloccato)';

  @override
  String get casinoErrGenericPlay => 'Qualcosa è andato storto';

  @override
  String get casinoErrSpinFailed => 'Errore durante la rotazione';

  @override
  String get casinoErrBetFailed => 'Errore durante la scommessa';

  @override
  String get casinoErrGambleFailed => 'Errore durante il gioco d\'azzardo';

  @override
  String get casinoErrThrowFailed => 'Errore durante il rotolamento';

  @override
  String get casinoErrCasinoNotFound =>
      'Casinò non trovato. Assicurati che il casinò sia stato acquistato in questo paese.';

  @override
  String get casinoErrInsufficientFunds => 'Non abbastanza soldi';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Il bankroll del casinò è troppo basso per questo pagamento';

  @override
  String casinoErrNetwork(String error) {
    return 'Errore di rete: $error';
  }

  @override
  String get casinoResultYouWon => 'Hai vinto!';

  @override
  String get casinoResultYouLost => 'Perduta';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Hai vinto!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Hai vinto €$amount!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Hai perso €$amount';
  }

  @override
  String get casinoYouLostPlain => 'Hai perso';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Hai vinto €$amount!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK! €$amount';
  }

  @override
  String get casinoAgain => 'Ancora';

  @override
  String get casinoBankruptTitle => 'Casinò in bancarotta!';

  @override
  String get casinoBankruptBody =>
      'Il casinò è fallito! \n\nIl proprietario non aveva abbastanza contanti nel bankroll per coprire tutti i pagamenti. \n\nIl casinò è ora chiuso e può essere acquistato nuovamente.';

  @override
  String get casinoBackToCasino => 'Torniamo al Casinò';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Numero: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'verde';

  @override
  String get casinoColorRed => 'rossa';

  @override
  String get casinoColorBlack => 'nera';

  @override
  String get casinoRoulettePickBet => 'Scegli la tua scommessa';

  @override
  String get casinoRouletteBetRed => 'Rossa';

  @override
  String get casinoRouletteBetBlack => 'Nera';

  @override
  String get casinoRouletteBetEven => 'Anche';

  @override
  String get casinoRouletteBetOdd => 'Strana';

  @override
  String get casinoRouletteSpinButton => 'ROTAZIONE!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Ultimo risultato: $number';
  }

  @override
  String get casinoBetLabel => 'Scommettere';

  @override
  String get casinoBlackjackPlayButton => 'GIOCARE!';

  @override
  String get casinoSlotSpinButton => 'ROTAZIONE!';

  @override
  String get casinoDiceRollButton => 'ROTOLO!';

  @override
  String get casinoBlackjackYourCards => 'Le tue carte';

  @override
  String get casinoBlackjackDealerCards => 'Carte del dealer';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Commerciante: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Tu: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Totale: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Prevedere';

  @override
  String get casinoDiceLowLabel => 'Basso (2-6)';

  @override
  String get casinoDiceHighLabel => 'Alto (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Basso/Alto paga 2x • Il totale esatto paga 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Tabella dei pagamenti';

  @override
  String get casinoBaccaratPlayer => 'Giocatrice';

  @override
  String get casinoBaccaratBanker => 'Banchiera';

  @override
  String get casinoBaccaratTieBet => 'Cravatta';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Vincitore: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Pagamento: €$amount';
  }

  @override
  String get casinoNoPayout => 'Nessun pagamento';

  @override
  String casinoResultEuro(String amount) {
    return 'Risultato: €$amount';
  }

  @override
  String get casinoDealing => 'Condotta…';

  @override
  String get casinoDealCaps => 'AFFARE';

  @override
  String get casinoVideoPokerDrawCards => 'PESCARE CARTE';

  @override
  String get casinoVideoPokerDrawHint => 'Disegna la tua mano';

  @override
  String get casinoVideoPokerRoyalFlush => 'Scala reale';

  @override
  String get casinoVideoPokerStraightFlush => 'Scala colore';

  @override
  String get casinoVideoPokerFourKind => 'Quattro di un genere';

  @override
  String get casinoVideoPokerFullHouse => 'Tutto esaurito';

  @override
  String get casinoVideoPokerFlush => 'A filo';

  @override
  String get casinoVideoPokerStraight => 'Dritta';

  @override
  String get casinoVideoPokerThreeKind => 'Tris';

  @override
  String get casinoVideoPokerTwoPair => 'Doppia Coppia';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jack o meglio';

  @override
  String get casinoVideoPokerNoWinningHand => 'Nessuna mano vincente';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Tabella dei pagamenti: Jack+ 1x • Doppia Coppia 2x • Tris 3x • Scala 4x • Colore 6x • Full 9x • Quattro 25x • Scala Colore 50x • Reale 250x';

  @override
  String get bankScreenLoadFailed => 'Impossibile caricare il bank';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Errore di rete: $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'A: $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'Da: $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Deposito riuscito';

  @override
  String get bankScreenDepositFailed => 'Deposito non riuscito';

  @override
  String bankScreenDailyDepositQuota(String remaining, String cap) {
    return 'Depositi liberi rimasti oggi: $remaining di $cap. Quantità maggiori devono essere riciclate.';
  }

  @override
  String get bankScreenDailyDepositCapReached =>
      'Il limite di deposito gratuito di oggi è esaurito. Riciclare il contante rimanente o attendere il ripristino dell\'UTC.';

  @override
  String bankScreenFillRemainingQuota(String amount) {
    return 'Riempi rimanente ($amount)';
  }

  @override
  String bankScreenDailyDepositResetsIn(String time) {
    return 'I depositi gratuiti vengono ripristinati alle 00:00 UTC ($time sinistra).';
  }

  @override
  String get bankScreenDailyDepositBelowLaunderMin =>
      'I contanti al di sotto del minimo di riciclaggio possono essere depositati gratuitamente dopo il ripristino dell\'UTC.';

  @override
  String bankScreenDepositCapError(String remaining) {
    return 'Ciò supera il deposito gratuito rimanente di oggi ($remaining). Deposita fino a tale importo o utilizza il riciclaggio di denaro.';
  }

  @override
  String get bankScreenWithdrawSuccess => 'Ritiro riuscito';

  @override
  String get bankScreenWithdrawFailed => 'Ritiro fallito';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '€$amount trasferito a $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Trasferimento non riuscito';

  @override
  String get bankScreenErrRecipientNotFound => 'Giocatore non trovato';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'Non puoi trasferire a te stesso';

  @override
  String get bankScreenErrInsufficientBalance => 'Saldo bancario insufficiente';

  @override
  String get bankScreenErrInvalidAmount => 'Importo non valido';

  @override
  String get bankScreenTryAgain => 'Riprova';

  @override
  String get bankScreenWorldwideSubtitle =>
      'Banca (accessibile in tutto il mondo)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Contanti in cassa: €$amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Saldo bancario: €$amount';
  }

  @override
  String get bankScreenAmountLabel => 'Quantità';

  @override
  String get bankScreenDescriptionOptional => 'Descrizione (facoltativa)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Verranno archiviati con il tuo deposito o prelievo nelle transazioni.';

  @override
  String get bankScreenDepositButton => 'Depositare';

  @override
  String get bankScreenWithdrawButton => 'Ritirare';

  @override
  String get bankScreenTransferSectionTitle => 'Trasferimento al giocatore';

  @override
  String get bankScreenRecipientUsername => 'Nome utente del destinatario';

  @override
  String get bankScreenRecentRecipients => 'Destinatari recenti';

  @override
  String get bankScreenDescriptionTransferHint =>
      'Il destinatario vedrà questa descrizione anche nelle transazioni.';

  @override
  String get bankScreenTransferButton => 'Trasferire';

  @override
  String get bankScreenTransactionsTitle => 'Transazioni';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count totale';
  }

  @override
  String get bankScreenSummaryDeposits => 'Depositi';

  @override
  String get bankScreenSummaryWithdrawals => 'Prelievi';

  @override
  String get bankScreenSummarySent => 'Inviata';

  @override
  String get bankScreenSummaryReceived => 'Ricevuto';

  @override
  String get bankScreenNoTransactions => 'Nessuna transazione ancora';

  @override
  String get bankScreenTxnDeposit => 'Depositare';

  @override
  String get bankScreenTxnWithdraw => 'Ritiro';

  @override
  String get bankScreenTxnTransferSent => 'Trasferimento inviato';

  @override
  String get bankScreenTxnTransferReceived => 'Bonifico ricevuto';

  @override
  String get bankScreenPrevious => 'Precedente';

  @override
  String get bankScreenNext => 'Prossima';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Classifica $rank';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get doAction => 'Fare';

  @override
  String get pay => 'Paga';

  @override
  String get success => 'Successo';

  @override
  String get jail => 'Prigione';

  @override
  String get cooldown => 'Raffreddare';

  @override
  String get requiredRank => 'Grado del giocatore richiesto';

  @override
  String get playerRankLabel => 'Grado del giocatore';

  @override
  String get loading => 'Caricamento...';

  @override
  String get trade => 'Commercio';

  @override
  String get buy => 'Acquistare';

  @override
  String get sell => 'Vendere';

  @override
  String get price => 'Prezzo';

  @override
  String get total => 'Totale';

  @override
  String available(String count) {
    return 'Disponibile: $count';
  }

  @override
  String get notEnoughMoney => 'Non hai abbastanza soldi!';

  @override
  String get confirm => 'Confermare';

  @override
  String get close => 'Vicina';

  @override
  String get viewOffer => 'Visualizza l\'offerta';

  @override
  String get unexpectedResponse => 'Risposta API imprevista';

  @override
  String get errorLoadingMenu => 'Errore durante il caricamento del menu';

  @override
  String get unknownError => 'Errore sconosciuto';

  @override
  String get food => 'Cibo';

  @override
  String get drink => 'Bere';

  @override
  String get work => 'Lavoro';

  @override
  String cooldownMinutes(String minutes) {
    return 'Tempo di recupero: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Volare';

  @override
  String get purchased => 'Acquistato!';

  @override
  String get sold => 'Venduta!';

  @override
  String get errorBuying => 'Errore nell\'acquisto';

  @override
  String get errorSelling => 'Errore nella vendita';

  @override
  String get goods => 'Merce';

  @override
  String get marketplace => 'Mercata';

  @override
  String get myListings => 'I miei annunci';

  @override
  String get inventory => 'Inventario';

  @override
  String get backpacks => 'Zaini';

  @override
  String get materials => 'Materiali';

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
  String get production => 'Produzione';

  @override
  String get stock => 'Azione';

  @override
  String get retryAgain => 'Riprova';

  @override
  String get noVehiclesAvailable => 'Nessun veicolo disponibile';

  @override
  String get noListings => 'Nessun elenco';

  @override
  String get condition => 'Condizione';

  @override
  String get yourHealth => 'La tua salute';

  @override
  String get criticalHealthWarning =>
      '⚠️ CRITICO! Devi andare immediatamente in ospedale!';

  @override
  String get lowHealthWarning => '⚠️ Salute scarsa! Stai attento.';

  @override
  String get information => 'Informazioni';

  @override
  String get contrabandFlowersName => 'Fiori';

  @override
  String get contrabandFlowersDesc =>
      'Tulipani olandesi e altri fiori per il commercio internazionale';

  @override
  String get contrabandElectronicsName => 'Elettronica';

  @override
  String get contrabandElectronicsDesc =>
      'Componenti elettronici e informatici avanzati';

  @override
  String get contrabandDiamondsName => 'Diamanti';

  @override
  String get contrabandDiamondsDesc => 'Diamanti grezzi e tagliati';

  @override
  String get contrabandWeaponsName => 'Armi';

  @override
  String get contrabandWeaponsDesc => 'Armi e munizioni illegali';

  @override
  String get contrabandPharmaceuticalsName => 'Prodotti farmaceutici';

  @override
  String get contrabandPharmaceuticalsDesc => 'Prodotti farmaceutici rari';

  @override
  String get contrabandSpiritsName => 'Superalcolici di lusso';

  @override
  String get contrabandSpiritsDesc =>
      'Whisky, cognac e liquori premium di contrabbando';

  @override
  String get contrabandTobaccoName => 'Tabacco';

  @override
  String get contrabandTobaccoDesc =>
      'Sigarette e tabacco da fiuto senza accise';

  @override
  String get contrabandArtName => 'Arte e antiquariato';

  @override
  String get contrabandArtDesc =>
      'Dipinti, sculture e antiquariato di contrabbando';

  @override
  String get contrabandSpicesName => 'Spezie';

  @override
  String get contrabandSpicesDesc => 'Erbe e spezie esotiche in bulk';

  @override
  String get contrabandCoffeeName => 'Caffè';

  @override
  String get contrabandCoffeeDesc =>
      'Chicchi di caffè premium senza certificato';

  @override
  String get contrabandFurLeatherName => 'Pellicce & pelle';

  @override
  String get contrabandFurLeatherDesc => 'Pellicce illegali e pelle esotica';

  @override
  String get contrabandPerfumeName => 'Profumo';

  @override
  String get contrabandPerfumeDesc => 'Profumi di designer di contrabbando';

  @override
  String get contrabandCounterfeitCashName => 'Denaro falso';

  @override
  String get contrabandCounterfeitCashDesc =>
      'Banconote contraffatte di alta qualità';

  @override
  String get contrabandRareWineName => 'Vino raro';

  @override
  String get contrabandRareWineDesc => 'Vini vintage e collezioni esclusive';

  @override
  String get contrabandLuxuryWatchesName => 'Orologi di lusso';

  @override
  String get contrabandLuxuryWatchesDesc =>
      'Orologi di prestigio senza documenti';

  @override
  String get contrabandGoldName => 'Oro';

  @override
  String get contrabandGoldDesc => 'Lingotti d\'oro fusi non contrassegnati';

  @override
  String get multiplier => 'Moltiplicatore';

  @override
  String get sellPrice => 'Prezzo di vendita';

  @override
  String get boughtFor => 'Comprato per';

  @override
  String get profit => 'Profitto';

  @override
  String get loss => 'Perdita';

  @override
  String ownedQuantity(String quantity) {
    return 'Di proprietà: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Bottino tra ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 SPOILED - Inutile';

  @override
  String get vehicleBought => 'Veicolo acquistato con successo!';

  @override
  String get purchaseFailed => 'Acquisto fallito';

  @override
  String get listingRemoved => 'Elenco rimosso';

  @override
  String get noItemsInInventory => 'Nessun articolo nell\'inventario';

  @override
  String get buyItemsInBuyTab => 'Acquista articoli nella scheda Acquista';

  @override
  String errorLoadingMarketData(String error) {
    return 'Errore durante il caricamento dei dati di mercato: $error';
  }

  @override
  String get tradeLoadGoodsFailed => 'Impossibile caricare il catalogo merci';

  @override
  String get tradeLoadPricesFailed => 'Impossibile caricare i prezzi correnti';

  @override
  String get tradeLoadInventoryFailed =>
      'Impossibile caricare il tuo inventario commerciale';

  @override
  String get tradePartialDataBanner =>
      'Non è stato possibile aggiornare alcuni dati di mercato. Tirare verso il basso per riprovare.';

  @override
  String get tradeMarketLoadAllFailed =>
      'Impossibile caricare il mercato. Tirare verso il basso per riprovare.';

  @override
  String get tradeNoGoodsLoaded => 'Nessuna merce è disponibile al momento.';

  @override
  String get tradeRiskPanelTitle => 'Rischi di viaggio e di mercato';

  @override
  String get tradeRiskPanelSubtitle =>
      'Ogni bene presenta deterioramenti, oscillazioni di prezzo, danni da viaggio o confisca laddove applicabile.';

  @override
  String get tradeRiskInsightBody =>
      'FIORI: si rovinano dopo il tempo dall\'acquisto - vendi in tempo. \nDIAMANTI: i prezzi di acquisto oscillano con la volatilità; pianifica dove vendere all\'estero. \nELETTRONICA: può perdere condizioni a ogni viaggio, riducendo il valore di rivendita. \nARMI e PRODOTTI FARMACEUTICI: durante i viaggi possono verificarsi sequestri parziali: mantieni i ricercati bassi e leggi le regole sul contrabbando. \nI prezzi in questa schermata includono già il moltiplicatore del tuo paese attuale.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h finestra di spoiler';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% oscillazione del prezzo';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct% rischio di convulsioni per viaggio';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct% di possibilità di danni per viaggio';
  }

  @override
  String tradeRiskHeavyWeight(String weight) {
    return 'Pesante ($weight peso)';
  }

  @override
  String get tradeGoodNotAvailableHere =>
      'Questo prodotto non è in vendita nel tuo paese attuale. Viaggia in un paese fonte.';

  @override
  String get tradeNoBuyableGoodsInCountry =>
      'Nessuna merce in vendita in questo paese. Viaggia in un paese fonte.';

  @override
  String get tradeUnavailableGoodsTitle => 'Non in vendita qui';

  @override
  String tradeUnavailableGoodsSubtitle(String count) {
    return '$count prodotti solo nei paesi fonte';
  }

  @override
  String get tradeTravelToSourceHint =>
      'Solo nei paesi fonte — viaggia per acquistare';

  @override
  String get tradeCategoryAll => 'Tutto';

  @override
  String get tradeCategoryStarter => 'Starter';

  @override
  String get tradeCategoryBulk => 'Bulk';

  @override
  String get tradeCategoryLuxury => 'Lusso';

  @override
  String get tradeCategoryDangerous => 'Pericoloso';

  @override
  String get tradeFilterAvailableHere => 'In vendita qui';

  @override
  String tradeMarketCatalogSummary(String total, String here) {
    return '$total prodotti · $here in vendita qui';
  }

  @override
  String get appeal => 'Appello';

  @override
  String get submitAppeal => 'Presentare ricorso';

  @override
  String get bribeJudge => 'Corrompere il giudice';

  @override
  String get bribe => 'Tangente';

  @override
  String get courtLoadFailed =>
      'Impossibile caricare i dati del tribunale. Per favore riprova.';

  @override
  String get courtAppealDialogIntro =>
      'Vuoi presentare ricorso per questa condanna?';

  @override
  String courtCostLine(String amount) {
    return 'Costo: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Giudice: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruttibilità: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'In caso di successo: riduzione della pena di circa il 20-40%.';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Ricorso accolto. Nuova frase: $minutes minuti.';
  }

  @override
  String get courtAppealDenied => 'Ricorso respinto.';

  @override
  String get courtBribeOfferIntro =>
      'Offri un importo. L\'importo viene sempre detratto, anche in caso di fallimento.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Importo della tangente: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€${thousands}k';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Probabilità di successo stimata: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Giudice corrotto. Verrai rilasciato immediatamente.';

  @override
  String get courtBribeFailedDebited =>
      'La tangente è fallita. L\'importo è stato comunque detratto.';

  @override
  String get courtRecordActive => 'Attiva';

  @override
  String get courtRecordServed => 'Servito';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Ricorso accolto: $fromMinutes → $toMinutes minuti';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Ricorso respinto: $minutes minuti rimasti';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Tangente fallita: $amount pagata';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Condannato a $minutes minuti';
  }

  @override
  String get courtPartialLoadWarning =>
      'Attenzione: non è stato possibile caricare parte dei dati del tribunale. Tirare per aggiornare e riprovare.';

  @override
  String get courtNoActiveSentence => 'Nessuna frase attiva';

  @override
  String get courtNotJailedHint =>
      'Al momento non sei in prigione. La tua fedina penale rimane visibile di seguito.';

  @override
  String get courtActiveSentenceTitle => 'Frase attiva';

  @override
  String get courtDelictLabel => 'Crimine';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Frase totale: $minutes minuti';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Rimanente: $minutes minuti';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Costo attuale del ricorso: $amount';
  }

  @override
  String get courtButtonAppeal => 'Appello';

  @override
  String get courtButtonBribeJudge => 'Corrompere il giudice';

  @override
  String get courtUnknownCrime => 'Sconosciuta';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Frase: $minutes minuti';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Frase: $original → $reduced minuti';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Data: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Storia della corte';

  @override
  String get courtAppealSubmitted => 'Ricorso presentato';

  @override
  String get courtCriminalRecordTitle => 'Fedina penale';

  @override
  String courtTotalConvictions(String count) {
    return 'Condanne totali: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Le convinzioni passate restano visibili. Una tangente di un giudice che riesce a risolvere solo un caso attivo.';

  @override
  String get courtNoConvictionsYet => 'Nessuna condanna ancora registrata.';

  @override
  String get treated => 'Trattato!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP per €$cost';
  }

  @override
  String get treatmentOptions => 'Opzioni di trattamento';

  @override
  String get youAreDead => 'Sei morto! Game Over.';

  @override
  String get emergencyOnly =>
      'Trattamento di emergenza disponibile solo sotto i 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Trattamento d\'emergenza! +$hp HP gratuiti';
  }

  @override
  String get byValue => 'Per valore';

  @override
  String get byCondition => 'Per condizione';

  @override
  String get byFuel => 'Per carburante';

  @override
  String get byName => 'Per nome';

  @override
  String get stealCar => 'Rubare l\'auto';

  @override
  String get stealBoat => 'Rubare la barca';

  @override
  String get sellVehicle => 'Vendi veicolo';

  @override
  String get sellBoat => 'Vendere Barca';

  @override
  String get confirmSellVehicle =>
      'Sei sicuro di voler vendere questo veicolo?';

  @override
  String get confirmSellBoat => 'Sei sicuro di voler vendere questa barca?';

  @override
  String get carStolen => 'Auto rubata con successo!';

  @override
  String get boatStolen => 'Barca rubata con successo!';

  @override
  String get vehicleTypeCar => 'Auto';

  @override
  String get vehicleTypeBoat => 'Barca';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType rubato!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Sconosciuto $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Velocità';

  @override
  String get vehicleStatFuel => 'Carburante';

  @override
  String get vehicleStatCargo => 'Carico';

  @override
  String get vehicleStatStealth => 'Furtività';

  @override
  String get continueAction => 'Continuare';

  @override
  String get vehicleSold => 'Veicolo venduto con successo!';

  @override
  String get boatSold => 'Barca venduta con successo!';

  @override
  String get garageUpgraded => 'Garage aggiornato!';

  @override
  String get marinaUpgraded => 'Marina è stata aggiornata con successo!';

  @override
  String get marinaCapacity => 'Capacità del porto turistico';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total barche';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Livello massimo';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Livello $level | $remaining posti rimasti';
  }

  @override
  String get noBoatsInMarina => 'Nessuna barca nel tuo porto turistico';

  @override
  String get stealBoatsToStart => 'Ruba alcune barche per iniziare!';

  @override
  String get marinaUpgradeFailed =>
      'L\'aggiornamento del porto turistico non è riuscito';

  @override
  String get boatShipped => 'Barca spedita con successo!';

  @override
  String get boatShipFailed => 'La spedizione della barca non è riuscita';

  @override
  String get buyProperty => 'Acquista proprietà';

  @override
  String propertyBought(String name) {
    return '$name acquistato!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Proprietà migliorata al livello $level!';
  }

  @override
  String get errorLoadingProperties =>
      'Errore durante il caricamento delle proprietà';

  @override
  String get errorUpgrading => 'Errore durante l\'aggiornamento';

  @override
  String networkError(String error) {
    return 'Errore di rete: $error';
  }

  @override
  String get unknownResponse => 'Risposta sconosciuta';

  @override
  String incomeCollected(String amount) {
    return '€$amount raccolti!';
  }

  @override
  String get buyCasino => 'Acquista Casinò';

  @override
  String get manageCasino => 'Gestisci il Casinò';

  @override
  String get casinoBought => 'Casinò acquistato con successo! 🎰';

  @override
  String get errorBuyCasino =>
      'Si è verificato un errore durante l\'acquisto del casinò';

  @override
  String minimumDeposit(String amount) {
    return 'Il deposito minimo è €$amount';
  }

  @override
  String get casinoInfo1 =>
      'I giocatori scommettono contro il bankroll del casinò';

  @override
  String get casinoInfo2 => 'Le vincite vengono pagate dal bankroll';

  @override
  String get casinoInfo3 => 'Puoi depositare e prelevare denaro';

  @override
  String get casinoInfo4 => 'È richiesto un bankroll minimo di € 10.000';

  @override
  String get casinoInfo5 => 'Sotto: fallimento';

  @override
  String get members => 'Membri';

  @override
  String get location => 'Posizione';

  @override
  String get level => 'Livello';

  @override
  String get alreadyFullHealth => 'Sei già in piena salute!';

  @override
  String get errorTreatment => 'Errore durante il trattamento';

  @override
  String waitMinutes(String minutes) {
    return 'Devi attendere $minutes minuti in più per il trattamento successivo!';
  }

  @override
  String get emergencyHelp => 'Aiuto di emergenza';

  @override
  String onlyNeedHp(String hp) {
    return '(Hai bisogno solo di $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 L\'aiuto di emergenza è GRATUITO sotto i 10 HP (+20 HP)';

  @override
  String get hospitalInfo1 =>
      '• La salute diminuisce quando si commettono crimini';

  @override
  String get hospitalInfo2 => '• A 0 HP non puoi commettere crimini';

  @override
  String hospitalInfo3(String cost) {
    return '• Il trattamento costa €$cost a volta';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Puoi ripristinare un massimo di $amount HP per trattamento';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 ora di recupero tra i trattamenti';

  @override
  String get hospitalInfo6 =>
      '• 💚 Guarigione passiva: +5 HP ogni 5 minuti (se HP > 0)';

  @override
  String get medicalTreatment => 'Trattamento medico';

  @override
  String get restoreCritical => 'Ripristina +20 HP (condizione critica)';

  @override
  String get hospitalCooldownTitle => 'Trattamento nel periodo di recupero';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Prossimo trattamento disponibile tra: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Stato medico';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'terapia intensiva: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'HP $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle =>
      'Panoramica sulle unità di terapia intensiva e triage';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Paziente in terapia intensiva. Tempo rimanente: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Stato critico rilevato. Si consiglia il pronto soccorso.';

  @override
  String get hospitalStableStatus =>
      'Stabile. Trattamento regolare disponibile.';

  @override
  String get hospitalRefreshMedicalRecord => 'Aggiorna la cartella clinica';

  @override
  String get hospitalStandardTreatmentTitle => 'Trattamento standard';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Conveniente • ripristina fino a $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Trattamento intensivo';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Recupero più veloce • fino a $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Trattamento intensivo: €$cost per un recupero fino a $amount HP.';
  }

  @override
  String restoreUp(String amount) {
    return 'Ripristina fino a $amount HP';
  }

  @override
  String get cost => 'Costo';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Per questo crimine ti serve $tools';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Hai $tools, ma è a casa! Vai a Inventario → Trasferimento';
  }

  @override
  String get crimeErrorVehicleRequired => '🚗 Questo reato richiede un veicolo';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Veicolo non trovato';

  @override
  String get crimeErrorNotVehicleOwner => '🚗 Non possiedi questo veicolo';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Il tuo veicolo è rotto e necessita di riparazione';

  @override
  String get crimeErrorNoFuel => '⛽ Il tuo veicolo è senza carburante';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Il tuo livello è troppo basso per questo crimine';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Reato invalido';

  @override
  String get crimeErrorWeaponRequired => '🔫 Serve un\'arma per questo crimine';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 La tua arma è rotta e necessita di riparazione';

  @override
  String get crimeErrorNoAmmo => '🔫 Non hai munizioni';

  @override
  String get crimeErrorGeneric =>
      '❌ Qualcosa è andato storto in questo delitto';

  @override
  String get inventoryFull =>
      '🎒 Il tuo inventario è pieno! Conservare gli strumenti in una proprietà';

  @override
  String get storageFull => '📦 Il deposito della proprietà è pieno';

  @override
  String get inventoryCrimeWeaponTitle => 'Arma del crimine selezionata';

  @override
  String get inventoryCrimeWeaponHint => 'Seleziona un\'arma per i crimini';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Scegli qui la tua arma del crimine. La schermata dei crimini utilizza immediatamente questa selezione.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'Nessuna arma utilizzabile nell\'inventario. Acquista o sposta prima un\'arma negli oggetti trasportati.';

  @override
  String get inventoryPaperDoll => 'Attrezzatura';

  @override
  String get inventoryBackpackGrid => 'Zaino';

  @override
  String get inventoryStorageGrid => 'Magazzinaggio';

  @override
  String get inventoryMaterialsDepot => 'Deposito materiali';

  @override
  String get inventoryEquipWeapon => 'Arma del crimine';

  @override
  String get inventoryEquipSecondary => 'Seconda arma';

  @override
  String get inventoryEquipArmor => 'Maglia';

  @override
  String get inventoryEmptySlot => 'Slot vuoto';

  @override
  String inventorySelectHint(String name) {
    return 'Selezionato: $name. Tocca uno slot valido per spostarlo.';
  }

  @override
  String get inventoryOpenStorage => 'Spazio di archiviazione aperto';

  @override
  String get inventoryTransferOk => 'Articolo spostato';

  @override
  String get inventoryTransferFailed => 'Spostamento fallito';

  @override
  String get inventoryWrongDrop => 'Quella caduta non è consentita qui';

  @override
  String get inventoryMoveOne => 'Sposta 1';

  @override
  String get inventoryMoveAll => 'Sposta tutto';

  @override
  String inventorySlotUsage(int used, int max) {
    return 'Zaino $used/$max';
  }

  @override
  String get inventoryCarriedEmpty =>
      'Non stai trasportando strumenti, armi o munizioni.';

  @override
  String get inventorySectionTools => 'Utensili';

  @override
  String get inventorySectionWeapons => 'Armi';

  @override
  String get inventorySectionAmmo => 'Munizioni';

  @override
  String get inventoryWeaponFallbackName => 'Arma';

  @override
  String get inventoryAmmoFallbackName => 'Munizioni';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Condizione: $condition% • Quantità: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Quantità: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Quantità: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Ritiro dal magazzino: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Massimo: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Quantità non valida';

  @override
  String get inventorySnackWeaponStored => 'Arma depositata';

  @override
  String get inventorySnackWeaponWithdrawn => 'Arma ritirata';

  @override
  String get inventorySnackCashStored => 'Depositato in contanti';

  @override
  String get inventorySnackCashWithdrawn => 'Contanti ritirati';

  @override
  String get inventorySnackDrugsWithdrawn => 'Farmaci ritirati';

  @override
  String get inventoryActionFailed => 'Azione fallita';

  @override
  String get inventoryStorageNoCategory => 'Nessun tipo di archiviazione';

  @override
  String get inventoryCountsWeapons => 'Armi';

  @override
  String get inventoryCountsDrugs => 'Droghe';

  @override
  String get inventoryCountsCash => 'Contanti';

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
      'Sei in un altro paese. Non puoi accedere a questo spazio di archiviazione qui.';

  @override
  String get inventoryWeaponStorageTitle => 'Deposito armi';

  @override
  String get inventoryStoreWeapons => 'Negozio';

  @override
  String get inventoryInStorage => 'In deposito';

  @override
  String get inventoryUnknownWeapon => 'Arma sconosciuta';

  @override
  String get inventoryTakeOne => 'Prendi 1';

  @override
  String get inventoryNoWeaponsInStorage => 'Nessuna arma in questo deposito.';

  @override
  String get inventoryCashStorageTitle => 'Deposito contanti';

  @override
  String get inventoryDepositCash => 'Depositare contanti';

  @override
  String get inventoryWithdrawCash => 'Prelevare contanti';

  @override
  String get inventoryDrugStorageTitle => 'Conservazione dei farmaci';

  @override
  String get inventoryNoDrugsInStorage => 'Nessun farmaco in deposito.';

  @override
  String get inventoryNotForTools =>
      'Questa proprietà non è per la conservazione degli strumenti. Usa un magazzino per gli strumenti.';

  @override
  String get inventoryCategoryTools => 'Utensili';

  @override
  String get inventoryCategoryDrugs => 'Droghe';

  @override
  String get inventoryCategoryWeapons => 'Armi';

  @override
  String get inventoryCategoryCash => 'Contanti';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max slot ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Accessibile nel paese attuale';

  @override
  String get inventoryStorageNotAccessibleHere =>
      'Non accessibile in questo paese';

  @override
  String get loadoutEquipFailed =>
      'Impossibile equipaggiare l\'equipaggiamento';

  @override
  String get loadoutDeleteFailed => 'Impossibile eliminare il caricamento';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool spostato in $location';
  }

  @override
  String get carried => 'Portato';

  @override
  String get storage => 'Magazzinaggio';

  @override
  String get property => 'Proprietà';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slot';
  }

  @override
  String get loadouts => 'Caricamenti';

  @override
  String get createLoadout => 'Crea equipaggiamento';

  @override
  String get equipLoadout => 'Equipaggiare';

  @override
  String get loadoutEquipped => '✅ Carico attrezzato';

  @override
  String get loadoutMaxReached => '❌ Carichi massimi raggiunti (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Strumenti mancanti: $tools';
  }

  @override
  String get backpackUpgrade => 'Aggiornamento dello zaino';

  @override
  String get backpackBasic => 'Zaino base (+5 slot)';

  @override
  String get backpackTactical => 'Gilet tattico (+10 slot)';

  @override
  String get backpackCargo => 'Pantaloni cargo (+3 slot)';

  @override
  String get upgradeInventory => 'Aggiorna inventario';

  @override
  String get noToolsCarried => 'Nessuno strumento trasportato';

  @override
  String get visitShopToBuyTools =>
      'Visita il negozio per acquistare gli strumenti';

  @override
  String get noProperties => 'Nessuna proprietà';

  @override
  String get buyPropertyForStorage =>
      'Acquista un immobile per riporre gli attrezzi';

  @override
  String get noToolsInStorage => 'Nessuno strumento in deposito';

  @override
  String get selectProperty => 'Seleziona proprietà';

  @override
  String get slotsRemaining => 'slot rimanenti';

  @override
  String get noLoadouts => 'Nessun caricamento';

  @override
  String get createLoadoutToStart => 'Crea un caricamento per iniziare';

  @override
  String get deleteLoadout => 'Elimina caricamento';

  @override
  String get confirmDeleteLoadout =>
      'Sei sicuro di voler eliminare questo caricamento?';

  @override
  String get loadoutDeleted => 'Caricamento eliminato';

  @override
  String get edit => 'Modificare';

  @override
  String get delete => 'Eliminare';

  @override
  String get active => 'Attiva';

  @override
  String get durability => 'Durabilità';

  @override
  String get quantity => 'Quantità';

  @override
  String get slotSize => 'Dimensione della fessura';

  @override
  String get repairCost => 'Costo di riparazione';

  @override
  String get wearPerUse => 'Usura per utilizzo';

  @override
  String get loseChance => 'Possibilità di perdere';

  @override
  String get requiredFor => 'Richiesto per';

  @override
  String get lowDurability => 'Bassa durabilità';

  @override
  String get transfer => 'Trasferire';

  @override
  String get toolDetails => 'Dettagli dello strumento';

  @override
  String get transferTool => 'Strumento di trasferimento';

  @override
  String get selectQuantity => 'Seleziona la quantità';

  @override
  String get destination => 'Destinazione';

  @override
  String get from => 'Da';

  @override
  String get to => 'A';

  @override
  String get editLoadout => 'Modifica equipaggiamento';

  @override
  String get loadoutName => 'Nome del carico';

  @override
  String get description => 'Descrizione';

  @override
  String get optional => 'opzionale';

  @override
  String get selectedTools => 'Strumenti selezionati';

  @override
  String get noToolsAvailable => 'Nessuno strumento disponibile';

  @override
  String get create => 'Creare';

  @override
  String get save => 'Salva';

  @override
  String get pleaseEnterName => 'Inserisci un nome';

  @override
  String get pleaseSelectTools => 'Seleziona almeno 1 strumento';

  @override
  String get loadoutCreated => 'Caricamento creato';

  @override
  String get loadoutUpdated => 'Caricamento aggiornato';

  @override
  String get goToInventory => 'Vai all\'inventario';

  @override
  String get slots => 'slot';

  @override
  String get backpackShop => 'Negozio di zaini';

  @override
  String get yourBackpack => 'Il tuo zaino';

  @override
  String get availableUpgrades => 'Aggiornamenti disponibili';

  @override
  String get otherBackpacks => 'Altri zaini';

  @override
  String get youHaveBestBackpack => 'Hai lo zaino migliore!';

  @override
  String get backpackPurchased => 'Zaino acquistato!';

  @override
  String get backpackUpgraded => 'Zaino aggiornato!';

  @override
  String get buyBackpack => 'Acquistare';

  @override
  String get upgradeBackpack => 'Aggiornamento';

  @override
  String get backpackPrice => 'Prezzo';

  @override
  String get extraSlots => 'Slot aggiuntivi';

  @override
  String get totalSlots => 'Slot totali';

  @override
  String get vipOnly => 'Solo VIP';

  @override
  String get tradeInValue => 'Valore di permuta';

  @override
  String get upgradeCost => 'Costo dell\'aggiornamento';

  @override
  String rankRequired(Object rank) {
    return 'Grado $rank richiesto';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Ti servono €$needed. Hai €$have';
  }

  @override
  String get alreadyHasBackpack => 'Hai già uno zaino';

  @override
  String get backpackNotFound => 'Zaino non trovato';

  @override
  String get playerNotFound => 'Giocatore non trovato';

  @override
  String get notAnUpgrade => 'Questo non è un aggiornamento';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Hai acquistato $name! +$slots slot.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Aggiornato a $newName! +$upgradeSlots slot extra.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Zaino non trovato';

  @override
  String get backpackPurchaseFailedAlready =>
      'Hai già uno zaino. Puoi usarne solo uno alla volta.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Hai bisogno del grado $required (sei del grado $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Ti servono €$needed. Hai €$have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Questo zaino è solo per i membri VIP';

  @override
  String get backpackUpgradeFailedNo => 'Non hai uno zaino da aggiornare';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Questo non è un aggiornamento. Scegli uno zaino più grande.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Hai bisogno del grado $required (sei del grado $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Ti servono €$needed. Hai €$have';
  }

  @override
  String get backpackUpgradeFailedVip => 'Questo zaino è solo per i membri VIP';

  @override
  String get backpackPurchaseFailedGeneric =>
      'Impossibile completare l\'acquisto.';

  @override
  String get backpackUpgradeFailedGeneric =>
      'Impossibile completare l\'aggiornamento.';

  @override
  String get backpackUnknownEvent => 'Azione sconosciuta';

  @override
  String get backpackLoadFailedGeneric => 'Qualcosa è andato storto';

  @override
  String get backpackOwnedBadge => 'Posseduta';

  @override
  String get availableBackpacks => 'Zaini disponibili';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Attuale: $name (+$slots slot)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Novità: $name (+$slots slot)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Aggiornamento: +$delta slot';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Totale: $totalSlots slot';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(problema di archiviazione: prova ad accedere di nuovo)';

  @override
  String get blackMarketTabBackpacks => 'Zaini';

  @override
  String get bmHubAdjustFiltersHint => 'Prova a modificare i filtri';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Veicoli da Garage/Marina, o strumenti trasportati con Vendi oggetto';

  @override
  String get bmHubSellerLabel => 'Venditrice';

  @override
  String get bmHubAskingPriceLabel => 'Prezzo richiesto';

  @override
  String get bmHubMarketValueShort => 'Valore di mercato';

  @override
  String get bmHubBuyNow => 'Acquista ora';

  @override
  String get bmHubListedFor => 'Inserito per';

  @override
  String get bmHubEditPrice => 'Modifica prezzo';

  @override
  String get bmHubDelist => 'Cancella';

  @override
  String get bmHubFilterListingsTitle => 'Filtra elenchi';

  @override
  String get bmHubLabelCountry => 'Paese';

  @override
  String get bmHubAllCountries => 'Tutti i paesi';

  @override
  String get bmHubLabelVehicleType => 'Tipo di veicolo';

  @override
  String get bmHubAllTypes => 'Tutti i tipi';

  @override
  String get bmHubCars => 'Automobili';

  @override
  String get bmHubBoats => 'Barche';

  @override
  String get bmHubPriceRange => 'Fascia di prezzo';

  @override
  String get bmHubClearFilters => 'Cancella filtri';

  @override
  String get bmHubApply => 'Fare domanda a';

  @override
  String get bmHubBuyVehicleTitle => 'Acquista veicolo';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Acquistare $name per $price?';
  }

  @override
  String get bmHubVehiclePurchased => 'Veicolo acquistato con successo!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Impossibile acquistare il veicolo';

  @override
  String get bmHubNewPriceEuro => 'Nuovo prezzo (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Inserisci il nuovo prezzo';

  @override
  String get bmHubCurrentPrice => 'Prezzo attuale';

  @override
  String get bmHubPriceUpdated => 'Prezzo aggiornato con successo!';

  @override
  String get bmHubPriceUpdateFailed => 'Impossibile aggiornare il prezzo';

  @override
  String get bmHubUpdateButton => 'Aggiornamento';

  @override
  String get bmHubDelistVehicleTitle => 'Elimina veicolo';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Rimuovere $name dal mercato?';
  }

  @override
  String get bmHubVehicleDelisted => 'Veicolo cancellato con successo!';

  @override
  String get bmHubDelistFailed =>
      'Impossibile rimuovere il veicolo dalla lista';

  @override
  String get bmHubLocationUnknown => 'SCONOSCIUTA';

  @override
  String get bmHubNoMarketListingsTitle => 'Nessun annuncio';

  @override
  String get bmHubNoMarketListingsBody =>
      'Nessun veicolo o oggetto corrisponde ai filtri. Puoi mettere in vendita strumenti trasportati con Vendi oggetto.';

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
  String get bmHubSellCarriedItem => 'Vendi oggetto';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Qtà $qty • $pct% condizione';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Guida €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Acquista oggetto';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return 'Acquistare $name per $price?';
  }

  @override
  String get bmHubToolPurchased => 'Oggetto acquistato';

  @override
  String get bmHubToolPurchaseFailed => 'Acquisto non riuscito';

  @override
  String get bmHubDelistToolTitle => 'Rimuovi annuncio';

  @override
  String bmHubDelistToolConfirm(String name) {
    return 'Rimuovere $name dal mercato?';
  }

  @override
  String get bmHubToolDelisted => 'Annuncio rimosso';

  @override
  String get bmHubListToolTitle => 'Metti in vendita';

  @override
  String get bmHubListToolSelectLabel => 'Oggetto trasportato';

  @override
  String get bmHubListToolSubmit => 'Pubblica';

  @override
  String get bmHubToolListedMessage => 'Oggetto pubblicato';

  @override
  String get bmHubListToolFailed => 'Impossibile pubblicare';

  @override
  String get bmHubLoadCarriedToolsFailed => 'Impossibile caricare l’inventario';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'Nessun oggetto da vendere (o già in vendita)';

  @override
  String get bmHubInvalidToolPrice => 'Inserisci un prezzo valido';

  @override
  String get arrested => 'Arrestato!';

  @override
  String get jailMessage =>
      'Sei stato arrestato durante il tuo viaggio e tutti i beni sono stati confiscati!';

  @override
  String get confirmAction => 'Sei sicuro?';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle => 'Procedere alla tappa successiva?';

  @override
  String get travelContinueConfirmBody =>
      'Sono attivi i controlli alle frontiere. Continuare il tuo viaggio?';

  @override
  String get travelJourneyCompleteTitle => 'Viaggio completato';

  @override
  String get travelJourneyCompleteBody =>
      'Sei arrivato sano e salvo alla tua destinazione.';

  @override
  String get hitlist => 'Elenco dei risultati';

  @override
  String hitlistLoadError(String error) {
    return 'Errore durante il caricamento dell\'elenco dei risultati: $error';
  }

  @override
  String get noActiveHits => 'Nessun colpo attivo piazzato';

  @override
  String get selectTarget => 'Seleziona Obiettivo';

  @override
  String get searchPlayer => 'Cerca giocatore...';

  @override
  String get placeHitTitle => 'Posiziona il colpo';

  @override
  String get minimumBounty => 'Taglia minima: 50.000€';

  @override
  String get bountyAmount => 'Importo della ricompensa';

  @override
  String get place => 'Posto';

  @override
  String hitPlaced(String amount) {
    return 'Hit piazzato per €$amount';
  }

  @override
  String hitError(String error) {
    return 'Errore: $error';
  }

  @override
  String get hitDifferentCountry =>
      'Devi trovarti nello stesso Paese della destinazione';

  @override
  String get hitlistErrMissingBounty =>
      'L\'importo della ricompensa è obbligatorio';

  @override
  String get hitlistErrBountyTooLow => 'La taglia minima è di 50.000€';

  @override
  String get hitlistErrCannotHitYourself => 'Non puoi colpire te stesso';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Hai già un colpo attivo su questo giocatore';

  @override
  String get hitlistErrInsufficientMoney => 'Non hai abbastanza soldi';

  @override
  String get hitlistErrMissingCounterBounty =>
      'È richiesto l\'importo della contro-bontà';

  @override
  String get hitlistErrHitNotFound => 'Hit non trovato';

  @override
  String get hitlistErrNotTarget =>
      'Solo il bersaglio può effettuare una controfferta';

  @override
  String get hitlistErrHitNotActive => 'Il colpo non è attivo';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'La contro-taglia deve essere superiore alla taglia originale';

  @override
  String get hitlistErrMissingWeapon => 'È richiesta l\'arma';

  @override
  String get hitlistErrWeaponNotFound => 'Arma non trovata';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Non possiedi quest\'arma oppure è rotta';

  @override
  String get hitlistErrWeaponBroken =>
      'L\'arma selezionata è rotta. Riparalo prima.';

  @override
  String get hitlistErrInsufficientAmmo => 'Non hai abbastanza munizioni';

  @override
  String get hitlistErrInvalidAmmoHit => 'Quantità di munizioni non valida';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'Il bersaglio ha una protezione attiva dal colpo';

  @override
  String get hitlistErrInvalidInvestigationTier =>
      'Tipo di indagine non valido';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Per questo colpo è già in corso un\'indagine. Aspetta il tuo messaggio da detective.';

  @override
  String get hitlistErrInvalidCaseId =>
      'Numero di fascicolo del caso non valido';

  @override
  String get hitlistErrMurderCaseNotFound => 'Fascicolo del caso non trovato';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Il periodo di indagine è scaduto (24 ore)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Le indagini per questo caso sono già state avviate';

  @override
  String get hitlistErrNotPlacer => 'Solo il piazzatore può annullare il colpo';

  @override
  String get hitlistInvestigationOptions => 'Opzioni di indagine';

  @override
  String get hitlistInvestigationChooseSpeedPrice =>
      'Scegli velocità e prezzo:';

  @override
  String get hitlistInvestigationQuick =>
      'Indagine rapida (€1.000.000 • 1 ora)';

  @override
  String get hitlistInvestigationStandard =>
      'Indagine standard (€500.000 • 6 ore)';

  @override
  String get hitlistInvestigationSlow => 'Indagine lenta (€250.000 • 24 ore)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Indagini in coda. Costo $cost. ETA: $etaMinutes min. Il rapporto arriverà tramite messaggi dell\'ufficio investigativo (circa $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'L\'indagine è fallita';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'Non è stato possibile completare l\'indagine';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Colpo riuscito! Taglia e bottino ricevuto: contanti $cash, oggetti trasportati $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'Il tentativo di colpire è scaduto. Per favore riprova.';

  @override
  String get hitlistNoUsableWeapons =>
      'Non hai armi utilizzabili nel tuo inventario. Acquista o ripara prima un\'arma.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Errore durante il caricamento delle armi: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Errore durante il caricamento dei giocatori: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => '1 giorno fa';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count giorni fa';
  }

  @override
  String get counterBountyTitle => 'Posiziona la contro-taglia';

  @override
  String minimumAmount(String amount) {
    return 'Importo minimo: €$amount';
  }

  @override
  String get counterBountyAmount => 'Importo della contro-taglia';

  @override
  String counterBountyPlaced(String amount) {
    return 'Contro-bontà piazzata di €$amount';
  }

  @override
  String get cancelHitConfirmTitle => 'Annullare il colpo?';

  @override
  String get cancelHitConfirmBody => 'La tua ricompensa verrà rimborsata.';

  @override
  String get hitCancelled => 'Colpo annullato';

  @override
  String get target => 'Bersaglio';

  @override
  String get placer => 'Posizionatore';

  @override
  String get bounty => 'Taglia';

  @override
  String get counterBid => 'CONTRO OFFERTA';

  @override
  String get counterBidPlaced =>
      'Controofferta piazzata! Il contratto è stato invertito.';

  @override
  String get attemptHit => 'Tentativo di colpo';

  @override
  String get selectWeapon => 'Seleziona Arma e munizioni';

  @override
  String get youAreTargeted => 'Sei sulla lista dei risultati';

  @override
  String get security => 'Sicurezza';

  @override
  String get currentDefense => 'Difesa attuale';

  @override
  String get totalDefense => 'Difesa totale';

  @override
  String get currentArmor => 'Armatura attuale';

  @override
  String get bodyguards => 'Guardie del corpo';

  @override
  String get buyBodyguards => 'Compra Guardie del corpo';

  @override
  String get bodyguardPrice => 'Prezzo per guardia del corpo';

  @override
  String get armor => 'Armatura';

  @override
  String get protectorsFollow => 'Protettori che ti seguono';

  @override
  String get eachGivesDefense => 'Ciascuno dà +10 difesa';

  @override
  String get lightArmor => 'Armatura leggera';

  @override
  String get basicProtection => 'Protezione di base';

  @override
  String get heavyArmor => 'Armatura pesante';

  @override
  String get strongProtection => 'Protezione forte';

  @override
  String get bulletproofVest => 'Giubbotto antiproiettile';

  @override
  String get veryStrongProtection => 'Protezione molto forte';

  @override
  String get stabVest => 'Giubbotto antistilettata';

  @override
  String get stabVestDesc =>
      'Protegge dai coltelli. Debole contro i proiettili.';

  @override
  String get bulletproofVestDesc =>
      'Protezione standard contro munizioni ordinarie.';

  @override
  String get bulletproofVestPremium => 'Giubbotto antiproiettile premium';

  @override
  String get bulletproofVestPremiumDesc =>
      'Piastre più pesanti contro i colpi normali.';

  @override
  String get ceramicApVest => 'Giubbotto piastre AP';

  @override
  String get ceramicApVestDesc =>
      'Piastre in ceramica contro munizioni perforanti.';

  @override
  String get vestProtectsStab => 'Lama';

  @override
  String get vestProtectsBullets => 'Proiettili';

  @override
  String get vestProtectsAp => 'Perforante';

  @override
  String get tacticalSuit => 'Attrezzatura tattica';

  @override
  String get premiumProtection => 'Protezione premium';

  @override
  String get defense => 'Difesa';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'Hai acquistato $armor! +$defense difesa';
  }

  @override
  String get worn => 'Logora';

  @override
  String get replaceArmor => 'Sostituire';

  @override
  String get bodyguardProductName => 'Guardia del corpo';

  @override
  String securityLoadError(String error) {
    return 'Errore durante il caricamento della sicurezza: $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'Impossibile caricare lo stato di sicurezza.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Condizione $percent% · base $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Salario giornaliero $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Costo giornaliero del sistema: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Prossima busta paga: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Se non puoi pagare la paga giornaliera, tutte le guardie del corpo se ne vanno.';

  @override
  String get armorOneAtATimeHint =>
      'Puoi indossare solo 1 armatura alla volta. Una nuova armatura sostituisce sempre quella attuale.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Adesso +$defense al $percent%';
  }

  @override
  String get couldNotBuyBodyguard =>
      'Impossibile acquistare la guardia del corpo';

  @override
  String get couldNotBuyArmor => 'Impossibile acquistare l\'armatura';

  @override
  String get armorAlreadyEquippedLong =>
      'Indossi già quest\'armatura. Puoi indossare solo 1 armatura alla volta.';

  @override
  String get securityErrorArmorNotFound => 'Armatura non trovata';

  @override
  String get securityErrorMinQuantity => 'La quantità deve essere almeno 1';

  @override
  String get hit => 'COLPO';

  @override
  String get counterBidLabel => 'CONTRO OFFERTA';

  @override
  String daysAgo(String count, String plural) {
    return '$count giorno$plural fa';
  }

  @override
  String get justPlaced => 'Appena piazzato';

  @override
  String get youAreTheTarget => 'Tu sei l\'obiettivo';

  @override
  String get youAreThePlacer => 'Tu sei il posizionatore';

  @override
  String get onlyTargetCanCounterBid =>
      'Solo il bersaglio può effettuare una controfferta';

  @override
  String get executeHit => 'Esegui Colpo';

  @override
  String get moneyNotEnough => 'Non hai abbastanza soldi';

  @override
  String get securityScreen => 'Sicurezza';

  @override
  String get currentDefenseStatus => 'Stato attuale della difesa';

  @override
  String get noWeapons => 'Non hai armi nel tuo inventario';

  @override
  String get ammoQuantity => 'Quantità di munizioni';

  @override
  String get noAmmoRequired => 'Nessuna munizione richiesta per quest\'arma';

  @override
  String get weaponStats => 'Statistiche sulle armi';

  @override
  String get damage => 'Danno';

  @override
  String get intimidation => 'Intimidazione';

  @override
  String get execute => 'Eseguire';

  @override
  String get hitExecuted => 'Hit eseguito con successo!';

  @override
  String get invalidAmmo => 'Inserisci una quantità di munizioni valida';

  @override
  String get weaponsMarket => 'Mercato delle armi';

  @override
  String get ammoMarket => 'Mercato delle munizioni';

  @override
  String get shootingRange => 'Poligono di tiro';

  @override
  String get ammoFactory => 'Fabbrica di munizioni';

  @override
  String get weaponShop => 'Negozio di armi';

  @override
  String get myWeapons => 'Le mie armi';

  @override
  String get weaponPurchased => 'Arma acquistata';

  @override
  String weaponRankRequired(String rank) {
    return 'Grado richiesto: $rank';
  }

  @override
  String get buyWeapon => 'Acquistare';

  @override
  String get ammoShop => 'Mercato delle munizioni';

  @override
  String get myAmmo => 'Le mie munizioni';

  @override
  String get ammoPurchased => 'Munizioni acquistate';

  @override
  String get purchaseCooldown => 'Devi attendere prima del prossimo acquisto';

  @override
  String get insufficientStock => 'Scorte disponibili insufficienti';

  @override
  String get maxInventoryReached =>
      'Capacità massima dell\'inventario raggiunta';

  @override
  String get invalidQuantity => 'Quantità non valida';

  @override
  String get nextAmmoPurchase => 'Prossimo acquisto disponibile tra';

  @override
  String get ammoBoxes => 'Scatole';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds colpi per scatola';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Riceverai: $rounds colpi';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Costo totale: €$cost';
  }

  @override
  String get ammoRounds => 'colpi';

  @override
  String get ammoGeneric => 'Munizioni';

  @override
  String get ammoPerCrimeSuffix => 'per crimine';

  @override
  String get ammoBoxesUnit => 'scatole';

  @override
  String get ammoStock => 'Scorte';

  @override
  String get ammoQuality => 'Qualità';

  @override
  String get factoryBought => 'Acquistato in fabbrica';

  @override
  String get factoryProduced => 'Produzione aggiornata';

  @override
  String get factorySessionStarted =>
      'Inizio produzione: attivo per 8 ore, reclamo ogni 20 minuti';

  @override
  String get ammoFactoryTitle => 'Fabbrica di munizioni';

  @override
  String get ammoFactoryIntro =>
      'Produce in lotti; richiedi ogni 20 minuti (fino a 8 ore di arretrato per sessione).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Cosa puoi fare:';

  @override
  String get ammoFactoryActionBuy =>
      'Acquista una fabbrica nel tuo paese attuale';

  @override
  String get ammoFactoryActionProduce =>
      'Produzione di richieste (intervallo: 20 minuti, backlog massimo: 8 ore per sessione)';

  @override
  String get ammoFactoryActionOutput =>
      'Migliora l\'output al livello 5 per più round per richiesta';

  @override
  String get ammoFactoryActionQuality =>
      'Migliora la qualità per prezzi di mercato più forti';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munizioni in vendita';

  @override
  String get ammoFactoryBlackMarketBody =>
      'La fabbrica di munizioni non vende proiettili direttamente da questa schermata. Usa il mercato nero per acquistare e vendere munizioni.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Acquista e vendi munizioni attraverso il mercato nero, non direttamente dalla fabbrica.';

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
  String get ammoFactoryErrCountryRequired => 'Il Paese è obbligatorio';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Giocatore non trovato';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Devi essere nello stesso paese per acquistare questa fabbrica';

  @override
  String get ammoFactoryErrCouldNotPurchase =>
      'Impossibile acquistare la fabbrica';

  @override
  String get ammoFactoryErrAlreadyOwned => 'La fabbrica è già di proprietà';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Non abbastanza soldi per comprare la fabbrica';

  @override
  String get ammoFactoryErrCouldNotProduce => 'Impossibile produrre munizioni';

  @override
  String get ammoFactoryErrNotOwned => 'Non possiedi una fabbrica';

  @override
  String get ammoFactoryErrOnCooldown =>
      'La fabbrica è in fase di raffreddamento';

  @override
  String get ammoFactoryErrInactive =>
      'Perdita della proprietà della fabbrica a causa dell\'inattività';

  @override
  String get ammoFactoryErrCouldNotUpgrade =>
      'Impossibile aggiornare la fabbrica';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Non abbastanza soldi per aggiornare la fabbrica';

  @override
  String get ammoFactoryErrMaxLevel => 'La fabbrica è già al livello massimo';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Il tipo di aggiornamento deve essere output o qualità';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Requisiti di istruzione non soddisfatti';

  @override
  String get factoryUpgradeOutputSuccess => 'Uscita aggiornata';

  @override
  String get factoryUpgradeQualitySuccess => 'Qualità migliorata';

  @override
  String get myFactory => 'La mia fabbrica';

  @override
  String get noFactoryOwned => 'Non possiedi una fabbrica';

  @override
  String get factoryCountry => 'Paese';

  @override
  String get factoryOutputLevel => 'Livello di uscita';

  @override
  String get factoryQualityLevel => 'Livello di qualità';

  @override
  String get factoryLastProduced => 'Ultimo prodotto';

  @override
  String get factoryProduceStatusLabel => 'Stato produzione';

  @override
  String get factoryProduceStatusReady => 'Pronto';

  @override
  String get factoryProduceStatusCooldown => 'In attesa';

  @override
  String get factorySessionActive =>
      'Finestra di produzione: attiva (intervallo di 20 minuti)';

  @override
  String get factorySessionStopped =>
      'Finestra di produzione: interrotta (fai clic su Produci per avviare una nuova finestra di 8 ore)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'La finestra termina con: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Prossima produzione: disponibile ora (premi Produci per richiedere)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Prossima produzione tra: $duration';
  }

  @override
  String get factoryProduce => 'Produrre';

  @override
  String get factoryUpgradeOutput => 'Aggiorna uscita';

  @override
  String get factoryUpgradeQuality => 'Migliora la qualità';

  @override
  String get factoryList => 'Fabbriche per Paese';

  @override
  String get factoryUnowned => 'Disponibile';

  @override
  String factoryOwnedBy(String owner) {
    return 'Proprietario: $owner';
  }

  @override
  String get factoryBuy => 'Acquistare';

  @override
  String get shootingIntro =>
      'Migliora la tua precisione e aumenta il tasso di successo del crimine';

  @override
  String get shootingTrainSuccess => 'Formazione completata';

  @override
  String get shootingMaxSessionsReached =>
      'Raggiunto il numero massimo di sessioni di allenamento';

  @override
  String get shootingTrainingProgressTitle => 'Progresso della formazione';

  @override
  String get shootingSessionsCompletedLabel => 'Sessioni completate:';

  @override
  String get shootingProgressCompleteSuffix => 'completare';

  @override
  String get shootingCurrentBonusTitle => 'Bonus attuale';

  @override
  String get shootingAccuracyBonusLabel => 'Bonus di precisione';

  @override
  String get shootingMaximumLabel => 'Massimo';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Questo bonus viene applicato a tutti i tuoi tentativi di crimine';

  @override
  String get shootingReadyToTrain => 'Pronti per allenarsi';

  @override
  String get shootingTrainingCooldownTitle => 'Recupero dell\'allenamento';

  @override
  String shootingCooldownLabel(String time) {
    return 'Prossima sessione alle: $time';
  }

  @override
  String get shootingCooldownHint =>
      'È necessario attendere 1 ora tra le sessioni di allenamento';

  @override
  String get shootingTrainingInProgress => 'Formazione...';

  @override
  String get shootingHowItWorksTitle => 'Come funziona?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Allenati ogni ora per aumentare la precisione';

  @override
  String get shootingHowItWorksBullet2 => '• Ogni sessione dà +0,1% di bonus';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Massimo di 100 sessioni (+10% totale)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Aumenta il tasso di successo del crimine';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Bonus permanente, ogni sessione conta';

  @override
  String shootingSessions(String count) {
    return 'Sessioni: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Bonus precisione: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Prossima sessione alle $time';
  }

  @override
  String get shootingTrain => 'Allenati';

  @override
  String get trainingHubMenuLabel => 'Formazione';

  @override
  String get trainingHubTitle => 'Centro di formazione';

  @override
  String get trainingHubSubtitle =>
      'Sviluppa forza in palestra e precisione sul poligono. Ogni traccia accumula fino a 100 sessioni con un tempo di recupero di 1 ora e aumenta le tue possibilità di successo nel crimine.';

  @override
  String get trainingHubSectionGym => 'Palestra';

  @override
  String get trainingHubSectionShooting => 'Poligono di tiro';

  @override
  String get trainingHubRefreshStatus => 'Aggiorna';

  @override
  String get trainingHubRefreshTooltip => 'Ricarica lo stato dal server';

  @override
  String get trainingHubOpenCrimes => 'Crimini aperti';

  @override
  String get trainingHubOpenCrimesHint =>
      'I bonus attivi vengono visualizzati nella schermata Crimini.';

  @override
  String get trainingHubMoreInfoTitle => 'Maggiori informazioni e opzioni';

  @override
  String get trainingHubMoreInfoCombo =>
      'Stesso giorno di calendario UTC: completa almeno una sessione di palestra e una sessione di poligono per un piccolo bonus extra per il successo del crimine (+0,5%).';

  @override
  String get trainingHubMoreInfoSeparate =>
      'La palestra e il poligono mantengono ciascuno il proprio tempo di recupero di 1 ora e il limite di 100 sessioni.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'I progressi del poligono di tiro alimentano anche i calcoli della lista dei risultati sul server.';

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
    return 'Combo attiva: +$pct% sui crimini';
  }

  @override
  String get gym => 'Palestra';

  @override
  String get gymIntro =>
      'Allena la tua forza e aumenta il tasso di successo del crimine';

  @override
  String get gymTrainSuccess => 'Formazione completata';

  @override
  String get gymMaxSessionsReached => 'Raggiunto il numero massimo di sessioni';

  @override
  String get gymTrainingProgressTitle => 'Progresso della formazione';

  @override
  String get gymSessionsCompletedLabel => 'Sessioni completate:';

  @override
  String get gymProgressCompleteSuffix => 'completare';

  @override
  String get gymCurrentBonusTitle => 'Bonus attuale';

  @override
  String gymSessions(String count) {
    return 'Sessioni: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Bonus Forza';

  @override
  String get gymMaximumLabel => 'Massimo';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonus Forza: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Questo bonus viene applicato a tutti i tuoi tentativi di crimine';

  @override
  String get gymReadyToTrain => 'Pronti per allenarsi';

  @override
  String get gymTrainingCooldownTitle => 'Recupero dell\'allenamento';

  @override
  String gymCooldown(String time) {
    return 'Prossima sessione alle $time';
  }

  @override
  String get gymCooldownHint =>
      'È necessario attendere 1 ora tra le sessioni di allenamento';

  @override
  String get gymTrain => 'Treno';

  @override
  String get gymTrainingInProgress => 'Formazione...';

  @override
  String get gymHowItWorksTitle => 'Come funziona?';

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
      '• Allenati ogni ora per aumentare la forza';

  @override
  String get gymHowItWorksBullet2 => '• Ogni sessione dà +0,08% di bonus';

  @override
  String get gymHowItWorksBullet3 => '• Massimo di 100 sessioni (+8% totale)';

  @override
  String get gymHowItWorksBullet4 =>
      '• Aumenta il tasso di successo del crimine';

  @override
  String get gymHowItWorksBullet5 => '• Bonus permanente, ogni sessione conta';

  @override
  String get buyAmmo => 'Acquista munizioni';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Costo di acquisto: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Produzione per ciclo: $amount unità';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Moltiplicatore di qualità: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Migliora output - Costo: €$cost, output successivo: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Qualità di aggiornamento - Costo: €$cost, Qualità successiva: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Costo';

  @override
  String get factoryCurrentOutput => 'Uscita corrente';

  @override
  String get factoryNextOutput => 'Uscita successiva';

  @override
  String get factoryCurrentQuality => 'Qualità attuale';

  @override
  String get factoryNextQuality => 'La prossima qualità';

  @override
  String get factoryUnitsPerCycle => 'unità/8 ore max';

  @override
  String get factoryUnitsPerHour => 'unità/ora';

  @override
  String get factoryUpgradeMaxLevel => 'La fabbrica è al livello massimo';

  @override
  String get countryUsa => 'U.S.A.';

  @override
  String get countryMexico => 'Messico';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryBrazil => 'Brasile';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryJapan => 'Giappone';

  @override
  String get countryChina => 'Cina';

  @override
  String get countryRussia => 'Russia';

  @override
  String get countryIndia => 'India';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countrySouthAfrica => 'Sudafrica';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryPortugal => 'Portogallo';

  @override
  String get countryIreland => 'Irlanda';

  @override
  String get countryLuxembourg => 'Lussemburgo';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryDenmark => 'Danimarca';

  @override
  String get countrySweden => 'Svezia';

  @override
  String get countryNorway => 'Norvegia';

  @override
  String get countryFinland => 'Finlandia';

  @override
  String get countryPoland => 'Polonia';

  @override
  String get countryCzechia => 'Cechia';

  @override
  String get countryGreece => 'Grecia';

  @override
  String get countryTurkey => 'Tacchina';

  @override
  String get countryUae => 'Emirati Arabi Uniti';

  @override
  String get countryDubai => 'Dubai';

  @override
  String get toolBoltCutter => 'Tagliabulloni';

  @override
  String get toolCarTheftTools => 'Strumenti per il furto d\'auto';

  @override
  String get toolBurglaryKit => 'Kit antifurto';

  @override
  String get toolToolbox => 'Cassetta degli attrezzi';

  @override
  String get toolCrowbar => 'Piede di porco';

  @override
  String get toolGlassCutter => 'Tagliavetro';

  @override
  String get toolSprayPaint => 'Vernice spray';

  @override
  String get toolJerryCan => 'Tanica';

  @override
  String get toolFakeDocuments => 'Documenti falsi';

  @override
  String get toolHackingLaptop => 'Hacking del computer portatile';

  @override
  String get toolCounterfeitingKit => 'Kit di contraffazione';

  @override
  String get toolRope => 'Corda';

  @override
  String get toolSilencer => 'Silenziatore';

  @override
  String get toolNightVision => 'Visione notturna';

  @override
  String get toolGpsJammer => 'Jammer GPS';

  @override
  String get toolBurnerPhone => 'Telefono bruciato';

  @override
  String get toolThermalDrill => 'Trapano termico';

  @override
  String get toolCategoryBoltCutter => 'Tagliabulloni';

  @override
  String get toolCategoryBurglaryKit => 'Kit antifurto';

  @override
  String get toolCategoryCarTools => 'Strumenti per il furto d\'auto';

  @override
  String get toolCategoryJerryCan => 'Tanica';

  @override
  String get toolCategorySprayPaint => 'Vernice spray';

  @override
  String get toolCategoryCrowbar => 'Piede di porco';

  @override
  String get toolCategoryGlassCutter => 'Tagliavetro';

  @override
  String get toolCategoryLaptop => 'Computer portatile';

  @override
  String get toolCategoryCounterfeiting => 'Contraffazione';

  @override
  String get toolCategoryToolbox => 'Cassetta degli attrezzi';

  @override
  String get toolCategoryRope => 'Corda';

  @override
  String get toolCategorySilencer => 'Silenziatore';

  @override
  String get toolCategoryFakeDocs => 'Documenti falsi';

  @override
  String get toolCategoryNightVision => 'Visione notturna';

  @override
  String get toolCategoryBurnerPhone => 'Telefono prepagato';

  @override
  String get toolCategoryGpsJammer => 'Disturbatore GPS';

  @override
  String get toolCategoryThermalDrill => 'Trapano termico';

  @override
  String get toolsScreenTitle => 'Mercato nero – Strumenti';

  @override
  String get toolsTabBuy => 'Acquistare';

  @override
  String get toolsTabMyTools => 'I miei strumenti';

  @override
  String get toolsNoToolsAvailable => 'Nessuno strumento disponibile';

  @override
  String get toolsEmptyInventoryTitle => 'Non hai ancora nessuno strumento';

  @override
  String get toolsEmptyInventoryHint => 'Acquista gli strumenti nel negozio';

  @override
  String get toolsNotEnoughMoney => 'Non hai abbastanza soldi!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'Non hai abbastanza soldi per la riparazione!';

  @override
  String get toolsBuyError => 'Errore durante l\'acquisto';

  @override
  String get toolsRepairError => 'Errore durante la riparazione';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName acquistato!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName riparato per €$cost';
  }

  @override
  String get toolsBadgeInventoryFull => 'PIENA';

  @override
  String get toolsBadgeBroken => 'ROTTA';

  @override
  String get toolsBadgeRepair => 'RIPARAZIONE';

  @override
  String toolsLoadError(String error) {
    return 'Impossibile caricare gli strumenti: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Strumento non trovato.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Il tuo inventario è pieno. Conserva alcuni strumenti o aggiorna la capacità.';

  @override
  String get toolsErrPurchaseServer =>
      'L\'acquisto dello strumento non è riuscito a causa di un problema con il server.';

  @override
  String get toolsErrToolNotOwned => 'Non possiedi questo strumento.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'Lo strumento è già alla massima durata.';

  @override
  String get toolsErrRepairServer =>
      'La riparazione dello strumento non è riuscita a causa di un problema del server.';

  @override
  String toolsNetworkError(String error) {
    return 'Errore di rete: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Crimine riuscito!';

  @override
  String get crimeOutcomeFailed => 'Crimine fallito';

  @override
  String get jobOutcomeSuccess => 'Lavoro completato!';

  @override
  String get crimeOutcomeCaught => 'Catturato dalla polizia';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Il tuo veicolo si è rotto prima di raggiungere la scena del crimine';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Il veicolo si è rotto durante la fuga e ha abbandonato la maggior parte del bottino';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Rimase senza carburante durante la fuga: fuggì a piedi, perse bottino e veicolo';

  @override
  String get crimeOutcomeToolBroke =>
      'Il tuo attrezzo si è rotto durante il crimine, lasciando delle prove';

  @override
  String get crimeOutcomeFledNoLoot => 'Sono fuggito dalla scena senza bottino';

  @override
  String get crimeResultMoneyLabel => 'Soldi';

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
  String get crimeOutcomeRowReward => 'Ricompensa:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Utensili:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% di durabilità';
  }

  @override
  String get icuIntensiveCareTitle => 'Terapia intensiva';

  @override
  String get icuInjuredLine =>
      'Sei stato gravemente ferito durante le tue attività criminali.';

  @override
  String get icuUnconsciousLine =>
      'Ora sei in terapia intensiva e privo di sensi.';

  @override
  String get icuRecoveryTimeLabel => 'Tempo di recupero:';

  @override
  String get icuWakeHp => 'Ti svegli con 10 HP';

  @override
  String get icuNoActionsHint =>
      'Non è possibile eseguire azioni durante questo periodo. \nStai più attento alla tua salute!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Sei libero! Cauzione pagata: €$amount';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Soldi insufficienti per la cauzione (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Si prega di attendere: ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => 'La fuga è riuscita! Sei libero.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'La fuga è fallita. Frase estesa di $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'La fuga è fallita';

  @override
  String jailErrorPrefix(String message) {
    return 'Errore: $message';
  }

  @override
  String get jailTimeLeft => 'Tempo rimasto';

  @override
  String jailPayBail(int amount) {
    return 'Pagare la cauzione (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Non puoi commettere crimini, lavorare o viaggiare mentre stai scontando la pena.';

  @override
  String get jailAttemptEscape => 'Tentativo di fuga';

  @override
  String get jailYouAreInJail => 'Sei in prigione';

  @override
  String get vehicleCondition => 'Condizione';

  @override
  String get vehicleFuel => 'Carburante';

  @override
  String get vehicleSpeed => 'Velocità';

  @override
  String get vehicleArmor => 'Armatura';

  @override
  String get vehicleStealth => 'Furtività';

  @override
  String get vehicleCargo => 'Carico';

  @override
  String get vehicleRepair => 'Riparazione';

  @override
  String get vehicleRefuel => 'Fare rifornimento';

  @override
  String get selectCrimeVehicle => 'Seleziona Veicolo per crimini';

  @override
  String get noVehicleSelected => 'Nessun veicolo selezionato';

  @override
  String get selectedVehicle => 'Veicolo del crimine';

  @override
  String get changeVehicle => 'Cambia veicolo';

  @override
  String get selectVehicle => 'Seleziona Veicolo';

  @override
  String get vehicleConditionLow => 'Condizioni del veicolo basse';

  @override
  String get vehicleFuelLow => 'Carburante del veicolo basso';

  @override
  String get vehicleSelectedForCrimes => 'Veicolo selezionato per crimini!';

  @override
  String get vehicleDeselectedForCrimes => 'Veicolo deselezionato per reati!';

  @override
  String get vehicleWrongCountry =>
      'Il veicolo deve trovarsi nel tuo stesso Paese';

  @override
  String get failedSelectVehicle => 'Impossibile selezionare il veicolo';

  @override
  String get failedDeselectVehicle => 'Impossibile deselezionare il veicolo';

  @override
  String get selectedForCrimesBadge => 'Selezionato per crimini';

  @override
  String get selectedButton => 'Selezionata';

  @override
  String get selectButton => 'Selezionare';

  @override
  String get deselectButton => 'Deseleziona';

  @override
  String get prostitutionTitle => 'Prostituzione';

  @override
  String get prostitutionTotal => 'Totale';

  @override
  String get prostitutionStreet => 'In strada';

  @override
  String get prostitutionRedLight => 'Luce rossa';

  @override
  String get prostitutionPotentialEarnings => 'Guadagni';

  @override
  String get prostitutionCollect => 'Raccogliere';

  @override
  String get prostitutionRecruit => 'Reclutare';

  @override
  String get prostitutionMyProstitutes => 'Le mie prostitute';

  @override
  String get prostitutionRedLightDistricts => 'Quartieri a luci rosse';

  @override
  String get prostitutionNoProstitutes => 'Nessuna prostituta ancora reclutata';

  @override
  String get prostitutionLocation => 'Posizione';

  @override
  String get prostitutionMoveToRedLight => 'Vai al quartiere a luci rosse';

  @override
  String get prostitutionMoveToRldShort => 'Al RLD';

  @override
  String get prostitutionMoveToStreet => 'Spostati in strada';

  @override
  String get prostitutionViewDistricts => 'Visualizza distretti';

  @override
  String get prostitutionAvailable => 'Disponibile';

  @override
  String get prostitutionMyDistricts => 'I miei distretti';

  @override
  String get prostitutionCurrentRLD => 'RLD attuale';

  @override
  String get prostitutionMyRLDs => 'I miei RLD';

  @override
  String get prostitutionNoAvailableDistricts => 'Nessun distretto disponibile';

  @override
  String get prostitutionNoOwnedDistricts =>
      'Non possiedi ancora nessun distretto';

  @override
  String get prostitutionRooms => 'stanze';

  @override
  String get prostitutionOccupancy => 'Occupazione';

  @override
  String get prostitutionIncome => 'Reddito';

  @override
  String get prostitutionTenants => 'Inquiline';

  @override
  String get prostitutionBuy => 'Acquistare';

  @override
  String get prostitutionManage => 'Maneggio';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Compra Distretto';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Sei sicuro di voler acquistare il quartiere a luci rosse a $country per €$price?';
  }

  @override
  String get prostitutionPurchase => 'Acquistare';

  @override
  String get prostitutionPurchaseSuccess =>
      'Distretto acquistato con successo!';

  @override
  String get prostitutionPurchaseFailed => 'Acquisto fallito';

  @override
  String get prostitutionDistrictManagement => 'Gestione del distretto';

  @override
  String get prostitutionDistrictNotFound => 'Distretto non trovato';

  @override
  String get prostitutionDistrictOwnedBadge => 'Posseduta';

  @override
  String get prostitutionOwnerLabel => 'Proprietaria:';

  @override
  String get prostitutionForSale => 'In vendita';

  @override
  String get prostitutionRoomsLabel => 'Camere:';

  @override
  String get prostitutionRoomsRented => 'affittata';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Distretto a luci rosse ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Occupata';

  @override
  String get prostitutionNotApplicable => 'N / A';

  @override
  String get back => 'Indietro';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Sei sicuro di volerti spostare $name dal quartiere a luci rosse alla strada?';
  }

  @override
  String get prostitutionMoveSuccess => 'Spostato con successo';

  @override
  String get prostitutionMoveFailed => 'Spostamento fallito';

  @override
  String get prostitutionNoStreetProstitutes =>
      'Nessuna prostituta disponibile per strada';

  @override
  String get prostitutionSelectProstitute => 'Seleziona Prostituta';

  @override
  String get prostitutionOnStreet => 'Per strada';

  @override
  String get prostitutionRoom => 'Camera';

  @override
  String get prostitutionInRedLight => 'Nel quartiere a luci rosse';

  @override
  String get prostitutionEarnings => 'Guadagni';

  @override
  String get prostitutionRent => 'Affitto';

  @override
  String get prostitutionNetIncome => 'Reddito netto';

  @override
  String get prostitutionLevel => 'Livello';

  @override
  String get prostitutionXpToNext => 'XP al livello successivo';

  @override
  String get prostitutionBusted => 'ARRESTATA';

  @override
  String get prostitutionBustedCount => 'Tempi rotti';

  @override
  String get prostitutionLevelBonus => 'Bonus di livello';

  @override
  String get prostitutionVipBonus => 'Bonus VIP: +50% di guadagno';

  @override
  String get prostitutionUpgradeTier => 'Migliora il livello';

  @override
  String get prostitutionUpgradeSecurity => 'Migliora la sicurezza';

  @override
  String get prostitutionTier => 'Livello';

  @override
  String get prostitutionSecurity => 'Sicurezza';

  @override
  String get prostitutionTierBasic => 'Di base';

  @override
  String get prostitutionTierLuxury => 'Lusso';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Livello di sicurezza';

  @override
  String get prostitutionRaidChance => 'Possibilità di raid';

  @override
  String get prostitutionMaxTier => 'Livello massimo raggiunto';

  @override
  String get prostitutionMaxSecurity => 'Sicurezza massima raggiunta';

  @override
  String get prostitutionUpgradeSuccess => 'Aggiornamento riuscito!';

  @override
  String get prostitutionUpgradeFailed => 'Aggiornamento non riuscito';

  @override
  String get prostitutionTabWorkers => 'Lavoratori';

  @override
  String get prostitutionTabRld => 'RLD';

  @override
  String get prostitutionTabEvents => 'Eventi';

  @override
  String get prostitutionTabSocial => 'Sociale';

  @override
  String get prostitutionRecruitCeremonyTitle => 'Nuova recluta';

  @override
  String prostitutionCollectConfirm(String amount) {
    return 'Raccogli €$amount di guadagni in sospeso?';
  }

  @override
  String get prostitutionCollectEmpty =>
      'Nessun guadagno da riscuotere in questo momento.';

  @override
  String prostitutionCollectSuccess(String amount) {
    return 'Raccolti €$amount.';
  }

  @override
  String get prostitutionCollectFailed => 'Impossibile riscuotere i guadagni.';

  @override
  String get prostitutionWorkersKpi => 'Lavoratori (S/RLD/NC)';

  @override
  String get prostitutionHourlyKpi => '€/ora';

  @override
  String get prostitutionRecruitReady => 'Pronta';

  @override
  String get prostitutionRetry => 'Riprova';

  @override
  String get prostitutionMove => 'Mossa';

  @override
  String get prostitutionFbiHeat => 'Calore dell\'FBI';

  @override
  String get prostitutionRaidStatsTitle => 'Rischio raid';

  @override
  String get prostitutionRaidStatsDistricts => 'Distretti';

  @override
  String get prostitutionRaidStatsBusted => 'Attualmente arrestato';

  @override
  String prostitutionUpgradeTierConfirm(String tier, String cost) {
    return 'Passa al livello $tier per €$cost?';
  }

  @override
  String prostitutionUpgradeSecurityConfirm(String level, String cost) {
    return 'Aggiorna la sicurezza al livello $level per €$cost?';
  }

  @override
  String prostitutionRoomsOccupied(String occupied, String total) {
    return '$occupied/$total stanze';
  }

  @override
  String prostitutionNextEarnings(String net) {
    return 'Successivo: €$net/h netti';
  }

  @override
  String prostitutionCurrentEarningsNet(String net) {
    return 'Adesso: €$net/h netti';
  }

  @override
  String prostitutionRaidReduction(String pct) {
    return 'Riduzione del raid: $pct';
  }

  @override
  String get vipEventsTitle => 'Eventi VIP';

  @override
  String get vipEventsTabTitle => 'Eventi VIP';

  @override
  String get vipEventsDescription =>
      'Assegna prostitute a eventi VIP per guadagni bonus!';

  @override
  String get vipEventsActive => 'Eventi attivi';

  @override
  String get vipEventsUpcoming => 'Prossimi eventi';

  @override
  String get vipEventsMyParticipations => 'Le mie partecipazioni attive';

  @override
  String get vipEventTypeTitle => 'Evento VIP';

  @override
  String get vipEventCelebrity => 'Visita di celebrità';

  @override
  String get vipEventBachelor => 'Addio al celibato';

  @override
  String get vipEventConvention => 'Convenzione';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'BONUS';

  @override
  String get vipEventSpots => 'macchie';

  @override
  String get vipEventParticipants => 'Partecipanti';

  @override
  String get vipEventFull => 'EVENTO COMPLETO';

  @override
  String get vipEventRequires => 'Richiede';

  @override
  String get vipEventLevel => 'Livello';

  @override
  String get vipEventLocation => 'Posizione';

  @override
  String get vipEventEndsIn => 'Finisce dentro';

  @override
  String get vipEventStartsIn => 'Inizia tra';

  @override
  String get vipEventNoActive => 'Nessun evento attivo al momento';

  @override
  String get vipEventNoUpcoming => 'Nessun evento in programma';

  @override
  String get vipEventAssignProstitute => 'Assegna Prostituta';

  @override
  String get vipEventAssignDialogTitle => 'Assegna a';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Nessuna prostituta idonea. Hai bisogno del livello $level+ in $country';
  }

  @override
  String get vipEventJoinSuccess => 'Evento partecipato!';

  @override
  String get vipEventJoinFailed => 'Impossibile partecipare all\'evento';

  @override
  String get vipEventLeave => 'Lascia l\'evento';

  @override
  String get vipEventLeaveSuccess => 'Evento a sinistra';

  @override
  String get vipEventLeaveFailed => 'Impossibile abbandonare l\'evento';

  @override
  String get vipEventAssigned => 'Assegnato';

  @override
  String get vipEventPerHour => '/ora';

  @override
  String get vipEventEarnings => 'Guadagni';

  @override
  String get prostitutionLeaderboardTitle => 'Classifica della prostituzione';

  @override
  String get prostitutionLeaderboardWeekly => 'Settimanale';

  @override
  String get prostitutionLeaderboardMonthly => 'Mensile';

  @override
  String get prostitutionLeaderboardAllTime => 'Di tutti i tempi';

  @override
  String get prostitutionLeaderboardYourRank => 'La tua classifica settimanale';

  @override
  String get prostitutionLeaderboardUnranked => 'Non classificato';

  @override
  String get prostitutionLeaderboardNoData =>
      'Nessun dato sulla classifica ancora';

  @override
  String get prostitutionLeaderboardButton => 'Classifica';

  @override
  String get prostitutionRivalryButton => 'Rivalità';

  @override
  String get prostitutionLeaderboardAchievements => 'Risultati';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'Impossibile caricare la classifica';

  @override
  String get achievementsTitle => 'Risultati';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked di $total sbloccato';
  }

  @override
  String get achievementsCategoryAll => 'Tutto';

  @override
  String get achievementsCategoryProgression => 'Progressione';

  @override
  String get achievementsCategoryWealth => 'Ricchezza';

  @override
  String get achievementsCategoryPower => 'Energia';

  @override
  String get achievementsCategorySocial => 'Sociale';

  @override
  String get achievementsCategoryMastery => 'Padronanza';

  @override
  String get achievementLocked => 'Bloccato';

  @override
  String get achievementReward => 'Ricompensa';

  @override
  String get achievementUnlocked => 'Sbloccato';

  @override
  String get achievementNoData => 'Nessun risultato trovato';

  @override
  String get achievementLoadFailed => 'Impossibile caricare gli obiettivi';

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
    return 'Sbloccato il $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Avanzamento: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Nessun premio ancora configurato';

  @override
  String get achievementsRewardOnUnlock =>
      'Riceverai questa ricompensa una volta sbloccato l\'obiettivo.';

  @override
  String get achievementsDateToday => 'Oggi';

  @override
  String get achievementsDateYesterday => 'Ieri';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days giorni fa';
  }

  @override
  String get achievementsDetails => 'Dettagli';

  @override
  String get achievementsCategory => 'Categoria';

  @override
  String get achievementsSectionProgress => 'Progresso';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent % completato';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostituzione';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Crimini';

  @override
  String get achievementsCategoryNameJobs => 'Lavori';

  @override
  String get achievementsCategoryNameSchool => 'Scuola';

  @override
  String get achievementsCategoryNameVehicles => 'Veicoli';

  @override
  String get achievementsCategoryNameTravel => 'Viaggi';

  @override
  String get achievementsCategoryNameDrugs => 'Droga';

  @override
  String get achievementsCategoryNameTrade => 'Commercio';

  @override
  String get achievementsCategoryNameGeneral => 'Generale';

  @override
  String get achievementJobItSpecialistTitle => 'Specialista informatico';

  @override
  String get achievementJobItSpecialistDescription =>
      'Completa il tuo primo turno come programmatore';

  @override
  String get achievementJobLawyerTitle => 'Avvocato di strada';

  @override
  String get achievementJobLawyerDescription =>
      'Completa il tuo primo turno come avvocato';

  @override
  String get achievementJobDoctorTitle => 'Dottore sotterraneo';

  @override
  String get achievementJobDoctorDescription =>
      'Completa il tuo primo turno come medico';

  @override
  String get achievementSchoolCertifiedTitle => 'Studente certificato';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Ottieni 3 certificazioni scolastiche';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multicertificazione';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Ottieni 6 certificazioni scolastiche';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Specialista della pista';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Ottieni un massimo di 3 percorsi scolastici';

  @override
  String get schoolMenuLabel => 'Scuola';

  @override
  String get schoolMenuSubtitle =>
      'Migliora la tua istruzione e le tue certificazioni';

  @override
  String get schoolTitle => 'Scuola e istruzione';

  @override
  String get schoolIntro =>
      'Sblocca posti di lavoro e risorse attraverso livelli e certificazioni.';

  @override
  String get schoolTracksTitle => 'Educazioni disponibili';

  @override
  String get schoolUnlockableContentTitle => 'Educazioni bloccate';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Livello scolastico: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Impossibile caricare i dati della scuola: $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Liv $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'XP: $xp';
  }

  @override
  String schoolTrainBonusLevels(int count) {
    return '+$count liv.';
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
    return '$name (Lv $level)';
  }

  @override
  String get schoolGateStatusOpen => 'APRIRE';

  @override
  String get schoolGateStatusLocked => 'BLOCCATO';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Grado del giocatore: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track livello: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Lavoro: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Asset: acquisto del casinò';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Risorsa: acquisto di una fabbrica di munizioni';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Risorsa: potenziamento della produzione di munizioni';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Risorsa: aggiornamento della qualità delle munizioni';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Risorsa: potenziamento slot struttura farmaceutica I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Risorsa: potenziamento slot struttura farmaceutica II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Risorsa: potenziamento slot struttura farmaceutica III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Risorsa: potenziamento slot struttura farmaceutica IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Risorsa: potenziamento delle attrezzature della struttura farmaceutica I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Risorsa: Aggiornamento delle attrezzature della struttura farmaceutica II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Risorsa: Aggiornamento delle attrezzature della struttura farmaceutica III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Risorsa: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Istruzione richiesta';

  @override
  String get educationDialogFallbackMessage =>
      'Requisiti non soddisfatti. Completare i requisiti di istruzione per continuare.';

  @override
  String get educationDialogClose => 'Vicina';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Lavori bloccati (istruzione richiesta)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Aggiornamento dell\'output bloccato';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Aggiornamento qualità bloccato';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Acquisto in fabbrica bloccato';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Serve il grado del giocatore $requiredRank · Grado del giocatore attuale $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Livello di istruzione';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName livello $requiredLevel richiesto · Attuale $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle =>
      'Certificazione richiesta';

  @override
  String get educationRequirementGenericTitle => 'Requisito';

  @override
  String get educationRequirementUnknown => 'Requisito sconosciuto';

  @override
  String get educationTrackNameAviation => 'Aviazione';

  @override
  String get educationTrackNameLaw => 'Legge';

  @override
  String get educationTrackNameMedicine => 'Medicinale';

  @override
  String get educationTrackNameFinance => 'Finanza';

  @override
  String get educationTrackNameEngineering => 'Ingegneria';

  @override
  String get educationTrackNameIt => 'IT';

  @override
  String get educationTrackNameNarcotics => 'Ingegneria dei narcotici';

  @override
  String get schoolTrackDescriptionAviation =>
      'Teoria del volo, navigazione e funzionamento dell\'aereo.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Diritto penale, procedura e pratica giudiziale.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Risposta alle emergenze, diagnostica e pratica medica.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Contabilità, investimenti e operazioni commerciali.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Sistemi meccanici, sicurezza industriale e produzione.';

  @override
  String get schoolTrackDescriptionIt =>
      'Sviluppo di software, sistemi e operazioni di rete.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Coltivazione controllata, processi elettrici e produzione chimica avanzata.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Tempo di recupero attivo: ${seconds}s rimanenti';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'La traccia è già al livello massimo';

  @override
  String get schoolTrackStartFailed => 'Impossibile avviare l\'allenamento';

  @override
  String get educationCertHydroponicSpecialist =>
      'Certificazione di specialista in coltura idroponica';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Certificazione di specialista in componenti elettrici di processo';

  @override
  String get educationCertClandestineChemist =>
      'Certificazione di chimico clandestino';

  @override
  String get educationCertNarcoGridArchitect =>
      'Certificazione di Narco Grid Architect';

  @override
  String get educationCertSoftwareEngineer =>
      'Certificazione di ingegnere del software';

  @override
  String get educationCertBarExam => 'Esame di avvocato';

  @override
  String get educationCertMedicalLicense => 'Licenza medica';

  @override
  String get educationCertFlightCommercial => 'Licenza di volo commerciale';

  @override
  String get educationCertFlightBasic => 'Licenza di volo base';

  @override
  String get educationCertIndustrialSafety =>
      'Certificazione di sicurezza industriale';

  @override
  String get educationCertFinancialAnalyst =>
      'Certificazione di analista finanziario';

  @override
  String get educationCertCasinoManagement =>
      'Certificazione di gestione del casinò';

  @override
  String get educationCertParamedic => 'Certificazione di paramedico';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostitute';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'distretti';

  @override
  String get rivalryTitle => 'Rivalità';

  @override
  String get rivalryChallengeTitle => 'Giocatore di sfida';

  @override
  String get rivalryChallengeHint =>
      'Inserisci un nome giocatore (o ID) per iniziare una rivalità.';

  @override
  String get rivalryPlayerIdHint => 'Nome o ID del giocatore';

  @override
  String get rivalryStartButton => 'Inizio';

  @override
  String get rivalryNoActive => 'Nessuna rivalità attiva ancora.';

  @override
  String get rivalryActiveTitle => 'Rivali attivi';

  @override
  String get rivalryScoreLabel => 'Punteggio di rivalità';

  @override
  String get rivalryRecentActivity => 'Attività recente';

  @override
  String get rivalryNoActivity => 'Nessuna attività di sabotaggio ancora';

  @override
  String get rivalryCooldownReady => 'Sabotaggio pronto';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Tempo di recupero: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Mancia Polizia (€5k)';

  @override
  String get rivalryActionStealCustomer => 'Ruba cliente (€ 3k)';

  @override
  String get rivalryActionDamageReputation =>
      'Reputazione del danno (€ 10.000)';

  @override
  String get rivalryActionBribeEmployee => 'Tangente dipendente (€8k)';

  @override
  String get rivalryUpdateMessage => 'Rivalità aggiornata';

  @override
  String get rivalrySabotageExecuted => 'Sabotaggio eseguito';

  @override
  String get rivalryConfirmTitle => 'Conferma il sabotaggio';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Obiettivo: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Azione: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Costo: €$amount';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Effetto: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Il successo non è garantito e puoi perdere denaro.';

  @override
  String get rivalryExecuteButton => 'Eseguire';

  @override
  String get rivalryEffectTipPolice =>
      'Aumentare la pressione della polizia rivale';

  @override
  String get rivalryEffectStealCustomer =>
      'Ruba parte del flusso di cassa rivale';

  @override
  String get rivalryEffectDamageReputation =>
      'Progresso inferiore della prostituta rivale';

  @override
  String get rivalryEffectBribeEmployee =>
      'Costrizione di una prostituta rivale allo stato di arresto';

  @override
  String get prostitutionUnderAttackTitle => 'Il tuo impero è sotto attacco';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker usato $action contro di te nelle ultime 24 ore.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Aperta rivalità';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      'Tradimento! Il tuo nightclub è stato colpito da una fuga di informazioni.';

  @override
  String get prostitutionLoadError => 'Errore nel caricamento dei dati';

  @override
  String get prostitutionNoDistrictInCountry =>
      'Nessun quartiere a luci rosse in questo paese';

  @override
  String get prostitutionMovedToStreet => 'Spostata in strada';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Questa prostituta è arrestata e non può essere assegnata.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Non hai ancora una sede nightclub per assegnare il personale.';

  @override
  String get prostitutionNightclubVenueName => 'Discoteca';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Discoteca #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Assegnata al nightclub';

  @override
  String get prostitutionArrestedCannotWork =>
      'Questa prostituta è arrestata e non può lavorare.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Ancora $duration di riposo prima del prossimo turno.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Turno completato';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Nessuna prostituta disponibile da mandare a lavorare.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostitute mandate a lavorare.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success mandate a lavorare, $failed fallite.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Reclutata!';

  @override
  String get prostitutionRecruitFailed => 'Reclutamento fallito';

  @override
  String get prostitutionRecruitConnectionError =>
      'Reclutamento fallito per errore di connessione';

  @override
  String get prostitutionEventUpdate => 'Evento aggiornato';

  @override
  String get prostitutionBuyPropertyFirst =>
      'Compra prima una casa o un appartamento';

  @override
  String prostitutionWorkAll(int count) {
    return 'Manda tutte a lavorare ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Nessun posto in alloggio libero. Compra o migliora una casa o un appartamento prima di reclutare altre prostitute.';

  @override
  String get prostitutionHousingTitle => 'Alloggio';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Ogni prostituta deve fare almeno un turno ogni $days giorni per pagare l\'affitto.';
  }

  @override
  String get prostitutionHousingSlots => 'Posti';

  @override
  String get prostitutionHousingFree => 'Libero';

  @override
  String get prostitutionHousingHomes => 'Case';

  @override
  String get prostitutionHousingAvgUpgrade => 'Miglior. media';

  @override
  String get prostitutionHousingHappinessBonus => 'Bonus felicità';

  @override
  String get prostitutionHousingWeeklyRent => 'Affitto settimanale';

  @override
  String get prostitutionHousingAtRisk => 'A rischio';

  @override
  String get prostitutionHousingSafe => 'Al sicuro';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Tradimento attivato: $grams g di droga sequestrata/e, $licenses licenza/e nightclub revocata/e.';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Panoramica guadagni (prostitute attive)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Strada: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'Luci rosse: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nightclub: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Totale: €$euros/h';
  }

  @override
  String get prostitutionHappinessEcstatic => 'In estasi';

  @override
  String get prostitutionHappinessHappy => 'Felice';

  @override
  String get prostitutionHappinessStable => 'Stabile';

  @override
  String get prostitutionHappinessStressed => 'Stressata';

  @override
  String get prostitutionHappinessMiserable => 'Miserabile';

  @override
  String get prostitutionHousingExpired => 'Scaduto';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'ancora $days g.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Meno di 1 giorno';

  @override
  String get prostitutionNightclubShort => 'Club';

  @override
  String get prostitutionMoveToStreetButton => 'In strada';

  @override
  String get prostitutionMoveToNightclubButton => 'Al nightclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/h';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Felicità $label ($score%) • Rendimento $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Alloggio: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Affitto settimanale €$amount';
  }

  @override
  String get prostitutionWork8h => 'Lavora 8 h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Riposa $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Prossimo turno tra $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get rivalryProtectionTitle => 'Assicurazione di protezione';

  @override
  String get rivalryProtectionDescription =>
      'Riduce l\'impatto del sabotaggio in arrivo del 30% per 7 giorni.';

  @override
  String get rivalryProtectionInactive => 'Nessuna protezione attiva';

  @override
  String rivalryProtectionActive(String date) {
    return 'Attivo fino al: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Acquista protezione (€25k/settimana)';

  @override
  String get rivalryProtectionActivated =>
      'Assicurazione di protezione attivata';

  @override
  String get achievementTitle_first_steps => 'Primi passi';

  @override
  String get achievementDescription_first_steps =>
      'Recluta la tua prima prostituta';

  @override
  String get achievementTitle_growing_empire => 'Impero in crescita';

  @override
  String get achievementDescription_growing_empire => 'Recluta 5 prostitute';

  @override
  String get achievementTitle_first_district => 'Primo Distretto';

  @override
  String get achievementDescription_first_district =>
      'Acquista il tuo primo quartiere a luci rosse';

  @override
  String get achievementTitle_empire_builder => 'Costruttore di imperi';

  @override
  String get achievementDescription_empire_builder =>
      'Possiedi 5 quartieri a luci rosse';

  @override
  String get achievementTitle_district_master => 'Maestro distrettuale';

  @override
  String get achievementDescription_district_master =>
      'Possiedi 10 quartieri a luci rosse';

  @override
  String get achievementTitle_leveling_master => 'Maestro del livellamento';

  @override
  String get achievementDescription_leveling_master =>
      'Porta al massimo una prostituta al livello 10';

  @override
  String get achievementTitle_untouchable => 'Intoccabile';

  @override
  String get achievementDescription_untouchable =>
      'Non farti mai beccare per 7 giorni consecutivi';

  @override
  String get achievementTitle_millionaire => 'Milionaria';

  @override
  String get achievementDescription_millionaire =>
      'Accumula € 1.000.000 di guadagni totali';

  @override
  String get achievementTitle_high_roller => 'Alto scommettitore';

  @override
  String get achievementDescription_high_roller =>
      'Accumula € 5.000.000 di guadagni totali';

  @override
  String get achievementTitle_vip_service => 'Servizio VIP';

  @override
  String get achievementDescription_vip_service => 'Completa 10 eventi VIP';

  @override
  String get achievementTitle_event_enthusiast => 'Appassionato di eventi';

  @override
  String get achievementDescription_event_enthusiast =>
      'Completa 25 eventi VIP';

  @override
  String get achievementTitle_security_expert => 'Esperto di sicurezza';

  @override
  String get achievementDescription_security_expert =>
      'Massimizza il livello di sicurezza su tutti i distretti di proprietà';

  @override
  String get achievementTitle_luxury_provider => 'Fornitore di lusso';

  @override
  String get achievementDescription_luxury_provider =>
      'Migliora 3 distretti al livello VIP';

  @override
  String get achievementTitle_rivalry_victor => 'Vittoria rivalità';

  @override
  String get achievementDescription_rivalry_victor =>
      'Sabotare con successo i rivali 10 volte';

  @override
  String get achievementTitle_untouchable_rival => 'Rivale intoccabile';

  @override
  String get achievementDescription_untouchable_rival =>
      'Difenditi da 20 tentativi di sabotaggio';

  @override
  String get achievementTitle_crime_first_blood => 'Crimine al primo sangue';

  @override
  String get achievementDescription_crime_first_blood =>
      'Completa con successo il tuo primo crimine';

  @override
  String get achievementTitle_crime_hustler => 'Spacciatore di crimini';

  @override
  String get achievementDescription_crime_hustler =>
      'Completa con successo 5 crimini';

  @override
  String get achievementTitle_crime_novice => 'Novizio del crimine';

  @override
  String get achievementDescription_crime_novice =>
      'Completa con successo 10 crimini';

  @override
  String get achievementTitle_crime_operator => 'Operatore del crimine';

  @override
  String get achievementDescription_crime_operator =>
      'Completa con successo 25 crimini';

  @override
  String get achievementTitle_crime_wave => 'Onda di criminalità';

  @override
  String get achievementDescription_crime_wave =>
      'Completa con successo 50 crimini';

  @override
  String get achievementTitle_crime_mastermind => 'Mente del crimine';

  @override
  String get achievementDescription_crime_mastermind =>
      'Completa con successo 100 crimini';

  @override
  String get achievementTitle_the_godfather => 'Il Padrino';

  @override
  String get achievementDescription_the_godfather =>
      'Completa con successo 250 crimini';

  @override
  String get achievementTitle_crime_emperor => 'Imperatore del crimine';

  @override
  String get achievementDescription_crime_emperor =>
      'Completa con successo 500 crimini';

  @override
  String get achievementTitle_crime_legend => 'Leggenda del crimine';

  @override
  String get achievementDescription_crime_legend =>
      'Completa con successo 1000 crimini';

  @override
  String get achievementTitle_crime_getaway_driver => 'Autista in fuga';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Completa con successo il tuo primo crimine con un veicolo';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Armati e pronti';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Completa con successo il tuo primo crimine che richiede un\'arma';

  @override
  String get achievementTitle_crime_full_loadout => 'Caricamento completo';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Completa con successo un crimine che richiede veicoli, armi e strumenti';

  @override
  String get achievementTitle_crime_completionist =>
      'Completizzatore di crimini';

  @override
  String get achievementDescription_crime_completionist =>
      'Completa con successo ogni tipo di crimine almeno una volta';

  @override
  String get achievementTitle_job_first_shift => 'Primo turno';

  @override
  String get achievementDescription_job_first_shift =>
      'Completa con successo il tuo primo lavoro';

  @override
  String get achievementTitle_job_hustler => 'Spacciatore di lavori';

  @override
  String get achievementDescription_job_hustler =>
      'Completa con successo 5 lavori';

  @override
  String get achievementTitle_job_starter => 'Inizio lavoro';

  @override
  String get achievementDescription_job_starter =>
      'Completa con successo 10 lavori';

  @override
  String get achievementTitle_job_operator => 'Operatore del lavoro';

  @override
  String get achievementDescription_job_operator =>
      'Completa con successo 25 lavori';

  @override
  String get achievementTitle_job_grinder => 'Macinino da lavoro';

  @override
  String get achievementDescription_job_grinder =>
      'Completa con successo 50 lavori';

  @override
  String get achievementTitle_job_master => 'Maestro del lavoro';

  @override
  String get achievementDescription_job_master =>
      'Completa con successo 100 lavori';

  @override
  String get achievementTitle_job_expert => 'Esperto del lavoro';

  @override
  String get achievementDescription_job_expert =>
      'Completa con successo 250 lavori';

  @override
  String get achievementTitle_job_elite => 'Lavoro d\'élite';

  @override
  String get achievementDescription_job_elite =>
      'Completa con successo 500 lavori';

  @override
  String get achievementTitle_job_legend => 'Leggenda del lavoro';

  @override
  String get achievementDescription_job_legend =>
      'Completa con successo 1000 lavori';

  @override
  String get achievementTitle_job_completionist => 'Completatore del lavoro';

  @override
  String get achievementDescription_job_completionist =>
      'Completa con successo ogni tipo di lavoro almeno una volta';

  @override
  String get achievementTitle_job_educated_worker => 'Lavoratore istruito';

  @override
  String get achievementDescription_job_educated_worker =>
      'Completa 1 lavoro che ha requisiti di istruzione';

  @override
  String get achievementTitle_job_certified_hustler =>
      'Spacciatore certificato';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Completa 25 lavori con requisiti di istruzione';

  @override
  String get achievementTitle_job_education_completionist =>
      'Completatore di lavori nel settore dell\'istruzione';

  @override
  String get achievementDescription_job_education_completionist =>
      'Completa ogni tipo di lavoro vincolato all\'istruzione almeno una volta';

  @override
  String get achievementTitle_job_it_specialist => 'Specialista informatico';

  @override
  String get achievementDescription_job_it_specialist =>
      'Completa il tuo primo turno come programmatore';

  @override
  String get achievementTitle_job_lawyer => 'Avvocato di strada';

  @override
  String get achievementDescription_job_lawyer =>
      'Completa il tuo primo turno come avvocato';

  @override
  String get achievementTitle_job_doctor => 'Dottore sotterraneo';

  @override
  String get achievementDescription_job_doctor =>
      'Completa il tuo primo turno come medico';

  @override
  String get achievementTitle_school_certified => 'Studente certificato';

  @override
  String get achievementDescription_school_certified =>
      'Ottieni 3 certificazioni scolastiche';

  @override
  String get achievementTitle_school_multi_certified => 'Multicertificazione';

  @override
  String get achievementDescription_school_multi_certified =>
      'Ottieni 6 certificazioni scolastiche';

  @override
  String get achievementTitle_school_track_specialist =>
      'Specialista della pista';

  @override
  String get achievementDescription_school_track_specialist =>
      'Ottieni un massimo di 3 percorsi scolastici';

  @override
  String get achievementTitle_school_freshman => 'Matricola della scuola';

  @override
  String get achievementDescription_school_freshman =>
      'Raggiungere il livello di istruzione 1';

  @override
  String get achievementTitle_school_scholar => 'Studioso della scuola';

  @override
  String get achievementDescription_school_scholar =>
      'Raggiungere il livello di istruzione 3';

  @override
  String get achievementTitle_school_graduate => 'Laureato';

  @override
  String get achievementDescription_school_graduate =>
      'Raggiungere il livello di istruzione 5';

  @override
  String get achievementTitle_school_mastermind => 'Mente accademica';

  @override
  String get achievementDescription_school_mastermind =>
      'Raggiungi il livello di istruzione 10';

  @override
  String get achievementTitle_school_doctorate => 'Dottorato di strada';

  @override
  String get achievementDescription_school_doctorate =>
      'Raggiungi il livello di istruzione 20';

  @override
  String get achievementTitle_road_bandit => 'Bandito di strada';

  @override
  String get achievementDescription_road_bandit => 'Ruba 5 auto';

  @override
  String get achievementTitle_grand_theft_fleet => 'Flotta di grandi furti';

  @override
  String get achievementDescription_grand_theft_fleet => 'Ruba 25 auto';

  @override
  String get achievementTitle_sea_raider => 'Raider del mare';

  @override
  String get achievementDescription_sea_raider => 'Ruba 3 barche';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Capitano dei contrabbandieri';

  @override
  String get achievementDescription_captain_of_smugglers => 'Ruba 12 barche';

  @override
  String get achievementTitle_globe_trotter => 'Giramondo';

  @override
  String get achievementDescription_globe_trotter => 'Completa 5 viaggi';

  @override
  String get achievementTitle_jet_setter => 'Jet-setter';

  @override
  String get achievementDescription_jet_setter => 'Completa 25 viaggi';

  @override
  String get achievementTitle_chemist_apprentice => 'Apprendista chimico';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Completa 10 produzioni di farmaci';

  @override
  String get achievementTitle_narco_chemist => 'Narcochimico';

  @override
  String get achievementDescription_narco_chemist =>
      'Completa 100 produzioni di farmaci';

  @override
  String get achievementTitle_street_merchant => 'Mercante di strada';

  @override
  String get achievementDescription_street_merchant => 'Completa 25 operazioni';

  @override
  String get achievementTitle_trade_tycoon => 'Magnate del commercio';

  @override
  String get achievementDescription_trade_tycoon => 'Completa 150 operazioni';

  @override
  String get achievementTitle_prostitute_lineup => 'Formazione creata';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Recluta 10 prostitute';

  @override
  String get achievementTitle_prostitute_network => 'Rete stradale';

  @override
  String get achievementDescription_prostitute_network =>
      'Recluta 25 prostitute';

  @override
  String get achievementTitle_prostitute_syndicate => 'Sindacato';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Recluta 50 prostitute';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dinastia';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Recluta 100 prostitute';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Impero 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recluta 250 prostitute';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Cartello 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recluta 500 prostitute';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Leggenda 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recluta 1.000 prostitute';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'Principiante VIP';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Raggiungi il livello 3 con una prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'Capofila VIP';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Raggiungi il livello 5 con una prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'Icona VIP';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Raggiungi il livello 7 con una prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'Leggenda VIP';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Raggiungi il livello 10 con una prostituta VIP';

  @override
  String get achievementTitle_nightclub_opening_night => 'Serata di apertura';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Apri il tuo primo locale notturno';

  @override
  String get achievementTitle_nightclub_headliner => 'Booker principale';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Prenota 10 turni di DJ per il tuo impero di nightclub';

  @override
  String get achievementTitle_nightclub_full_house => 'Tutto esaurito';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Spingi la folla di un nightclub al 90% della capacità';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Bancomat';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Guadagna € 250.000 di entrate totali nel nightclub';

  @override
  String get achievementTitle_nightclub_empire => 'Impero della vita notturna';

  @override
  String get achievementDescription_nightclub_empire =>
      'Guadagna € 1.000.000 di entrate totali nel nightclub';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Capo del personale';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Gestisci 3 membri attivi dell\'equipaggio del nightclub contemporaneamente';

  @override
  String get achievementTitle_nightclub_vip_room => 'Sala VIP';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Assegna 2 membri dell\'equipaggio VIP al tuo nightclub';

  @override
  String get achievementTitle_nightclub_head_of_security =>
      'Responsabile della sicurezza';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Assumi la sicurezza della discoteca per 10 turni';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Arrivo sul podio';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Finisci tra i primi 3 di una stagione di nightclub settimanale';

  @override
  String get achievementTitle_nightclub_season_champion =>
      'Campione della stagione';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Vinci una stagione settimanale di nightclub';

  @override
  String get nightclubManagementTitle => 'Gestione delle discoteche';

  @override
  String get nightclubRealtimeStatus => 'Stato in tempo reale attivo';

  @override
  String get nightclubRefresh => 'Aggiorna';

  @override
  String get nightclubEmptyTitle => 'Nessun nightclub trovato ancora';

  @override
  String get nightclubEmptyBody =>
      'Acquista prima una discoteca in Proprietà per attivare questo sistema.';

  @override
  String get nightclubLocationTitle => 'Posizione della discoteca';

  @override
  String get nightclubSelectVenue => 'Seleziona sede';

  @override
  String get nightclubLiveStatistics => 'Statistiche in tempo reale';

  @override
  String get nightclubKpiCrowd => 'Folla';

  @override
  String get nightclubKpiVibe => 'Vibrazione';

  @override
  String get nightclubKpiToday => 'Oggi';

  @override
  String get nightclubKpiAllTime => 'Di tutti i tempi';

  @override
  String get nightclubKpiStock => 'Azione';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Furti';

  @override
  String get nightclubKpiStaff => 'Personale';

  @override
  String get nightclubKpiSalesBoost => 'Incremento delle vendite';

  @override
  String get nightclubKpiPriceBoost => 'Aumento dei prezzi';

  @override
  String get nightclubKpiVipBonus => 'Bonus VIP';

  @override
  String get nightclubStatusActive => 'Attiva';

  @override
  String get nightclubStatusOff => 'Spento';

  @override
  String get nightclubStatusActiveLower => 'attiva';

  @override
  String get nightclubRevenueTrend => 'Andamento dei ricavi (in tempo reale)';

  @override
  String get nightclubLeaderboardTitle => 'Le migliori discoteche';

  @override
  String get nightclubLeaderboardCountry => 'Paese';

  @override
  String get nightclubLeaderboardGlobal => 'Globale';

  @override
  String get nightclubLeaderboardEmpty => 'Nessun dato sulla classifica ancora';

  @override
  String get nightclubLeaderboardRevenue24h => 'Entrate 24 ore su 24';

  @override
  String get nightclubSeasonProcessing => 'elaborazione...';

  @override
  String get nightclubSeasonTitle => 'Classifica stagionale settimanale';

  @override
  String get nightclubSeasonResetIn => 'Reimposta';

  @override
  String get nightclubSeasonYourRewards => 'I tuoi premi stagionali';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 della settimana corrente';

  @override
  String get nightclubSeasonEmpty => 'Nessun dato stagionale ancora';

  @override
  String get nightclubSeasonWeekRevenue => 'Entrate settimanali';

  @override
  String get nightclubSeasonScore => 'Punto';

  @override
  String get nightclubSeasonRecentPayouts => 'Pagamenti recenti';

  @override
  String get nightclubSeasonNoPayouts => 'Nessun pagamento ancora';

  @override
  String get nightclubSalesTitle => 'Vendite recenti';

  @override
  String get nightclubSalesEmpty => 'Nessun dato di vendita ancora';

  @override
  String get nightclubTheftTitle => 'Registro dei furti';

  @override
  String get nightclubTheftEmpty => 'Nessun furto registrato';

  @override
  String get nightclubTheftLoss => 'Perdita';

  @override
  String get nightclubStaffTitle => 'Squadra di magnaccia nel club';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 attivi)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capacità: $assigned/$cap$vipSuffix';
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
    return 'Mix di incremento: vendite x$sales | prezzo x$price | atmosfera x$vibe | sicurezza x$security | giocatore vip x$vipPlayer | personale vip x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember =>
      'Seleziona il membro dell\'equipaggio';

  @override
  String get nightclubAssignShift => 'Assegnato al turno in discoteca';

  @override
  String get nightclubTabActive => 'Attiva';

  @override
  String get nightclubTabHistory => 'Storia';

  @override
  String get nightclubNoCrewAssigned => 'Nessun equipaggio ancora assegnato';

  @override
  String get nightclubCrewBoostDescription =>
      'Aumenta la domanda e il margine nel tuo club';

  @override
  String get nightclubRemove => 'Rimuovere';

  @override
  String get nightclubNoStaffHistory =>
      'Nessuna cronologia del personale ancora';

  @override
  String get nightclubFrom => 'Da';

  @override
  String get nightclubTo => 'A';

  @override
  String get nightclubRevenueImpact => 'Impatto sulle entrate';

  @override
  String get nightclubSalesCountLabel => 'salde';

  @override
  String get nightclubDjTitle => 'Assumi un DJ';

  @override
  String get nightclubChooseDj => 'Scegli DJ';

  @override
  String get nightclubShiftLength => 'Durata del turno';

  @override
  String get nightclubHireDj => 'Assumi un DJ';

  @override
  String get nightclubSecurityTitle => 'Sicurezza';

  @override
  String get nightclubChooseSecurity => 'Scegli la sicurezza';

  @override
  String get nightclubHireSecurity => 'Assumi la sicurezza';

  @override
  String get nightclubStoreTitle => 'Conservare i farmaci';

  @override
  String get nightclubChooseStock => 'Scegli azione';

  @override
  String get nightclubAmountGrams => 'Quantità in grammi';

  @override
  String get nightclubStoreButton => 'Negozio in discoteca';

  @override
  String get nightclubHireDjSuccess => 'DJ assunto';

  @override
  String get nightclubHireSecuritySuccess => 'Sicurezza assunta';

  @override
  String get nightclubAssignCrewSuccess => 'Membro dell\'equipaggio assegnato';

  @override
  String get nightclubRemoveCrewSuccess => 'Membro dell\'equipaggio rimosso';

  @override
  String get nightclubStoreDrugsSuccess => 'Farmaci immagazzinati';

  @override
  String get nightclubSeasonPayoutDialogTitle =>
      'Pagamento stagionale ricevuto';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'La tua discoteca è arrivata al rango #$rank questa settimana.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Ricompensa: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Entrate settimanali: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Perdita furto: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Vicina';

  @override
  String get nightclubVibeChill => 'Fredda';

  @override
  String get nightclubVibeNormal => 'Normale';

  @override
  String get nightclubVibeWild => 'Selvaggia';

  @override
  String get nightclubVibeRaging => 'Infuriata';

  @override
  String get nightclubTheftTypeCustomer => 'Furto del cliente';

  @override
  String get nightclubTheftTypeEmployee => 'Rapina ai dipendenti';

  @override
  String get nightclubTheftTypeRival => 'Sabotaggio rivale';

  @override
  String nightclubErrorLoading(String error) {
    return 'Errore durante il caricamento della discoteca: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Impossibile caricare le statistiche del nightclub';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'Impossibile caricare la classifica';

  @override
  String get nightclubServiceErrorSeason =>
      'Impossibile caricare la classifica della stagione';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Errore: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Il contratto del DJ residente è fallito';

  @override
  String get nightclubScheduleEventFailed =>
      'Impossibile pianificare l\'evento';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'L\'aggiornamento del marketing non è riuscito';

  @override
  String get nightclubUpgradeFailed => 'Aggiornamento non riuscito';

  @override
  String get nightclubIncidentResponseFailed =>
      'La risposta all\'incidente non è riuscita';

  @override
  String get nightclubRivalActionFailed => 'L\'azione rivale fallì';

  @override
  String get nightclubSupplierContractFailed =>
      'Contratto con il fornitore fallito';

  @override
  String get nightclubPromoterFailed => 'Il promotore ha fallito';

  @override
  String get nightclubHeatCooldownFailed =>
      'Il raffreddamento del calore non è riuscito';

  @override
  String get nightclubSmugglingFailed => 'Il contrabbando fallì';

  @override
  String get nightclubCounterIntelFailed => 'Il controspionaggio fallì';

  @override
  String get nightclubHospitalityStockFailed =>
      'Le azioni del settore alberghiero sono fallite';

  @override
  String get nightclubHospitalityPricingFailed =>
      'La determinazione dei prezzi dell\'ospitalità è fallita';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Visitatori attuali: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Ponte di comando del nightclub';

  @override
  String get nightclubOpsDeckRevenueToday => 'Entrate oggi';

  @override
  String get nightclubStockValueLabel => 'Valore delle azioni';

  @override
  String get nightclubCrewOccupancy => 'Occupazione dell\'Crew';

  @override
  String get nightclubOperationalRisk => 'Rischio operativo';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidenti (24 ore)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Turni di Crew attivi';

  @override
  String get nightclubRecentCrewHistory => 'Storia recente dell\'Crew';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'STANDARD';

  @override
  String get nightclubActiveDj => 'DJ attivo';

  @override
  String get nightclubActiveDjNone => 'DJ attivo: nessuno';

  @override
  String nightclubUntilTime(String time) {
    return 'fino al $time';
  }

  @override
  String get nightclubActiveSecurity => 'Sicurezza attiva';

  @override
  String get nightclubActiveSecurityNone => 'Sicurezza attiva: nessuna';

  @override
  String get nightclubNoDjsLoaded => 'Nessun DJ caricato. Aggiorna lo schermo.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Nessun titolo caricato. Aggiorna lo schermo.';

  @override
  String get nightclubCrowdBoost => 'Incremento della folla';

  @override
  String get nightclubCostPerHour => 'Costo';

  @override
  String get nightclubReputationLabel => 'Reputazione';

  @override
  String get nightclubSpecialtyLabel => 'Specialità';

  @override
  String get nightclubTheftReduction => 'Riduzione dei furti';

  @override
  String get nightclubShiftCost => 'Costo del turno';

  @override
  String get nightclubSelectedStock => 'Selezionata';

  @override
  String get nightclubAvailableGrams => 'Disponibile';

  @override
  String get nightclubMaxChip => 'MASSIMO';

  @override
  String get nightclubStoredInNightclub => 'Conservato in discoteca';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Stock attuale: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Nessun farmaco ancora memorizzato.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Lo stock attuale è di 0 g (è stato venduto tutto).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Qualità: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g di brodo';
  }

  @override
  String get nightclubOperationsLabTitle =>
      'Laboratorio operativo (11 sistemi)';

  @override
  String get nightclubSectionResidentDjContract =>
      '1) Contratto da DJ residente';

  @override
  String get nightclubContractDiscount => 'Sconto contrattuale';

  @override
  String get nightclubContractDuration => 'Durata del contratto';

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
  String get nightclubStartResidentContract => 'Inizio contratto di residenza';

  @override
  String get nightclubSectionEventCalendar => '2) Calendario eventi dinamico';

  @override
  String get nightclubRecommendedToday => 'Consigliato oggi';

  @override
  String get nightclubEventTemplate => 'Modello di evento';

  @override
  String get nightclubScheduleEventFiveMin => 'Pianifica evento (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Prossimi eventi';

  @override
  String get nightclubSectionUpgradeTree => '3) Aggiorna l\'albero';

  @override
  String get nightclubUpgradeSoundRig => 'Impianto audio';

  @override
  String get nightclubUpgradeVipLounge => 'Sala VIP';

  @override
  String get nightclubUpgradeSurveillance => 'Sorveglianza';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Scegli l\'aggiornamento';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Questo aggiornamento è già al livello massimo.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Aggiornamento già al massimo';

  @override
  String get nightclubUpgradeNow => 'Aggiorna ora';

  @override
  String get nightclubMarketingInvestment => 'Investimenti di marketing';

  @override
  String get nightclubInvestMarketing => 'Investire nel marketing';

  @override
  String get nightclubSectionPoliceHeat =>
      '4) Calore e incidenti della polizia';

  @override
  String get nightclubHeatLabel => 'Calore';

  @override
  String get nightclubRaidRisk => 'Rischio raid';

  @override
  String get nightclubCooldownLabel => 'Raffreddare';

  @override
  String get nightclubStartHeatCooldown => 'Avvia il raffreddamento del calore';

  @override
  String get nightclubBribe => 'Tangente';

  @override
  String get nightclubLockdown => 'Confinamento';

  @override
  String get nightclubCounterIntelShort => 'Contro-intelligence';

  @override
  String get nightclubSectionStaffMorale =>
      '5) Affaticamento e morale del personale';

  @override
  String get nightclubMorale => 'Morale';

  @override
  String get nightclubFatigue => 'Fatica';

  @override
  String get nightclubStaffing => 'Personale';

  @override
  String get nightclubSectionSupplierPromoter => '6) Fornitore e promotore';

  @override
  String get nightclubSupplierContract => 'Contratto fornitore';

  @override
  String get nightclubActivateSupplier => 'Attiva fornitore';

  @override
  String get nightclubPromoterProfile => 'Profilo del promotore';

  @override
  String get nightclubHirePromoter => 'Assumi un promotore';

  @override
  String get nightclubSectionVipClientele =>
      '7) Clientela VIP e caratteristiche del personale';

  @override
  String get nightclubVipShare => 'Quota VIP';

  @override
  String get nightclubSpendMultiplier => 'Spendi x';

  @override
  String get nightclubTier => 'Livello';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Rotte del contrabbando';

  @override
  String get nightclubReady => 'Pronta';

  @override
  String get nightclubRoute => 'Itinerario';

  @override
  String get nightclubStartRoute => 'Inizia il percorso';

  @override
  String get nightclubLastRoute => 'Ultimo percorso';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Blocco percorso attivo fino alle $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Gestione Bar e Cucina';

  @override
  String get nightclubServiceLevel => 'Livello di servizio';

  @override
  String get nightclubStockStatus => 'Stato delle scorte';

  @override
  String get nightclubSpoilageRisk => 'Rischio di deterioramento';

  @override
  String get nightclubDrinksFoodStock => 'Bevande/brodo alimentare';

  @override
  String get nightclubBuyStock => 'Acquista azioni';

  @override
  String get nightclubMenuPricingMode => 'Modalità di prezzo del menu';

  @override
  String get nightclubApplyPricing => 'Applicare i prezzi';

  @override
  String get nightclubSectionRivals => '10) Club rivali + controspionaggio';

  @override
  String get nightclubSearchPlayerName => 'Cerca il nome del giocatore';

  @override
  String get nightclubTargetName => 'Obiettivo (nome)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • folla $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotaggio';

  @override
  String get nightclubPromoWar => 'Guerra promozionale';

  @override
  String get nightclubCounterIntelSweep => 'Svolta nel controspionaggio';

  @override
  String get nightclubMitigation => 'Mitigazione';

  @override
  String get nightclubSectionTimeline => '11) Cronologia delle operazioni';

  @override
  String get nightclubNoTimelineEvents =>
      'Nessun evento nella sequenza temporale.';

  @override
  String get nightclubOperationsAlerts => 'Avvisi operativi';

  @override
  String get nightclubNoCriticalAlerts => 'Nessun avviso critico.';

  @override
  String get nightclubQuickAction => 'Azione rapida';

  @override
  String get nightclubMgmtCrewTitle => 'Crew e turni';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Personale, prestazioni e cronologia dei turni.';

  @override
  String get nightclubMgmtDrugsTitle => 'Conservazione dei farmaci';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Gestisci e trasferisci l\'inventario in grammi.';

  @override
  String get nightclubMgmtDjTitle => 'Comando DJ';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Scegli il DJ, la durata del turno e l\'incremento della folla dal vivo.';

  @override
  String get nightclubMgmtSecurityTitle => 'Unità di sicurezza';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Riduzione dei furti, costi e sicurezza attiva.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Laboratorio operativo';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Avvisi in tempo reale: $alerts | Contrabbando: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 sistemi per eventi, potenziamenti, percorsi e rivali.';

  @override
  String get nightclubManagementPanelTitle => 'Gestione delle discoteche';

  @override
  String get nightclubChooseZoneHint =>
      'Scegli una zona di gestione e controlla tutto senza scorrimento interno nidificato.';

  @override
  String get nightclubChipCrew => 'Equipaggio';

  @override
  String get nightclubChipStorage => 'Magazzinaggio';

  @override
  String get nightclubChipDjShift => 'Turno di DJ';

  @override
  String get nightclubChipSecurity => 'Sicurezza';

  @override
  String get nightclubChipOpsAlerts => 'Avvisi operativi';

  @override
  String get nightclubNone => 'Nessuno';

  @override
  String get nightclubIntelligenceCardTitle => 'Intelligenza da discoteca';

  @override
  String get nightclubSeasonStatus => 'Stato della stagione';

  @override
  String nightclubSeasonCountdown(String days, String hours, String minutes) {
    return '${days}d ${hours}h ${minutes}m';
  }

  @override
  String nightclubShiftHours(String hours) {
    return '$hours h';
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
      'Saltare il tempo di recupero del furto?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Spendi $cost crediti per eliminare il tempo di recupero del furto del veicolo adesso? Il tuo saldo: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Non mostrare più questa conferma';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Usa $credits crediti';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'L\'accelerazione del credito non è disponibile per questo tempo di recupero al momento.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Nessun cooldown di furto attivo da reimpostare.';

  @override
  String get theftCooldownRedeemInsufficientCredits => 'Crediti insufficienti.';

  @override
  String get theftCooldownRedeemFailed =>
      'Impossibile applicare crediti al tempo di recupero.';

  @override
  String get theftCooldownRedeemSuccess =>
      'Il tempo di recupero è stato cancellato.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Tempo di recupero del furto (crediti)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Chiedi conferma prima di spendere crediti per saltare il tempo di recupero del furto del veicolo. Disattiva per riscattare con un solo tocco (icona del fulmine accanto al timer).';

  @override
  String get supportTicketsScreenTitle => 'Ticket di supporto';

  @override
  String get supportLoadTicketsFailed => 'Impossibile caricare i biglietti';

  @override
  String get supportLoadTicketFailed => 'Impossibile caricare il biglietto';

  @override
  String get supportPickImageFailed => 'Impossibile selezionare l\'immagine';

  @override
  String get supportSubjectMessageMinLength =>
      'Compila oggetto e messaggio (min. 3 caratteri).';

  @override
  String get supportTicketCreated => 'Biglietto creato.';

  @override
  String get supportCreateTicketFailed => 'Impossibile creare il biglietto';

  @override
  String get supportReplySent => 'Risposta inviata.';

  @override
  String get supportReplySendFailed => 'Impossibile inviare la risposta';

  @override
  String get supportDeleteTicketTitle => 'Elimina biglietto';

  @override
  String get supportDeleteTicketBody =>
      'Sei sicuro di voler eliminare questo ticket? Questa azione non può essere annullata.';

  @override
  String get supportTicketDeleted => 'Biglietto eliminato.';

  @override
  String get supportDeleteTicketFailed => 'Impossibile eliminare il biglietto';

  @override
  String get supportUnknownError => 'Errore sconosciuto';

  @override
  String get supportStatusNew => 'Nuova';

  @override
  String get supportStatusTriage => 'Triage';

  @override
  String get supportStatusInProgress => 'In corso';

  @override
  String get supportStatusWaitingPlayer => 'In attesa del giocatore';

  @override
  String get supportStatusBlocked => 'Bloccata';

  @override
  String get supportStatusResolved => 'Risolta';

  @override
  String get supportStatusClosed => 'Chiusa';

  @override
  String get supportStatusArchived => 'Archiviata';

  @override
  String get supportCategoryBug => 'Bug';

  @override
  String get supportCategoryQuestion => 'Domanda';

  @override
  String get supportCategoryFeedback => 'Feedback';

  @override
  String get supportCategoryOther => 'Altra';

  @override
  String get supportPriorityLow => 'Basso';

  @override
  String get supportPriorityHigh => 'Alto';

  @override
  String get supportPriorityUrgent => 'Urgente';

  @override
  String get supportPriorityNormal => 'Normale';

  @override
  String supportTimeDaysAgo(int count) {
    return '${count}d fa';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return '${count}h fa';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return '${count}m fa';
  }

  @override
  String get supportTimeJustNow => 'proprio adesso';

  @override
  String get supportSenderSupport => 'Supporto';

  @override
  String get supportSenderYou => 'Voi';

  @override
  String get supportImageLoadFailed => 'Impossibile caricare l\'immagine.';

  @override
  String get supportMyTickets => 'I miei biglietti';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'Il supporto ora risponde direttamente all\'interno di questa schermata. Puoi comunque ricevere facoltativamente una notifica push quando il tuo ticket riceve un aggiornamento.';

  @override
  String get supportNoTicketsYet =>
      'Non hai ancora alcun biglietto. Crea un nuovo rapporto qui sotto.';

  @override
  String get supportSelectTicketPrompt =>
      'Seleziona un ticket per aprire la conversazione.';

  @override
  String get supportConversation => 'Conversazione';

  @override
  String get supportNoMessagesYet => 'Nessun messaggio ancora.';

  @override
  String get supportAttachments => 'Allegati';

  @override
  String get supportReplyToTicket => 'Rispondi a questo ticket';

  @override
  String get supportReplyFieldHint =>
      'Utilizza questo campo quando il supporto richiede ulteriori informazioni o quando desideri fornire un aggiornamento. Posta in arrivo e push rimangono canali di notifica per nuove risposte di supporto.';

  @override
  String get supportYourReply => 'La tua risposta';

  @override
  String get supportSendReply => 'Invia risposta';

  @override
  String get supportNewTicket => 'Nuovo biglietto';

  @override
  String get supportNewTicketIntro =>
      'Crea un nuovo rapporto qui. L\'assistenza può quindi rispondere tramite posta in arrivo/push e in questa schermata, così puoi continuare la conversazione in un unico posto.';

  @override
  String get supportTicketReceivedBanner => 'Biglietto ricevuto';

  @override
  String supportTicketNumberLine(int id) {
    return 'Numero del biglietto: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'Il biglietto ora appare direttamente nella tua lista sopra. Le nuove risposte al supporto arrivano anche come messaggi di posta in arrivo e notifiche push.';

  @override
  String get supportFieldCategory => 'Categoria';

  @override
  String get supportFieldModule => 'Modulo';

  @override
  String get supportFieldSubject => 'Soggetta';

  @override
  String get supportFieldMessage => 'Messaggio';

  @override
  String get supportReferenceOptional => 'Riferimento (facoltativo)';

  @override
  String get supportReferenceHint =>
      'Ad esempio ID ordine, nome visualizzato, paese o contesto breve';

  @override
  String get supportAddScreenshot => 'Aggiungi schermata';

  @override
  String get supportSubmit => 'Invia';

  @override
  String get supportLastMessagePrefix => 'Scorsa:';

  @override
  String get supportReferenceLabel => 'Riferimento';

  @override
  String get supportMod_support => 'Supporto generale';

  @override
  String get supportMod_dashboard => 'Pannello di controllo';

  @override
  String get supportMod_messages => 'Messaggi/posta in arrivo';

  @override
  String get supportMod_notifications => 'Notifiche/push';

  @override
  String get supportMod_payments => 'Pagamenti/premio';

  @override
  String get supportMod_bank => 'Banca';

  @override
  String get supportMod_crypto => 'Criptovaluta';

  @override
  String get supportMod_travel => 'Viaggio';

  @override
  String get supportMod_properties => 'Proprietà';

  @override
  String get supportMod_inventory => 'Inventario/stoccaggio';

  @override
  String get supportMod_loadouts => 'Dotazioni/attrezzature';

  @override
  String get supportMod_crimes => 'Crimini';

  @override
  String get supportMod_jobs => 'Lavoro/lavori';

  @override
  String get supportMod_vehicles => 'Furto auto/bici/barca';

  @override
  String get supportMod_garage => 'Garage';

  @override
  String get supportMod_marina => 'Marina';

  @override
  String get supportMod_aviation => 'Aviazione';

  @override
  String get supportMod_smuggling => 'Contrabbando';

  @override
  String get supportMod_drugs => 'Droghe';

  @override
  String get supportMod_nightclub => 'Discoteca';

  @override
  String get supportMod_prostitution => 'Prostituzione';

  @override
  String get supportMod_crew => 'Equipaggio';

  @override
  String get supportMod_friends => 'Amici/giocatori';

  @override
  String get supportMod_hitlist => 'Hitlist';

  @override
  String get supportMod_security => 'Sicurezza/FBI';

  @override
  String get supportMod_prison => 'Prigione/tribunale';

  @override
  String get supportMod_casino => 'Casinò';

  @override
  String get supportMod_school => 'Scuola/formazione';

  @override
  String get supportMod_achievements => 'Risultati';

  @override
  String get supportMod_profile => 'Profilo';

  @override
  String get supportMod_settings => 'Impostazioni';

  @override
  String get supportMod_events => 'Eventi/classifica';

  @override
  String get supportMod_other => 'Altra';

  @override
  String get gameEventDefaultTitle => 'Evento';

  @override
  String get gameEventStatusActive => 'Attiva';

  @override
  String get gameEventStatusScheduled => 'Programmata';

  @override
  String get gameEventStatusCompleted => 'Completato';

  @override
  String get gameEventStatusDraft => 'Bozza';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Caccia al furto settimanale';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Ruba più veicoli che puoi durante la finestra dell\'evento.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Impennata del contrabbando';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Sposta la maggior parte del contrabbando in questo turno.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Sfida sui risultati del laboratorio';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produci il massimo risultato mentre l\'evento è in diretta.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'La criminalità di strada';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Completa quanti più crimini possibile nella finestra live.';

  @override
  String get gameEventTmplContrabandRushTitle => 'Corsa al contrabbando';

  @override
  String get gameEventTmplContrabandRushDesc =>
      'Vendi contrabbando con profitto o ritira spedizioni — vince il punteggio più alto.';

  @override
  String get gameEventTmplMonthlyEmpireShowdownTitle =>
      'Monthly Empire Showdown';

  @override
  String get gameEventTmplMonthlyEmpireShowdownDesc =>
      'All-round monthly challenge: score via crimes, vehicles, drugs, smuggling and trade. Top ranks win rare vehicles, weapons, ammo and parts.';

  @override
  String get gameScreenLoadError => 'Impossibile caricare gli eventi.';

  @override
  String get gameScreenDetailsLoadError =>
      'Impossibile caricare i dettagli dell\'evento.';

  @override
  String get gameScreenSectionLive => 'Eventi dal vivo';

  @override
  String get gameScreenNoActive =>
      'Non ci sono eventi attivi in ​​questo momento.';

  @override
  String get gameScreenSectionUpcoming => 'Prossimi eventi';

  @override
  String get gameScreenNoUpcoming => 'Non ci sono eventi in programma.';

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
    return 'Stato: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Inizio: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Fine: $date';
  }

  @override
  String get gameScreenYourProgress => 'I tuoi progressi';

  @override
  String gameScreenScore(String value) {
    return 'Punteggio: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Classifica: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Classifica (primi 10)';

  @override
  String get gameScreenNoLeaderboard => 'Nessun dato sulla classifica ancora.';

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
  String get gameScreenUnknownPlayer => 'Sconosciuta';

  @override
  String get gameScreenDash => '—';

  @override
  String get gameCardActive => 'Attiva';

  @override
  String get gameCardScheduled => 'Pianificata';

  @override
  String gameCardYourScore(String value) {
    return 'Il tuo punteggio: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Il tuo grado: $value';
  }

  @override
  String get gameCardTapDetails => 'Tocca per i dettagli e la classifica';

  @override
  String get eventFeedDisconnected => 'Disconnesso dal flusso di eventi';

  @override
  String get eventFeedReconnecting => 'Riconnessione...';

  @override
  String get eventFeedConnectedWaiting => 'Connesso: in attesa di eventi...';

  @override
  String get eventFeedConnecting => 'Connessione allo streaming dell\'evento…';

  @override
  String get evStreamConnectionEstablished => 'Connesso al flusso dell\'evento';

  @override
  String get evStreamAuthRegistered => 'Account creato con successo.';

  @override
  String get evStreamAuthLogin => 'Bentornato.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Completato con successo $crimeName! +EUR $reward, +$xpGained XP';
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
      other: '$minutes minuti',
      one: '1 minuto',
    );
    return 'Completato $crimeName con successo! +EUR $reward, +$xpGained XP — catturato! In carcere $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      'Il tuo veicolo è stato sequestrato dalla polizia.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      'La tua arma è stata confiscata dalla polizia.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condanne',
      one: '1 condanna',
    );
    return 'Completato $crimeName con successo! Casellario pulito: $_temp0 rimosse. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Arrestato da $authority durante un tentativo di $crimeName.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti',
      one: '1 minuto',
    );
    return 'Catturato durante $crimeName! In carcere $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Impossibile completare $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return 'Il tuo veicolo ha subito il $pct% di danni durante l\'inseguimento.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti',
      one: '1 minuto',
    );
    return 'Catturato durante $crimeName! In carcere $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Lavoro completato come $jobName! +€$earnings, +$xpGained PE';
  }

  @override
  String evStreamActorPrefix(String username, String message) {
    return '$username: $message';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return '(Bonus istruzione +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Impossibile completare il lavoro come $jobName. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Impossibile completare il lavoro come $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Lavoro non valido';

  @override
  String get evStreamJobErrorLevel =>
      'Il tuo grado è troppo basso per questo lavoro';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes altri minuti',
      one: '1 altro minuto',
    );
    return 'Questo lavoro è in cooldown. Aspetta $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Errore lavoro: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Volando a $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Arrivato tra $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Depositato €$amount in banca';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Prelevato €$amount dalla banca';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Comprato $quantity $symbol per €$total';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Venduto $quantity $symbol per €$total (P&L €$pnl)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol avviso: €$price ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side riempito: $quantity $symbol a €$price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig attivato per $symbol a €$price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Il regime di mercato è cambiato in $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment notizie: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Missione giornaliera completata: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Missione settimanale completata: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Ricompensa nella classifica delle criptovalute: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'rialzista';

  @override
  String get evStreamRegimeBear => 'ribassista';

  @override
  String get evStreamRegimeSideways => 'lateralmente';

  @override
  String get evStreamImpactBull => 'Rialzista';

  @override
  String get evStreamImpactBear => 'Ribassista';

  @override
  String get evStreamImpactNeutral => 'Neutra';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Acquistato $name per €$cost';
  }

  @override
  String evStreamPropertyClaimed(String name, String country, String cost) {
    return 'Claimed property $name in $country for €$cost';
  }

  @override
  String evStreamDrugsProductionStarted(String drugName, String minutes) {
    return 'Produzione iniziata $drugName — pronto in $minutes min';
  }

  @override
  String evStreamDrugsProductionCollected(
    String quantity,
    String drugName,
    String quality,
  ) {
    return 'Raccolti ${quantity}g $drugName ($quality)';
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
    return '${quantity}g $drugType venduto a $destination (€$payout)';
  }

  @override
  String evStreamDrugsWholesaleSeized(
    String quantity,
    String drugType,
    String destination,
  ) {
    return '${quantity}g $drugType verso $destination sequestrato';
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
    return 'Crew creato: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Crew iscritto: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Guerra tra equipaggi dichiarata: #$a vs #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'È iniziata la guerra tra equipaggi: #$a contro #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'La guerra tra equipaggi #$id è bloccata';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Guerra dell\'Crew #$id risolta. Vincitore: Crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Azione di guerra tra equipaggi: $action (+$points pt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Rapina “$name” riuscita! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Il colpo “$name” è fallito.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Curato in ospedale! +$hp salute, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Arrestato! Incarcerato per $mins minuti';
  }

  @override
  String get evStreamPoliceEscaped => 'Sei scappato dalla polizia.';

  @override
  String get evStreamFbiRaid => 'Raid dell\'FBI! Hai perso proprietà e denaro.';

  @override
  String get evStreamErrInsufficientFunds => 'Non abbastanza soldi';

  @override
  String get evStreamErrInsufficientHealth =>
      'Salute insufficiente per questa azione';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Richiede il grado $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes more minutes',
      one: '1 more minute',
    );
    return 'Rimarrai in prigione per $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'Hai bisogno di riposarti e recuperare la salute';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds secondi',
      one: '1 secondo',
    );
    return 'Attendi $_temp0 prima di riprovare';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Non puoi aiutare gli altri mentre sei in prigione';

  @override
  String get evStreamErrTargetNotJailed => 'Quel giocatore non è in prigione';

  @override
  String get evStreamErrCannotRescueSelf => 'Non puoi liberarti';

  @override
  String get evStreamJailbreakOk =>
      'Jailbreak riuscito! Il giocatore è libero.';

  @override
  String get evStreamJailbreakFail =>
      'Jailbreak fallito! Il giocatore è ancora in carcere.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Jailbreak fallito! Sei stato catturato e incarcerato per $mins minuti.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Cauzione pagata: €$amount. Sei libero.';
  }

  @override
  String get evStreamErrInternal =>
      'Qualcosa è andato storto. Per favore riprova.';

  @override
  String evStreamTest(String msg) {
    return 'Prova: $msg';
  }

  @override
  String get evStreamNoCriminalRecord =>
      'Non hai precedenti penali da cancellare';

  @override
  String get evStreamWeaponSelectRequired =>
      'Seleziona un\'arma del crimine prima di commettere questo crimine';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Hai bisogno di un\'arma adatta: $types';
  }

  @override
  String get evStreamJobFallbackName => 'lavoro';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Errore di connessione';

  @override
  String get crimeWeaponSectionTitle => 'Arma del crimine';

  @override
  String get crimeWeaponInstruction =>
      'Scegli quale arma portare utilizzare per impostazione predefinita per i crimini che ne richiedono una.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Acquista o sposta prima un\'arma utilizzabile nel tuo inventario trasportato.';

  @override
  String get crimeWeaponSelectHint => 'Seleziona un\'arma per i crimini';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Senza una selezione, i crimini basati sulle armi non cominceranno.';

  @override
  String get crimeWeaponSlotEmpty => 'vuoto';

  @override
  String crimeWeaponEquippedStatus(String slotOne, String slotTwo) {
    return 'Slot 1: $slotOne. Slot 2: $slotTwo.';
  }

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Selezionato: $weaponLine. Alcuni crimini richiedono ancora un tipo di arma corrispondente.';
  }

  @override
  String get crimeSetWeaponFailed =>
      'Impossibile impostare l\'arma del crimine.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Scegli prima un\'arma del crimine nella parte superiore di questa schermata o tramite Inventario.';

  @override
  String get crimeWeaponFooterNote =>
      'I crimini basati sulle armi utilizzano l\'arma del crimine selezionata sopra.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Training bonuses on success chance: +$strengthPct% strength, +$accuracyPct% accuracy.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Combo lo stesso giorno (palestra + poligono, calendario UTC): +$pct% probabilità extra di successo del crimine.';
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
      'Falsifica atti giudiziari e cancella tutti i tuoi precedenti penali se l\'operazione ha successo.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% di probabilità di successo';
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
      'Qualcosa è andato storto. Per favore riprova.';

  @override
  String get cooldownTimeLeft => 'Tempo rimasto';

  @override
  String get cooldownMustWaitExplanation =>
      'È necessario attendere prima di poter eseguire nuovamente questa azione.';

  @override
  String get cooldownAlreadyFinished => 'Il raffreddamento è già terminato.';

  @override
  String get cooldownNotEnoughCredits => 'Crediti insufficienti.';

  @override
  String get cooldownNoActiveToReset =>
      'Nessun tempo di recupero attivo da ripristinare.';

  @override
  String get cooldownNotAvailableNow => 'Non disponibile al momento.';

  @override
  String get cooldownRedeemFailed => 'Impossibile accelerare con i crediti.';

  @override
  String get cooldownFinishedInstantly =>
      'Il tempo di recupero è terminato immediatamente.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Accelera adesso (-$cost crediti)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Saldo: $balance crediti';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Caricamento opzioni di credito…';

  @override
  String get cooldownWaitCrime => 'Il caldo è troppo alto...';

  @override
  String get cooldownWaitJob => 'Riposarsi prima di poter lavorare di nuovo';

  @override
  String get cooldownWaitTravel => 'Il prossimo volo parte tra';

  @override
  String get cooldownWaitHeist => 'Pianificazione della rapina...';

  @override
  String get cooldownWaitAppeal => 'La Corte è occupata...';

  @override
  String get cooldownWaitSchool =>
      'Riprendi fiato prima della prossima lezione...';

  @override
  String get cooldownWaitDefault => 'Attendere prego…';

  @override
  String get weaponLabelKnife => 'Coltello';

  @override
  String get weaponLabelHandgun9mm => 'Pistola (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Pistola pesante (.45)';

  @override
  String get weaponLabelSmgCompact => 'Mitragliatore compatto';

  @override
  String get weaponLabelShotgunPump => 'Fucile (a pompa)';

  @override
  String get weaponLabelMolotov => 'Molotov';

  @override
  String get weaponLabelSmgSuppressed => 'SMG soppresso';

  @override
  String get weaponLabelShotgunTactical => 'Fucile tattico';

  @override
  String get weaponLabelAssaultRifle => 'Fucile d\'assalto (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Granata flash';

  @override
  String get weaponLabelGrenadeFrag => 'Granata a frammentazione';

  @override
  String get weaponLabelSniperStandard => 'Fucile da cecchino';

  @override
  String get weaponLabelAssaultRifleVip => 'Fucile d\'assalto d\'élite';

  @override
  String get weaponLabelSniperVip => 'Fucile da cecchino d\'élite';

  @override
  String get cooldownTitleCrime => 'Tempo di recupero del crimine';

  @override
  String get cooldownTitleJob => 'Recupero del lavoro';

  @override
  String get cooldownTitleTravel => 'Tempo di recupero del viaggio';

  @override
  String get cooldownTitleHeist => 'Tempo di recupero del colpo';

  @override
  String get cooldownTitleAppeal => 'Tempo di recupero dell\'appello';

  @override
  String get cooldownTitleSchool => 'Recupero scolastico';

  @override
  String get cooldownTitleGeneric => 'Raffreddare';

  @override
  String get crimeOutcomeDefaultTitle => 'Risultato del crimine';

  @override
  String get territoryContestStatusPreparing => 'Preparazione';

  @override
  String get territoryContestStatusActive => 'Attiva';

  @override
  String get territoryContestStatusLockdown => 'Confinamento';

  @override
  String get territoryContestStatusResolved => 'Risolta';

  @override
  String get territoryContestStatusCancelled => 'Annullata';

  @override
  String get territoryContestHintPreparing =>
      'Questo concorso è attualmente in preparazione. Una volta terminato il tempo di preparazione, la regione diventa automaticamente attiva e le azioni vengono sbloccate.';

  @override
  String get territoryContestHintLockdown =>
      'Questo concorso è in blocco. Al momento non è possibile intraprendere nuove azioni; il risultato si risolve automaticamente.';

  @override
  String get territoryNow => 'Ora';

  @override
  String get territoryRoleAttacker => 'Attaccante';

  @override
  String get territoryRoleDefender => 'Difenditrice';

  @override
  String get territoryValueLow => 'Basso';

  @override
  String get territoryValueAverage => 'Media';

  @override
  String get territoryValueHigh => 'Alto';

  @override
  String get territoryValueTop => 'Superiore';

  @override
  String get territoryTagCapital => 'Centro amministrativo';

  @override
  String get territoryTagHarbor => 'Porto';

  @override
  String get territoryTagIndustry => 'Industria';

  @override
  String get territoryTagBorder => 'Regione di confine';

  @override
  String get territoryTagLogistics => 'Polo logistico';

  @override
  String get territoryActionPatrol => 'Pattuglia';

  @override
  String get territoryActionIntelScan => 'Scansione Intel';

  @override
  String get territoryActionSabotage => 'Sabotaggio';

  @override
  String get territoryActionSupplyRun => 'Corsa ai rifornimenti';

  @override
  String get territoryActionRaid => 'Incursione';

  @override
  String get territoryActionDefense => 'Difesa';

  @override
  String get territoryBonusStrategicRegion => 'Regione strategica';

  @override
  String get territoryBonusAdjacentSupport => 'Supporto adiacente';

  @override
  String get territoryBonusWarPressure => 'Pressione bellica';

  @override
  String get territoryBonusHqLevel => 'Livello quartier generale';

  @override
  String get territoryBonusCrewMissionLevel => 'Livello di missione dell\'Crew';

  @override
  String get territoryBonusCrewBuildings => 'Edifici lato Crew';

  @override
  String get territoryBonusOther => 'Altra';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'base $basePoints + bonus $bonusPoints = $totalPoints punti gara';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Devi unirti a un Crew prima di poter attaccare il territorio.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'È già in corso un concorso per questa regione. Aggiornamento della mappa allo stato più recente.';

  @override
  String get territoryErrorCrewContestLimit =>
      'La tua squadra ha già raggiunto il limite di gare simultanee.';

  @override
  String get territoryErrorRegionsCap =>
      'Il tuo Crew possiede già il numero massimo di regioni.';

  @override
  String get territoryErrorContestNotActive =>
      'Questo concorso non è ancora attivo. Attendi il completamento della fase di preparazione.';

  @override
  String get territoryErrorActionCooldown =>
      'Devi attendere prima di eseguire un\'altra azione sul territorio.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Questa azione appartiene all\'altro lato del concorso.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Il tuo livello HQ è troppo basso per questa azione sul territorio.';

  @override
  String get territoryErrorDailyCap =>
      'Hai raggiunto il limite giornaliero di azioni sul territorio.';

  @override
  String get territoryErrorWrongCountry =>
      'Puoi visualizzare tutti i paesi, ma le azioni sul territorio funzionano solo nel paese in cui ti trovi attualmente.';

  @override
  String get territoryErrorUnknown => 'Errore territorio sconosciuto.';

  @override
  String get territoryLegendUnderContest => 'In concorso';

  @override
  String get territoryLegendNeutral => 'Neutra';

  @override
  String get territoryTabMap => 'Mappa';

  @override
  String get territoryTabLeaderboard => 'Classifica';

  @override
  String get territoryTabSeason => 'Stagione';

  @override
  String get territorySelectCountryTooltip => 'Seleziona il paese';

  @override
  String get territoryUnavailableMessage =>
      'Il territorio non è attualmente disponibile.';

  @override
  String get territoryMapHintTapMain =>
      'Tocca una regione sulla mappa per aprire le informazioni sul territorio e il pulsante di attacco in modalità modale.';

  @override
  String get territoryMapHintTapPanel =>
      'Tocca una regione per aprire direttamente la modalità con le informazioni sul territorio e le azioni di attacco.';

  @override
  String get territoryMapHintMobile =>
      'Sul cellulare puoi pizzicare dentro e fuori con due dita e trascinare direttamente la mappa ingrandita per le regioni più piccole.';

  @override
  String get territoryMapHintColors =>
      'I colori delle regioni mostrano la proprietà; arancione = concorso attivo.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country mappa (controllo Crew)';
  }

  @override
  String get territoryLegendTitle => 'Leggenda';

  @override
  String territoryYourCrewLine(String name) {
    return 'Il tuo Crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Anteprima della regione';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Solo la regione selezionata, senza il resto della mappa.';

  @override
  String get territoryNeutralTerritory => 'Territorio neutrale';

  @override
  String get territoryDetailOwner => 'Proprietaria';

  @override
  String get territoryDetailNeutral => 'Neutra';

  @override
  String get territoryDetailStability => 'Stabilità';

  @override
  String get territoryDetailEffectiveStability => 'Stabilità effettiva';

  @override
  String get territoryDetailControl => 'Controllare';

  @override
  String get territoryDetailValueTier => 'Livello di valore';

  @override
  String get territoryDetailPayout => 'Pagamento';

  @override
  String get territoryDetailStrategicRole => 'Ruolo strategico';

  @override
  String get territoryDetailAdjacentOwned => 'Regioni di proprietà adiacenti';

  @override
  String get territoryDetailActionBonuses => 'Bonus d\'azione';

  @override
  String get territoryDetailBonusInfo => 'Informazioni bonus';

  @override
  String get territoryDetailBonusInfoBody =>
      'Questi bonus aumentano solo i tuoi punti concorso per azione. Il versamento in € della Regione resta invariato.';

  @override
  String get territoryDetailWarPressure => 'Pressione bellica';

  @override
  String get territoryDetailAttackPressure => 'pressione di attacco';

  @override
  String get territoryDetailStabilityWord => 'stabilità';

  @override
  String get territoryWarRoleTheater => 'regione del teatro';

  @override
  String get territoryWarRoleAdjacent => 'regione adiacente';

  @override
  String get territoryWarRoleTarget => 'regione di destinazione';

  @override
  String get territoryWarPressureEndsIn => 'La pressione bellica finisce';

  @override
  String get territoryDetailIncomeHour => 'Reddito orario';

  @override
  String get territoryDetailIncomeDay => 'Reddito giornaliero';

  @override
  String get territoryDetailYourCrew => 'Il tuo Crew';

  @override
  String get territoryDetailContestStatus => 'Stato del concorso';

  @override
  String get territoryDetailYourRole => 'Il tuo ruolo';

  @override
  String get territoryDetailYourHqLevel =>
      'Il tuo livello di quartier generale';

  @override
  String get territoryDetailActionsUnlockIn => 'Le azioni si sbloccano';

  @override
  String get territoryDetailActionsCloseIn => 'Le azioni si avvicinano';

  @override
  String get territoryDetailContestEndsIn => 'Il concorso termina tra';

  @override
  String get territoryDetailCooldownPerAction => 'Tempo di recupero per azione';

  @override
  String get territoryDetailYourCooldown => 'Il tuo tempo di recupero';

  @override
  String get territoryNoticeCrewOnly =>
      'Il territorio è giocabile solo per i membri dell\'Crew. Prima crea o unisciti a un Crew, poi puoi attaccare le regioni neutrali.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Stai visualizzando $viewingCountry, ma attualmente ti trovi in ​​$playerCountry. Puoi esplorare questa mappa, ma gli attacchi e le azioni di concorso si sbloccano solo dopo aver viaggiato in questo paese.';
  }

  @override
  String get territoryNoticeOwnRegion =>
      'Il tuo Crew controlla già questa regione.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Il tuo Crew sta difendendo questa regione. Una volta iniziata la fase attiva, vedrai solo le azioni difensive.';

  @override
  String get territoryConfirmDefense => 'Conferma la difesa';

  @override
  String get territoryAttack => 'Attacco';

  @override
  String get territoryAttackerActions => 'Azioni dell\'attaccante';

  @override
  String get territoryDefenderActions => 'Azioni del difensore';

  @override
  String get territoryContestActions => 'Azioni del concorso';

  @override
  String get territoryIntelShort => 'Scansione Intel';

  @override
  String get territoryRequiresHqShort => 'richiede quartier generale';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Livello HQ più alto richiesto per: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Non fai parte di questo concorso, quindi non puoi eseguire azioni qui.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Questo concorso si svolge in un altro paese. Puoi seguirlo, ma puoi unirti solo quando sei fisicamente in $country.';
  }

  @override
  String get territoryLeaderboardEmpty =>
      'Nessun territorio ancora controllato.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regioni';
  }

  @override
  String get territorySeasonNone => 'Nessuna stagione attiva trovata.';

  @override
  String get territorySeasonCurrent => 'Stagione in corso';

  @override
  String get territorySeasonKey => 'Chiave';

  @override
  String get territorySeasonStatus => 'Stato';

  @override
  String get territorySeasonStart => 'Inizio';

  @override
  String get territorySeasonEnd => 'FINE';

  @override
  String get territoryDialogAttackTitle => 'Attacco?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Avviare un concorso per $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Unisciti prima a un Crew per attaccare il territorio.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Il concorso è iniziato. Stato: $status. Attendi il completamento della fase di preparazione prima di intraprendere azioni.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'Il concorso è già iniziato e la mappa è stata aggiornata. Stato: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points punti!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Confermata la difesa. Una volta iniziata la fase attiva, puoi eseguire azioni difensive.';

  @override
  String get territorySnackContestRefreshed =>
      'Lo stato del concorso è stato aggiornato. Ora puoi vedere immediatamente l\'attuale fase di difesa.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Richiede il livello HQ $required. Livello QG attuale: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (richiede HQ $level)';
  }

  @override
  String get smugglingHubTitle => 'Centro del contrabbando';

  @override
  String get smugglingHubSubtitle =>
      'Un unico sistema per farmaci, beni commerciali, veicoli, armi e munizioni. Viaggia vuoto e ritiralo in tutta sicurezza dal deposito.';

  @override
  String get smugglingClaimPersonal => 'Richiesta personale';

  @override
  String get smugglingClaimCrew => 'Reclama l\'Crew';

  @override
  String get smugglingNewShipment => 'Nuova spedizione';

  @override
  String get smugglingCategoryDrug => 'Droghe';

  @override
  String get smugglingCategoryTrade => 'Beni commerciali';

  @override
  String get smugglingCategoryVehicle => 'Veicoli';

  @override
  String get smugglingCategoryWeapon => 'Armi';

  @override
  String get smugglingCategoryAmmo => 'Munizioni';

  @override
  String get smugglingNoItemsInCategory =>
      'Nessun articolo disponibile in questa categoria.';

  @override
  String get smugglingFieldItem => 'Articolo';

  @override
  String get smugglingFieldDestination => 'Destinazione';

  @override
  String get smugglingTransport => 'Trasporto';

  @override
  String get smugglingCommercialChannel => 'Canale commerciale';

  @override
  String get smugglingOwnedVehicleAircraft => 'Veicolo/aereo di proprietà';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Non disponi di un veicolo o di un aereo di proprietà disponibile per il contrabbando in questo Paese.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Trasporto di proprietà';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capacità: $slots slot • Confisca in caso di fallimento: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots slot • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Rete';

  @override
  String get smugglingPersonal => 'Personale';

  @override
  String get smugglingCrew => 'Equipaggio';

  @override
  String get smugglingChannelField => 'Canale del contrabbando';

  @override
  String get smugglingQuantity => 'Quantità';

  @override
  String get smugglingVehiclesOneByOne =>
      'I veicoli vengono spediti uno per uno';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Massimo: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Inizia il contrabbando';

  @override
  String get smugglingSelectItemDestination =>
      'Seleziona l\'oggetto e la destinazione';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'Il contrabbando di equipaggi per merci commerciali non è ancora disponibile';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Seleziona prima un veicolo o un aereo di proprietà';

  @override
  String get smugglingInvalidQuantity => 'Quantità non valida';

  @override
  String get smugglingActionProcessed => 'Azione elaborata';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes min • $risk% di rischio';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return 'Rischio $percent%.';
  }

  @override
  String get smugglingQuotePrompt =>
      'Seleziona l\'articolo e la destinazione per un preventivo in tempo reale.';

  @override
  String get smugglingQuoteLiveTitle => 'Citazione dal vivo';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Mezzi di proprietà: $label';
  }

  @override
  String get smugglingHarborBonus =>
      'Bonus porto: rotta più veloce e meno sequestro (porto crew in questo paese).';

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Slot di carico: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Tempo di recupero attivo: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Canale consigliato: $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Contanti insufficienti per questa spedizione';

  @override
  String get smugglingDepotsTitle => 'Depositi nazionali';

  @override
  String get smugglingDepotsEmpty => 'Nessun pacco pronto nei depositi.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages pacchetti • $totalQuantity unità';
  }

  @override
  String get smugglingClaimHere => 'Richiedi qui';

  @override
  String get smugglingStatusTitle => 'Stato di contrabbando';

  @override
  String get smugglingNoShipmentsYet => 'Nessuna spedizione ancora.';

  @override
  String get smugglingStatusInTransit => 'In transito';

  @override
  String get smugglingStatusReady => 'Pronta';

  @override
  String get smugglingStatusSeized => 'Sequestrata';

  @override
  String get smugglingStatusClaimed => 'Reclamata';

  @override
  String get smugglingStatusUnknown => 'Sconosciuta';

  @override
  String get smugglingChannelPackage => 'Pacchetto';

  @override
  String get smugglingChannelCourier => 'Corriera';

  @override
  String get smugglingChannelContainer => 'Contenitrice';

  @override
  String get smugglingChannelOwned => 'Trasporto di proprietà';

  @override
  String get smugglingHintOwnedTransport =>
      'I trasporti di proprietà riducono costi e rischi, ma possono essere confiscati in caso di fallimento.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Suggerimento: i veicoli funzionano meglio con corriere o container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Suggerimento: è meglio caricare armi più grandi tramite Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Suggerimento: munizioni sfuse tramite container per ridurre il rischio.';

  @override
  String get smugglingHintDrugsChannel =>
      'Suggerimento: piccoli lotti tramite pacchetto, grandi quantità tramite contenitore.';

  @override
  String get smugglingHintCompareChannels =>
      'Suggerimento: confronta i canali con il preventivo in tempo reale.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Una barca non può entrare in un aereo.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'La capacità di carico del tuo trasporto di proprietà è troppo piccola.';

  @override
  String get smugglingQuoteUnavailable => 'Citazione non disponibile';

  @override
  String get smugglingApiInvalidChannel => 'Canale di contrabbando non valido';

  @override
  String get smugglingApiInvalidNetwork => 'Scelta della rete non valida';

  @override
  String get smugglingApiInvalidQuantity => 'Quantità non valida';

  @override
  String get smugglingApiInvalidDestination =>
      'Il paese di destinazione non esiste';

  @override
  String get smugglingApiPlayerNotFound => 'Giocatore non trovato';

  @override
  String get smugglingApiSameCountryInventory =>
      'Utilizza l\'inventario locale per lo stesso Paese';

  @override
  String get smugglingApiNotInCrew => 'Non fai parte di un Crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'Il contrabbando di equipaggi per merci commerciali non è ancora disponibile';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'I veicoli di proprietà funzionano solo per il contrabbando personale';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Scegli un veicolo o un aereo di proprietà';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Il veicolo di proprietà selezionato non è disponibile';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Non è possibile utilizzare lo stesso veicolo sia come carico che come trasporto';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Un\'auto o una moto non può trasportare un altro veicolo';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'I veicoli non possono utilizzare il canale dei pacchetti';

  @override
  String get smugglingApiBoatCannotFit =>
      'Una barca non può entrare in un aereo.';

  @override
  String get smugglingApiCargoOverflow =>
      'La capacità di carico del tuo trasporto di proprietà è troppo piccola.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Attendi ${seconds}s prima di un\'altra spedizione di $channel';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Non abbastanza soldi per le tasse sul contrabbando';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Non ci sono abbastanza farmaci nell\'inventario dell\'Crew';

  @override
  String get smugglingApiInsufficientDrugs =>
      'Farmaci insufficienti nell\'inventario';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Beni commerciali insufficienti nell\'inventario';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Armi insufficienti nell\'inventario dell\'Crew';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Armi insufficienti nell\'inventario';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Munizioni insufficienti nell\'inventario dell\'Crew';

  @override
  String get smugglingApiInsufficientAmmo =>
      'Munizioni insufficienti nell\'inventario';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Veicolo dell\'Crew non valido';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Barca con Crew non disponibile per il contrabbando';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Motocicletta dell\'Crew non disponibile per il contrabbando';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Auto dell\'Crew non disponibile per il contrabbando';

  @override
  String get smugglingApiInvalidVehicleKey => 'Veicolo non valido';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Veicolo non disponibile per il contrabbando';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Stock insufficiente per questa spedizione';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'Nessuna spedizione pronta presso il deposito di questo paese';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Quantità troppo alta per $channel. Massimo: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'È iniziata la spedizione di contrabbando ($channel) a $destination';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Ritirato/i $count spedizioni in $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Ritirate $count spedizioni dell\'Crew in $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Spedizione fallita';

  @override
  String get smugglingClientQuoteFailed => 'Citazione non riuscita';

  @override
  String get smugglingClientClaimFailed => 'Reclamo non riuscito';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Errore: $detail';
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
  String get cryptoMarketNoData =>
      'Nessun dato disponibile sul mercato delle criptovalute';

  @override
  String get cryptoMarketTitle => 'Mercato delle criptovalute';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Ordini aperti: $count';
  }

  @override
  String get cryptoRegimeBull => 'Mercato rialzista';

  @override
  String get cryptoRegimeBear => 'Mercato dell\'orso';

  @override
  String get cryptoRegimeSideways => 'Dilata';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Di proprietà: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portfolio';

  @override
  String get cryptoLabelValue => 'Valore';

  @override
  String get cryptoLabelCostBasis => 'Base di costo';

  @override
  String get cryptoLabelUnrealized => 'Non realizzato';

  @override
  String get cryptoLabelRealized => 'Realizzato';

  @override
  String get cryptoNoPositionsYet => 'Nessuna posizione ancora';

  @override
  String get cryptoChartDataUnavailable => 'Dati cartografici non disponibili';

  @override
  String get cryptoUnknownTime => 'Sconosciuta';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Prendi profitto';

  @override
  String get cryptoOrderTypeLimit => 'Limite';

  @override
  String get cryptoSideBuy => 'Acquistare';

  @override
  String get cryptoSideSell => 'Vendere';

  @override
  String get cryptoInvalidQuantity => 'Quantità non valida';

  @override
  String get cryptoPurchaseCompleted => 'Acquisto completato';

  @override
  String get cryptoSaleCompleted => 'Vendita completata';

  @override
  String get cryptoActionProcessed => 'Azione elaborata';

  @override
  String get cryptoInvalidTargetPrice => 'Prezzo target non valido';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Non puoi vendere più di quanto possiedi.';

  @override
  String get cryptoOpenOrderPlaced => 'Ordine aperto effettuato';

  @override
  String get cryptoOpenOrderFailed => 'Impossibile effettuare l\'ordine';

  @override
  String get cryptoOrderCancelled => 'Ordine annullato';

  @override
  String get cryptoCancelOrderFailed => 'Impossibile annullare l\'ordine';

  @override
  String get cryptoDirectTradeTitle => 'Commercio diretto';

  @override
  String get cryptoLabelQuantity => 'Quantità';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Prezzo attuale: €$currentPrice • Acquisto medio: €$avgBuy \nUtilizza ALL per vendere immediatamente la tua intera posizione.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Prezzo attuale: €$currentPrice • Acquisto medio: €$avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Prezzo attuale: €$currentPrice \nUtilizza ALL per vendere immediatamente la tua intera posizione.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Prezzo attuale: €$currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'La tua cronologia per $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Acquisto medio';

  @override
  String get cryptoLabelLastBuy => 'Ultimo acquisto';

  @override
  String get cryptoLabelBuyVolume => 'Acquista volume';

  @override
  String get cryptoLabelSellVolume => 'Vendi volume';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Ultimo acquisto alle $when';
  }

  @override
  String get cryptoNoTradesForCoinYet =>
      'Ancora nessuno scambio per questa moneta.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Ordini aperti per $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Gli ordini aperti utilizzano la propria quantità di seguito. Inserisci sia la quantità che il prezzo target in questa sezione.';

  @override
  String get cryptoLabelOrderType => 'Tipo di ordine';

  @override
  String get cryptoLabelSide => 'Lato';

  @override
  String get cryptoLabelOrderQuantity => 'Quantità dell\'ordine';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Questo ordine vende dalla tua posizione attuale. Di proprietà: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Questa quantità è separata dal commercio diretto di cui sopra.';

  @override
  String get cryptoLabelTargetPrice => 'Prezzo indicativo';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limita l\'acquisto al di sotto del prezzo, limita la vendita al di sopra del prezzo';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Viene eseguito quando il prezzo scende a questo livello';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Viene eseguito quando il prezzo sale a questo livello';

  @override
  String get cryptoPlaceOpenOrder => 'Effettua un ordine aperto';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Non hai ancora ordini aperti per questa moneta.';

  @override
  String get cryptoLabelCancel => 'Cancellare';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Dettagli crittografici • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Coniare';

  @override
  String get cryptoLabelPrice => 'Prezzo';

  @override
  String get cryptoLabelOwned => 'Posseduta';

  @override
  String get cryptoLabelOpenOrders => 'Ordini aperti';

  @override
  String get cryptoNotEnoughHistory => 'Non c\'è ancora abbastanza storia';

  @override
  String get cryptoChartPointsWord => 'punti';

  @override
  String get cryptoChartHourAbbrev => 'H';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • cronologia completa';
  }

  @override
  String cryptoChartDataCaptionHours(int count, String points, String hours) {
    return '$count $points • $hours';
  }

  @override
  String get cryptoChartRange1h => '1 ora';

  @override
  String get cryptoChartRange4h => '4 ore';

  @override
  String get cryptoChartRange8h => '8 ore';

  @override
  String get cryptoChartRange24h => '24 ore';

  @override
  String get cryptoChartRange7d => '7d';

  @override
  String get cryptoChartRange30d => '30 gg';

  @override
  String get cryptoChartRangeAll => 'Tutto';

  @override
  String get cryptoChartLive1h => 'In diretta • ultima 1 ora';

  @override
  String get cryptoChartLive4h => 'In diretta • ultime 4 ore';

  @override
  String get cryptoChartLive8h => 'In diretta • ultime 8 ore';

  @override
  String get cryptoChartLive24h => 'In diretta • ultime 24 ore';

  @override
  String get cryptoChartLive7d => 'Dal vivo • ultimi 7 giorni';

  @override
  String get cryptoChartLive30d => 'Dal vivo • ultimi 30 giorni';

  @override
  String get cryptoChartLiveAll => 'Dal vivo • storia completa';

  @override
  String get cryptoLabelTotal => 'Totale';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'Impossibile caricare il mercato delle criptovalute.';

  @override
  String get cryptoApiAssetNotFound => 'Criptovaluta non trovata.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'Impossibile caricare i dati del grafico crittografico.';

  @override
  String get cryptoApiNotLoggedIn => 'Non effettuato l\'accesso.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'Impossibile caricare il portafoglio.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Impossibile caricare la cronologia delle transazioni crittografiche.';

  @override
  String get cryptoApiInvalidQuantity => 'Quantità non valida.';

  @override
  String get cryptoApiInsufficientFunds => 'Non abbastanza soldi.';

  @override
  String get cryptoApiPurchaseFailed => 'Acquisto fallito.';

  @override
  String get cryptoApiNotEnoughCrypto =>
      'Non sono detenute abbastanza criptovalute.';

  @override
  String get cryptoApiSellFailed => 'Vendita fallita.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'Impossibile caricare gli ordini crittografici.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Prezzo target non valido.';

  @override
  String get cryptoApiInvalidOrderType => 'Tipo di ordine non valido.';

  @override
  String get cryptoApiInvalidOrderSide => 'Lato ordine non valido.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Questo tipo di ordine e questa combinazione di lato non sono consentiti.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Impossibile effettuare l\'ordine.';

  @override
  String get cryptoApiPlayerNotFound => 'Giocatore non trovato.';

  @override
  String get cryptoApiInvalidOrderId => 'ID ordine non valido.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Ordine non trovato o non più attivo.';

  @override
  String get cryptoApiCancelOrderFailed => 'Impossibile annullare l\'ordine.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Hai acquistato $quantity $symbol per €$total.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Hai venduto $quantity $symbol per €$total.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Ordine effettuato: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Ordine $orderId annullato.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Errore: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Errore durante il caricamento: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Errore durante il caricamento delle strutture: $error';
  }

  @override
  String get drugsInvTitle => 'Inventario dei farmaci';

  @override
  String get drugsInvKpiGramsLabel => 'inventario';

  @override
  String get drugsCutQualityDCannotCut =>
      'La qualità D non può essere ulteriormente tagliata.';

  @override
  String get drugsCutFailed => 'Taglio fallito';

  @override
  String get drugsSellFailed => 'Vendita fallita';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Vendi $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Disponibili: $qty gr';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Qualità: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Prezzo attuale: €$price al grammo';
  }

  @override
  String get drugsPricesByCountry => 'Prezzi per paese:';

  @override
  String get drugsQuantityGramsField => 'Quantità (grammi)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Totale: €$amount';
  }

  @override
  String get drugsInvalidQuantity => 'Quantità non valida';

  @override
  String get drugsSellAction => 'Vendere';

  @override
  String get drugsExportAction => 'Esporta';

  @override
  String drugsExportDialogTitle(String name) {
    return 'Export $name';
  }

  @override
  String get drugsExportDestLabel => 'Destinazione';

  @override
  String drugsExportQuoteStreet(String amount) {
    return 'Prezzo strada dest.: €$amount/g';
  }

  @override
  String drugsExportQuoteB2b(String amount) {
    return 'Ingrosso: €$amount/g';
  }

  @override
  String drugsExportPayout(String amount) {
    return 'Pagamento all\'arrivo: €$amount';
  }

  @override
  String drugsExportFee(String amount) {
    return 'Nolo: €$amount';
  }

  @override
  String drugsExportEta(String minutes) {
    return 'ETA: $minutes min';
  }

  @override
  String drugsExportSeizure(String pct) {
    return 'Sequestro: $pct%';
  }

  @override
  String drugsExportHeat(String heat, String fbi) {
    return 'Heat +$heat · FBI +$fbi';
  }

  @override
  String get drugsExportHarbor => 'Bonus porto attivo';

  @override
  String get drugsExportConfirm => 'Invia';

  @override
  String drugsExportMinHint(String grams) {
    return 'Minimo ${grams}g';
  }

  @override
  String get drugsExportFailed => 'Esportazione fallita';

  @override
  String get drugsExportStarted => 'Carico in transito. Contanti all\'arrivo.';

  @override
  String get drugsExportCannotAfford => 'Contanti insufficienti per il nolo';

  @override
  String get drugsExportCrewFeeHint => 'La banca della crew paga il nolo';

  @override
  String drugsExportCrewPayout(String crew, String runner) {
    return 'Pagamento: crew €$crew · corriere €$runner';
  }

  @override
  String get drugsExportCannotAffordCrew =>
      'La banca della crew non copre il nolo';

  @override
  String get drugsHubExportCrewPrefix => 'Crew';

  @override
  String get drugsCrewLotsTitle => 'Lotti di qualità della crew';

  @override
  String get drugsCrewExportStarted =>
      'Carico crew in transito. Contanti all\'arrivo sulla banca della crew.';

  @override
  String get drugsHubExportsTitle => 'Spedizioni all\'ingrosso';

  @override
  String get drugsHubExportInTransit => 'In transito';

  @override
  String get drugsHubExportSold => 'Venduto';

  @override
  String get drugsHubExportSeized => 'Sequestrato';

  @override
  String get drugsHubExportEmpty => 'Nessuna esportazione aperta';

  @override
  String drugsHubExportLine(String qty, String dest, String status) {
    return '${qty}g → $dest · $status';
  }

  @override
  String get drugsInvEmptyTitle => 'Nessun farmaco nell\'inventario';

  @override
  String get drugsInvEmptySubtitle => 'Avvia la produzione per creare farmaci';

  @override
  String get drugsInvSectionHeader => 'Inventario e distribuzione';

  @override
  String get drugsInvSectionBody =>
      'Vendi in loco o esporta un carico all\'ingrosso in un altro paese. Vendita di strada, nightclub, darkweb e Marketplace restano al dettaglio.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Posizione attuale: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventario: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Valore attuale: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Mercato: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Tagliare i farmaci';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Qualità $fromQ → $toQ: +$pct% di unità in più';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Risultato: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Taglio';

  @override
  String get drugsSlotsLabel => 'slot';

  @override
  String get drugsFacilitiesTitle => 'Strutture farmaceutiche';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Gestisci le tue strutture farmaceutiche';

  @override
  String get drugsFacilitiesHeroBody =>
      'Strutture come serre, coltivazioni di funghi, laboratori farmaceutici, cucine di crack e negozi nel darkweb determinano quali farmaci puoi produrre, quanti slot hai e quanto sono forti la tua qualità, resa e velocità.';

  @override
  String get drugsFacCurrentProductions => 'Produzioni attuali';

  @override
  String get drugsFacUnknownFacility => 'Impianto sconosciuto';

  @override
  String get drugsFacUnknownMessage => 'Messaggio sconosciuto';

  @override
  String get drugsFacUpgradeLockedTitle => '🔒 Aggiornamento farmaco bloccato';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Per prima cosa hai bisogno dei giusti livelli di istruzione e certificazioni sugli stupefacenti.';

  @override
  String get drugsFacEquipLockedTitle =>
      '🔒 Aggiornamento dell\'attrezzatura bloccato';

  @override
  String get drugsFacEquipLockedBody =>
      'Allena prima il tuo percorso Narcotici per sbloccare il livello di aggiornamento successivo.';

  @override
  String get drugsFacBuy => 'Acquistare';

  @override
  String get drugsFacOwned => 'Posseduta';

  @override
  String get drugsFacPrice => 'Prezzo';

  @override
  String get drugsFacRank => 'Rango';

  @override
  String get drugsFacDrugTypes => 'Droghe';

  @override
  String get drugsFacSlots => 'Slot';

  @override
  String get drugsFacQuality => 'Qualità';

  @override
  String get drugsFacYield => 'Prodotto';

  @override
  String get drugsFacSpeed => 'Velocità';

  @override
  String get drugsFacMaxSlots => 'Slot massimi';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Slot di aggiornamento (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Aggiornamenti dell\'attrezzatura';

  @override
  String get drugsFacMax => 'Massimo';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Livello $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Ambiente della droga';

  @override
  String get drugsSubviewProduction => 'Produzione di farmaci';

  @override
  String get drugsSubviewFacilities => 'Strutture farmaceutiche';

  @override
  String get drugsSubviewInventory => 'Inventario dei farmaci';

  @override
  String get drugsTagUndergroundOps => 'Operazioni sotterranee';

  @override
  String get drugsTagMobileOptimized => 'Ottimizzato per dispositivi mobili';

  @override
  String get drugsTagQualityDriven => 'Guidato dalla qualità';

  @override
  String get drugsEmpireTitle => 'Impero della droga';

  @override
  String get drugsHubIntro =>
      'Gestisci la produzione, le strutture e l\'inventario qui. Acquista materiali al mercato nero mentre il resto viene eseguito nel tuo ambiente farmaceutico.';

  @override
  String get drugsStatMaterialFlow => 'Flusso di materiale';

  @override
  String get drugsStatBlackMarket => 'Mercato nero';

  @override
  String get drugsStatProductionChain => 'Filiera produttiva';

  @override
  String get drugsStatProductionChainValue =>
      'Serra + Laboratorio + Cucina + Tela Oscura';

  @override
  String get drugsStatSalesModel => 'Modello di vendita';

  @override
  String get drugsStatPerQuality => 'Per qualità';

  @override
  String get drugsMetricActiveBatches => 'Lotti attivi';

  @override
  String get drugsMetricSlotUsage => 'Utilizzo degli slot';

  @override
  String get drugsMetricInventoryValue => 'Valore dell\'inventario';

  @override
  String get drugsMetricInventoryGrams => 'Grammi di inventario';

  @override
  String get drugsMetricEfficiency => 'Efficienza';

  @override
  String get drugsMetricPoliceHeat => 'Calore della polizia';

  @override
  String get drugsSectionOperations => 'Operazioni';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Scegli un ramo del tuo impero della droga';

  @override
  String get drugsCardOpenAction => 'Open';

  @override
  String drugsCardStepLabel(int step) {
    return 'Step $step';
  }

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastrutture';

  @override
  String get drugsCardFacilitiesTitle => 'Strutture';

  @override
  String get drugsCardFacilitiesBody =>
      'Acquista e migliora la serra, il laboratorio farmaceutico, la cucina di crack e il negozio del darkweb per più slot, velocità e qualità.';

  @override
  String get drugsCardProductionEyebrow => 'Conduttura';

  @override
  String get drugsCardProductionTitle => 'Produzione';

  @override
  String get drugsCardProductionBody =>
      'Avvia lotti, monitora i timer e raccogli gli output con rotoli di qualità.';

  @override
  String get drugsCardInventoryEyebrow => 'Distribuzione';

  @override
  String get drugsCardInventoryTitle => 'Inventario';

  @override
  String get drugsCardInventoryBody =>
      'Visualizza gli stack per qualità e vendi al miglior valore di mercato.';

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
  String get drugsQualityDistribution => 'Distribuzione di qualità';

  @override
  String get drugsQualityGradeSuperior => 'Superiore';

  @override
  String get drugsQualityGradeHigh => 'Alto';

  @override
  String get drugsQualityGradeStandardPlus => 'Standard+';

  @override
  String get drugsQualityGradeStandard => 'Standard';

  @override
  String get drugsQualityGradeLow => 'Basso';

  @override
  String get drugsHeatLevelLow => 'Basso';

  @override
  String get drugsHeatLevelMedium => 'Medio';

  @override
  String get drugsHeatLevelHigh => 'Alto';

  @override
  String get drugsHeatLevelCritical => 'Critica';

  @override
  String get drugsProdTitle => 'Produzione di farmaci';

  @override
  String get drugsProdLineTitle => 'Linea di produzione';

  @override
  String get drugsProdLineSubtitle =>
      'Avvia lotti, monitora la capacità degli slot e ottimizza la qualità tramite aggiornamenti di serre e laboratori.';

  @override
  String get drugsProdActiveProductions => 'Produzioni attive';

  @override
  String get drugsProdIncidentLegend => 'Leggenda dell\'incidente';

  @override
  String get drugsProdHide => 'Nascondere';

  @override
  String get drugsProdShow => 'Spettacolo';

  @override
  String get drugsProdLegendDelay => 'Ritardo';

  @override
  String get drugsProdLegendContamination => 'Contaminazione';

  @override
  String get drugsProdLegendYieldLoss => 'Perdita di rendimento';

  @override
  String get drugsProdLegendInstability => 'Instabilità';

  @override
  String get drugsProdLegendCombined => 'Problema combinato';

  @override
  String get drugsProdCollect => 'Raccogliere';

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
  String get drugsProdAvailableDrugs => 'Farmaci disponibili';

  @override
  String get drugsProdNoDrugs => 'Nessun farmaco disponibile';

  @override
  String get drugsProdAutoCollectOn => 'Raccolta automatica attivata (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Ritiro automatico disattivato (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Tutti i materiali disponibili';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: acquista i materiali mancanti in un clic';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Orario: $time | Resa: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total slot utilizzati';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility obbligatorio';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Grado $rank richiesto';
  }

  @override
  String get drugsProdNoFreeSlot =>
      'Nessuno slot di produzione libero disponibile';

  @override
  String get drugsProdOpenFacilities => 'Strutture aperte';

  @override
  String get drugsProdStartProduction => 'Avviare la produzione';

  @override
  String get drugsProdAutoCollectUpdated => 'Raccolta automatica aggiornata';

  @override
  String get drugsProdKpiActive => 'attiva';

  @override
  String get drugsProdKpiReady => 'pronta';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Resa: $qty grammi';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours ore';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours ora $minutes min';
  }

  @override
  String get drugsTimeHourEn => 'ora';

  @override
  String get drugsProdConfirmTitle => 'Sei sicuro?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return 'Avviare la produzione $drugName?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Orario: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Resa: $yield grammi';
  }

  @override
  String get drugsProdRiskNote =>
      'La produzione a volte può subire battute d’arresto. Migliori aggiornamenti riducono il rischio, l’elevato calore della droga lo aumenta.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Materiali richiesti:';

  @override
  String get drugsProdStartProductionButton => 'Avvia la produzione';

  @override
  String get drugsProdFailed => 'La produzione fallì';

  @override
  String get drugsProdCollectFailed => 'Raccolta non riuscita';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Hai bisogno del grado $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Mancante';

  @override
  String get drugsFacilityGreenhouse => 'Serra';

  @override
  String get drugsFacilityCrackKitchen => 'Cucina Crepa';

  @override
  String get drugsFacilityDarkweb => 'Vetrina del negozio Darkweb';

  @override
  String get drugsFacilityMushroomFarm => 'Fattoria dei funghi';

  @override
  String get drugsFacilityDrugLab => 'Laboratorio di droga';

  @override
  String get drugsVipQuickBuyTitle => 'Acquisto rapido VIP';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Hai già abbastanza materiali per $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Acquistare tutti i materiali mancanti per $name in un clic?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Totale: €$amount';
  }

  @override
  String get drugsPurchaseCompleted => 'Acquisto completato';

  @override
  String get drugsPurchaseFailed => 'Acquisto fallito';

  @override
  String get drugsServiceErrorGeneric => 'Errore';

  @override
  String get drugsApiFailedBuyMaterial => 'Impossibile acquistare il materiale';

  @override
  String get drugsApiFailedStartProduction =>
      'Impossibile avviare la produzione';

  @override
  String get drugsApiFailedCollect => 'Impossibile raccogliere la produzione';

  @override
  String get drugsApiFailedSell => 'Impossibile vendere farmaci';

  @override
  String get drugsApiFailedCut => 'Impossibile tagliare i farmaci';

  @override
  String get drugsApiFailedShipment => 'Impossibile inviare la spedizione';

  @override
  String get drugsApiFailedClaim =>
      'Impossibile richiedere le spedizioni in deposito';

  @override
  String get helpTopicDashboardCategory => 'Nucleo';

  @override
  String get helpTopicDashboardTitle => 'Pannello di controllo';

  @override
  String get helpTopicDashboardSummary =>
      'La tua panoramica centrale con tutte le tue statistiche, tempi di recupero attivi, eventi live e scorciatoie per ogni parte del gioco.';

  @override
  String get helpTopicDashboardHow =>
      'La barra superiore mostra: Contanti, Grado, Salute (0-100 HP), Livello ricercato (0-100) e Calore FBI (0-100). \nI titoli di grado seguono la stessa scala del tuo profilo pubblico: ad esempio Soldato intorno al grado 25 e Padrino solo dal grado 60. \nOgni 5 minuti si attiva un tick automatico: la fame scende -2, la sete -3, guarisci passivamente +5 HP (se HP > 0), vengono aggiunti gli interessi bancari (0,5%) e il livello ricercato scende leggermente quando è inferiore a 10. \nSe la fame o la sete raggiungono lo 0 muori e trascorri 3 ore in terapia intensiva. Mangia e bevi in ​​tempo! \nSul cellulare, un piè di pagina adesivo mantiene Crimini, Furto di veicoli, Lavoro, Banca ed Crew a portata di tocco. Un punto dorato su Crimini, Furto o Lavoro significa che il tempo di recupero è pronto. Tutto il resto è nel menu dell\'hamburger o nella barra laterale di sinistra; quel menu è raggruppato (Azioni, Mondo, Sociale, Economia, Impero, Risorse) e ricercabile. \nI timer di recupero per sezione mostrano quanto tempo manca alla disponibilità dell\'azione successiva. Il timer si adatta per mostrare l\'unità più rilevante: minuti, ore o giorni. \nLa scheda delle statistiche ora utilizza veri contatori live per evasioni, omicidi, contratti di hitlist, viaggi e proiettili invece di segnaposto fissi a zero. \nLa dashboard ora ha anche una sezione economica ampliata con contanti, banca, criptovalute, valore del veicolo, valore della proprietà, patrimonio netto e tendenza del flusso di cassa di 24 ore. \nIl blocco delle operazioni ora mostra la produzione attiva, il tempo di recupero più lungo, lo stato del veicolo (attivo/elencato/in transito) e i timer della produzione/evento successivo. \nQuando gli eventi dei giocatori sono in diretta (ad esempio, competizioni settimanali), lo stesso pannello di destra elenca brevemente i loro titoli e i collegamenti alla pagina Eventi. Puoi attivare o disattivare il push per l\'inizio/fine del round in Impostazioni → Eventi giocatore (oltre alle autorizzazioni del dispositivo e ad altre categorie push). \nNotifiche e rischi ora includono messaggi diretti non letti, ticket di supporto in attesa di risposta, eventi delle ultime 24 ore e un punteggio di rischio compatto (ricercato + FBI). \nQuando la tua squadra è coinvolta in Crew Wars, la dashboard mostra anche un riepilogo di Crew Wars con lo stato, l\'avversario, i punti della squadra, il grado della stagione e il tempo rimanente nella fase corrente. \nIl dashboard ora include anche una panoramica delle operazioni del veicolo per auto/moto/barca con chip di ricarica in tempo reale (hotspot, Crew, partita dell\'Crew, taglio, contratto e contatore), oltre a calore/reputazione, conteggi di contratti e reclami e punti stagionali. \nGli eventi dal vivo appaiono quando altri giocatori eseguono azioni importanti, quando vieni attaccato o quando si verificano movimenti del mercato globale. \nIl badge dei messaggi mostra i messaggi di sistema e i messaggi personali non letti. \nIl menu avatar in alto a destra apre Il mio profilo, i messaggi, la guida, le impostazioni e il logout. \nIl menu di navigazione a sinistra garantisce l\'accesso a tutte le sezioni del gioco raggruppate per categoria: Azioni, Mondo, Sociale, Economia, Impero e Risorse.';

  @override
  String get helpTopicDashboardTips =>
      'Apri prima la dashboard dopo ogni accesso per vedere cosa è cambiato mentre eri assente. \nMantieni il livello di ricercato al di sotto di 10 in modo che il decadimento automatico funzioni e le possibilità di arresto rimangano basse. \nControlla i messaggi non letti prima di intraprendere azioni rischiose: premi, evasioni degli ordini ed eventi di sistema appaiono tutti nella tua casella di posta.';

  @override
  String get helpTopicCrimesCategory => 'Azioni';

  @override
  String get helpTopicCrimesTitle => 'Crimini';

  @override
  String get helpTopicCrimesSummary =>
      'Commetti azioni illegali in cambio di denaro e XP, ma ogni tentativo rischia di danneggiare, arrestare o aumentare il livello di ricercato. Il crimine Wipe Criminal Record a fine partita rimuove l\'intera fedina penale in caso di successo, ma richiede strumenti pesanti e comporta un elevato rischio federale.';

  @override
  String get helpTopicCrimesHow =>
      'I tempi di recupero dei crimini ora aumentano con il potenziale guadagno: i crimini a basso rendimento rimangono veloci, mentre i crimini ad alto rendimento ottengono tempi di recupero chiaramente più lunghi. \nLinee guida per livello di premio: fino a 500 € ≈ 1,5 min, fino a 2.000 € ≈ 5 min, fino a 10.000 € ≈ 15 min, fino a 30.000 € ≈ 30 min, oltre ≈ 60 min. \nNon esiste un limite giornaliero rigido ai crimini; i giocatori attivi possono continuare a giocare purché gestiscano tempi di recupero, rischi e risorse. \nI crimini con \"arma richiesta\" utilizzano l\'arma del crimine selezionata. Ora puoi sceglierlo direttamente nella parte superiore della schermata Crimini o tramite Inventario. \nI bonus attivi da palestra e poligono di tiro (fino a +8% ciascuno) sono mostrati nella schermata Crimini; aumentano la probabilità di successo come calcola il server (allenati di più dal Centro di formazione / palestra + poligono). \nSe completi almeno una sessione in palestra e una al poligono nello stesso giorno solare UTC, il server aggiunge +0,5% di probabilità di successo sui crimini. La schermata Crimini mostra quando il combo è attivo. \nI crimini che richiedono un veicolo utilizzano il veicolo criminale selezionato da Garage o Marina. Conta solo un veicolo che si trova effettivamente nel tuo Paese attuale e non in transito o in vendita. \nIl fabbisogno di farmaci nei reati è indicato in grammi e segue le stesse quantità dell\'inventario e dello stoccaggio dei farmaci. \nSe un crimine non può iniziare a causa di un veicolo scomparso, di un\'arma sbagliata o di munizioni mancanti, il messaggio di errore ora dovrebbe mostrare la vera causa invece di un generico tentativo. \nAd ogni tentativo di crimine: subisci 5-15 danni HP e il livello di ricercato aumenta di 1-4 punti a seconda del successo o del fallimento. \nLa probabilità di arresto aumenta rapidamente con il livello di ricercato: ricercato 5 = 25%, ricercato 10 = 50%, ricercato 18+ = massimo 90%. \nAll\'arresto vai in prigione. Frase = max(livello desiderato × 10, 5) minuti. Cauzione = livello di ricercato × € 1.000. Anche se all’inizio un crimine sembra riuscito, ma poi si viene scoperti, il risultato finale conta comunque come un arresto: gli strumenti necessari vengono confiscati, l’arma usata del crimine viene persa e anche i veicoli possono essere sequestrati. \nAlcuni crimini richiedono un veicolo, uno strumento o un grado minimo. Mancare questi impedirà l\'inizio del crimine. \nGli XP guadagnati aumentano il tuo grado, sbloccando crimini migliori e ricompense più elevate. \nFBI La tensione aumenta con crimini più pesanti. Al di sopra dei 50 gradi l\'FBI diventa attivo con possibilità di arresto ancora più elevate.';

  @override
  String get helpTopicCrimesTips =>
      'Usa i crimini veloci per principianti per accumulare XP mentre aspetti grandi tempi di recupero. \nSalvati sempre se il tuo livello di ricercato è alto: stare in prigione blocca tutti i tuoi loop. \nMantieni gli HP sopra i 30 prima di iniziare una corsa al crimine: ogni tentativo costa HP e con 0 HP trascorri 3 ore in terapia intensiva.';

  @override
  String get helpTopicJobsCategory => 'Azioni';

  @override
  String get helpTopicJobsTitle => 'Lavori';

  @override
  String get helpTopicJobsSummary =>
      'Guadagna denaro legale senza il rischio del livello di ricercato. I posti di lavoro sono più sicuri dei crimini ma hanno picchi di rendimento inferiori.';

  @override
  String get helpTopicJobsHow =>
      'I lavori disponibili crescono in base al grado e all’istruzione: i lavori migliori pagano di più, ma hanno anche periodi di recupero più lunghi. \nI tempi di recupero dei lavori variano in base al pagamento massimo: lavori di livello basso circa 3-5 minuti, livello intermedio circa 8-12 minuti, livello superiore circa 17-22 minuti. \nI lavori hanno un tasso di successo elevato ma non perfetto; in caso di fallimento non perdi denaro o HP, ma perdi alcuni XP. \nRequisiti per lavoro: minimo 10 HP, fame > 20, sete > 20, non in carcere, non in terapia intensiva. \nNon esiste un limite giornaliero rigido per i posti di lavoro; la progressione è scandita dal tempo di recupero, dalla possibilità e dal pagamento invece che da un blocco giornaliero. \nLa retribuzione del lavoro varia in base al tipo di lavoro e al grado. L\'istruzione (scuola) può sbloccare posizioni più elevate. \nGuadagni anche XP per lavoro, anche se meno di crimini comparabili. \nUsa i lavori come base affidabile per il flusso di cassa, soprattutto quando il tuo livello di ricercato è troppo alto per crimini sicuri.';

  @override
  String get helpTopicJobsTips =>
      'Combinare lavoro e scuola: l’istruzione sblocca posti di lavoro migliori con compensi più elevati. \nQuando il livello di ricercato è superiore a 8 o ti stai riprendendo dall\'unità di terapia intensiva, usa i lavori invece dei crimini. \nEvita che la fame e la sete scendano troppo in basso: un lavoro con statistiche inferiori a 20 semplicemente non inizierà.';

  @override
  String get helpTopicTravelCategory => 'Mondo';

  @override
  String get helpTopicTravelTitle => 'Viaggio';

  @override
  String get helpTopicTravelSummary =>
      'Muoviti tra paesi per ottenere prezzi di mercato migliori, opportunità uniche e accesso ai sistemi internazionali.';

  @override
  String get helpTopicTravelHow =>
      'Paesi disponibili: Paesi Bassi (inizio), Belgio, Germania, Francia, Regno Unito, Spagna, Italia, Svizzera, Stati Uniti, Messico, Colombia, Brasile. \nSpese di viaggio: Paese limitrofo € 500-€ 2.000, Europa → Americhe € 5.000-€ 10.000, lunga distanza € 10.000-€ 20.000. \nRequisiti di viaggio: non in carcere, non in terapia intensiva, minimo 20 HP, fondi di viaggio disponibili. \nLe quantità di farmaci nel tuo inventario contano come grammi reali per il peso di trasporto e gli assegni di viaggio; 500 significa 500 g, non 50 kg. \nOgni paese ha prezzi di mercato diversi (differenza di prezzo fino al 300%), compensi diversi per i reati e articoli commerciali unici. \nRischio di trasporto: la polizia può sequestrare merci in base al livello di ricercato (probabilità = ricercato × 2%, massimo 80%). L\'FBI può sequestrare tutto a livello internazionale se la situazione è alta. \nL\'ispezione doganale ha una probabilità base del 10%. Puoi corrompere (€ 1.000-€ 5.000) o farti scoprire mentre perdi il 50% della merce. \nDopo l\'arrivo tutte le azioni sono immediatamente disponibili nel nuovo paese. I mercati e la velocità della criminalità variano in base alla località.';

  @override
  String get helpTopicTravelTips =>
      'Combina sempre il viaggio con il commercio, la droga o il contrabbando: i viaggi a vuoto sono uno spreco di denaro. \nAbbassa il tuo livello di ricercato prima della partenza: un livello elevato di ricercato aumenta notevolmente il rischio di confisca durante il viaggio. \nPianifica in anticipo il viaggio di ritorno in modo da sapere già cosa portare all\'arrivo.';

  @override
  String get helpTopicCrewCategory => 'Sociale';

  @override
  String get helpTopicCrewTitle => 'Equipaggio';

  @override
  String get helpTopicCrewSummary =>
      'Crea una squadra o unisciti ai giocatori esistenti per portare a termine insieme rapine, condividere spazio di archiviazione e diventare più forti come unità.';

  @override
  String get helpTopicCrewHow =>
      'Creare un Crew costa 10.000€. Il quartier generale dell\'Crew determina quanti membri può contenere la tua squadra e arriva fino a 150 membri. Il leader può invitare, calciare e avviare rapine. \nVantaggi per l\'Crew: accesso a grandi rapine, spazio di archiviazione condiviso, bonus per il lavoro di squadra (+10% di successo per membro extra, massimo +30%) e chat di gruppo. \nI nuovi equipaggi ora iniziano con il quartier generale dell\'Crew al livello 1 e tutti gli edifici di stoccaggio al livello 1, compreso il deposito di contanti, quindi la banca dell\'Crew e il deposito condiviso funzionano immediatamente. \nIl deposito delle auto dell\'Crew ora accetta anche le motociclette, quindi i veicoli terrestri possono essere gestiti insieme dallo stesso deposito dell\'Crew condiviso. \nQuando un membro dell\'Crew viene arrestato, i membri dell\'Crew ora ricevono una notifica push che informa che il giocatore è rinchiuso e in attesa di aiuto. \nLa schermata dell\'Crew è ora raggruppata in Panoramica, Quartier generale e potenziamenti, Deposito, Membri, Stanza di guerra, Missioni dell\'Crew, Equipaggi e Chat, in modo che la gestione sia più calma e professionale. \nMissioni Crew mostra modelli di livello, una scheda di corsa attiva e corse recenti. I leader/co-leader possono iniziare e risolvere; la richiesta delle ricompense e l\'accelerazione del tempo di recupero vengono gestiti nella stessa scheda. \nSono previste missioni dell\'Crew extra con operazioni a tema bancario (deposito notturno, rete di scrematura, percorso blindato, caveau sussidiario, caveau di riserva e stanza di compensazione). Non esiste una seconda missione per l\'Crew del casinò insieme a Casino Ledger Raid. \nI premi per le missioni dell\'Crew provengono dall\'economia delle missioni lato server; I saldi bancari degli altri giocatori non vengono addebitati per questi pagamenti. \nQuando inizi una missione ora puoi assegnare un ruolo a ciascun membro dell\'Crew (Pianificatore, Tutore, Logistico, Tecnologico) per i bonus di squadra. \nLe carte missione attive e recenti ora mostrano anche i contributi di ruolo per giocatore con il punteggio e l\'eventuale moltiplicatore di pagamento. \nI membri dell\'Crew ora ricevono anche avvisi push/in-app per l\'inizio della missione, il risultato della missione e quando il tempo di recupero della missione diventa di nuovo pronto. \nMentre è attivo il tempo di recupero di una missione, non puoi iniziare una nuova missione; prima attendi il tempo di recupero rimanente o acceleralo con i crediti. \nPer velocizzare il tempo di recupero, prima di confermare vedi il costo esatto del credito e i minuti rimanenti. \nCrew Wars ha la propria scheda War Room all\'interno della schermata dell\'Crew. Solo i leader possono dichiarare guerra e per partecipare sono necessari almeno 3 membri dell\'Crew. \nTipi di guerra: Kill War, Economy War, Territory War e Total War. Ogni guerra passa attraverso la preparazione, la fase attiva, il blocco e la risoluzione. \nDurante una guerra attiva, i partecipanti possono eseguire azioni come uccisioni, aggressioni, sabotaggi, informazioni, incursioni, scudi, potenziamenti e rivendicazioni di territori. Le azioni mirate ora ti consentono di scegliere direttamente da un elenco di membri dell\'Crew avversario invece di digitare manualmente l\'ID giocatore. \nI punti stagionali vengono aggregati nella classifica Crew Wars. La War Room mostra anche le classifiche, le azioni recenti e le guerre recenti del tuo Crew. \nIn Territory War e Total War ora rivendichi regioni territoriali reali dal sistema territoriale invece di obiettivi segnaposto generici. \nQuelle regioni di guerra ora mostrano anche il loro valore strategico nella War Room: bonus di rivendicazione, punti di controllo ed etichette come porto, capitale o logistica. Ciò rende immediatamente chiaro quali regioni valgano di più di un semplice scambio di proprietà. \nCrew Wars non sceglie più i bersagli territoriali solo in base al livello di valore, ma anche in base ai tag strategici e alla pressione adiacente del territorio dell\'attaccante o del difensore. Ciò fa sì che Territory War e Total War sembrino più una vera linea del fronte che tre affermazioni casuali. \nColpi: Piccola banca (2 giocatori, 40%, €10.000-€30.000, 30 minuti di recupero), Gioielleria (3 giocatori, 35%, €20.000-€50.000, 45 min), Colpo al casinò (4 giocatori, 25%, €50.000-€150.000, 2 ore), Federal Reserve (5 giocatori, 15%, €100.000-€500.000, 6 ore, +20 FBI Heat). \nPer una rapina tutti i membri devono essere online all\'inizio. Se qualcuno è assente la rapina fallisce. \nRapina fallita: carcere per tutti, livello ricercato +5, nessuna ricompensa. \nLa ricompensa del colpo viene divisa equamente tra tutti i membri partecipanti. \nLa chat dell\'Crew è disponibile per un rapido coordinamento. \nProgressione del quartier generale dell\'Crew: più lunga e attiva è l\'Crew, più potenziamenti e potenziamenti condivisi si sbloccano.';

  @override
  String get helpTopicCrewTips =>
      'I nuovi equipaggi possono depositare denaro e utilizzare immediatamente lo spazio di archiviazione condiviso; successivamente, concentrati sugli aggiornamenti per una maggiore capacità invece di un acquisto iniziale separato. \nControlla prima la War Room per vedere se il tuo Crew è ancora in ricarica prima di provare a dichiarare una nuova guerra. \nCoordina le chiamate ai bersagli nella chat dell\'Crew in modo da non continuare a coltivare lo stesso avversario e far inciampare la guardia anti-fattoria. \nCoordina gli orari di inizio delle rapine nella chat dell\'Crew in modo che tutti siano online e nessuno sia in prigione. \nScegli una squadra nello stesso fuso orario o nello stesso schema di attività per ottenere migliori percentuali di successo delle rapine. \nUtilizza il deposito condiviso per l\'Crew per separare le merci rischiose dal tuo inventario personale.';

  @override
  String get helpTopicFriendsCategory => 'Sociale';

  @override
  String get helpTopicFriendsTitle => 'Amiche';

  @override
  String get helpTopicFriendsSummary =>
      'Gestisci la tua lista di amici per un coordinamento più rapido, la navigazione del profilo e il feedback sui social.';

  @override
  String get helpTopicFriendsHow =>
      'La pagina Amici mostra tre elenchi: amici attuali, richieste inviate e richieste ricevute. \nDa un amico puoi inviare direttamente un messaggio, visualizzare il suo profilo o avviare una collaborazione. \nPuoi vedere quando gli amici sono attivi nel gioco, il che aiuta a pianificare rapine o scambi. \nLe richieste di amicizia non scadono automaticamente; mantieni l\'elenco in ordine in modo che le richieste in sospeso non ti distraggano. \nGli amici esterni al tuo Crew sono preziosi per le fughe di prigione (un amico può aiutarti a evadere) e per la condivisione di informazioni. \nQuando un amico viene arrestato, anche gli amici accettati ora ricevono una notifica push che il giocatore sta aspettando aiuto in prigione.';

  @override
  String get helpTopicFriendsTips =>
      'Aggiungi amici che condividono il tuo stile di gioco: partner nelle rapine, reti di commercianti o supporto al crimine. \nUn amico che esegue una fuga di prigione guadagna una ricompensa di € 500-€ 2.000 in caso di successo. Organizzalo per le emergenze.';

  @override
  String get helpTopicMessagesCategory => 'Sociale';

  @override
  String get helpTopicMessagesTitle => 'Messaggi';

  @override
  String get helpTopicMessagesSummary =>
      'La tua casella di posta con messaggi personali dei giocatori e messaggi di sistema su premi, ordini ed eventi di gioco.';

  @override
  String get helpTopicMessagesHow =>
      'I messaggi sono suddivisi in conversazioni personali e thread del sistema The Mob State. \nI messaggi di sistema vengono inviati automaticamente per: scambi di criptovalute, evasione di ordini, pagamenti in classifica, risultati di rapine, evasioni di prigione e badge di conseguimento. \nPuoi inviare messaggi ad altri giocatori purché le loro impostazioni sulla privacy lo consentano. \nI messaggi non letti vengono visualizzati come badge sull\'icona del messaggio e sono visibili dalla dashboard. \nI messaggi non scadono e vengono conservati come registro cronologico degli eventi dell\'account. \nUtilizza il registro della posta in arrivo in caso di dubbi su un pagamento, un ordine mancato o una modifica imprevista del saldo.';

  @override
  String get helpTopicMessagesTips =>
      'Controlla la tua casella di posta dopo lunghi periodi offline: premi, evasione degli ordini ed eventi sono tutti registrati lì. \nConfigura le preferenze di notifica tramite Impostazioni in modo da ricevere avvisi push solo per eventi veramente importanti.';

  @override
  String get helpTopicInventoryCategory => 'Gestione';

  @override
  String get helpTopicInventoryTitle => 'Inventario';

  @override
  String get helpTopicInventorySummary =>
      'Gestisci tutto ciò che trasporti, conservi ed equipaggia: armi, strumenti, veicoli, farmaci e beni commerciali.';

  @override
  String get helpTopicInventoryHow =>
      'L\'inventario si apre come una bambola di carta: il tuo avatar al centro, uno slot per l\'arma del crimine e uno slot per il gilet, oltre a slot quadrati per lo zaino.\nTrascina un elemento (o toccalo, quindi tocca un bersaglio valido) per spostarlo. Sui telefoni, il tocco per selezionare è più affidabile del trascinamento.\nSe una pila ha più di un\'unità (munizioni, materiali, armi o strumenti impilati), scegli quante unità spostare: 1, tutte o un importo personalizzato.\nLa griglia di destra è il contesto attuale: una casa o un magazzino in questo paese, o il deposito dei materiali. Apri spazio di archiviazione su una proprietà salta qui con quell\'edificio selezionato.\nLe case immagazzinano armi, munizioni, giubbotti e contanti. I magazzini immagazzinano gli strumenti. I materiali restano nel deposito di campagna, non in una casa. Cash utilizza i pulsanti, non il trascinamento.\nPuoi indossare un solo gilet. Lasciare un giubbotto sull\'avatar lo equipaggia; conservarlo in una casa lo disequipaggia. Un secondo giubbotto indossato viene rifiutato.\nLo slot dell\'arma del crimine rimane sincronizzato con la schermata Crimini. Contano solo le armi trasportate e utilizzabili.\nLa capacità dello zaino comprende strumenti, armi e materiali trasportati. Le munizioni e il giubbotto indossato non utilizzano gli slot dello zaino. Il server rifiuta pacchetti completi, paese sbagliato e tipo di proprietà sbagliato.\nGli equipaggiamenti rimangono una seconda scheda per i crimini salvati o i set di viaggio.\nI farmaci vengono archiviati e visualizzati in grammi; 351 significa 351g. Lo stoccaggio dell\'Crew rimane una scorta sicura separata.\nAll\'arresto la polizia può confiscare oggetti. I farmaci nell\'inventario aumentano il rischio dell\'FBI nei viaggi internazionali.';

  @override
  String get helpTopicInventoryTips =>
      'Mantieni leggero il tuo carico di trasporto quando sei in viaggio o durante un\'attività criminale ad alto rischio di arresto. \nUsa gli equipaggiamenti in modo da avere sempre l\'equipaggiamento giusto equipaggiato per ogni scenario. \nControlla regolarmente le condizioni degli articoli: gli strumenti rotti bloccano silenziosamente i crimini senza un chiaro messaggio di errore.';

  @override
  String get helpTopicPropertiesCategory => 'Economia';

  @override
  String get helpTopicPropertiesTitle => 'Proprietà';

  @override
  String get helpTopicPropertiesSummary =>
      'Acquista proprietà per espandere lo stoccaggio, la capacità abitativa e l\'accesso a determinati sistemi come la discoteca.';

  @override
  String get helpTopicPropertiesHow =>
      'Ogni proprietà ha il proprio ruolo: spazio di stoccaggio, capacità abitativa o accesso a un modulo successivo come la discoteca.\nGli aggiornamenti del magazzino aumentano la capacità di stoccaggio di articoli e altre scorte.\nLe case immagazzinano armi, munizioni, giubbotti e contanti; magazzini immagazzinano strumenti. L\'apertura del deposito in una casa o in un magazzino apre la bambola di carta Inventario con quell\'edificio selezionato. Devi essere nello stesso paese.\nCase e appartamenti aumentano la capacità abitativa; I giocatori VIP ricevono inoltre slot extra.\nAlcune proprietà sono uniche o bloccate nel paese: devi essere nel paese corretto per acquistarle o gestirle.\nLa vendita rende il 70% del prezzo di acquisto. Nessun tempo di recupero sulla vendita, è istantaneo.\nUna discoteca acquistata apre la schermata separata di gestione della discoteca; quel modulo gestisce la gestione e le entrate, non la panoramica delle proprietà.\nLo sviluppo spende denaro bancario: ogni livello aumenta in modo permanente il reddito passivo di quella proprietà (il livello massimo e il tempo di recupero sono ottimizzati dal server).';

  @override
  String get helpTopicPropertiesTips =>
      'Investi presto in un magazzino se hai bisogno di più spazio di archiviazione per gli altri tuoi sistemi. \nScegli case e appartamenti quando desideri costruire più capacità abitative per i relativi sistemi di gioco. \nNon vendere troppo in fretta: il 70% rappresenta un notevole ribasso rispetto al prezzo di acquisto.';

  @override
  String get helpTopicBankCategory => 'Economia';

  @override
  String get helpTopicBankTitle => 'Banca';

  @override
  String get helpTopicBankSummary =>
      'Deposita contanti funzionanti gratuitamente fino a un limite giornaliero. I contanti di grandi dimensioni devono essere riciclati con una commissione, ritardi e rischio di sequestro da parte dell\'FBI.';

  @override
  String get helpTopicBankHow =>
      'I depositi gratuiti sono istantanei e non prevedono commissioni, ma solo fino a un limite giornaliero proporzionale al tuo rango (giorno UTC). I prelievi rimangono gratuiti e illimitati. Utilizzare Riempi rimanente per inserire la quota rimanente di oggi; quando il limite è esaurito lo schermo mostra il conto alla rovescia fino alle 00:00 UTC.\nGli interessi bancari passivi sono attualmente disabilitati.\nIl denaro in banca è protetto dalle confische della polizia. Al momento dell\'arresto può essere perso solo il denaro contante.\nLo storico delle transazioni mostra tutti i flussi in entrata e in uscita con timestamp, importo, controparte del bonifico e descrizioni facoltative.\nRiciclaggio di denaro: trasferisci contanti al di sopra del limite giornaliero gratuito nella tua banca pagando una commissione e ritardando. Ogni lavaggio ha un minimo e un massimo, mostrati nella schermata bancaria. Una maggiore pressione da parte dell\'FBI aumenta le possibilità di sequestro; il successo abbassa leggermente il calore.\nCrimine di rapina in banca: riesce al 30% e ruba il 10-30% del saldo bancario di un altro giocatore a caso. Rischio di livello ricercato elevato.\nÈ possibile trasferire denaro ad altri giocatori. Facoltativamente puoi aggiungere una descrizione e anche il destinatario la vedrà nelle transazioni. Ricontrolla sia l\'importo che il destinatario prima di confermare.';

  @override
  String get helpTopicBankTips =>
      'Utilizza il deposito giornaliero gratuito per piccoli contanti lavorativi in ​​modo che sia al sicuro dalla confisca.\nRiciclare denaro contante più grande quando si accetta la commissione e si coglie il rischio; il calore più basso è più sicuro.\nConservare un piccolo capitale circolante in contanti per le spese dirette (cauzione, viaggio, attrezzi).';

  @override
  String get helpTopicCasinoCategory => 'Economia';

  @override
  String get helpTopicCasinoTitle => 'Casinò';

  @override
  String get helpTopicCasinoSummary =>
      'Punta contanti su slot, blackjack, roulette, dadi, baccarat e video poker. La casa ha tre piani (public/VIP/private) con rake visibile e puntata max. Alta varianza.';

  @override
  String get helpTopicCasinoHow =>
      'Giochi: slot, blackjack, roulette, dadi, baccarat e video poker.\nOgni tavolo usa la puntata max del piano e un rake visibile che resta nel bankroll del proprietario.\nPublic / VIP / Private alzano puntata max e rake. Il proprietario assume un dealer, una security e un promoter. Il dealer alza un po\' il rake; il promoter alza la puntata max e il heat; la security riduce il drain di casino_ledger_raid.\nGli stipendi escono dal bankroll a ogni tick. Troppo basso: licenzia il più economico.\nUn casino_ledger_raid riuscito drena una % del bankroll nel paese di partenza. Il premio cash della crew resta; è pressione extra, non un secondo print.\nSolo contanti. Le puntate perse spariscono.';

  @override
  String get helpTopicCasinoTips =>
      'Imposta un limite di sessione: mai più del 10% del cash.\nIl blackjack ha le quote migliori per un giocatore abile.\nProprietari: tieni più di 10.000 € e assumi security prima dei ledger raid.\nIl casinò è intrattenimento: il house edge vince.';

  @override
  String get helpTopicBlackMarketCategory => 'Economia';

  @override
  String get helpTopicBlackMarketTitle => 'Mercato nero';

  @override
  String get helpTopicBlackMarketSummary =>
      'Un hub: prima il contrabbando di beni commerciali (fiori, elettronica, diamanti, armi, prodotti farmaceutici), poi la scheda Mercato per i veicoli da giocatore a giocatore, strumenti trasportati, lotti di droga, lotti di criptovalute, pile di beni di scambio e oggetti evento trasferibili, oltre a zaini, materiali, mercato di armi e munizioni.';

  @override
  String get helpTopicBlackMarketHow =>
      'Scheda Beni commerciali: uno scorrimento continuo: prima le cinque linee di contrabbando (prezzi, limiti, chip di rischio: deterioramento, volatilità, danno da viaggio, sequestro), quindi l\'inventario da cui vendere. Acquista/vendi utilizza l\'API /trade; i guasti al carico parziale mostrano un banner di avviso. \nIl mercato nero è suddiviso in sottomercati: Materiali (materie prime), Armi (armi da fuoco e coltelli), Munizioni (munizioni per calibro), Veicoli (veicoli illegali). \nI prezzi e la disponibilità variano notevolmente in base al paese e al periodo. Un annuncio può esaurirsi rapidamente. \nLe transazioni del mercato nero non lasciano tracce ufficiali ma aumentano la pressione dell\'FBI per i grandi acquisti. \nLe armi acquistate qui possono essere utilizzate in crimini, PvP e sicurezza. Armi migliori danno maggiori danni e possibilità di successo. \nI filtri per categoria (tipologia, paese, prezzo, disponibilità) ti aiutano a trovare rapidamente l\'annuncio giusto. \nPuoi pubblicare le tue inserzioni come venditore, inclusi prezzo e quantità. Gli altri giocatori acquistano da te. \nLe inserzioni scadono dopo un certo tempo se invendute. Monitora le tue offerte tramite il tuo profilo. \nScheda Marketplace: transazioni in contanti peer-to-player. Un feed mostra i veicoli più gli elenchi dei giocatori per gli strumenti trasportati, le pile di farmaci (grammi + qualità), le partecipazioni in criptovalute e l\'inventario dei beni commerciali. Utilizza Vendi per scegliere un tipo, impostare quantità e prezzo. Le mie inserzioni coprono i tuoi annunci attivi. Non puoi acquistare il tuo annuncio. L\'impegno rimuove le azioni fino all\'acquisto o alla rimozione dalla quotazione.';

  @override
  String get helpTopicBlackMarketTips =>
      'Scheda Commercio: trascina per aggiornare se un segmento fallisce; guarda i chip rischiosi e i ricercati prima di correre rischi di contrabbando. \nAcquista armi e munizioni in grandi quantità quando i prezzi sono bassi: la disponibilità è temporanea. \nEvita grandi acquisti sul mercato nero quando FBI Heat ha già superato i 30. \nMarketplace: aggiorna dopo l\'inserimento nell\'elenco; elenca solo ciò che possiedi: gli strumenti devono essere trasportati, i farmaci/criptovalute/beni commerciali provengono dal tuo inventario/detenzioni. La rimozione dall\'elenco ripristina il deposito a garanzia.';

  @override
  String get helpTopicDrugsCategory => 'Impero';

  @override
  String get helpTopicDrugsTitle => 'Droghe';

  @override
  String get helpTopicDrugsSummary =>
      'Costruisci un\'operazione farmaceutica completa, dalle materie prime al prodotto finito. Gestisci catene di produzione, gestisci lo stoccaggio e vendi con margini elevati ma rischi seri.';

  @override
  String get helpTopicDrugsHow =>
      'Il sistema del farmaco è composto da: Hub (panoramica e statistiche), Strutture (potenziamento della capacità produttiva), Produzione (linee di produzione attive con timer) e Inventario (prodotti finiti e materie prime). \nAcquista materie prime tramite il mercato nero o il commercio. Combinali in una struttura per produrre farmaci. \nI timer di produzione vengono eseguiti mentre sei offline. Non è necessario alcun clic attivo: ricontrolla al termine del timer. \nL\'output finito rimane visibile in Produzione e mantiene occupato lo slot della struttura finché non lo raccogli; La raccolta automatica VIP elabora l\'output pronto automaticamente in background. \nLa capacità di stoccaggio è limitata per struttura. Quando lo spazio di stoccaggio è pieno la produzione si ferma automaticamente. \nUna vetrina del darkweb o un\'altra struttura non vende automaticamente i prodotti finiti: la vendita avviene comunque manualmente attraverso il flusso di vendita previsto. \nVendi farmaci tramite il mercato nero, la Colombia o altri luoghi di vendita speciali per ottenere il margine più elevato. \nFBI Heat aumenta ogni ciclo di produzione e extra sulle grandi vendite. Il calore elevato porta a eventi di raid che possono interrompere le tue operazioni. \nGli aggiornamenti della struttura riducono i tempi di produzione, aumentano la produzione ed espandono la capacità di stoccaggio. \nI giocatori VIP ottengono un pulsante fulmineo sulle carte di produzione: dopo una modalità di conferma, puoi acquistare tutti i materiali del lotto mancanti in un clic. \nGli aggiornamenti avanzati di slot e equipaggiamento sono legati al nuovo percorso formativo sugli stupefacenti (specialista di idroponica, specialista di processi elettrici, chimico clandestino). Senza il livello/certificazione richiesto non è possibile passare al livello di aggiornamento successivo. \nLa droga nell\'inventario aumenta il rischio di confisca durante i viaggi e i controlli di polizia.\nDall\'inventario puoi esportare un carico all\'ingrosso in un altro paese: resti sul posto, paghi il nolo e ricevi il cash B2B a destinazione all\'arrivo. Il sequestro non paga. Vendita di strada, nightclub, darkweb e Marketplace restano al dettaglio.';

  @override
  String get helpTopicDrugsTips =>
      'Aggiorna lo storage prima della produzione: lo storage completo interrompe la produzione e perdi quel tempo di produzione. \nMantieni l\'FBI Heat al di sotto di 50: sopra quella soglia sei attivamente cacciato con pesanti possibilità di raid che chiudono tutto. \nCombinare le vendite di farmaci con il contrabbando per ottenere margini più elevati e rischi distribuiti.\nEsporta solo se accetti nolo e sequestro; viaggiare e vendere in strada resta più redditizio al grammo.';

  @override
  String get helpTopicNightclubCategory => 'Impero';

  @override
  String get helpTopicNightclubTitle => 'Discoteca';

  @override
  String get helpTopicNightclubSummary =>
      'Gestisci una discoteca come parte del tuo impero criminale. Gestisci il personale, la sicurezza e l\'offerta per il reddito passivo e attivo con una classifica stagionale dedicata.';

  @override
  String get helpTopicNightclubHow =>
      'Nella parte inferiore ora utilizzi un centro di comando per la gestione dei nightclub con zone per l\'Crew, il deposito dei farmaci, il comando dei DJ, l\'unità di sicurezza e il laboratorio operativo; tutte le zone vengono eseguite in un flusso di pagine continuo senza scorrimento interno aggiuntivo. \nLo schermo del nightclub ora include una sezione centrale di Intelligence che combina panoramica, tendenze dei ricavi e registri dei rischi senza cambiare scheda. \nOps Lab ora include 11 sistemi: DJ residente, calendario dinamico degli eventi, albero degli aggiornamenti, risposta al calore/incidente della polizia, contratti con i fornitori, profili dei promotori, clientela VIP + caratteristiche del personale, percorsi di contrabbando, gestione di bar e cucine (bevande/cibo) con prezzi, sabotaggio rivale + controspionaggio e una sequenza temporale delle operazioni. \nLe rotte di contrabbando ora hanno un tempo di recupero della corsa (Porto 60 min, Pista di atterraggio 90 min, Borderline 120 min), costringendo la pianificazione del rischio/tempistica invece dello spam infinito. \nL\'albero degli upgrade è interattivo: scegli esplicitamente Sound Rig, VIP Lounge o Surveillance e acquista direttamente il livello successivo con costi di upgrade visibili. \nLe entrate vengono generate per tick in base alla qualità del DJ, all\'occupazione e alla disponibilità dell\'offerta. La mancanza di offerta riduce direttamente il reddito. \nI contratti DJ terminano automaticamente all\'ora di fine configurata; dopodiché dovrai prenotare nuovamente per nuovi potenziamenti. \nPossono verificarsi incidenti (risse, furti) quando la sicurezza è insufficiente. Ciò danneggia il punteggio e il reddito dei visitatori. \nOgni stagione ha una classifica. I giocatori con le entrate totali del nightclub più alte vincono premi stagionali. \nSinergia con i farmaci: la propria produzione di farmaci può fungere da approvvigionamento, aumentando i margini. \nLo stoccaggio dei farmaci è basato sui grammi: ogni selezione mostra i grammi disponibili prima di spostare le scorte nell\'inventario del nightclub. \nLe azioni rivali sono basate sul nome: cerchi i club rivali per nome del giocatore prima di selezionare un\'azione (non è richiesto l\'ID giocatore). \nSinergia con la prostituzione: gli eventi in sedi combinate danno visitatori extra e entrate più elevate. \nGli aggiornamenti migliorano la capacità, lo stoccaggio delle scorte e il numero massimo di DJ e guardie che puoi schierare.';

  @override
  String get helpTopicNightclubTips =>
      'Mantieni sempre la fornitura rifornita: un tick senza fornitura può innescare un calo dei visitatori da cui è difficile riprendersi. \nPrenota il miglior DJ che ti puoi permettere: la qualità del DJ ha il maggiore impatto diretto sulle entrate per tick. \nControlla quotidianamente la classifica della stagione e aumenta l\'offerta e i DJ se vuoi finire tra i primi 10.';

  @override
  String get helpTopicCryptoCategory => 'Economia';

  @override
  String get helpTopicCryptoTitle => 'Criptovaluta';

  @override
  String get helpTopicCryptoSummary =>
      'Scambia 30 criptovalute reali. Acquista e vendi direttamente o automatizza tramite ordini limite, stop-loss e take-profit. I prezzi ora seguono gli ancoraggi del mercato in tempo reale con regimi e notizie extra nel gioco e il popup delle monete utilizza campi separati per le negoziazioni dirette e gli ordini aperti.';

  @override
  String get helpTopicCryptoHow =>
      'L\'elenco delle criptovalute mostra 30 monete con il prezzo corrente, la percentuale su 24 ore e la tua attuale detenzione per moneta. La base dei prezzi segue i dati di mercato in tempo reale, ma è comunque influenzata dai regimi e dalle notizie del gioco. \nFai clic su una moneta per aprire il popup con: grafico in tempo reale (filtri temporali 1 ora, 4 ore, 8 ore, 24 ore, 7 giorni, 30 giorni, Tutto), cronologia acquisti, prezzo di acquisto medio e modulo di acquisto/vendita. \nCommercio diretto: inserisci la quantità e fai clic su Acquista o Vendi. Quando vendi puoi premere \"TUTTO\" per riempire istantaneamente la tua posizione completa. L\'esecuzione è immediata al prezzo di mercato corrente. \nOrdini aperti: Limit (acquisto/vendita a un prezzo target esatto), Stop-loss (vendita automatica quando il prezzo scende a una soglia), Take-profit (vendita automatica quando il prezzo sale a un target). Questa sezione ora ha il proprio campo quantità e il proprio campo prezzo target. \nGli ordini aperti vengono eseguiti automaticamente dal backend non appena il prezzo di mercato raggiunge l\'obiettivo. Non è necessario essere online. \nI regimi di mercato (Bull/Bear/Sideways) e le notizie influenzano i movimenti dei prezzi. Ricevi notifiche di regime tramite push quando abilitato. \nClassifica settimanale delle criptovalute: il giocatore con il guadagno realizzato più alto quella settimana vince un premio in denaro. \nLe missioni giornaliere e settimanali (ad esempio 3 operazioni redditizie, diversificare su 5 monete) danno ricompense extra al completamento. \nLa panoramica del portafoglio mostra: valore totale, importo investito, profitti/perdite realizzati e non realizzati.';

  @override
  String get helpTopicCryptoTips =>
      'Controlla la cronologia degli acquisti prima di effettuare un ordine di vendita: il popup mostra il prezzo di acquisto medio in modo da non vendere accidentalmente in perdita. \nUtilizza gli ordini stop loss su ogni posizione che non stai osservando attivamente: ti proteggono automaticamente quando sei offline. \nCambia i filtri temporali nel grafico: 1 ora e 4 ore mostrano la tendenza a breve termine, 7 giorni e 30 giorni mostrano il quadro più ampio.';

  @override
  String get helpTopicSmugglingCategory => 'Impero';

  @override
  String get helpTopicSmugglingTitle => 'Contrabbando';

  @override
  String get helpTopicSmugglingSummary =>
      'Spostare merci e veicoli illegali tra paesi. Scegli un canale commerciale o utilizza il tuo veicolo o aereo per ridurre i costi e aumentare il rischio di confisca.';

  @override
  String get helpTopicSmugglingHow =>
      'Scegli una categoria, l\'articolo specifico, la destinazione e poi decidi tra un canale commerciale o il tuo trasporto. \nAuto, motociclette, barche e aerei di proprietà ora mostrano un preventivo in tempo reale con slot di carico, costi inferiori e riduzione del rischio. \nUna barca può trasportare auto e moto; un aereo non può trasportare un\'imbarcazione e restituirà un errore immediato. \nLe probabilità di successo dipendono dal canale selezionato o dal trasporto posseduto, dal tuo attuale livello di ricercato e dalle dimensioni della spedizione. \nIn caso di fallimento si perde l\'intera spedizione. Nessun rimborso. I costi di carico e trasporto sono scomparsi. \nQuando si utilizza il trasporto di proprietà e la corsa fallisce, anche la risorsa di trasporto stessa può essere confiscata. \nLe spedizioni attive vengono monitorate in tempo reale in una panoramica. Dopo l\'arrivo il carico appare in un deposito pronto per il ritiro. \nLa rete dell\'Crew rimane disponibile per le spedizioni commerciali dell\'Crew, ma il trasporto di proprietà è solo personale.';

  @override
  String get helpTopicSmugglingTips =>
      'Non inviare mai l\'intero stock in un\'unica spedizione: dividilo in più carichi più piccoli per limitare perdite catastrofiche. \nAbbassa il livello di ricercato e l\'influenza dell\'FBI al minimo prima di iniziare una grande corsa di contrabbando. \nUsa il tuo aereo o la tua barca migliore per corse costose: i costi inferiori aiutano, ma gli slot di carico e la possibilità di confisca determinano comunque il rischio. \nRaccogli sempre i depot attivi il più velocemente possibile: i contenuti dei depot scaduti vengono persi in modo permanente.';

  @override
  String get helpTopicToolsCategory => 'Gestione';

  @override
  String get helpTopicToolsTitle => 'Utensili';

  @override
  String get helpTopicToolsSummary =>
      'Acquista e gestisci gli strumenti necessari per reati specifici. Gli strumenti buoni aumentano le probabilità di successo, gli strumenti usurati le riducono.';

  @override
  String get helpTopicToolsHow =>
      'Il negozio degli strumenti mostra tutti gli articoli disponibili con il prezzo, la valutazione delle condizioni e il tipo di crimine per cui sono richiesti. \nOgni categoria di crimine ha strumenti preferiti: il furto con scasso richiede piede di porco o grimaldelli, il furto d\'auto richiede un kit hotwire, la rapina richiede un\'arma da fuoco. \nGli strumenti hanno una valutazione della condizione (0-100%). Ogni crimine riuscito o fallito abbassa la condizione di una piccola percentuale. \nAl di sotto del 20% il bonus alla probabilità di successo dello strumento diminuisce drasticamente. Al di sotto del 5% lo strumento non ha quasi alcun effetto. \nGli strumenti riparati tramite il negozio costano una frazione del prezzo di acquisto. La sostituzione a volte è più economica della riparazione per strumenti molto usurati. \nGli strumenti sono visibili nella scheda dell\'inventario. È possibile conservare più copie dello stesso tipo come backup.';

  @override
  String get helpTopicToolsTips =>
      'Acquista utensili in grandi quantità quando costano poco al mercato nero: risparmi rispetto al negozio. \nImposta una soglia personale: sostituisci sempre gli strumenti quando le condizioni scendono al di sotto del 25% per mantenere stabili le possibilità di successo.';

  @override
  String get helpTopicCourtCategory => 'Rischio';

  @override
  String get helpTopicCourtTitle => 'Tribunale';

  @override
  String get helpTopicCourtSummary =>
      'Durante la sentenza puoi presentare ricorso o provare a corrompere il giudice per essere rilasciato prima.';

  @override
  String get helpTopicCourtHow =>
      'Una volta incarcerato, lo schermo del tribunale mostra la tua condanna attiva con il tempo rimanente, il crimine e il profilo del giudice. \nUn appello costa denaro in base alla durata della pena attuale. Se concessa, la pena viene solitamente ridotta di circa il 20-40%. \nPuoi fare appello solo una volta per condanna e ai tentativi rapidi si applica un tempo di recupero. \nLa corruzione utilizza un importo selezionato dal giocatore. Tale importo viene sempre detratto, anche quando il tentativo fallisce. \nUn importo di tangente più elevato aumenta le possibilità di successo. In caso di successo, verrai rilasciato immediatamente. \nLa tua fedina penale conserva le condanne precedenti con date e dettagli della storia del tribunale anche quando non sei più in prigione. \nUna tangente di un giudice riuscita rimuove solo quella condanna attuale dalla tua fedina penale. \nSe vuoi cancellare tutta la tua fedina penale, devi farlo fuori dal tribunale attraverso il crimine Wipe Criminal Record a fine partita.';

  @override
  String get helpTopicCourtTips =>
      'Utilizzate prima i ricorsi sulle frasi lunghe: lì il tempo previsto risparmiato è più alto. \nUtilizzare la corruzione solo con sufficiente riserva di liquidità, poiché il pagamento viene sempre detratto.';

  @override
  String get helpTopicHitlistCategory => 'Rischio';

  @override
  String get helpTopicHitlistTitle => 'Hitlist';

  @override
  String get helpTopicHitlistSummary =>
      'Metti una taglia su un nemico o accetta un contratto di successo. Elimina il tuo target nello stesso paese per il pagamento completo.';

  @override
  String get helpTopicHitlistHow =>
      'Tramite la hitlist aggiungi un giocatore impostando una taglia. La taglia minima è di 5.000€. Il pagatore perde immediatamente questo denaro. \nSe ti viene assegnata una taglia, riceverai immediatamente una notifica push e un messaggio nella posta in arrivo da Hitlist Bureau. \nI colpi attivi sono visibili a tutti i giocatori. Più alta è la taglia, più attenzione attira il contratto. \nLe indagini investigative non restituiscono più informazioni istantanee: i rapporti arrivano più tardi tramite un messaggio dell\'ufficio investigativo (Rapido 1 ora € 1.000.000, Standard 6 ore € 500.000, Lento 24 ore € 250.000). \nSe vieni ucciso tramite la lista nera, riceverai un messaggio dell\'Hitlist Bureau con un pulsante per avviare un\'indagine sull\'assassino entro 24 ore. \nSe richiedi questa indagine subito dopo l\'omicidio, il rapporto investigativo arriverà più velocemente. Un\'attesa più lunga implica un ritardo nel rapporto più lungo. \nPer eseguire un colpo devi trovarti nello stesso paese del tuo obiettivo. Attacchi tramite il profilo del giocatore. \nIl combattimento viene calcolato automaticamente in base a: armi, armature, statistiche (forza, riflessi), bonus dell\'Crew e livello attivo. \nIn caso di eliminazione riuscita riceverai l\'intera taglia. Se l\'attacco fallisce, perdi HP e il bersaglio sopravvive. \nIn caso di successo, il bersaglio riceve un duro reset dei progressi dell\'account: le risorse e i progressi vengono ripristinati allo stato di base, mentre il saldo bancario e la leadership dell\'Crew vengono preservati. Ricevi una parte del bottino disponibile oltre alla taglia. \nDopo un\'uccisione riuscita riceverai immediatamente un messaggio nella casella di posta da Hitlist Bureau con il dettaglio della taglia e del bottino (denaro + oggetti). \nI bersagli con una guardia del corpo attiva o una protezione di sicurezza sono più difficili da colpire. \nPuoi rimuovere il tuo nome dalla lista dei risultati pagando il placer o acquistando tu stesso la taglia.';

  @override
  String get helpTopicHitlistTips =>
      'Controlla quotidianamente la lista dei risultati: taglie elevate sui giocatori deboli sono un rapido profitto se ti trovi nello stesso paese. \nMetti una taglia su un giocatore solo quando hai motivo di credere che sia offline o con pochi HP.';

  @override
  String get helpTopicSecurityCategory => 'Rischio';

  @override
  String get helpTopicSecurityTitle => 'Sicurezza';

  @override
  String get helpTopicSecuritySummary =>
      'Proteggi il tuo personaggio e il tuo impero con armature, guardie del corpo e sicurezza dell\'installazione. Una migliore sicurezza significa meno danni subiti durante gli attacchi.';

  @override
  String get helpTopicSecurityHow =>
      'I giubbotti si comprano in Sicurezza: Giubbotto antistilettata (€7.500) → Giubbotto antiproiettile (€50.000) → Giubbotto antiproiettile premium (€125.000) → Giubbotto piastre AP (€280.000). I calibri 5.56, 7.62 e .308 forano i giubbotti normali, a meno che non indossi il giubbotto piastre AP.\nPuoi indossare solo 1 armatura alla volta; se acquisti un altro giubbotto, sostituirà immediatamente la tua attuale armatura. \nOgni classe di armatura riduce il danno in arrivo per attacco di una percentuale fissa. Armatura migliore = più sopravvivenza nel PvP e nei raid. \nL\'armatura viene danneggiata dopo un attacco e perde efficacia. Più bassa è la condizione, minore è la protezione fornita dalla tua attuale armatura. \nAl 100% di danno la tua armatura viene distrutta e scompare completamente; è necessario acquistare un nuovo set per riacquistare la protezione. \nLe guardie del corpo danno +10 difesa ciascuna, ma ogni 24 ore fanno pagare una paga giornaliera di € 10.000 per guardia del corpo. \nSe non puoi pagare la paga giornaliera della guardia del corpo, se ne vanno tutti e tu perdi immediatamente la loro protezione. \nLa sicurezza dell\'installazione (per nightclub, strutture farmaceutiche, ecc.) riduce le possibilità di incursioni e incidenti in quel luogo specifico. \nPiù alto è il tuo livello di ricercato, più spesso verrai attaccato o razziato. Una migliore sicurezza compensa direttamente questo. \nI membri dell\'Crew possono dividere i ruoli di sicurezza in modo che più posizioni siano coperte contemporaneamente.';

  @override
  String get helpTopicSecurityTips =>
      'Indossa sempre almeno un giubbotto antistilettata quando il livello di ricercato è 2 o superiore: i risparmi sulle bollette ospedaliere compensano rapidamente il prezzo di acquisto.\nControlla lo stato della tua armatura dopo ogni attacco: un giubbotto danneggiato fornisce solo una parte della sua protezione originale. \nMantieni solo il numero di guardie del corpo che puoi ancora permetterti domani; i team di grandi dimensioni diventano rapidamente costosi nella manutenzione quotidiana.\nLe munizioni da fucile (5.56, 7.62, .308) forano i giubbotti normali; compra il giubbotto piastre AP se quei calibri vengono usati contro di te.';

  @override
  String get helpTopicHospitalCategory => 'Recupero';

  @override
  String get helpTopicHospitalTitle => 'Ospedale';

  @override
  String get helpTopicHospitalSummary =>
      'Recupera HP dopo combattimenti, crimini falliti o raid. L’ospedale offre cure d’emergenza gratuite e trattamenti a pagamento per un recupero più rapido.';

  @override
  String get helpTopicHospitalHow =>
      'Se scendi sotto i 10 HP verrai automaticamente ammesso al pronto soccorso (ER). Questo è gratuito ma richiede più tempo. \nIl trattamento a pagamento costa 10.000 € a sessione e ripristina +30 HP. Cooldown: 60 minuti tra i trattamenti a pagamento. \nL\'ICU (terapia intensiva) è il trattamento più pesante per i danni critici. Recupero: 180 minuti. I costi sono più alti ma il recupero è più completo. \nCon HP più alti (50+) puoi comunque eseguire azioni ma sei più vulnerabile agli attacchi. \nLe cure ospedaliere sono bloccate mentre sei in carcere. Prima esci e poi fatti curare. \nIl diploma di scuola in Medicina abbatte i costi ospedalieri e accelera i tempi di recupero. \nI medici dell\'Crew o le abilità mediche possono ripristinare gli HP fuori dall\'ospedale come recupero di emergenza.';

  @override
  String get helpTopicHospitalTips =>
      'Non recuperare mai a metà strada: attendi i pieni HP prima di affrontare PvP o crimini ad alto rischio. \nTrattamenti a tempo pagati intorno al tempo di recupero: inizia un trattamento appena prima di andare offline in modo da tornare online al massimo dei HP.';

  @override
  String get helpTopicPrisonCategory => 'Recupero';

  @override
  String get helpTopicPrisonTitle => 'Prigione';

  @override
  String get helpTopicPrisonSummary =>
      'Sconta la tua pena detentiva, paga la cauzione o tenta di fuggire. Più alto è il tuo livello di ricercato, più lunga e costosa sarà la tua condanna.';

  @override
  String get helpTopicPrisonHow =>
      'Dopo l\'arresto parte un timer basato sul livello di ricercato. Livello di ricercato 1 = pena breve (minuti), Livello di ricercato 5+ = ore di prigione. \nLa cauzione è proporzionale alla pena rimanente e non scende mai al di sotto del livello di ricercato × € 1.000. Pene più lunghe costano quindi di più per il riscatto immediato. \nFuga: puoi tentare un\'evasione ma le possibilità di successo sono basse. Il fallimento estende la pena di un importo fisso. \nNell\'elenco delle prigioni e nello schermo delle prigioni puoi sempre pagare la tua cauzione e anche tentare la fuga mentre sei ancora in prigione. \nI membri dell\'Crew possono visitarti e fornirti piccoli benefici (statistiche, morale) mentre sei rinchiuso. \nAll\'arresto i tuoi amici e i membri dell\'Crew ora ricevono una notifica push che ti informa che sei stato catturato e stai aspettando aiuto. \nArmi e armature vengono confiscate all\'arresto se non si dispone di copertura legale per esse. \nOpzione tribunale: rivolgersi al tribunale per ottenere una riduzione di pena tramite un avvocato (vedi Tribunale). \nMentre sono bloccati, i timer di produzione (farmaci, fabbrica di munizioni) continuano a funzionare. Il tuo impero funziona senza di te. \nNon puoi visitare l\'ospedale mentre sei rinchiuso. Il ripristino HP attende finché non sei libero.';

  @override
  String get helpTopicPrisonTips =>
      'Controlla la cauzione subito dopo l\'arresto: il pulsante dovrebbe rimanere visibile finché rimani in prigione, anche se il tuo livello di ricercato è già sceso. \nAvvia i timer di produzione appena prima di intraprendere una corsa criminale ad alto rischio: se vieni scoperto, la produzione continua comunque a funzionare.';

  @override
  String get helpTopicVaultCategory => 'Eventi';

  @override
  String get helpTopicVaultTitle => 'Scassina il caveau';

  @override
  String get helpTopicVaultSummary =>
      'Stagione mensile del caveau: inserisci un codice a 4 cifre e punta i crediti per avere la possibilità di vincere grandi premi.';

  @override
  String get helpTopicVaultHow =>
      'Ogni mese una nuova stagione inizia il 1 e termina l\'ultimo giorno del mese. \nScegli una puntata (ad esempio 1/3/5 crediti) e inserisci un codice di 4 cifre. \nÈ anche possibile inserire il codice utilizzando la tastiera su schermo (pulsanti numerici). \nOgni tentativo costa crediti. Se indovini correttamente, vinci un premio. \nLe puntate più alte significano premi più grandi; a volte una ricompensa VIP può cadere. \nSe sei già VIP, un premio VIP viene convertito in crediti. \nPuoi visualizzare i codici errati per questo mese. L\'elenco si reimposta automaticamente con il nuovo mese.';

  @override
  String get helpTopicVaultTips =>
      'Scegli una puntata che corrisponda al tuo saldo crediti: puoi provare un numero illimitato di volte, ma ogni tentativo costa crediti. \nUtilizza l\'elenco dei codici errati per evitare di riprovare con lo stesso codice.';

  @override
  String get helpTopicGarageCategory => 'Attività';

  @override
  String get helpTopicGarageTitle => 'Garage';

  @override
  String get helpTopicGarageSummary =>
      'Ruba e gestisci auto e motociclette per crimini e contrabbando. Garage si occupa della proprietà, delle riparazioni a tempo, della vendita e della rottamazione; il trasporto passa attraverso l\'hub del contrabbando.';

  @override
  String get helpTopicGarageHow =>
      'Il tuo garage mostra auto e moto con condizioni (0-100%), carburante, valore di mercato, rarità e status di livello mondiale. \nIl deposito auto e il deposito moto sono ora separati: le auto utilizzano la capacità del garage, le moto utilizzano la capacità del deposito moto. \nGli aggiornamenti del deposito di auto e moto sono indipendenti in base al paese: l\'aggiornamento delle auto non aumenta la capacità delle moto (e viceversa). Gli aggiornamenti sono vincolati al rango; quando il tuo grado è troppo basso vedi un lucchetto/tooltip. Al livello 5 il pulsante di aggiornamento è nascosto. \nUsando il pulsante del catalogo puoi visualizzare tutte le auto e le motociclette rubabili, incluso il paese più comune e l\'elenco completo dei paesi di spawn. \nIl furto avviene per veicolo con requisiti di grado e tempi di recupero. Più è costoso e raro, minori sono le tue possibilità di successo. \nSe la copertura del mondo di un modello è piena, non puoi rubare quel modello temporaneamente. Quando una copia viene venduta o rottamata, 1 slot si riapre immediatamente. \nIl furto fallito aumenta il livello di ricercato e può innescare l\'arresto. Se la polizia ti sorprende durante la fuga, finisci in prigione e il veicolo appena rubato ti viene immediatamente confiscato. \nLe riparazioni sono a tempo: paghi in anticipo, il veicolo entra in riparazione e ritorna solo allo scadere del tempo. \nLe riparazioni simultanee sono limitate tra auto, moto e barca insieme: senza VIP max 1 attivo, con VIP max 2 attivi. \nLa rottamazione è un\'alternativa alla vendita: ricevi un valore di recupero (35% del valore base), proporzionale alle condizioni e al bonus di potenziamento del garage. \nVehicle Ops Intelligence aggiunge 6 opzioni extra. In breve: \n1) Corsa all\'hotspot: un\'azione rapida per denaro diretto, con il proprio tempo di recupero e rischio aggiuntivo. \n2) Mercato dei ricambi: prezzi in tempo reale dei ricambi per tipologia (auto/moto/barca) per il tuning; i prezzi si aggiornano periodicamente. \n3) Crew op: un\'azione cooperativa con la tua crew per guadagni/vantaggi extra (solo se fai parte di una crew). \n4) Calore: per tipologia (auto/moto/barca) un contatore “attenzione”; un calore più elevato rende le azioni più rischiose e riduce le possibilità di successo. Il calore decade lentamente. \n5) Contratto Chop: consegna un veicolo idoneo dal tuo inventario per un pagamento contrattuale fisso. \n6) Schema di polizia: gli schemi orari della giornata possono aumentare i controlli; ciò influisce sul rischio (ad esempio sciopero portuale/blocco delle imbarcazioni). \nIn Colpo di veicolo, Auto/Moto/Barca ora utilizzano un livello di comando: seleziona la categoria tramite le tre carte corsia in alto, senza una seconda riga di schede aggiuntiva. \nOgni scheda corsia include azioni rapide dirette per il furto e gli aggiornamenti dello spazio di archiviazione, quindi non è necessario scorrere prima fino ai pulsanti secondari separati. \nMentre è in corso il tempo di recupero del furto, accanto al timer appare l\'icona di un fulmine: toccala per spendere crediti e cancellare il tempo di recupero. Puoi disattivare la finestra di dialogo di conferma; riattivalo in Impostazioni sotto ricarica furto (crediti). \nLe carte corsia ora mostrano direttamente anche la capacità per tipo (usato/totale + livello di potenziamento). \nI veicoli rubati ora vengono visualizzati come carte reattive: i dispositivi mobili ne mostrano uno per riga, i tablet/desktop mostrano più carte affiancate. \nNuovo livello Operazioni: finestre di intercettazione PvP per hotspot, bonus per il ruolo dell\'Crew nelle operazioni dell\'Crew, sblocco della reputazione per tipo di veicolo, eventi regionali nella lista nera e contratti assicurativi contro il contrabbando. \nNuove espansioni per le operazioni sui veicoli: missioni di controintercettazione, matchmaking dell\'Crew con scala stagionale, modificatori nazionali (inflazione/corruzione/sciopero portuale) e una bacheca dei contratti con contratti leggendari settimanali. \nLe operazioni ora mostrano i tempi di recupero in tempo reale per azione. I timer effettuano il conto alla rovescia in modo visibile e si aggiornano automaticamente. \nLe azioni della crew (Crew Op e Crew Match) sono disponibili solo quando fai parte di una crew; senza un Crew ottieni un chiaro suggerimento di sblocco. \nLe azioni operative riuscite pagano in contanti direttamente sul tuo portafoglio. La panoramica delle azioni mostra il tipo di pagamento previsto per pulsante. \nLe richieste di indennizzo ora vengono esaminate per prime; l\'utilizzo della contestazione del reclamo ti consente di contestare un pagamento extra con il rischio di rifiuto. \nIl calore di categoria più elevata riduce le possibilità di successo del furto e aumenta il rischio di hotspot. Il calore diminuisce gradualmente ogni ora. \nI contratti Chop-Shop richiedono un veicolo idoneo dal tuo inventario; sostenendo consuma quel veicolo e paga i contanti del contratto. \nIl trasporto dei veicoli non avviene più nel Garage; utilizzare il flusso dell\'Hub del contrabbando. \nLa rivendita e la rottamazione liberano la capacità dell\'auto o della motocicletta e possono riaprire gli slot mondiali per quel modello. \nI veicoli riservati agli eventi, come gli intercettori della polizia, rimangono chiusi fuori dalle finestre degli eventi.';

  @override
  String get helpTopicGarageTips =>
      'Ruba attivamente i veicoli quando il livello di ricercato è basso: ricercato più alto = maggiore probabilità di fallimento durante il furto. \nMantieni sempre almeno un veicolo affidabile in ottime condizioni per il contrabbando: un veicolo rotto dimezza le tue possibilità di successo. \nUtilizzare la rottamazione per veicoli gravemente danneggiati come ripristino rapido della capacità; la vendita è spesso migliore a condizioni elevate.';

  @override
  String get helpTopicMarinaCategory => 'Attività';

  @override
  String get helpTopicMarinaTitle => 'Marina';

  @override
  String get helpTopicMarinaSummary =>
      'Gestisci barche con rarità, limiti mondiali e timer di riparazione per le rotte del contrabbando marittimo. Marina si occupa di proprietà, manutenzione, vendita e rottamazione; il trasporto passa attraverso l\'hub del contrabbando.';

  @override
  String get helpTopicMarinaHow =>
      'La marina mostra le tue barche con condizioni, carburante, valore di mercato, rarità e status di livello mondiale per modello. \nUsando il pulsante del catalogo puoi visualizzare tutte le barche rubabili, incluso il paese più comune e l\'elenco completo dei paesi di spawn. \nIl furto della barca ha i propri cancelli di rango e tempi di recupero. Le barche più costose sono più difficili da rubare ma possono essere più redditizie. \nSe la capienza del modello di una barca è piena, scompare temporaneamente dall\'elenco disponibile. La vendita/rottamazione riapre gli slot. \nLe riparazioni sono a tempo: paghi in anticipo e la barca non è disponibile fino allo scadere del tempo. \nLe riparazioni simultanee sono limitate tra auto, moto e barca insieme: senza VIP max 1 attivo, con VIP max 2 attivi. \nLa demolizione garantisce un valore di recupero (35% del valore base), proporzionale alle condizioni e al bonus di potenziamento del porto turistico. \nMarina gestisce solo la proprietà e la manutenzione; il percorso di trasporto effettivo avviene nell\'Hub del contrabbando. \nLe barche della polizia riservate agli eventi sono destinate a eventi temporanei e rimangono chiuse fuori dalle finestre degli eventi.';

  @override
  String get helpTopicMarinaTips =>
      'Investi nel porto turistico se le tue rotte di contrabbando passano regolarmente via acqua: un minore interesse della polizia può aumentare significativamente le possibilità di successo. \nMantenere un motoscafo in condizioni ottimali come alternativa rapida quando le vie di fuga via terra sono bloccate. \nDemolisci le barche gravemente danneggiate con un basso valore di rivendita per liberare spazio e capacità del porto turistico più velocemente.';

  @override
  String get helpTopicTuneshopCategory => 'Attività';

  @override
  String get helpTopicTuneshopTitle => 'Negozio di sintonizzazione';

  @override
  String get helpTopicTuneshopSummary =>
      'Usa le parti recuperate per aggiornare i veicoli per categoria. Migliora la velocità, la furtività e l\'armatura con costi di livello crescenti e tempi di recupero delle categorie.';

  @override
  String get helpTopicTuneshopHow =>
      'Guadagni parti rottamando veicoli: parti di automobili, parti di motociclette e parti di barche. \nI ricambi sono raggruppati per categoria: qualsiasi veicolo della stessa categoria utilizza lo stesso stock di ricambi. \nOgni aggiornamento costa parti e denaro. I costi in denaro sono basati sulla categoria e aumentano in base al livello di ottimizzazione. \nPuoi aggiornare tre statistiche: velocità, furtività e armatura. \nLa messa a punto è per veicolo nel tuo inventario. I nuovi veicoli iniziano nuovamente dal livello 0. \nDopo ogni brano c\'è un tempo di recupero per veicolo: auto 180, moto 120, barca 240. \nLa messa a punto simultanea è limitata: senza VIP massimo 1 veicolo attivo nel tempo di recupero della messa a punto, con VIP massimo 5. \nI veicoli messi a punto offrono un valore di vendita e di recupero più elevato. \nLa messa a punto è bloccata mentre il veicolo è in riparazione o in trasporto.';

  @override
  String get helpTopicTuneshopTips =>
      'Demolisci prima i veicoli gravemente danneggiati per costruire rapidamente le parti. \nInvesti subito nella furtività per ridurre il rischio di cattura nelle corse ad alto rischio. \nUsa potenziamenti dell\'armatura sui veicoli che schieri ripetutamente in circuiti pericolosi.';

  @override
  String get helpTopicShootingRangeCategory => 'Formazione';

  @override
  String get helpTopicShootingRangeTitle => 'Poligono di tiro';

  @override
  String get helpTopicShootingRangeSummary =>
      'Migliora la tua precisione e abilità con le armi attraverso esercitazioni di tiro strutturate. Statistiche più alte aumentano il danno e la probabilità di colpire in PvP e crimini.';

  @override
  String get helpTopicShootingRangeHow =>
      'Il poligono di tiro offre molteplici discipline: pistola, fucile, fucile e fuoco automatico. Ognuno allena un\'abilità con l\'arma separata. \nOgni sessione di allenamento ha un tempo di recupero di 30 minuti. Non puoi allenarti all\'infinito ogni giorno. \nUna maggiore precisione aumenta la probabilità di successo nei combattimenti PvP e riduce la possibilità di essere colpiti. \nL\'abilità dell\'arma determina anche quali armi puoi usare in modo efficace: un fucile di precisione richiede una certa abilità prima di ottenere il suo bonus completo. \nI risultati dell\'addestramento si accumulano cumulativamente. Non è previsto alcun ripristino a meno che non si riceva una pesante sanzione tramite il tribunale. \nIl certificato scolastico di Addestramento Militare conferisce un bonus permanente ad ogni sessione di tiro al poligono.';

  @override
  String get helpTopicShootingRangeTips =>
      'Allena il poligono di tiro ogni giorno: piccoli bonus cumulativi diventano evidenti nei risultati PvP entro una settimana. \nAddestra il tipo di arma che usi di più nei crimini e nel PvP per il massimo ritorno sull\'investimento.';

  @override
  String get helpTopicGymCategory => 'Formazione';

  @override
  String get helpTopicGymTitle => 'Palestra';

  @override
  String get helpTopicGymSummary =>
      'Allena forza, velocità e resistenza per migliorare le statistiche in PvP, crimini e pool di HP. L\'allenamento quotidiano è fondamentale per una rapida crescita delle statistiche.';

  @override
  String get helpTopicGymHow =>
      'La palestra offre tre categorie di allenamento: Forza (più danni per attacco), Velocità (riflessi più alti, meno colpi subiti), Resistenza (HP massimi più alti). \nOgni allenamento ha un tempo di recupero di 1 ora. Massimo 6-8 sessioni al giorno a seconda del titolo scolastico. \nLa forza aumenta il danno diretto sia in PvP che in alcuni tipi di crimine (rapina, rissa). \nLa velocità aumenta la possibilità di schivare un attacco e riduce la possibilità di essere scoperti in caso di fallimento di un crimine. \nLa resistenza aumenta la riserva di HP massimi. Più HP = sopravvivere più a lungo in PvP e più spazio per crimini rischiosi. \nIl certificato scolastico di Preparazione Fisica dà un bonus del 15% a tutte le sessioni in palestra.';

  @override
  String get helpTopicGymTips =>
      'Dai priorità all\'allenamento della resistenza: un pool di HP più elevato migliora tutti gli altri tuoi sistemi perché rimani attivo più a lungo. \nCombina palestra con poligono di tiro: Forza + Precisione è la combinazione PvP più forte.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Impero';

  @override
  String get helpTopicAmmoFactoryTitle => 'Fabbrica di munizioni';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produci munizioni per uso personale e gestisci la produzione dalla fabbrica. L\'acquisto e la vendita di munizioni avviene attraverso il mercato nero, non direttamente dalla schermata di fabbrica.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'La fabbrica di munizioni ha livelli di produzione (da livello 1 a 5). Livello più alto = più colpi per reclamo e migliore qualità. \nDurante una sessione attiva richiedi la produzione circa ogni 20 minuti (fino a 8 ore di arretrato all\'interno di quella sessione). \nLa produzione continua ad aumentare mentre sei offline: quando ritorni puoi richiedere più volte fino a quando non viene recuperato l\'arretrato. \nLa semplice visita della fabbrica di munizioni o il viaggio di andata e ritorno non devono cambiare proprietà; una fabbrica non dovrebbe passare allo stato \"in vendita\" solo perché lo schermo è stato aperto. \nLe munizioni prodotte vengono utilizzate personalmente nei crimini e nel PvP. Per acquistare e vendere munizioni, attraversa il mercato nero; lo schermo di fabbrica stesso non vende direttamente i proiettili. \nGli aggiornamenti dell\'output aumentano i giri per reclamo; gli aggiornamenti di qualità migliorano il valore di mercato. \nIl prezzo di mercato delle munizioni varia in base alla domanda. Fai scorta quando i prezzi sono bassi e vendi quando i prezzi sono alti. \nDurante un raid in fabbrica perdi parte della produzione immagazzinata. La sicurezza riduce questo rischio.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Migliora la tua fabbrica al livello 3 il prima possibile: la produzione raddoppiata rispetto al livello 1 la rende autosufficiente per le munizioni. \nMantieni sempre 2-3 round di produzione in riserva come buffer in modo da non rimanere mai senza munizioni durante il PvP.';

  @override
  String get helpTopicSchoolCategory => 'Formazione';

  @override
  String get helpTopicSchoolTitle => 'Scuola';

  @override
  String get helpTopicSchoolSummary =>
      'Segui corsi su più percorsi per sbloccare bonus, ridurre i costi e aprire nuovi sistemi. La scuola è un moltiplicatore di tutto quello che fai.';

  @override
  String get helpTopicSchoolHow =>
      'La scuola offre percorsi per dominio: Penale (migliori statistiche sulla criminalità), Economia (minori costi commerciali e bancari), Militare (bonus di combattimento), Medicina (minori costi ospedalieri), Giurisprudenza (minori costi legali), Tecnico (migliore fabbrica e produzione di farmaci). \nOgni lezione ha una durata di studio di 15-60 minuti a seconda del livello. I livelli più alti richiedono più tempo. \nDopo aver completato una lezione ricevi un certificato per quel livello di traccia. Questo certificato è permanente e concede il bonus immediatamente. \nPuoi seguire una sola lezione alla volta. Pianifica attentamente i tuoi studi quando hai bisogno urgentemente di un certificato specifico. \nI costi scolastici aumentano per livello. L’istruzione superiore richiede il completamento dei livelli precedenti dello stesso percorso. \nAlcune funzionalità avanzate del gioco sono protette da un certificato scolastico: ad es. accesso a determinati lavori, livelli di fabbrica più elevati, eventi in nightclub VIP e livelli di aggiornamento delle strutture farmaceutiche più elevati. \nI certificati non vengono mai ripristinati a meno che il tuo account non riceva una pesante penalità.';

  @override
  String get helpTopicSchoolTips =>
      'Inizia sempre con il percorso Criminale: i bonus alle possibilità di successo nel crimine ripagano i costi di studio in poche sessioni. \nPianifica studi lunghi (60 min+) prima di andare a dormire: ti svegli con un nuovo certificato senza perdere tempo attivo.';

  @override
  String get helpTopicTerritoryCategory => 'Impero';

  @override
  String get helpTopicTerritoryTitle => 'Territorio';

  @override
  String get helpTopicTerritorySummary =>
      'Rivendica e controlla le regioni geografiche per ottenere reddito passivo, prestigio dell\'Crew e bonus regionali strategici. Il territorio combina il controllo della mappa con concorsi e premi stagionali.';

  @override
  String get helpTopicTerritoryHow =>
      'La panoramica del territorio mostra tutti i paesi e le regioni disponibili per paese. Fare clic su un paese per visualizzare la mappa interattiva. \nTutti i paesi supportati sono ora completamente navigabili attraverso lo stesso flusso di mappe interattive dei Paesi Bassi. \nTocca una regione sulla mappa interattiva per aprire una finestra modale con le informazioni sul territorio e il pulsante di attacco. Le carte regionali separate sotto la mappa non sono più necessarie. \nLa visualizzazione è consentita ovunque, ma gli attacchi, le unioni di difesa e le azioni di competizione funzionano solo nel paese in cui si trova attualmente il tuo personaggio. \nSui dispositivi mobili ora puoi pizzicare dentro e fuori con due dita e trascinare direttamente la mappa ingrandita, rendendo più semplice toccare le regioni più piccole senza pulsanti aggiuntivi sulla mappa. \nIl territorio è basato sull\'Crew: devi creare o unirti a un Crew prima che il pulsante di attacco diventi disponibile per le regioni neutrali o ostili. \nOgni regione può essere controllata al massimo da un Crew alla volta. La proprietà garantisce un reddito passivo orario, ma il Territorio smette di versare alla banca dell\'Crew una volta raggiunto il limite di stoccaggio del contante. \nAvvia un concorso in una regione non rivendicata utilizzando il pulsante del concorso. Il concorso procede automaticamente attraverso la preparazione (tempo di preparazione), l\'attivazione (azioni) e il blocco (risoluzione). \nAl termine della preparazione, i membri dell\'Crew in attacco e in difesa ricevono una notifica push e un messaggio di posta in arrivo in modo che tu sappia che puoi attaccare o difendere. L\'avviso viene inviato ogni minuto anche se nessuno ha la schermata Territorio aperta. \nDurante un concorso attivo, la modalità regionale ora mostra anche quando si sbloccano le azioni, quando termina il concorso, qual è il tempo di recupero per azione e l\'importo in denaro reale che la regione paga per pagamento, per ora e al giorno. \nLe regioni ora hanno anche ruoli strategici come porto, industria, capitale, regione di confine o hub logistico. Quel ruolo determina quali azioni possono guadagnare punti extra lì. \nLe regioni adiacenti già possedute dalla tua squadra ora forniscono supporto extra durante le azioni del concorso. La modalità regionale mostra quali bonus strategici sono attivi e quanto supporto adiacente ha il tuo Crew in quell\'area. \nI bonus d\'azione ora possono provenire anche dalla progressione dell\'Crew: livello del quartier generale, livello della missione dell\'Crew e relativi edifici laterali (armi/munizioni/auto/barca/deposito di farmaci). Questi bonus aumentano solo i punti concorso, non i contanti passivi della regione. \nAlcune azioni di concorso avanzate sono vincolate al HQ: se il tuo livello HQ è troppo basso, il pulsante di azione mostra immediatamente \"richiede livello HQ X\". \nIl territorio non utilizza più un limite rigido di azioni giornaliere per impostazione predefinita (limite di runtime 0 = disabilitato). L\'equilibrio rimane controllato attraverso tempi di recupero, anti-fattoria e scelte di azioni strategiche. \nVincere una guerra territoriale o una guerra totale ora può lasciare una pressione bellica temporanea sulle regioni del territorio reale attorno a quella linea del fronte. La modalità regionale mostra quale Crew mantiene la pressione, quanta stabilità effettiva viene ridotta e quando scadono le conseguenze. \nQuando un concorso è appena iniziato o in un concorso più vecchio mancano ancora i campi di cronometraggio, lo schermo ora riempie immediatamente i timer e aggiorna la finestra modale all\'ultimo stato del concorso senza che tu debba prima allontanarti. \nGli attaccanti vedono solo le azioni dell\'attaccante (informazioni, sabotaggio, raid) e i difensori vedono solo le azioni del difensore (pattuglia, corsa ai rifornimenti, difesa), quindi la modalità non mostra più pulsanti misti confusi. \nUna regione ora mostra anche la resa reale del Territorio. I leader dell\'Crew vedono anche quante regioni e paesi controllano il loro Crew sulla dashboard, quanto guadagna attualmente l\'Crew e quanto territorio ha guadagnato in totale finora. \nI concorsi comportano il trasferimento della proprietà e premi (denaro, XP, prestigio). I perdenti ricevono anche XP parziali per la partecipazione. \nLe grandi regioni (porti, capitali) danno più entrate passive ma innescano anche più avversari e tentativi di raid. \nGli eventi stagionali offrono ricompense bonus e sfide speciali per gruppo regionale. \nPrevieni le situazioni di stallo: la tua squadra non può attaccare immediatamente lo stesso avversario dopo una sconfitta; attendere il raffreddamento. \nI controlli antiabuso impediscono a un Crew di attaccare ripetutamente lo stesso bersaglio in brevi finestre di tempo.';

  @override
  String get helpTopicTerritoryTips =>
      'Iniziare in un paese equilibrato con regioni di medie dimensioni: meno concorrenza rispetto ai paesi grandi ma reddito passivo ragionevole. \nConcentrati innanzitutto su un paese in cui il tuo Crew è forte: una migliore conoscenza porta a una migliore strategia di competizione rispetto a un controllo superficiale in molti paesi. \nUsa le stagioni come reset strategici: se perdi in una stagione secca, segue sempre una stagione migliore per la rimonta.';

  @override
  String get helpTopicProstitutionCategory => 'Impero';

  @override
  String get helpTopicProstitutionTitle => 'Prostituzione';

  @override
  String get helpTopicProstitutionSummary =>
      'Costruisci una rete di prostituzione con reclute, eventi e clienti VIP. Una rete ben gestita genera reddito passivo ma richiede una gestione attiva per controllare la rivalità e l’attenzione della polizia.';

  @override
  String get helpTopicProstitutionHow =>
      'L\'hub di Prostitution Empire ha quattro schede: Lavoratori, RLD, Eventi e Sociale.\nGestisci le reclute ciascuna con le proprie statistiche (esperienza, popolarità, disponibilità). Più reclute = reddito passivo più elevato.\nUtilizza la raccolta per saldare le entrate in sospeso mostrate nella striscia KPI.\nI turni di lavoro durano 8 ore per recluta: dopo un turno, quella recluta ha bisogno di un periodo di riposo prima di poter ricominciare.\nLa gestione della posizione è flessibile: sposta le reclute tra strada, quartiere a luci rosse e discoteca tramite il menu Sposta su ciascuna carta lavoratore.\nGli eventi sono booster temporanei: spettacoli speciali, serate VIP e feste aumentano le entrate per tick per la durata dell\'evento.\nRivalità: altri giocatori o concorrenti NPC possono derubare le tue reclute o sabotare eventi. Una maggiore sicurezza riduce questo rischio.\nI clienti VIP pagano molto di più ma richiedono reclute con elevata popolarità (oltre 80 anni) e una posizione protetta.\nL\'attenzione (calore) della polizia aumenta con grandi transazioni e raid. Il caldo elevato porta alla confisca dei redditi o alla chiusura temporanea.\nCombinazione con discoteca: una discoteca garantisce la copertura legale delle attività che rallentano l\'aumento del calore.\nUtilizza il pannello informativo sui guadagni in alto per confrontare rapidamente la produzione oraria per strada, RLD e nightclub.\nClassifica: il fatturato settimanale totale più alto vince un premio in denaro settimanale e un badge.';

  @override
  String get helpTopicProstitutionTips =>
      'Investi subito nella sicurezza: un attacco di rivalità che porta via la tua migliore recluta costa più dell’investimento in sicurezza. \nOrganizza eventi VIP solo quando le reclute hanno una popolarità superiore a 80: al di sotto di tale soglia i clienti VIP pagano semplicemente la tariffa standard.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Impero';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Quartieri a luci rosse';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Rivendica e gestisci i distretti territoriali per paese. Possedere un distretto fornisce reddito passivo e controllo sulle attività di prostituzione in quella regione.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'Ogni paese ha uno o più quartieri a luci rosse che possono essere rivendicati. Rivendica un distretto pagando un determinato importo di acquisto.\nCome proprietario di un distretto ricevi una percentuale di tutti i redditi derivanti dalla prostituzione in quel paese, compresi quelli provenienti da altri giocatori che operano lì.\nAltri giocatori possono attaccare il tuo distretto per assumerne la proprietà. Una maggiore sicurezza riduce la possibilità di attacco.\nNel dettaglio del distretto puoi aggiornare il livello (guadagni) e la sicurezza (rischio di raid) e visualizzare le statistiche dei raid in tempo reale (calore dell\'FBI, possibilità di raid). Una maggiore sicurezza riduce le possibilità di raid.\nPuoi possedere fino a 3 distretti contemporaneamente. La scelta strategica del paese è essenziale.\nI paesi più trafficati (Colombia, Dubai, Giappone) garantiscono il reddito passivo più elevato ma sono anche i più contestati.\nLa perdita di un distretto non rimborsa il prezzo di acquisto: viene perso definitivamente se un nemico lo rivendica con successo.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Inizia con un paese meno popolare per il tuo primo distretto: una minore pressione di attacco ti dà il tempo di migliorare la sicurezza prima della concorrenza reale. \nMigliora la sicurezza di ciascun distretto immediatamente dopo l\'acquisto: le prime 24 ore sono le più vulnerabili a un\'acquisizione.';

  @override
  String get helpTopicAchievementsCategory => 'Meta';

  @override
  String get helpTopicAchievementsTitle => 'Risultati';

  @override
  String get helpTopicAchievementsSummary =>
      'Guadagna badge raggiungendo traguardi su tutti i sistemi di gioco. I risultati danno ricompense, aumentano il tuo profilo di stato e mostrano i tuoi progressi per categoria.';

  @override
  String get helpTopicAchievementsHow =>
      'Gli obiettivi sono raggruppati in categorie: Crimini, Impero, PvP, Economia, Formazione, Sociale e Meta. \nOgni risultato ha più livelli (Bronzo, Argento, Oro, Platino). Ogni livello offre una ricompensa più alta e un badge più impressionante. \nI premi per risultato includono: denaro, XP, oggetti speciali, bonus permanenti o titoli unici per il tuo profilo. \nI progressi vengono monitorati automaticamente. Non è necessario attivare nulla: raggiungi la soglia e il badge viene assegnato subito. \nAlcuni risultati sono nascosti finché non li completi parzialmente: poi appariranno con il loro vero nome e i requisiti. \nI badge degli obiettivi sono visibili sul tuo profilo pubblico. Mostrano agli altri giocatori le tue specializzazioni ed esperienze. \nRisultati a catena: alcuni badge sono collegati in una catena. L\'oro richiede che l\'argento sia già ottenuto. Pianifica in anticipo per i livelli più alti.';

  @override
  String get helpTopicAchievementsTips =>
      'Controlla quotidianamente i tuoi risultati quasi completati: un piccolo sforzo extra può farti guadagnare un badge e una ricompensa in denaro che altrimenti tarderebbe di mesi. \nConcentrati subito sulle categorie Economia e Crimine: queste hanno il maggior numero di premi in denaro e sono più facili da combinare con il tuo normale gameplay.';

  @override
  String get helpTopicSupportTicketsCategory => 'Supporto';

  @override
  String get helpTopicSupportTicketsTitle => 'Rapporti e ticket';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Segnala bug, domande o feedback tramite il sistema di ticket. Il supporto e gli amministratori possono rispondere, gestire il follow-up interno e inviare aggiornamenti tramite la conversazione di supporto stessa e notifiche push opzionali.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Apri la voce di menu separata \"Supporto\" per rivedere i tuoi ticket o crearne uno nuovo. \nScegli una categoria (bug, domanda, feedback o altro), seleziona il modulo correlato se necessario e descrivi il tuo problema nel modo più specifico possibile. \nFacoltativamente, puoi aggiungere un riferimento come un ID ordine, un nome visualizzato o un breve contesto, oltre a uno screenshot se ciò aiuta. \nDopo l\'invio riceverai immediatamente un numero di ticket e il tuo ticket apparirà nella panoramica del supporto, dove il supporto può rispondere e creare attività interne da fare. \nQuando l\'assistenza risponde o lo stato del ticket cambia, lo vedi direttamente all\'interno della stessa conversazione di assistenza e puoi facoltativamente ricevere una notifica push (se le notifiche sono abilitate). \nLa voce di menu Supporto mostra un badge non appena un ticket riceve una nuova risposta di supporto o un aggiornamento di stato dall\'ultima visita alla panoramica del supporto. \nIl supporto utilizza stati come nuovo, valutazione, in corso, in attesa del giocatore, bloccato e risolto per tenere traccia della segnalazione internamente.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Includi sempre il tuo Paese, l\'azione e il messaggio di errore esatto; questo accelera le correzioni per gli sviluppatori. \nUtilizza un ticket per tipo di problema in modo che l\'elenco delle cose da fare e il follow-up rimangano chiari.';

  @override
  String get helpTopicSettingsCategory => 'Nucleo';

  @override
  String get helpTopicSettingsTitle => 'Impostazioni';

  @override
  String get helpTopicSettingsSummary =>
      'Gestisci tutte le impostazioni dell\'account: lingua, avatar, privacy, preferenze di notifica per sistema e opzioni di sicurezza. Le impostazioni influenzano direttamente la tua esperienza di gioco.';

  @override
  String get helpTopicSettingsHow =>
      'Lingua: passa dall\'olandese all\'inglese. Tutti i testi dell\'interfaccia utente, i messaggi di sistema e le notifiche si aggiornano immediatamente. \nAvatar: carica o seleziona un\'immagine del profilo visibile agli altri giocatori sul tuo profilo pubblico e nelle liste della crew. \nPrivacy: imposta chi può vedere il tuo stato online, la tua posizione (paese attuale) e le statistiche: solo tu, l\'Crew, i tuoi amici o tutti. \nNotifiche push: attiva/disattiva per sistema. Categorie: Crimini, Trading di criptovalute, Avvisi sui prezzi, Ordini, eventi dei giocatori dal vivo (competizione), Regime di mercato, Rapina, Discoteca, messaggi generali. \nSe il push era già consentito, la versione web/PWA si riconnette automaticamente al token del dispositivo corrente dopo un aggiornamento o un aggiornamento; devi solo riattivarlo in Impostazioni quando il browser stesso blocca le notifiche. \nLe preferenze di notifica crittografica rimangono salvate dopo aver lasciato le Impostazioni e riaperte in un secondo momento. \nNotifiche in-app: configurabili separatamente dalle push. In-app mostra gli avvisi all\'interno dell\'app senza inviare una notifica di sistema. \nSicurezza: cambia password, imposta l\'autenticazione a due fattori e visualizza le sessioni attive. \nPreferenza di notifica per sistema: ottimizzala in modo da non ricevere una tempesta di notifiche dai sistemi su cui non stai giocando attivamente.';

  @override
  String get helpTopicSettingsTips =>
      'Abilita le notifiche push per ordini crittografici ed eventi di rapina: si tratta di sistemi con tempi critici in cui è importante una reazione rapida. \nImposta la privacy solo per l\'Crew per la posizione quando sei attivo nella lista dei risultati: altrimenti gli altri giocatori potranno localizzarti esattamente.';

  @override
  String get helpTopicPremiumCategory => 'Nucleo';

  @override
  String get helpTopicPremiumTitle => 'Premi e crediti';

  @override
  String get helpTopicPremiumSummary =>
      'Acquista e gestisci Player VIP, Crew VIP e pacchetti di crediti qui. Questa panoramica mostra anche il saldo del tuo credito e tutte le voci di credito disponibili che puoi utilizzare direttamente o contestualmente.';

  @override
  String get helpTopicPremiumHow =>
      'Apri la pagina separata \"Premium e crediti\" dal menu laterale per visualizzare il tuo stato VIP, le date di scadenza, il saldo del credito e le opzioni di acquisto. \nSu ciascun riquadro di acquisto, tocca/fai clic sull\'icona \"i\" in alto a sinistra per dettagli e vantaggi completi; il riquadro stesso mostra intenzionalmente solo brevi informazioni principali e il pulsante Acquista. \nIl VIP del giocatore è personale. Crew VIP si applica alla tua crew e ha valore solo quando fai già parte di una crew. \nIl giocatore VIP offre timeout d\'azione più brevi del 10% (il tempo di prigione rimane invariato), 100 crediti settimanali, un pulsante di acquisto VIP con un clic per i materiali mancanti nella produzione di farmaci (dopo la conferma dei costi) e un reset della morte più morbido: banca/criptovaluta/istruzione/risultati rimangono, mentre le risorse, l\'inventario e le scorte di farmaci vengono rimossi. \nIl pagamento VIP apre la pagina di pagamento e poi ritorna alla sezione \"Premium e crediti\" del gioco, così potrai vedere immediatamente se l\'acquisto è andato a buon fine e per quanto tempo dura il tuo VIP. \nI pacchetti di crediti vengono acquistati con denaro reale. Dopo un pagamento andato a buon fine, i crediti appaiono immediatamente nella panoramica del tuo portafoglio. \nIl Pass Evento (7 giorni, denaro reale) è elencato nella griglia delle offerte una tantum: +10% di punteggio sugli eventi dei giocatori dal vivo, più un piccolo bonus di credito dopo l\'acquisto. È un grado secondario: non un combattimento diretto o un potenziamento PvP; aiuta principalmente i risultati della classifica durante gli eventi di corsa. \nGli articoli di credito utilizzano i crediti del portafoglio anziché gli euro. Pensa alla protezione dai colpi, al ripristino dei tempi di recupero, ai potenziamenti degli eventi o ai pacchetti di denaro, a seconda di ciò che l\'amministratore ha attualmente abilitato dal vivo. \nNelle schermate di timeout supportate (come crimini, lavori, furto di veicoli/barche e scuola) ottieni anche un pulsante di accelerazione diretto per i tempi di recupero attivi, quindi non è necessario tornare prima a Premium e crediti. \nAlcuni elementi di credito funzionano direttamente da questa schermata. Gli elementi legati al contesto, come alcune azioni del veicolo, vengono invece utilizzati dalla schermata del veicolo o del garage corretto (i veicoli danneggiati mostrano un pulsante di riparazione istantanea direttamente sulla carta). \nPer i pulsanti contestuali come l\'accelerazione della riparazione, il costo attuale del credito viene mostrato direttamente sul pulsante/descrizione comando. \nI prezzi e gli articoli disponibili sono gestiti in tempo reale nell\'amministratore. Ciò significa che i prezzi VIP, i costi del credito e l\'offerta disponibile possono cambiare senza aggiornamento dell\'app.';

  @override
  String get helpTopicPremiumTips =>
      'Controlla il saldo del tuo credito e la data di scadenza prima di acquistare nuovamente; estendere è spesso meglio che impilare alla cieca. \nUsa i crediti principalmente su potenziamenti o protezioni critici in termini di tempo, non automaticamente su ogni piccola scorciatoia. \nSe non fai ancora parte di una crew, inizia con Player VIP o un pacchetto di crediti prima di Crew VIP.';

  @override
  String get landingHeroTitle => 'Lo Stato mafioso';

  @override
  String get landingHeroSubtitle =>
      'Un profondo gioco di strategia criminale basato su testo nel tuo browser. Costruisci il tuo impero, gestisci equipaggi, commercia, combatti per il territorio e scala le classifiche.';

  @override
  String get landingAboutTitle => 'Cosa ti aspetta';

  @override
  String get landingAboutBody =>
      'Gestisci attività, esegui lavori e rapine, sviluppa il tuo personaggio attraverso certificati scolastici, competi in eventi dal vivo e coordinati con il tuo Crew sulla mappa del mondo. Regole competitive giuste, progressione a lungo termine e aggiornamenti regolari dei contenuti.';

  @override
  String get landingTopPlayersTitle => 'I migliori giocatori';

  @override
  String get landingTopCrewsTitle => 'Migliori equipaggi (territorio)';

  @override
  String get landingRankLabel => 'Rango';

  @override
  String get landingRegionsLabel => 'Regioni';

  @override
  String get landingLoadError =>
      'Impossibile caricare le classifiche in questo momento.';

  @override
  String get landingEmptyLeaderboard => 'Nessuna voce ancora.';

  @override
  String get landingCtaLogin => 'Login';

  @override
  String get landingCtaRegister => 'Creare un account';

  @override
  String get landingFooterPrivacy => 'politica sulla riservatezza';

  @override
  String get landingFooterTerms => 'Termini di servizio';

  @override
  String get landingFooterDigitalGoods => 'Acquisto di beni digitali';

  @override
  String get landingFooterLanguage => 'Lingua';

  @override
  String landingCopyright(int year) {
    return '© $year Lo Stato mafioso. Tutti i diritti riservati.';
  }

  @override
  String get legalPrivacyTitle => 'politica sulla riservatezza';

  @override
  String get legalPrivacyLastUpdated => 'Ultimo aggiornamento: maggio 2026';

  @override
  String get legalPrivacyIntro =>
      'La presente Informativa sulla privacy spiega come The Mob State (\"noi\") gestisce i dati personali quando utilizzi il nostro sito Web, il gioco Web e i servizi correlati. Giocando o navigando accetti questa politica ove consentito dalla legge applicabile.';

  @override
  String get legalPrivacySection01Title => 'Chi siamo';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State è un gioco online gestito come servizio digitale. Per richieste di privacy potete contattarci tramite il sistema di ticket di supporto in-game previa registrazione, oppure tramite i canali di contatto del sito ufficiale se pubblicati.';

  @override
  String get legalPrivacySection02Title => 'Dati che raccogliamo';

  @override
  String get legalPrivacySection02Body =>
      'Potremmo elaborare i dati dell\'account (nome utente, email se fornita, password con hash), dati di gioco e di progressione, registri tecnici (indirizzo IP, tipo di dispositivo/browser, timestamp), riferimenti relativi ai pagamenti dai nostri fornitori di servizi di pagamento (non memorizziamo i numeri completi delle carte) e le comunicazioni inviate all\'assistenza.';

  @override
  String get legalPrivacySection03Title => 'Scopi';

  @override
  String get legalPrivacySection03Body =>
      'Utilizziamo i dati per fornire il gioco, proteggere gli account, prevenire abusi e frodi, elaborare gli acquisti, migliorare le prestazioni, comunicare messaggi di servizio e rispettare gli obblighi legali.';

  @override
  String get legalPrivacySection04Title => 'Basi giuridiche (SEE/Regno Unito)';

  @override
  String get legalPrivacySection04Body =>
      'Laddove si applica il GDPR, facciamo affidamento sull\'esecuzione di un contratto (fornitura del gioco), interessi legittimi (sicurezza, analisi, miglioramento del prodotto in equilibrio con i tuoi diritti), consenso ove richiesto (ad esempio alcuni cookie di marketing o comunicazioni facoltative) e obblighi legali.';

  @override
  String get legalPrivacySection05Title => 'Cookie e archiviazione locale';

  @override
  String get legalPrivacySection05Body =>
      'Utilizziamo cookie e tecnologie simili per mantenerti connesso, ricordare le preferenze, misurare l\'utilizzo di base e fornire funzionalità essenziali. Puoi controllare molti cookie attraverso le impostazioni del tuo browser.';

  @override
  String get legalPrivacySection06Title => 'Conservazione';

  @override
  String get legalPrivacySection06Body =>
      'Conserviamo le informazioni per il tempo necessario a gestire il servizio e a soddisfare i requisiti legali, fiscali e contabili. Alcuni registri potrebbero essere conservati per un periodo di sicurezza limitato. Quando i dati non sono più necessari, li cancelliamo o li rendiamo anonimi, ove possibile.';

  @override
  String get legalPrivacySection07Title => 'Condivisione';

  @override
  String get legalPrivacySection07Body =>
      'Condividiamo i dati con l\'infrastruttura e i processori di pagamento rigorosamente secondo quanto necessario per eseguire il servizio, in base ad accordi appropriati. Non vendiamo i tuoi dati personali. Potremmo divulgare informazioni se richiesto dalla legge o per proteggere i diritti e la sicurezza.';

  @override
  String get legalPrivacySection08Title => 'Trasferimenti internazionali';

  @override
  String get legalPrivacySection08Body =>
      'I tuoi dati potrebbero essere trattati nello Spazio Economico Europeo e/o in altre regioni in cui operiamo noi o i nostri fornitori. Utilizziamo garanzie come clausole contrattuali standard ove richiesto.';

  @override
  String get legalPrivacySection09Title => 'I tuoi diritti';

  @override
  String get legalPrivacySection09Body =>
      'A seconda della tua posizione, potresti avere i diritti di accesso, rettifica, cancellazione, limitazione o opposizione a determinati trattamenti e alla portabilità dei dati. Lei potrà proporre reclamo ad un\'autorità di controllo. Contattaci tramite supporto per esercitare i diritti; potremmo aver bisogno di verificare la tua identità.';

  @override
  String get legalPrivacySection10Title => 'Bambine';

  @override
  String get legalPrivacySection10Body =>
      'Il gioco non è rivolto ai bambini di età inferiore a quella in cui è richiesto il consenso dei genitori per il trattamento nella tua regione. Se ritieni che un bambino abbia fornito dati in modo improprio, contattaci e adotteremo le misure appropriate.';

  @override
  String get legalDigitalGoodsTitle => 'Acquisto di beni digitali';

  @override
  String get legalDigitalGoodsLastUpdated =>
      'Ultimo aggiornamento: maggio 2026';

  @override
  String get legalDigitalGoodsIntro =>
      'Questa politica descrive gli acquisti di contenuti e servizi digitali in The Mob State (ad esempio crediti premium, tempo VIP o altri articoli virtuali). Completando un acquisto accetti questi termini insieme a tutti i termini di pagamento mostrati al momento del pagamento.';

  @override
  String get legalDigitalGoodsSection01Title =>
      'Natura degli acquisti digitali';

  @override
  String get legalDigitalGoodsSection01Body =>
      'Tutti gli acquisti sono pagamenti per l\'accesso a funzionalità online aggiuntive e oggetti virtuali all\'interno di The Mob State. Vengono consegnati digitalmente nel gioco e non hanno forma fisica.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Consegna e ritiro immediati (Regno Unito/UE)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Laddove si applichino i regolamenti sui contratti con i consumatori del 2013 (Regno Unito) o norme UE equivalenti, riconosci che il contenuto digitale viene fornito immediatamente dopo l\'acquisto e, ove la legge lo consenta, potresti perdere il diritto di recesso legale di 14 giorni una volta iniziata la consegna con il tuo previo consenso esplicito.';

  @override
  String get legalDigitalGoodsSection03Title => 'Rimborsi e chargeback';

  @override
  String get legalDigitalGoodsSection03Body =>
      'I beni digitali generalmente non sono rimborsabili una volta consegnati, tranne nei casi in cui le leggi obbligatorie sui consumatori richiedono diversamente. Riaddebiti o controversie sui pagamenti dopo la consegna possono portare alla sospensione o alla chiusura dei relativi account; contatta prima l\'assistenza per consentirci di risolvere i problemi di fatturazione.';

  @override
  String get legalDigitalGoodsSection04Title => 'Autorizzazione ed età';

  @override
  String get legalDigitalGoodsSection04Body =>
      'Devi essere autorizzato ad utilizzare il metodo di pagamento scelto. Se hai meno di 18 anni, hai bisogno dell\'autorizzazione di un genitore o tutore per effettuare acquisti o utilizzare servizi a pagamento.';

  @override
  String get legalDigitalGoodsSection05Title =>
      'Canali e commissioni di pagamento';

  @override
  String get legalDigitalGoodsSection05Body =>
      'I prezzi possono essere visualizzati in euro o nella valuta del tuo fornitore. Gli operatori di telefonia mobile o le piattaforme di pagamento possono aggiungere le proprie tariffe; verifica con il tuo fornitore prima di confermare i pagamenti con l\'operatore o con il portafoglio.';

  @override
  String get legalDigitalGoodsSection06Title => 'Disponibilità';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Le funzionalità a pagamento vengono fornite virtualmente tramite i nostri server e possono cambiare nel tempo. Potremmo modificare, sospendere o ritirare articoli, pacchetti o prezzi specifici per bilanciare il gioco o per motivi tecnici.';

  @override
  String get legalDigitalGoodsSection07Title =>
      'Nessun valore in contanti nel mondo reale';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Gli oggetti e le valute virtuali non hanno valore monetario al di fuori del gioco, non sono trasferibili con denaro reale e possono essere alterati o rimossi nell\'ambito di aggiornamenti, applicazione dell\'account o interruzione del servizio, tranne nei casi in cui la legge richiede un risarcimento.';

  @override
  String get legalDigitalGoodsSection08Title => 'Uso commerciale vietato';

  @override
  String get legalDigitalGoodsSection08Body =>
      'Non puoi utilizzare The Mob State per effettuare transazioni non autorizzate di denaro reale, incluso l\'acquisto o la vendita di account, valuta di gioco, codici o risorse virtuali per contanti o servizi esterni al di fuori dei nostri flussi di pagamento ufficiali.';

  @override
  String get legalDigitalGoodsSection09Title => 'Modifiche al servizio';

  @override
  String get legalDigitalGoodsSection09Body =>
      'Potremmo aggiornare questa politica e le descrizioni degli acquisti in-game. L\'uso continuato dopo le modifiche costituisce l\'accettazione dei termini modificati ove consentito dalla legge.';

  @override
  String get legalDigitalGoodsSection10Title => 'Legge applicabile';

  @override
  String get legalDigitalGoodsSection10Body =>
      'A meno che la legge locale obbligatoria non disponga diversamente, questa politica è regolata dalle leggi di Inghilterra e Galles e le controversie saranno soggette alla giurisdizione esclusiva dei tribunali di Inghilterra e Galles.';

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
  String get helpTopicTrainingHubCategory => 'Formazione';

  @override
  String get helpTopicTrainingHubTitle => 'Centro di formazione';

  @override
  String get helpTopicTrainingHubSummary =>
      'Palestra (forza) e poligono di tiro (precisione) in un unico posto. Entrambi i bonus aumentano le tue possibilità di successo nel crimine; la precisione di tiro viene utilizzata anche nelle azioni della hitlist. Ogni traccia ha il proprio tempo di recupero e un limite di 100 sessioni.';

  @override
  String get helpTopicTrainingHubHow =>
      'Palestra: ogni sessione aumenta il tuo bonus forza permanente fino al +8% totale (100 sessioni). Il tempo di recupero tra le sessioni è di 1 ora (VIP può accorciarlo).\nPoligono di tiro: ogni sessione aumenta il tuo bonus permanente di precisione fino al +10% totale (100 sessioni). Il tempo di recupero tra le sessioni è di 1 ora (VIP può accorciarlo).\nEntrambi i bonus vengono aggiunti dal server nei calcoli del successo del crimine.\nAlleni ogni traccia separatamente: due timer e due pulsanti di allenamento: uno schermo.\nI progressi non si ripristinano a meno che il personale non applichi una pesante penalità.';

  @override
  String get helpTopicTrainingHubTips =>
      'Pianifica entrambe le tracce quotidianamente: piccoli passi si accumulano in un netto vantaggio sui crimini.\nEsamina i crimini in cui fallisci di più: forza e precisione si completano a vicenda: non sono la stessa statistica.';

  @override
  String territoryCapsLine(
    int owned,
    int maxRegions,
    int active,
    int maxContests,
  ) {
    return 'Regioni $owned/$maxRegions · Concorsi $active/$maxContests';
  }

  @override
  String territoryCapsRegionsChip(int owned, int max) {
    return 'Regioni $owned/$max';
  }

  @override
  String territoryCapsContestsChip(int active, int max) {
    return 'Concorsi $active/$max';
  }

  @override
  String get territoryDetailProject => 'Progetto Regione';

  @override
  String get territoryProjectSafehouse => 'Rete di rifugi';

  @override
  String get territoryProjectStatusBuilding => 'Edificio';

  @override
  String get territoryProjectStatusActive => 'Attiva';

  @override
  String get territoryProjectStatusDamaged => 'Danneggiata';

  @override
  String get territoryProjectStatusDestroyed => 'Distrutta';

  @override
  String get territoryProjectProgress => 'Progressi';

  @override
  String get territoryProjectHp => 'Integrità';

  @override
  String territoryProjectIncomeBonusPct(int percent) {
    return '+$percent% reddito passivo';
  }

  @override
  String get territoryProjectStart => 'Start safehouse project';

  @override
  String get territoryProjectContribute => 'Progetto di fornitura';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Richiede il livello HQ $level';
  }

  @override
  String get territoryProjectHint =>
      'A safehouse network boosts passive income. Sabotage damages it in contests; supply runs repair or advance it.';

  @override
  String get territorySnackProjectStarted => 'Avviato il progetto Safehouse.';

  @override
  String get territorySnackProjectContributed => 'Progetto aggiornato.';

  @override
  String get territoryErrorProjectHq =>
      'Per avviare questo progetto è necessario un livello HQ più elevato.';

  @override
  String get territoryErrorProjectNotOwner =>
      'Solo l\'Crew di controllo può gestire questo progetto.';

  @override
  String get territoryErrorProjectExists =>
      'Questa regione ha già un progetto.';

  @override
  String get territoryErrorProjectNotFound =>
      'Nessun progetto trovato per questa regione.';

  @override
  String get territoryErrorProjectDestroyed =>
      'Progetto distrutto: avviane uno nuovo.';

  @override
  String get territoryErrorProjectActive => 'Il progetto è già attivo.';

  @override
  String get territoryErrorProjectCooldown =>
      'La fornitura del progetto è in fase di recupero.';

  @override
  String get territoryDramaTitle => 'Dramma del territorio';

  @override
  String get territoryDramaHotContests => 'Concorsi caldi';

  @override
  String get territoryDramaRecentCaptures => 'Catture recenti';

  @override
  String get territoryDramaRisingCrews => 'Equipaggi in ascesa';

  @override
  String get territoryDramaWarTheaters => 'Teatri di guerra';

  @override
  String get territoryDramaRegionEvents => 'Eventi della regione';

  @override
  String get territoryDramaEmpty =>
      'Nessun dramma sul territorio dal vivo in questo momento.';

  @override
  String get territoryDetailRegionEvent => 'Evento regionale';

  @override
  String get territoryEventPoliceOffensive => 'Offensiva della polizia';

  @override
  String get territoryEventHarborStrike => 'Sciopero del porto';

  @override
  String get territoryEventBlackoutRumor => 'Voci di blackout';

  @override
  String get launderSectionTitle => 'Money laundering';

  @override
  String launderSectionHint(int feePercent, int durationMinutes) {
    return 'Wash cash into your bank with a $feePercent% fee. Takes about $durationMinutes minutes. Higher FBI heat means higher seize risk.';
  }

  @override
  String get launderSectionCapHint =>
      'Usalo per contanti al di sopra del limite di deposito gratuito odierno.';

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
    return 'Min $min · Max $max per lavaggio.';
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
    return 'L\'importo è inferiore al minimo ($min).';
  }

  @override
  String launderErrorTooHigh(String max) {
    return 'L\'importo è superiore al massimo ($max).';
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

  @override
  String get territoryOverlayContest => 'Punteggi del concorso';

  @override
  String get territoryOverlayProject => 'Progetti';

  @override
  String get territoryOverlayEvent => 'Eventi della regione';

  @override
  String get territoryLegendPocket => 'Tasca (bordo sottile)';

  @override
  String get territoryLegendCluster => 'Cluster (bordo spesso)';

  @override
  String get territoryContestHudTitle => 'Concorso';

  @override
  String territoryContestHudScore(int attacker, int defender) {
    return 'Punteggio $attacker:$defender';
  }

  @override
  String get territoryProjectSurveillance => 'Griglia di sorveglianza';

  @override
  String get territoryProjectArmsCache => 'Deposito di armi';

  @override
  String get territoryProjectPickTitle => 'Scegli un progetto regionale';

  @override
  String get territoryProjectPickSubtitle =>
      'Un progetto per regione. Il tipo dipende dai tag strategici e dal livello HQ.';

  @override
  String get territoryProjectStartGeneric => 'Avvia progetto';

  @override
  String get territoryProjectLockedTags =>
      'Necessita di un tag strategico corrispondente';

  @override
  String territoryProjectLockedHq(int level) {
    return 'Richiede QG $level';
  }

  @override
  String get territoryProjectSafehouseDesc =>
      'Bonus sul reddito passivo su questa regione.';

  @override
  String get territoryProjectSurveillanceDesc =>
      'Punti intel_scan extra e tempo di recupero Intel più breve (porto/airhub/capitale).';

  @override
  String get territoryProjectArmsCacheDesc =>
      'Punti raid e difesa extra (industria/confine).';

  @override
  String get territoryBonusRegionProject => 'Progetto Regione';

  @override
  String get territoryErrorProjectInvalidType =>
      'Tipo di progetto sconosciuto.';

  @override
  String get territoryErrorProjectTagMismatch =>
      'Questo tipo di progetto non si adatta ai tag strategici di questa regione.';

  @override
  String get territoryStatsTitle => 'Statistiche del territorio del tuo Crew';

  @override
  String get territoryStatsAllTime => 'Di tutti i tempi';

  @override
  String get territoryStatsSeason => 'Questa stagione';

  @override
  String get territoryStatsWon => 'Vinta';

  @override
  String get territoryStatsDefended => 'Difeso';

  @override
  String get territoryStatsLost => 'Perduta';

  @override
  String get territoryStatsContests => 'Concorsi';

  @override
  String get territoryStatsHoldTotal => 'Tempo di attesa totale';

  @override
  String get territoryStatsHoldCurrent => 'Tenuta attuale';

  @override
  String get territoryStatsOwnedNow => 'Di proprietà adesso';

  @override
  String get territoryLeaderboardScopeAllTime => 'Di tutti i tempi';

  @override
  String get territoryLeaderboardScopeSeason => 'Stagione';

  @override
  String territoryLeaderboardStatsLine(
    int won,
    int defended,
    int lost,
    String hold,
  ) {
    return 'W $won · D $defended · L $lost · tieni premuto $hold';
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
  String get countryPoliceStripTitle => 'Polizia nazionale';

  @override
  String get countryPoliceBandCalm => 'Calma';

  @override
  String get countryPoliceBandWatchful => 'Vigilante';

  @override
  String get countryPoliceBandHot => 'Calda';

  @override
  String get countryPoliceBandLockdown => 'Lockdown';

  @override
  String countryPolicePressureValue(int pressure) {
    return '$pressure/100';
  }

  @override
  String countryPoliceEffectLine(int successPenalty, int arrestBonus) {
    return 'Successo crimine −$successPenalty pp · Arresto +$arrestBonus pp';
  }

  @override
  String get countryPoliceDisruptTitle => 'Disturbare la pressione poliziesca';

  @override
  String get countryPoliceDisruptHint =>
      'Ops rare che raffreddano il calore locale. Il fallimento alza Wanted e il calore FBI.';

  @override
  String get countryPoliceDisruptButton => 'Disturbare';

  @override
  String get countryPoliceDisruptCorruption => 'Corruzione';

  @override
  String get countryPoliceDisruptCorruptionDesc =>
      'Unge le ruote per calare la pressione.';

  @override
  String get countryPoliceDisruptDistract => 'Distrarre';

  @override
  String get countryPoliceDisruptDistractDesc => 'Crea un diversivo in città.';

  @override
  String get countryPoliceDisruptRaid => 'Controrapina';

  @override
  String get countryPoliceDisruptRaidDesc =>
      'Colpisci un deposito per confondere la risposta.';

  @override
  String countryPoliceDisruptCost(String cost) {
    return 'Costo €$cost';
  }

  @override
  String countryPoliceDisruptDropHint(int drop, int minutes) {
    return 'Pressione −$drop · Cool ~${minutes}m';
  }

  @override
  String countryPoliceDisruptFailHint(int wanted, int fbi) {
    return 'Fallimento: +$wanted Wanted, +$fbi FBI';
  }

  @override
  String get countryPoliceDisruptSuccess =>
      'Pressione scesa. Le strade si raffreddano un po’.';

  @override
  String get countryPoliceDisruptFailed =>
      'L’op è fallita. Il calore è salito.';

  @override
  String get countryPoliceCoolActive => 'Raffreddamento attivo';

  @override
  String get countryPoliceDisabled =>
      'La pressione della polizia nazionale è disattivata.';

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
    return 'Puntata massima: €$amount';
  }

  @override
  String get casinoFloorPublic => 'Public';

  @override
  String get casinoFloorVip => 'VIP';

  @override
  String get casinoFloorPrivate => 'Private';

  @override
  String casinoHouseRulesLine(String floor, String maxBet, String rake) {
    return '$floor · puntata max €$maxBet · rake $rake%';
  }

  @override
  String get casinoUpgradeFloor => 'Potenzia piano';

  @override
  String casinoUpgradeFloorTo(String floor, String cost) {
    return 'Passa a $floor (€$cost)';
  }

  @override
  String get casinoUpgradeSuccess => 'Piano potenziato';

  @override
  String get casinoUpgradeFailed => 'Upgrade fallito';

  @override
  String get casinoStaffTitle => 'Staff';

  @override
  String get casinoStaffHire => 'Assumi';

  @override
  String get casinoStaffFire => 'Licenzia';

  @override
  String get casinoStaffDealer => 'Dealer';

  @override
  String get casinoStaffSecurity => 'Sicurezza';

  @override
  String get casinoStaffPromoter => 'Promoter';

  @override
  String casinoStaffSalaryPerTick(String amount) {
    return 'Stipendio €$amount/tick';
  }

  @override
  String get casinoStaffHireSuccess => 'Staff assunto';

  @override
  String get casinoStaffFireSuccess => 'Staff licenziato';

  @override
  String get casinoStaffHireFailed => 'Assunzione fallita';

  @override
  String get casinoStaffFireFailed => 'Licenziamento fallito';

  @override
  String get casinoTotalRake => 'Rake totale:';

  @override
  String casinoLastRaid(String when) {
    return 'Ultimo raid: $when';
  }

  @override
  String casinoRaidDrain(String percent) {
    return 'Drain raid $percent%';
  }

  @override
  String casinoRaidDefense(String percent) {
    return 'Difesa raid $percent%';
  }

  @override
  String get casinoNoStaffHired => 'Nessuno assunto';
}
