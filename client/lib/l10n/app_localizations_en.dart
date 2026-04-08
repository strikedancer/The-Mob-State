// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mafia Game';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameLabel => 'USERNAME';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get usernamePlaceholder => 'Username';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get registerButton => 'REGISTER';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get usernameRequired => 'Please enter a username';

  @override
  String get passwordRequired => 'Please enter a password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get invalidCredentials => 'Incorrect username or password';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get emailPlaceholder => 'Email';

  @override
  String get emailRequired => 'Please enter an email address';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get resetPasswordButton => 'SEND RESET LINK';

  @override
  String get emailSent => 'Reset link sent! Check your email.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String welcome(String username) {
    return 'Welcome, $username!';
  }

  @override
  String get dashboardTimeouts => 'Timeouts';

  @override
  String get dashboardTimeoutCrime => 'Crime';

  @override
  String get dashboardTimeoutJob => 'Work';

  @override
  String get dashboardTimeoutTravel => 'Travel';

  @override
  String get dashboardTimeoutVehicleTheft => 'Steal car';

  @override
  String get dashboardTimeoutBoatTheft => 'Steal boat';

  @override
  String get dashboardTimeoutNightclubSeason => 'Nightclub season';

  @override
  String get dashboardTimeoutAmmo => 'Buy bullets';

  @override
  String get dashboardTimeoutShootingRange => 'Shooting range';

  @override
  String get dashboardTimeoutGym => 'Gym';

  @override
  String get dashboardInfoDrugsGrams => 'Drugs (grams)';

  @override
  String get dashboardInfoNightclubs => 'Nightclubs';

  @override
  String get dashboardInfoNightclubRevenue => 'Nightclub revenue';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get crimes => 'Crimes';

  @override
  String get errorLoadingCrimes => 'Failed to load crimes';

  @override
  String connectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Pay: €$min - €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Requires Rank $rank';
  }

  @override
  String get requiresVehicle => 'Requires Vehicle';

  @override
  String get federalCrimeWarning => '⚠️ Federal Crime - FBI Heat';

  @override
  String get crimePickpocketName => 'Pickpocketing';

  @override
  String get crimePickpocketDesc => 'Steal wallets from passersby';

  @override
  String get crimeShopliftName => 'Shoplifting';

  @override
  String get crimeShopliftDesc => 'Steal goods from a store';

  @override
  String get crimeStealBikeName => 'Steal Bike';

  @override
  String get crimeStealBikeDesc => 'Steal a bike from a rack';

  @override
  String get crimeCarTheftName => 'Car Theft';

  @override
  String get crimeCarTheftDesc => 'Steal a parked car';

  @override
  String get crimeBurglaryName => 'Burglary';

  @override
  String get crimeBurglaryDesc => 'Break into a house';

  @override
  String get crimeRobStoreName => 'Store Robbery';

  @override
  String get crimeRobStoreDesc => 'Rob a small store';

  @override
  String get crimeMugPersonName => 'Mugging';

  @override
  String get crimeMugPersonDesc => 'Mug someone on the street';

  @override
  String get crimeStealCarPartsName => 'Steal Car Parts';

  @override
  String get crimeStealCarPartsDesc => 'Steal parts from parked cars';

  @override
  String get crimeHijackTruckName => 'Hijack Truck';

  @override
  String get crimeHijackTruckDesc => 'Hijack a truck carrying goods';

  @override
  String get crimeAtmTheftName => 'ATM Theft';

  @override
  String get crimeAtmTheftDesc => 'Break into an ATM';

  @override
  String get crimeJewelryHeistName => 'Jewelry Heist';

  @override
  String get crimeJewelryHeistDesc => 'Rob a jeweler';

  @override
  String get crimeVandalismName => 'Vandalism';

  @override
  String get crimeVandalismDesc => 'Damage property for money';

  @override
  String get crimeGraffitiName => 'Graffiti';

  @override
  String get crimeGraffitiDesc => 'Spray graffiti for local gangs';

  @override
  String get crimeDrugDealSmallName => 'Small Drug Deal';

  @override
  String get crimeDrugDealSmallDesc => 'Sell a small amount of drugs';

  @override
  String get crimeDrugDealLargeName => 'Large Drug Deal';

  @override
  String get crimeDrugDealLargeDesc => 'Sell a large amount of drugs';

  @override
  String get crimeExtortionName => 'Extortion';

  @override
  String get crimeExtortionDesc => 'Extort money from local businesses';

  @override
  String get crimeKidnappingName => 'Kidnapping';

  @override
  String get crimeKidnappingDesc => 'Kidnap someone for ransom';

  @override
  String get crimeArsonName => 'Arson';

  @override
  String get crimeArsonDesc => 'Set a building on fire';

  @override
  String get crimeSmugglingName => 'Smuggling';

  @override
  String get crimeSmugglingDesc => 'Smuggle goods across the border';

  @override
  String get crimeAssassinationName => 'Assassination';

  @override
  String get crimeAssassinationDesc => 'Carry out a contract killing';

  @override
  String get crimeHackAccountName => 'Hack Account';

  @override
  String get crimeHackAccountDesc => 'Hack a bank account';

  @override
  String get crimeCounterfeitMoneyName => 'Counterfeit Money';

  @override
  String get crimeCounterfeitMoneyDesc => 'Make fake money';

  @override
  String get crimeIdentityTheftName => 'Identity Theft';

  @override
  String get crimeIdentityTheftDesc => 'Steal someone\'s identity for fraud';

  @override
  String get crimeRobArmoredTruckName => 'Armored Truck Heist';

  @override
  String get crimeRobArmoredTruckDesc => 'Rob an armored truck';

  @override
  String get crimeArtTheftName => 'Art Theft';

  @override
  String get crimeArtTheftDesc => 'Steal valuable artwork';

  @override
  String get crimeProtectionRacketName => 'Protection Racket';

  @override
  String get crimeProtectionRacketDesc =>
      'Make businesses pay protection money';

  @override
  String get crimeCasinoHeistName => 'Casino Heist';

  @override
  String get crimeCasinoHeistDesc => 'Rob a casino';

  @override
  String get crimeBankRobberyName => 'Bank Robbery';

  @override
  String get crimeBankRobberyDesc => 'Rob a bank';

  @override
  String get crimeStealYachtName => 'Steal Yacht';

  @override
  String get crimeStealYachtDesc => 'Steal a luxury yacht';

  @override
  String get crimeCorruptOfficialName => 'Bribe Official';

  @override
  String get crimeCorruptOfficialDesc => 'Bribe an official for favors';

  @override
  String get tooltipCrimeRequiresTools => 'Tools Required';

  @override
  String get tooltipCrimeRequiresVehicle => 'Vehicle Required';

  @override
  String get tooltipCrimeRequiresDrugs => 'Drugs required';

  @override
  String get tooltipCrimeHighValue => 'High Value Operation';

  @override
  String get tooltipCrimeRequiresViolence => 'Violence Required';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'You need at least ${quantity}x of: $drugs';
  }

  @override
  String get jobs => 'Jobs';

  @override
  String get errorLoadingJobs => 'Failed to load jobs';

  @override
  String get jobNewspaperDeliveryName => 'Newspaper Delivery';

  @override
  String get jobNewspaperDeliveryDesc =>
      'Deliver newspapers early in the morning';

  @override
  String get jobCarWashName => 'Car Wash';

  @override
  String get jobCarWashDesc => 'Wash cars at the car wash';

  @override
  String get jobGroceryBaggerName => 'Grocery Bagger';

  @override
  String get jobGroceryBaggerDesc => 'Stock shelves at the supermarket';

  @override
  String get jobDishwasherName => 'Dishwasher';

  @override
  String get jobDishwasherDesc => 'Wash dishes in a restaurant';

  @override
  String get jobStreetSweeperName => 'Street Sweeper';

  @override
  String get jobStreetSweeperDesc => 'Sweep streets clean';

  @override
  String get jobPizzaDeliveryName => 'Pizza Delivery';

  @override
  String get jobPizzaDeliveryDesc => 'Deliver pizzas in the city';

  @override
  String get jobTaxiDriverName => 'Taxi Driver';

  @override
  String get jobTaxiDriverDesc => 'Drive a taxi around the city';

  @override
  String get jobWarehouseWorkerName => 'Warehouse Worker';

  @override
  String get jobWarehouseWorkerDesc => 'Work in a warehouse';

  @override
  String get jobConstructionWorkerName => 'Construction Worker';

  @override
  String get jobConstructionWorkerDesc => 'Work on a construction site';

  @override
  String get jobBartenderName => 'Bartender';

  @override
  String get jobBartenderDesc => 'Pour beer and mix cocktails';

  @override
  String get jobSecurityGuardName => 'Security Guard';

  @override
  String get jobSecurityGuardDesc => 'Guard a building';

  @override
  String get jobTruckDriverName => 'Truck Driver';

  @override
  String get jobTruckDriverDesc => 'Drive a truck over long distances';

  @override
  String get jobMechanicName => 'Mechanic';

  @override
  String get jobMechanicDesc => 'Repair cars in a garage';

  @override
  String get jobElectricianName => 'Electrician';

  @override
  String get jobElectricianDesc => 'Install and repair electrical systems';

  @override
  String get jobPlumberName => 'Plumber';

  @override
  String get jobPlumberDesc => 'Repair pipes and plumbing';

  @override
  String get jobChefName => 'Chef';

  @override
  String get jobChefDesc => 'Cook in a restaurant';

  @override
  String get jobParamedicName => 'Paramedic';

  @override
  String get jobParamedicDesc => 'Help people in need';

  @override
  String get jobProgrammerName => 'Programmer';

  @override
  String get jobProgrammerDesc => 'Write software for companies';

  @override
  String get jobAccountantName => 'Accountant';

  @override
  String get jobAccountantDesc => 'Manage finances for businesses';

  @override
  String get jobLawyerName => 'Lawyer';

  @override
  String get jobLawyerDesc => 'Defend clients in court';

  @override
  String get jobRealEstateAgentName => 'Real Estate Agent';

  @override
  String get jobRealEstateAgentDesc => 'Sell houses and buildings';

  @override
  String get jobStockbrokerName => 'Stockbroker';

  @override
  String get jobStockbrokerDesc => 'Trade stocks';

  @override
  String get jobDoctorName => 'Doctor';

  @override
  String get jobDoctorDesc => 'Treat patients at the hospital';

  @override
  String get jobAirlinePilotName => 'Pilot';

  @override
  String get jobAirlinePilotDesc => 'Fly passenger airplanes';

  @override
  String get travel => 'Travel';

  @override
  String get errorLoadingCountries => 'Failed to load countries';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get current => 'Current';

  @override
  String get travelTo => 'Travel';

  @override
  String travelCost(String amount) {
    return 'Cost: €$amount';
  }

  @override
  String get travelJourneyTitle => 'Start journey?';

  @override
  String get travelRouteLabel => 'Route:';

  @override
  String travelLegsLabel(String count) {
    return 'Legs: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Cost per leg: €$amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Total cost: €$amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Cooldown: $minutes min per leg';
  }

  @override
  String get travelRiskPerLeg =>
      'Risk: per leg (can be jailed and lose all goods)';

  @override
  String get travelStart => 'Start';

  @override
  String travelInTransitTo(String country) {
    return 'In transit to $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Leg $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Next stop: $country';
  }

  @override
  String get travelContinue => 'Continue';

  @override
  String get travelCancelJourney => 'Cancel journey';

  @override
  String get travelJourneyCanceled => 'Journey canceled';

  @override
  String get travelDirect => 'Direct';

  @override
  String travelVia(String countries) {
    return 'via $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count legs';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'You are in jail for $minutes more minutes';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Traveled to $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity items $item confiscated!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item damaged ($percent% value loss)!';
  }

  @override
  String get countryNetherlands => 'Netherlands';

  @override
  String get countryBelgium => 'Belgium';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryFrance => 'France';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryItaly => 'Italy';

  @override
  String get countryUk => 'United Kingdom';

  @override
  String get countrySwitzerland => 'Switzerland';

  @override
  String get crew => 'Crew';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Health';

  @override
  String get rank => 'Rank';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Settings';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => 'Avatar updated!';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get changeLanguage => 'Language / Taal';

  @override
  String get languageChanged => 'Language changed to English';

  @override
  String languageChangeFailed(String code) {
    return 'Language change failed ($code)';
  }

  @override
  String get chooseLanguage => 'Choose Language / Taal Kiezen';

  @override
  String get dutch => 'Nederlands';

  @override
  String get english => 'English';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeUsername => 'Change Username';

  @override
  String get usernameHint => '3-20 characters';

  @override
  String get change => 'Change';

  @override
  String get minChars => 'Minimum 3 characters';

  @override
  String get usernameUpdated => 'Username updated!';

  @override
  String get usernameTaken => 'Username already taken';

  @override
  String get oncePerMonth => 'Change once per month';

  @override
  String get privacy => 'Privacy';

  @override
  String get allowMessages => 'Allow Messages';

  @override
  String get allowMessagesDesc => 'Other players can send you messages';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get vipStatus => 'VIP Status';

  @override
  String activeUntil(String date) {
    return 'Active until $date';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get chooseAvatar => 'Choose an Avatar';

  @override
  String get freeAvatars => 'Free Avatars';

  @override
  String get vipAvatars => 'VIP Avatars';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get refresh => 'Refresh';

  @override
  String get foodAndDrink => 'Food & Drink';

  @override
  String get invalidItem => 'This item does not exist';

  @override
  String get foodBroodje => 'Sandwich';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Burger';

  @override
  String get foodSteak => 'Steak';

  @override
  String get drinkWater => 'Water';

  @override
  String get drinkSoda => 'Soda';

  @override
  String get drinkCoffee => 'Coffee';

  @override
  String get drinkBeer => 'Beer';

  @override
  String get foodInfo3 => '• Buy food and drink to keep your stats up';

  @override
  String get friends => 'Friends';

  @override
  String get friendActivity => 'Friend Activity';

  @override
  String get properties => 'Properties';

  @override
  String get propertiesAvailable => 'Available';

  @override
  String get myProperties => 'My Properties';

  @override
  String get errorLoadingMyProperties => 'Error loading my properties';

  @override
  String get errorBuyingProperty => 'Error buying property';

  @override
  String get errorCollectingIncome => 'Error collecting income';

  @override
  String get noAvailableProperties => 'No available properties';

  @override
  String get noOwnedProperties => 'You don\'t own any properties yet';

  @override
  String get buyFirstPropertyHint =>
      'Buy your first property in the \"Available\" tab';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Do you want to buy $name for €$price?';
  }

  @override
  String get propertyPrice => 'Price';

  @override
  String get propertyMinLevel => 'Required level';

  @override
  String get propertyIncomePerHour => 'Income/hour';

  @override
  String get propertyMaxLevel => 'Max Level';

  @override
  String get propertyUniquePerCountry => '⚠️ Unique - 1 per country';

  @override
  String get propertyIncomeReady => '✅ Income ready to collect!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Next income in $duration';
  }

  @override
  String get propertyBuyAction => 'Buy Property';

  @override
  String get propertyCollectAction => 'Collect';

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
  String get propertyTypeHouse => 'House';

  @override
  String get propertyTypeWarehouse => 'Warehouse';

  @override
  String get propertyTypeCasino => 'Casino';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Factory';

  @override
  String get propertyTypeBusiness => 'Business';

  @override
  String get propertyCasinoName => 'Casino';

  @override
  String get propertyWarehouseName => 'Warehouse';

  @override
  String get propertyNightclubName => 'Nightclub';

  @override
  String get propertyHouseName => 'House';

  @override
  String get propertyApartmentName => 'Apartment';

  @override
  String get propertyShopName => 'Shop';

  @override
  String get blackMarket => 'Black Market';

  @override
  String get garage => 'Garage';

  @override
  String get garageCapacity => 'Garage Capacity';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total vehicles';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Max Level';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Level $level | $spots spots left';
  }

  @override
  String get noCarsInGarage => 'No cars in your garage';

  @override
  String get stealCarsToStart => 'Steal some cars to get started!';

  @override
  String get stealFailed => 'Steal failed';

  @override
  String get garageUpgradeFailed => 'Failed to upgrade garage';

  @override
  String get saleFailed => 'Sale failed';

  @override
  String get vehicleTransported => 'Vehicle transported successfully!';

  @override
  String get vehicleTransportFailed => 'Failed to transport vehicle';

  @override
  String get listOnMarket => 'List on Market';

  @override
  String marketValue(String amount) {
    return 'Market Value: €$amount';
  }

  @override
  String get askingPrice => 'Asking Price (€)';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get list => 'List';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get vehicleListed => 'Vehicle listed on market!';

  @override
  String get listVehicleFailed => 'Failed to list vehicle';

  @override
  String get marina => 'Marina';

  @override
  String get hospital => 'Hospital';

  @override
  String get court => 'Court';

  @override
  String get casino => 'Casino';

  @override
  String get errorLoadingCasinoStatus => 'Could not check casino status';

  @override
  String get errorLoadingCasinoGames => 'Could not load casino games';

  @override
  String casinoPrice(String amount) {
    return 'Price: €$amount';
  }

  @override
  String get startingCapital => 'Starting capital';

  @override
  String get bankrollHelper => 'This will be the casino bankroll';

  @override
  String get casinoOwnershipInfoTitle => 'About casino ownership:';

  @override
  String get casinoClosedTitle => 'CASINO CLOSED';

  @override
  String get casinoOwnedByLabel => 'This casino is owned by:';

  @override
  String get casinoNoOwner => 'This casino has no owner yet';

  @override
  String get casinoPurchasePriceLabel => 'Purchase price:';

  @override
  String get casinoOwnerInfo =>
      'As owner you manage the casino bankroll and earn money when players lose!';

  @override
  String get casinoGameSlotsName => 'Slot Machine';

  @override
  String get casinoGameSlotsDesc =>
      'Spin the reels and win up to 100x your bet!';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Beat the dealer and win up to 2x your bet!';

  @override
  String get casinoGameRouletteName => 'Roulette';

  @override
  String get casinoGameRouletteDesc =>
      'Pick your number and win up to 35x your bet!';

  @override
  String get casinoGameDiceName => 'Dice';

  @override
  String get casinoGameDiceDesc => 'Roll the dice and win up to 6x your bet!';

  @override
  String get difficultyEasy => 'EASY';

  @override
  String get difficultyMedium => 'MEDIUM';

  @override
  String get difficultyHard => 'HARD';

  @override
  String get casinoDepositTitle => 'Deposit Money';

  @override
  String get casinoWithdrawTitle => 'Withdraw Money';

  @override
  String get amount => 'Amount';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdraw => 'Withdraw';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount deposited into casino bankroll';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount withdrawn from casino bankroll';
  }

  @override
  String get casinoDepositError => 'Error depositing';

  @override
  String get casinoWithdrawError => 'Error withdrawing';

  @override
  String get casinoMinBankroll =>
      'At least €10,000 must remain in the bankroll';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Maximum: €$amount';
  }

  @override
  String get casinoManagementTitle => 'Casino Management';

  @override
  String casinoBankruptWarning(String amount) {
    return 'WARNING: Casino bankroll too low!\nDeposit at least €$amount to avoid bankruptcy.';
  }

  @override
  String get casinoBankroll => 'Casino Bankroll';

  @override
  String get casinoStatsTitle => 'Statistics';

  @override
  String get casinoTotalReceived => 'Total Received:';

  @override
  String get casinoTotalPaidOut => 'Total Paid Out:';

  @override
  String get casinoNetProfit => 'Net Profit:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Profit margin: $percent%';
  }

  @override
  String get casinoManagementInfoTitle => 'Casino Management Info';

  @override
  String get casinoManagementInfo5 =>
      '• You can deposit or withdraw money at any time';

  @override
  String get retry => 'Retry';

  @override
  String get doAction => 'Do';

  @override
  String get pay => 'Pay';

  @override
  String get success => 'Success';

  @override
  String get jail => 'Jail';

  @override
  String get wantedLevel => 'Wanted Level';

  @override
  String get cooldown => 'Cooldown';

  @override
  String get requiredRank => 'Required Player Rank';

  @override
  String get playerRankLabel => 'Player rank';

  @override
  String get loading => 'Loading...';

  @override
  String get trade => 'Trade';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String available(String count) {
    return 'Available: $count';
  }

  @override
  String get notEnoughMoney => 'You don\'t have enough money!';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get unexpectedResponse => 'Unexpected API response';

  @override
  String get errorLoadingMenu => 'Error loading menu';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get food => 'Food';

  @override
  String get drink => 'Drink';

  @override
  String get work => 'Work';

  @override
  String cooldownMinutes(String minutes) {
    return 'Cooldown: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Fly';

  @override
  String get purchased => 'Purchased!';

  @override
  String get sold => 'Sold!';

  @override
  String get errorBuying => 'Error buying';

  @override
  String get errorSelling => 'Error selling';

  @override
  String get goods => 'Goods';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get myListings => 'My Listings';

  @override
  String get inventory => 'Inventory';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get backpacks => 'Backpacks';

  @override
  String get materials => 'Materials';

  @override
  String get production => 'Production';

  @override
  String get stock => 'Stock';

  @override
  String get retryAgain => 'Retry';

  @override
  String get noVehiclesAvailable => 'No vehicles available';

  @override
  String get noListings => 'No listings';

  @override
  String get condition => 'Condition';

  @override
  String get yourHealth => 'Your Health';

  @override
  String get criticalHealthWarning =>
      '⚠️ CRITICAL! You must go to the hospital immediately!';

  @override
  String get lowHealthWarning => '⚠️ Low health! Be careful.';

  @override
  String get free => 'FREE';

  @override
  String get information => 'Information';

  @override
  String get contrabandFlowersName => 'Flowers';

  @override
  String get contrabandFlowersDesc =>
      'Dutch tulips and other flowers for international trade';

  @override
  String get contrabandElectronicsName => 'Electronics';

  @override
  String get contrabandElectronicsDesc =>
      'Advanced electronics and computer components';

  @override
  String get contrabandDiamondsName => 'Diamonds';

  @override
  String get contrabandDiamondsDesc => 'Rough and cut diamonds';

  @override
  String get contrabandWeaponsName => 'Weapons';

  @override
  String get contrabandWeaponsDesc => 'Illegal weapons and ammunition';

  @override
  String get contrabandPharmaceuticalsName => 'Pharmaceuticals';

  @override
  String get contrabandPharmaceuticalsDesc => 'Rare pharmaceutical products';

  @override
  String get multiplier => 'Multiplier';

  @override
  String get sellPrice => 'Sell price';

  @override
  String get boughtFor => 'Bought for';

  @override
  String get profit => 'Profit';

  @override
  String get loss => 'Loss';

  @override
  String ownedQuantity(String quantity) {
    return 'Owned: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Spoils in ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 SPOILED - Worthless';

  @override
  String get vehicleBought => 'Vehicle successfully bought!';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get listingRemoved => 'Listing removed';

  @override
  String get noItemsInInventory => 'No items in inventory';

  @override
  String get buyItemsInBuyTab => 'Buy items in the Buy tab';

  @override
  String errorLoadingMarketData(String error) {
    return 'Error loading market data: $error';
  }

  @override
  String get appeal => 'Appeal';

  @override
  String get submitAppeal => 'Submit Appeal';

  @override
  String get bribeJudge => 'Bribe Judge';

  @override
  String get bribe => 'Bribe';

  @override
  String get treated => 'Treated!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP for €$cost';
  }

  @override
  String get treatmentOptions => 'Treatment Options';

  @override
  String get youAreDead => 'You are dead! Game over.';

  @override
  String get emergencyOnly => 'Emergency treatment only available below 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Emergency treatment! Free +$hp HP';
  }

  @override
  String get byValue => 'By Value';

  @override
  String get byCondition => 'By Condition';

  @override
  String get byFuel => 'By Fuel';

  @override
  String get byName => 'By Name';

  @override
  String get stealCar => 'Steal Car';

  @override
  String get stealBoat => 'Steal Boat';

  @override
  String get sellVehicle => 'Sell Vehicle';

  @override
  String get sellBoat => 'Sell Boat';

  @override
  String get confirmSellVehicle =>
      'Are you sure you want to sell this vehicle?';

  @override
  String get confirmSellBoat => 'Are you sure you want to sell this boat?';

  @override
  String get carStolen => 'Car successfully stolen!';

  @override
  String get boatStolen => 'Boat successfully stolen!';

  @override
  String get vehicleTypeCar => 'Car';

  @override
  String get vehicleTypeBoat => 'Boat';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType stolen!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Unknown $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Speed';

  @override
  String get vehicleStatFuel => 'Fuel';

  @override
  String get vehicleStatCargo => 'Cargo';

  @override
  String get vehicleStatStealth => 'Stealth';

  @override
  String get continueAction => 'Continue';

  @override
  String get vehicleSold => 'Vehicle successfully sold!';

  @override
  String get boatSold => 'Boat successfully sold!';

  @override
  String get garageUpgraded => 'Garage upgraded!';

  @override
  String get marinaUpgraded => 'Marina successfully upgraded!';

  @override
  String get marinaCapacity => 'Marina Capacity';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total boats';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Upgrade (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Max Level';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Level $level | $remaining spots left';
  }

  @override
  String get noBoatsInMarina => 'No boats in your marina';

  @override
  String get stealBoatsToStart => 'Steal some boats to get started!';

  @override
  String get marinaUpgradeFailed => 'Marina upgrade failed';

  @override
  String get boatShipped => 'Boat successfully shipped!';

  @override
  String get boatShipFailed => 'Boat shipping failed';

  @override
  String get buyProperty => 'Buy Property';

  @override
  String propertyBought(String name) {
    return '$name purchased!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Property upgraded to level $level!';
  }

  @override
  String get errorLoadingProperties => 'Error loading properties';

  @override
  String get errorUpgrading => 'Error upgrading';

  @override
  String networkError(String error) {
    return 'Network error: $error';
  }

  @override
  String get unknownResponse => 'Unknown response';

  @override
  String incomeCollected(String amount) {
    return '€$amount collected!';
  }

  @override
  String get buyCasino => 'Buy Casino';

  @override
  String get manageCasino => 'Manage Casino';

  @override
  String get casinoBought => 'Casino successfully bought! 🎰';

  @override
  String get errorBuyCasino => 'An error occurred while buying the casino';

  @override
  String minimumDeposit(String amount) {
    return 'Minimum deposit is €$amount';
  }

  @override
  String get casinoInfo1 => 'Players bet against the casino bankroll';

  @override
  String get casinoInfo2 => 'Winnings are paid from the bankroll';

  @override
  String get casinoInfo3 => 'You can deposit and withdraw money';

  @override
  String get casinoInfo4 => 'Minimum €10,000 in bankroll required';

  @override
  String get casinoInfo5 => 'Below that: bankruptcy';

  @override
  String get members => 'Members';

  @override
  String get location => 'Location';

  @override
  String get level => 'Level';

  @override
  String get alreadyFullHealth => 'You are already at full health!';

  @override
  String get errorTreatment => 'Error during treatment';

  @override
  String waitMinutes(String minutes) {
    return 'You must wait $minutes more minutes for the next treatment!';
  }

  @override
  String get emergencyHelp => 'Emergency Help';

  @override
  String onlyNeedHp(String hp) {
    return '(You only need $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 Emergency Help is FREE below 10 HP (+20 HP)';

  @override
  String get hospitalInfo1 => '• Health decreases when committing crimes';

  @override
  String get hospitalInfo2 => '• At 0 HP you cannot commit crimes';

  @override
  String hospitalInfo3(String cost) {
    return '• Treatment costs €$cost per time';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• You can restore max $amount HP per treatment';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 hour cooldown between treatments';

  @override
  String get hospitalInfo6 =>
      '• 💚 Passive healing: +5 HP per 5 minutes (if HP > 0)';

  @override
  String get medicalTreatment => 'Medical Treatment';

  @override
  String get restoreCritical => 'Restore +20 HP (critical condition)';

  @override
  String restoreUp(String amount) {
    return 'Restore up to $amount HP';
  }

  @override
  String get cost => 'Cost';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ You need $tools for this crime';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ You have $tools, but it\'s at home! Go to Inventory → Transfer';
  }

  @override
  String get crimeErrorVehicleRequired => '🚗 This crime requires a vehicle';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Vehicle not found';

  @override
  String get crimeErrorNotVehicleOwner => '🚗 You don\'t own this vehicle';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Your vehicle is broken and needs repair';

  @override
  String get crimeErrorNoFuel => '⛽ Your vehicle has no fuel';

  @override
  String get crimeErrorLevelTooLow => '⭐ Your level is too low for this crime';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Invalid crime';

  @override
  String get crimeErrorWeaponRequired => '🔫 You need a weapon for this crime';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Your weapon is broken and needs repair';

  @override
  String get crimeErrorNoAmmo => '🔫 You have no ammo';

  @override
  String get crimeErrorGeneric => '❌ Something went wrong with this crime';

  @override
  String get inventoryFull =>
      '🎒 Your inventory is full! Store tools in a property';

  @override
  String get storageFull => '📦 Property storage is full';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool moved to $location';
  }

  @override
  String get carried => 'Carried';

  @override
  String get storage => 'Storage';

  @override
  String get property => 'Property';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slots';
  }

  @override
  String get loadouts => 'Loadouts';

  @override
  String get createLoadout => 'Create Loadout';

  @override
  String get equipLoadout => 'Equip';

  @override
  String get loadoutEquipped => '✅ Loadout equipped';

  @override
  String get loadoutMaxReached => '❌ Maximum loadouts reached (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Missing tools: $tools';
  }

  @override
  String get backpackUpgrade => 'Backpack Upgrade';

  @override
  String get backpackBasic => 'Basic Backpack (+5 slots)';

  @override
  String get backpackTactical => 'Tactical Vest (+10 slots)';

  @override
  String get backpackCargo => 'Cargo Pants (+3 slots)';

  @override
  String get upgradeInventory => 'Upgrade Inventory';

  @override
  String get noToolsCarried => 'No tools carried';

  @override
  String get visitShopToBuyTools => 'Visit the shop to buy tools';

  @override
  String get noProperties => 'No properties';

  @override
  String get buyPropertyForStorage => 'Buy a property to store tools';

  @override
  String get noToolsInStorage => 'No tools in storage';

  @override
  String get selectProperty => 'Select property';

  @override
  String get slotsRemaining => 'slots remaining';

  @override
  String get tools => 'tools';

  @override
  String get noLoadouts => 'No loadouts';

  @override
  String get createLoadoutToStart => 'Create a loadout to get started';

  @override
  String get deleteLoadout => 'Delete Loadout';

  @override
  String get confirmDeleteLoadout =>
      'Are you sure you want to delete this loadout?';

  @override
  String get loadoutDeleted => 'Loadout deleted';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get active => 'Active';

  @override
  String get durability => 'Durability';

  @override
  String get quantity => 'Quantity';

  @override
  String get slotSize => 'Slot size';

  @override
  String get repairCost => 'Repair cost';

  @override
  String get wearPerUse => 'Wear per use';

  @override
  String get loseChance => 'Chance to lose';

  @override
  String get requiredFor => 'Required for';

  @override
  String get lowDurability => 'Low durability';

  @override
  String get transfer => 'Transfer';

  @override
  String get toolDetails => 'Tool Details';

  @override
  String get transferTool => 'Transfer Tool';

  @override
  String get selectQuantity => 'Select quantity';

  @override
  String get destination => 'Destination';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get editLoadout => 'Edit Loadout';

  @override
  String get loadoutName => 'Loadout Name';

  @override
  String get description => 'Description';

  @override
  String get optional => 'optional';

  @override
  String get selectedTools => 'Selected tools';

  @override
  String get noToolsAvailable => 'No tools available';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get pleaseSelectTools => 'Please select at least 1 tool';

  @override
  String get loadoutCreated => 'Loadout created';

  @override
  String get loadoutUpdated => 'Loadout updated';

  @override
  String get goToInventory => 'Go to Inventory';

  @override
  String get slots => 'slots';

  @override
  String get backpackShop => 'Backpack Shop';

  @override
  String get yourBackpack => 'Your backpack';

  @override
  String get availableUpgrades => 'Available upgrades';

  @override
  String get otherBackpacks => 'Other backpacks';

  @override
  String get youHaveBestBackpack => 'You have the best backpack!';

  @override
  String get backpackPurchased => 'Backpack purchased!';

  @override
  String get backpackUpgraded => 'Backpack upgraded!';

  @override
  String get buyBackpack => 'Buy';

  @override
  String get upgradeBackpack => 'Upgrade';

  @override
  String get backpackPrice => 'Price';

  @override
  String get extraSlots => 'Extra slots';

  @override
  String get totalSlots => 'Total slots';

  @override
  String get vipOnly => 'VIP only';

  @override
  String get tradeInValue => 'Trade-in value';

  @override
  String get upgradeCost => 'Upgrade cost';

  @override
  String rankRequired(Object rank) {
    return 'Rank $rank required';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'You need €$needed. You have €$have';
  }

  @override
  String get alreadyHasBackpack => 'You already have a backpack';

  @override
  String get backpackNotFound => 'Backpack not found';

  @override
  String get playerNotFound => 'Player not found';

  @override
  String get notAnUpgrade => 'This is not an upgrade';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'You purchased $name! +$slots slots.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Upgraded to $newName! +$upgradeSlots extra slots.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Backpack not found';

  @override
  String get backpackPurchaseFailedAlready =>
      'You already have a backpack. You can only use one at a time.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'You need rank $required (you are rank $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'You need €$needed. You have €$have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'This backpack is for VIP members only';

  @override
  String get backpackUpgradeFailedNo => 'You have no backpack to upgrade';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'This is not an upgrade. Choose a larger backpack.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'You need rank $required (you are rank $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'You need €$needed. You have €$have';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'This backpack is for VIP members only';

  @override
  String get arrested => 'Arrested!';

  @override
  String get jailMessage =>
      'You were arrested during your journey and all goods were confiscated!';

  @override
  String get confirmAction => 'Are you sure?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle => 'Proceed to next leg?';

  @override
  String get travelContinueConfirmBody =>
      'Border checks are active. Continue your journey?';

  @override
  String get travelJourneyCompleteTitle => 'Journey complete';

  @override
  String get travelJourneyCompleteBody =>
      'You made it safely to your destination.';

  @override
  String get hitlist => 'Hit List';

  @override
  String hitlistLoadError(String error) {
    return 'Error loading hit list: $error';
  }

  @override
  String get noActiveHits => 'No active hits placed';

  @override
  String get selectTarget => 'Select Target';

  @override
  String get searchPlayer => 'Search player...';

  @override
  String get placeHitTitle => 'Place Hit';

  @override
  String get minimumBounty => 'Minimum bounty: €50,000';

  @override
  String get bountyAmount => 'Bounty amount';

  @override
  String get place => 'Place';

  @override
  String hitPlaced(String amount) {
    return 'Hit placed for €$amount';
  }

  @override
  String hitError(String error) {
    return 'Error: $error';
  }

  @override
  String get hitDifferentCountry =>
      'You must be in the same country as the target';

  @override
  String get counterBountyTitle => 'Place Counter-Bounty';

  @override
  String minimumAmount(String amount) {
    return 'Minimum amount: €$amount';
  }

  @override
  String get counterBountyAmount => 'Counter-bounty amount';

  @override
  String counterBountyPlaced(String amount) {
    return 'Counter-bounty of €$amount placed';
  }

  @override
  String get cancelHitConfirmTitle => 'Cancel hit?';

  @override
  String get cancelHitConfirmBody => 'Your bounty will be refunded.';

  @override
  String get hitCancelled => 'Hit cancelled';

  @override
  String get target => 'Target';

  @override
  String get placer => 'Placer';

  @override
  String get bounty => 'Bounty';

  @override
  String get counterBid => 'COUNTER-BID';

  @override
  String get counterBidPlaced =>
      'Counter-bid placed! The contract has been reversed.';

  @override
  String get attemptHit => 'Attempt Hit';

  @override
  String get selectWeapon => 'Select Weapon and Ammo';

  @override
  String get youAreTargeted => 'You are on the hit list';

  @override
  String get security => 'Security';

  @override
  String get currentDefense => 'Current Defense';

  @override
  String get totalDefense => 'Total Defense';

  @override
  String get currentArmor => 'Current Armor';

  @override
  String get bodyguards => 'Bodyguards';

  @override
  String get buyBodyguards => 'Buy Bodyguards';

  @override
  String get bodyguardPrice => 'Price per Bodyguard';

  @override
  String get armor => 'Armor';

  @override
  String get protectorsFollow => 'Protectors that follow you';

  @override
  String get eachGivesDefense => 'Each gives +10 defense';

  @override
  String get lightArmor => 'Light Armor';

  @override
  String get basicProtection => 'Basic protection';

  @override
  String get heavyArmor => 'Heavy Armor';

  @override
  String get strongProtection => 'Strong protection';

  @override
  String get bulletproofVest => 'Bulletproof Vest';

  @override
  String get veryStrongProtection => 'Very strong protection';

  @override
  String get tacticalSuit => 'Tactical Outfit';

  @override
  String get premiumProtection => 'Premium protection';

  @override
  String get defense => 'Defense';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'You purchased $armor! +$defense defense';
  }

  @override
  String get worn => 'Worn';

  @override
  String get hit => 'HIT';

  @override
  String daysAgo(String count, String plural) {
    return '$count day$plural ago';
  }

  @override
  String hoursAgo(String count) {
    return '$count hours ago';
  }

  @override
  String minutesAgo(String count) {
    return '$count minutes ago';
  }

  @override
  String get justPlaced => 'Just placed';

  @override
  String get youAreTheTarget => 'You are the target';

  @override
  String get youAreThePlacer => 'You are the placer';

  @override
  String get onlyTargetCanCounterBid =>
      'Only the target can place a counter-bid';

  @override
  String get executeHit => 'Execute Hit';

  @override
  String get moneyNotEnough => 'You don\'t have enough money';

  @override
  String get securityScreen => 'Security';

  @override
  String get currentDefenseStatus => 'Current Defense Status';

  @override
  String get noWeapons => 'You have no weapons in your inventory';

  @override
  String get ammoQuantity => 'Ammo Quantity';

  @override
  String get noAmmoRequired => 'No ammunition required for this weapon';

  @override
  String get weaponStats => 'Weapon Stats';

  @override
  String get damage => 'Damage';

  @override
  String get intimidation => 'Intimidation';

  @override
  String get execute => 'Execute';

  @override
  String get hitExecuted => 'Hit executed successfully!';

  @override
  String get invalidAmmo => 'Please enter valid ammo quantity';

  @override
  String get weaponsMarket => 'Weapons Market';

  @override
  String get ammoMarket => 'Ammo Market';

  @override
  String get shootingRange => 'Shooting Range';

  @override
  String get ammoFactory => 'Ammo Factory';

  @override
  String get weaponShop => 'Weapon Shop';

  @override
  String get myWeapons => 'My Weapons';

  @override
  String get weaponPurchased => 'Weapon purchased';

  @override
  String weaponRankRequired(String rank) {
    return 'Rank required: $rank';
  }

  @override
  String get buyWeapon => 'Buy';

  @override
  String get ammoShop => 'Ammo Market';

  @override
  String get myAmmo => 'My Ammo';

  @override
  String get ammoPurchased => 'Ammo purchased';

  @override
  String get purchaseCooldown => 'You must wait before the next purchase';

  @override
  String get insufficientStock => 'Not enough stock available';

  @override
  String get maxInventoryReached => 'Maximum inventory capacity reached';

  @override
  String get invalidQuantity => 'Invalid quantity';

  @override
  String get nextAmmoPurchase => 'Next purchase available in';

  @override
  String get ammoBoxes => 'Boxes';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds rounds per box';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'You will receive: $rounds rounds';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Total cost: €$cost';
  }

  @override
  String get ammoRounds => 'rounds';

  @override
  String get ammoBoxesUnit => 'boxes';

  @override
  String get ammoStock => 'Stock';

  @override
  String get ammoQuality => 'Quality';

  @override
  String get factoryBought => 'Factory purchased';

  @override
  String get factoryProduced => 'Production updated';

  @override
  String get factorySessionStarted =>
      'Production started: active for 8 hours, new ammo every 5 minutes';

  @override
  String get ammoFactoryTitle => 'Ammo Factory';

  @override
  String get ammoFactoryIntro =>
      'Produces automatically every 5 minutes. You can claim up to 8 hours of backlog.';

  @override
  String get ammoFactoryWhatYouCanDo => 'What you can do:';

  @override
  String get ammoFactoryActionBuy => 'Buy a factory in your current country';

  @override
  String get ammoFactoryActionProduce =>
      'Claim production (interval: 5 minutes, max backlog: 8 hours)';

  @override
  String get ammoFactoryActionOutput =>
      'Upgrade output to level 5 (max ±3200 per 8h / ±400 per hour)';

  @override
  String get ammoFactoryActionQuality =>
      'Upgrade quality for stronger market prices';

  @override
  String get factoryUpgradeOutputSuccess => 'Output upgraded';

  @override
  String get factoryUpgradeQualitySuccess => 'Quality upgraded';

  @override
  String get myFactory => 'My Factory';

  @override
  String get noFactoryOwned => 'You do not own a factory';

  @override
  String get factoryCountry => 'Country';

  @override
  String get factoryOutputLevel => 'Output level';

  @override
  String get factoryQualityLevel => 'Quality level';

  @override
  String get factoryLastProduced => 'Last produced';

  @override
  String get factoryProduceStatusLabel => 'Produce status';

  @override
  String get factoryProduceStatusReady => 'Ready';

  @override
  String get factoryProduceStatusCooldown => 'Cooldown';

  @override
  String get factorySessionActive =>
      'Production window: active (5 min interval)';

  @override
  String get factorySessionStopped =>
      'Production window: stopped (click Produce to start a new 8-hour window)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'Window ends in: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Next production: available now (press Produce to claim)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Next production in: $duration';
  }

  @override
  String get factoryProduce => 'Produce';

  @override
  String get factoryUpgradeOutput => 'Upgrade Output';

  @override
  String get factoryUpgradeQuality => 'Upgrade Quality';

  @override
  String get factoryList => 'Factories by Country';

  @override
  String get factoryUnowned => 'Available';

  @override
  String factoryOwnedBy(String owner) {
    return 'Owner: $owner';
  }

  @override
  String get factoryBuy => 'Buy';

  @override
  String get shootingTrainSuccess => 'Training complete';

  @override
  String shootingSessions(String count) {
    return 'Sessions: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Accuracy bonus: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Next session at $time';
  }

  @override
  String get shootingTrain => 'Train';

  @override
  String get gym => 'Gym';

  @override
  String get gymTrainSuccess => 'Training complete';

  @override
  String gymSessions(String count) {
    return 'Sessions: $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Strength bonus: $bonus%';
  }

  @override
  String gymCooldown(String time) {
    return 'Next session at $time';
  }

  @override
  String get gymTrain => 'Train';

  @override
  String get buyAmmo => 'Buy Ammo';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Purchase Cost: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Output per cycle: $amount units';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Quality Multiplier: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Upgrade Output - Cost: €$cost, Next Output: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Upgrade Quality - Cost: €$cost, Next Quality: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Cost';

  @override
  String get factoryCurrentOutput => 'Current Output';

  @override
  String get factoryNextOutput => 'Next Output';

  @override
  String get factoryCurrentQuality => 'Current Quality';

  @override
  String get factoryNextQuality => 'Next Quality';

  @override
  String get factoryUnitsPerCycle => 'units/8h max';

  @override
  String get factoryUnitsPerHour => 'units/hour';

  @override
  String get factoryUpgradeMaxLevel => 'Factory is at max level';

  @override
  String get countryUsa => 'USA';

  @override
  String get countryMexico => 'Mexico';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryBrazil => 'Brazil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryChina => 'China';

  @override
  String get countryRussia => 'Russia';

  @override
  String get countryIndia => 'India';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countrySouthAfrica => 'South Africa';

  @override
  String get countryCanada => 'Canada';

  @override
  String get toolBoltCutter => 'Bolt Cutter';

  @override
  String get toolCarTheftTools => 'Car Theft Tools';

  @override
  String get toolBurglaryKit => 'Burglary Kit';

  @override
  String get toolToolbox => 'Toolbox';

  @override
  String get toolCrowbar => 'Crowbar';

  @override
  String get toolGlassCutter => 'Glass Cutter';

  @override
  String get toolSprayPaint => 'Spray Paint';

  @override
  String get toolJerryCan => 'Jerry Can';

  @override
  String get toolFakeDocuments => 'Fake Documents';

  @override
  String get toolHackingLaptop => 'Hacking Laptop';

  @override
  String get toolCounterfeitingKit => 'Counterfeiting Kit';

  @override
  String get toolRope => 'Rope';

  @override
  String get toolSilencer => 'Silencer';

  @override
  String get toolNightVision => 'Night Vision';

  @override
  String get toolGpsJammer => 'GPS Jammer';

  @override
  String get toolBurnerPhone => 'Burner Phone';

  @override
  String get crimeOutcomeSuccess => 'Crime successful!';

  @override
  String get crimeOutcomeCaught => 'Caught by police';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Your vehicle broke down before reaching the crime scene';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Vehicle broke down during escape - abandoned most loot';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Ran out of fuel during escape - fled on foot, lost loot and vehicle';

  @override
  String get crimeOutcomeToolBroke =>
      'Your tool broke during the crime, leaving evidence';

  @override
  String get crimeOutcomeFledNoLoot => 'Fled the scene without loot';

  @override
  String get vehicleCondition => 'Condition';

  @override
  String get vehicleFuel => 'Fuel';

  @override
  String get vehicleSpeed => 'Speed';

  @override
  String get vehicleArmor => 'Armor';

  @override
  String get vehicleStealth => 'Stealth';

  @override
  String get vehicleCargo => 'Cargo';

  @override
  String get vehicleRepair => 'Repair';

  @override
  String get vehicleRefuel => 'Refuel';

  @override
  String get selectCrimeVehicle => 'Select Vehicle for Crimes';

  @override
  String get noVehicleSelected => 'No vehicle selected';

  @override
  String get selectedVehicle => 'Crime Vehicle';

  @override
  String get changeVehicle => 'Change Vehicle';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get vehicleConditionLow => 'Vehicle Condition Low';

  @override
  String get vehicleFuelLow => 'Vehicle Fuel Low';

  @override
  String get vehicleSelectedForCrimes => 'Vehicle selected for crimes!';

  @override
  String get vehicleDeselectedForCrimes => 'Vehicle deselected for crimes!';

  @override
  String get vehicleWrongCountry =>
      'Vehicle must be in the same country as you';

  @override
  String get failedSelectVehicle => 'Failed to select vehicle';

  @override
  String get failedDeselectVehicle => 'Failed to deselect vehicle';

  @override
  String get selectedForCrimesBadge => 'Selected for crimes';

  @override
  String get selectedButton => 'Selected';

  @override
  String get selectButton => 'Select';

  @override
  String get deselectButton => 'Deselect';

  @override
  String get prostitutionTitle => 'Prostitution';

  @override
  String get prostitutionTotal => 'Total';

  @override
  String get prostitutionStreet => 'On Street';

  @override
  String get prostitutionRedLight => 'Red Light';

  @override
  String get prostitutionPotentialEarnings => 'Earnings';

  @override
  String get prostitutionCollect => 'Collect';

  @override
  String get prostitutionRecruit => 'Recruit';

  @override
  String get prostitutionMyProstitutes => 'My Prostitutes';

  @override
  String get prostitutionRedLightDistricts => 'Red Light Districts';

  @override
  String get prostitutionNoProstitutes => 'No prostitutes recruited yet';

  @override
  String get prostitutionLocation => 'Location';

  @override
  String get prostitutionMoveToRedLight => 'Move to Red Light';

  @override
  String get prostitutionMoveToRldShort => 'To RLD';

  @override
  String get prostitutionMoveToStreet => 'Move to Street';

  @override
  String get prostitutionViewDistricts => 'View Districts';

  @override
  String get prostitutionAvailable => 'Available';

  @override
  String get prostitutionMyDistricts => 'My Districts';

  @override
  String get prostitutionCurrentRLD => 'Current RLD';

  @override
  String get prostitutionMyRLDs => 'My RLDs';

  @override
  String get prostitutionNoAvailableDistricts => 'No districts available';

  @override
  String get prostitutionNoOwnedDistricts => 'You don\'t own any districts yet';

  @override
  String get prostitutionRooms => 'rooms';

  @override
  String get prostitutionOccupancy => 'Occupancy';

  @override
  String get prostitutionIncome => 'Income';

  @override
  String get prostitutionTenants => 'Tenants';

  @override
  String get prostitutionBuy => 'Buy';

  @override
  String get prostitutionManage => 'Manage';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Buy District';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Are you sure you want to buy the Red Light District in $country for €$price?';
  }

  @override
  String get prostitutionPurchase => 'Buy';

  @override
  String get prostitutionPurchaseSuccess => 'District purchased successfully!';

  @override
  String get prostitutionPurchaseFailed => 'Purchase failed';

  @override
  String get prostitutionDistrictManagement => 'District Management';

  @override
  String get prostitutionDistrictNotFound => 'District not found';

  @override
  String get back => 'Back';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Are you sure you want to move $name from the Red Light District to the street?';
  }

  @override
  String get prostitutionMoveSuccess => 'Successfully moved';

  @override
  String get prostitutionMoveFailed => 'Move failed';

  @override
  String get prostitutionNoStreetProstitutes =>
      'No prostitutes available on the street';

  @override
  String get prostitutionSelectProstitute => 'Select Prostitute';

  @override
  String get prostitutionOnStreet => 'On street';

  @override
  String get prostitutionRoom => 'Room';

  @override
  String get prostitutionInRedLight => 'In Red Light District';

  @override
  String get prostitutionEarnings => 'Earnings';

  @override
  String get prostitutionRent => 'Rent';

  @override
  String get prostitutionNetIncome => 'Net Income';

  @override
  String get prostitutionLevel => 'Level';

  @override
  String get prostitutionXpToNext => 'XP to next level';

  @override
  String get prostitutionBusted => 'BUSTED';

  @override
  String get prostitutionBustedCount => 'Times busted';

  @override
  String get prostitutionLevelBonus => 'Level bonus';

  @override
  String get prostitutionVipBonus => 'VIP bonus: +50% earnings';

  @override
  String get prostitutionUpgradeTier => 'Upgrade Tier';

  @override
  String get prostitutionUpgradeSecurity => 'Upgrade Security';

  @override
  String get prostitutionTier => 'Tier';

  @override
  String get prostitutionSecurity => 'Security';

  @override
  String get prostitutionTierBasic => 'Basic';

  @override
  String get prostitutionTierLuxury => 'Luxury';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Security Level';

  @override
  String get prostitutionRaidChance => 'Raid Chance';

  @override
  String get prostitutionMaxTier => 'Max tier reached';

  @override
  String get prostitutionMaxSecurity => 'Max security reached';

  @override
  String get prostitutionUpgradeSuccess => 'Upgrade successful!';

  @override
  String get prostitutionUpgradeFailed => 'Upgrade failed';

  @override
  String get vipEventsTitle => 'VIP Events';

  @override
  String get vipEventsTabTitle => 'VIP Events';

  @override
  String get vipEventsDescription =>
      'Assign prostitutes to VIP events for bonus earnings!';

  @override
  String get vipEventsActive => 'Active Events';

  @override
  String get vipEventsUpcoming => 'Upcoming Events';

  @override
  String get vipEventsMyParticipations => 'My Active Participations';

  @override
  String get vipEventTypeTitle => 'VIP Event';

  @override
  String get vipEventCelebrity => 'Celebrity Visit';

  @override
  String get vipEventBachelor => 'Bachelor Party';

  @override
  String get vipEventConvention => 'Convention';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'BONUS';

  @override
  String get vipEventSpots => 'spots';

  @override
  String get vipEventParticipants => 'Participants';

  @override
  String get vipEventFull => 'EVENT FULL';

  @override
  String get vipEventRequires => 'Requires';

  @override
  String get vipEventLevel => 'Level';

  @override
  String get vipEventLocation => 'Location';

  @override
  String get vipEventEndsIn => 'Ends in';

  @override
  String get vipEventStartsIn => 'Starts in';

  @override
  String get vipEventNoActive => 'No active events at the moment';

  @override
  String get vipEventNoUpcoming => 'No upcoming events';

  @override
  String get vipEventAssignProstitute => 'Assign Prostitute';

  @override
  String get vipEventAssignDialogTitle => 'Assign to';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'No eligible prostitutes. Need level $level+ in $country';
  }

  @override
  String get vipEventJoinSuccess => 'Joined event!';

  @override
  String get vipEventJoinFailed => 'Failed to join event';

  @override
  String get vipEventLeave => 'Leave Event';

  @override
  String get vipEventLeaveSuccess => 'Left event';

  @override
  String get vipEventLeaveFailed => 'Could not leave event';

  @override
  String get vipEventAssigned => 'Assigned';

  @override
  String get vipEventPerHour => '/hour';

  @override
  String get vipEventEarnings => 'Earnings';

  @override
  String get prostitutionLeaderboardTitle => 'Prostitution Leaderboard';

  @override
  String get prostitutionLeaderboardWeekly => 'Weekly';

  @override
  String get prostitutionLeaderboardMonthly => 'Monthly';

  @override
  String get prostitutionLeaderboardAllTime => 'All-Time';

  @override
  String get prostitutionLeaderboardYourRank => 'Your Weekly Rank';

  @override
  String get prostitutionLeaderboardUnranked => 'Unranked';

  @override
  String get prostitutionLeaderboardNoData => 'No leaderboard data yet';

  @override
  String get prostitutionLeaderboardButton => 'Leaderboard';

  @override
  String get prostitutionRivalryButton => 'Rivalry';

  @override
  String get prostitutionLeaderboardAchievements => 'Achievements';

  @override
  String get prostitutionLeaderboardLoadFailed => 'Could not load leaderboard';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked of $total unlocked';
  }

  @override
  String get achievementsCategoryAll => 'All';

  @override
  String get achievementsCategoryProgression => 'Progression';

  @override
  String get achievementsCategoryWealth => 'Wealth';

  @override
  String get achievementsCategoryPower => 'Power';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMastery => 'Mastery';

  @override
  String get achievementLocked => 'Locked';

  @override
  String get achievementReward => 'Reward';

  @override
  String get achievementUnlocked => 'Unlocked';

  @override
  String get achievementNoData => 'No achievements found';

  @override
  String get achievementLoadFailed => 'Could not load achievements';

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
    return 'Unlocked on $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Progress: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured => 'No reward configured yet';

  @override
  String get achievementsRewardOnUnlock =>
      'You receive this reward once the achievement is unlocked.';

  @override
  String get achievementsDateToday => 'Today';

  @override
  String get achievementsDateYesterday => 'Yesterday';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get achievementsDetails => 'Details';

  @override
  String get achievementsCategory => 'Category';

  @override
  String get achievementJobItSpecialistTitle => 'IT Specialist';

  @override
  String get achievementJobItSpecialistDescription =>
      'Complete your first shift as a Programmer';

  @override
  String get achievementJobLawyerTitle => 'Street Lawyer';

  @override
  String get achievementJobLawyerDescription =>
      'Complete your first shift as a Lawyer';

  @override
  String get achievementJobDoctorTitle => 'Underground Doctor';

  @override
  String get achievementJobDoctorDescription =>
      'Complete your first shift as a Doctor';

  @override
  String get achievementSchoolCertifiedTitle => 'Certified Student';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Earn 3 school certifications';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multi-Certified';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Earn 6 school certifications';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Track Specialist';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Max out 3 school tracks';

  @override
  String get schoolMenuLabel => 'School';

  @override
  String get schoolMenuSubtitle => 'Level your education and certifications';

  @override
  String get schoolTitle => 'School & Education';

  @override
  String get schoolIntro =>
      'Unlock jobs and assets through levels and certifications.';

  @override
  String get schoolTracksTitle => 'Available educations';

  @override
  String get schoolUnlockableContentTitle => 'Locked educations';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'School level: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Could not load school data: $error';
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
    return 'Player rank: $current/$required';
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
  String get schoolGateAssetCasinoPurchase => 'Asset: Casino purchase';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Asset: Ammo factory purchase';

  @override
  String get schoolGateAssetAmmoOutputUpgrade => 'Asset: Ammo output upgrade';

  @override
  String get schoolGateAssetAmmoQualityUpgrade => 'Asset: Ammo quality upgrade';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Asset: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Education required';

  @override
  String get educationDialogFallbackMessage =>
      'Requirements not met. Complete education requirements to continue.';

  @override
  String get educationDialogClose => 'Close';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Locked jobs (education required)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Output upgrade locked';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Quality upgrade locked';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Factory purchase locked';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Need player rank $requiredRank · Current player rank $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Education level';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName level $requiredLevel required · Current $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle => 'Certification required';

  @override
  String get educationRequirementGenericTitle => 'Requirement';

  @override
  String get educationRequirementUnknown => 'Unknown requirement';

  @override
  String get educationTrackNameAviation => 'Aviation';

  @override
  String get educationTrackNameLaw => 'Law';

  @override
  String get educationTrackNameMedicine => 'Medicine';

  @override
  String get educationTrackNameFinance => 'Finance';

  @override
  String get educationTrackNameEngineering => 'Engineering';

  @override
  String get educationTrackNameIt => 'IT';

  @override
  String get schoolTrackDescriptionAviation =>
      'Flight theory, navigation, and aircraft operation.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Criminal law, procedure, and courtroom practice.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Emergency response, diagnostics, and medical practice.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Accounting, investment, and business operations.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Mechanical systems, industrial safety, and manufacturing.';

  @override
  String get schoolTrackDescriptionIt =>
      'Software development, systems, and network operations.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown active: ${seconds}s remaining';
  }

  @override
  String get schoolTrackMaxLevelReached => 'Track is already at max level';

  @override
  String get schoolTrackStartFailed => 'Failed to start training';

  @override
  String get educationCertSoftwareEngineer => 'Software Engineer Certification';

  @override
  String get educationCertBarExam => 'Bar Exam';

  @override
  String get educationCertMedicalLicense => 'Medical License';

  @override
  String get educationCertFlightCommercial => 'Commercial Flight License';

  @override
  String get educationCertFlightBasic => 'Basic Flight License';

  @override
  String get educationCertIndustrialSafety => 'Industrial Safety Certification';

  @override
  String get educationCertFinancialAnalyst => 'Financial Analyst Certification';

  @override
  String get educationCertCasinoManagement => 'Casino Management Certification';

  @override
  String get educationCertParamedic => 'Paramedic Certification';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostitutes';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'districts';

  @override
  String get rivalryTitle => 'Rivalry';

  @override
  String get rivalryChallengeTitle => 'Challenge Player';

  @override
  String get rivalryChallengeHint => 'Enter a player ID to start a rivalry.';

  @override
  String get rivalryPlayerIdHint => 'Player ID';

  @override
  String get rivalryStartButton => 'Start';

  @override
  String get rivalryNoActive => 'No active rivalries yet.';

  @override
  String get rivalryActiveTitle => 'Active Rivals';

  @override
  String get rivalryScoreLabel => 'Rivalry score';

  @override
  String get rivalryRecentActivity => 'Recent Activity';

  @override
  String get rivalryNoActivity => 'No sabotage activity yet';

  @override
  String get rivalryCooldownReady => 'Sabotage ready';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Cooldown: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Tip Police (€5k)';

  @override
  String get rivalryActionStealCustomer => 'Steal Customer (€3k)';

  @override
  String get rivalryActionDamageReputation => 'Damage Reputation (€10k)';

  @override
  String get rivalryActionBribeEmployee => 'Bribe Employee (€8k)';

  @override
  String get rivalryUpdateMessage => 'Rivalry updated';

  @override
  String get rivalrySabotageExecuted => 'Sabotage executed';

  @override
  String get rivalryConfirmTitle => 'Confirm sabotage';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Target: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Action: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Cost: €$amount';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Effect: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'Success is not guaranteed and you can lose money.';

  @override
  String get rivalryExecuteButton => 'Execute';

  @override
  String get rivalryEffectTipPolice => 'Increase rival police pressure';

  @override
  String get rivalryEffectStealCustomer => 'Steal part of rival cashflow';

  @override
  String get rivalryEffectDamageReputation => 'Lower rival prostitute progress';

  @override
  String get rivalryEffectBribeEmployee =>
      'Force one rival prostitute into busted state';

  @override
  String get prostitutionUnderAttackTitle => 'Your empire is under attack';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker used $action against you in the last 24h.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Open rivalry';

  @override
  String get rivalryProtectionTitle => 'Protection Insurance';

  @override
  String get rivalryProtectionDescription =>
      'Reduces incoming sabotage impact by 30% for 7 days.';

  @override
  String get rivalryProtectionInactive => 'No active protection';

  @override
  String rivalryProtectionActive(String date) {
    return 'Active until: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Buy protection (€25k/week)';

  @override
  String get rivalryProtectionActivated => 'Protection insurance activated';

  @override
  String get achievementTitle_first_steps => 'First Steps';

  @override
  String get achievementDescription_first_steps =>
      'Recruit your first prostitute';

  @override
  String get achievementTitle_growing_empire => 'Growing Empire';

  @override
  String get achievementDescription_growing_empire => 'Recruit 5 prostitutes';

  @override
  String get achievementTitle_first_district => 'First District';

  @override
  String get achievementDescription_first_district =>
      'Purchase your first red light district';

  @override
  String get achievementTitle_empire_builder => 'Empire Builder';

  @override
  String get achievementDescription_empire_builder =>
      'Own 5 red light districts';

  @override
  String get achievementTitle_district_master => 'District Master';

  @override
  String get achievementDescription_district_master =>
      'Own 10 red light districts';

  @override
  String get achievementTitle_leveling_master => 'Leveling Master';

  @override
  String get achievementDescription_leveling_master =>
      'Max out a prostitute to level 10';

  @override
  String get achievementTitle_untouchable => 'Untouchable';

  @override
  String get achievementDescription_untouchable =>
      'Never get busted for 7 consecutive days';

  @override
  String get achievementTitle_millionaire => 'Millionaire';

  @override
  String get achievementDescription_millionaire =>
      'Accumulate €1,000,000 total earnings';

  @override
  String get achievementTitle_high_roller => 'High Roller';

  @override
  String get achievementDescription_high_roller =>
      'Accumulate €5,000,000 total earnings';

  @override
  String get achievementTitle_vip_service => 'VIP Service';

  @override
  String get achievementDescription_vip_service => 'Complete 10 VIP events';

  @override
  String get achievementTitle_event_enthusiast => 'Event Enthusiast';

  @override
  String get achievementDescription_event_enthusiast =>
      'Complete 25 VIP events';

  @override
  String get achievementTitle_security_expert => 'Security Expert';

  @override
  String get achievementDescription_security_expert =>
      'Maximize security level on all owned districts';

  @override
  String get achievementTitle_luxury_provider => 'Luxury Provider';

  @override
  String get achievementDescription_luxury_provider =>
      'Upgrade 3 districts to VIP tier';

  @override
  String get achievementTitle_rivalry_victor => 'Rivalry Victor';

  @override
  String get achievementDescription_rivalry_victor =>
      'Successfully sabotage rivals 10 times';

  @override
  String get achievementTitle_untouchable_rival => 'Untouchable Rival';

  @override
  String get achievementDescription_untouchable_rival =>
      'Defend against 20 sabotage attempts';

  @override
  String get achievementTitle_crime_first_blood => 'Crime First Blood';

  @override
  String get achievementDescription_crime_first_blood =>
      'Successfully complete your first crime';

  @override
  String get achievementTitle_crime_hustler => 'Crime Hustler';

  @override
  String get achievementDescription_crime_hustler =>
      'Successfully complete 5 crimes';

  @override
  String get achievementTitle_crime_novice => 'Crime Novice';

  @override
  String get achievementDescription_crime_novice =>
      'Successfully complete 10 crimes';

  @override
  String get achievementTitle_crime_operator => 'Crime Operator';

  @override
  String get achievementDescription_crime_operator =>
      'Successfully complete 25 crimes';

  @override
  String get achievementTitle_crime_wave => 'Crime Wave';

  @override
  String get achievementDescription_crime_wave =>
      'Successfully complete 50 crimes';

  @override
  String get achievementTitle_crime_mastermind => 'Crime Mastermind';

  @override
  String get achievementDescription_crime_mastermind =>
      'Successfully complete 100 crimes';

  @override
  String get achievementTitle_the_godfather => 'The Godfather';

  @override
  String get achievementDescription_the_godfather =>
      'Successfully complete 250 crimes';

  @override
  String get achievementTitle_crime_emperor => 'Crime Emperor';

  @override
  String get achievementDescription_crime_emperor =>
      'Successfully complete 500 crimes';

  @override
  String get achievementTitle_crime_legend => 'Crime Legend';

  @override
  String get achievementDescription_crime_legend =>
      'Successfully complete 1000 crimes';

  @override
  String get achievementTitle_crime_getaway_driver => 'Getaway Driver';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Successfully complete your first crime with a vehicle';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Armed & Ready';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Successfully complete your first crime that requires a weapon';

  @override
  String get achievementTitle_crime_full_loadout => 'Full Loadout';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Successfully complete a crime requiring vehicle, weapon, and tools';

  @override
  String get achievementTitle_crime_completionist => 'Crime Completionist';

  @override
  String get achievementDescription_crime_completionist =>
      'Successfully complete every crime type at least once';

  @override
  String get achievementTitle_job_first_shift => 'First Shift';

  @override
  String get achievementDescription_job_first_shift =>
      'Successfully complete your first job';

  @override
  String get achievementTitle_job_hustler => 'Job Hustler';

  @override
  String get achievementDescription_job_hustler =>
      'Successfully complete 5 jobs';

  @override
  String get achievementTitle_job_starter => 'Job Starter';

  @override
  String get achievementDescription_job_starter =>
      'Successfully complete 10 jobs';

  @override
  String get achievementTitle_job_operator => 'Job Operator';

  @override
  String get achievementDescription_job_operator =>
      'Successfully complete 25 jobs';

  @override
  String get achievementTitle_job_grinder => 'Job Grinder';

  @override
  String get achievementDescription_job_grinder =>
      'Successfully complete 50 jobs';

  @override
  String get achievementTitle_job_master => 'Job Master';

  @override
  String get achievementDescription_job_master =>
      'Successfully complete 100 jobs';

  @override
  String get achievementTitle_job_expert => 'Job Expert';

  @override
  String get achievementDescription_job_expert =>
      'Successfully complete 250 jobs';

  @override
  String get achievementTitle_job_elite => 'Job Elite';

  @override
  String get achievementDescription_job_elite =>
      'Successfully complete 500 jobs';

  @override
  String get achievementTitle_job_legend => 'Job Legend';

  @override
  String get achievementDescription_job_legend =>
      'Successfully complete 1000 jobs';

  @override
  String get achievementTitle_job_completionist => 'Job Completionist';

  @override
  String get achievementDescription_job_completionist =>
      'Successfully complete every job type at least once';

  @override
  String get achievementTitle_job_educated_worker => 'Educated Worker';

  @override
  String get achievementDescription_job_educated_worker =>
      'Complete 1 job that has education requirements';

  @override
  String get achievementTitle_job_certified_hustler => 'Certified Hustler';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Complete 25 jobs with education requirements';

  @override
  String get achievementTitle_job_education_completionist =>
      'Education Job Completionist';

  @override
  String get achievementDescription_job_education_completionist =>
      'Complete every education-gated job type at least once';

  @override
  String get achievementTitle_job_it_specialist => 'IT Specialist';

  @override
  String get achievementDescription_job_it_specialist =>
      'Complete your first shift as a Programmer';

  @override
  String get achievementTitle_job_lawyer => 'Street Lawyer';

  @override
  String get achievementDescription_job_lawyer =>
      'Complete your first shift as a Lawyer';

  @override
  String get achievementTitle_job_doctor => 'Underground Doctor';

  @override
  String get achievementDescription_job_doctor =>
      'Complete your first shift as a Doctor';

  @override
  String get achievementTitle_school_certified => 'Certified Student';

  @override
  String get achievementDescription_school_certified =>
      'Earn 3 school certifications';

  @override
  String get achievementTitle_school_multi_certified => 'Multi-Certified';

  @override
  String get achievementDescription_school_multi_certified =>
      'Earn 6 school certifications';

  @override
  String get achievementTitle_school_track_specialist => 'Track Specialist';

  @override
  String get achievementDescription_school_track_specialist =>
      'Max out 3 school tracks';

  @override
  String get achievementTitle_school_freshman => 'School Freshman';

  @override
  String get achievementDescription_school_freshman =>
      'Reach education level 1';

  @override
  String get achievementTitle_school_scholar => 'School Scholar';

  @override
  String get achievementDescription_school_scholar => 'Reach education level 3';

  @override
  String get achievementTitle_school_graduate => 'School Graduate';

  @override
  String get achievementDescription_school_graduate =>
      'Reach education level 5';

  @override
  String get achievementTitle_school_mastermind => 'Academic Mastermind';

  @override
  String get achievementDescription_school_mastermind =>
      'Reach education level 10';

  @override
  String get achievementTitle_school_doctorate => 'Street Doctorate';

  @override
  String get achievementDescription_school_doctorate =>
      'Reach education level 20';

  @override
  String get achievementTitle_road_bandit => 'Road Bandit';

  @override
  String get achievementDescription_road_bandit => 'Steal 5 cars';

  @override
  String get achievementTitle_grand_theft_fleet => 'Grand Theft Fleet';

  @override
  String get achievementDescription_grand_theft_fleet => 'Steal 25 cars';

  @override
  String get achievementTitle_sea_raider => 'Sea Raider';

  @override
  String get achievementDescription_sea_raider => 'Steal 3 boats';

  @override
  String get achievementTitle_captain_of_smugglers => 'Captain of Smugglers';

  @override
  String get achievementDescription_captain_of_smugglers => 'Steal 12 boats';

  @override
  String get achievementTitle_globe_trotter => 'Globe Trotter';

  @override
  String get achievementDescription_globe_trotter => 'Complete 5 journeys';

  @override
  String get achievementTitle_jet_setter => 'Jet Setter';

  @override
  String get achievementDescription_jet_setter => 'Complete 25 journeys';

  @override
  String get achievementTitle_chemist_apprentice => 'Chemist Apprentice';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Complete 10 drug productions';

  @override
  String get achievementTitle_narco_chemist => 'Narco Chemist';

  @override
  String get achievementDescription_narco_chemist =>
      'Complete 100 drug productions';

  @override
  String get achievementTitle_street_merchant => 'Street Merchant';

  @override
  String get achievementDescription_street_merchant => 'Complete 25 trades';

  @override
  String get achievementTitle_trade_tycoon => 'Trade Tycoon';

  @override
  String get achievementDescription_trade_tycoon => 'Complete 150 trades';

  @override
  String get achievementTitle_prostitute_lineup => 'Lineup Built';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Recruit 10 prostitutes';

  @override
  String get achievementTitle_prostitute_network => 'Street Network';

  @override
  String get achievementDescription_prostitute_network =>
      'Recruit 25 prostitutes';

  @override
  String get achievementTitle_prostitute_syndicate => 'Syndicate';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Recruit 50 prostitutes';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dynasty';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Recruit 100 prostitutes';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Empire 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recruit 250 prostitutes';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Cartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recruit 500 prostitutes';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Legend 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recruit 1000 prostitutes';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP Beginner';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Reach level 3 with a VIP prostitute';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'VIP Headliner';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Reach level 5 with a VIP prostitute';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'VIP Icon';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Reach level 7 with a VIP prostitute';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'VIP Legend';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Reach level 10 with a VIP prostitute';

  @override
  String get achievementTitle_nightclub_opening_night => 'Opening Night';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Open your first nightclub venue';

  @override
  String get achievementTitle_nightclub_headliner => 'Headliner Booker';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Book 10 DJ shifts for your nightclub empire';

  @override
  String get achievementTitle_nightclub_full_house => 'Full House';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Push a nightclub crowd to 90% capacity';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Cash Machine';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Earn €250,000 total nightclub revenue';

  @override
  String get achievementTitle_nightclub_empire => 'Nightlife Empire';

  @override
  String get achievementDescription_nightclub_empire =>
      'Earn €1,000,000 total nightclub revenue';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Staffing Boss';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Run 3 active nightclub crew members at the same time';

  @override
  String get achievementTitle_nightclub_vip_room => 'VIP Room';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Assign 2 VIP crew members to your nightclub';

  @override
  String get achievementTitle_nightclub_head_of_security => 'Head of Security';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Hire nightclub security for 10 shifts';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Podium Finish';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Finish in the top 3 of a weekly nightclub season';

  @override
  String get achievementTitle_nightclub_season_champion => 'Season Champion';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Win a weekly nightclub season';

  @override
  String get nightclubManagementTitle => 'Nightclub Management';

  @override
  String get nightclubRealtimeStatus => 'Realtime status active';

  @override
  String get nightclubRefresh => 'Refresh';

  @override
  String get nightclubEmptyTitle => 'No nightclub found yet';

  @override
  String get nightclubEmptyBody =>
      'Buy a nightclub in Properties first to activate this system.';

  @override
  String get nightclubLocationTitle => 'Nightclub Location';

  @override
  String get nightclubSelectVenue => 'Select venue';

  @override
  String get nightclubLiveStatistics => 'Live Statistics';

  @override
  String get nightclubKpiCrowd => 'Crowd';

  @override
  String get nightclubKpiVibe => 'Vibe';

  @override
  String get nightclubKpiToday => 'Today';

  @override
  String get nightclubKpiAllTime => 'All-time';

  @override
  String get nightclubKpiStock => 'Stock';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Thefts';

  @override
  String get nightclubKpiStaff => 'Staff';

  @override
  String get nightclubKpiSalesBoost => 'Sales boost';

  @override
  String get nightclubKpiPriceBoost => 'Price boost';

  @override
  String get nightclubKpiVipBonus => 'VIP bonus';

  @override
  String get nightclubStatusActive => 'Active';

  @override
  String get nightclubStatusOff => 'Off';

  @override
  String get nightclubStatusActiveLower => 'active';

  @override
  String get nightclubRevenueTrend => 'Revenue Trend (live)';

  @override
  String get nightclubLeaderboardTitle => 'Top Nightclubs';

  @override
  String get nightclubLeaderboardCountry => 'Country';

  @override
  String get nightclubLeaderboardGlobal => 'Global';

  @override
  String get nightclubLeaderboardEmpty => 'No leaderboard data yet';

  @override
  String get nightclubLeaderboardRevenue24h => '24h revenue';

  @override
  String get nightclubSeasonProcessing => 'processing...';

  @override
  String get nightclubSeasonTitle => 'Weekly Season Ranking';

  @override
  String get nightclubSeasonResetIn => 'Reset in';

  @override
  String get nightclubSeasonYourRewards => 'Your season rewards';

  @override
  String get nightclubSeasonCurrentTop5 => 'Current week top 5';

  @override
  String get nightclubSeasonEmpty => 'No season data yet';

  @override
  String get nightclubSeasonWeekRevenue => 'Week revenue';

  @override
  String get nightclubSeasonScore => 'Score';

  @override
  String get nightclubSeasonRecentPayouts => 'Recent payouts';

  @override
  String get nightclubSeasonNoPayouts => 'No payouts yet';

  @override
  String get nightclubSalesTitle => 'Recent Sales';

  @override
  String get nightclubSalesEmpty => 'No sales data yet';

  @override
  String get nightclubTheftTitle => 'Theft Log';

  @override
  String get nightclubTheftEmpty => 'No thefts recorded';

  @override
  String get nightclubTheftLoss => 'Loss';

  @override
  String get nightclubStaffTitle => 'Pimp Crew in Club';

  @override
  String get nightclubStaffVipExtraActive => ' (VIP +2 active)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capacity: $assigned/$cap$vipSuffix';
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
    return 'Boost mix: sales x$sales | price x$price | vibe x$vibe | security x$security | vip player x$vipPlayer | vip staff x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Select crew member';

  @override
  String get nightclubAssignShift => 'Assign to nightclub shift';

  @override
  String get nightclubTabActive => 'Active';

  @override
  String get nightclubTabHistory => 'History';

  @override
  String get nightclubNoCrewAssigned => 'No crew assigned yet';

  @override
  String get nightclubCrewBoostDescription =>
      'Boosts demand and margin in your club';

  @override
  String get nightclubRemove => 'Remove';

  @override
  String get nightclubNoStaffHistory => 'No staffing history yet';

  @override
  String get nightclubFrom => 'From';

  @override
  String get nightclubTo => 'To';

  @override
  String get nightclubRevenueImpact => 'Revenue impact';

  @override
  String get nightclubSalesCountLabel => 'sales';

  @override
  String get nightclubDjTitle => 'Hire DJ';

  @override
  String get nightclubChooseDj => 'Choose DJ';

  @override
  String get nightclubShiftLength => 'Shift length';

  @override
  String get nightclubHireDj => 'Hire DJ';

  @override
  String get nightclubSecurityTitle => 'Security';

  @override
  String get nightclubChooseSecurity => 'Choose security';

  @override
  String get nightclubHireSecurity => 'Hire security';

  @override
  String get nightclubStoreTitle => 'Store Drugs';

  @override
  String get nightclubChooseStock => 'Choose stock';

  @override
  String get nightclubAmountGrams => 'Amount in grams';

  @override
  String get nightclubStoreButton => 'Store in nightclub';

  @override
  String get nightclubHireDjSuccess => 'DJ hired';

  @override
  String get nightclubHireSecuritySuccess => 'Security hired';

  @override
  String get nightclubAssignCrewSuccess => 'Crew member assigned';

  @override
  String get nightclubRemoveCrewSuccess => 'Crew member removed';

  @override
  String get nightclubStoreDrugsSuccess => 'Drugs stored';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Season payout received';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Your nightclub finished at rank #$rank this week.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Reward: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Weekly revenue: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Theft loss: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Close';

  @override
  String get nightclubVibeChill => 'Chill';

  @override
  String get nightclubVibeNormal => 'Normal';

  @override
  String get nightclubVibeWild => 'Wild';

  @override
  String get nightclubVibeRaging => 'Raging';

  @override
  String get nightclubTheftTypeCustomer => 'Customer theft';

  @override
  String get nightclubTheftTypeEmployee => 'Employee heist';

  @override
  String get nightclubTheftTypeRival => 'Rival sabotage';
}
