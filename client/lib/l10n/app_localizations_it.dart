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
  String get dashboardInfoDrugsGrams => 'Farmaci (grammi)';

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
  String get liveEvents => 'Eventi dal vivo';

  @override
  String get support => 'Supporto';

  @override
  String get events => 'Eventi';

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
  String get rankGodfather => 'Padrino';

  @override
  String get dailyGoalTitle_crime_3 => 'Compi 3 crimini';

  @override
  String get dailyGoalTitle_job_2 => 'Lavorare 2 volte';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Ruba 1 veicolo';

  @override
  String get dailyGoalTitle_travel_1 => 'Completa 1 viaggio';

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
  String get dashboardEconomy24h => 'Economico 24 ore su 24';

  @override
  String get dashboardGrossIncome => 'Reddito lordo';

  @override
  String get dashboardPropertySpend => 'Spesa immobiliare';

  @override
  String get dashboardNetCashflow => 'Flusso di cassa netto';

  @override
  String get dashboardTrendVsPrevious => 'Tendenza rispetto al precedente';

  @override
  String get dashboardActivity7d => 'Attività 7d';

  @override
  String get dashboardVehicleThefts => 'Furti di veicoli';

  @override
  String get dashboardOpsOverview => 'Panoramica delle operazioni';

  @override
  String get dashboardActiveCooldowns => 'Cooldown attivi';

  @override
  String get dashboardLongestTimer => 'Il timer più lungo';

  @override
  String get dashboardActiveProduction => 'Produzione attiva';

  @override
  String get dashboardProductionReadyIn => 'Produzione pronta';

  @override
  String get dashboardNightclubEvents => 'Eventi in discoteca';

  @override
  String get dashboardNextEventStartsIn => 'Il prossimo evento inizia tra';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Veicoli attivi/quotati/in transito';

  @override
  String get dashboardLivePlayerEvents => 'Eventi dei giocatori dal vivo';

  @override
  String get dashboardOpenEvents => 'Eventi aperti';

  @override
  String get dashboardNotificationsAndRisk => 'Notifiche e rischi';

  @override
  String get dashboardUnreadDm => 'DM non letto';

  @override
  String get dashboardSupportWaitingOnYou => 'Il supporto ti aspetta';

  @override
  String get dashboardEventsLast24h => 'Gli eventi durano 24 ore';

  @override
  String get dashboardRiskScore => 'Punteggio di rischio';

  @override
  String get dashboardRecruitProstitute => 'Recluta una prostituta';

  @override
  String get dashboardCrewWars => 'Guerre tra equipaggi';

  @override
  String get dashboardStatusLabel => 'Stato';

  @override
  String get dashboardCanDeclare => 'Può dichiarare';

  @override
  String get dashboardTypeLabel => 'Tipa';

  @override
  String get dashboardOpponent => 'Avversaria';

  @override
  String get dashboardCrewPoints => 'Punti Crew';

  @override
  String get dashboardWarRank => 'Grado di guerra';

  @override
  String get dashboardSeasonRank => 'Classifica stagionale';

  @override
  String get dashboardOpenTargets => 'Obiettivi aperti';

  @override
  String get dashboardPhaseEndsIn => 'La fase termina tra';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'In prigione ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Preparazione';

  @override
  String get dashboardCrewWarStatusActive => 'Attiva';

  @override
  String get dashboardCrewWarStatusLockdown => 'Confinamento';

  @override
  String get dashboardCrewWarStatusResolved => 'Risolta';

  @override
  String get dashboardCrewWarStatusArchived => 'Archiviata';

  @override
  String get dashboardCrewWarStatusCancelled => 'Annullata';

  @override
  String get dashboardCrewWarStatusNone => 'Nessuna guerra attiva';

  @override
  String get dashboardCrewWarTypeKill => 'Uccidi la guerra';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerra economica';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerra del territorio';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerra totale';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'non configurato';

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
    return 'ogni $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Territorio dell\'Crew';

  @override
  String get dashboardRegions => 'Regioni';

  @override
  String get dashboardCountriesCaptured => 'Paesi catturati';

  @override
  String get dashboardPayout => 'Pagamento';

  @override
  String get dashboardEarningPerHour => 'Guadagna ora ogni ora';

  @override
  String get dashboardEarningPerDay => 'Guadagna ora al giorno';

  @override
  String get dashboardTotalEarned => 'Totale guadagnato';

  @override
  String get dashboardVehicleOps => 'Operazioni sui veicoli';

  @override
  String get dashboardKillProgress => 'Uccidi il progresso';

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
  String get aviationUiLicenseActiveBlurb =>
      'Licenza attiva. L\'acquisto dell\'aereo ora richiede una formazione completa del pilota (livello di aviazione 5 + tutte le certificazioni).';

  @override
  String get aviationUiLicenseMissingBlurb =>
      'Non hai ancora la licenza di volo. Acquista una licenza in questo modulo prima di acquistare l\'aereo.';

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
      'Vai al Garage o alla Marina per elencare i veicoli';

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
      'Inizio produzione: attivo per 8 ore, reclamo ogni 10 minuti';

  @override
  String get ammoFactoryTitle => 'Fabbrica di munizioni';

  @override
  String get ammoFactoryIntro =>
      'Produce in lotti; richiedi ogni 10 minuti (fino a 8 ore di arretrato per sessione).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Cosa puoi fare:';

  @override
  String get ammoFactoryActionBuy =>
      'Acquista una fabbrica nel tuo paese attuale';

  @override
  String get ammoFactoryActionProduce =>
      'Produzione di richieste (intervallo: 10 minuti, backlog massimo: 8 ore per sessione)';

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
      'Finestra di produzione: attiva (intervallo di 10 minuti)';

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
  String get educationTrackNameIt => 'ESSA';

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
      'Inserisci un ID giocatore per iniziare una rivalità.';

  @override
  String get rivalryPlayerIdHint => 'ID del giocatore';

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
  String get supportCategoryBug => 'Insetto';

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
  String get drugsInvEmptyTitle => 'Nessun farmaco nell\'inventario';

  @override
  String get drugsInvEmptySubtitle => 'Avvia la produzione per creare farmaci';

  @override
  String get drugsInvSectionHeader => 'Inventario e distribuzione';

  @override
  String get drugsInvSectionBody =>
      'Vendi farmaci in base alla qualità e sfrutta le differenze di prezzo tra i paesi.';

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
}
