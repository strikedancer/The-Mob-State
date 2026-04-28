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
  String get oncePerMonth => 'Changer une fois par mois';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get allowMessages => 'Autoriser les messages';

  @override
  String get allowMessagesDesc =>
      'Les autres joueurs peuvent vous envoyer des messages';

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
  String get properties => 'Propriétés';

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
  String get wantedLevel => 'Niveau recherché';

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
  String get vehicles => 'Véhicules';

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
  String get free => 'GRATUITE';

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
  String get tools => 'outils';

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
  String get arrested => 'Arrêté!';

  @override
  String get jailMessage =>
      'Vous avez été arrêté pendant votre voyage et toutes les marchandises ont été confisquées !';

  @override
  String get confirmAction => 'Es-tu sûr?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

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
  String get hit => 'FRAPPER';

  @override
  String get counterBidLabel => 'CONTRE-OFFRE';

  @override
  String daysAgo(String count, String plural) {
    return 'Il y a $count jour$plural';
  }

  @override
  String hoursAgo(String count) {
    return 'Il y a $count heures';
  }

  @override
  String minutesAgo(String count) {
    return 'il y a $count minutes';
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
    return '$rounds tours par boîte';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Vous recevrez : $rounds tours';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Coût total : $cost€';
  }

  @override
  String get ammoRounds => 'tours';

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
  String get factoryProduceStatusLabel => 'Statut du produit';

  @override
  String get factoryProduceStatusReady => 'Prêt';

  @override
  String get factoryProduceStatusCooldown => 'Refroidir';

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
  String get shootingTrainSuccess => 'Formation terminée';

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
  String get gymTrainSuccess => 'Formation terminée';

  @override
  String gymSessions(String count) {
    return 'Séances : $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonus de force : $bonus%';
  }

  @override
  String gymCooldown(String time) {
    return 'Prochaine séance à $time';
  }

  @override
  String get gymTrain => 'Former';

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
  String get prostitutionMoveToRedLight => 'Passer au feu rouge';

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
  String schoolTrackCooldownActive(int seconds) {
    return 'Temps de recharge actif : ${seconds}s restants';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'La piste est déjà au niveau maximum';

  @override
  String get schoolTrackStartFailed => 'Échec du démarrage de la formation';

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
}
