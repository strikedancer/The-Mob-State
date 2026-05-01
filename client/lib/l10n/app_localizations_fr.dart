// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Jeu mafieux';

  @override
  String get login => 'Se connecter';

  @override
  String get register => 'Registre';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get usernameLabel => 'NOM D\'UTILISATEUR';

  @override
  String get passwordLabel => 'MOT DE PASSE';

  @override
  String get usernamePlaceholder => 'Nom d\'utilisateur';

  @override
  String get passwordPlaceholder => 'Mot de passe';

  @override
  String get loginButton => 'SE CONNECTER';

  @override
  String get registerButton => 'REGISTRE';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get usernameRequired => 'Veuillez entrer un nom d\'utilisateur';

  @override
  String get passwordRequired => 'Veuillez entrer un mot de passe';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get invalidCredentials =>
      'Nom d\'utilisateur ou mot de passe incorrect';

  @override
  String get loginSuccessful => 'Connexion réussie !';

  @override
  String get registrationSuccessful => 'Inscription réussie !';

  @override
  String get loginFailed => 'La connexion a échoué';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get emailRequired => 'Veuillez entrer une adresse e-mail';

  @override
  String get emailInvalid =>
      'S\'il vous plaît, mettez une adresse email valide';

  @override
  String get forgotPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotPasswordDescription =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get resetPasswordButton => 'ENVOYER LE LIEN DE RÉINITIALISATION';

  @override
  String get emailSent =>
      'Lien de réinitialisation envoyé ! Vérifiez votre courrier électronique.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String welcome(String username) {
    return 'Bienvenue, $username !';
  }

  @override
  String get dashboardTimeouts => 'Délais d\'attente';

  @override
  String get dashboardTimeoutCrime => 'Crime';

  @override
  String get dashboardTimeoutJob => 'Travail';

  @override
  String get dashboardTimeoutTravel => 'Voyage';

  @override
  String get dashboardTimeoutVehicleTheft => 'Voler une voiture';

  @override
  String get dashboardTimeoutBoatTheft => 'Voler un bateau';

  @override
  String get dashboardTimeoutNightclubSeason => 'Saison des discothèques';

  @override
  String get dashboardTimeoutAmmo => 'Acheter des balles';

  @override
  String get dashboardTimeoutShootingRange => 'Champ de tir';

  @override
  String get dashboardTimeoutGym => 'Salle de sport';

  @override
  String get dashboardInfoDrugsGrams => 'Médicaments (grammes)';

  @override
  String get dashboardInfoNightclubs => 'Boîtes de nuit';

  @override
  String get dashboardInfoNightclubRevenue => 'Revenus des discothèques';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get crimes => 'Crimes';

  @override
  String get errorLoadingCrimes => 'Échec du chargement des crimes';

  @override
  String connectionError(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Salaire : $min€ - 1$max€';
  }

  @override
  String requiresRank(String rank) {
    return 'Nécessite le rang $rank';
  }

  @override
  String get requiresVehicle => 'Nécessite un véhicule';

  @override
  String get federalCrimeWarning => '⚠️ Crime fédéral - FBI Heat';

  @override
  String get crimePickpocketName => 'Vol à la tire';

  @override
  String get crimePickpocketDesc => 'Voler les portefeuilles des passants';

  @override
  String get crimeShopliftName => 'Vol à l\'étalage';

  @override
  String get crimeShopliftDesc => 'Voler des marchandises dans un magasin';

  @override
  String get crimeStealBikeName => 'Voler un vélo';

  @override
  String get crimeStealBikeDesc => 'Voler un vélo sur un support';

  @override
  String get crimeCarTheftName => 'Vol de voiture';

  @override
  String get crimeCarTheftDesc => 'Voler une voiture garée';

  @override
  String get crimeBurglaryName => 'Cambriolage';

  @override
  String get crimeBurglaryDesc => 'Pénétrer dans une maison';

  @override
  String get crimeRobStoreName => 'Vol de magasin';

  @override
  String get crimeRobStoreDesc => 'Voler un petit magasin';

  @override
  String get crimeMugPersonName => 'Agression';

  @override
  String get crimeMugPersonDesc => 'Agresser quelqu\'un dans la rue';

  @override
  String get crimeStealCarPartsName => 'Voler des pièces de voiture';

  @override
  String get crimeStealCarPartsDesc =>
      'Voler des pièces dans des voitures garées';

  @override
  String get crimeHijackTruckName => 'Détourner un camion';

  @override
  String get crimeHijackTruckDesc =>
      'Détourner un camion transportant des marchandises';

  @override
  String get crimeAtmTheftName => 'Vol de guichet automatique';

  @override
  String get crimeAtmTheftDesc => 'Intrusion dans un guichet automatique';

  @override
  String get crimeJewelryHeistName => 'Vol de bijoux';

  @override
  String get crimeJewelryHeistDesc => 'Voler un bijoutier';

  @override
  String get crimeVandalismName => 'Vandalisme';

  @override
  String get crimeVandalismDesc => 'Dommages à la propriété pour de l\'argent';

  @override
  String get crimeGraffitiName => 'Graffiti';

  @override
  String get crimeGraffitiDesc =>
      'Pulvérisez des graffitis pour les gangs locaux';

  @override
  String get crimeDrugDealSmallName => 'Petite affaire de drogue';

  @override
  String get crimeDrugDealSmallDesc => 'Vendre une petite quantité de drogue';

  @override
  String get crimeDrugDealLargeName => 'Gros trafic de drogue';

  @override
  String get crimeDrugDealLargeDesc => 'Vendre une grande quantité de drogue';

  @override
  String get crimeExtortionName => 'Extorsion';

  @override
  String get crimeExtortionDesc =>
      'Extorquer de l’argent aux entreprises locales';

  @override
  String get crimeKidnappingName => 'Enlèvement';

  @override
  String get crimeKidnappingDesc => 'Enlever quelqu\'un contre rançon';

  @override
  String get crimeArsonName => 'Incendie criminel';

  @override
  String get crimeArsonDesc => 'Mettre le feu à un immeuble';

  @override
  String get crimeSmugglingName => 'Contrebande';

  @override
  String get crimeSmugglingDesc =>
      'Faire passer clandestinement des marchandises à la frontière';

  @override
  String get crimeAssassinationName => 'Assassinat';

  @override
  String get crimeAssassinationDesc => 'Effectuer un meurtre à forfait';

  @override
  String get crimeHackAccountName => 'Pirater un compte';

  @override
  String get crimeHackAccountDesc => 'Pirater un compte bancaire';

  @override
  String get crimeCounterfeitMoneyName => 'Argent contrefait';

  @override
  String get crimeCounterfeitMoneyDesc => 'Gagner de la fausse monnaie';

  @override
  String get crimeIdentityTheftName => 'Vol d\'identité';

  @override
  String get crimeIdentityTheftDesc =>
      'Voler l\'identité de quelqu\'un pour fraude';

  @override
  String get crimeRobArmoredTruckName => 'Vol de camion blindé';

  @override
  String get crimeRobArmoredTruckDesc => 'Voler un camion blindé';

  @override
  String get crimeArtTheftName => 'Vol d\'œuvres d\'art';

  @override
  String get crimeArtTheftDesc => 'Voler des œuvres d\'art de valeur';

  @override
  String get crimeProtectionRacketName => 'Raquette de protection';

  @override
  String get crimeProtectionRacketDesc =>
      'Faire payer aux entreprises de l’argent pour la protection';

  @override
  String get crimeCasinoHeistName => 'Vol de casino';

  @override
  String get crimeCasinoHeistDesc => 'Voler un casino';

  @override
  String get crimeBankRobberyName => 'Vol de banque';

  @override
  String get crimeBankRobberyDesc => 'Voler une banque';

  @override
  String get crimeStealYachtName => 'Voler un yacht';

  @override
  String get crimeStealYachtDesc => 'Voler un yacht de luxe';

  @override
  String get crimeCorruptOfficialName => 'Pot-de-vin officiel';

  @override
  String get crimeCorruptOfficialDesc =>
      'Soudoyer un fonctionnaire pour obtenir des faveurs';

  @override
  String get crimeEliminateWitnessName => 'Éliminer le témoin';

  @override
  String get crimeEliminateWitnessDesc => 'Éliminer un témoin avant le procès';

  @override
  String get crimeDiamondHeistName => 'Vol de transport de diamants';

  @override
  String get crimeDiamondHeistDesc =>
      'Détourner un transport de diamants bruts';

  @override
  String get crimeEvidenceRoomHeistName => 'Vol de la salle des preuves';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Voler des preuves dans un entrepôt fédéral';

  @override
  String get crimeMuseumHeistName => 'Vol de musée';

  @override
  String get crimeMuseumHeistDesc => 'Voler des objets précieux dans un musée';

  @override
  String get crimeBossAssassinationName => 'Assassinat d\'un boss rival';

  @override
  String get crimeBossAssassinationDesc =>
      'Éliminer le leader d\'une organisation rivale';

  @override
  String get crimeCriminalRecordWipeName => 'Effacer le casier judiciaire';

  @override
  String get tooltipCrimeRequiresTools => 'Outils requis';

  @override
  String get tooltipCrimeRequiresVehicle => 'Véhicule requis';

  @override
  String get tooltipCrimeRequiresDrugs => 'Médicaments requis';

  @override
  String get tooltipCrimeHighValue => 'Opération à haute valeur ajoutée';

  @override
  String get tooltipCrimeRequiresViolence => 'Violence requise';

  @override
  String get tooltipCrimeRequiresWeapon => 'Arme requise';

  @override
  String get tooltipCrimeRequirementsHeading => 'Requis:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Efface complètement votre casier judiciaire en cas de succès. Uniquement disponible si vous avez déjà des condamnations.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Il vous faut au moins ${quantity}g de : $drugs';
  }

  @override
  String get jobs => 'Emplois';

  @override
  String get errorLoadingJobs => 'Échec du chargement des tâches';

  @override
  String get jobNewspaperDeliveryName => 'Livraison de journaux';

  @override
  String get jobNewspaperDeliveryDesc => 'Livrer les journaux tôt le matin';

  @override
  String get jobCarWashName => 'Lavage de voiture';

  @override
  String get jobCarWashDesc => 'Laver les voitures au lave-auto';

  @override
  String get jobGroceryBaggerName => 'Ensacheuse d\'épicerie';

  @override
  String get jobGroceryBaggerDesc => 'Stocker les étagères au supermarché';

  @override
  String get jobDishwasherName => 'Lave-vaisselle';

  @override
  String get jobDishwasherDesc => 'Faire la vaisselle dans un restaurant';

  @override
  String get jobStreetSweeperName => 'Balayeuse de rue';

  @override
  String get jobStreetSweeperDesc => 'Nettoyer les rues';

  @override
  String get jobPizzaDeliveryName => 'Livraison de pizzas';

  @override
  String get jobPizzaDeliveryDesc => 'Livrer des pizzas en ville';

  @override
  String get jobTaxiDriverName => 'Chauffeur de taxi';

  @override
  String get jobTaxiDriverDesc => 'Conduire un taxi dans la ville';

  @override
  String get jobWarehouseWorkerName => 'Ouvrier d\'entrepôt';

  @override
  String get jobWarehouseWorkerDesc => 'Travailler dans un entrepôt';

  @override
  String get jobConstructionWorkerName => 'Ouvrier du bâtiment';

  @override
  String get jobConstructionWorkerDesc =>
      'Travailler sur un chantier de construction';

  @override
  String get jobBartenderName => 'Barman';

  @override
  String get jobBartenderDesc => 'Verser la bière et mélanger les cocktails';

  @override
  String get jobSecurityGuardName => 'Agent de sécurité';

  @override
  String get jobSecurityGuardDesc => 'Garder un bâtiment';

  @override
  String get jobTruckDriverName => 'Chauffeur de camion';

  @override
  String get jobTruckDriverDesc =>
      'Conduire un camion sur de longues distances';

  @override
  String get jobMechanicName => 'Mécanicienne';

  @override
  String get jobMechanicDesc => 'Réparer des voitures dans un garage';

  @override
  String get jobElectricianName => 'Électricienne';

  @override
  String get jobElectricianDesc =>
      'Installer et réparer des systèmes électriques';

  @override
  String get jobPlumberName => 'Plombière';

  @override
  String get jobPlumberDesc => 'Réparer les canalisations et la plomberie';

  @override
  String get jobChefName => 'Cuisinière';

  @override
  String get jobChefDesc => 'Cuisiner dans un restaurant';

  @override
  String get jobParamedicName => 'Paramédicale';

  @override
  String get jobParamedicDesc => 'Aider les personnes dans le besoin';

  @override
  String get jobProgrammerName => 'Programmeuse';

  @override
  String get jobProgrammerDesc => 'Écrire des logiciels pour les entreprises';

  @override
  String get jobAccountantName => 'Comptable';

  @override
  String get jobAccountantDesc => 'Gérer les finances des entreprises';

  @override
  String get jobLawyerName => 'Avocate';

  @override
  String get jobLawyerDesc => 'Défendre ses clients devant les tribunaux';

  @override
  String get jobRealEstateAgentName => 'Agent immobilier';

  @override
  String get jobRealEstateAgentDesc => 'Vendre des maisons et des immeubles';

  @override
  String get jobStockbrokerName => 'Agent de change';

  @override
  String get jobStockbrokerDesc => 'Négocier des actions';

  @override
  String get jobDoctorName => 'Médecin';

  @override
  String get jobDoctorDesc => 'Traiter les patients à l\'hôpital';

  @override
  String get jobAirlinePilotName => 'Pilote';

  @override
  String get jobAirlinePilotDesc => 'Piloter des avions de passagers';

  @override
  String get travel => 'Voyage';

  @override
  String get errorLoadingCountries => 'Échec du chargement des pays';

  @override
  String get currentLocation => 'Emplacement actuel';

  @override
  String get current => 'Actuelle';

  @override
  String get travelTo => 'Voyage';

  @override
  String travelCost(String amount) {
    return 'Coût : $amount€';
  }

  @override
  String get travelJourneyTitle => 'Commencer le voyage ?';

  @override
  String get travelRouteLabel => 'Itinéraire:';

  @override
  String travelLegsLabel(String count) {
    return 'Jambes : $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Coût par étape : $amount€';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Coût total : $amount€';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Temps de recharge : $minutes min par jambe';
  }

  @override
  String get travelRiskPerLeg =>
      'Risque : par jambe (peut être emprisonné et perdre toutes les marchandises)';

  @override
  String get travelStart => 'Commencer';

  @override
  String travelInTransitTo(String country) {
    return 'En transit vers $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Jambe $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Prochain arrêt : $country';
  }

  @override
  String get travelContinue => 'Continuer';

  @override
  String get travelCancelJourney => 'Annuler le voyage';

  @override
  String get travelJourneyCanceled => 'Voyage annulé';

  @override
  String get travelDirect => 'Direct';

  @override
  String travelVia(String countries) {
    return 'via $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count jambes';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Vous êtes en prison pendant $minutes minutes supplémentaires';
  }

  @override
  String travelSuccessTo(String country) {
    return 'J\'ai voyagé à $country !';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity articles $item confisqués !';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item endommagé ($percent% de perte de valeur) !';
  }

  @override
  String get countryNetherlands => 'Pays-Bas';

  @override
  String get countryBelgium => 'Belgique';

  @override
  String get countryGermany => 'Allemagne';

  @override
  String get countryFrance => 'France';

  @override
  String get countrySpain => 'Espagne';

  @override
  String get countryItaly => 'Italie';

  @override
  String get countryUk => 'Royaume-Uni';

  @override
  String get countrySwitzerland => 'Suisse';

  @override
  String get crew => 'Équipage';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Compte';

  @override
  String get messages => 'Messages';

  @override
  String get noDirectMessagesYet => 'Pas encore de messages';

  @override
  String get sendMessageToFriendsHint => 'Envoyez un message à vos amis !';

  @override
  String errorLoadingConversations(String error) {
    return 'Erreur lors du chargement des conversations : $error';
  }

  @override
  String get messageSystemBadge => 'SYSTÈME';

  @override
  String get messageSystemInboxPreview => 'Réalisations et messages système';

  @override
  String get messageSystemThreadSubtitle => 'Réalisations et messages système';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Les succès et les messages système apparaissent automatiquement ici.';

  @override
  String get messageSendFirst => 'Envoyez le premier message !';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Rang $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Messages d\'erreur lors du chargement : $error';
  }

  @override
  String get messageDeleteOwnOnly =>
      'Vous ne pouvez supprimer que vos propres messages';

  @override
  String get messageDeleteTitle => 'Supprimer le message';

  @override
  String get messageDeleteBody => 'Ce message sera définitivement supprimé.';

  @override
  String get messageSendFailed => 'Échec de l\'envoi du message';

  @override
  String get messageDeleteFailed => 'Échec de la suppression du message';

  @override
  String get investigationWindowExpired =>
      'La fenêtre d\'enquête a expiré (24 heures).';

  @override
  String get investigationStartedInboxHint =>
      'L\'enquête a commencé. Vérifiez votre boîte de réception pour le rapport de détective.';

  @override
  String get investigationAlreadyInProgress =>
      'Cette enquête est déjà en cours ou terminée.';

  @override
  String investigationStartFailed(String error) {
    return 'Échec du démarrage de l\'enquête : $error';
  }

  @override
  String get investigationExpired => 'Enquête expirée';

  @override
  String get investigationStarted => 'L\'enquête a commencé';

  @override
  String get investigationStarting => 'Départ...';

  @override
  String get startMurderInvestigation => 'Démarrer une enquête pour meurtre';

  @override
  String get systemMessagesReadOnlyHint =>
      'Il est impossible de répondre aux messages système';

  @override
  String get helpAndGuide => 'Aide et guide';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get liveEvents => 'Événements en direct';

  @override
  String get support => 'Soutien';

  @override
  String get events => 'Événements';

  @override
  String get aviation => 'Aviation';

  @override
  String get premiumAndCredits => 'Primes et crédits';

  @override
  String get bank => 'Banque';

  @override
  String get tradeGoods => 'Marchandises commerciales';

  @override
  String get drugs => 'Drogues';

  @override
  String get nightclub => 'Discothèque';

  @override
  String get crypto => 'Cryptomonnaie';

  @override
  String get smuggling => 'Contrebande';

  @override
  String get tools => 'outils';

  @override
  String get vehicleHeist => 'Vol de véhicule';

  @override
  String get vehicleHeistTitle => 'Vol de véhicule';

  @override
  String get vehicleHeistTabSubtitleCar =>
      'Volez des voitures pour obtenir de l\'argent et des pièces détachées.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Voler des motos pour obtenir de l\'argent et des pièces.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Volez des bateaux pour de l\'argent et des pièces détachées.';

  @override
  String get vehicleHeistReady => 'Prêt';

  @override
  String get vehicleHeistMotorStorage => 'Entreposage moto';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'La capacité des voitures est partagée entre tous les braquages ​​de voitures.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'La capacité des motos est partagée entre tous les braquages ​​de motos.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'La capacité des bateaux est partagée entre tous les braquages ​​de bateaux.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Rang requis : $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Stockage : $stored/$total (voie niveau $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Voler une voiture';

  @override
  String get vehicleHeistStealMotorcycle => 'Voler une moto';

  @override
  String get vehicleHeistStealBoat => 'Voler un bateau';

  @override
  String get vehicleHeistGenericVehicle => 'véhicule';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Succès : $vehicle volé.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Temps de recharge actif : $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Vous avez été arrêté ($minutes min de prison).';
  }

  @override
  String get vehicleHeistUntil => 'jusqu\'à';

  @override
  String get vehicleHeistRegionalLockActive => 'Verrouillage régional actif.';

  @override
  String get vehicleHeistStealFailed => 'L\'action de vol a échoué.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Mise à niveau terminée.';

  @override
  String get vehicleHeistUpgradeFailed => 'La mise à niveau a échoué.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Voitures disponibles';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Motos disponibles';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Bateaux disponibles';

  @override
  String get vehicleHeistCatalogEmpty => 'Aucun véhicule dans ce catalogue.';

  @override
  String get vehicleHeistRarityCommon => 'Commune';

  @override
  String get vehicleHeistRarityUncommon => 'Rare';

  @override
  String get vehicleHeistRarityRare => 'Rare';

  @override
  String get vehicleHeistRarityEpic => 'Épique';

  @override
  String get vehicleHeistRarityLegendary => 'Légendaire';

  @override
  String get vehicleHeistEventOnlyTag => 'Événement uniquement';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Valeur : $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Rang : $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Disponibilité en jeu : $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Le plus courant dans : $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Pays : $countries';
  }

  @override
  String vehicleHeistUpgradeCost(String cost) {
    return 'Mise à niveau ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Mise à niveau verrouillée : rang $rank requis';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Mise à niveau verrouillée';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Accélérez pour $credits crédits';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Accélérer (écran suivant)';

  @override
  String get vehicleHeistExpand => 'Développer';

  @override
  String get vehicleHeistCollapse => 'Effondrement';

  @override
  String get vehicleHeistActive => 'ACTIVE';

  @override
  String get vehicleHeistOff => 'désactivé';

  @override
  String get catalog => 'Catalogue';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Exécuter un point d\'accès';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Exécution de points d\'accès';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Exécution du point d\'accès terminée : +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Temps de recharge du point d\'accès actif ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'Le point d\'accès a échoué. La chaleur augmenta.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Opération d\'équipage';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Opération d\'équipage';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Opération d\'équipage terminée : vous avez gagné $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Equipage requis.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Temps de recharge des opérations d\'équipage actif ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'L\'opération d\'équipage a échoué.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Rejoignez un équipage pour débloquer des actions d\'équipage';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Equipage requis : oui';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Équipage requis : non (rejoignez d\'abord un équipage)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Acheter des pièces';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Acheter des pièces';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Acheter quelles pièces ? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Pièces achetées : -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'L\'achat de pièces a échoué.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Contrat de réclamation';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Contrat de réclamation';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contrat terminé : +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Aucun véhicule admissible en inventaire pour ce contrat.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Temps de recharge du contrat actif ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'La réclamation contractuelle a échoué.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Assurance';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Assurance contrebande';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Choisissez un niveau de couverture pour cette catégorie de véhicule.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Basique';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pro';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Assurance active ($tier) pour $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'L’achat d’assurance a échoué.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Match d\'équipage';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Match d\'équipage gagné : +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Match d\'équipage perdu : +$reward consolation';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed =>
      'Le matchmaking des équipages a échoué.';

  @override
  String get vehicleHeistOpsCounterButton => 'Comptoir';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Succès de la contre-interception : +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Contre-interception indisponible ou échouée.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Contrat d\'opérations';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Contrat d\'opérations';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Contrat d\'exploitation terminé : +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Le contrat d\'opérations a échoué ou est en période de recharge.';

  @override
  String get vehicleHeistOpsClaimDisputeButton =>
      'Litige concernant une réclamation';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'Aucune réclamation d’assurance ouverte.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'Aucune réclamation valide trouvée.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Réclamation approuvée : +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Réclamation rejetée : -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'La résolution de la réclamation a échoué.';

  @override
  String get vehicleHeistOpsIntelTitle =>
      'Intelligence opérationnelle des véhicules';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip =>
      'Actualiser les renseignements';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Appuyez pour développer et afficher toutes les actions.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Chaleur $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Police : $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Niveau de représentant $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Marché des pièces détachées : $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Point d\'accès : $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Récompense : $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Pourquoi obtenez-vous de l\'argent : les actions opérationnelles réussies sont versées directement sur l\'argent du portefeuille.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Espèces : $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Vous : $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Espèces : $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contrats : $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| à partir de $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Prix ​​des pièces (auto/moto/bateau) : $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Actualisation du marché des pièces détachées : $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Équipage : $name ($size membres)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Récompense du contrat Chop : $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Fenêtre d\'interception : $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Liste noire : $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Liste noire : aucune';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Assurance : $tier active';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine =>
      'Assurance : inactive';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Modificateur de pays : $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Saison de l\'équipage : $season | points $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contrats : $count | temps de recharge $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Temps de recharge du compteur : $cooldown | réclamations ouvertes : $claims';
  }

  @override
  String get tuneShop => 'Boutique de mélodies';

  @override
  String get tuneShopIntro =>
      'Mettez au rebut les véhicules pour les pièces et améliorez la vitesse, la furtivité et l\'armure. Les pièces sont partagées par catégorie (voiture/moto/bateau), vous pouvez donc régler n\'importe quel véhicule de la même catégorie.';

  @override
  String get tuneShopCarPartsLabel => 'Pièces de voiture';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Pièces de moto';

  @override
  String get tuneShopBoatPartsLabel => 'Pièces de bateau';

  @override
  String get tuneShopEmptyTitle => 'Aucun véhicule disponible pour le réglage';

  @override
  String get tuneShopEmptyBody =>
      'Volez d’abord quelques véhicules et jetez-en quelques-uns pour les pièces.';

  @override
  String get tuneShopVehicleTypeCar => 'Voiture';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Moto';

  @override
  String get tuneShopVehicleTypeBoat => 'Bateau';

  @override
  String get tuneShopStatSpeed => 'Vitesse';

  @override
  String get tuneShopStatStealth => 'Furtivité';

  @override
  String get tuneShopStatArmor => 'Armure';

  @override
  String get tuneShopValueMultiplierPrefix => 'Valeur x';

  @override
  String get tuneShopUpgradeButton => 'Mise à niveau';

  @override
  String get tuneShopMaxLabel => 'MAXIMUM';

  @override
  String get tuneShopPartsAbbrev => 'points';

  @override
  String get tuneShopUpgradeCompleted => 'Mise à niveau terminée';

  @override
  String get tuneShopUpgradeFailed => 'La mise à niveau a échoué';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning verrouillé : le véhicule est en transit.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning verrouillé : le véhicule est en réparation.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Temps de recharge de réglage actif : $duration restant.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Véhicule introuvable';

  @override
  String get tuneShopErrorNotOwner =>
      'Vous n\'êtes pas propriétaire de ce véhicule';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning verrouillé : le véhicule est en transit.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning verrouillé : le véhicule est en réparation.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Pas assez d\'argent';

  @override
  String get tuneShopErrorInsufficientParts => 'Pas assez de pièces';

  @override
  String get tuneShopErrorStatMaxed => 'Ce niveau de réglage est maximum';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Temps de recharge de réglage actif : $duration restant.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Limite atteinte : maximum $max réglage simultané, actuellement $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Statistique de réglage invalide';

  @override
  String get territory => 'Territoire';

  @override
  String get achievements => 'Réalisations';

  @override
  String get menuCrackVault => 'Cassez le coffre-fort';

  @override
  String get vaultHeroTagline => 'Devinez le code et gagnez de gros prix.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Saison : $range';
  }

  @override
  String get vaultYourCredits => 'Vos crédits';

  @override
  String get vaultChooseStake => 'Choisissez votre mise';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake crédits',
      one: '$stake crédit',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Prix ​​attendu : +$reward crédits';
  }

  @override
  String get vaultCodeLabel => 'Code';

  @override
  String get vaultSubmitStake => 'Soumettre la mise';

  @override
  String get vaultWrongCodesTitle => 'Mauvais codes (ce mois-ci)';

  @override
  String get vaultShowWrongCodes => 'Montrer';

  @override
  String get vaultHideWrongCodes => 'Cacher';

  @override
  String get vaultNoWrongCodesYet =>
      'Aucun code erroné n\'a encore été enregistré.';

  @override
  String get couldNotLoadVaultStatus => 'Impossible de charger le statut.';

  @override
  String get vaultEnterFourDigitCode => 'Entrez un code à 4 chiffres.';

  @override
  String get vaultAttemptSuccessGeneric => 'Succès.';

  @override
  String get vaultAttemptFailedGeneric => 'Échoué.';

  @override
  String get vaultAttemptFailedRetry => 'Échoué. Veuillez réessayer.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count nouveaux messages';
  }

  @override
  String get rankProgress => 'Progression du classement';

  @override
  String get cash => 'Espèces';

  @override
  String get sessionRecap => 'Récapitulatif de la séance';

  @override
  String get nameLabel => 'Nom';

  @override
  String get countryLabel => 'Pays';

  @override
  String get wantedLevel => 'Niveau recherché';

  @override
  String get fbiHeat => 'Chaleur du FBI';

  @override
  String get properties => 'Propriétés';

  @override
  String get vehicles => 'Véhicules';

  @override
  String get netWorth => 'Valeur nette';

  @override
  String get securityLabel => 'Sécurité';

  @override
  String get noSecurity => 'Aucune sécurité';

  @override
  String get weaponLabel => 'Arme';

  @override
  String get vehicleLabel => 'Véhicule';

  @override
  String get none => 'Aucune';

  @override
  String get statistics => 'Statistiques';

  @override
  String get breakouts => 'Éruptions cutanées';

  @override
  String get murders => 'Meurtres';

  @override
  String get hitlistContracts => 'Contrats de liste de résultats';

  @override
  String get carsStolen => 'Voitures volées';

  @override
  String get boatsStolen => 'Bateaux volés';

  @override
  String get crimeAttempts => 'Tentatives de crime';

  @override
  String get successful => 'Réussie';

  @override
  String get jobAttempts => 'Tentatives de travail';

  @override
  String get streetProstitutes => 'Prostituées de rue';

  @override
  String get rldProstitutes => 'Prostituées RLD';

  @override
  String get travels => 'Voyages';

  @override
  String get bullets => 'Balles';

  @override
  String get moneyStatusLabel => 'Statut de l\'argent';

  @override
  String get moneyStatusPoor => 'Pauvre';

  @override
  String get moneyStatusRising => 'Soulèvement';

  @override
  String get moneyStatusRich => 'Riche';

  @override
  String get moneyStatusMultimillionaire => 'Multimillionnaire';

  @override
  String get rankBeginner => 'Débutante';

  @override
  String get rankCriminal => 'Criminelle';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Mafieux';

  @override
  String get rankGodfather => 'Parrain';

  @override
  String get dailyGoalTitle_crime_3 => 'Faites 3 crimes';

  @override
  String get dailyGoalTitle_job_2 => 'Travailler 2 fois';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Voler 1 véhicule';

  @override
  String get dailyGoalTitle_travel_1 => 'Terminer 1 voyage';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Hebdomadaire : 20 crimes';

  @override
  String get dailyGoalTitle_weekly_job_10 =>
      'Hebdomadaire : travailler 10 fois';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Hebdomadaire : volez 5 véhicules';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Hebdomadaire : 3 déplacements';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Récompense : +$cash et +$xp XP';
  }

  @override
  String get justNow => 'Tout à l\' heure';

  @override
  String secondsAgo(String seconds) {
    return 'Il y a $seconds';
  }

  @override
  String minutesAgo(String count) {
    return 'il y a $count minutes';
  }

  @override
  String hoursAgo(String count) {
    return 'Il y a $count heures';
  }

  @override
  String get last10EventsLive => '10 derniers événements (en direct).';

  @override
  String get noEventsYetSession =>
      'Aucun événement pour l\'instant dans cette session.';

  @override
  String get clearRecap => 'Récapitulatif clair';

  @override
  String get weeklyGoalClaimed => 'Objectif hebdomadaire revendiqué !';

  @override
  String get dailyGoalClaimed => 'Objectif quotidien revendiqué !';

  @override
  String get failed => 'Échoué.';

  @override
  String get failedPleaseTryAgain => 'Échoué. Veuillez réessayer.';

  @override
  String get dailyGoals => 'Objectifs quotidiens';

  @override
  String get weeklyGoals => 'Objectifs hebdomadaires';

  @override
  String get claimed => 'Réclamé';

  @override
  String get ready => 'Prêt';

  @override
  String get claim => 'Réclamer';

  @override
  String readyToClaim(String count) {
    return '$count prêt à réclamer';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total terminé';
  }

  @override
  String get noPlayerData => 'Aucune donnée du joueur';

  @override
  String get economy24h => 'Économie 24h';

  @override
  String get grossIncome => 'Revenu brut';

  @override
  String get propertySpend => 'Dépenses immobilières';

  @override
  String get netCashflow => 'Flux de trésorerie net';

  @override
  String get trendVsPrevious => 'Tendance par rapport au précédent';

  @override
  String get activity7d => 'Activité 7j';

  @override
  String get vehicleThefts => 'Vols de véhicules';

  @override
  String get opsOverview => 'Présentation des opérations';

  @override
  String get activeCooldowns => 'Temps de recharge actifs';

  @override
  String get longestTimer => 'Minuterie la plus longue';

  @override
  String get activeProduction => 'Production active';

  @override
  String get productionReadyIn => 'Production prête à';

  @override
  String get nightclubEvents => 'Événements en Nightclub';

  @override
  String get nextEventStartsIn => 'Le prochain événement commence dans';

  @override
  String get vehiclesActiveListedTransit =>
      'Véhicules actifs/répertoriés/en transit';

  @override
  String get livePlayerEvents => 'Événements de joueurs en direct';

  @override
  String get openEvents => 'Événements ouverts';

  @override
  String get notificationsAndRisk => 'Notifications et risques';

  @override
  String get unreadDm => 'DM non lu';

  @override
  String get supportWaitingOnYou => 'Un soutien qui vous attend';

  @override
  String get eventsLast24h => 'Événements dernières 24h';

  @override
  String get riskScore => 'Score de risque';

  @override
  String get recruitProstitute => 'Recruter une prostituée';

  @override
  String get free => 'GRATUITE';

  @override
  String get crewWars => 'Guerres d\'équipage';

  @override
  String get status => 'Statut';

  @override
  String get canDeclare => 'Peut déclarer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get type => 'Taper';

  @override
  String get opponent => 'Adversaire';

  @override
  String get crewPoints => 'Points d\'équipage';

  @override
  String get warRank => 'Rang de guerre';

  @override
  String get seasonRank => 'Classement de la saison';

  @override
  String get openTargets => 'Cibles ouvertes';

  @override
  String get phaseEndsIn => 'La phase se termine dans';

  @override
  String get crewTerritory => 'Territoire de l\'équipage';

  @override
  String get regions => 'Régions';

  @override
  String get countriesCaptured => 'Pays capturés';

  @override
  String get payout => 'Paiement';

  @override
  String get earningPerHour => 'Gagner maintenant par heure';

  @override
  String get earningPerDay => 'Gagner maintenant par jour';

  @override
  String get totalEarned => 'Total gagné';

  @override
  String get crewBank => 'Banque d\'équipage';

  @override
  String get dashboardEconomy24h => 'Économie 24h';

  @override
  String get dashboardGrossIncome => 'Revenu brut';

  @override
  String get dashboardPropertySpend => 'Dépenses immobilières';

  @override
  String get dashboardNetCashflow => 'Flux de trésorerie net';

  @override
  String get dashboardTrendVsPrevious => 'Tendance par rapport au précédent';

  @override
  String get dashboardActivity7d => 'Activité 7j';

  @override
  String get dashboardVehicleThefts => 'Vols de véhicules';

  @override
  String get dashboardOpsOverview => 'Présentation des opérations';

  @override
  String get dashboardActiveCooldowns => 'Temps de recharge actifs';

  @override
  String get dashboardLongestTimer => 'Minuterie la plus longue';

  @override
  String get dashboardActiveProduction => 'Production active';

  @override
  String get dashboardProductionReadyIn => 'Production prête à';

  @override
  String get dashboardNightclubEvents => 'Événements en Nightclub';

  @override
  String get dashboardNextEventStartsIn =>
      'Le prochain événement commence dans';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Véhicules actifs/répertoriés/en transit';

  @override
  String get dashboardLivePlayerEvents => 'Événements de joueurs en direct';

  @override
  String get dashboardOpenEvents => 'Événements ouverts';

  @override
  String get dashboardNotificationsAndRisk => 'Notifications et risques';

  @override
  String get dashboardUnreadDm => 'DM non lu';

  @override
  String get dashboardSupportWaitingOnYou => 'Un soutien qui vous attend';

  @override
  String get dashboardEventsLast24h => 'Événements dernières 24h';

  @override
  String get dashboardRiskScore => 'Score de risque';

  @override
  String get dashboardRecruitProstitute => 'Recruter une prostituée';

  @override
  String get dashboardCrewWars => 'Guerres d\'équipage';

  @override
  String get dashboardStatusLabel => 'Statut';

  @override
  String get dashboardCanDeclare => 'Peut déclarer';

  @override
  String get dashboardTypeLabel => 'Taper';

  @override
  String get dashboardOpponent => 'Adversaire';

  @override
  String get dashboardCrewPoints => 'Points d\'équipage';

  @override
  String get dashboardWarRank => 'Rang de guerre';

  @override
  String get dashboardSeasonRank => 'Classement de la saison';

  @override
  String get dashboardOpenTargets => 'Cibles ouvertes';

  @override
  String get dashboardPhaseEndsIn => 'La phase se termine dans';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'En prison ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Préparation';

  @override
  String get dashboardCrewWarStatusActive => 'Active';

  @override
  String get dashboardCrewWarStatusLockdown => 'Confinement';

  @override
  String get dashboardCrewWarStatusResolved => 'Résolue';

  @override
  String get dashboardCrewWarStatusArchived => 'Archivé';

  @override
  String get dashboardCrewWarStatusCancelled => 'Annulé';

  @override
  String get dashboardCrewWarStatusNone => 'Pas de guerre active';

  @override
  String get dashboardCrewWarTypeKill => 'Tuer la guerre';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerre économique';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerre de territoire';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerre totale';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'non configuré';

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
    return 'toutes les $minutes minutes';
  }

  @override
  String get dashboardCrewTerritory => 'Territoire de l\'équipage';

  @override
  String get dashboardRegions => 'Régions';

  @override
  String get dashboardCountriesCaptured => 'Pays capturés';

  @override
  String get dashboardPayout => 'Paiement';

  @override
  String get dashboardEarningPerHour => 'Gagner maintenant par heure';

  @override
  String get dashboardEarningPerDay => 'Gagner maintenant par jour';

  @override
  String get dashboardTotalEarned => 'Total gagné';

  @override
  String get dashboardVehicleOps => 'Opérations de véhicules';

  @override
  String get dashboardKillProgress => 'Tuer le progrès';

  @override
  String get vehicleOpsHeat => 'Chaleur';

  @override
  String get vehicleOpsHeatLevelLow => 'Faible';

  @override
  String get vehicleOpsHeatLevelMedium => 'Moyen';

  @override
  String get vehicleOpsHeatLevelHigh => 'Élevé';

  @override
  String get vehicleOpsReputation => 'Représentante';

  @override
  String get vehicleOpsPartsTrendUp =>
      'le marché des pièces détachées est en hausse';

  @override
  String get vehicleOpsPartsTrendDown =>
      'le marché des pièces détachées en baisse';

  @override
  String get vehicleOpsPartsTrendStable => 'marché des pièces détachées stable';

  @override
  String get vehicleOpsBlacklistActive => 'Liste noire active';

  @override
  String get vehicleOpsNoBlacklist => 'Pas de liste noire';

  @override
  String get prisonTitle => 'Prison';

  @override
  String get prisonLoadFailed => 'Échec du chargement des prisonniers';

  @override
  String get prisonNoPrisonersFound => 'Aucun prisonnier trouvé';

  @override
  String prisonRankLine(String rank) {
    return 'Rang : $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Rang : $rank · Vous';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Temps restant : $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Caution : $amount€';
  }

  @override
  String get prisonPayBailButton => 'Payer une caution';

  @override
  String get prisonBuyOutButton => 'Rachat';

  @override
  String get prisonAttemptEscapeButton => 'Tentative d\'évasion';

  @override
  String get prisonJailbreakButton => 'Jailbreak';

  @override
  String get prisonActionFailed => '❌ L\'action a échoué';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Acheté $username pour $amount€';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Vous avez payé une caution de $amount€ et êtes libre';
  }

  @override
  String get prisonEscapeSuccess => '✅Évasion réussie ! Vous êtes libre.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ L\'évasion a échoué. Phrase prolongée de $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Cooldown actif : attendez $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ L\'évasion a échoué';

  @override
  String get prisonErrorInsufficientFunds => '❌ Pas assez d\'argent';

  @override
  String get prisonErrorTargetNotJailed => '❌ La cible n\'est plus en prison';

  @override
  String get prisonErrorCannotBuyoutSelf =>
      '❌ Vous ne pouvez pas vous racheter';

  @override
  String get prisonErrorPlayerNotFound => '❌ Joueur introuvable';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak réussi ! Le prisonnier est libre.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Le jailbreak a échoué, vous vous êtes fait prendre ($minutes min de prison).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Le jailbreak a échoué. Le prisonnier est toujours enfermé.';

  @override
  String get prisonErrorRescuerJailed => '❌ Vous êtes vous-même en prison';

  @override
  String get prisonJailbreakGenericFailure => '❌ Le jailbreak a échoué';

  @override
  String get crewJailbreakTitle => '🚔 Équipage emprisonné';

  @override
  String get crewJailbreakLoadFailed =>
      'Échec du chargement des membres emprisonnés';

  @override
  String get crewJailbreakEmptyTitle => '🎉 Personne en prison !';

  @override
  String get crewJailbreakEmptyBody =>
      'Tous les membres d\'équipage sont libres';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Tentative de jailbreak pour $username :';
  }

  @override
  String get crewJailbreakRiskSuccess => 'En cas de réussite : Joueur libéré !';

  @override
  String get crewJailbreakRiskFailChance =>
      'En cas d\'échec : 60 % de chances de réussite';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Attrapé : 30-60 min de prison + recherché +10';

  @override
  String get crewJailbreakTip =>
      'Les chances de réussite augmentent avec le rang et le bonus d\'équipage !';

  @override
  String get crewJailbreakAttemptButton => 'Tentative de jailbreak';

  @override
  String get crewJailbreakActionFailed => '❌ L\'action a échoué';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minutes de prison';
  }

  @override
  String get crewJailbreakRescueButton => 'Sauvetage';

  @override
  String get crewRoleLeader => 'Chef';

  @override
  String get crewRoleCoLeader => 'Co-leader';

  @override
  String get crewRoleMember => 'Membre';

  @override
  String get vehicleOpsHotspot => 'Point chaud';

  @override
  String get vehicleOpsCrew => 'Équipage';

  @override
  String get vehicleOpsCrewMatch => 'Match d\'équipage';

  @override
  String get vehicleOpsChop => 'Hacher';

  @override
  String get vehicleOpsContract => 'Contracter';

  @override
  String get vehicleOpsCounter => 'Comptoir';

  @override
  String get vehicleOpsContracts => 'Contrats';

  @override
  String get vehicleOpsClaims => 'Réclamations';

  @override
  String get vehicleOpsSeason => 'Saison';

  @override
  String get dashboardCar => 'Voiture';

  @override
  String get dashboardMotorcycle => 'Moto';

  @override
  String get dashboardBoat => 'Bateau';

  @override
  String get dashboardCrewAccess => 'Accès de l\'équipage';

  @override
  String get dashboardCrewRole => 'Rôle de l\'équipage';

  @override
  String get dashboardUnavailable => 'indisponible';

  @override
  String get vehicleOps => 'Opérations de véhicules';

  @override
  String get car => 'Voiture';

  @override
  String get motorcycle => 'Moto';

  @override
  String get boat => 'Bateau';

  @override
  String get crewAccess => 'Accès de l\'équipage';

  @override
  String get crewRole => 'Rôle de l\'équipage';

  @override
  String get unavailable => 'indisponible';

  @override
  String get quickActionsCrimesSubtitle => 'Commettre des actes criminels';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Voiture, moto et bateau';

  @override
  String get quickActionsTuneShopSubtitle => 'Pièces et mises à niveau';

  @override
  String get quickActionsEventsSubtitle => 'Événements actifs et à venir';

  @override
  String get quickActionsJobsSubtitle => 'Gagnez de l\'argent légal';

  @override
  String get quickActionsCasinoSubtitle => 'Jouez votre argent';

  @override
  String get quickActionsBankSubtitle => 'Gérez votre solde global';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Santé';

  @override
  String get rank => 'Rang';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Paramètres';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => 'Avatar mis à jour !';

  @override
  String get avatarChangeFailed => 'Échec du changement d\'avatar';

  @override
  String error(String error) {
    return 'Erreur : $error';
  }

  @override
  String get changeLanguage => 'Langue / Taal';

  @override
  String get languageChanged => 'Langue changée en anglais';

  @override
  String languageChangeFailed(String code) {
    return 'Échec du changement de langue ($code)';
  }

  @override
  String get chooseLanguage => 'Choisir la langue / Taal Kiezen';

  @override
  String get dutch => 'Pays-Bas';

  @override
  String get english => 'Anglaise';

  @override
  String get cancel => 'Annuler';

  @override
  String get changeUsername => 'Changer le nom d\'utilisateur';

  @override
  String get usernameHint => '3-20 caractères';

  @override
  String get change => 'Changement';

  @override
  String get minChars => 'Minimum 3 caractères';

  @override
  String get usernameUpdated => 'Nom d\'utilisateur mis à jour !';

  @override
  String get usernameTaken => 'Nom d\'utilisateur déjà pris';

  @override
  String get usernameChangeFailed =>
      'Échec du changement de nom d\'utilisateur';

  @override
  String get oncePerMonth => 'Changer une fois par mois';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get allowMessages => 'Autoriser les messages';

  @override
  String get allowMessagesDesc =>
      'Les autres joueurs peuvent vous envoyer des messages';

  @override
  String get settingsSystemNotificationsTitle =>
      'Notifications système pour l\'application';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Autorisation : autorisée, appareil lié';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Autorisation : autorisée, l\'appareil est en train de se reconnecter';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Autorisation : provisoire, liée à l\'appareil';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Autorisation : provisoire, l\'appareil est en cours de reconnexion';

  @override
  String get settingsPushPermissionDenied => 'Autorisation : refusée';

  @override
  String get settingsPushPermissionNotRequested =>
      'Autorisation : pas encore demandée';

  @override
  String get settingsPushPermissionUnknown => 'Autorisation : inconnue';

  @override
  String get settingsDeviceTokenRegistered =>
      'Jeton d\'appareil enregistré sur le serveur';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Aucun jeton d\'appareil enregistré pour le moment';

  @override
  String get settingsPushHelpText =>
      'Utilisez ce bouton pour demander à nouveau l\'autorisation du navigateur/iPhone et enregistrer votre jeton push.';

  @override
  String get working => 'Fonctionnement...';

  @override
  String get settingsEnablePush => 'Activer le push';

  @override
  String get settingsPushEnabledToast =>
      'Notifications push activées. De nouvelles notifications seront désormais reçues.';

  @override
  String get settingsPushDisabledInSystem =>
      'Le push est désactivé dans les paramètres de votre navigateur/iPhone. Activez les notifications pour cette application.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Échec de l\'activation des notifications push : $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Événements de joueurs';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push : événements de joueurs en direct';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Début et fin des événements de compétition récurrents (par exemple, les tours avec les meilleurs scores).';

  @override
  String get settingsCryptoNotificationsTitle =>
      'Notifications cryptographiques';

  @override
  String get settingsCryptoPushTradesTitle => 'Push : échanges';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Notification push pour les transactions d\'achat/vente';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push : alertes de prix';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Notification push pour les mouvements de prix pertinents';

  @override
  String get settingsCryptoPushOrdersTitle => 'Push : commandes';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Notification push lorsque la commande est déclenchée ou exécutée';

  @override
  String get settingsCryptoPushMissionsTitle => 'Pousser : Missions';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Notification push lorsqu\'une mission crypto est terminée';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Push : classement';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Notification push pour les récompenses du classement crypto';

  @override
  String get settingsCryptoInAppTradesTitle => 'Dans l\'application : échanges';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Afficher les événements commerciaux dans votre flux d\'événements';

  @override
  String get settingsCryptoInAppPriceAlertsTitle =>
      'Dans l\'application : alertes de prix';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Afficher les événements d\'alerte de prix dans votre flux d\'événements';

  @override
  String get settingsCryptoInAppOrdersTitle =>
      'Dans l\'application : commandes';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Afficher les événements de commande dans votre flux d\'événements';

  @override
  String get settingsCryptoInAppMissionsTitle =>
      'Dans l\'application : Missions';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Afficher les missions terminées dans votre flux d\'événements';

  @override
  String get settingsCryptoInAppLeaderboardTitle =>
      'Dans l\'application : classement';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Afficher les récompenses du classement dans votre flux d\'événements';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Vous ne pouvez changer votre avatar qu\'une fois par semaine';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Vous ne pouvez changer votre nom d\'utilisateur qu\'une fois par mois';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get vipStatus => 'Statut VIP';

  @override
  String activeUntil(String date) {
    return 'Actif jusqu\'à $date';
  }

  @override
  String get unknown => 'Inconnue';

  @override
  String get chooseAvatar => 'Choisissez un avatar';

  @override
  String get freeAvatars => 'Avatars gratuits';

  @override
  String get vipAvatars => 'Avatars VIP';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get foodAndDrink => 'Nourriture et boissons';

  @override
  String get invalidItem => 'Cet article n\'existe pas';

  @override
  String get foodBroodje => 'Sandwich';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Hamburger';

  @override
  String get foodSteak => 'Steak';

  @override
  String get drinkWater => 'Eau';

  @override
  String get drinkSoda => 'Soude';

  @override
  String get drinkCoffee => 'Café';

  @override
  String get drinkBeer => 'Bière';

  @override
  String get foodInfo3 =>
      '• Achetez de la nourriture et des boissons pour maintenir vos statistiques à jour';

  @override
  String get friends => 'Amies';

  @override
  String get friendActivity => 'Activité d\'un ami';

  @override
  String get friendsUiTabActivity => 'Activité';

  @override
  String get friendsUiTabRequests => 'Demandes';

  @override
  String get friendsUiTabSearch => 'Recherche';

  @override
  String get friendsUiEmptyListTitle => 'Pas encore d\'amis';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Recherchez des joueurs et ajoutez-les comme amis !';

  @override
  String get friendsUiNoRequests => 'Aucune demande';

  @override
  String friendsUiLineRank(String rank) {
    return 'Rang : $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Localisation : $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Santé : $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Amis depuis : $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Supprimer un ami';

  @override
  String get friendsUiRemoveDialogBody =>
      'Etes-vous sûr de vouloir supprimer cet ami ?';

  @override
  String get friendsUiRemoveConfirm => 'Retirer';

  @override
  String get friendsUiBlockDialogTitle => 'Bloquer le joueur';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Êtes-vous sûr de vouloir bloquer $username ? Vous ne pourrez ni envoyer ni recevoir de messages.';
  }

  @override
  String get friendsUiBlockButton => 'Bloc';

  @override
  String get friendsUiSnackRequestSent => 'Demande d\'ami envoyée';

  @override
  String get friendsUiSnackRequestAccepted => 'Demande d\'ami acceptée';

  @override
  String get friendsUiSnackRequestRejected => 'Demande d\'ami rejetée';

  @override
  String get friendsUiSnackFriendRemoved => 'Ami supprimé';

  @override
  String get friendsUiSnackPlayerBlocked => 'Joueur bloqué';

  @override
  String friendsUiSnackError(String details) {
    return 'Erreur : $details';
  }

  @override
  String get friendsUiSearchLabel => 'Rechercher un joueur';

  @override
  String get friendsUiSearchHint => 'Tapez au moins 2 caractères';

  @override
  String get friendsUiSearchMinChars =>
      'Tapez au moins 2 caractères pour rechercher';

  @override
  String get friendsUiNoPlayersFound => 'Aucun joueur trouvé';

  @override
  String get friendsUiMenuBlock => 'Bloc';

  @override
  String get friendsUiMenuRemove => 'Retirer';

  @override
  String get friendsUiChipFriend => 'Amie';

  @override
  String get friendsUiChipPending => 'En attente';

  @override
  String get friendsUiAccept => 'Accepter';

  @override
  String get friendsUiReject => 'Rejeter';

  @override
  String get friendsUiActivityEmpty => 'Aucune activité d\'ami pour l\'instant';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Niveau $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Équipage : $name';
  }

  @override
  String get crewUiAppCrews => 'Équipages';

  @override
  String get crewUiTabMyCrew => 'Aperçu';

  @override
  String get crewUiTabCrewHq => 'QG et mises à niveau';

  @override
  String get crewUiTabStorageHub => 'Stockage';

  @override
  String get crewUiTabMembers => 'Membres';

  @override
  String get crewUiTabWarRoom => 'Salle de guerre';

  @override
  String get crewUiTabCrewMissions => 'Missions d\'équipage';

  @override
  String get crewUiTabCarStorage => 'Entreposage de voiture/moto';

  @override
  String get crewUiTabBoatStorage => 'Stockage de bateau';

  @override
  String get crewUiTabWeaponStorage => 'Stockage d\'armes';

  @override
  String get crewUiTabAmmoStorage => 'Stockage de munitions';

  @override
  String get crewUiTabDrugStorage => 'Stockage des médicaments';

  @override
  String get crewUiTabCashStorage => 'Stockage d\'espèces';

  @override
  String get crewUiTabAllCrews => 'Équipages';

  @override
  String get crewUiTabChat => 'Chatte';

  @override
  String get crewUiActionCreateCrewShort => 'Créer un équipage (50k€)';

  @override
  String get crewUiStateNotInCrewYet =>
      'Vous n\'êtes pas encore dans un équipage';

  @override
  String get crewUiActionCreateCrew => 'Créer un équipage (50 000 €)';

  @override
  String get crewUiLabelCrewBank => 'Banque d\'équipage :';

  @override
  String get crewUiLabelDeposit => 'Dépôt';

  @override
  String get crewUiLabelWithdraw => 'Retirer';

  @override
  String get crewUiLabelMyTrustScore => 'Mon score de confiance :';

  @override
  String get crewUiActionDeleteCrew => 'Supprimer l\'équipage';

  @override
  String get crewUiLabelCrewStats => 'Statistiques de l\'équipage :';

  @override
  String get crewUiActionLeaveCrew => 'Quitter l\'équipage';

  @override
  String get crewUiSectionBuildings => 'QG et mises à niveau';

  @override
  String get crewUiHintBuildingsTabs =>
      'Ouvrez le QG et les mises à niveau pour gérer le QG et tous les bâtiments d\'équipage à partir d\'un seul endroit.';

  @override
  String get crewUiSectionCrewStorage => 'Stockage de l\'équipage';

  @override
  String get crewUiStateNoStorageData => 'Aucune donnée de stockage chargée';

  @override
  String get crewUiActionAddCar => 'Ajouter une voiture/moto';

  @override
  String get crewUiActionAddBoat => 'Ajouter un bateau';

  @override
  String get crewUiActionAddWeapon => 'Ajouter une arme';

  @override
  String get crewUiActionAddAmmo => 'Ajouter des munitions';

  @override
  String get crewUiActionAddDrugs => 'Ajouter des médicaments';

  @override
  String get crewUiSectionMembersOverview => 'Aperçu des membres';

  @override
  String get crewUiHintMembersTab =>
      'Ouvrez l\'onglet Membres ci-dessus pour la liste des membres et les demandes d\'adhésion.';

  @override
  String get crewUiActionGoToMembers => 'Aller aux membres';

  @override
  String get crewUiLabelCrewHq => 'QG de l\'équipage';

  @override
  String get crewUiActionGoToCrewHq => 'Aller au QG de l\'équipage';

  @override
  String get crewUiActionGoToStorage => 'Aller au stockage';

  @override
  String get crewUiStateJoinCrewFirst =>
      'Créez ou rejoignez d\'abord un équipage';

  @override
  String get crewUiStateJoinRequests => 'Demandes de participation';

  @override
  String get crewUiStateNoJoinRequests => 'Aucune demande en attente';

  @override
  String get crewUiStateNoCrewsFound => 'Aucun équipage trouvé';

  @override
  String get crewUiLabelMemberCount => 'Membres';

  @override
  String get crewUiBadgeMyCrew => 'Mon équipage';

  @override
  String get crewUiActionJoin => 'Rejoindre';

  @override
  String get crewUiStateNotInCrew => 'Vous n\'êtes pas dans un équipage';

  @override
  String get crewUiHintChatJoinCrew =>
      'Créez ou rejoignez un équipage pour discuter !';

  @override
  String get crewUiStatusNotOwned => 'N\'appartient pas';

  @override
  String get crewUiLabelLevel => 'Niveau';

  @override
  String get crewUiLabelCapacity => 'Capacité';

  @override
  String get crewUiLabelMemberCap => 'Plafond de membres';

  @override
  String get crewUiLabelParking => 'Parking';

  @override
  String get crewUiActionPurchase => 'Achat';

  @override
  String get crewUiActionUpgrade => 'Mise à niveau';

  @override
  String get crewUiActionDetails => 'Détails';

  @override
  String get crewUiHelpCapsTitle => 'Aperçu des niveaux';

  @override
  String get crewUiHelpLevel => 'Niveau';

  @override
  String get crewUiHelpCapacity => 'Capuchon';

  @override
  String get crewUiHelpUpgradeCost => 'Coût';

  @override
  String get crewUiHelpClose => 'Fermer';

  @override
  String get crewUiHelpShowCaps => 'Afficher les majuscules';

  @override
  String get crewUiSectionUpgradeHub => 'QG et mises à niveau';

  @override
  String get crewUiSectionStorageHub => 'Centre de stockage';

  @override
  String get crewUiHintStorageTab =>
      'Utilisez l\'onglet Stockage pour les dépôts, les soldes et les actions de stockage rapides.';

  @override
  String get crewUiHintUpgradeHub =>
      'Gérez les mises à niveau du QG et de toutes les équipes depuis un seul endroit ici.';

  @override
  String get crewUiSectionCrewMissions => 'Missions d\'équipage';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Aucune mission d\'équipage disponible pour l\'instant';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Rejoignez ou créez un équipage pour démarrer des missions.';

  @override
  String get crewUiActionStartMission => 'Commencer la mission';

  @override
  String get crewUiActionConfigureAndStartMission => 'Configurer et démarrer';

  @override
  String get crewUiActionResolveMission => 'Résoudre la mission';

  @override
  String get crewUiActionClaimRewards => 'Réclamez des récompenses';

  @override
  String get crewUiActionSpeedupCooldown => 'Accélérer le temps de recharge';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Confirmer l\'accélération';

  @override
  String get crewUiLabelActiveMission => 'Mission active';

  @override
  String get crewUiLabelRecentMissions => 'Missions récentes';

  @override
  String get crewUiLabelMissionDuration => 'Durée';

  @override
  String get crewUiLabelMissionCooldown => 'Refroidir';

  @override
  String get crewUiLabelMissionTier => 'Étage';

  @override
  String get crewUiLabelMissionRewards => 'Récompenses';

  @override
  String get crewUiLabelCrewMissionProgress =>
      'Progression de la mission de l\'équipage';

  @override
  String get crewUiLabelCrewMissionXp => 'XP de mission d\'équipage';

  @override
  String get crewUiLabelCrewMissionLevelBonus =>
      'Bonus en espèces pour l\'équipage';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus =>
      'Bonus de niveau supérieur';

  @override
  String get crewUiLabelMissionStatus => 'Statut';

  @override
  String get crewUiLabelCooldownActive => 'Temps de recharge actif';

  @override
  String get crewUiLabelRoleContributions => 'Contributions aux rôles';

  @override
  String get crewUiLabelContribution => 'contribution';

  @override
  String get crewUiLabelMultiplier => 'multiplicateur';

  @override
  String get crewUiStatusMissionLocked => 'Fermée';

  @override
  String get crewUiStatusInProgress => 'En cours';

  @override
  String get crewUiStatusCompleted => 'Complété';

  @override
  String get crewUiStatusReady => 'Prêt';

  @override
  String get crewUiStatusRewardsClaimed => 'Récompenses réclamées';

  @override
  String get crewUiStateMissionActionBusy =>
      'L\'action est en cours de traitement...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Seul le leader/co-leader peut démarrer et résoudre des missions.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Attribuer des rôles';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Choisissez un rôle de mission par membre d\'équipage.';

  @override
  String get crewUiLabelRoleNone => 'Non attribué';

  @override
  String get crewUiLabelRolePlanner => 'Planificatrice';

  @override
  String get crewUiLabelRoleEnforcer => 'Exécutrice';

  @override
  String get crewUiLabelRoleLogistics => 'Logistique';

  @override
  String get crewUiLabelRoleTech => 'Technologie';

  @override
  String get crewUiHintRoleBonus =>
      'Chaque rôle unique : +3 % de chances de réussite, -2 % de durée (max +12 % / -8 %).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'Aucun membre d\'équipage trouvé.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Sélectionnez au moins 1 rôle.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'Le niveau 2 nécessite des membres du QG 5+ et 2+.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'Le niveau 3 nécessite les membres HQ 9+ et 3+.';

  @override
  String get crewUiHintMissionLockedDefault =>
      'La mission est toujours verrouillée.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Échec du chargement des missions d\'équipage.';

  @override
  String get crewUiMessageMissionStarted => 'Mission commencée';

  @override
  String get crewUiMessageMissionResolved => 'Mission résolue';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Récompenses réclamées';

  @override
  String get crewUiMessageMissionCooldownSpedUp =>
      'Le temps de recharge est accéléré';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Impossible de charger le prix d\'accélération.';

  @override
  String get crewUiDialogSpeedupTitle => 'Accélérer le temps de recharge ?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'La finition instantanée coûte $credits crédits ($minutes min restantes).';
  }

  @override
  String get crewUiLabelCredits => 'crédits';

  @override
  String get crewUiStateLoadingPrice => 'Chargement du prix...';

  @override
  String get crewUiActionCancel => 'Annuler';

  @override
  String crewUiHqUpgradeSideBuildingsMessage(String level, String missing) {
    return 'Améliorez d\'abord tous les bâtiments latéraux au moins au niveau $level. \n\nManquant : \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 minute';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get crewUiMissionNoHistory => 'Pas d\'historique pour l\'instant.';

  @override
  String get crewUiBuildingHq => 'QG de l\'équipage';

  @override
  String get crewUiBuildingCarStorage => 'Entreposage de voiture/moto';

  @override
  String get crewUiBuildingBoatStorage => 'Stockage de bateau';

  @override
  String get crewUiBuildingWeaponStorage => 'Stockage d\'armes';

  @override
  String get crewUiBuildingAmmoStorage => 'Stockage de munitions';

  @override
  String get crewUiBuildingDrugStorage => 'Stockage des médicaments';

  @override
  String get crewUiBuildingCashStorage => 'Stockage d\'espèces';

  @override
  String get crewUiWarActionKill => 'Tuer';

  @override
  String get crewUiWarActionMug => 'Tasse';

  @override
  String get crewUiWarActionSabotage => 'Sabotage';

  @override
  String get crewUiWarActionIntel => 'Intel';

  @override
  String get crewUiWarActionRaid => 'Raid';

  @override
  String get crewUiWarActionShield => 'Bouclier';

  @override
  String get crewUiWarActionBoost => 'Booster';

  @override
  String get crewUiWarActionTerritory => 'Territoire';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count membres)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Messages d\'erreur lors du chargement : $error';
  }

  @override
  String get crewChatMessageTooLong => 'Message trop long (max 500 caractères)';

  @override
  String crewChatErrorSending(String error) {
    return 'Erreur lors de l\'envoi du message : $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Impossible de supprimer le message : $error';
  }

  @override
  String get crewChatDeleteTitle => 'Supprimer le message ?';

  @override
  String get crewChatDeleteBody => 'Ce message sera définitivement supprimé.';

  @override
  String get crewChatCancel => 'Annuler';

  @override
  String get crewChatDelete => 'Supprimer';

  @override
  String get crewChatNoMessages => 'Pas encore de messages';

  @override
  String get crewChatEmptyHint =>
      'Envoyez le premier message à votre équipage !';

  @override
  String get aviationUiBuyConfirmTitle => 'Acheter un avion ?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Voulez-vous acheter $name pour $price ?';
  }

  @override
  String get aviationUiPurchaseFailed => 'L\'achat a échoué.';

  @override
  String get aviationUiPurchasedSuccess => 'Avion acheté.';

  @override
  String get aviationUiLicenseActiveBlurb =>
      'Licence active. L\'achat d\'un avion nécessite désormais une formation complète de pilote (Aviation niveau 5 + toutes les certifications).';

  @override
  String get aviationUiLicenseMissingBlurb =>
      'Vous n\'avez pas encore de licence aéronautique. Achetez une licence dans ce module avant d\'acheter un avion.';

  @override
  String get aviationUiYourAircraft => 'Votre avion';

  @override
  String get aviationUiNoOwnedAircraft =>
      'Vous ne possédez pas encore d\'avion.';

  @override
  String get aviationUiAvailableAircraft => 'Avions disponibles';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Carburant : $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Prix ​​: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Rang minimum : $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Vitesse x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Cargaison : $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Aéronef';

  @override
  String aviationUiLoadError(String error) {
    return 'Impossible de charger les données aéronautiques : $error';
  }

  @override
  String get crewUiTr0 => 'Exigences de mise à niveau du QG';

  @override
  String get crewUiTr1 =>
      'Améliorez votre style QG actuel au niveau maximum pour débloquer le style suivant';

  @override
  String get crewUiTr2 => 'Style de QG final atteint';

  @override
  String get crewUiTr3 => 'QG VIP requis pour les niveaux 11-15';

  @override
  String get crewUiTr4 =>
      'Améliorez d\'abord tous les bâtiments latéraux au niveau requis pour ce style de QG.';

  @override
  String get crewUiTr5 => 'Immeuble déjà possédé';

  @override
  String get crewUiTr6 => 'Fonds de banque d\'équipage insuffisants';

  @override
  String get crewUiTr7 =>
      'La progression du QG est trop faible pour cette mise à niveau';

  @override
  String get crewUiTr8 => 'VIP d\'équipage requis pour le niveau 11+';

  @override
  String get crewUiTr9 =>
      'Dépôt de démarrage atteint. Achetez d\'abord du stockage d\'argent pour débloquer plus d\'espace bancaire pour l\'équipage.';

  @override
  String get crewUiTr10 => 'L\'action a échoué';

  @override
  String get crewUiTr11 => 'Il y a déjà une mission d\'équipage active.';

  @override
  String get crewUiTr12 =>
      'Un temps de recharge de mission est toujours actif. Attendez qu\'il se termine ou accélérez-le avec des crédits.';

  @override
  String get crewUiTr13 => 'Mission introuvable.';

  @override
  String get crewUiTr14 => 'Ce niveau est toujours verrouillé.';

  @override
  String get crewUiTr15 => 'Exécution de mission introuvable.';

  @override
  String get crewUiTr16 => 'La mission est déjà résolue.';

  @override
  String get crewUiTr17 => 'La mission n\'est pas encore terminée.';

  @override
  String get crewUiTr18 => 'Aucun temps de recharge actif.';

  @override
  String get crewUiTr19 => 'Crédits insuffisants.';

  @override
  String get crewUiTr20 => 'Échec du démarrage de la mission.';

  @override
  String get crewUiTr21 => 'Échec de la résolution de la mission.';

  @override
  String get crewUiTr22 => 'Échec de la réclamation des récompenses.';

  @override
  String get crewUiTr23 => 'Impossible d\'accélérer le temps de recharge.';

  @override
  String get crewUiTr24 => 'Vous n\'êtes pas dans un équipage.';

  @override
  String get crewUiTr25 => 'Seul le chef d\'équipe peut le faire.';

  @override
  String get crewUiTr26 => 'Équipage cible introuvable.';

  @override
  String get crewUiTr27 => 'Cet équipage est déjà en guerre.';

  @override
  String get crewUiTr28 => 'Au moins 3 membres d\'équipage sont requis.';

  @override
  String get crewUiTr29 => 'Guerre introuvable.';

  @override
  String get crewUiTr30 => 'Cette guerre n\'est pas active.';

  @override
  String get crewUiTr31 =>
      'Vous ne pouvez pas rejoindre cette guerre pour le moment.';

  @override
  String get crewUiTr32 => 'Cette action nécessite un joueur ciblé.';

  @override
  String get crewUiTr33 => 'Blocage anti-ferme : choisissez une autre cible.';

  @override
  String get crewUiTr34 => 'Un joueur VIP est requis pour cette action.';

  @override
  String get crewUiTr35 => 'Un équipage VIP est requis pour cette action.';

  @override
  String get crewUiTr36 => 'Limite d\'action atteinte pour l\'instant.';

  @override
  String crewUiTr37(String remaining) {
    return 'Temps de recharge actif : attendez $remaining minutes supplémentaires.';
  }

  @override
  String get crewUiTr38 => 'Territoire sélectionné non valide.';

  @override
  String get crewUiTr39 => 'L\'action de guerre des équipages a échoué.';

  @override
  String get crewUiTr40 => 'Joueur cible';

  @override
  String get crewUiTr41 => 'Tue';

  @override
  String get crewUiTr42 => 'Décès';

  @override
  String get crewUiTr43 => 'Annuler';

  @override
  String get crewUiTr44 => 'Confirmer';

  @override
  String get crewUiTr45 => 'Chef';

  @override
  String get crewUiTr46 => 'Co-leader';

  @override
  String get crewUiTr47 => 'Membre';

  @override
  String get crewUiTr48 => 'Capitale';

  @override
  String get crewUiTr49 => 'Port';

  @override
  String get crewUiTr50 => 'Industrie';

  @override
  String get crewUiTr51 => 'Frontière';

  @override
  String get crewUiTr52 => 'Logistique';

  @override
  String get crewUiTr53 => 'Réclamer';

  @override
  String get crewUiTr54 => 'Cocher';

  @override
  String get crewUiTr55 => 'Sélectionnez un territoire';

  @override
  String get crewUiTr56 => 'Sélectionnez d’abord un équipage cible.';

  @override
  String get crewUiTr57 => 'La guerre des équipages est déclarée.';

  @override
  String get crewUiTr58 => 'Échec de la déclaration de guerre à l\'équipage.';

  @override
  String get crewUiTr59 => 'Vous avez rejoint la guerre.';

  @override
  String get crewUiTr60 => 'N\'a pas réussi à rejoindre la guerre.';

  @override
  String get crewUiTr61 => 'Action de guerre d\'équipage terminée.';

  @override
  String get crewUiTr62 => 'Tuer la guerre';

  @override
  String get crewUiTr63 => 'Guerre économique';

  @override
  String get crewUiTr64 => 'Guerre de territoire';

  @override
  String get crewUiTr65 => 'Guerre totale';

  @override
  String get crewUiTr66 => 'Préparation';

  @override
  String get crewUiTr67 => 'Active';

  @override
  String get crewUiTr68 => 'Confinement';

  @override
  String get crewUiTr69 => 'Résolue';

  @override
  String get crewUiTr70 => 'Archivé';

  @override
  String get crewUiTr71 => 'Annulé';

  @override
  String get crewUiTr72 => 'Équipage VIP';

  @override
  String get crewUiTr73 => '9,99 €/mois';

  @override
  String get crewUiTr74 => '4,99 €/mois';

  @override
  String get crewUiTr75 => 'Achats uniques';

  @override
  String get crewUiTr76 =>
      'Seul le leader peut acheter des VIP pour l\'équipage';

  @override
  String get crewUiTr77 => 'Produit invalide';

  @override
  String get crewUiTr78 => 'Erreur lors de l\'ouverture de la page de paiement';

  @override
  String get crewUiTr79 => 'Es-tu sûr?';

  @override
  String get crewUiTr80 => 'Quitter l\'équipage';

  @override
  String get crewUiTr81 => 'Etes-vous sûr de vouloir quitter l\'équipage ?';

  @override
  String get crewUiTr82 => 'Partir';

  @override
  String get crewUiTr83 => 'Equipage de gauche';

  @override
  String get crewUiTr84 => 'Dépôt à la banque de l\'équipage';

  @override
  String get crewUiTr85 => 'Se retirer de la banque d\'équipage';

  @override
  String get crewUiTr86 => 'Montante';

  @override
  String get crewUiTr87 => 'Montant invalide';

  @override
  String get crewUiTr88 => 'Pas assez de liquidités disponibles';

  @override
  String get crewUiTr89 =>
      'Achetez d\'abord du stockage d\'argent pour la banque de l\'équipage';

  @override
  String get crewUiTr90 => 'Le stockage de l\'argent de l\'équipage est plein';

  @override
  String get crewUiTr91 => 'Supprimer l\'équipage';

  @override
  String get crewUiTr92 =>
      'Êtes-vous sûr de vouloir supprimer cet équipage ? Cela ne peut pas être annulé.';

  @override
  String get crewUiTr93 => 'Supprimer';

  @override
  String get crewUiTr94 => 'Niveau suivant';

  @override
  String get crewUiTr95 => 'Coût';

  @override
  String get crewUiTr96 => 'Niveau maximum atteint';

  @override
  String get crewUiTr97 => 'Bâtiment n\'appartenant pas';

  @override
  String get crewUiTr98 => 'Ajouter une voiture/moto';

  @override
  String get crewUiTr99 => 'Ajouter un bateau';

  @override
  String get crewUiTr100 => 'Moto';

  @override
  String get crewUiTr101 => 'Bateau';

  @override
  String get crewUiTr102 => 'Voiture';

  @override
  String get crewUiTr103 => 'Sélectionner';

  @override
  String get crewUiTr104 => 'Ajouter';

  @override
  String get crewUiTr105 => 'Ajouter une arme';

  @override
  String get crewUiTr106 => 'Arme';

  @override
  String get crewUiTr107 => 'Quantité';

  @override
  String get crewUiTr108 => 'Ajouter des munitions';

  @override
  String get crewUiTr109 => 'Type de munitions';

  @override
  String get crewUiTr110 => 'Ajouter des marchandises';

  @override
  String get crewUiTr111 => 'Type de marchandises';

  @override
  String get crewUiTr112 =>
      'Rejoignez d\'abord un équipage pour utiliser Crew Wars.';

  @override
  String get crewUiTr113 =>
      'Aucun membre d\'équipage adverse n\'est disponible pour cibler.';

  @override
  String get crewUiTr114 => 'Sélectionnez le joueur cible';

  @override
  String get crewUiTr115 => 'Aperçu de la saison';

  @override
  String get crewUiTr116 => 'Saison active';

  @override
  String get crewUiTr117 => 'Mon rôle';

  @override
  String get crewUiTr118 => 'L\'équipage peut déclarer';

  @override
  String get crewUiTr119 => 'Oui';

  @override
  String get crewUiTr120 => 'Non';

  @override
  String get crewUiTr121 => 'Déclarer une nouvelle guerre';

  @override
  String get crewUiTr122 => 'Équipage cible';

  @override
  String get crewUiTr123 => 'Type de guerre';

  @override
  String get crewUiTr124 => 'Déclarer la guerre';

  @override
  String get crewUiTr125 => 'Territoires de guerre';

  @override
  String get crewUiTr126 => 'Neutre';

  @override
  String get crewUiTr127 => 'Équipage adverse';

  @override
  String get crewUiTr128 => 'Actif à partir de';

  @override
  String get crewUiTr129 => 'Rejoignez la guerre';

  @override
  String get crewUiTr130 => 'Classement';

  @override
  String get crewUiTr131 => 'Territoires';

  @override
  String get crewUiTr132 => 'Actions récentes';

  @override
  String get crewUiTr133 => 'Aucune action de guerre pour l\'instant.';

  @override
  String get crewUiTr134 => 'contre';

  @override
  String get crewUiTr135 => 'Classement de la saison';

  @override
  String get crewUiTr136 => 'Pas encore de points de saison.';

  @override
  String get crewUiTr137 => 'Butin';

  @override
  String get crewUiTr138 => 'Guerres récentes';

  @override
  String get crewUiTr139 => 'Pas encore de guerres récentes.';

  @override
  String get crewUiTr140 => 'Seul le leader peut acheter ou améliorer';

  @override
  String get crewUiTr141 =>
      'Mise à niveau du QG bloquée : les bâtiments latéraux sont d\'abord vers L\$requiredSideLevel';

  @override
  String get crewUiTr142 =>
      'La prochaine mise à jour n\'est pas encore disponible';

  @override
  String get crewUiTr143 => 'Progression du QG trop faible';

  @override
  String get crewUiTr144 =>
      'Niveau de QG trop bas pour la prochaine mise à niveau';

  @override
  String get premiumUiLoadError =>
      'Les données Premium n\'ont pas pu être chargées.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Achat reçu. Actualisation de vos crédits et de votre aperçu des primes.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Paiement VIP de l\'équipage reçu. Actualisation de votre aperçu premium.';

  @override
  String get premiumUiRedirectPaidVip =>
      'Paiement VIP reçu. Actualisation de votre aperçu premium.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Achat annulé.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Paiement annulé.';

  @override
  String get premiumUiRedirectFailedOneTime => 'L\'achat a échoué ou a expiré.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'Le paiement a échoué ou a expiré.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'Échec de l\'ouverture de la page de paiement.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Cet objet nécessite une sélection de véhicule et sera utilisé à partir de l\'écran du véhicule.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Crédits échangés.';

  @override
  String get premiumUiRedeemFailed => 'Échec de l\'utilisation des crédits.';

  @override
  String get premiumUiPerMonthShort => 'mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Augmentation de la trésorerie';

  @override
  String get premiumUiCreditThemeSecurity => 'Sécurité';

  @override
  String get premiumUiCreditThemeGarage => 'Garage';

  @override
  String get premiumUiCreditThemeTuneShop => 'Boutique de mélodies';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Temps de recharge : $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset =>
      'Réinitialisation du temps de recharge';

  @override
  String get premiumUiCreditThemeEvents => 'Événements';

  @override
  String get premiumUiCreditThemePremium => 'Prime';

  @override
  String get premiumUiKpiPlayerVip => 'Joueur VIP';

  @override
  String get premiumUiKpiCrewVip => 'Équipage VIP';

  @override
  String get premiumUiCreditsLabel => 'Crédits';

  @override
  String get premiumUiStatusActive => 'Active';

  @override
  String get premiumUiStatusInactive => 'Inactive';

  @override
  String get premiumUiNoCrew => 'Pas d\'équipage';

  @override
  String get premiumUiSectionVipTitle => 'Abonnements VIP';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Tuiles VIP professionnelles avec des prix, un statut et des avantages clairs.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Avantages de compte exclusifs, déblocages d\'avatar et qualité de vie premium.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Actif jusqu\'à $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP';

  @override
  String get premiumUiExtendVip => 'Prolonger VIP';

  @override
  String get premiumUiBuyVip => 'Acheter VIP';

  @override
  String get premiumUiPlayerVipBenefitsTitle =>
      'Avantages VIP pour les joueurs';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Avantages VIP des joueurs : \n- Délais d\'action/temps de recharge 10 % plus courts (le temps de prison reste inchangé). \n- Dans Drug Production, vous obtenez un bouton éclair VIP sur chaque carte de production pour acheter les matériaux manquants en un clic (après confirmation du coût). \n- Au décès, vous perdez vos liquidités mais repartez avec 500 000 euros de liquidités. \n- Votre rang est réduit de moitié au lieu d\'une réinitialisation complète. \n- Les progrès éducatifs et les réalisations débloquées sont préservés. \n- Le solde bancaire et la crypto sont préservés. \n- Les propriétés, véhicules, prostituées, l\'inventaire transporté et les objets stockés sont supprimés. \n- La progression des médicaments et le stock de médicaments sont réinitialisés. \n- Vous recevez 100 crédits premium par semaine pendant que VIP est actif.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Vous devez faire partie d\'un équipage avant de pouvoir activer Crew VIP.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Pour les améliorations d\'équipage, les bâtiments secondaires de niveau 11 à 15 et les avantages partagés.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Equipage nécessaire';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Équipage VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Équipage requis';

  @override
  String get premiumUiExtendCrewVip => 'Prolonger le statut VIP de l\'équipage';

  @override
  String get premiumUiBuyCrewVip => 'Acheter Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Avantages VIP de l\'équipage';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Vous devez rejoindre un équipage avant d\'acheter Crew VIP. Crew VIP débloque des avantages axés sur l’équipage et une progression de mise à niveau plus élevée.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew VIP donne accès à des améliorations d’équipage supplémentaires et à des avantages premium partagés pour votre flux d’équipage. Après l\'achat, le statut actif et l\'expiration sont immédiatement mis à jour.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Acheter des crédits';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Choisissez un lot via des vignettes visuelles. L\'option populaire de 1 000 crédits bénéficie de son propre intérêt.';

  @override
  String get premiumUiNoCreditBundles =>
      'Il n’y a aucun forfait de crédit actif pour le moment.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Forfait de crédit';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Crédits instantanés pour votre portefeuille premium.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Achetez $amount crédits';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count crédits';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Offre ultra';

  @override
  String get premiumUiBadgeTopDeal => 'Meilleure offre';

  @override
  String get premiumUiBadgeCredits => 'Crédits';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine pour $price. \n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'Boutique de crédit';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Chaque article utilise une tuile thématique basée sur l\'effet que vous achetez.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Article haut de gamme';

  @override
  String get premiumUiShopItemFallbackDescription => 'Avantage premium direct.';

  @override
  String get premiumUiShopNoActiveCooldown => 'Aucun temps de recharge actif';

  @override
  String get premiumUiShopNotEnoughCredits => 'Pas assez de crédits';

  @override
  String get premiumUiShopRedeem => 'Racheter';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nThème : $theme \nCoût : $cost crédits';
  }

  @override
  String get premiumUiBadgeShop => 'Boutique';

  @override
  String get premiumUiActiveEffectsTitle => 'Effets de prime actifs';

  @override
  String get premiumUiIntroSubtitle =>
      'Les joueurs gèrent ici les abonnements VIP, les lots de crédits et les articles de la boutique de crédits.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

  @override
  String get propertiesAvailable => 'Disponible';

  @override
  String get myProperties => 'Mes propriétés';

  @override
  String get errorLoadingMyProperties =>
      'Erreur lors du chargement de mes propriétés';

  @override
  String get errorBuyingProperty => 'Erreur lors de l\'achat d\'une propriété';

  @override
  String get errorCollectingIncome => 'Erreur de collecte des revenus';

  @override
  String get noAvailableProperties => 'Aucune propriété disponible';

  @override
  String get noOwnedProperties =>
      'Vous n\'êtes pas encore propriétaire de propriétés';

  @override
  String get buyFirstPropertyHint =>
      'Achetez votre première propriété dans l\'onglet \"Disponible\"';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Voulez-vous acheter 0$name pour 1⟧€ ?';
  }

  @override
  String get propertyPrice => 'Prix';

  @override
  String get propertyMinLevel => 'Niveau requis';

  @override
  String get propertyIncomePerHour => 'Revenu/heure';

  @override
  String get propertyMaxLevel => 'Niveau maximum';

  @override
  String get propertyUniquePerCountry => '⚠️ Unique - 1 par pays';

  @override
  String get propertyIncomeReady => '✅Revenus prêts à encaisser !';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Prochain revenu en $duration';
  }

  @override
  String get propertyBuyAction => 'Acheter une propriété';

  @override
  String get propertyCollectAction => 'Collecter';

  @override
  String get propertyUpgradeAction => 'Mise à niveau';

  @override
  String get propertyMax => 'MAXIMUM';

  @override
  String propertyLevel(String level) {
    return 'Niveau $level';
  }

  @override
  String durationHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationMinutes(String minutes) {
    return '${minutes}min';
  }

  @override
  String get propertyTypeHouse => 'Maison';

  @override
  String get propertyTypeWarehouse => 'Entrepôt';

  @override
  String get propertyTypeCasino => 'Casino';

  @override
  String get propertyTypeHotel => 'Hôtel';

  @override
  String get propertyTypeFactory => 'Usine';

  @override
  String get propertyTypeBusiness => 'Entreprise';

  @override
  String get propertyCasinoName => 'Casino';

  @override
  String get propertyWarehouseName => 'Entrepôt';

  @override
  String get propertyNightclubName => 'Discothèque';

  @override
  String get propertyHouseName => 'Maison';

  @override
  String get propertyApartmentName => 'Appartement';

  @override
  String get propertyShopName => 'Boutique';

  @override
  String get propertiesConfirmPurchaseTitle => 'Es-tu sûr?';

  @override
  String get propertyTypeApartment => 'Appartement';

  @override
  String get propertyTypeNightclub => 'Discothèque';

  @override
  String get propertyTypeShop => 'Boutique';

  @override
  String get propertyStatStorageLabel => '📦Stockage';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to emplacements';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Capacité d\'accueil';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to travailleurs';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount emplacements';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current ouvriers (max $max au niveau $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current travailleurs • max';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count emplacements supplémentaires';
  }

  @override
  String get propertyManageNightclub => 'Gérer une discothèque';

  @override
  String get blackMarket => 'Marché noir';

  @override
  String get garage => 'Garage';

  @override
  String get garageCapacity => 'Capacité du garage';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total véhicules';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Surclassement ($cost€)';
  }

  @override
  String get garageMaxLevel => 'Niveau maximum';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Niveau $level | $spots places restantes';
  }

  @override
  String get noCarsInGarage => 'Aucune voiture dans votre garage';

  @override
  String get stealCarsToStart => 'Volez des voitures pour commencer !';

  @override
  String get stealFailed => 'Le vol a échoué';

  @override
  String get garageUpgradeFailed => 'Échec de la mise à niveau du garage';

  @override
  String get saleFailed => 'La vente a échoué';

  @override
  String get vehicleTransported => 'Véhicule transporté avec succès !';

  @override
  String get vehicleTransportFailed => 'Échec du transport du véhicule';

  @override
  String get listOnMarket => 'Liste sur le marché';

  @override
  String marketValue(String amount) {
    return 'Valeur marchande : $amount€';
  }

  @override
  String get askingPrice => 'Prix ​​demandé (€)';

  @override
  String get enterPrice => 'Entrez le prix';

  @override
  String get list => 'Liste';

  @override
  String get invalidPrice => 'Prix ​​invalide';

  @override
  String get vehicleListed => 'Véhicule répertorié sur le marché !';

  @override
  String get listVehicleFailed => 'Échec de la liste du véhicule';

  @override
  String get marina => 'Marina';

  @override
  String get hospital => 'Hôpital';

  @override
  String get court => 'Tribunal';

  @override
  String get casino => 'Casino';

  @override
  String get errorLoadingCasinoStatus =>
      'Impossible de vérifier le statut du casino';

  @override
  String get errorLoadingCasinoGames =>
      'Impossible de charger les jeux de casino';

  @override
  String casinoPrice(String amount) {
    return 'Prix ​​: $amount€';
  }

  @override
  String get startingCapital => 'Capital de départ';

  @override
  String get bankrollHelper => 'Ce sera la bankroll du casino';

  @override
  String get casinoOwnershipInfoTitle =>
      'À propos de la propriété d\'un casino :';

  @override
  String get casinoClosedTitle => 'CASINO FERMÉ';

  @override
  String get casinoOwnedByLabel => 'Ce casino appartient à :';

  @override
  String get casinoNoOwner => 'Ce casino n\'a pas encore de propriétaire';

  @override
  String get casinoPurchasePriceLabel => 'Prix ​​d\'achat :';

  @override
  String get casinoOwnerInfo =>
      'En tant que propriétaire, vous gérez les fonds du casino et gagnez de l\'argent lorsque les joueurs perdent !';

  @override
  String get casinoGameSlotsName => 'Machine à sous';

  @override
  String get casinoGameSlotsDesc =>
      'Faites tourner les rouleaux et gagnez jusqu\'à 100x votre mise !';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Battez le croupier et gagnez jusqu\'à 2x votre mise !';

  @override
  String get casinoGameRouletteName => 'Roulette';

  @override
  String get casinoGameRouletteDesc =>
      'Choisissez votre numéro et gagnez jusqu\'à 35x votre mise !';

  @override
  String get casinoGameDiceName => 'Dés';

  @override
  String get casinoGameDiceDesc =>
      'Lancez les dés et gagnez jusqu\'à 6x votre mise !';

  @override
  String get difficultyEasy => 'FACILE';

  @override
  String get difficultyMedium => 'MOYENNE';

  @override
  String get difficultyHard => 'DURE';

  @override
  String get casinoDepositTitle => 'Déposer de l\'argent';

  @override
  String get casinoWithdrawTitle => 'Retirer de l\'argent';

  @override
  String get amount => 'Montante';

  @override
  String get deposit => 'Dépôt';

  @override
  String get withdraw => 'Retirer';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount déposé sur la bankroll du casino';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '$amount € retiré de la bankroll du casino';
  }

  @override
  String get casinoDepositError => 'Erreur de dépôt';

  @override
  String get casinoWithdrawError => 'Erreur lors du retrait';

  @override
  String get casinoMinBankroll =>
      'Au moins 10 000 € doivent rester dans la bankroll';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Maximum : $amount€';
  }

  @override
  String get casinoManagementTitle => 'Gestion des casinos';

  @override
  String casinoBankruptWarning(String amount) {
    return 'AVERTISSEMENT : la bankroll du casino est trop faible ! \nDéposez au moins $amount € pour éviter la faillite.';
  }

  @override
  String get casinoBankroll => 'Fonds de casino';

  @override
  String get casinoStatsTitle => 'Statistiques';

  @override
  String get casinoTotalReceived => 'Total reçu :';

  @override
  String get casinoTotalPaidOut => 'Total payé :';

  @override
  String get casinoNetProfit => 'Bénéfice net:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Marge bénéficiaire : $percent%';
  }

  @override
  String get casinoManagementInfoTitle =>
      'Informations sur la gestion du casino';

  @override
  String get casinoManagementInfo5 =>
      '• Vous pouvez déposer ou retirer de l\'argent à tout moment';

  @override
  String get casinoHubChooseGameHint =>
      'Choisissez un jeu et placez votre pari';

  @override
  String get casinoPlayButton => 'Jouer';

  @override
  String get casinoGameBaccaratName => 'Baccara';

  @override
  String get casinoGameBaccaratDesc =>
      'Pariez sur un joueur, un banquier ou une égalité avec des cotes stratégiques.';

  @override
  String get casinoGameVideoPokerName => 'Vidéo Poker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Piochez 5 cartes et réalisez des combos jusqu\'au Royal Flush.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Acheter un casino (verrouillé)';

  @override
  String get casinoErrGenericPlay => 'Quelque chose s\'est mal passé';

  @override
  String get casinoErrSpinFailed => 'Erreur lors de la rotation';

  @override
  String get casinoErrBetFailed => 'Erreur lors du pari';

  @override
  String get casinoErrGambleFailed => 'Erreur en jouant';

  @override
  String get casinoErrThrowFailed => 'Erreur lors du roulement';

  @override
  String get casinoErrCasinoNotFound =>
      'Casino introuvable. Assurez-vous que le casino est acheté dans ce pays.';

  @override
  String get casinoErrInsufficientFunds => 'Pas assez d\'argent';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'La bankroll du casino est trop faible pour ce paiement';

  @override
  String casinoErrNetwork(String error) {
    return 'Erreur réseau : $error';
  }

  @override
  String get casinoResultYouWon => 'Vous avez gagné !';

  @override
  String get casinoResultYouLost => 'Perdue';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Vous avez gagné !';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Vous avez gagné$amount€ !';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Vous avez perdu⟦0€⟧';
  }

  @override
  String get casinoYouLostPlain => 'Tu as perdu';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Vous avez gagné$amount€ !';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK ! €$amount';
  }

  @override
  String get casinoAgain => 'Encore';

  @override
  String get casinoBankruptTitle => 'Casino en faillite !';

  @override
  String get casinoBankruptBody =>
      'Le casino a fait faillite ! \n\nLe propriétaire ne disposait pas de suffisamment de liquidités pour couvrir tous les paiements. \n\nLe casino est désormais fermé et peut à nouveau être acheté.';

  @override
  String get casinoBackToCasino => 'Retour au casino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Numéro : $number ($color)';
  }

  @override
  String get casinoColorGreen => 'verte';

  @override
  String get casinoColorRed => 'rouge';

  @override
  String get casinoColorBlack => 'noire';

  @override
  String get casinoRoulettePickBet => 'Choisissez votre pari';

  @override
  String get casinoRouletteBetRed => 'Rouge';

  @override
  String get casinoRouletteBetBlack => 'Noire';

  @override
  String get casinoRouletteBetEven => 'Même';

  @override
  String get casinoRouletteBetOdd => 'Impaire';

  @override
  String get casinoRouletteSpinButton => 'ROTATION!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Dernier résultat : $number';
  }

  @override
  String get casinoBetLabel => 'Pari';

  @override
  String get casinoBlackjackPlayButton => 'JOUER!';

  @override
  String get casinoSlotSpinButton => 'ROTATION!';

  @override
  String get casinoDiceRollButton => 'ROULER!';

  @override
  String get casinoBlackjackYourCards => 'Vos cartes';

  @override
  String get casinoBlackjackDealerCards => 'Cartes de revendeur';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Concessionnaire : $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Vous : $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Total : $total';
  }

  @override
  String get casinoDicePredictTitle => 'Prédire';

  @override
  String get casinoDiceLowLabel => 'Faible (2-6)';

  @override
  String get casinoDiceHighLabel => 'Élevé (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Faible/Élevé paie 2x • Le total exact paie 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Tableau de paiement';

  @override
  String get casinoBaccaratPlayer => 'Joueuse';

  @override
  String get casinoBaccaratBanker => 'Banquière';

  @override
  String get casinoBaccaratTieBet => 'Cravate';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Gagnant : $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Paiement : ⟦0 €⟧';
  }

  @override
  String get casinoNoPayout => 'Aucun paiement';

  @override
  String casinoResultEuro(String amount) {
    return 'Résultat : $amount€';
  }

  @override
  String get casinoDealing => 'Transaction…';

  @override
  String get casinoDealCaps => 'ACCORD';

  @override
  String get casinoVideoPokerDrawCards => 'TIRER DES CARTES';

  @override
  String get casinoVideoPokerDrawHint => 'Dessine ta main';

  @override
  String get casinoVideoPokerRoyalFlush => 'Quinte royale';

  @override
  String get casinoVideoPokerStraightFlush => 'Chasse d\'eau droite';

  @override
  String get casinoVideoPokerFourKind => 'Carré';

  @override
  String get casinoVideoPokerFullHouse => 'Full house';

  @override
  String get casinoVideoPokerFlush => 'Flush';

  @override
  String get casinoVideoPokerStraight => 'Droite';

  @override
  String get casinoVideoPokerThreeKind => 'Brelan';

  @override
  String get casinoVideoPokerTwoPair => 'Deux paires';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jacks ou mieux';

  @override
  String get casinoVideoPokerNoWinningHand => 'Pas de main gagnante';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Tableau des gains : Valets+ 1x • Deux paires 2x • Trips 3x • Quinte 4x • Flush 6x • Full House 9x • Quatre 25x • Quinte Flush 50x • Royal 250x';

  @override
  String get bankScreenLoadFailed => 'Échec du chargement de la banque';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Erreur réseau : $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'À : $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'De : $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Dépôt réussi';

  @override
  String get bankScreenDepositFailed => 'Échec du dépôt';

  @override
  String get bankScreenWithdrawSuccess => 'Retrait réussi';

  @override
  String get bankScreenWithdrawFailed => 'Échec du retrait';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '$amount€ transféré à $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Le transfert a échoué';

  @override
  String get bankScreenErrRecipientNotFound => 'Joueur introuvable';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'Vous ne pouvez pas vous transférer';

  @override
  String get bankScreenErrInsufficientBalance => 'Solde bancaire insuffisant';

  @override
  String get bankScreenErrInvalidAmount => 'Montant invalide';

  @override
  String get bankScreenTryAgain => 'Essayer à nouveau';

  @override
  String get bankScreenWorldwideSubtitle =>
      'Banque (accessible dans le monde entier)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Trésorerie : $amount€';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Solde bancaire : $amount€';
  }

  @override
  String get bankScreenAmountLabel => 'Montante';

  @override
  String get bankScreenDescriptionOptional => 'Description (facultatif)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Sera stocké avec votre dépôt ou retrait dans les transactions.';

  @override
  String get bankScreenDepositButton => 'Dépôt';

  @override
  String get bankScreenWithdrawButton => 'Retirer';

  @override
  String get bankScreenTransferSectionTitle => 'Transfert au joueur';

  @override
  String get bankScreenRecipientUsername =>
      'Nom d\'utilisateur du destinataire';

  @override
  String get bankScreenRecentRecipients => 'Destinataires récents';

  @override
  String get bankScreenDescriptionTransferHint =>
      'Le destinataire verra également cette description dans les transactions.';

  @override
  String get bankScreenTransferButton => 'Transfert';

  @override
  String get bankScreenTransactionsTitle => 'Transactions';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count total';
  }

  @override
  String get bankScreenSummaryDeposits => 'Dépôts';

  @override
  String get bankScreenSummaryWithdrawals => 'Retraits';

  @override
  String get bankScreenSummarySent => 'Envoyée';

  @override
  String get bankScreenSummaryReceived => 'Reçue';

  @override
  String get bankScreenNoTransactions => 'Aucune transaction pour l\'instant';

  @override
  String get bankScreenTxnDeposit => 'Dépôt';

  @override
  String get bankScreenTxnWithdraw => 'Retrait';

  @override
  String get bankScreenTxnTransferSent => 'Virement envoyé';

  @override
  String get bankScreenTxnTransferReceived => 'Virement reçu';

  @override
  String get bankScreenPrevious => 'Précédente';

  @override
  String get bankScreenNext => 'Suivante';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Page $current de $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Rang $rank';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get doAction => 'Faire';

  @override
  String get pay => 'Payer';

  @override
  String get success => 'Succès';

  @override
  String get jail => 'Prison';

  @override
  String get cooldown => 'Refroidir';

  @override
  String get requiredRank => 'Rang de joueur requis';

  @override
  String get playerRankLabel => 'Classement du joueur';

  @override
  String get loading => 'Chargement...';

  @override
  String get trade => 'Commerce';

  @override
  String get buy => 'Acheter';

  @override
  String get sell => 'Vendre';

  @override
  String get price => 'Prix';

  @override
  String get total => 'Totale';

  @override
  String available(String count) {
    return 'Disponible : $count';
  }

  @override
  String get notEnoughMoney => 'Vous n\'avez pas assez d\'argent !';

  @override
  String get confirm => 'Confirmer';

  @override
  String get close => 'Fermer';

  @override
  String get viewOffer => 'Voir l\'offre';

  @override
  String get unexpectedResponse => 'Réponse inattendue de l\'API';

  @override
  String get errorLoadingMenu => 'Erreur de chargement du menu';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get food => 'Nourriture';

  @override
  String get drink => 'Boire';

  @override
  String get work => 'Travail';

  @override
  String cooldownMinutes(String minutes) {
    return 'Temps de recharge : $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP : +$amount';
  }

  @override
  String get fly => 'Voler';

  @override
  String get purchased => 'Achetée!';

  @override
  String get sold => 'Vendue!';

  @override
  String get errorBuying => 'Erreur d\'achat';

  @override
  String get errorSelling => 'Erreur de vente';

  @override
  String get goods => 'Marchandises';

  @override
  String get marketplace => 'Marché';

  @override
  String get myListings => 'Mes annonces';

  @override
  String get inventory => 'Inventaire';

  @override
  String get backpacks => 'Sacs à dos';

  @override
  String get materials => 'Matériels';

  @override
  String get production => 'Production';

  @override
  String get stock => 'Action';

  @override
  String get retryAgain => 'Réessayer';

  @override
  String get noVehiclesAvailable => 'Aucun véhicule disponible';

  @override
  String get noListings => 'Aucune annonce';

  @override
  String get condition => 'Condition';

  @override
  String get yourHealth => 'Votre santé';

  @override
  String get criticalHealthWarning =>
      '⚠️ CRITIQUE ! Vous devez vous rendre à l\'hôpital immédiatement !';

  @override
  String get lowHealthWarning => '⚠️ Faible santé ! Sois prudent.';

  @override
  String get information => 'Information';

  @override
  String get contrabandFlowersName => 'Fleurs';

  @override
  String get contrabandFlowersDesc =>
      'Tulipes hollandaises et autres fleurs pour le commerce international';

  @override
  String get contrabandElectronicsName => 'Électronique';

  @override
  String get contrabandElectronicsDesc =>
      'Composants électroniques et informatiques avancés';

  @override
  String get contrabandDiamondsName => 'Diamants';

  @override
  String get contrabandDiamondsDesc => 'Diamants bruts et taillés';

  @override
  String get contrabandWeaponsName => 'Armes';

  @override
  String get contrabandWeaponsDesc => 'Armes et munitions illégales';

  @override
  String get contrabandPharmaceuticalsName => 'Médicaments';

  @override
  String get contrabandPharmaceuticalsDesc => 'Produits pharmaceutiques rares';

  @override
  String get multiplier => 'Multiplicateur';

  @override
  String get sellPrice => 'Prix ​​de vente';

  @override
  String get boughtFor => 'Acheté pour';

  @override
  String get profit => 'Profit';

  @override
  String get loss => 'Perte';

  @override
  String ownedQuantity(String quantity) {
    return 'Possédé : $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Spoilers dans ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 GÂTÉ - Sans valeur';

  @override
  String get vehicleBought => 'Véhicule acheté avec succès !';

  @override
  String get purchaseFailed => 'L\'achat a échoué';

  @override
  String get listingRemoved => 'Annonce supprimée';

  @override
  String get noItemsInInventory => 'Aucun article en inventaire';

  @override
  String get buyItemsInBuyTab => 'Acheter des articles dans l\'onglet Acheter';

  @override
  String errorLoadingMarketData(String error) {
    return 'Erreur lors du chargement des données de marché : $error';
  }

  @override
  String get appeal => 'Appel';

  @override
  String get submitAppeal => 'Soumettre un appel';

  @override
  String get bribeJudge => 'Juge de pots-de-vin';

  @override
  String get bribe => 'Pot-de-vin';

  @override
  String get courtLoadFailed =>
      'Impossible de charger les données du tribunal. Veuillez réessayer.';

  @override
  String get courtAppealDialogIntro =>
      'Souhaitez-vous faire appel de cette condamnation ?';

  @override
  String courtCostLine(String amount) {
    return 'Coût : $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Juge : $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruptibilité : $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'En cas de réussite : réduction de peine d\'environ 20 à 40 %';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Appel accueilli. Nouvelle phrase : $minutes minutes.';
  }

  @override
  String get courtAppealDenied => 'Appel rejeté.';

  @override
  String get courtBribeOfferIntro =>
      'Offrez un montant. Le montant est toujours déduit, même en cas d\'échec.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Montant du pot-de-vin : $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '0⟧k€';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Chances de réussite estimées : ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Le juge a soudoyé. Vous êtes libéré immédiatement.';

  @override
  String get courtBribeFailedDebited =>
      'Le pot-de-vin a échoué. Le montant a quand même été déduit.';

  @override
  String get courtRecordActive => 'Active';

  @override
  String get courtRecordServed => 'Servie';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Appel accueilli : $fromMinutes → $toMinutes minutes';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Appel refusé : $minutes minutes restantes';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Pot-de-vin échoué : $amount payé';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Condamné à $minutes minutes';
  }

  @override
  String get courtPartialLoadWarning =>
      'Attention : une partie des données du tribunal n\'a pas pu être chargée. Tirez pour actualiser pour réessayer.';

  @override
  String get courtNoActiveSentence => 'Aucune phrase active';

  @override
  String get courtNotJailedHint =>
      'Vous n\'êtes actuellement pas emprisonné. Votre casier judiciaire reste visible ci-dessous.';

  @override
  String get courtActiveSentenceTitle => 'Phrase active';

  @override
  String get courtDelictLabel => 'Crime';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Phrase totale : $minutes minutes';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Restant : $minutes minutes';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Coût d\'appel actuel : $amount';
  }

  @override
  String get courtButtonAppeal => 'Appel';

  @override
  String get courtButtonBribeJudge => 'Juge des pots-de-vin';

  @override
  String get courtUnknownCrime => 'Inconnue';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Phrase : $minutes minutes';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Phrase : $original → $reduced minutes';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Date : $datetime';
  }

  @override
  String get courtHistoryHeading => 'Histoire de la Cour';

  @override
  String get courtAppealSubmitted => 'Appel déposé';

  @override
  String get courtCriminalRecordTitle => 'Casier judiciaire';

  @override
  String courtTotalConvictions(String count) {
    return 'Total des condamnations : $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Les convictions passées restent visibles. Un pot-de-vin réussi ne règle que cette seule affaire active.';

  @override
  String get courtNoConvictionsYet =>
      'Aucune condamnation enregistrée pour l’instant.';

  @override
  String get treated => 'Traité !';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP pour $cost€';
  }

  @override
  String get treatmentOptions => 'Options de traitement';

  @override
  String get youAreDead => 'Tu es mort ! Jeu terminé.';

  @override
  String get emergencyOnly =>
      'Traitement d\'urgence uniquement disponible en dessous de 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Traitement d\'urgence ! Gratuit +$hp HP';
  }

  @override
  String get byValue => 'Par valeur';

  @override
  String get byCondition => 'Par état';

  @override
  String get byFuel => 'Par carburant';

  @override
  String get byName => 'Par nom';

  @override
  String get stealCar => 'Voler une voiture';

  @override
  String get stealBoat => 'Voler un bateau';

  @override
  String get sellVehicle => 'Vendre un véhicule';

  @override
  String get sellBoat => 'Vendre un bateau';

  @override
  String get confirmSellVehicle =>
      'Êtes-vous sûr de vouloir vendre ce véhicule ?';

  @override
  String get confirmSellBoat => 'Etes-vous sûr de vouloir vendre ce bateau ?';

  @override
  String get carStolen => 'Voiture volée avec succès !';

  @override
  String get boatStolen => 'Bateau volé avec succès !';

  @override
  String get vehicleTypeCar => 'Voiture';

  @override
  String get vehicleTypeBoat => 'Bateau';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType volé !';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Inconnu $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Vitesse';

  @override
  String get vehicleStatFuel => 'Carburant';

  @override
  String get vehicleStatCargo => 'Cargaison';

  @override
  String get vehicleStatStealth => 'Furtivité';

  @override
  String get continueAction => 'Continuer';

  @override
  String get vehicleSold => 'Véhicule vendu avec succès !';

  @override
  String get boatSold => 'Bateau vendu avec succès !';

  @override
  String get garageUpgraded => 'Garage amélioré !';

  @override
  String get marinaUpgraded => 'Marina a été mise à niveau avec succès !';

  @override
  String get marinaCapacity => 'Capacité de la marina';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total bateaux';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Surclassement ($cost€)';
  }

  @override
  String get marinaMaxLevel => 'Niveau maximum';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Niveau $level | $remaining places restantes';
  }

  @override
  String get noBoatsInMarina => 'Aucun bateau dans votre marina';

  @override
  String get stealBoatsToStart => 'Volez des bateaux pour commencer !';

  @override
  String get marinaUpgradeFailed => 'La mise à niveau de la marina a échoué';

  @override
  String get boatShipped => 'Bateau expédié avec succès !';

  @override
  String get boatShipFailed => 'L\'expédition par bateau a échoué';

  @override
  String get buyProperty => 'Acheter une propriété';

  @override
  String propertyBought(String name) {
    return '$name acheté !';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Propriété surclassée au niveau $level !';
  }

  @override
  String get errorLoadingProperties => 'Erreur de chargement des propriétés';

  @override
  String get errorUpgrading => 'Erreur de mise à niveau';

  @override
  String networkError(String error) {
    return 'Erreur réseau : $error';
  }

  @override
  String get unknownResponse => 'Réponse inconnue';

  @override
  String incomeCollected(String amount) {
    return '$amount€ collectés !';
  }

  @override
  String get buyCasino => 'Acheter un casino';

  @override
  String get manageCasino => 'Gérer le casino';

  @override
  String get casinoBought => 'Casino acheté avec succès ! 🎰';

  @override
  String get errorBuyCasino =>
      'Une erreur s\'est produite lors de l\'achat du casino';

  @override
  String minimumDeposit(String amount) {
    return 'Le dépôt minimum est de $amount€';
  }

  @override
  String get casinoInfo1 => 'Les joueurs parient contre la bankroll du casino';

  @override
  String get casinoInfo2 => 'Les gains sont payés à partir de la bankroll';

  @override
  String get casinoInfo3 => 'Vous pouvez déposer et retirer de l\'argent';

  @override
  String get casinoInfo4 => 'Minimum 10 000 € de bankroll requis';

  @override
  String get casinoInfo5 => 'En dessous : faillite';

  @override
  String get members => 'Membres';

  @override
  String get location => 'Emplacement';

  @override
  String get level => 'Niveau';

  @override
  String get alreadyFullHealth => 'Vous êtes déjà en pleine santé !';

  @override
  String get errorTreatment => 'Erreur pendant le traitement';

  @override
  String waitMinutes(String minutes) {
    return 'Vous devez attendre $minutes minutes supplémentaires pour le prochain traitement !';
  }

  @override
  String get emergencyHelp => 'Aide d\'urgence';

  @override
  String onlyNeedHp(String hp) {
    return '(Vous n\'avez besoin que de $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 L\'aide d\'urgence est GRATUITE en dessous de 10 HP (+20 HP)';

  @override
  String get hospitalInfo1 =>
      '• La santé diminue lors de la commission de crimes';

  @override
  String get hospitalInfo2 =>
      '• À 0 HP, vous ne pouvez pas commettre de crimes';

  @override
  String hospitalInfo3(String cost) {
    return '• Le traitement coûte $cost € par fois.';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Vous pouvez restaurer un maximum de $amount HP par traitement';
  }

  @override
  String get hospitalInfo5 =>
      '• ⏱️ 1 heure de récupération entre les traitements';

  @override
  String get hospitalInfo6 =>
      '• 💚 Guérison passive : +5 HP toutes les 5 minutes (si HP > 0)';

  @override
  String get medicalTreatment => 'Traitement médical';

  @override
  String get restoreCritical => 'Restaure +20 HP (condition critique)';

  @override
  String get hospitalCooldownTitle => 'Traitement en période de récupération';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Prochain soin disponible en : $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Statut médical';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'USI : $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'PV $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle =>
      'Aperçu des soins intensifs et du triage';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Patient en soins intensifs. Temps restant : $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'État critique détecté. Soins d\'urgence recommandés.';

  @override
  String get hospitalStableStatus => 'Écurie. Traitement régulier disponible.';

  @override
  String get hospitalRefreshMedicalRecord => 'Actualiser le dossier médical';

  @override
  String get hospitalStandardTreatmentTitle => 'Traitement standard';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Abordable • restaure jusqu\'à $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Traitement intensif';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Récupération plus rapide • jusqu\'à $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Traitement intensif : $cost€ pour une récupération jusqu\'à $amount HP.';
  }

  @override
  String restoreUp(String amount) {
    return 'Restaurer jusqu\'à $amount HP';
  }

  @override
  String get cost => 'Coût';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Il vous faut $tools pour ce crime';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Vous avez $tools, mais c\'est chez vous ! Allez dans Inventaire → Transfert';
  }

  @override
  String get crimeErrorVehicleRequired => '🚗 Ce crime nécessite un véhicule';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Véhicule introuvable';

  @override
  String get crimeErrorNotVehicleOwner =>
      '🚗 Vous n\'êtes pas propriétaire de ce véhicule';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Votre véhicule est en panne et a besoin d\'être réparé';

  @override
  String get crimeErrorNoFuel => '⛽ Votre véhicule n\'a plus de carburant';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Votre niveau est trop bas pour ce crime';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Crime invalide';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Vous avez besoin d\'une arme pour ce crime';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Votre arme est cassée et doit être réparée';

  @override
  String get crimeErrorNoAmmo => '🔫 Vous n\'avez pas de munitions';

  @override
  String get crimeErrorGeneric =>
      '❌ Quelque chose n\'a pas fonctionné avec ce crime';

  @override
  String get inventoryFull =>
      '🎒 Votre inventaire est plein ! Ranger les outils dans une propriété';

  @override
  String get storageFull => '📦 Le stockage de la propriété est plein';

  @override
  String get inventoryCrimeWeaponTitle => 'Arme du crime sélectionnée';

  @override
  String get inventoryCrimeWeaponHint =>
      'Sélectionnez une arme pour les crimes';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Choisissez votre arme criminelle ici. L\'écran des crimes utilise immédiatement cette sélection.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'Aucune arme utilisable dans l\'inventaire. Achetez ou déplacez d\'abord une arme dans les objets transportés.';

  @override
  String get inventoryCarriedEmpty =>
      'Vous ne transportez aucun outil, arme ou munition.';

  @override
  String get inventorySectionTools => 'Outils';

  @override
  String get inventorySectionWeapons => 'Armes';

  @override
  String get inventorySectionAmmo => 'Munitions';

  @override
  String get inventoryWeaponFallbackName => 'Arme';

  @override
  String get inventoryAmmoFallbackName => 'Munitions';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'État : $condition% • Quantité : $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Quantité : $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Quantité : $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Retirer du stockage : $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Max : $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Quantité invalide';

  @override
  String get inventorySnackWeaponStored => 'Arme stockée';

  @override
  String get inventorySnackWeaponWithdrawn => 'Arme retirée';

  @override
  String get inventorySnackCashStored => 'Espèces déposées';

  @override
  String get inventorySnackCashWithdrawn => 'Espèces retirées';

  @override
  String get inventorySnackDrugsWithdrawn => 'Médicaments retirés';

  @override
  String get inventoryActionFailed => 'L\'action a échoué';

  @override
  String get inventoryStorageNoCategory => 'Aucun type de stockage';

  @override
  String get inventoryCountsWeapons => 'Armes';

  @override
  String get inventoryCountsDrugs => 'Drogues';

  @override
  String get inventoryCountsCash => 'Espèces';

  @override
  String inventoryStorageCountsLine(
    String weapons,
    int weaponCount,
    String drugs,
    int drugCount,
    String cash,
    int cashAmount,
  ) {
    return '$weapons : $weaponCount • $drugs : $drugCount • $cash : $cashAmount €';
  }

  @override
  String get inventoryStorageWrongCountry =>
      'Vous êtes dans un autre pays. Vous ne pouvez pas accéder à ce stockage ici.';

  @override
  String get inventoryWeaponStorageTitle => 'Stockage d\'armes';

  @override
  String get inventoryStoreWeapons => 'Magasin';

  @override
  String get inventoryInStorage => 'En stockage';

  @override
  String get inventoryUnknownWeapon => 'Arme inconnue';

  @override
  String get inventoryTakeOne => 'Prenez 1';

  @override
  String get inventoryNoWeaponsInStorage => 'Aucune arme dans ce stockage.';

  @override
  String get inventoryCashStorageTitle => 'Stockage d\'espèces';

  @override
  String get inventoryDepositCash => 'Déposer de l\'argent';

  @override
  String get inventoryWithdrawCash => 'Retirer de l\'argent';

  @override
  String get inventoryDrugStorageTitle => 'Stockage des médicaments';

  @override
  String get inventoryNoDrugsInStorage => 'Aucun médicament en stock.';

  @override
  String get inventoryNotForTools =>
      'Cette propriété n\'est pas destinée au stockage d\'outils. Utilisez un entrepôt pour les outils.';

  @override
  String get inventoryCategoryTools => 'Outils';

  @override
  String get inventoryCategoryDrugs => 'Drogues';

  @override
  String get inventoryCategoryWeapons => 'Armes';

  @override
  String get inventoryCategoryCash => 'Espèces';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max emplacements ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Accessible dans le pays actuel';

  @override
  String get inventoryStorageNotAccessibleHere => 'Non accessible dans ce pays';

  @override
  String get loadoutEquipFailed => 'Échec de l\'équipement du chargement';

  @override
  String get loadoutDeleteFailed => 'Échec de la suppression du chargement';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool déplacé vers $location';
  }

  @override
  String get carried => 'Adoptée';

  @override
  String get storage => 'Stockage';

  @override
  String get property => 'Propriété';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max emplacements';
  }

  @override
  String get loadouts => 'Chargements';

  @override
  String get createLoadout => 'Créer un chargement';

  @override
  String get equipLoadout => 'Équiper';

  @override
  String get loadoutEquipped => '✅ Équipement équipé';

  @override
  String get loadoutMaxReached => '❌ Chargements maximum atteints (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Outils manquants : $tools';
  }

  @override
  String get backpackUpgrade => 'Mise à niveau du sac à dos';

  @override
  String get backpackBasic => 'Sac à dos de base (+5 emplacements)';

  @override
  String get backpackTactical => 'Gilet tactique (+10 emplacements)';

  @override
  String get backpackCargo => 'Pantalon cargo (+3 emplacements)';

  @override
  String get upgradeInventory => 'Inventaire de mise à niveau';

  @override
  String get noToolsCarried => 'Aucun outil transporté';

  @override
  String get visitShopToBuyTools =>
      'Visitez la boutique pour acheter des outils';

  @override
  String get noProperties => 'Aucune propriété';

  @override
  String get buyPropertyForStorage =>
      'Acheter une propriété pour stocker des outils';

  @override
  String get noToolsInStorage => 'Aucun outil en stock';

  @override
  String get selectProperty => 'Sélectionnez une propriété';

  @override
  String get slotsRemaining => 'créneaux restants';

  @override
  String get noLoadouts => 'Aucun chargement';

  @override
  String get createLoadoutToStart => 'Créez un chargement pour commencer';

  @override
  String get deleteLoadout => 'Supprimer le chargement';

  @override
  String get confirmDeleteLoadout =>
      'Êtes-vous sûr de vouloir supprimer ce chargement ?';

  @override
  String get loadoutDeleted => 'Chargement supprimé';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get active => 'Active';

  @override
  String get durability => 'Durabilité';

  @override
  String get quantity => 'Quantité';

  @override
  String get slotSize => 'Taille de l\'emplacement';

  @override
  String get repairCost => 'Coût de réparation';

  @override
  String get wearPerUse => 'Usure par utilisation';

  @override
  String get loseChance => 'Chance de perdre';

  @override
  String get requiredFor => 'Requis pour';

  @override
  String get lowDurability => 'Faible durabilité';

  @override
  String get transfer => 'Transfert';

  @override
  String get toolDetails => 'Détails de l\'outil';

  @override
  String get transferTool => 'Outil de transfert';

  @override
  String get selectQuantity => 'Sélectionnez la quantité';

  @override
  String get destination => 'Destination';

  @override
  String get from => 'Depuis';

  @override
  String get to => 'À';

  @override
  String get editLoadout => 'Modifier l\'équipement';

  @override
  String get loadoutName => 'Nom du chargement';

  @override
  String get description => 'Description';

  @override
  String get optional => 'facultative';

  @override
  String get selectedTools => 'Outils sélectionnés';

  @override
  String get noToolsAvailable => 'Aucun outil disponible';

  @override
  String get create => 'Créer';

  @override
  String get save => 'Sauvegarder';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get pleaseSelectTools => 'Veuillez sélectionner au moins 1 outil';

  @override
  String get loadoutCreated => 'Chargement créé';

  @override
  String get loadoutUpdated => 'Équipement mis à jour';

  @override
  String get goToInventory => 'Aller à l\'inventaire';

  @override
  String get slots => 'machines à sous';

  @override
  String get backpackShop => 'Boutique de sacs à dos';

  @override
  String get yourBackpack => 'Votre sac à dos';

  @override
  String get availableUpgrades => 'Mises à niveau disponibles';

  @override
  String get otherBackpacks => 'Autres sacs à dos';

  @override
  String get youHaveBestBackpack => 'Vous avez le meilleur sac à dos !';

  @override
  String get backpackPurchased => 'Sac à dos acheté !';

  @override
  String get backpackUpgraded => 'Sac à dos amélioré !';

  @override
  String get buyBackpack => 'Acheter';

  @override
  String get upgradeBackpack => 'Mise à niveau';

  @override
  String get backpackPrice => 'Prix';

  @override
  String get extraSlots => 'Emplacements supplémentaires';

  @override
  String get totalSlots => 'Emplacements totaux';

  @override
  String get vipOnly => 'VIP uniquement';

  @override
  String get tradeInValue => 'Valeur de reprise';

  @override
  String get upgradeCost => 'Coût de mise à niveau';

  @override
  String rankRequired(Object rank) {
    return 'Rang $rank requis';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Il vous faut$needed€. Vous avez $have€';
  }

  @override
  String get alreadyHasBackpack => 'Vous avez déjà un sac à dos';

  @override
  String get backpackNotFound => 'Sac à dos introuvable';

  @override
  String get playerNotFound => 'Joueur introuvable';

  @override
  String get notAnUpgrade => 'Ce n\'est pas une mise à niveau';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Vous avez acheté $name ! +$slots emplacements.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Mis à niveau vers $newName ! +$upgradeSlots emplacements supplémentaires.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Sac à dos introuvable';

  @override
  String get backpackPurchaseFailedAlready =>
      'Vous avez déjà un sac à dos. Vous ne pouvez en utiliser qu’un à la fois.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Vous avez besoin du rang $required (vous êtes le rang $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Il vous faut$needed€. Vous avez $have€';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Ce sac à dos est réservé aux membres VIP';

  @override
  String get backpackUpgradeFailedNo =>
      'Vous n\'avez pas de sac à dos à mettre à niveau';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Il ne s\'agit pas d\'une mise à niveau. Choisissez un sac à dos plus grand.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Vous avez besoin du rang $required (vous êtes le rang $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Il vous faut$needed€. Vous avez $have€';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'Ce sac à dos est réservé aux membres VIP';

  @override
  String get backpackPurchaseFailedGeneric =>
      'Impossible de finaliser l\'achat.';

  @override
  String get backpackUpgradeFailedGeneric =>
      'Impossible de terminer la mise à niveau.';

  @override
  String get backpackUnknownEvent => 'Action inconnue';

  @override
  String get backpackLoadFailedGeneric => 'Quelque chose s\'est mal passé';

  @override
  String get backpackOwnedBadge => 'Possédée';

  @override
  String get availableBackpacks => 'Sacs à dos disponibles';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Actuel : $name (+$slots emplacements)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Nouveau : $name (+$slots emplacements)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Mise à niveau : +$delta emplacements';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Total : $totalSlots emplacements';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(problème de stockage – essayez de vous connecter à nouveau)';

  @override
  String get blackMarketTabBackpacks => 'Sacs à dos';

  @override
  String get bmHubAdjustFiltersHint => 'Essayez d\'ajuster vos filtres';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Allez dans Garage ou Marina pour lister les véhicules';

  @override
  String get bmHubSellerLabel => 'Vendeuse';

  @override
  String get bmHubAskingPriceLabel => 'Prix ​​demandé';

  @override
  String get bmHubMarketValueShort => 'Valeur marchande';

  @override
  String get bmHubBuyNow => 'Acheter maintenant';

  @override
  String get bmHubListedFor => 'Inscrit pour';

  @override
  String get bmHubEditPrice => 'Modifier le prix';

  @override
  String get bmHubDelist => 'Supprimer la liste';

  @override
  String get bmHubFilterListingsTitle => 'Filtrer les annonces';

  @override
  String get bmHubLabelCountry => 'Pays';

  @override
  String get bmHubAllCountries => 'Tous les pays';

  @override
  String get bmHubLabelVehicleType => 'Type de véhicule';

  @override
  String get bmHubAllTypes => 'Tous types';

  @override
  String get bmHubCars => 'Voitures';

  @override
  String get bmHubBoats => 'Bateaux';

  @override
  String get bmHubPriceRange => 'Gamme de prix';

  @override
  String get bmHubClearFilters => 'Effacer les filtres';

  @override
  String get bmHubApply => 'Appliquer';

  @override
  String get bmHubBuyVehicleTitle => 'Acheter un véhicule';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Acheter $name pour $price ?';
  }

  @override
  String get bmHubVehiclePurchased => 'Véhicule acheté avec succès !';

  @override
  String get bmHubVehiclePurchaseFailed => 'Échec de l\'achat du véhicule';

  @override
  String get bmHubNewPriceEuro => 'Nouveau prix (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Entrez le nouveau prix';

  @override
  String get bmHubCurrentPrice => 'Prix ​​actuel';

  @override
  String get bmHubPriceUpdated => 'Prix ​​mis à jour avec succès !';

  @override
  String get bmHubPriceUpdateFailed => 'Échec de la mise à jour du prix';

  @override
  String get bmHubUpdateButton => 'Mise à jour';

  @override
  String get bmHubDelistVehicleTitle => 'Supprimer le véhicule';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Supprimer $name du marché ?';
  }

  @override
  String get bmHubVehicleDelisted => 'Véhicule radié avec succès !';

  @override
  String get bmHubDelistFailed => 'Échec de la suppression du véhicule';

  @override
  String get bmHubLocationUnknown => 'INCONNUE';

  @override
  String get arrested => 'Arrêté!';

  @override
  String get jailMessage =>
      'Vous avez été arrêté pendant votre voyage et toutes les marchandises ont été confisquées !';

  @override
  String get confirmAction => 'Es-tu sûr?';

  @override
  String get ok => 'D\'ACCORD';

  @override
  String get travelContinueConfirmTitle => 'Passer à l\'étape suivante ?';

  @override
  String get travelContinueConfirmBody =>
      'Les contrôles aux frontières sont actifs. Continuer votre voyage ?';

  @override
  String get travelJourneyCompleteTitle => 'Voyage terminé';

  @override
  String get travelJourneyCompleteBody =>
      'Vous êtes arrivé à destination en toute sécurité.';

  @override
  String get hitlist => 'Liste des résultats';

  @override
  String hitlistLoadError(String error) {
    return 'Erreur lors du chargement de la liste des résultats : $error';
  }

  @override
  String get noActiveHits => 'Aucun coup actif placé';

  @override
  String get selectTarget => 'Sélectionnez la cible';

  @override
  String get searchPlayer => 'Rechercher un joueur...';

  @override
  String get placeHitTitle => 'Placer le coup';

  @override
  String get minimumBounty => 'Prime minimale : 50 000 €';

  @override
  String get bountyAmount => 'Montant de la prime';

  @override
  String get place => 'Lieu';

  @override
  String hitPlaced(String amount) {
    return 'Hit placé pour ⟦0€⟧';
  }

  @override
  String hitError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get hitDifferentCountry =>
      'Vous devez être dans le même pays que la cible';

  @override
  String get hitlistErrMissingBounty => 'Le montant de la prime est requis';

  @override
  String get hitlistErrBountyTooLow => 'La prime minimale est de 50 000 €';

  @override
  String get hitlistErrCannotHitYourself =>
      'Vous ne pouvez pas vous frapper vous-même';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Vous avez déjà un hit actif sur ce joueur';

  @override
  String get hitlistErrInsufficientMoney => 'Tu n\'as pas assez d\'argent';

  @override
  String get hitlistErrMissingCounterBounty =>
      'Le montant de la contre-prime est requis';

  @override
  String get hitlistErrHitNotFound => 'Coup introuvable';

  @override
  String get hitlistErrNotTarget =>
      'Seule la cible peut faire une contre-offre';

  @override
  String get hitlistErrHitNotActive => 'Le coup n\'est pas actif';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'La contre-prime doit être supérieure à la prime initiale';

  @override
  String get hitlistErrMissingWeapon => 'Une arme est requise';

  @override
  String get hitlistErrWeaponNotFound => 'Arme introuvable';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Vous ne possédez pas cette arme ou elle est cassée';

  @override
  String get hitlistErrWeaponBroken =>
      'L\'arme que vous avez sélectionnée est cassée. Réparez-le d’abord.';

  @override
  String get hitlistErrInsufficientAmmo =>
      'Vous n\'avez pas assez de munitions';

  @override
  String get hitlistErrInvalidAmmoHit => 'Quantité de munitions invalide';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'La cible a une protection active contre les coups';

  @override
  String get hitlistErrInvalidInvestigationTier => 'Type d\'enquête non valide';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Une enquête est déjà en cours pour ce coup. Attendez votre message de détective.';

  @override
  String get hitlistErrInvalidCaseId => 'Numéro de dossier invalide';

  @override
  String get hitlistErrMurderCaseNotFound => 'Dossier introuvable';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Fenêtre d\'enquête expirée (24 heures)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'L\'enquête sur cette affaire a déjà commencé';

  @override
  String get hitlistErrNotPlacer => 'Seul le placeur peut annuler le coup';

  @override
  String get hitlistInvestigationOptions => 'Options d\'enquête';

  @override
  String get hitlistInvestigationChooseSpeedPrice =>
      'Choisissez la vitesse et le prix :';

  @override
  String get hitlistInvestigationQuick =>
      'Enquête rapide (1 000 000 € • 1 heure)';

  @override
  String get hitlistInvestigationStandard =>
      'Enquête standard (500 000 € • 6 heures)';

  @override
  String get hitlistInvestigationSlow =>
      'Enquête lente (250 000 € • 24 heures)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'L\'enquête est en attente. Coût $cost. ETA : $etaMinutes min. Le rapport arrivera via les messages du Detective Bureau (vers $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'L\'enquête a échoué';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'L\'enquête n\'a pas pu être complétée';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Frappe réussie ! Prime et butin reçus : espèces $cash, objets transportés $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'La tentative de frappe a expiré. Veuillez réessayer.';

  @override
  String get hitlistNoUsableWeapons =>
      'Vous n\'avez aucune arme utilisable dans votre inventaire. Achetez ou réparez d’abord une arme.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Erreur de chargement des armes : $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Erreur de chargement des joueurs : $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => 'il y a 1 jour';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return 'il y a $count jours';
  }

  @override
  String get counterBountyTitle => 'Placer une contre-bounty';

  @override
  String minimumAmount(String amount) {
    return 'Montant minimum : $amount€';
  }

  @override
  String get counterBountyAmount => 'Montant de la contre-prime';

  @override
  String counterBountyPlaced(String amount) {
    return 'Contre-bounty de $amount€ placé';
  }

  @override
  String get cancelHitConfirmTitle => 'Annuler l\'appel ?';

  @override
  String get cancelHitConfirmBody => 'Votre prime sera remboursée.';

  @override
  String get hitCancelled => 'Appel annulé';

  @override
  String get target => 'Cible';

  @override
  String get placer => 'Placeuse';

  @override
  String get bounty => 'Prime';

  @override
  String get counterBid => 'CONTRE-OFFRE';

  @override
  String get counterBidPlaced =>
      'Contre-enchère placée ! Le contrat a été annulé.';

  @override
  String get attemptHit => 'Tentative de frappe';

  @override
  String get selectWeapon => 'Sélectionnez l\'arme et les munitions';

  @override
  String get youAreTargeted => 'Vous êtes sur la liste noire';

  @override
  String get security => 'Sécurité';

  @override
  String get currentDefense => 'Défense actuelle';

  @override
  String get totalDefense => 'Défense totale';

  @override
  String get currentArmor => 'Armure actuelle';

  @override
  String get bodyguards => 'Gardes du corps';

  @override
  String get buyBodyguards => 'Acheter des gardes du corps';

  @override
  String get bodyguardPrice => 'Prix ​​par garde du corps';

  @override
  String get armor => 'Armure';

  @override
  String get protectorsFollow => 'Des protecteurs qui vous suivent';

  @override
  String get eachGivesDefense => 'Chacun donne +10 en défense';

  @override
  String get lightArmor => 'Armure légère';

  @override
  String get basicProtection => 'Protection de base';

  @override
  String get heavyArmor => 'Armure lourde';

  @override
  String get strongProtection => 'Forte protection';

  @override
  String get bulletproofVest => 'Gilet pare-balles';

  @override
  String get veryStrongProtection => 'Protection très forte';

  @override
  String get tacticalSuit => 'Tenue tactique';

  @override
  String get premiumProtection => 'Protection haut de gamme';

  @override
  String get defense => 'Défense';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'Vous avez acheté $armor ! +$defense défense';
  }

  @override
  String get worn => 'Porté';

  @override
  String get replaceArmor => 'Remplacer';

  @override
  String get bodyguardProductName => 'Garde du corps';

  @override
  String securityLoadError(String error) {
    return 'Erreur de chargement de la sécurité : $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'Impossible de charger l\'état de sécurité.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'État $percent% · base $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Salaire journalier $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Coût quotidien du système : $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Prochaine paie : $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Si vous ne pouvez pas payer le salaire journalier, tous les gardes du corps partent.';

  @override
  String get armorOneAtATimeHint =>
      'Vous ne pouvez porter qu’une seule armure à la fois. Une nouvelle armure remplace toujours votre armure actuelle.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Maintenant +$defense à $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'Impossible d\'acheter un garde du corps';

  @override
  String get couldNotBuyArmor => 'Impossible d\'acheter une armure';

  @override
  String get armorAlreadyEquippedLong =>
      'Vous portez déjà cette armure. Vous ne pouvez porter qu’une seule armure à la fois.';

  @override
  String get securityErrorArmorNotFound => 'Armure introuvable';

  @override
  String get securityErrorMinQuantity => 'La quantité doit être d\'au moins 1';

  @override
  String get hit => 'FRAPPER';

  @override
  String get counterBidLabel => 'CONTRE-OFFRE';

  @override
  String daysAgo(String count, String plural) {
    return 'Il y a $count jour$plural';
  }

  @override
  String get justPlaced => 'Je viens de placer';

  @override
  String get youAreTheTarget => 'Vous êtes la cible';

  @override
  String get youAreThePlacer => 'Tu es le placeur';

  @override
  String get onlyTargetCanCounterBid =>
      'Seule la cible peut faire une contre-offre';

  @override
  String get executeHit => 'Exécuter le coup';

  @override
  String get moneyNotEnough => 'Tu n\'as pas assez d\'argent';

  @override
  String get securityScreen => 'Sécurité';

  @override
  String get currentDefenseStatus => 'État de défense actuel';

  @override
  String get noWeapons => 'Vous n\'avez aucune arme dans votre inventaire';

  @override
  String get ammoQuantity => 'Quantité de munitions';

  @override
  String get noAmmoRequired => 'Aucune munition requise pour cette arme';

  @override
  String get weaponStats => 'Statistiques des armes';

  @override
  String get damage => 'Dommage';

  @override
  String get intimidation => 'Intimidation';

  @override
  String get execute => 'Exécuter';

  @override
  String get hitExecuted => 'Frappe exécutée avec succès !';

  @override
  String get invalidAmmo => 'Veuillez entrer une quantité de munitions valide';

  @override
  String get weaponsMarket => 'Marché des armes';

  @override
  String get ammoMarket => 'Marché des munitions';

  @override
  String get shootingRange => 'Champ de tir';

  @override
  String get ammoFactory => 'Usine de munitions';

  @override
  String get weaponShop => 'Magasin d\'armes';

  @override
  String get myWeapons => 'Mes armes';

  @override
  String get weaponPurchased => 'Arme achetée';

  @override
  String weaponRankRequired(String rank) {
    return 'Rang requis : $rank';
  }

  @override
  String get buyWeapon => 'Acheter';

  @override
  String get ammoShop => 'Marché des munitions';

  @override
  String get myAmmo => 'Mes munitions';

  @override
  String get ammoPurchased => 'Munitions achetées';

  @override
  String get purchaseCooldown => 'Vous devez attendre avant le prochain achat';

  @override
  String get insufficientStock => 'Pas assez de stock disponible';

  @override
  String get maxInventoryReached => 'Capacité maximale d\'inventaire atteinte';

  @override
  String get invalidQuantity => 'Quantité invalide';

  @override
  String get nextAmmoPurchase => 'Prochain achat disponible dans';

  @override
  String get ammoBoxes => 'Boîtes';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds cartouches par boîte';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Vous recevrez : $rounds cartouches';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Coût total : $cost€';
  }

  @override
  String get ammoRounds => 'cartouches';

  @override
  String get ammoGeneric => 'Munitions';

  @override
  String get ammoPerCrimeSuffix => 'par crime';

  @override
  String get ammoBoxesUnit => 'boîtes';

  @override
  String get ammoStock => 'Action';

  @override
  String get ammoQuality => 'Qualité';

  @override
  String get factoryBought => 'Acheté en usine';

  @override
  String get factoryProduced => 'Production mise à jour';

  @override
  String get factorySessionStarted =>
      'Production démarrée : actif pendant 8 heures, réclamation toutes les 10 minutes';

  @override
  String get ammoFactoryTitle => 'Usine de munitions';

  @override
  String get ammoFactoryIntro =>
      'Produit par lots ; vous réclamez toutes les 10 minutes (jusqu\'à 8 heures de retard par session).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Ce que vous pouvez faire :';

  @override
  String get ammoFactoryActionBuy => 'Achetez une usine dans votre pays actuel';

  @override
  String get ammoFactoryActionProduce =>
      'Production des réclamations (intervalle : 10 minutes, backlog max : 8 heures par session)';

  @override
  String get ammoFactoryActionOutput =>
      'Améliorez la sortie au niveau 5 pour plus de tours par réclamation';

  @override
  String get ammoFactoryActionQuality =>
      'Améliorez la qualité pour des prix de marché plus élevés';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munitions à vendre';

  @override
  String get ammoFactoryBlackMarketBody =>
      'L\'usine de munitions ne vend pas de balles directement depuis cet écran. Utilisez le marché noir pour acheter et vendre des munitions.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Achetez et vendez des munitions sur le marché noir, et non directement depuis l\'usine.';

  @override
  String get ammoFactoryErrCountryRequired => 'Le pays est requis';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Joueur introuvable';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Vous devez être dans le même pays pour acheter cette usine';

  @override
  String get ammoFactoryErrCouldNotPurchase => 'Impossible d\'acheter l\'usine';

  @override
  String get ammoFactoryErrAlreadyOwned => 'L\'usine appartient déjà';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Pas assez d\'argent pour acheter une usine';

  @override
  String get ammoFactoryErrCouldNotProduce =>
      'Impossible de produire des munitions';

  @override
  String get ammoFactoryErrNotOwned => 'Vous ne possédez pas d\'usine';

  @override
  String get ammoFactoryErrOnCooldown => 'L\'usine est en refroidissement';

  @override
  String get ammoFactoryErrInactive =>
      'Propriété de l\'usine perdue en raison de l\'inactivité';

  @override
  String get ammoFactoryErrCouldNotUpgrade =>
      'Impossible de mettre à niveau l\'usine';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Pas assez d\'argent pour moderniser l\'usine';

  @override
  String get ammoFactoryErrMaxLevel => 'L\'usine est déjà au niveau maximum';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Le type de mise à niveau doit être de sortie ou de qualité';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Exigences de formation non remplies';

  @override
  String get factoryUpgradeOutputSuccess => 'Sortie améliorée';

  @override
  String get factoryUpgradeQualitySuccess => 'Qualité améliorée';

  @override
  String get myFactory => 'Mon usine';

  @override
  String get noFactoryOwned => 'Vous ne possédez pas d\'usine';

  @override
  String get factoryCountry => 'Pays';

  @override
  String get factoryOutputLevel => 'Niveau de sortie';

  @override
  String get factoryQualityLevel => 'Niveau de qualité';

  @override
  String get factoryLastProduced => 'Dernière production';

  @override
  String get factoryProduceStatusLabel => 'État de la production';

  @override
  String get factoryProduceStatusReady => 'Prêt';

  @override
  String get factoryProduceStatusCooldown => 'Temps d’attente';

  @override
  String get factorySessionActive =>
      'Fenêtre de production : active (intervalle de 10 min)';

  @override
  String get factorySessionStopped =>
      'Fenêtre de production : arrêtée (cliquez sur Produire pour démarrer une nouvelle fenêtre de 8 heures)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'La fenêtre se termine par : $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Prochaine production : disponible maintenant (appuyez sur Produire pour réclamer)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Prochaine production en : $duration';
  }

  @override
  String get factoryProduce => 'Produire';

  @override
  String get factoryUpgradeOutput => 'Sortie de mise à niveau';

  @override
  String get factoryUpgradeQuality => 'Améliorer la qualité';

  @override
  String get factoryList => 'Usines par pays';

  @override
  String get factoryUnowned => 'Disponible';

  @override
  String factoryOwnedBy(String owner) {
    return 'Propriétaire : $owner';
  }

  @override
  String get factoryBuy => 'Acheter';

  @override
  String get shootingIntro =>
      'Améliorez votre précision et augmentez votre taux de réussite en matière de criminalité';

  @override
  String get shootingTrainSuccess => 'Formation terminée';

  @override
  String get shootingMaxSessionsReached =>
      'Nombre maximum d\'entraînements atteint';

  @override
  String get shootingTrainingProgressTitle => 'Progrès de la formation';

  @override
  String get shootingSessionsCompletedLabel => 'Séances terminées :';

  @override
  String get shootingProgressCompleteSuffix => 'complète';

  @override
  String get shootingCurrentBonusTitle => 'Bonus actuel';

  @override
  String get shootingAccuracyBonusLabel => 'Bonus de précision';

  @override
  String get shootingMaximumLabel => 'Maximum';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Ce bonus est appliqué à toutes vos tentatives de crime';

  @override
  String get shootingReadyToTrain => 'Prêt à s\'entraîner';

  @override
  String get shootingTrainingCooldownTitle =>
      'Temps de recharge de l\'entraînement';

  @override
  String shootingCooldownLabel(String time) {
    return 'Prochaine séance à : $time';
  }

  @override
  String get shootingCooldownHint =>
      'Vous devez attendre 1 heure entre les entraînements';

  @override
  String get shootingTrainingInProgress => 'Entraînement...';

  @override
  String get shootingHowItWorksTitle => 'Comment ça marche ?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Entraînez-vous toutes les heures pour améliorer la précision';

  @override
  String get shootingHowItWorksBullet2 =>
      '• Chaque session donne +0,1 % de bonus';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Maximum de 100 séances (+10 % au total)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Augmente votre taux de réussite en matière de crime';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Bonus permanent, chaque session compte';

  @override
  String shootingSessions(String count) {
    return 'Séances : $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Bonus de précision : $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Prochaine séance à $time';
  }

  @override
  String get shootingTrain => 'Former';

  @override
  String get gym => 'Salle de sport';

  @override
  String get gymIntro =>
      'Entraînez votre force et augmentez votre taux de réussite en matière de crime';

  @override
  String get gymTrainSuccess => 'Formation terminée';

  @override
  String get gymMaxSessionsReached => 'Nombre maximum de sessions atteint';

  @override
  String get gymTrainingProgressTitle => 'Progrès de la formation';

  @override
  String get gymSessionsCompletedLabel => 'Séances terminées :';

  @override
  String get gymProgressCompleteSuffix => 'complète';

  @override
  String get gymCurrentBonusTitle => 'Bonus actuel';

  @override
  String gymSessions(String count) {
    return 'Séances : $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Bonus de force';

  @override
  String get gymMaximumLabel => 'Maximum';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonus de force : $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Ce bonus est appliqué à toutes vos tentatives de crime';

  @override
  String get gymReadyToTrain => 'Prêt à s\'entraîner';

  @override
  String get gymTrainingCooldownTitle => 'Temps de recharge de l\'entraînement';

  @override
  String gymCooldown(String time) {
    return 'Prochaine séance à $time';
  }

  @override
  String get gymCooldownHint =>
      'Vous devez attendre 1 heure entre les entraînements';

  @override
  String get gymTrain => 'Former';

  @override
  String get gymTrainingInProgress => 'Entraînement...';

  @override
  String get gymHowItWorksTitle => 'Comment ça marche ?';

  @override
  String get gymHowItWorksBullet1 =>
      '• Entraînez-vous toutes les heures pour augmenter votre force';

  @override
  String get gymHowItWorksBullet2 => '• Chaque session donne +0,08 % de bonus';

  @override
  String get gymHowItWorksBullet3 => '• Maximum de 100 séances (+8% au total)';

  @override
  String get gymHowItWorksBullet4 =>
      '• Augmente votre taux de réussite en matière de crime';

  @override
  String get gymHowItWorksBullet5 => '• Bonus permanent, chaque session compte';

  @override
  String get buyAmmo => 'Acheter des munitions';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Coût d\'achat : $cost€';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Sortie par cycle : $amount unités';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Multiplicateur de qualité : ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Sortie de mise à niveau - Coût : $cost €, Sortie suivante : $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Qualité de mise à niveau - Coût : $cost €, Qualité suivante : ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Coût';

  @override
  String get factoryCurrentOutput => 'Sortie actuelle';

  @override
  String get factoryNextOutput => 'Sortie suivante';

  @override
  String get factoryCurrentQuality => 'Qualité actuelle';

  @override
  String get factoryNextQuality => 'Qualité suivante';

  @override
  String get factoryUnitsPerCycle => 'unités/8h maximum';

  @override
  String get factoryUnitsPerHour => 'unités/heure';

  @override
  String get factoryUpgradeMaxLevel => 'L\'usine est au niveau maximum';

  @override
  String get countryUsa => 'USA';

  @override
  String get countryMexico => 'Mexique';

  @override
  String get countryColombia => 'Colombie';

  @override
  String get countryBrazil => 'Brésil';

  @override
  String get countryArgentina => 'Argentine';

  @override
  String get countryJapan => 'Japon';

  @override
  String get countryChina => 'Chine';

  @override
  String get countryRussia => 'Russie';

  @override
  String get countryIndia => 'Inde';

  @override
  String get countryAustralia => 'Australie';

  @override
  String get countrySouthAfrica => 'Afrique du Sud';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Irlande';

  @override
  String get countryLuxembourg => 'Luxembourg';

  @override
  String get countryAustria => 'Autriche';

  @override
  String get countryDenmark => 'Danemark';

  @override
  String get countrySweden => 'Suède';

  @override
  String get countryNorway => 'Norvège';

  @override
  String get countryFinland => 'Finlande';

  @override
  String get countryPoland => 'Pologne';

  @override
  String get countryCzechia => 'Tchéquie';

  @override
  String get countryGreece => 'Grèce';

  @override
  String get countryTurkey => 'Turquie';

  @override
  String get countryUae => 'Émirats arabes unis';

  @override
  String get countryDubai => 'Dubaï';

  @override
  String get toolBoltCutter => 'Coupe-boulon';

  @override
  String get toolCarTheftTools => 'Outils de vol de voiture';

  @override
  String get toolBurglaryKit => 'Kit anti-effraction';

  @override
  String get toolToolbox => 'Boîte à outils';

  @override
  String get toolCrowbar => 'Pied de biche';

  @override
  String get toolGlassCutter => 'Coupe-verre';

  @override
  String get toolSprayPaint => 'Peinture en aérosol';

  @override
  String get toolJerryCan => 'Jerry peut';

  @override
  String get toolFakeDocuments => 'Faux documents';

  @override
  String get toolHackingLaptop => 'Piratage d\'un ordinateur portable';

  @override
  String get toolCounterfeitingKit => 'Kit de contrefaçon';

  @override
  String get toolRope => 'Corde';

  @override
  String get toolSilencer => 'Silencieux';

  @override
  String get toolNightVision => 'Vision nocturne';

  @override
  String get toolGpsJammer => 'Brouilleur GPS';

  @override
  String get toolBurnerPhone => 'Téléphone graveur';

  @override
  String get toolThermalDrill => 'Perceuse thermique';

  @override
  String get toolCategoryBoltCutter => 'Coupe-boulons';

  @override
  String get toolCategoryBurglaryKit => 'Kit anti-effraction';

  @override
  String get toolCategoryCarTools => 'Outils de vol de voiture';

  @override
  String get toolCategoryJerryCan => 'Jerry peut';

  @override
  String get toolCategorySprayPaint => 'Peinture en aérosol';

  @override
  String get toolCategoryCrowbar => 'Pied de biche';

  @override
  String get toolCategoryGlassCutter => 'Coupe-verre';

  @override
  String get toolCategoryLaptop => 'Ordinateur portable';

  @override
  String get toolCategoryCounterfeiting => 'Contrefaçon';

  @override
  String get toolCategoryToolbox => 'Boîte à outils';

  @override
  String get toolCategoryRope => 'Corde';

  @override
  String get toolCategorySilencer => 'Silencieux';

  @override
  String get toolCategoryFakeDocs => 'Faux documents';

  @override
  String get toolCategoryNightVision => 'Vision nocturne';

  @override
  String get toolCategoryBurnerPhone => 'Téléphone graveur';

  @override
  String get toolCategoryGpsJammer => 'Brouilleur GPS';

  @override
  String get toolCategoryThermalDrill => 'Foreuse thermique';

  @override
  String get toolsScreenTitle => 'Marché noir – Outils';

  @override
  String get toolsTabBuy => 'Acheter';

  @override
  String get toolsTabMyTools => 'Mes outils';

  @override
  String get toolsNoToolsAvailable => 'Aucun outil disponible';

  @override
  String get toolsEmptyInventoryTitle => 'Vous n\'avez pas encore d\'outils';

  @override
  String get toolsEmptyInventoryHint => 'Acheter des outils dans la boutique';

  @override
  String get toolsNotEnoughMoney => 'Vous n\'avez pas assez d\'argent !';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'Vous n\'avez pas assez d\'argent pour réparer !';

  @override
  String get toolsBuyError => 'Erreur lors de l\'achat';

  @override
  String get toolsRepairError => 'Erreur lors de la réparation';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName acheté !';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName réparé pour $cost€';
  }

  @override
  String get toolsBadgeInventoryFull => 'COMPLÈTE';

  @override
  String get toolsBadgeBroken => 'CASSÉE';

  @override
  String get toolsBadgeRepair => 'RÉPARATION';

  @override
  String toolsLoadError(String error) {
    return 'Impossible de charger les outils : $error';
  }

  @override
  String get toolsErrToolNotFound => 'Outil introuvable.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Votre inventaire est plein. Stockez des outils ou améliorez la capacité.';

  @override
  String get toolsErrPurchaseServer =>
      'L\'achat de l\'outil a échoué en raison d\'un problème de serveur.';

  @override
  String get toolsErrToolNotOwned => 'Vous ne possédez pas cet outil.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'L\'outil a déjà atteint sa durabilité maximale.';

  @override
  String get toolsErrRepairServer =>
      'La réparation de l\'outil a échoué en raison d\'un problème de serveur.';

  @override
  String toolsNetworkError(String error) {
    return 'Erreur réseau : $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Crime réussi !';

  @override
  String get crimeOutcomeCaught => 'Arrêté par la police';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Votre véhicule est en panne avant d\'arriver sur les lieux du crime';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Le véhicule est tombé en panne lors d\'une évasion - la plupart du butin a été abandonné';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Manque de carburant lors de l\'évasion - fuite à pied, perte du butin et du véhicule';

  @override
  String get crimeOutcomeToolBroke =>
      'Votre outil s\'est cassé pendant le crime, laissant des preuves';

  @override
  String get crimeOutcomeFledNoLoot => 'J\'ai fui les lieux sans butin';

  @override
  String get crimeResultMoneyLabel => 'Argent';

  @override
  String get crimeResultXpLabel => 'XP';

  @override
  String get crimeOutcomeRowReward => 'Récompense:';

  @override
  String get crimeOutcomeRowXp => 'XP :';

  @override
  String get crimeOutcomeRowTools => 'Outils:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% de durabilité';
  }

  @override
  String get icuIntensiveCareTitle => 'Soins intensifs';

  @override
  String get icuInjuredLine =>
      'Vous avez été grièvement blessé lors de vos activités criminelles.';

  @override
  String get icuUnconsciousLine =>
      'Vous êtes désormais aux soins intensifs et inconscient.';

  @override
  String get icuRecoveryTimeLabel => 'Temps de récupération :';

  @override
  String get icuWakeHp => 'Tu te réveilles avec 10 HP';

  @override
  String get icuNoActionsHint =>
      'Vous ne pouvez pas effectuer d\'actions pendant cette période. \nSoyez plus prudent avec votre santé !';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Vous êtes libre ! Caution payée : $amount€';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Pas assez d\'argent pour la caution (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Veuillez patienter : ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => 'Évasion réussie ! Vous êtes libre.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'L\'évasion a échoué. Phrase prolongée de $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'L\'évasion a échoué';

  @override
  String jailErrorPrefix(String message) {
    return 'Erreur : $message';
  }

  @override
  String get jailTimeLeft => 'Temps restant';

  @override
  String jailPayBail(int amount) {
    return 'Payer une caution (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Vous ne pouvez pas commettre de crimes, travailler ou voyager pendant que vous purgez votre peine.';

  @override
  String get jailAttemptEscape => 'Tentative d\'évasion';

  @override
  String get jailYouAreInJail => 'Tu es en prison';

  @override
  String get vehicleCondition => 'Condition';

  @override
  String get vehicleFuel => 'Carburant';

  @override
  String get vehicleSpeed => 'Vitesse';

  @override
  String get vehicleArmor => 'Armure';

  @override
  String get vehicleStealth => 'Furtivité';

  @override
  String get vehicleCargo => 'Cargaison';

  @override
  String get vehicleRepair => 'Réparation';

  @override
  String get vehicleRefuel => 'Ravitailler';

  @override
  String get selectCrimeVehicle => 'Sélectionnez le véhicule pour les crimes';

  @override
  String get noVehicleSelected => 'Aucun véhicule sélectionné';

  @override
  String get selectedVehicle => 'Véhicule criminel';

  @override
  String get changeVehicle => 'Changer de véhicule';

  @override
  String get selectVehicle => 'Sélectionnez un véhicule';

  @override
  String get vehicleConditionLow => 'État du véhicule faible';

  @override
  String get vehicleFuelLow => 'Carburant du véhicule faible';

  @override
  String get vehicleSelectedForCrimes =>
      'Véhicule sélectionné pour des crimes !';

  @override
  String get vehicleDeselectedForCrimes =>
      'Véhicule désélectionné pour crimes !';

  @override
  String get vehicleWrongCountry =>
      'Le véhicule doit être dans le même pays que vous';

  @override
  String get failedSelectVehicle => 'Échec de la sélection du véhicule';

  @override
  String get failedDeselectVehicle => 'Échec de la désélection du véhicule';

  @override
  String get selectedForCrimesBadge => 'Sélectionné pour des crimes';

  @override
  String get selectedButton => 'Choisie';

  @override
  String get selectButton => 'Sélectionner';

  @override
  String get deselectButton => 'Désélectionner';

  @override
  String get prostitutionTitle => 'Prostitution';

  @override
  String get prostitutionTotal => 'Totale';

  @override
  String get prostitutionStreet => 'Dans la rue';

  @override
  String get prostitutionRedLight => 'Lumière rouge';

  @override
  String get prostitutionPotentialEarnings => 'Gains';

  @override
  String get prostitutionCollect => 'Collecter';

  @override
  String get prostitutionRecruit => 'Recruter';

  @override
  String get prostitutionMyProstitutes => 'Mes prostituées';

  @override
  String get prostitutionRedLightDistricts => 'Quartiers rouges';

  @override
  String get prostitutionNoProstitutes =>
      'Aucune prostituée recrutée pour l\'instant';

  @override
  String get prostitutionLocation => 'Emplacement';

  @override
  String get prostitutionMoveToRedLight => 'Aller au quartier rouge';

  @override
  String get prostitutionMoveToRldShort => 'Vers RLD';

  @override
  String get prostitutionMoveToStreet => 'Déplacer vers la rue';

  @override
  String get prostitutionViewDistricts => 'Voir les quartiers';

  @override
  String get prostitutionAvailable => 'Disponible';

  @override
  String get prostitutionMyDistricts => 'Mes quartiers';

  @override
  String get prostitutionCurrentRLD => 'RLD actuel';

  @override
  String get prostitutionMyRLDs => 'Mes RLD';

  @override
  String get prostitutionNoAvailableDistricts => 'Aucun quartier disponible';

  @override
  String get prostitutionNoOwnedDistricts =>
      'Vous ne possédez pas encore de quartiers';

  @override
  String get prostitutionRooms => 'chambres';

  @override
  String get prostitutionOccupancy => 'Occupation';

  @override
  String get prostitutionIncome => 'Revenu';

  @override
  String get prostitutionTenants => 'Locataires';

  @override
  String get prostitutionBuy => 'Acheter';

  @override
  String get prostitutionManage => 'Gérer';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Acheter Quartier';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Etes-vous sûr de vouloir acheter le Quartier Rouge à $country pour $price€ ?';
  }

  @override
  String get prostitutionPurchase => 'Acheter';

  @override
  String get prostitutionPurchaseSuccess => 'Quartier acheté avec succès !';

  @override
  String get prostitutionPurchaseFailed => 'L\'achat a échoué';

  @override
  String get prostitutionDistrictManagement => 'Gestion de district';

  @override
  String get prostitutionDistrictNotFound => 'Quartier introuvable';

  @override
  String get prostitutionDistrictOwnedBadge => 'Possédée';

  @override
  String get prostitutionOwnerLabel => 'Propriétaire:';

  @override
  String get prostitutionForSale => 'À vendre';

  @override
  String get prostitutionRoomsLabel => 'Chambres :';

  @override
  String get prostitutionRoomsRented => 'loué';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Quartier rouge ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Occupée';

  @override
  String get prostitutionNotApplicable => 'N / A';

  @override
  String get back => 'Dos';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Êtes-vous sûr de vouloir déplacer le $name du quartier rouge vers la rue ?';
  }

  @override
  String get prostitutionMoveSuccess => 'Déplacement réussi';

  @override
  String get prostitutionMoveFailed => 'Le déplacement a échoué';

  @override
  String get prostitutionNoStreetProstitutes =>
      'Aucune prostituée disponible dans la rue';

  @override
  String get prostitutionSelectProstitute => 'Sélectionnez une prostituée';

  @override
  String get prostitutionOnStreet => 'Dans la rue';

  @override
  String get prostitutionRoom => 'Chambre';

  @override
  String get prostitutionInRedLight => 'Dans le quartier rouge';

  @override
  String get prostitutionEarnings => 'Gains';

  @override
  String get prostitutionRent => 'Louer';

  @override
  String get prostitutionNetIncome => 'Revenu net';

  @override
  String get prostitutionLevel => 'Niveau';

  @override
  String get prostitutionXpToNext => 'XP au niveau suivant';

  @override
  String get prostitutionBusted => 'CASSÉE';

  @override
  String get prostitutionBustedCount => 'Des temps brisés';

  @override
  String get prostitutionLevelBonus => 'Bonus de niveau';

  @override
  String get prostitutionVipBonus => 'Bonus VIP : +50% de gains';

  @override
  String get prostitutionUpgradeTier => 'Niveau de mise à niveau';

  @override
  String get prostitutionUpgradeSecurity => 'Mettre à niveau la sécurité';

  @override
  String get prostitutionTier => 'Étage';

  @override
  String get prostitutionSecurity => 'Sécurité';

  @override
  String get prostitutionTierBasic => 'Basique';

  @override
  String get prostitutionTierLuxury => 'Luxe';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Niveau de sécurité';

  @override
  String get prostitutionRaidChance => 'Chances de raid';

  @override
  String get prostitutionMaxTier => 'Niveau maximum atteint';

  @override
  String get prostitutionMaxSecurity => 'Sécurité maximale atteinte';

  @override
  String get prostitutionUpgradeSuccess => 'Mise à niveau réussie !';

  @override
  String get prostitutionUpgradeFailed => 'La mise à niveau a échoué';

  @override
  String get vipEventsTitle => 'Événements VIP';

  @override
  String get vipEventsTabTitle => 'Événements VIP';

  @override
  String get vipEventsDescription =>
      'Assignez des prostituées à des événements VIP pour gagner des bonus !';

  @override
  String get vipEventsActive => 'Événements actifs';

  @override
  String get vipEventsUpcoming => 'Événements à venir';

  @override
  String get vipEventsMyParticipations => 'Mes participations actives';

  @override
  String get vipEventTypeTitle => 'Événement VIP';

  @override
  String get vipEventCelebrity => 'Visite de célébrité';

  @override
  String get vipEventBachelor => 'Enterrement de vie de garçon';

  @override
  String get vipEventConvention => 'Convention';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'PRIME';

  @override
  String get vipEventSpots => 'taches';

  @override
  String get vipEventParticipants => 'Participantes';

  @override
  String get vipEventFull => 'ÉVÉNEMENT COMPLET';

  @override
  String get vipEventRequires => 'Nécessite';

  @override
  String get vipEventLevel => 'Niveau';

  @override
  String get vipEventLocation => 'Emplacement';

  @override
  String get vipEventEndsIn => 'Se termine dans';

  @override
  String get vipEventStartsIn => 'Commence dans';

  @override
  String get vipEventNoActive => 'Aucun événement actif pour le moment';

  @override
  String get vipEventNoUpcoming => 'Aucun événement à venir';

  @override
  String get vipEventAssignProstitute => 'Attribuer une prostituée';

  @override
  String get vipEventAssignDialogTitle => 'Attribuer à';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Aucune prostituée éligible. Besoin du niveau $level+ en $country';
  }

  @override
  String get vipEventJoinSuccess => 'Événement rejoint !';

  @override
  String get vipEventJoinFailed => 'Impossible de rejoindre l\'événement';

  @override
  String get vipEventLeave => 'Quitter l\'événement';

  @override
  String get vipEventLeaveSuccess => 'Événement gauche';

  @override
  String get vipEventLeaveFailed => 'Impossible de quitter l\'événement';

  @override
  String get vipEventAssigned => 'Attribué';

  @override
  String get vipEventPerHour => '/heure';

  @override
  String get vipEventEarnings => 'Gains';

  @override
  String get prostitutionLeaderboardTitle => 'Classement de la prostitution';

  @override
  String get prostitutionLeaderboardWeekly => 'Hebdomadaire';

  @override
  String get prostitutionLeaderboardMonthly => 'Mensuelle';

  @override
  String get prostitutionLeaderboardAllTime => 'De tous les temps';

  @override
  String get prostitutionLeaderboardYourRank => 'Votre classement hebdomadaire';

  @override
  String get prostitutionLeaderboardUnranked => 'Non classé';

  @override
  String get prostitutionLeaderboardNoData =>
      'Aucune donnée de classement pour l\'instant';

  @override
  String get prostitutionLeaderboardButton => 'Classement';

  @override
  String get prostitutionRivalryButton => 'Rivalité';

  @override
  String get prostitutionLeaderboardAchievements => 'Réalisations';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'Impossible de charger le classement';

  @override
  String get achievementsTitle => 'Réalisations';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked sur $total débloqué';
  }

  @override
  String get achievementsCategoryAll => 'Toute';

  @override
  String get achievementsCategoryProgression => 'Progression';

  @override
  String get achievementsCategoryWealth => 'Richesse';

  @override
  String get achievementsCategoryPower => 'Pouvoir';

  @override
  String get achievementsCategorySocial => 'Sociale';

  @override
  String get achievementsCategoryMastery => 'Maîtrise';

  @override
  String get achievementLocked => 'Fermée';

  @override
  String get achievementReward => 'Récompense';

  @override
  String get achievementUnlocked => 'Débloqué';

  @override
  String get achievementNoData => 'Aucune réalisation trouvée';

  @override
  String get achievementLoadFailed => 'Impossible de charger les réalisations';

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
    return 'Débloqué le $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Progression : $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Aucune récompense configurée pour le moment';

  @override
  String get achievementsRewardOnUnlock =>
      'Vous recevez cette récompense une fois le succès débloqué.';

  @override
  String get achievementsDateToday => 'Aujourd\'hui';

  @override
  String get achievementsDateYesterday => 'Hier';

  @override
  String achievementsDateDaysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String get achievementsDetails => 'Détails';

  @override
  String get achievementsCategory => 'Catégorie';

  @override
  String get achievementsSectionProgress => 'Progrès';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent % terminé';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostitution';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Crimes';

  @override
  String get achievementsCategoryNameJobs => 'Emplois';

  @override
  String get achievementsCategoryNameSchool => 'École';

  @override
  String get achievementsCategoryNameVehicles => 'Véhicules';

  @override
  String get achievementsCategoryNameTravel => 'Voyages';

  @override
  String get achievementsCategoryNameDrugs => 'Drogue';

  @override
  String get achievementsCategoryNameTrade => 'Commerce';

  @override
  String get achievementsCategoryNameGeneral => 'Général';

  @override
  String get achievementJobItSpecialistTitle => 'Spécialiste informatique';

  @override
  String get achievementJobItSpecialistDescription =>
      'Terminez votre premier quart de travail en tant que programmeur';

  @override
  String get achievementJobLawyerTitle => 'Avocat de rue';

  @override
  String get achievementJobLawyerDescription =>
      'Complétez votre premier quart de travail en tant qu\'avocat';

  @override
  String get achievementJobDoctorTitle => 'Docteur souterrain';

  @override
  String get achievementJobDoctorDescription =>
      'Terminez votre premier quart de travail en tant que médecin';

  @override
  String get achievementSchoolCertifiedTitle => 'Étudiant certifié';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Gagnez 3 certifications scolaires';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multi-certifié';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Gagnez 6 certifications scolaires';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Spécialiste de la piste';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Maximisez 3 pistes scolaires';

  @override
  String get schoolMenuLabel => 'École';

  @override
  String get schoolMenuSubtitle =>
      'Améliorez votre formation et vos certifications';

  @override
  String get schoolTitle => 'École et éducation';

  @override
  String get schoolIntro =>
      'Débloquez des emplois et des atouts grâce à des niveaux et des certifications.';

  @override
  String get schoolTracksTitle => 'Formations disponibles';

  @override
  String get schoolUnlockableContentTitle => 'Des formations verrouillées';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Niveau scolaire : $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Impossible de charger les données de l\'école : $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Niv $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'XP : $xp';
  }

  @override
  String schoolCertificationRequiredLevel(String name, int level) {
    return '$name (Niv $level)';
  }

  @override
  String get schoolGateStatusOpen => 'OUVRIR';

  @override
  String get schoolGateStatusLocked => 'FERMÉE';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Rang du joueur : $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return 'Niveau $track : $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Emploi : $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Atout : Achat de casino';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Atout : achat d\'usine de munitions';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Atout : mise à niveau de la sortie de munitions';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Atout : amélioration de la qualité des munitions';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Atout : mise à niveau de l\'emplacement d\'un établissement pharmaceutique I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Atout : Mise à niveau II de l\'emplacement de l\'établissement pharmaceutique';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Atout : mise à niveau de l\'emplacement de l\'établissement pharmaceutique III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Atout : mise à niveau de l\'emplacement de l\'établissement pharmaceutique IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Atout : Mise à niveau de l\'équipement d\'un établissement pharmaceutique I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Atout : Mise à niveau de l\'équipement des installations pharmaceutiques II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Atout : Mise à niveau de l\'équipement des installations pharmaceutiques III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Actif : $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type : $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Éducation requise';

  @override
  String get educationDialogFallbackMessage =>
      'Exigences non remplies. Remplissez les exigences de formation pour continuer.';

  @override
  String get educationDialogClose => 'Fermer';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Emplois verrouillés (formation requise)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Mise à niveau de sortie verrouillée';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Amélioration de la qualité verrouillée';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Achat d\'usine verrouillé';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Besoin du rang du joueur $requiredRank · Classement actuel du joueur $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Niveau d\'éducation';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName niveau $requiredLevel requis · Actuel $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle => 'Certification requise';

  @override
  String get educationRequirementGenericTitle => 'Exigence';

  @override
  String get educationRequirementUnknown => 'Exigence inconnue';

  @override
  String get educationTrackNameAviation => 'Aviation';

  @override
  String get educationTrackNameLaw => 'Loi';

  @override
  String get educationTrackNameMedicine => 'Médecine';

  @override
  String get educationTrackNameFinance => 'Finance';

  @override
  String get educationTrackNameEngineering => 'Ingénierie';

  @override
  String get educationTrackNameIt => 'IL';

  @override
  String get educationTrackNameNarcotics => 'Ingénierie des stupéfiants';

  @override
  String get schoolTrackDescriptionAviation =>
      'Théorie du vol, navigation et exploitation des aéronefs.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Droit pénal, procédure et pratique judiciaire.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Intervention d\'urgence, diagnostic et pratique médicale.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Comptabilité, investissement et opérations commerciales.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Systèmes mécaniques, sécurité industrielle et fabrication.';

  @override
  String get schoolTrackDescriptionIt =>
      'Développement de logiciels, systèmes et opérations réseau.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Culture contrôlée, processus électriques et production chimique avancée.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Temps de recharge actif : ${seconds}s restants';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'La piste est déjà au niveau maximum';

  @override
  String get schoolTrackStartFailed => 'Échec du démarrage de la formation';

  @override
  String get educationCertHydroponicSpecialist =>
      'Certification de spécialiste en culture hydroponique';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Certification de spécialiste en électricité de procédés';

  @override
  String get educationCertClandestineChemist =>
      'Certification de chimiste clandestin';

  @override
  String get educationCertNarcoGridArchitect =>
      'Certification d\'architecte de réseau Narco';

  @override
  String get educationCertSoftwareEngineer =>
      'Certification d\'ingénieur logiciel';

  @override
  String get educationCertBarExam => 'Examen du Barreau';

  @override
  String get educationCertMedicalLicense => 'Licence médicale';

  @override
  String get educationCertFlightCommercial => 'Licence de vol commercial';

  @override
  String get educationCertFlightBasic => 'Licence de vol de base';

  @override
  String get educationCertIndustrialSafety =>
      'Certification de sécurité industrielle';

  @override
  String get educationCertFinancialAnalyst =>
      'Certification d\'analyste financier';

  @override
  String get educationCertCasinoManagement =>
      'Certification en gestion de casino';

  @override
  String get educationCertParamedic => 'Certification paramédicale';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostituées';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'quartiers';

  @override
  String get rivalryTitle => 'Rivalité';

  @override
  String get rivalryChallengeTitle => 'Joueur de défi';

  @override
  String get rivalryChallengeHint =>
      'Entrez un identifiant de joueur pour démarrer une rivalité.';

  @override
  String get rivalryPlayerIdHint => 'Identifiant du joueur';

  @override
  String get rivalryStartButton => 'Commencer';

  @override
  String get rivalryNoActive => 'Aucune rivalité active pour l’instant.';

  @override
  String get rivalryActiveTitle => 'Rivaux actifs';

  @override
  String get rivalryScoreLabel => 'Score de rivalité';

  @override
  String get rivalryRecentActivity => 'Activité récente';

  @override
  String get rivalryNoActivity => 'Aucune activité de sabotage pour l\'instant';

  @override
  String get rivalryCooldownReady => 'Prêt pour le sabotage';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Temps de recharge : $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Pourboire à la police (5 000 €)';

  @override
  String get rivalryActionStealCustomer => 'Voler un client (3 000 €)';

  @override
  String get rivalryActionDamageReputation =>
      'Dommages à la réputation (10 000 €)';

  @override
  String get rivalryActionBribeEmployee => 'Pot-de-vin à un employé (8 000 €)';

  @override
  String get rivalryUpdateMessage => 'Rivalité mise à jour';

  @override
  String get rivalrySabotageExecuted => 'Sabotage exécuté';

  @override
  String get rivalryConfirmTitle => 'Confirmer le sabotage';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Cible : $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Action : $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Coût : $amount€';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Effet : $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Le succès n’est pas garanti et vous pouvez perdre de l’argent.';

  @override
  String get rivalryExecuteButton => 'Exécuter';

  @override
  String get rivalryEffectTipPolice => 'Augmenter la pression policière rivale';

  @override
  String get rivalryEffectStealCustomer =>
      'Voler une partie des liquidités du rival';

  @override
  String get rivalryEffectDamageReputation =>
      'Diminution des progrès des prostituées rivales';

  @override
  String get rivalryEffectBribeEmployee =>
      'Forcer une prostituée rivale à se retrouver en faillite';

  @override
  String get prostitutionUnderAttackTitle => 'Votre empire est attaqué';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker a utilisé $action contre vous au cours des dernières 24h.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Rivalité ouverte';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      'Trahison ! Votre boîte de nuit a été touchée par une fuite d\'informations.';

  @override
  String get prostitutionLoadError => 'Erreur lors du chargement des données';

  @override
  String get prostitutionNoDistrictInCountry =>
      'Pas de quartier rouge dans ce pays';

  @override
  String get prostitutionMovedToStreet => 'Déplacée dans la rue';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Cette prostituée est arrêtée et ne peut pas être assignée.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Vous n\'avez pas encore de lieu de boîte de nuit pour assigner du personnel.';

  @override
  String get prostitutionNightclubVenueName => 'Boîte de nuit';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Boîte de nuit n°$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Assignée à la boîte de nuit';

  @override
  String get prostitutionArrestedCannotWork =>
      'Cette prostituée est arrêtée et ne peut pas travailler.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Encore $duration de repos avant le prochain service.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Service terminé';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Aucune prostituée disponible à envoyer au travail.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostituées envoyées au travail.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success envoyées au travail, $failed échecs.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Recrutée !';

  @override
  String get prostitutionRecruitFailed => 'Échec du recrutement';

  @override
  String get prostitutionRecruitConnectionError =>
      'Échec du recrutement suite à une erreur de connexion';

  @override
  String get prostitutionEventUpdate => 'Événement mis à jour';

  @override
  String get prostitutionBuyPropertyFirst =>
      'Achetez d\'abord une maison ou un appartement';

  @override
  String prostitutionWorkAll(int count) {
    return 'Tout envoyer travailler ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Pas de place de logement libre. Achetez ou améliorez une maison ou un appartement avant de recruter d\'autres prostituées.';

  @override
  String get prostitutionHousingTitle => 'Logement';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Chaque prostituée doit effectuer au moins un service tous les $days jours pour payer le loyer.';
  }

  @override
  String get prostitutionHousingSlots => 'Places';

  @override
  String get prostitutionHousingFree => 'Libre';

  @override
  String get prostitutionHousingHomes => 'Logements';

  @override
  String get prostitutionHousingAvgUpgrade => 'Amélio. moy.';

  @override
  String get prostitutionHousingHappinessBonus => 'Bonus bonheur';

  @override
  String get prostitutionHousingWeeklyRent => 'Loyer hebdo';

  @override
  String get prostitutionHousingAtRisk => 'À risque';

  @override
  String get prostitutionHousingSafe => 'Sûr';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Trahison déclenchée : $grams g de drogue saisie(s), $licenses licence(s) de boîte de nuit révoquée(s).';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Aperçu des revenus (prostituées actives)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Rue : $count • €$euros/h';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'Quartier rouge : $count • €$euros/h';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Boîte de nuit : $count • €$euros/h';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Total : €$euros/h';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Extatique';

  @override
  String get prostitutionHappinessHappy => 'Heureux';

  @override
  String get prostitutionHappinessStable => 'Écurie';

  @override
  String get prostitutionHappinessStressed => 'Stressé';

  @override
  String get prostitutionHappinessMiserable => 'Misérable';

  @override
  String get prostitutionHousingExpired => 'Expiré';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'encore $days j.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Moins d\'un jour';

  @override
  String get prostitutionNightclubShort => 'Club';

  @override
  String get prostitutionMoveToStreetButton => 'Vers la rue';

  @override
  String get prostitutionMoveToNightclubButton => 'Vers le club';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/h';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Bonheur $label ($score%) • Rendement $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Logement : $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Loyer hebdo €$amount';
  }

  @override
  String get prostitutionWork8h => 'Travailler 8 h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Repos $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Prochain service dans $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get rivalryProtectionTitle => 'Assurance protection';

  @override
  String get rivalryProtectionDescription =>
      'Réduit l\'impact des sabotages entrants de 30 % pendant 7 jours.';

  @override
  String get rivalryProtectionInactive => 'Aucune protection active';

  @override
  String rivalryProtectionActive(String date) {
    return 'Actif jusqu\'à : $date';
  }

  @override
  String get rivalryProtectionBuy => 'Acheter une protection (25k€/semaine)';

  @override
  String get rivalryProtectionActivated => 'Assurance protection activée';

  @override
  String get achievementTitle_first_steps => 'Premiers pas';

  @override
  String get achievementDescription_first_steps =>
      'Recrutez votre première prostituée';

  @override
  String get achievementTitle_growing_empire => 'Empire grandissant';

  @override
  String get achievementDescription_growing_empire => 'Recruter 5 prostituées';

  @override
  String get achievementTitle_first_district => 'Premier District';

  @override
  String get achievementDescription_first_district =>
      'Achetez votre premier quartier rouge';

  @override
  String get achievementTitle_empire_builder => 'Bâtisseur d\'Empire';

  @override
  String get achievementDescription_empire_builder =>
      'Posséder 5 quartiers rouges';

  @override
  String get achievementTitle_district_master => 'Maître de District';

  @override
  String get achievementDescription_district_master =>
      'Posséder 10 quartiers rouges';

  @override
  String get achievementTitle_leveling_master => 'Maître de mise à niveau';

  @override
  String get achievementDescription_leveling_master =>
      'Maximisez une prostituée au niveau 10';

  @override
  String get achievementTitle_untouchable => 'Intouchable';

  @override
  String get achievementDescription_untouchable =>
      'Ne vous laissez jamais arrêter pendant 7 jours consécutifs';

  @override
  String get achievementTitle_millionaire => 'Millionnaire';

  @override
  String get achievementDescription_millionaire =>
      'Accumulez 1 000 000 € de gains totaux';

  @override
  String get achievementTitle_high_roller => 'Gros rouleau';

  @override
  String get achievementDescription_high_roller =>
      'Accumulez 5 000 000 € de gains totaux';

  @override
  String get achievementTitle_vip_service => 'Service VIP';

  @override
  String get achievementDescription_vip_service => 'Terminez 10 événements VIP';

  @override
  String get achievementTitle_event_enthusiast => 'Passionné d\'événements';

  @override
  String get achievementDescription_event_enthusiast =>
      'Terminez 25 événements VIP';

  @override
  String get achievementTitle_security_expert => 'Expert en sécurité';

  @override
  String get achievementDescription_security_expert =>
      'Maximiser le niveau de sécurité sur tous les districts possédés';

  @override
  String get achievementTitle_luxury_provider => 'Fournisseur de luxe';

  @override
  String get achievementDescription_luxury_provider =>
      'Améliorez 3 districts au niveau VIP';

  @override
  String get achievementTitle_rivalry_victor => 'Rivalité Victor';

  @override
  String get achievementDescription_rivalry_victor =>
      'Saboter vos rivaux avec succès 10 fois';

  @override
  String get achievementTitle_untouchable_rival => 'Rival intouchable';

  @override
  String get achievementDescription_untouchable_rival =>
      'Se défendre contre 20 tentatives de sabotage';

  @override
  String get achievementTitle_crime_first_blood => 'Crime Premier Sang';

  @override
  String get achievementDescription_crime_first_blood =>
      'Réussissez votre premier crime';

  @override
  String get achievementTitle_crime_hustler => 'arnaqueur de crime';

  @override
  String get achievementDescription_crime_hustler => 'Réussissez 5 crimes';

  @override
  String get achievementTitle_crime_novice =>
      'Débutant en matière de criminalité';

  @override
  String get achievementDescription_crime_novice => 'Réussissez 10 crimes';

  @override
  String get achievementTitle_crime_operator => 'Opérateur du crime';

  @override
  String get achievementDescription_crime_operator => 'Réussissez 25 crimes';

  @override
  String get achievementTitle_crime_wave => 'Vague de criminalité';

  @override
  String get achievementDescription_crime_wave => 'Réussissez 50 crimes';

  @override
  String get achievementTitle_crime_mastermind => 'Cerveau du crime';

  @override
  String get achievementDescription_crime_mastermind => 'Réussissez 100 crimes';

  @override
  String get achievementTitle_the_godfather => 'Le parrain';

  @override
  String get achievementDescription_the_godfather => 'Réussissez 250 crimes';

  @override
  String get achievementTitle_crime_emperor => 'Empereur du crime';

  @override
  String get achievementDescription_crime_emperor => 'Réussissez 500 crimes';

  @override
  String get achievementTitle_crime_legend => 'Légende du crime';

  @override
  String get achievementDescription_crime_legend => 'Réussissez 1 000 crimes';

  @override
  String get achievementTitle_crime_getaway_driver => 'Chauffeur d\'escapade';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Réussissez votre premier crime avec un véhicule';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Armé et prêt';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Réussissez votre premier crime nécessitant une arme';

  @override
  String get achievementTitle_crime_full_loadout => 'Chargement complet';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Réussissez un crime nécessitant un véhicule, une arme et des outils';

  @override
  String get achievementTitle_crime_completionist => 'Crime Completionniste';

  @override
  String get achievementDescription_crime_completionist =>
      'Réussir chaque type de crime au moins une fois';

  @override
  String get achievementTitle_job_first_shift => 'Premier quart de travail';

  @override
  String get achievementDescription_job_first_shift =>
      'Réussissez votre premier emploi';

  @override
  String get achievementTitle_job_hustler => 'arnaqueur d\'emploi';

  @override
  String get achievementDescription_job_hustler => 'Réussir 5 tâches';

  @override
  String get achievementTitle_job_starter => 'Démarreur d\'emploi';

  @override
  String get achievementDescription_job_starter => 'Réussir 10 tâches';

  @override
  String get achievementTitle_job_operator => 'Opérateur d\'emploi';

  @override
  String get achievementDescription_job_operator => 'Réussir 25 tâches';

  @override
  String get achievementTitle_job_grinder => 'Broyeur d\'emplois';

  @override
  String get achievementDescription_job_grinder => 'Réussissez 50 tâches';

  @override
  String get achievementTitle_job_master => 'Maître des tâches';

  @override
  String get achievementDescription_job_master => 'Réussir 100 tâches';

  @override
  String get achievementTitle_job_expert => 'Expert en emploi';

  @override
  String get achievementDescription_job_expert => 'Réussissez 250 tâches';

  @override
  String get achievementTitle_job_elite => 'Emploi Élite';

  @override
  String get achievementDescription_job_elite => 'Réussir 500 tâches';

  @override
  String get achievementTitle_job_legend => 'Légende du travail';

  @override
  String get achievementDescription_job_legend => 'Réussir 1 000 tâches';

  @override
  String get achievementTitle_job_completionist => 'Achèvement du travail';

  @override
  String get achievementDescription_job_completionist =>
      'Réussir chaque type de travail au moins une fois';

  @override
  String get achievementTitle_job_educated_worker => 'Travailleur instruit';

  @override
  String get achievementDescription_job_educated_worker =>
      'Terminez 1 emploi qui comporte des exigences en matière de formation';

  @override
  String get achievementTitle_job_certified_hustler => 'arnaqueur certifié';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Terminez 25 emplois avec des exigences de formation';

  @override
  String get achievementTitle_job_education_completionist =>
      'Finisseur d’emplois en éducation';

  @override
  String get achievementDescription_job_education_completionist =>
      'Terminez chaque type d’emploi lié à l’éducation au moins une fois';

  @override
  String get achievementTitle_job_it_specialist => 'Spécialiste informatique';

  @override
  String get achievementDescription_job_it_specialist =>
      'Terminez votre premier quart de travail en tant que programmeur';

  @override
  String get achievementTitle_job_lawyer => 'Avocat de rue';

  @override
  String get achievementDescription_job_lawyer =>
      'Complétez votre premier quart de travail en tant qu\'avocat';

  @override
  String get achievementTitle_job_doctor => 'Docteur souterrain';

  @override
  String get achievementDescription_job_doctor =>
      'Terminez votre premier quart de travail en tant que médecin';

  @override
  String get achievementTitle_school_certified => 'Étudiant certifié';

  @override
  String get achievementDescription_school_certified =>
      'Gagnez 3 certifications scolaires';

  @override
  String get achievementTitle_school_multi_certified => 'Multi-certifié';

  @override
  String get achievementDescription_school_multi_certified =>
      'Gagnez 6 certifications scolaires';

  @override
  String get achievementTitle_school_track_specialist =>
      'Spécialiste de la piste';

  @override
  String get achievementDescription_school_track_specialist =>
      'Maximisez 3 pistes scolaires';

  @override
  String get achievementTitle_school_freshman => 'Étudiant de première année';

  @override
  String get achievementDescription_school_freshman =>
      'Atteindre le niveau d\'éducation 1';

  @override
  String get achievementTitle_school_scholar => 'Érudit scolaire';

  @override
  String get achievementDescription_school_scholar =>
      'Atteindre le niveau d\'éducation 3';

  @override
  String get achievementTitle_school_graduate => 'Diplômé de l\'école';

  @override
  String get achievementDescription_school_graduate =>
      'Atteindre le niveau d\'éducation 5';

  @override
  String get achievementTitle_school_mastermind => 'Cerveau académique';

  @override
  String get achievementDescription_school_mastermind =>
      'Atteindre le niveau d\'éducation 10';

  @override
  String get achievementTitle_school_doctorate => 'Doctorat de rue';

  @override
  String get achievementDescription_school_doctorate =>
      'Atteindre le niveau d\'éducation 20';

  @override
  String get achievementTitle_road_bandit => 'Bandit de la route';

  @override
  String get achievementDescription_road_bandit => 'Voler 5 voitures';

  @override
  String get achievementTitle_grand_theft_fleet => 'Flotte Grand Theft';

  @override
  String get achievementDescription_grand_theft_fleet => 'Voler 25 voitures';

  @override
  String get achievementTitle_sea_raider => 'Pilleur de mer';

  @override
  String get achievementDescription_sea_raider => 'Voler 3 bateaux';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Capitaine des contrebandiers';

  @override
  String get achievementDescription_captain_of_smugglers => 'Voler 12 bateaux';

  @override
  String get achievementTitle_globe_trotter => 'Globe-trotter';

  @override
  String get achievementDescription_globe_trotter => 'Terminez 5 voyages';

  @override
  String get achievementTitle_jet_setter => 'Jet-setteur';

  @override
  String get achievementDescription_jet_setter => 'Terminez 25 voyages';

  @override
  String get achievementTitle_chemist_apprentice => 'Apprenti chimiste';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Terminez 10 productions de médicaments';

  @override
  String get achievementTitle_narco_chemist => 'Chimiste Narco';

  @override
  String get achievementDescription_narco_chemist =>
      'Terminez 100 productions de médicaments';

  @override
  String get achievementTitle_street_merchant => 'Marchand de rue';

  @override
  String get achievementDescription_street_merchant =>
      'Terminez 25 transactions';

  @override
  String get achievementTitle_trade_tycoon => 'Magnat du commerce';

  @override
  String get achievementDescription_trade_tycoon => 'Terminez 150 transactions';

  @override
  String get achievementTitle_prostitute_lineup => 'Programmation construite';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Recruter 10 prostituées';

  @override
  String get achievementTitle_prostitute_network => 'Réseau routier';

  @override
  String get achievementDescription_prostitute_network =>
      'Recruter 25 prostituées';

  @override
  String get achievementTitle_prostitute_syndicate => 'Syndicat';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Recruter 50 prostituées';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dynastie';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Recruter 100 prostituées';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Empire 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recruter 250 prostituées';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Cartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recruter 500 prostituées';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Légende 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recruter 1000 prostituées';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP Débutant';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Atteignez le niveau 3 avec une prostituée VIP';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'Tête d\'affiche VIP';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Atteignez le niveau 5 avec une prostituée VIP';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'Icône VIP';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Atteignez le niveau 7 avec une prostituée VIP';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'Légende VIP';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Atteignez le niveau 10 avec une prostituée VIP';

  @override
  String get achievementTitle_nightclub_opening_night => 'Soirée d\'ouverture';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Ouvrez votre première discothèque';

  @override
  String get achievementTitle_nightclub_headliner =>
      'Réservateur en tête d\'affiche';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Réservez 10 équipes de DJ pour votre empire de discothèques';

  @override
  String get achievementTitle_nightclub_full_house => 'Full house';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Pousser la fréquentation d\'une discothèque à 90 % de sa capacité';

  @override
  String get achievementTitle_nightclub_cash_machine =>
      'Distributeur automatique de billets';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Gagnez 250 000 € de revenus totaux en discothèque';

  @override
  String get achievementTitle_nightclub_empire => 'Empire de la vie nocturne';

  @override
  String get achievementDescription_nightclub_empire =>
      'Gagnez 1 000 000 € de revenus totaux en discothèque';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Chef du personnel';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Dirigez 3 membres actifs de l\'équipe de discothèque en même temps';

  @override
  String get achievementTitle_nightclub_vip_room => 'Salle VIP';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Assignez 2 membres d\'équipage VIP à votre discothèque';

  @override
  String get achievementTitle_nightclub_head_of_security =>
      'Chef de la sécurité';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Embaucher la sécurité d\'une discothèque pour 10 équipes';

  @override
  String get achievementTitle_nightclub_podium_finish =>
      'Arrivée sur le podium';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Terminez dans le top 3 d\'une saison hebdomadaire en boîte de nuit';

  @override
  String get achievementTitle_nightclub_season_champion =>
      'Champion de la saison';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Gagnez une saison hebdomadaire en discothèque';

  @override
  String get nightclubManagementTitle => 'Gestion de discothèque';

  @override
  String get nightclubRealtimeStatus => 'Statut en temps réel actif';

  @override
  String get nightclubRefresh => 'Rafraîchir';

  @override
  String get nightclubEmptyTitle =>
      'Aucune discothèque trouvée pour l\'instant';

  @override
  String get nightclubEmptyBody =>
      'Achetez d\'abord une discothèque dans Propriétés pour activer ce système.';

  @override
  String get nightclubLocationTitle => 'Emplacement de la discothèque';

  @override
  String get nightclubSelectVenue => 'Sélectionnez le lieu';

  @override
  String get nightclubLiveStatistics => 'Statistiques en direct';

  @override
  String get nightclubKpiCrowd => 'Foule';

  @override
  String get nightclubKpiVibe => 'Ambiance';

  @override
  String get nightclubKpiToday => 'Aujourd\'hui';

  @override
  String get nightclubKpiAllTime => 'De tous les temps';

  @override
  String get nightclubKpiStock => 'Action';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Vols';

  @override
  String get nightclubKpiStaff => 'Personnelle';

  @override
  String get nightclubKpiSalesBoost => 'Augmentation des ventes';

  @override
  String get nightclubKpiPriceBoost => 'Augmentation des prix';

  @override
  String get nightclubKpiVipBonus => 'Bonus VIP';

  @override
  String get nightclubStatusActive => 'Active';

  @override
  String get nightclubStatusOff => 'Désactivé';

  @override
  String get nightclubStatusActiveLower => 'active';

  @override
  String get nightclubRevenueTrend => 'Tendance des revenus (en direct)';

  @override
  String get nightclubLeaderboardTitle => 'Meilleures boîtes de nuit';

  @override
  String get nightclubLeaderboardCountry => 'Pays';

  @override
  String get nightclubLeaderboardGlobal => 'Mondiale';

  @override
  String get nightclubLeaderboardEmpty =>
      'Aucune donnée de classement pour l\'instant';

  @override
  String get nightclubLeaderboardRevenue24h => 'Revenus 24h';

  @override
  String get nightclubSeasonProcessing => 'traitement...';

  @override
  String get nightclubSeasonTitle => 'Classement hebdomadaire de la saison';

  @override
  String get nightclubSeasonResetIn => 'Réinitialiser dans';

  @override
  String get nightclubSeasonYourRewards => 'Vos récompenses de saison';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 de la semaine en cours';

  @override
  String get nightclubSeasonEmpty => 'Aucune donnée de saison pour l\'instant';

  @override
  String get nightclubSeasonWeekRevenue => 'Revenu hebdomadaire';

  @override
  String get nightclubSeasonScore => 'Score';

  @override
  String get nightclubSeasonRecentPayouts => 'Paiements récents';

  @override
  String get nightclubSeasonNoPayouts => 'Aucun paiement pour l\'instant';

  @override
  String get nightclubSalesTitle => 'Ventes récentes';

  @override
  String get nightclubSalesEmpty => 'Aucune donnée de vente pour l\'instant';

  @override
  String get nightclubTheftTitle => 'Journal de vol';

  @override
  String get nightclubTheftEmpty => 'Aucun vol enregistré';

  @override
  String get nightclubTheftLoss => 'Perte';

  @override
  String get nightclubStaffTitle => 'L\'équipe de proxénètes dans le club';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 actif)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capacité : $assigned/$cap$vipSuffix';
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
    return 'Boost mix : ventes x$sales | prix x$price | ambiance x$vibe | sécurité x$security | joueur vip x$vipPlayer | personnel vip x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Sélectionner un membre d\'équipage';

  @override
  String get nightclubAssignShift => 'Affecter à l\'équipe de discothèque';

  @override
  String get nightclubTabActive => 'Active';

  @override
  String get nightclubTabHistory => 'Histoire';

  @override
  String get nightclubNoCrewAssigned =>
      'Aucun équipage affecté pour l\'instant';

  @override
  String get nightclubCrewBoostDescription =>
      'Augmente la demande et la marge dans votre club';

  @override
  String get nightclubRemove => 'Retirer';

  @override
  String get nightclubNoStaffHistory =>
      'Aucun historique de dotation pour l\'instant';

  @override
  String get nightclubFrom => 'Depuis';

  @override
  String get nightclubTo => 'À';

  @override
  String get nightclubRevenueImpact => 'Impact sur les revenus';

  @override
  String get nightclubSalesCountLabel => 'ventes';

  @override
  String get nightclubDjTitle => 'Embaucher un DJ';

  @override
  String get nightclubChooseDj => 'Choisissez DJ';

  @override
  String get nightclubShiftLength => 'Durée du quart de travail';

  @override
  String get nightclubHireDj => 'Embaucher un DJ';

  @override
  String get nightclubSecurityTitle => 'Sécurité';

  @override
  String get nightclubChooseSecurity => 'Choisissez la sécurité';

  @override
  String get nightclubHireSecurity => 'Embaucher la sécurité';

  @override
  String get nightclubStoreTitle => 'Conserver les médicaments';

  @override
  String get nightclubChooseStock => 'Choisissez des actions';

  @override
  String get nightclubAmountGrams => 'Quantité en grammes';

  @override
  String get nightclubStoreButton => 'Magasin dans une discothèque';

  @override
  String get nightclubHireDjSuccess => 'DJ embauché';

  @override
  String get nightclubHireSecuritySuccess => 'Sécurité embauchée';

  @override
  String get nightclubAssignCrewSuccess => 'Membre d\'équipage affecté';

  @override
  String get nightclubRemoveCrewSuccess => 'Membre d\'équipage supprimé';

  @override
  String get nightclubStoreDrugsSuccess => 'Médicaments stockés';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Paiement de saison reçu';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Votre discothèque a terminé au rang #$rank cette semaine.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Récompense : $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Revenu hebdomadaire : $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Perte de vol : $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Fermer';

  @override
  String get nightclubVibeChill => 'Froideur';

  @override
  String get nightclubVibeNormal => 'Normale';

  @override
  String get nightclubVibeWild => 'Sauvage';

  @override
  String get nightclubVibeRaging => 'Rage';

  @override
  String get nightclubTheftTypeCustomer => 'Vol de client';

  @override
  String get nightclubTheftTypeEmployee => 'Vol d\'un employé';

  @override
  String get nightclubTheftTypeRival => 'Sabotage rival';

  @override
  String nightclubErrorLoading(String error) {
    return 'Erreur lors du chargement de la discothèque : $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Impossible de charger les statistiques de la discothèque';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'Impossible de charger le classement';

  @override
  String get nightclubServiceErrorSeason =>
      'Impossible de charger le classement de la saison';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Erreur : $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Le contrat du DJ résident a échoué';

  @override
  String get nightclubScheduleEventFailed =>
      'Échec de la planification de l\'événement';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'Échec de la mise à niveau marketing';

  @override
  String get nightclubUpgradeFailed => 'La mise à niveau a échoué';

  @override
  String get nightclubIncidentResponseFailed =>
      'Échec de la réponse à l\'incident';

  @override
  String get nightclubRivalActionFailed => 'L\'action rivale a échoué';

  @override
  String get nightclubSupplierContractFailed => 'Échec du contrat fournisseur';

  @override
  String get nightclubPromoterFailed => 'Le promoteur a échoué';

  @override
  String get nightclubHeatCooldownFailed =>
      'Le refroidissement de la chaleur a échoué';

  @override
  String get nightclubSmugglingFailed => 'La contrebande a échoué';

  @override
  String get nightclubCounterIntelFailed => 'Le contre-renseignement a échoué';

  @override
  String get nightclubHospitalityStockFailed =>
      'Le stock d\'hôtellerie est en panne';

  @override
  String get nightclubHospitalityPricingFailed =>
      'La tarification de l\'hospitalité a échoué';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Visiteurs actuels : $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Pont de commandement de Nightclub';

  @override
  String get nightclubOpsDeckRevenueToday => 'Chiffre d\'affaires aujourd\'hui';

  @override
  String get nightclubStockValueLabel => 'Valeur des actions';

  @override
  String get nightclubCrewOccupancy => 'Occupation de l\'équipage';

  @override
  String get nightclubOperationalRisk => 'Risque opérationnel';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidents (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Changements d\'équipage actifs';

  @override
  String get nightclubRecentCrewHistory => 'Historique récent de l\'équipage';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'STANDARD';

  @override
  String get nightclubActiveDj => 'DJ actif';

  @override
  String get nightclubActiveDjNone => 'DJ actif : aucun';

  @override
  String nightclubUntilTime(String time) {
    return 'jusqu\'à $time';
  }

  @override
  String get nightclubActiveSecurity => 'Sécurité active';

  @override
  String get nightclubActiveSecurityNone => 'Sécurité active : aucune';

  @override
  String get nightclubNoDjsLoaded => 'Aucun DJ chargé. Actualisez l\'écran.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Aucune sécurité chargée. Actualisez l\'écran.';

  @override
  String get nightclubCrowdBoost => 'Augmentation de la foule';

  @override
  String get nightclubCostPerHour => 'Coût';

  @override
  String get nightclubReputationLabel => 'Réputation';

  @override
  String get nightclubSpecialtyLabel => 'Spécialité';

  @override
  String get nightclubTheftReduction => 'Réduction du vol';

  @override
  String get nightclubShiftCost => 'Coût du changement';

  @override
  String get nightclubSelectedStock => 'Choisie';

  @override
  String get nightclubAvailableGrams => 'Disponible';

  @override
  String get nightclubMaxChip => 'MAXIMUM';

  @override
  String get nightclubStoredInNightclub => 'Stocké dans une discothèque';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Stock actuel : ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs =>
      'Aucun médicament stocké pour l’instant.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Le stock actuel est de 0g (tout a été vendu).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Qualité : $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g de bouillon';
  }

  @override
  String get nightclubOperationsLabTitle =>
      'Laboratoire d\'opérations (11 systèmes)';

  @override
  String get nightclubSectionResidentDjContract => '1) Contrat DJ résident';

  @override
  String get nightclubContractDiscount => 'Remise sur contrat';

  @override
  String get nightclubContractDuration => 'Durée du contrat';

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
  String get nightclubStartResidentContract =>
      'Démarrer le contrat de résident';

  @override
  String get nightclubSectionEventCalendar =>
      '2) Calendrier d\'événements dynamique';

  @override
  String get nightclubRecommendedToday => 'Recommandé aujourd\'hui';

  @override
  String get nightclubEventTemplate => 'Modèle d\'événement';

  @override
  String get nightclubScheduleEventFiveMin => 'Planifier l\'événement (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Événements à venir';

  @override
  String get nightclubSectionUpgradeTree => '3) Arbre de mise à niveau';

  @override
  String get nightclubUpgradeSoundRig => 'Plate-forme sonore';

  @override
  String get nightclubUpgradeVipLounge => 'Salon VIP';

  @override
  String get nightclubUpgradeSurveillance => 'Surveillance';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Choisissez la mise à niveau';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Cette mise à niveau est déjà au niveau maximum.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Mise à niveau déjà maximale';

  @override
  String get nightclubUpgradeNow => 'Mettre à niveau maintenant';

  @override
  String get nightclubMarketingInvestment => 'Investissement marketing';

  @override
  String get nightclubInvestMarketing => 'Investir dans le marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Chaleur et incidents policiers';

  @override
  String get nightclubHeatLabel => 'Chaleur';

  @override
  String get nightclubRaidRisk => 'Risque de raid';

  @override
  String get nightclubCooldownLabel => 'Refroidir';

  @override
  String get nightclubStartHeatCooldown =>
      'Démarrer le refroidissement de la chaleur';

  @override
  String get nightclubBribe => 'Pot-de-vin';

  @override
  String get nightclubLockdown => 'Confinement';

  @override
  String get nightclubCounterIntelShort => 'Contre-renseignements';

  @override
  String get nightclubSectionStaffMorale => '5) Fatigue et moral du personnel';

  @override
  String get nightclubMorale => 'Moral';

  @override
  String get nightclubFatigue => 'Fatigue';

  @override
  String get nightclubStaffing => 'Dotation en personnel';

  @override
  String get nightclubSectionSupplierPromoter => '6) Fournisseur & promoteur';

  @override
  String get nightclubSupplierContract => 'Contrat fournisseur';

  @override
  String get nightclubActivateSupplier => 'Activer le fournisseur';

  @override
  String get nightclubPromoterProfile => 'Profil du promoteur';

  @override
  String get nightclubHirePromoter => 'Promoteur d\'embauche';

  @override
  String get nightclubSectionVipClientele =>
      '7) Clientèle VIP et caractéristiques du personnel';

  @override
  String get nightclubVipShare => 'Partage VIP';

  @override
  String get nightclubSpendMultiplier => 'Dépenser x';

  @override
  String get nightclubTier => 'Étage';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Routes de contrebande';

  @override
  String get nightclubReady => 'Prêt';

  @override
  String get nightclubRoute => 'Itinéraire';

  @override
  String get nightclubStartRoute => 'Itinéraire de départ';

  @override
  String get nightclubLastRoute => 'Dernier itinéraire';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Verrouillage d\'itinéraire actif jusqu\'à $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Gestion du bar et de la cuisine';

  @override
  String get nightclubServiceLevel => 'Niveau de service';

  @override
  String get nightclubStockStatus => 'État des stocks';

  @override
  String get nightclubSpoilageRisk => 'Risque de détérioration';

  @override
  String get nightclubDrinksFoodStock => 'Stock de boissons/nourriture';

  @override
  String get nightclubBuyStock => 'Acheter des actions';

  @override
  String get nightclubMenuPricingMode => 'Mode de tarification des menus';

  @override
  String get nightclubApplyPricing => 'Appliquer le prix';

  @override
  String get nightclubSectionRivals => '10) Clubs rivaux + contre-informations';

  @override
  String get nightclubSearchPlayerName => 'Rechercher le nom du joueur';

  @override
  String get nightclubTargetName => 'Cible (nom)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • foule $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotage';

  @override
  String get nightclubPromoWar => 'Guerre promotionnelle';

  @override
  String get nightclubCounterIntelSweep => 'Balayage contre les renseignements';

  @override
  String get nightclubMitigation => 'Atténuation';

  @override
  String get nightclubSectionTimeline => '11) Chronologie des opérations';

  @override
  String get nightclubNoTimelineEvents => 'Aucun événement chronologique.';

  @override
  String get nightclubOperationsAlerts => 'Alertes opérationnelles';

  @override
  String get nightclubNoCriticalAlerts => 'Aucune alerte critique.';

  @override
  String get nightclubQuickAction => 'Action rapide';

  @override
  String get nightclubMgmtCrewTitle => 'Équipage et quarts de travail';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Dotation en personnel, performances et historique des quarts de travail.';

  @override
  String get nightclubMgmtDrugsTitle => 'Stockage des médicaments';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Gérez et transférez l\'inventaire en grammes.';

  @override
  String get nightclubMgmtDjTitle => 'Commande DJ';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Choisissez DJ, changez de durée et boostez la foule en direct.';

  @override
  String get nightclubMgmtSecurityTitle => 'Unité de sécurité';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Réduction du vol, des coûts et sécurité active.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Laboratoire d\'opérations';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Alertes en direct : $alerts | Contrebande : $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 systèmes pour les événements, les mises à niveau, les itinéraires et les rivaux.';

  @override
  String get nightclubManagementPanelTitle => 'Gestion de discothèque';

  @override
  String get nightclubChooseZoneHint =>
      'Choisissez une zone de gestion et contrôlez tout sans défilement interne imbriqué.';

  @override
  String get nightclubChipCrew => 'Équipage';

  @override
  String get nightclubChipStorage => 'Stockage';

  @override
  String get nightclubChipDjShift => 'Changement de DJ';

  @override
  String get nightclubChipSecurity => 'Sécurité';

  @override
  String get nightclubChipOpsAlerts => 'Alertes opérationnelles';

  @override
  String get nightclubNone => 'Aucune';

  @override
  String get nightclubIntelligenceCardTitle =>
      'Intelligence des boîtes de nuit';

  @override
  String get nightclubSeasonStatus => 'Statut de la saison';

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
    return '$minutes minutes';
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
      'Ignorer le temps de recharge du vol ?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Dépenser $cost crédits pour effacer le temps de recharge du vol de véhicule maintenant ? Votre solde : $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Ne plus afficher cette confirmation';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Utilisez $credits crédits';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'L’accélération du crédit n’est pas disponible pour ce temps de recharge pour le moment.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Aucun temps de recharge de vol actif à réinitialiser.';

  @override
  String get theftCooldownRedeemInsufficientCredits => 'Pas assez de crédits.';

  @override
  String get theftCooldownRedeemFailed =>
      'Impossible d\'appliquer des crédits au temps de recharge.';

  @override
  String get theftCooldownRedeemSuccess => 'Le temps de recharge est terminé.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Temps de recharge pour vol (crédits)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Demandez une confirmation avant de dépenser des crédits pour éviter le temps de recharge du vol de véhicule. Désactivez-le pour l\'échanger en un seul clic (icône en forme d\'éclair à côté de la minuterie).';

  @override
  String get supportTicketsScreenTitle => 'Billets d\'assistance';

  @override
  String get supportLoadTicketsFailed => 'Échec du chargement des billets';

  @override
  String get supportLoadTicketFailed => 'Échec du chargement du ticket';

  @override
  String get supportPickImageFailed => 'Échec de la sélection de l\'image';

  @override
  String get supportSubjectMessageMinLength =>
      'Remplissez le sujet et le message (min. 3 caractères).';

  @override
  String get supportTicketCreated => 'Billet créé.';

  @override
  String get supportCreateTicketFailed => 'Échec de la création du ticket';

  @override
  String get supportReplySent => 'Réponse envoyée.';

  @override
  String get supportReplySendFailed => 'Échec de l\'envoi de la réponse';

  @override
  String get supportDeleteTicketTitle => 'Supprimer le billet';

  @override
  String get supportDeleteTicketBody =>
      'Êtes-vous sûr de vouloir supprimer ce ticket ? Cette action ne peut pas être annulée.';

  @override
  String get supportTicketDeleted => 'Billet supprimé.';

  @override
  String get supportDeleteTicketFailed => 'Échec de la suppression du ticket';

  @override
  String get supportUnknownError => 'Erreur inconnue';

  @override
  String get supportStatusNew => 'Nouvelle';

  @override
  String get supportStatusTriage => 'Triage';

  @override
  String get supportStatusInProgress => 'En cours';

  @override
  String get supportStatusWaitingPlayer => 'En attente du joueur';

  @override
  String get supportStatusBlocked => 'Bloquée';

  @override
  String get supportStatusResolved => 'Résolue';

  @override
  String get supportStatusClosed => 'Fermée';

  @override
  String get supportStatusArchived => 'Archivé';

  @override
  String get supportCategoryBug => 'Bogue';

  @override
  String get supportCategoryQuestion => 'Question';

  @override
  String get supportCategoryFeedback => 'Retour';

  @override
  String get supportCategoryOther => 'Autre';

  @override
  String get supportPriorityLow => 'Faible';

  @override
  String get supportPriorityHigh => 'Haut';

  @override
  String get supportPriorityUrgent => 'Urgente';

  @override
  String get supportPriorityNormal => 'Normale';

  @override
  String supportTimeDaysAgo(int count) {
    return 'il y a ${count}d';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return 'il y a ${count}h';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return 'il y a ${count}m';
  }

  @override
  String get supportTimeJustNow => 'tout à l\' heure';

  @override
  String get supportSenderSupport => 'Soutien';

  @override
  String get supportSenderYou => 'Toi';

  @override
  String get supportImageLoadFailed => 'Échec du chargement de l\'image.';

  @override
  String get supportMyTickets => 'Mes billets';

  @override
  String get supportMyTicketsIntro =>
      'Le support répond désormais directement dans cet écran. Vous pouvez toujours éventuellement recevoir une notification push lorsque votre ticket reçoit une mise à jour.';

  @override
  String get supportNoTicketsYet =>
      'Vous n\'avez pas encore de billets. Créez un nouveau rapport ci-dessous.';

  @override
  String get supportSelectTicketPrompt =>
      'Sélectionnez un ticket pour ouvrir la conversation.';

  @override
  String get supportConversation => 'Conversation';

  @override
  String get supportNoMessagesYet => 'Aucun message pour l\'instant.';

  @override
  String get supportAttachments => 'Pièces jointes';

  @override
  String get supportReplyToTicket => 'Répondre à ce ticket';

  @override
  String get supportReplyFieldHint =>
      'Utilisez ce champ lorsque l\'assistance demande plus d\'informations ou lorsque vous souhaitez fournir une mise à jour. La boîte de réception et le push restent des canaux de notification pour les nouvelles réponses d\'assistance.';

  @override
  String get supportYourReply => 'Votre réponse';

  @override
  String get supportSendReply => 'Envoyer la réponse';

  @override
  String get supportNewTicket => 'Nouveau billet';

  @override
  String get supportNewTicketIntro =>
      'Créez un nouveau rapport ici. L\'assistance peut ensuite répondre via la boîte de réception/push et sur cet écran, afin que vous puissiez poursuivre la conversation au même endroit.';

  @override
  String get supportTicketReceivedBanner => 'Billet reçu';

  @override
  String supportTicketNumberLine(int id) {
    return 'Numéro de billet : #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'Le ticket apparaît désormais directement dans votre liste ci-dessus. De nouvelles réponses d\'assistance arrivent également sous forme de messages de boîte de réception et de notifications push.';

  @override
  String get supportFieldCategory => 'Catégorie';

  @override
  String get supportFieldModule => 'Module';

  @override
  String get supportFieldSubject => 'Sujette';

  @override
  String get supportFieldMessage => 'Message';

  @override
  String get supportReferenceOptional => 'Référence (facultatif)';

  @override
  String get supportReferenceHint =>
      'Par exemple, l\'identifiant de la commande, le nom d\'écran, le pays ou un bref contexte';

  @override
  String get supportAddScreenshot => 'Ajouter une capture d\'écran';

  @override
  String get supportSubmit => 'Soumettre';

  @override
  String get supportLastMessagePrefix => 'Dernière:';

  @override
  String get supportReferenceLabel => 'Référence';

  @override
  String get supportMod_support => 'Assistance générale';

  @override
  String get supportMod_dashboard => 'Tableau de bord';

  @override
  String get supportMod_messages => 'Messages/boîte de réception';

  @override
  String get supportMod_notifications => 'Notifications/push';

  @override
  String get supportMod_payments => 'Paiements / prime';

  @override
  String get supportMod_bank => 'Banque';

  @override
  String get supportMod_crypto => 'Cryptomonnaie';

  @override
  String get supportMod_travel => 'Voyage';

  @override
  String get supportMod_properties => 'Propriétés';

  @override
  String get supportMod_inventory => 'Inventaire / stockage';

  @override
  String get supportMod_loadouts => 'Chargements / équipement';

  @override
  String get supportMod_crimes => 'Crimes';

  @override
  String get supportMod_jobs => 'Travail / emplois';

  @override
  String get supportMod_vehicles => 'Vol de voiture / vélo / bateau';

  @override
  String get supportMod_garage => 'Garage';

  @override
  String get supportMod_marina => 'Marina';

  @override
  String get supportMod_aviation => 'Aviation';

  @override
  String get supportMod_smuggling => 'Contrebande';

  @override
  String get supportMod_drugs => 'Drogues';

  @override
  String get supportMod_nightclub => 'Discothèque';

  @override
  String get supportMod_prostitution => 'Prostitution';

  @override
  String get supportMod_crew => 'Équipage';

  @override
  String get supportMod_friends => 'Amis/joueurs';

  @override
  String get supportMod_hitlist => 'Liste de résultats';

  @override
  String get supportMod_security => 'Sécurité / FBI';

  @override
  String get supportMod_prison => 'Prison/tribunal';

  @override
  String get supportMod_casino => 'Casino';

  @override
  String get supportMod_school => 'Ecole / formation';

  @override
  String get supportMod_achievements => 'Réalisations';

  @override
  String get supportMod_profile => 'Profil';

  @override
  String get supportMod_settings => 'Paramètres';

  @override
  String get supportMod_events => 'Événements / classement';

  @override
  String get supportMod_other => 'Autre';

  @override
  String get gameEventDefaultTitle => 'Événement';

  @override
  String get gameEventStatusActive => 'Active';

  @override
  String get gameEventStatusScheduled => 'Programmé';

  @override
  String get gameEventStatusCompleted => 'Complété';

  @override
  String get gameEventStatusDraft => 'Brouillon';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Chasse au vol hebdomadaire';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Volez autant de véhicules que possible pendant la fenêtre de l\'événement.';

  @override
  String get gameEventTmplSmugglingSurgeTitle =>
      'Augmentation de la contrebande';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Déplacez la contrebande la plus introduite ce tour-ci.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Défi des résultats de laboratoire';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produisez le plus de résultats pendant que l’événement est en direct.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'Frénésie de crimes de rue';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Complétez autant de crimes que possible dans la fenêtre en direct.';

  @override
  String get gameScreenLoadError => 'Impossible de charger les événements.';

  @override
  String get gameScreenDetailsLoadError =>
      'Impossible de charger les détails de l\'événement.';

  @override
  String get gameScreenSectionLive => 'Événements en direct';

  @override
  String get gameScreenNoActive =>
      'Il n\'y a aucun événement actif pour le moment.';

  @override
  String get gameScreenSectionUpcoming => 'Événements à venir';

  @override
  String get gameScreenNoUpcoming => 'Il n\'y a aucun événement programmé.';

  @override
  String gameScreenStatusPrefix(String value) {
    return 'Statut : $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Début : $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Fin : $date';
  }

  @override
  String get gameScreenYourProgress => 'Votre progression';

  @override
  String gameScreenScore(String value) {
    return 'Note : $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Rang : $value';
  }

  @override
  String get gameScreenLeaderboard => 'Classement (top 10)';

  @override
  String get gameScreenNoLeaderboard =>
      'Aucune donnée de classement pour l\'instant.';

  @override
  String get gameScreenUnknownPlayer => 'Inconnue';

  @override
  String get gameCardActive => 'Active';

  @override
  String get gameCardScheduled => 'Prévue';

  @override
  String gameCardYourScore(String value) {
    return 'Votre note : $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Votre rang : $value';
  }

  @override
  String get gameCardTapDetails =>
      'Appuyez pour plus de détails et le classement';

  @override
  String get eventFeedDisconnected => 'Déconnecté du flux d\'événements';

  @override
  String get eventFeedReconnecting => 'Reconnexion...';

  @override
  String get eventFeedConnectedWaiting =>
      'Connecté — en attente des événements…';

  @override
  String get eventFeedConnecting => 'Connexion au flux d\'événements…';

  @override
  String get evStreamConnectionEstablished => 'Connecté au flux d\'événements';

  @override
  String get evStreamAuthRegistered => 'Compte créé avec succès.';

  @override
  String get evStreamAuthLogin => 'Content de te revoir.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return '$crimeName terminé avec succès ! +EUR $reward, +$xpGained XP';
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
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$crimeName réussi ! +EUR $reward, +$xpGained XP — attrapé ! Emprisonné $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      'Votre véhicule a été saisi par la police.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      'Votre arme a été confisquée par la police.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condamnations',
      one: '1 condamnation',
    );
    return '$crimeName réussi ! Casier effacé : $_temp0 supprimées. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Arrêté par $authority lors d\'une tentative $crimeName.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'Pris pendant $crimeName ! Emprisonné $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Échec de la réalisation $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return 'Votre véhicule a subi $pct % de dégâts pendant la poursuite.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'Pris pendant $crimeName ! Emprisonné $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Travail terminé en tant que $jobName ! +$earnings€, +$xpGained XP';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return '(Prime d\'éducation +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Échec de la réalisation du travail en tant que $jobName. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Échec de la réalisation du travail en tant que $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Emploi invalide';

  @override
  String get evStreamJobErrorLevel => 'Votre rang est trop bas pour ce poste';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes de plus',
      one: '1 minute de plus',
    );
    return 'Ce travail est en recharge. Attends $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Erreur de tâche : $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Vol vers $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Arrivé en $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Déposé $amount € à la banque';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Retrait $amount € de la banque';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Acheté $quantity $symbol pour $total€';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Vendu $quantity $symbol pour $total€ (P&L $pnl€)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol alerte : $price€ ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side rempli : $quantity $symbol à $price€';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig déclenché pour $symbol à $price€';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Le régime du marché est passé à $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment actualité : $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Mission quotidienne terminée : $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Mission hebdomadaire terminée : $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Récompense du classement Crypto : #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'haussière';

  @override
  String get evStreamRegimeBear => 'baissier';

  @override
  String get evStreamRegimeSideways => 'de côté';

  @override
  String get evStreamImpactBull => 'Haussière';

  @override
  String get evStreamImpactBear => 'Baissier';

  @override
  String get evStreamImpactNeutral => 'Neutre';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Acheté $name pour $cost€';
  }

  @override
  String evStreamCrewCreated(String name) {
    return 'Equipage créé : $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Équipage rejoint : $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Guerre d\'équipage déclarée : #$a contre #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'La guerre des équipages a commencé : #$a contre #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'La guerre des équipages #$id est bloquée';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Guerre d\'équipage #$id résolue. Gagnant : équipage #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Action de guerre d\'équipage : $action (+$points pt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Braquage « $name » réussi ! +$money€';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Le braquage « $name » a échoué.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Soigné à l\'hôpital ! +$hp santé, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Arrêté! Emprisonné pendant $mins minutes';
  }

  @override
  String get evStreamPoliceEscaped => 'Vous avez échappé à la police.';

  @override
  String get evStreamFbiRaid =>
      'Raid du FBI ! Vous avez perdu des biens et de l\'argent.';

  @override
  String get evStreamErrInsufficientFunds => 'Pas assez d\'argent';

  @override
  String get evStreamErrInsufficientHealth =>
      'Pas assez de santé pour cette action';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Nécessite le rang $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'Tu es en prison encore $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'Vous avez besoin de vous reposer et de retrouver votre santé';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds secondes',
      one: '1 seconde',
    );
    return 'Attends $_temp0 avant de réessayer';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Vous ne pouvez pas aider les autres pendant que vous êtes en prison';

  @override
  String get evStreamErrTargetNotJailed => 'Ce joueur n\'est pas en prison';

  @override
  String get evStreamErrCannotRescueSelf => 'Tu ne peux pas te libérer';

  @override
  String get evStreamJailbreakOk => 'Jailbreak réussi ! Le joueur est libre.';

  @override
  String get evStreamJailbreakFail =>
      'Le jailbreak a échoué ! Le joueur est toujours en prison.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Le jailbreak a échoué ! Vous avez été arrêté et emprisonné pendant $mins minutes.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Caution payée : $amount€. Vous êtes libre.';
  }

  @override
  String get evStreamErrInternal =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String evStreamTest(String msg) {
    return 'Test : $msg';
  }

  @override
  String get evStreamNoCriminalRecord =>
      'Vous n\'avez pas de casier judiciaire à effacer';

  @override
  String get evStreamWeaponSelectRequired =>
      'Sélectionnez une arme du crime avant de commettre ce crime';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Il vous faut une arme adaptée : $types';
  }

  @override
  String get evStreamJobFallbackName => 'emploi';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Erreur de connexion';

  @override
  String get crimeWeaponSectionTitle => 'Arme du crime';

  @override
  String get crimeWeaponInstruction =>
      'Choisissez l\'arme que vous utilisez par défaut pour les crimes qui en nécessitent une.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Achetez ou déplacez d’abord une arme utilisable dans votre inventaire transporté.';

  @override
  String get crimeWeaponSelectHint => 'Sélectionnez une arme pour les crimes';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Sans sélection, les crimes basés sur les armes ne commenceront pas.';

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Sélectionné : $weaponLine. Certains crimes nécessitent en plus un type d’arme correspondant.';
  }

  @override
  String get crimeSetWeaponFailed =>
      'Échec de la configuration de l\'arme du crime.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Choisissez d\'abord une arme du crime en haut de cet écran ou via l\'inventaire.';

  @override
  String get crimeWeaponFooterNote =>
      'Les crimes commis à l\'aide d\'armes utilisent l\'arme criminelle sélectionnée ci-dessus.';

  @override
  String get crimeCriminalRecordWipeDesc =>
      'Forgez des dossiers judiciaires et effacez l’intégralité de votre casier judiciaire si l’opération réussit.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% de chances de réussite';
  }

  @override
  String get cooldownTimeLeft => 'Temps restant';

  @override
  String get cooldownMustWaitExplanation =>
      'Vous devez attendre avant de pouvoir effectuer à nouveau cette action.';

  @override
  String get cooldownAlreadyFinished =>
      'Le temps de recharge est déjà terminé.';

  @override
  String get cooldownNotEnoughCredits => 'Pas assez de crédits.';

  @override
  String get cooldownNoActiveToReset =>
      'Aucun temps de recharge actif à réinitialiser.';

  @override
  String get cooldownNotAvailableNow => 'Non disponible pour le moment.';

  @override
  String get cooldownRedeemFailed =>
      'Impossible d\'accélérer avec les crédits.';

  @override
  String get cooldownFinishedInstantly =>
      'Le temps de recharge s\'est terminé instantanément.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Accélérez maintenant (-$cost crédits)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Solde : $balance crédits';
  }

  @override
  String get cooldownLoadingCreditOptions =>
      'Chargement des options de crédit…';

  @override
  String get cooldownWaitCrime => 'La chaleur est trop forte…';

  @override
  String get cooldownWaitJob =>
      'Se reposer avant de pouvoir travailler à nouveau';

  @override
  String get cooldownWaitTravel => 'Le prochain vol décolle à';

  @override
  String get cooldownWaitHeist => 'Planification du braquage…';

  @override
  String get cooldownWaitAppeal => 'Le tribunal est occupé…';

  @override
  String get cooldownWaitSchool =>
      'Reprenez votre souffle avant le prochain cours…';

  @override
  String get cooldownWaitDefault => 'S\'il vous plaît, attendez…';

  @override
  String get weaponLabelKnife => 'Couteau';

  @override
  String get weaponLabelHandgun9mm => 'Pistolet (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Pistolet lourd (.45)';

  @override
  String get weaponLabelSmgCompact => 'Mitrailleuse compacte';

  @override
  String get weaponLabelShotgunPump => 'Fusil de chasse (à pompe)';

  @override
  String get weaponLabelMolotov => 'Cocktail Molotov';

  @override
  String get weaponLabelSmgSuppressed => 'SMG supprimé';

  @override
  String get weaponLabelShotgunTactical => 'Fusil de chasse tactique';

  @override
  String get weaponLabelAssaultRifle => 'Fusil d\'assaut (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Grenade éclair';

  @override
  String get weaponLabelGrenadeFrag => 'Grenade à fragmentation';

  @override
  String get weaponLabelSniperStandard => 'Fusil de précision';

  @override
  String get weaponLabelAssaultRifleVip => 'Fusil d\'assaut d\'élite';

  @override
  String get weaponLabelSniperVip => 'Fusil de précision d\'élite';

  @override
  String get cooldownTitleCrime => 'Temps de recharge du crime';

  @override
  String get cooldownTitleJob => 'Temps de recharge du travail';

  @override
  String get cooldownTitleTravel => 'Temps de recharge du voyage';

  @override
  String get cooldownTitleHeist => 'Temps de recharge du braquage';

  @override
  String get cooldownTitleAppeal => 'Temps de recharge d\'appel';

  @override
  String get cooldownTitleSchool => 'Temps de recharge pour l\'école';

  @override
  String get cooldownTitleGeneric => 'Refroidir';

  @override
  String get crimeOutcomeDefaultTitle => 'Résultat du crime';

  @override
  String get territoryContestStatusPreparing => 'Préparation';

  @override
  String get territoryContestStatusActive => 'Active';

  @override
  String get territoryContestStatusLockdown => 'Confinement';

  @override
  String get territoryContestStatusResolved => 'Résolue';

  @override
  String get territoryContestStatusCancelled => 'Annulé';

  @override
  String get territoryContestHintPreparing =>
      'Ce concours est actuellement en préparation. Une fois le temps de préparation terminé, la région devient automatiquement active et les actions se déverrouillent.';

  @override
  String get territoryContestHintLockdown =>
      'Ce concours est bloqué. Aucune nouvelle mesure ne peut être prise maintenant ; le résultat se résout automatiquement.';

  @override
  String get territoryNow => 'Maintenant';

  @override
  String get territoryRoleAttacker => 'Attaquante';

  @override
  String get territoryRoleDefender => 'Défenseure';

  @override
  String get territoryValueLow => 'Faible';

  @override
  String get territoryValueAverage => 'Moyenne';

  @override
  String get territoryValueHigh => 'Haut';

  @override
  String get territoryValueTop => 'Haut';

  @override
  String get territoryTagCapital => 'Centre administratif';

  @override
  String get territoryTagHarbor => 'Port';

  @override
  String get territoryTagIndustry => 'Industrie';

  @override
  String get territoryTagBorder => 'Région frontalière';

  @override
  String get territoryTagLogistics => 'Plateforme logistique';

  @override
  String get territoryActionPatrol => 'Patrouille';

  @override
  String get territoryActionIntelScan => 'Analyse Intel';

  @override
  String get territoryActionSabotage => 'Sabotage';

  @override
  String get territoryActionSupplyRun => 'Course d\'approvisionnement';

  @override
  String get territoryActionRaid => 'Raid';

  @override
  String get territoryActionDefense => 'Défense';

  @override
  String get territoryBonusStrategicRegion => 'Région stratégique';

  @override
  String get territoryBonusAdjacentSupport => 'Support adjacent';

  @override
  String get territoryBonusWarPressure => 'Pression de guerre';

  @override
  String get territoryBonusHqLevel => 'Niveau QG';

  @override
  String get territoryBonusCrewMissionLevel =>
      'Niveau de mission de l\'équipage';

  @override
  String get territoryBonusCrewBuildings => 'Bâtiments côté équipage';

  @override
  String get territoryBonusOther => 'Autre';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'base $basePoints + bonus $bonusPoints = $totalPoints points du concours';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Vous devez rejoindre un équipage avant de pouvoir attaquer un territoire.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Un concours est déjà en cours pour cette région. Actualisation de la carte vers le dernier état.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Votre équipage a déjà atteint la limite des concours simultanés.';

  @override
  String get territoryErrorRegionsCap =>
      'Votre équipe possède déjà le nombre maximum de régions.';

  @override
  String get territoryErrorContestNotActive =>
      'Ce concours n\'est pas encore actif. Attendez la fin de la phase de préparation.';

  @override
  String get territoryErrorActionCooldown =>
      'Vous devez attendre avant d\'effectuer une autre action de territoire.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Cette action appartient à l\'autre côté du concours.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Votre niveau de QG est trop bas pour cette action de territoire.';

  @override
  String get territoryErrorDailyCap =>
      'Vous avez atteint votre limite quotidienne d\'actions de territoire.';

  @override
  String get territoryErrorWrongCountry =>
      'Vous pouvez afficher tous les pays, mais les actions territoriales ne fonctionnent que dans le pays dans lequel vous vous trouvez actuellement.';

  @override
  String get territoryErrorUnknown => 'Erreur de territoire inconnu.';

  @override
  String get territoryLegendUnderContest => 'En concours';

  @override
  String get territoryLegendNeutral => 'Neutre';

  @override
  String get territoryTabMap => 'Carte';

  @override
  String get territoryTabLeaderboard => 'Classement';

  @override
  String get territoryTabSeason => 'Saison';

  @override
  String get territorySelectCountryTooltip => 'Sélectionnez un pays';

  @override
  String get territoryUnavailableMessage =>
      'Le territoire est actuellement indisponible.';

  @override
  String get territoryMapHintTapMain =>
      'Appuyez sur une région sur la carte pour ouvrir les informations sur le territoire et le bouton d\'attaque dans un modal.';

  @override
  String get territoryMapHintTapPanel =>
      'Appuyez sur une région pour ouvrir directement le modal avec des informations sur le territoire et des actions d\'attaque.';

  @override
  String get territoryMapHintMobile =>
      'Sur mobile, vous pouvez pincer l\'intérieur et l\'extérieur avec deux doigts et faire glisser la carte zoomée directement pour les petites régions.';

  @override
  String get territoryMapHintColors =>
      'Les couleurs de la région montrent la propriété ; orange = concours actif.';

  @override
  String territoryMapOverviewTitle(String country) {
    return 'Carte $country (contrôle de l\'équipage)';
  }

  @override
  String get territoryLegendTitle => 'Légende';

  @override
  String territoryYourCrewLine(String name) {
    return 'Votre équipage : $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Aperçu de la région';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Uniquement la région sélectionnée, sans le reste de la carte.';

  @override
  String get territoryNeutralTerritory => 'Territoire neutre';

  @override
  String get territoryDetailOwner => 'Propriétaire';

  @override
  String get territoryDetailNeutral => 'Neutre';

  @override
  String get territoryDetailStability => 'Stabilité';

  @override
  String get territoryDetailEffectiveStability => 'Stabilité efficace';

  @override
  String get territoryDetailControl => 'Contrôle';

  @override
  String get territoryDetailValueTier => 'Niveau de valeur';

  @override
  String get territoryDetailPayout => 'Paiement';

  @override
  String get territoryDetailStrategicRole => 'Rôle stratégique';

  @override
  String get territoryDetailAdjacentOwned => 'Régions adjacentes';

  @override
  String get territoryDetailActionBonuses => 'Bonus d\'actions';

  @override
  String get territoryDetailBonusInfo => 'Informations sur les bonus';

  @override
  String get territoryDetailBonusInfoBody =>
      'Ces bonus ne font qu\'augmenter vos points de concours par action. Le paiement en € de la région reste le même.';

  @override
  String get territoryDetailWarPressure => 'Pression de guerre';

  @override
  String get territoryDetailAttackPressure => 'pression d\'attaque';

  @override
  String get territoryDetailStabilityWord => 'stabilité';

  @override
  String get territoryWarRoleTheater => 'région du théâtre';

  @override
  String get territoryWarRoleAdjacent => 'région adjacente';

  @override
  String get territoryWarRoleTarget => 'région cible';

  @override
  String get territoryWarPressureEndsIn => 'La pression de la guerre prend fin';

  @override
  String get territoryDetailIncomeHour => 'Revenu par heure';

  @override
  String get territoryDetailIncomeDay => 'Revenu par jour';

  @override
  String get territoryDetailYourCrew => 'Votre équipage';

  @override
  String get territoryDetailContestStatus => 'Statut du concours';

  @override
  String get territoryDetailYourRole => 'Votre rôle';

  @override
  String get territoryDetailYourHqLevel => 'Votre niveau QG';

  @override
  String get territoryDetailActionsUnlockIn => 'Les actions se débloquent dans';

  @override
  String get territoryDetailActionsCloseIn => 'Les actions se rapprochent';

  @override
  String get territoryDetailContestEndsIn => 'Le concours se termine dans';

  @override
  String get territoryDetailCooldownPerAction => 'Temps de recharge par action';

  @override
  String get territoryDetailYourCooldown => 'Votre temps de recharge';

  @override
  String get territoryNoticeCrewOnly =>
      'Le territoire n\'est jouable que pour les membres d\'équipage. Créez ou rejoignez d’abord un équipage, puis vous pourrez attaquer des régions neutres.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Vous visualisez $viewingCountry, mais vous êtes actuellement en $playerCountry. Vous pouvez parcourir cette carte, mais les attaques et les actions de concours ne se débloquent qu\'après votre voyage dans ce pays.';
  }

  @override
  String get territoryNoticeOwnRegion =>
      'Votre équipage contrôle déjà cette région.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Votre équipage défend cette région. Une fois la phase active commencée, vous ne verrez que des actions défensives.';

  @override
  String get territoryConfirmDefense => 'Confirmer la défense';

  @override
  String get territoryAttack => 'Attaque';

  @override
  String get territoryAttackerActions => 'Actions de l\'attaquant';

  @override
  String get territoryDefenderActions => 'Actions du défenseur';

  @override
  String get territoryContestActions => 'Actions du concours';

  @override
  String get territoryIntelShort => 'Analyse Intel';

  @override
  String get territoryRequiresHqShort => 'nécessite le QG';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Niveau de QG supérieur requis pour : $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Vous ne faites pas partie de ce concours, vous ne pouvez donc pas effectuer d\'actions ici.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Ce concours se déroule dans un autre pays. Vous pouvez le suivre, mais vous ne pouvez le rejoindre qu\'une fois que vous êtes physiquement en $country.';
  }

  @override
  String get territoryLeaderboardEmpty =>
      'Aucun territoire contrôlé pour l\'instant.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count régions';
  }

  @override
  String get territorySeasonNone => 'Aucune saison active trouvée.';

  @override
  String get territorySeasonCurrent => 'Saison en cours';

  @override
  String get territorySeasonKey => 'Clé';

  @override
  String get territorySeasonStatus => 'Statut';

  @override
  String get territorySeasonStart => 'Commencer';

  @override
  String get territorySeasonEnd => 'Fin';

  @override
  String get territoryDialogAttackTitle => 'Attaque?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Lancer un concours pour $regionKey ?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Rejoignez d\'abord un équipage pour attaquer le territoire.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Le concours a commencé. Statut : $status. Attendez la fin de la phase de préparation avant d’agir.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'Le concours a déjà commencé et la carte a été rafraîchie. Statut : $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points points !';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'La défense a confirmé. Une fois la phase active lancée, vous pouvez effectuer des actions défensives.';

  @override
  String get territorySnackContestRefreshed =>
      'L\'état du concours a été actualisé. Vous pouvez désormais voir immédiatement la phase de défense en cours.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Nécessite le niveau de QG $required. Niveau actuel du QG : $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (nécessite le QG $level)';
  }

  @override
  String get smugglingHubTitle => 'Centre de contrebande';

  @override
  String get smugglingHubSubtitle =>
      'Un seul système pour les drogues, les marchandises commerciales, les véhicules, les armes et les munitions. Voyagez à vide et récupérez en toute sécurité depuis le dépôt.';

  @override
  String get smugglingClaimPersonal => 'Réclamation personnelle';

  @override
  String get smugglingClaimCrew => 'Equipe de réclamation';

  @override
  String get smugglingNewShipment => 'Nouvel envoi';

  @override
  String get smugglingCategoryDrug => 'Drogues';

  @override
  String get smugglingCategoryTrade => 'Marchandises commerciales';

  @override
  String get smugglingCategoryVehicle => 'Véhicules';

  @override
  String get smugglingCategoryWeapon => 'Armes';

  @override
  String get smugglingCategoryAmmo => 'Munitions';

  @override
  String get smugglingNoItemsInCategory =>
      'Aucun article disponible dans cette catégorie.';

  @override
  String get smugglingFieldItem => 'Article';

  @override
  String get smugglingFieldDestination => 'Destination';

  @override
  String get smugglingTransport => 'Transport';

  @override
  String get smugglingCommercialChannel => 'Canal commercial';

  @override
  String get smugglingOwnedVehicleAircraft => 'Véhicule/avion possédé';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Vous ne possédez pas de véhicule ou d\'avion disponible pour la contrebande dans ce pays.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Transport en propriété';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capacité : $slots emplacements • Confiscation en cas d\'échec : $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots emplacements • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Réseau';

  @override
  String get smugglingPersonal => 'Personnelle';

  @override
  String get smugglingCrew => 'Équipage';

  @override
  String get smugglingChannelField => 'Canal de contrebande';

  @override
  String get smugglingQuantity => 'Quantité';

  @override
  String get smugglingVehiclesOneByOne =>
      'Les véhicules sont expédiés un par un';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Max : $max';
  }

  @override
  String get smugglingStartSmuggling => 'Commencer la contrebande';

  @override
  String get smugglingSelectItemDestination =>
      'Sélectionnez l\'article et la destination';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'La contrebande d\'équipages pour les marchandises commerciales n\'est pas encore disponible';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Sélectionnez d\'abord un véhicule ou un avion possédé';

  @override
  String get smugglingInvalidQuantity => 'Quantité invalide';

  @override
  String get smugglingActionProcessed => 'Action traitée';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '$fee € • $etaMinutes min • $risk% de risque';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% de risque';
  }

  @override
  String get smugglingQuotePrompt =>
      'Sélectionnez l\'article et la destination pour un devis en direct.';

  @override
  String get smugglingQuoteLiveTitle => 'Devis en direct';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Transport en propriété : $label';
  }

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Emplacements de chargement : $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Temps de recharge actif : $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Chaîne recommandée : $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Liquidités insuffisantes pour cet envoi';

  @override
  String get smugglingDepotsTitle => 'Dépôts nationaux';

  @override
  String get smugglingDepotsEmpty => 'Aucun colis prêt dans les dépôts.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages forfaits • $totalQuantity unités';
  }

  @override
  String get smugglingClaimHere => 'Réclamez ici';

  @override
  String get smugglingStatusTitle => 'Statut de contrebande';

  @override
  String get smugglingNoShipmentsYet => 'Pas encore d\'envois.';

  @override
  String get smugglingStatusInTransit => 'En transit';

  @override
  String get smugglingStatusReady => 'Prêt';

  @override
  String get smugglingStatusSeized => 'Saisie';

  @override
  String get smugglingStatusClaimed => 'Réclamé';

  @override
  String get smugglingStatusUnknown => 'Inconnue';

  @override
  String get smugglingChannelPackage => 'Emballer';

  @override
  String get smugglingChannelCourier => 'Courrier';

  @override
  String get smugglingChannelContainer => 'Récipient';

  @override
  String get smugglingChannelOwned => 'Transport en propriété';

  @override
  String get smugglingHintOwnedTransport =>
      'Le transport en propriété réduit les coûts et les risques, mais il peut être confisqué en cas d\'échec.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Astuce : les véhicules fonctionnent mieux avec Courier ou Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Astuce : il est préférable d\'utiliser des chargements d\'armes plus importants via Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Astuce : munitions en vrac via un conteneur pour réduire les risques.';

  @override
  String get smugglingHintDrugsChannel =>
      'Astuce : petits lots via Package, vrac via Container.';

  @override
  String get smugglingHintCompareChannels =>
      'Astuce : comparez les chaînes avec le live quote.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Un bateau ne peut pas rentrer dans un avion.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'La capacité de transport que vous possédez est trop petite.';

  @override
  String get smugglingQuoteUnavailable => 'Devis indisponible';

  @override
  String get smugglingApiInvalidChannel => 'Canal de contrebande invalide';

  @override
  String get smugglingApiInvalidNetwork => 'Choix de réseau invalide';

  @override
  String get smugglingApiInvalidQuantity => 'Quantité invalide';

  @override
  String get smugglingApiInvalidDestination =>
      'Le pays de destination n\'existe pas';

  @override
  String get smugglingApiPlayerNotFound => 'Joueur introuvable';

  @override
  String get smugglingApiSameCountryInventory =>
      'Utiliser l\'inventaire local pour le même pays';

  @override
  String get smugglingApiNotInCrew => 'Vous n\'êtes pas dans un équipage';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'La contrebande d\'équipages pour les marchandises commerciales n\'est pas encore disponible';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Les véhicules en propriété ne fonctionnent que pour le trafic personnel';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Choisissez un véhicule ou un avion possédé';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Le véhicule sélectionné n\'est pas disponible';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Vous ne pouvez pas utiliser le même véhicule pour le fret et le transport';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Une voiture ou une moto ne peut pas transporter un autre véhicule';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Les véhicules ne peuvent pas utiliser le canal du forfait';

  @override
  String get smugglingApiBoatCannotFit =>
      'Un bateau ne peut pas rentrer dans un avion.';

  @override
  String get smugglingApiCargoOverflow =>
      'La capacité de transport que vous possédez est trop petite.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Attendez ${seconds}s avant un autre $channel envoi';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Pas assez d\'argent pour les frais de contrebande';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Pas assez de médicaments dans l\'inventaire de l\'équipage';

  @override
  String get smugglingApiInsufficientDrugs =>
      'Pas assez de médicaments en stock';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Pas assez de marchandises commerciales en stock';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Pas assez d\'armes dans l\'inventaire de l\'équipage';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Pas assez d\'armes en inventaire';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Pas assez de munitions dans l\'inventaire de l\'équipage';

  @override
  String get smugglingApiInsufficientAmmo =>
      'Pas assez de munitions dans l\'inventaire';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Véhicule d\'équipage invalide';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Bateau avec équipage non disponible pour la contrebande';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Moto de l\'équipage non disponible pour la contrebande';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Voiture d\'équipage non disponible pour la contrebande';

  @override
  String get smugglingApiInvalidVehicleKey => 'Véhicule invalide';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Véhicule non disponible pour la contrebande';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Stock insuffisant pour cette expédition';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'Aucune expédition prête dans ce dépôt de pays';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Quantité trop élevée pour $channel. Max : $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'L\'envoi de contrebande ($channel) vers $destination a commencé';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Récupéré $count envoi(s) en $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Récupération de $count expédition(s) d\'équipage en $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'L\'envoi a échoué';

  @override
  String get smugglingClientQuoteFailed => 'Échec du devis';

  @override
  String get smugglingClientClaimFailed => 'La réclamation a échoué';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Erreur : $detail';
  }

  @override
  String get cryptoMarketNoData =>
      'Aucune donnée disponible sur le marché de la cryptographie';

  @override
  String get cryptoMarketTitle => 'Marché de la cryptographie';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Commandes ouvertes : $count';
  }

  @override
  String get cryptoRegimeBull => 'Marché haussier';

  @override
  String get cryptoRegimeBear => 'Marché baissier';

  @override
  String get cryptoRegimeSideways => 'De côté';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Possédé : $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portefeuille';

  @override
  String get cryptoLabelValue => 'Valeur';

  @override
  String get cryptoLabelCostBasis => 'Base de coût';

  @override
  String get cryptoLabelUnrealized => 'Non réalisé';

  @override
  String get cryptoLabelRealized => 'Réalisé';

  @override
  String get cryptoNoPositionsYet => 'Aucun poste pour l\'instant';

  @override
  String get cryptoChartDataUnavailable => 'Données graphiques indisponibles';

  @override
  String get cryptoUnknownTime => 'Inconnue';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop-loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Profiter';

  @override
  String get cryptoOrderTypeLimit => 'Limite';

  @override
  String get cryptoSideBuy => 'Acheter';

  @override
  String get cryptoSideSell => 'Vendre';

  @override
  String get cryptoInvalidQuantity => 'Quantité invalide';

  @override
  String get cryptoPurchaseCompleted => 'Achat terminé';

  @override
  String get cryptoSaleCompleted => 'Vente terminée';

  @override
  String get cryptoActionProcessed => 'Action traitée';

  @override
  String get cryptoInvalidTargetPrice => 'Prix ​​indicatif invalide';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Vous ne pouvez pas vendre plus que ce que vous possédez.';

  @override
  String get cryptoOpenOrderPlaced => 'Commande ouverte passée';

  @override
  String get cryptoOpenOrderFailed => 'Échec de la commande';

  @override
  String get cryptoOrderCancelled => 'Commande annulée';

  @override
  String get cryptoCancelOrderFailed => 'Échec de l\'annulation de la commande';

  @override
  String get cryptoDirectTradeTitle => 'Commerce direct';

  @override
  String get cryptoLabelQuantity => 'Quantité';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Prix actuel : $currentPrice€ • Achat moy : $avgBuy€ \nUtilisez TOUS pour vendre instantanément l’intégralité de votre position.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Prix ​​actuel : $currentPrice€ • Achat moy : $avgBuy€';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Prix actuel : $currentPrice€ \nUtilisez TOUS pour vendre instantanément l’intégralité de votre position.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Prix ​​actuel : $currentPrice€';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Votre historique pour $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Achat moyen';

  @override
  String get cryptoLabelLastBuy => 'Dernier achat';

  @override
  String get cryptoLabelBuyVolume => 'Acheter du volume';

  @override
  String get cryptoLabelSellVolume => 'Volume de vente';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Dernier achat à $when';
  }

  @override
  String get cryptoNoTradesForCoinYet =>
      'Aucun échange pour cette pièce pour l\'instant.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Commandes ouvertes pour $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Les commandes ouvertes utilisent leur propre quantité ci-dessous. Remplissez la quantité et le prix indicatif dans cette section.';

  @override
  String get cryptoLabelOrderType => 'Type de commande';

  @override
  String get cryptoLabelSide => 'Côté';

  @override
  String get cryptoLabelOrderQuantity => 'Quantité commandée';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Cet ordre se vend à partir de votre position actuelle. Possédé : $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Cette quantité est distincte du commerce direct ci-dessus.';

  @override
  String get cryptoLabelTargetPrice => 'Prix ​​indicatif';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limiter l\'achat en dessous du prix, limiter la vente au-dessus du prix';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'S\'exécute lorsque le prix tombe à ce niveau';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'S\'exécute lorsque le prix atteint ce niveau';

  @override
  String get cryptoPlaceOpenOrder => 'Passer une commande ouverte';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Vous n\'avez pas encore de commandes ouvertes pour cette pièce.';

  @override
  String get cryptoLabelCancel => 'Annuler';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Détails de la cryptographie • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Pièce de monnaie';

  @override
  String get cryptoLabelPrice => 'Prix';

  @override
  String get cryptoLabelOwned => 'Possédée';

  @override
  String get cryptoLabelOpenOrders => 'Commandes ouvertes';

  @override
  String get cryptoNotEnoughHistory => 'Pas encore assez d\'histoire';

  @override
  String get cryptoChartPointsWord => 'points';

  @override
  String get cryptoChartHourAbbrev => 'h';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • historique complet';
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
  String get cryptoChartRange7d => '7j';

  @override
  String get cryptoChartRange30d => '30j';

  @override
  String get cryptoChartRangeAll => 'Toute';

  @override
  String get cryptoChartLive1h => 'En direct • dernière 1h';

  @override
  String get cryptoChartLive4h => 'En direct • dernières 4h';

  @override
  String get cryptoChartLive8h => 'En direct • dernières 8h';

  @override
  String get cryptoChartLive24h => 'En direct • dernières 24h';

  @override
  String get cryptoChartLive7d => 'En direct • les 7 derniers jours';

  @override
  String get cryptoChartLive30d => 'En direct • 30 derniers jours';

  @override
  String get cryptoChartLiveAll => 'En direct • historique complet';

  @override
  String get cryptoLabelTotal => 'Totale';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'Impossible de charger le marché des cryptomonnaies.';

  @override
  String get cryptoApiAssetNotFound => 'Crypto introuvable.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'Impossible de charger les données du graphique cryptographique.';

  @override
  String get cryptoApiNotLoggedIn => 'Non connecté.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'Impossible de charger le portefeuille.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Impossible de charger l\'historique des transactions cryptographiques.';

  @override
  String get cryptoApiInvalidQuantity => 'Quantité invalide.';

  @override
  String get cryptoApiInsufficientFunds => 'Pas assez d\'argent.';

  @override
  String get cryptoApiPurchaseFailed => 'L\'achat a échoué.';

  @override
  String get cryptoApiNotEnoughCrypto =>
      'Pas assez de crypto-monnaies détenues.';

  @override
  String get cryptoApiSellFailed => 'La vente a échoué.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'Impossible de charger les commandes cryptographiques.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Prix ​​indicatif invalide.';

  @override
  String get cryptoApiInvalidOrderType => 'Type de commande invalide.';

  @override
  String get cryptoApiInvalidOrderSide => 'Côté commande invalide.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Ce type de commande et cette combinaison latérale ne sont pas autorisés.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Échec de la commande.';

  @override
  String get cryptoApiPlayerNotFound => 'Joueur introuvable.';

  @override
  String get cryptoApiInvalidOrderId => 'Identifiant de commande invalide.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Commande introuvable ou n\'est plus active.';

  @override
  String get cryptoApiCancelOrderFailed =>
      'Échec de l\'annulation de la commande.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Vous avez acheté $quantity $symbol pour $total€.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Vous avez vendu $quantity $symbol pour $total€.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Commande passée : $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Commande $orderId annulée.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Erreur : $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Erreur lors du chargement : $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Erreur lors du chargement des installations : $error';
  }

  @override
  String get drugsInvTitle => 'Inventaire des médicaments';

  @override
  String get drugsInvKpiGramsLabel => 'inventaire';

  @override
  String get drugsCutQualityDCannotCut =>
      'La qualité D ne peut pas être réduite davantage.';

  @override
  String get drugsCutFailed => 'La coupe a échoué';

  @override
  String get drugsSellFailed => 'La vente a échoué';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Vendre $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Disponible : $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Qualité : $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Prix ​​actuel : $price€ le gramme';
  }

  @override
  String get drugsPricesByCountry => 'Tarifs par pays :';

  @override
  String get drugsQuantityGramsField => 'Quantité (grammes)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Total : $amount€';
  }

  @override
  String get drugsInvalidQuantity => 'Quantité invalide';

  @override
  String get drugsSellAction => 'Vendre';

  @override
  String get drugsInvEmptyTitle => 'Aucun médicament en stock';

  @override
  String get drugsInvEmptySubtitle =>
      'Démarrer la production pour créer des médicaments';

  @override
  String get drugsInvSectionHeader => 'Inventaire et distribution';

  @override
  String get drugsInvSectionBody =>
      'Vendre des médicaments par qualité et utiliser les différences de prix entre les pays.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Localisation actuelle : $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventaire : $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Valeur actuelle : $amount€';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Marché : $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Couper les médicaments';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Qualité $fromQ → $toQ : +$pct% d\'unités en plus';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Résultat : $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Couper';

  @override
  String get drugsSlotsLabel => 'machines à sous';

  @override
  String get drugsFacilitiesTitle => 'Installations antidrogue';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Gérez vos installations pharmaceutiques';

  @override
  String get drugsFacilitiesHeroBody =>
      'Des installations telles qu\'une serre, une champignonnière, un laboratoire pharmaceutique, une cuisine de crack et une vitrine sur le darkweb déterminent les médicaments que vous pouvez produire, le nombre d\'emplacements dont vous disposez et la qualité, le rendement et la rapidité de votre production.';

  @override
  String get drugsFacCurrentProductions => 'Productions actuelles';

  @override
  String get drugsFacUnknownFacility => 'Installation inconnue';

  @override
  String get drugsFacUnknownMessage => 'Message inconnu';

  @override
  String get drugsFacUpgradeLockedTitle =>
      '🔒 Mise à niveau de médicament verrouillée';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Vous avez d’abord besoin des niveaux de formation et des certifications appropriés en matière de stupéfiants.';

  @override
  String get drugsFacEquipLockedTitle =>
      '🔒 Mise à niveau d\'équipement verrouillée';

  @override
  String get drugsFacEquipLockedBody =>
      'Entraînez d\'abord votre piste Narcotics pour débloquer le niveau de mise à niveau suivant.';

  @override
  String get drugsFacBuy => 'Acheter';

  @override
  String get drugsFacOwned => 'Possédée';

  @override
  String get drugsFacPrice => 'Prix';

  @override
  String get drugsFacRank => 'Rang';

  @override
  String get drugsFacDrugTypes => 'Drogues';

  @override
  String get drugsFacSlots => 'Machines à sous';

  @override
  String get drugsFacQuality => 'Qualité';

  @override
  String get drugsFacYield => 'Rendement';

  @override
  String get drugsFacSpeed => 'Vitesse';

  @override
  String get drugsFacMaxSlots => 'Emplacements maximum';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Emplacements de mise à niveau (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Mises à niveau de l\'équipement';

  @override
  String get drugsFacMax => 'Max.';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Niv $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Environnement de la drogue';

  @override
  String get drugsSubviewProduction => 'Production de drogue';

  @override
  String get drugsSubviewFacilities => 'Installations antidrogue';

  @override
  String get drugsSubviewInventory => 'Inventaire des médicaments';

  @override
  String get drugsTagUndergroundOps => 'Opérations souterraines';

  @override
  String get drugsTagMobileOptimized => 'Optimisé pour les mobiles';

  @override
  String get drugsTagQualityDriven => 'Axé sur la qualité';

  @override
  String get drugsEmpireTitle => 'Empire de la drogue';

  @override
  String get drugsHubIntro =>
      'Gérez ici la production, les installations et les stocks. Achetez du matériel sur le marché noir pendant que le reste se déroule dans votre propre environnement de drogue.';

  @override
  String get drugsStatMaterialFlow => 'Flux de matières';

  @override
  String get drugsStatBlackMarket => 'Marché noir';

  @override
  String get drugsStatProductionChain => 'Chaîne de production';

  @override
  String get drugsStatProductionChainValue =>
      'Serre + Laboratoire + Cuisine + Darkweb';

  @override
  String get drugsStatSalesModel => 'Modèle de vente';

  @override
  String get drugsStatPerQuality => 'Par qualité';

  @override
  String get drugsMetricActiveBatches => 'Lots actifs';

  @override
  String get drugsMetricSlotUsage => 'Utilisation des emplacements';

  @override
  String get drugsMetricInventoryValue => 'Valeur d\'inventaire';

  @override
  String get drugsMetricInventoryGrams => 'Grammes d\'inventaire';

  @override
  String get drugsMetricEfficiency => 'Efficacité';

  @override
  String get drugsMetricPoliceHeat => 'Chaleur policière';

  @override
  String get drugsSectionOperations => 'Opérations';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Choisissez une branche de votre empire de la drogue';

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastructure';

  @override
  String get drugsCardFacilitiesTitle => 'Installations';

  @override
  String get drugsCardFacilitiesBody =>
      'Achetez et améliorez une serre, un laboratoire pharmaceutique, une cuisine de crack et une vitrine darkweb pour plus d\'emplacements, de vitesse et de qualité.';

  @override
  String get drugsCardProductionEyebrow => 'Pipeline';

  @override
  String get drugsCardProductionTitle => 'Production';

  @override
  String get drugsCardProductionBody =>
      'Démarrez des lots, suivez les minuteries et collectez les résultats avec des rouleaux de qualité.';

  @override
  String get drugsCardInventoryEyebrow => 'Distribution';

  @override
  String get drugsCardInventoryTitle => 'Inventaire';

  @override
  String get drugsCardInventoryBody =>
      'Visualisez les piles par qualité et vendez au meilleur prix du marché.';

  @override
  String get drugsQualityDistribution => 'Distribution de qualité';

  @override
  String get drugsQualityGradeSuperior => 'Supérieure';

  @override
  String get drugsQualityGradeHigh => 'Haut';

  @override
  String get drugsQualityGradeStandardPlus => 'Norme+';

  @override
  String get drugsQualityGradeStandard => 'Standard';

  @override
  String get drugsQualityGradeLow => 'Faible';

  @override
  String get drugsHeatLevelLow => 'Faible';

  @override
  String get drugsHeatLevelMedium => 'Moyen';

  @override
  String get drugsHeatLevelHigh => 'Haut';

  @override
  String get drugsHeatLevelCritical => 'Critique';

  @override
  String get drugsProdTitle => 'Production de drogue';

  @override
  String get drugsProdLineTitle => 'Ligne de production';

  @override
  String get drugsProdLineSubtitle =>
      'Démarrez des lots, surveillez la capacité des emplacements et ajustez la qualité via les mises à niveau des serres et des laboratoires.';

  @override
  String get drugsProdActiveProductions => 'Productions actives';

  @override
  String get drugsProdIncidentLegend => 'Légende de l\'incident';

  @override
  String get drugsProdHide => 'Cacher';

  @override
  String get drugsProdShow => 'Montrer';

  @override
  String get drugsProdLegendDelay => 'Retard';

  @override
  String get drugsProdLegendContamination => 'Contamination';

  @override
  String get drugsProdLegendYieldLoss => 'Perte de rendement';

  @override
  String get drugsProdLegendInstability => 'Instabilité';

  @override
  String get drugsProdLegendCombined => 'Problème combiné';

  @override
  String get drugsProdCollect => 'Collecter';

  @override
  String get drugsProdAvailableDrugs => 'Médicaments disponibles';

  @override
  String get drugsProdNoDrugs => 'Aucun médicament disponible';

  @override
  String get drugsProdAutoCollectOn => 'Collecte automatique sur (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Collecte automatique (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Tous les matériaux disponibles';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP : achetez les matériaux manquants en un clic';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Heure : $time | Rendement : ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility : $used/$total emplacements utilisés';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility requis';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Rang $rank requis';
  }

  @override
  String get drugsProdNoFreeSlot =>
      'Aucun créneau de production gratuit disponible';

  @override
  String get drugsProdOpenFacilities => 'Installations ouvertes';

  @override
  String get drugsProdStartProduction => 'Démarrer la production';

  @override
  String get drugsProdAutoCollectUpdated => 'Collecte automatique mise à jour';

  @override
  String get drugsProdKpiActive => 'active';

  @override
  String get drugsProdKpiReady => 'prête';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Rendement : $qty grammes';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes minutes';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours heure';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours heure $minutes min';
  }

  @override
  String get drugsTimeHourEn => 'heure';

  @override
  String get drugsProdConfirmTitle => 'Es-tu sûr?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return 'Démarrer la production $drugName ?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Heure : $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Rendement : $yield grammes';
  }

  @override
  String get drugsProdRiskNote =>
      'La production peut parfois subir des revers. De meilleures mises à niveau réduisent le risque, tandis que la chaleur élevée du médicament l\'augmente.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Matériel requis :';

  @override
  String get drugsProdStartProductionButton => 'Démarrer la production';

  @override
  String get drugsProdFailed => 'La production a échoué';

  @override
  String get drugsProdCollectFailed => 'Échec de la collecte';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Vous avez besoin du rang $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Manquante';

  @override
  String get drugsFacilityGreenhouse => 'Serre';

  @override
  String get drugsFacilityCrackKitchen => 'Cuisine de crack';

  @override
  String get drugsFacilityDarkweb => 'Vitrine du Darkweb';

  @override
  String get drugsFacilityMushroomFarm => 'Ferme de champignons';

  @override
  String get drugsFacilityDrugLab => 'Laboratoire de médicaments';

  @override
  String get drugsVipQuickBuyTitle => 'Achat rapide VIP';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Vous avez déjà suffisamment de matériel pour $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Acheter tous les matériaux manquants pour $name en un clic ?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Total : $amount€';
  }

  @override
  String get drugsPurchaseCompleted => 'Achat terminé';

  @override
  String get drugsPurchaseFailed => 'L\'achat a échoué';

  @override
  String get drugsServiceErrorGeneric => 'Erreur';

  @override
  String get drugsApiFailedBuyMaterial => 'Échec de l\'achat du matériel';

  @override
  String get drugsApiFailedStartProduction =>
      'Échec du démarrage de la production';

  @override
  String get drugsApiFailedCollect => 'Échec de la collecte de la production';

  @override
  String get drugsApiFailedSell => 'Échec de la vente de médicaments';

  @override
  String get drugsApiFailedCut => 'Échec de la suppression des médicaments';

  @override
  String get drugsApiFailedShipment => 'Échec de l\'envoi de l\'envoi';

  @override
  String get drugsApiFailedClaim =>
      'Échec de la réclamation des expéditions du dépôt';
}
