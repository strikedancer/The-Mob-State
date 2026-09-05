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
  String get dashboardTimeoutGym => 'Gym (soonest)';

  @override
  String get dashboardTimeoutGymStrength => 'Gym: strength';

  @override
  String get dashboardTimeoutGymSpeed => 'Gym: speed';

  @override
  String get dashboardTimeoutGymStamina => 'Gym: stamina';

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
  String get crimeEliminateWitnessName => 'Eliminate Witness';

  @override
  String get crimeEliminateWitnessDesc => 'Eliminate a witness before trial';

  @override
  String get crimeDiamondHeistName => 'Diamond Transport Heist';

  @override
  String get crimeDiamondHeistDesc => 'Hijack a transport of rough diamonds';

  @override
  String get crimeEvidenceRoomHeistName => 'Evidence Room Heist';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Steal evidence from a federal storage facility';

  @override
  String get crimeMuseumHeistName => 'Museum Heist';

  @override
  String get crimeMuseumHeistDesc => 'Steal valuable artifacts from a museum';

  @override
  String get crimeBossAssassinationName => 'Rival Boss Assassination';

  @override
  String get crimeBossAssassinationDesc =>
      'Eliminate the leader of a rival organization';

  @override
  String get crimeCriminalRecordWipeName => 'Wipe Criminal Record';

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
  String get tooltipCrimeRequiresWeapon => 'Weapon required';

  @override
  String get tooltipCrimeRequirementsHeading => 'Required:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Wipes your full criminal record on success. Only available if you already have convictions.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'You need at least ${quantity}g of: $drugs';
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
  String jobSuccessChancePercent(String percent) {
    return '$percent% chance';
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
  String get travelNotInTransit => 'You are not on a journey.';

  @override
  String get travelDirect => 'Direct';

  @override
  String get travelHeroTitle => 'The road';

  @override
  String get travelHeroSubtitle =>
      'Move between countries for markets, crimes and trade. Each leg costs cash and can get you searched.';

  @override
  String get travelHereChip => 'You are here';

  @override
  String travelDestinationsChip(String count) {
    return '$count destinations';
  }

  @override
  String travelWantedChip(String level) {
    return 'Wanted $level';
  }

  @override
  String travelFbiChip(String level) {
    return 'FBI $level';
  }

  @override
  String get travelCannotAfford => 'Not enough cash';

  @override
  String travelAircraftBonusChip(String percent) {
    return 'Own aircraft: −$percent% travel time';
  }

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
  String get logOut => 'Log out';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Account';

  @override
  String get userAccountMenuTooltip => 'Account menu';

  @override
  String get myProfile => 'My profile';

  @override
  String get messages => 'Messages';

  @override
  String get noDirectMessagesYet => 'No messages yet';

  @override
  String get sendMessageToFriendsHint => 'Send a message to your friends!';

  @override
  String errorLoadingConversations(String error) {
    return 'Error loading conversations: $error';
  }

  @override
  String get messageSystemBadge => 'SYSTEM';

  @override
  String get messageSystemInboxPreview => 'Achievements and system messages';

  @override
  String get messageSystemThreadSubtitle => 'Achievements and system messages';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Achievements and system messages appear here automatically.';

  @override
  String get messageSendFirst => 'Send the first message!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Rank $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Error loading messages: $error';
  }

  @override
  String get messageDeleteOwnOnly => 'You can only delete your own messages';

  @override
  String get messageDeleteTitle => 'Delete message';

  @override
  String get messageDeleteBody => 'This message will be permanently deleted.';

  @override
  String get messageSendFailed => 'Failed to send message';

  @override
  String get messageDeleteFailed => 'Failed to delete message';

  @override
  String get investigationWindowExpired =>
      'Investigation window expired (24 hours).';

  @override
  String get investigationStartedInboxHint =>
      'Investigation started. Check your inbox for the detective report.';

  @override
  String get investigationAlreadyInProgress =>
      'This investigation is already in progress or completed.';

  @override
  String investigationStartFailed(String error) {
    return 'Failed to start investigation: $error';
  }

  @override
  String get investigationExpired => 'Investigation expired';

  @override
  String get investigationStarted => 'Investigation started';

  @override
  String get investigationStarting => 'Starting...';

  @override
  String get startMurderInvestigation => 'Start murder investigation';

  @override
  String get systemMessagesReadOnlyHint =>
      'System messages cannot be replied to';

  @override
  String get helpAndGuide => 'Help & Guide';

  @override
  String get helpUiManualTitle => 'Game manual';

  @override
  String get helpUiSearchHint => 'Search by module, explanation or tip';

  @override
  String get helpUiTopicLabel => 'Topic';

  @override
  String get helpUiAllChip => 'All';

  @override
  String get helpUiNoResultsTitle => 'No topics found';

  @override
  String get helpUiNoResultsBody =>
      'Change your search or category to see results again.';

  @override
  String get helpUiHowItWorks => 'How it works';

  @override
  String get helpUiTips => 'Tips';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get mobileNavCrimes => 'Crimes';

  @override
  String get mobileNavSteal => 'Steal';

  @override
  String get mobileNavWork => 'Work';

  @override
  String get mobileNavBank => 'Bank';

  @override
  String get mobileNavCrew => 'Crew';

  @override
  String get mobileNavReady => 'Ready';

  @override
  String get menuSearchHint => 'Search menu';

  @override
  String get menuSearchNoResults => 'No matching pages';

  @override
  String get menuNavCategoryActions => 'Actions';

  @override
  String get menuNavCategoryWorld => 'World';

  @override
  String get menuNavCategorySocial => 'Social';

  @override
  String get menuNavCategoryEconomy => 'Economy';

  @override
  String get menuNavCategoryEmpire => 'Empire';

  @override
  String get menuNavCategoryAssets => 'Assets';

  @override
  String get menuNavCategoryMore => 'More';

  @override
  String get liveEvents => 'My activity';

  @override
  String get worldFeedHint => 'Only your recent actions.';

  @override
  String get support => 'Support';

  @override
  String get events => 'Events';

  @override
  String get liveEventRailOpenEvents => 'Open events';

  @override
  String seasonPassTitle(String season) {
    return 'Event Pass $season';
  }

  @override
  String get seasonPassSubtitle =>
      '56 monthly goals across crimes, vehicles, smuggling, drugs, cash earned, XP and prostitution recruits. Free event prize and Event Pass bonus (premium) per row.';

  @override
  String seasonPassGoalProstitution(int count) {
    return 'Recruit $count workers';
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
  String get seasonPassBuyCta => 'Unlock Event Pass · €7.99';

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
  String get seasonPassClaimSuccess => 'Event Pass reward claimed';

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
  String get aviation => 'Aviation';

  @override
  String get premiumAndCredits => 'Premium & Credits';

  @override
  String get bank => 'Bank';

  @override
  String get tradeGoods => 'Trade goods';

  @override
  String get drugs => 'Drugs';

  @override
  String get nightclub => 'Nightclub';

  @override
  String get crypto => 'Crypto';

  @override
  String get smuggling => 'Smuggling';

  @override
  String get tools => 'tools';

  @override
  String get vehicleHeist => 'Vehicle Heist';

  @override
  String get vehicleHeistTitle => 'Vehicle Heist';

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
  String get vehicleHeistTabSubtitleCar => 'Steal cars for cash and parts.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Steal motorcycles for cash and parts.';

  @override
  String get vehicleHeistTabSubtitleBoat => 'Steal boats for cash and parts.';

  @override
  String get vehicleHeistReady => 'Ready';

  @override
  String get vehicleHeistMotorStorage => 'Motorcycle storage';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'Car capacity is shared across all car heists.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'Motorcycle capacity is shared across all motorcycle heists.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'Boat capacity is shared across all boat heists.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Rank required: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Storage: $stored/$total (lane lvl $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Steal car';

  @override
  String get vehicleHeistStealMotorcycle => 'Steal motorcycle';

  @override
  String get vehicleHeistStealBoat => 'Steal boat';

  @override
  String get vehicleHeistGenericVehicle => 'vehicle';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Success: $vehicle stolen.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Cooldown active: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'You got arrested ($minutes min jail).';
  }

  @override
  String get vehicleHeistUntil => 'until';

  @override
  String get vehicleHeistRegionalLockActive => 'Regional lock active.';

  @override
  String get vehicleHeistStealFailed => 'Steal action failed.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Upgrade completed.';

  @override
  String get vehicleHeistUpgradeFailed => 'Upgrade failed.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Available cars';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Available motorcycles';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Available boats';

  @override
  String get vehicleHeistCatalogEmpty => 'No vehicles in this catalog.';

  @override
  String get vehicleHeistRarityCommon => 'Common';

  @override
  String get vehicleHeistRarityUncommon => 'Uncommon';

  @override
  String get vehicleHeistRarityRare => 'Rare';

  @override
  String get vehicleHeistRarityEpic => 'Epic';

  @override
  String get vehicleHeistRarityLegendary => 'Legendary';

  @override
  String get vehicleHeistEventOnlyTag => 'Event-only';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Value: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Rank: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'In-game availability: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Most common in: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Countries: $countries';
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
    return 'Upgrade locked: rank $rank required';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Upgrade locked';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Speed up for $credits credits';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Speed up (next screen)';

  @override
  String get vehicleHeistExpand => 'Expand';

  @override
  String get vehicleHeistCollapse => 'Collapse';

  @override
  String get vehicleHeistActive => 'ACTIVE';

  @override
  String get vehicleHeistOff => 'off';

  @override
  String get catalog => 'Catalog';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Run Hotspot';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Hotspot run';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Hotspot run completed: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Hotspot cooldown active ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'Hotspot failed. Heat increased.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Crew Op';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Crew op';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Crew op completed: you earned $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Crew required.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Crew op cooldown active ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'Crew op failed.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Join a crew to unlock crew actions';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew required: yes';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew required: no (join a crew first)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Buy Parts';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Buy parts';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Buy which parts? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Parts purchased: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed => 'Parts purchase failed.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Claim Contract';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Claim contract';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contract completed: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'No eligible vehicle in inventory for this contract.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Contract cooldown active ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed => 'Contract claim failed.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Insurance';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Contraband Insurance';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Choose a coverage tier for this vehicle category.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Basic';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pro';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Insurance active ($tier) for $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'Insurance purchase failed.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Crew Match';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Crew match won: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Crew match lost: +$reward consolation';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed => 'Crew matchmaking failed.';

  @override
  String get vehicleHeistOpsCounterButton => 'Counter';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Counter-intercept success: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Counter-intercept unavailable or failed.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Ops Contract';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Ops Contract';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Ops contract completed: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'Ops contract failed or on cooldown.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Claim dispute';

  @override
  String get vehicleHeistOpsNoOpenClaims => 'No open insurance claims.';

  @override
  String get vehicleHeistOpsNoValidClaimFound => 'No valid claim found.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Claim approved: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Claim rejected: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed => 'Claim resolution failed.';

  @override
  String get vehicleHeistOpsIntelTitle => 'Vehicle Ops Intelligence';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Refresh intelligence';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Tap to expand and view all actions.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Heat $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Police: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Rep lvl $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Parts market: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Hotspot: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Reward: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Why you get cash: successful ops actions pay out directly to wallet cash.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Cash: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'You: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Cash: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contracts: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return ' | from $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Part prices (car/motorcycle/boat): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Parts market refresh: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size members)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Chop contract reward: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Intercept window: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Blacklist: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Blacklist: none';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Insurance: $tier active';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine => 'Insurance: inactive';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Country modifier: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Crew season: $season | points $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contracts: $count | cooldown $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Counter cooldown: $cooldown | open claims: $claims';
  }

  @override
  String get tuneShop => 'Tune Shop';

  @override
  String get tuneShopIntro =>
      'Scrap vehicles for parts and upgrade speed, stealth and armor. Parts are shared per category (car/motorcycle/boat), so you can tune any vehicle within the same category.';

  @override
  String get tuneShopCarPartsLabel => 'Car parts';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Motorcycle parts';

  @override
  String get tuneShopBoatPartsLabel => 'Boat parts';

  @override
  String get tuneShopEmptyTitle => 'No vehicles available for tuning';

  @override
  String get tuneShopEmptyBody =>
      'Steal some vehicles first and scrap a few for parts.';

  @override
  String get tuneShopVehicleTypeCar => 'Car';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motorcycle';

  @override
  String get tuneShopVehicleTypeBoat => 'Boat';

  @override
  String get tuneShopStatSpeed => 'Speed';

  @override
  String get tuneShopStatStealth => 'Stealth';

  @override
  String get tuneShopStatArmor => 'Armor';

  @override
  String get tuneShopValueMultiplierPrefix => 'Value x';

  @override
  String get tuneShopUpgradeButton => 'Upgrade';

  @override
  String get tuneShopMaxLabel => 'MAX';

  @override
  String get tuneShopPartsAbbrev => 'pts';

  @override
  String get tuneShopUpgradeCompleted => 'Upgrade completed';

  @override
  String get tuneShopUpgradeFailed => 'Upgrade failed';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning locked: vehicle is in transit.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning locked: vehicle is in repair.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tuning cooldown active: $duration remaining.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Vehicle not found';

  @override
  String get tuneShopErrorNotOwner => 'You do not own this vehicle';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning locked: vehicle is in transit.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning locked: vehicle is in repair.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Not enough money';

  @override
  String get tuneShopErrorInsufficientParts => 'Not enough parts';

  @override
  String get tuneShopErrorStatMaxed => 'This tuning level is maxed';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tuning cooldown active: $duration remaining.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Limit reached: max $max concurrent tuning, currently $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Invalid tuning stat';

  @override
  String get territory => 'Territory';

  @override
  String get achievements => 'Achievements';

  @override
  String get menuCrackVault => 'Crack the Vault';

  @override
  String get vaultHeroTagline => 'Guess the code and win big prizes.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Season: $range';
  }

  @override
  String get vaultYourCredits => 'Your credits';

  @override
  String get vaultChooseStake => 'Choose your stake';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake credits',
      one: '$stake credit',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Expected prize: +$reward credits';
  }

  @override
  String get vaultCodeLabel => 'Code';

  @override
  String get vaultSubmitStake => 'Submit stake';

  @override
  String get vaultWrongCodesTitle => 'Wrong codes (this month)';

  @override
  String get vaultShowWrongCodes => 'Show';

  @override
  String get vaultHideWrongCodes => 'Hide';

  @override
  String get vaultNoWrongCodesYet => 'No wrong codes saved yet.';

  @override
  String get couldNotLoadVaultStatus => 'Could not load status.';

  @override
  String get vaultEnterFourDigitCode => 'Enter a 4-digit code.';

  @override
  String get vaultAttemptSuccessGeneric => 'Success.';

  @override
  String get vaultAttemptFailedGeneric => 'Failed.';

  @override
  String get vaultAttemptFailedRetry => 'Failed. Please try again.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count new messages';
  }

  @override
  String get rankProgress => 'Rank Progress';

  @override
  String get cash => 'Cash';

  @override
  String get sessionRecap => 'Session recap';

  @override
  String get nameLabel => 'Name';

  @override
  String get countryLabel => 'Country';

  @override
  String get wantedLevel => 'Wanted Level';

  @override
  String get fbiHeat => 'FBI Heat';

  @override
  String get properties => 'Properties';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get netWorth => 'Net worth';

  @override
  String get securityLabel => 'Security';

  @override
  String get noSecurity => 'No security';

  @override
  String get weaponLabel => 'Weapon';

  @override
  String get vehicleLabel => 'Vehicle';

  @override
  String get none => 'None';

  @override
  String get statistics => 'Statistics';

  @override
  String get breakouts => 'Breakouts';

  @override
  String get murders => 'Murders';

  @override
  String get hitlistContracts => 'Hitlist contracts';

  @override
  String get carsStolen => 'Cars stolen';

  @override
  String get boatsStolen => 'Boats stolen';

  @override
  String get crimeAttempts => 'Crime attempts';

  @override
  String get successful => 'Successful';

  @override
  String get jobAttempts => 'Job attempts';

  @override
  String get streetProstitutes => 'Street prostitutes';

  @override
  String get rldProstitutes => 'RLD prostitutes';

  @override
  String get travels => 'Travels';

  @override
  String get bullets => 'Bullets';

  @override
  String get moneyStatusLabel => 'Money status';

  @override
  String get moneyStatusPoor => 'Poor';

  @override
  String get moneyStatusRising => 'Rising';

  @override
  String get moneyStatusRich => 'Rich';

  @override
  String get moneyStatusMultimillionaire => 'Multimillionaire';

  @override
  String get rankBeginner => 'Beginner';

  @override
  String get rankCriminal => 'Criminal';

  @override
  String get rankGangster => 'Gangster';

  @override
  String get rankMafioso => 'Mafioso';

  @override
  String get rankEmptySuit => 'Empty Suit';

  @override
  String get rankDeliveryBoy => 'Delivery Boy';

  @override
  String get rankPicciotto => 'Picciotto';

  @override
  String get rankShoplifter => 'Shoplifter';

  @override
  String get rankPickpocket => 'Pickpocket';

  @override
  String get rankThief => 'Thief';

  @override
  String get rankAssociate => 'Associate';

  @override
  String get rankCadet => 'Cadet';

  @override
  String get rankSoldier => 'Soldier';

  @override
  String get rankSwindler => 'Swindler';

  @override
  String get rankAssassin => 'Assassin';

  @override
  String get rankLocalChief => 'Local Chief';

  @override
  String get rankChief => 'Chief';

  @override
  String get rankDrugLord => 'Drug Lord';

  @override
  String get rankGodfather => 'Godfather';

  @override
  String get rankDon => 'Don';

  @override
  String get rankOverlord => 'Overlord';

  @override
  String get rankLegend => 'Legend';

  @override
  String get rankUnknown => 'Unknown';

  @override
  String get dailyGoalTitle_crime_3 => 'Do 3 crimes';

  @override
  String get dailyGoalTitle_job_2 => 'Work 2 times';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Steal 1 vehicle';

  @override
  String get dailyGoalTitle_travel_1 => 'Complete 1 travel';

  @override
  String get dailyGoalTitle_training_combo_1 =>
      'Train gym + shooting range (same day)';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Weekly: 20 crimes';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Weekly: work 10 times';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Weekly: steal 5 vehicles';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Weekly: 3 travels';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Reward: +$cash and +$xp XP';
  }

  @override
  String get justNow => 'Just now';

  @override
  String secondsAgo(String seconds) {
    return '${seconds}s ago';
  }

  @override
  String minutesAgo(String count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(String count) {
    return '$count hours ago';
  }

  @override
  String get last10EventsLive => 'Last 10 events (live).';

  @override
  String get noEventsYetSession => 'No events yet in this session.';

  @override
  String get clearRecap => 'Clear recap';

  @override
  String get weeklyGoalClaimed => 'Weekly goal claimed!';

  @override
  String get dailyGoalClaimed => 'Daily goal claimed!';

  @override
  String get failed => 'Failed.';

  @override
  String get failedPleaseTryAgain => 'Failed. Please try again.';

  @override
  String get dailyGoals => 'Daily goals';

  @override
  String get weeklyGoals => 'Weekly goals';

  @override
  String get claimed => 'Claimed';

  @override
  String get ready => 'Ready';

  @override
  String get claim => 'Claim';

  @override
  String readyToClaim(String count) {
    return '$count ready to claim';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total completed';
  }

  @override
  String get noPlayerData => 'No player data';

  @override
  String get economy24h => 'Economy 24h';

  @override
  String get grossIncome => 'Gross income';

  @override
  String get propertySpend => 'Property spend';

  @override
  String get netCashflow => 'Net cashflow';

  @override
  String get trendVsPrevious => 'Trend vs previous';

  @override
  String get activity7d => 'Activity 7d';

  @override
  String get vehicleThefts => 'Vehicle thefts';

  @override
  String get opsOverview => 'Ops Overview';

  @override
  String get activeCooldowns => 'Active cooldowns';

  @override
  String get longestTimer => 'Longest timer';

  @override
  String get activeProduction => 'Active production';

  @override
  String get productionReadyIn => 'Production ready in';

  @override
  String get nightclubEvents => 'Nightclub events';

  @override
  String get nextEventStartsIn => 'Next event starts in';

  @override
  String get vehiclesActiveListedTransit => 'Vehicles active/listed/transit';

  @override
  String get livePlayerEvents => 'Live player events';

  @override
  String get openEvents => 'Open Events';

  @override
  String get notificationsAndRisk => 'Notifications & Risk';

  @override
  String get unreadDm => 'Unread DM';

  @override
  String get supportWaitingOnYou => 'Support waiting on you';

  @override
  String get eventsLast24h => 'Events last 24h';

  @override
  String get riskScore => 'Risk score';

  @override
  String get recruitProstitute => 'Recruit prostitute';

  @override
  String get free => 'FREE';

  @override
  String get crewWars => 'Crew Wars';

  @override
  String get status => 'Status';

  @override
  String get canDeclare => 'Can declare';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get type => 'Type';

  @override
  String get opponent => 'Opponent';

  @override
  String get crewPoints => 'Crew points';

  @override
  String get warRank => 'War rank';

  @override
  String get seasonRank => 'Season rank';

  @override
  String get openTargets => 'Open targets';

  @override
  String get phaseEndsIn => 'Phase ends in';

  @override
  String get crewTerritory => 'Crew Territory';

  @override
  String get regions => 'Regions';

  @override
  String get countriesCaptured => 'Countries captured';

  @override
  String get payout => 'Payout';

  @override
  String get earningPerHour => 'Earning now per hour';

  @override
  String get earningPerDay => 'Earning now per day';

  @override
  String get totalEarned => 'Total earned';

  @override
  String get crewBank => 'Crew bank';

  @override
  String get dashboardEconomy24h => 'Economy 24h';

  @override
  String get dashboardGrossIncome => 'Gross income';

  @override
  String get dashboardPropertySpend => 'Property spend';

  @override
  String get dashboardNetCashflow => 'Net cashflow';

  @override
  String get dashboardTrendVsPrevious => 'Trend vs previous';

  @override
  String get dashboardActivity7d => 'Activity 7d';

  @override
  String get dashboardVehicleThefts => 'Vehicle thefts';

  @override
  String get dashboardOpsOverview => 'Ops Overview';

  @override
  String get dashboardActiveCooldowns => 'Active cooldowns';

  @override
  String get dashboardLongestTimer => 'Longest timer';

  @override
  String get dashboardActiveProduction => 'Active production';

  @override
  String get dashboardProductionReadyIn => 'Production ready in';

  @override
  String get dashboardNightclubEvents => 'Nightclub events';

  @override
  String get dashboardNextEventStartsIn => 'Next event starts in';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Vehicles active/listed/transit';

  @override
  String get dashboardLivePlayerEvents => 'Live player events';

  @override
  String get dashboardOpenEvents => 'Open Events';

  @override
  String get dashboardNotificationsAndRisk => 'Notifications & Risk';

  @override
  String get dashboardUnreadDm => 'Unread DM';

  @override
  String get dashboardSupportWaitingOnYou => 'Support waiting on you';

  @override
  String get dashboardEventsLast24h => 'Events last 24h';

  @override
  String get dashboardRiskScore => 'Risk score';

  @override
  String get dashboardRecruitProstitute => 'Recruit prostitute';

  @override
  String get dashboardWarTheater => 'War theater';

  @override
  String get dashboardHotRegions => 'Hot regions';

  @override
  String get dashboardCrewWars => 'Crew Wars';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Can declare';

  @override
  String get dashboardTypeLabel => 'Type';

  @override
  String get dashboardOpponent => 'Opponent';

  @override
  String get dashboardCrewPoints => 'Crew points';

  @override
  String get dashboardWarRank => 'War rank';

  @override
  String get dashboardSeasonRank => 'Season rank';

  @override
  String get dashboardOpenTargets => 'Open targets';

  @override
  String get dashboardPhaseEndsIn => 'Phase ends in';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'In jail ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Preparing';

  @override
  String get dashboardCrewWarStatusActive => 'Active';

  @override
  String get dashboardCrewWarStatusLockdown => 'Lockdown';

  @override
  String get dashboardCrewWarStatusResolved => 'Resolved';

  @override
  String get dashboardCrewWarStatusArchived => 'Archived';

  @override
  String get dashboardCrewWarStatusCancelled => 'Cancelled';

  @override
  String get dashboardCrewWarStatusNone => 'No active war';

  @override
  String get dashboardCrewWarTypeKill => 'Kill War';

  @override
  String get dashboardCrewWarTypeEconomy => 'Economy War';

  @override
  String get dashboardCrewWarTypeTerritory => 'Territory War';

  @override
  String get dashboardCrewWarTypeTotal => 'Total War';

  @override
  String get dashboardClicks => 'Clicks';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Special offer';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'not configured';

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
    return 'every $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Crew Territory';

  @override
  String get dashboardRegions => 'Regions';

  @override
  String get dashboardCountriesCaptured => 'Countries captured';

  @override
  String get dashboardPayout => 'Payout';

  @override
  String get dashboardEarningPerHour => 'Earning now per hour';

  @override
  String get dashboardEarningPerDay => 'Earning now per day';

  @override
  String get dashboardTotalEarned => 'Total earned';

  @override
  String get dashboardVehicleOps => 'Vehicle Ops';

  @override
  String get dashboardKillProgress => 'Kill Progress';

  @override
  String get vehicleOpsHeat => 'Heat';

  @override
  String get vehicleOpsHeatLevelLow => 'Low';

  @override
  String get vehicleOpsHeatLevelMedium => 'Medium';

  @override
  String get vehicleOpsHeatLevelHigh => 'High';

  @override
  String get vehicleOpsReputation => 'Rep';

  @override
  String get vehicleOpsPartsTrendUp => 'parts market rising';

  @override
  String get vehicleOpsPartsTrendDown => 'parts market falling';

  @override
  String get vehicleOpsPartsTrendStable => 'parts market stable';

  @override
  String get vehicleOpsBlacklistActive => 'Blacklist active';

  @override
  String get vehicleOpsNoBlacklist => 'No blacklist';

  @override
  String get prisonTitle => 'Prison';

  @override
  String get prisonLoadFailed => 'Failed to load prisoners';

  @override
  String get prisonNoPrisonersFound => 'No prisoners found';

  @override
  String prisonRankLine(String rank) {
    return 'Rank: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Rank: $rank · You';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Remaining time: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Bail: €$amount';
  }

  @override
  String get prisonPayBailButton => 'Pay bail';

  @override
  String get prisonBuyOutButton => 'Buy out';

  @override
  String get prisonAttemptEscapeButton => 'Attempt escape';

  @override
  String get prisonJailbreakButton => 'Jailbreak';

  @override
  String get prisonActionFailed => '❌ Action failed';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Bought out $username for €$amount';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ You paid bail for €$amount and are free';
  }

  @override
  String get prisonEscapeSuccess => '✅ Escape succeeded! You are free.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ Escape failed. Sentence extended by $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Cooldown active: wait $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Escape failed';

  @override
  String get prisonErrorInsufficientFunds => '❌ Not enough money';

  @override
  String get prisonErrorTargetNotJailed => '❌ Target is no longer in prison';

  @override
  String get prisonErrorCannotBuyoutSelf => '❌ You cannot buy yourself out';

  @override
  String get prisonErrorPlayerNotFound => '❌ Player not found';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak succeeded! Prisoner is free.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Jailbreak failed, you got caught ($minutes min jail).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Jailbreak failed. Prisoner is still locked up.';

  @override
  String get prisonErrorRescuerJailed => '❌ You are in jail yourself';

  @override
  String get prisonJailbreakGenericFailure => '❌ Jailbreak failed';

  @override
  String get crewJailbreakTitle => '🚔 Jailed Crew';

  @override
  String get crewJailbreakLoadFailed => 'Failed to load jailed members';

  @override
  String get crewJailbreakEmptyTitle => '🎉 No one in jail!';

  @override
  String get crewJailbreakEmptyBody => 'All crew members are free';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Jailbreak attempt for $username:';
  }

  @override
  String get crewJailbreakRiskSuccess => 'If successful: Player freed!';

  @override
  String get crewJailbreakRiskFailChance => 'If failed: 60% chance caught';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Caught: 30-60 min jail + wanted +10';

  @override
  String get crewJailbreakTip =>
      'Success chance increases with rank and crew bonus!';

  @override
  String get crewJailbreakAttemptButton => 'Attempt Jailbreak';

  @override
  String get crewJailbreakActionFailed => '❌ Action failed';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minutes in jail';
  }

  @override
  String get crewJailbreakRescueButton => 'Rescue';

  @override
  String get crewRoleLeader => 'Leader';

  @override
  String get crewRoleCoLeader => 'Co-leader';

  @override
  String get crewRoleMember => 'Member';

  @override
  String get vehicleOpsHotspot => 'Hotspot';

  @override
  String get vehicleOpsCrew => 'Crew';

  @override
  String get vehicleOpsCrewMatch => 'Crew match';

  @override
  String get vehicleOpsChop => 'Chop';

  @override
  String get vehicleOpsContract => 'Contract';

  @override
  String get vehicleOpsCounter => 'Counter';

  @override
  String get vehicleOpsContracts => 'Contracts';

  @override
  String get vehicleOpsClaims => 'Claims';

  @override
  String get vehicleOpsSeason => 'Season';

  @override
  String get dashboardCar => 'Car';

  @override
  String get dashboardMotorcycle => 'Motorcycle';

  @override
  String get dashboardBoat => 'Boat';

  @override
  String get dashboardCrewAccess => 'Crew access';

  @override
  String get dashboardCrewRole => 'Crew role';

  @override
  String get dashboardUnavailable => 'unavailable';

  @override
  String get vehicleOps => 'Vehicle Ops';

  @override
  String get car => 'Car';

  @override
  String get motorcycle => 'Motorcycle';

  @override
  String get boat => 'Boat';

  @override
  String get crewAccess => 'Crew access';

  @override
  String get crewRole => 'Crew role';

  @override
  String get unavailable => 'unavailable';

  @override
  String get quickActionsCrimesSubtitle => 'Commit criminal acts';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Car, motorcycle and boat';

  @override
  String get quickActionsTuneShopSubtitle => 'Parts and upgrades';

  @override
  String get quickActionsEventsSubtitle => 'Active and upcoming events';

  @override
  String get quickActionsJobsSubtitle => 'Earn legal money';

  @override
  String get quickActionsCasinoSubtitle => 'Gamble your money';

  @override
  String get quickActionsBankSubtitle => 'Manage your global balance';

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
  String get avatarChangeFailed => 'Failed to change avatar';

  @override
  String get settingsMyPortraits => 'My portraits';

  @override
  String get settingsPortraitFromSelfieTitle => 'Portrait from selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Turn a selfie into a gangster-style portrait. $credits credits each.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'This costs $credits credits. Continue?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'I agree my photo may be processed into a stylized in-game portrait (see Terms). I am not under 13.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'Not enough credits (need $need, you have $have).';
  }

  @override
  String get settingsPortraitCreated => 'Portrait added to your library!';

  @override
  String get settingsPortraitGenerationFailed =>
      'Could not create portrait. Try another photo.';

  @override
  String get settingsPortraitSelectActive => 'Use as avatar';

  @override
  String get settingsPortraitDelete => 'Remove portrait';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Portrait limit reached ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Custom portrait active';

  @override
  String get settingsPresetAvatars => 'Preset avatars';

  @override
  String get settingsPortraitDeleteConfirm =>
      'Remove this portrait from your library?';

  @override
  String get settingsPortraitGenerating =>
      'Creating your portrait… This may take a few minutes. Please wait.';

  @override
  String get settingsPortraitDeleteHint =>
      'Tap a portrait to select it. Use the download button (left) to save your PNG, or the remove button (right) to delete it from the game.';

  @override
  String get settingsPortraitDownloadFailed =>
      'Could not download the portrait. Check your connection and try again.';

  @override
  String get settingsPortraitDownloadTooltip =>
      'Download this portrait as a PNG';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Remove this portrait from your library';

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
  String get usernameChangeFailed => 'Failed to change username';

  @override
  String get oncePerMonth => 'Change once per month';

  @override
  String get privacy => 'Privacy';

  @override
  String get allowMessages => 'Allow Messages';

  @override
  String get allowMessagesDesc => 'Other players can send you messages';

  @override
  String get settingsSystemNotificationsTitle => 'System notifications for app';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Permission: allowed, device linked';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Permission: allowed, device is re-linking';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Permission: provisional, device linked';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Permission: provisional, device is re-linking';

  @override
  String get settingsPushPermissionDenied => 'Permission: denied';

  @override
  String get settingsPushPermissionNotRequested =>
      'Permission: not requested yet';

  @override
  String get settingsPushPermissionUnknown => 'Permission: unknown';

  @override
  String get settingsDeviceTokenRegistered =>
      'Device token registered on server';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'No device token registered yet';

  @override
  String get settingsPushHelpText =>
      'Use this button to request browser/iPhone permission again and register your push token.';

  @override
  String get working => 'Working...';

  @override
  String get settingsEnablePush => 'Enable push';

  @override
  String get settingsPushEnabledToast =>
      'Push notifications enabled. New notifications will now be received.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push is disabled in your browser/iPhone settings. Enable notifications for this app.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Failed to enable push notifications: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Player events';

  @override
  String get settingsPushLivePlayerEventsTitle => 'Push: live player events';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Start and end of recurring competition events (e.g. top-score rounds).';

  @override
  String get settingsCryptoNotificationsTitle => 'Crypto Notifications';

  @override
  String get settingsCryptoPushTradesTitle => 'Push: Trades';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Push notification for buy/sell trades';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: Price alerts';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Push notification for relevant price moves';

  @override
  String get settingsCryptoPushOrdersTitle => 'Push: Orders';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Push notification when order is triggered or filled';

  @override
  String get settingsCryptoPushMissionsTitle => 'Push: Missions';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Push notification when a crypto mission is completed';

  @override
  String get settingsCryptoPushLeaderboardTitle => 'Push: Leaderboard';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Push notification for crypto leaderboard rewards';

  @override
  String get settingsCryptoInAppTradesTitle => 'In-app: Trades';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Show trade events in your event feed';

  @override
  String get settingsCryptoInAppPriceAlertsTitle => 'In-app: Price alerts';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Show price alert events in your event feed';

  @override
  String get settingsCryptoInAppOrdersTitle => 'In-app: Orders';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Show order events in your event feed';

  @override
  String get settingsCryptoInAppMissionsTitle => 'In-app: Missions';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Show mission completions in your event feed';

  @override
  String get settingsCryptoInAppLeaderboardTitle => 'In-app: Leaderboard';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Show leaderboard rewards in your event feed';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'You can only change your avatar once per week';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'You can only change your username once per month';

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
      'Hunger and thirst drop slowly over time. Eat and drink to stay ready.';

  @override
  String get friends => 'Friends';

  @override
  String get friendActivity => 'Friend Activity';

  @override
  String get friendsUiTabActivity => 'Activity';

  @override
  String get friendsUiTabRequests => 'Requests';

  @override
  String get friendsUiTabSearch => 'Search';

  @override
  String get friendsUiEmptyListTitle => 'No friends yet';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Search for players and add them as friends!';

  @override
  String get friendsUiNoRequests => 'No requests';

  @override
  String friendsUiLineRank(String rank) {
    return 'Rank: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Location: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Health: $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Friends since: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Remove friend';

  @override
  String get friendsUiRemoveDialogBody =>
      'Are you sure you want to remove this friend?';

  @override
  String get friendsUiRemoveConfirm => 'Remove';

  @override
  String get friendsUiBlockDialogTitle => 'Block player';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Are you sure you want to block $username? You won\'t be able to send or receive messages.';
  }

  @override
  String get friendsUiBlockButton => 'Block';

  @override
  String get friendsUiSnackRequestSent => 'Friend request sent';

  @override
  String get friendsUiSnackRequestAccepted => 'Friend request accepted';

  @override
  String get friendsUiSnackRequestRejected => 'Friend request rejected';

  @override
  String get friendsUiSnackFriendRemoved => 'Friend removed';

  @override
  String get friendsUiSnackPlayerBlocked => 'Player blocked';

  @override
  String friendsUiSnackError(String details) {
    return 'Error: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Search player';

  @override
  String get friendsUiSearchHint => 'Type at least 2 characters';

  @override
  String get friendsUiSearchMinChars => 'Type at least 2 characters to search';

  @override
  String get friendsUiNoPlayersFound => 'No players found';

  @override
  String get friendsUiMenuBlock => 'Block';

  @override
  String get friendsUiMenuRemove => 'Remove';

  @override
  String get friendsUiChipFriend => 'Friend';

  @override
  String get friendsUiChipPending => 'Pending';

  @override
  String get friendsUiAccept => 'Accept';

  @override
  String get friendsUiReject => 'Reject';

  @override
  String get friendsUiActivityEmpty => 'No friend activity yet';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Level $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Crews';

  @override
  String get crewUiTabMyCrew => 'Overview';

  @override
  String get crewUiTabCrewHq => 'HQ & Upgrades';

  @override
  String get crewUiTabStorageHub => 'Storage';

  @override
  String get crewUiTabMembers => 'Members';

  @override
  String get crewUiTabWarRoom => 'War Room';

  @override
  String get crewUiTabCrewMissions => 'Crew Missions';

  @override
  String get crewUiTabCarStorage => 'Car/Motorcycle Storage';

  @override
  String get crewUiTabBoatStorage => 'Boat Storage';

  @override
  String get crewUiTabWeaponStorage => 'Weapon Storage';

  @override
  String get crewUiTabAmmoStorage => 'Ammo Storage';

  @override
  String get crewUiTabDrugStorage => 'Drug Storage';

  @override
  String get crewUiTabCashStorage => 'Cash Storage';

  @override
  String get crewUiTabAllCrews => 'Crews';

  @override
  String get crewUiTabChat => 'Chat';

  @override
  String get crewUiActionCreateCrewShort => 'Create Crew (€50k)';

  @override
  String get crewUiStateNotInCrewYet => 'You are not in a crew yet';

  @override
  String get crewUiActionCreateCrew => 'Create Crew (€50,000)';

  @override
  String get crewUiLabelCrewBank => 'Crew Bank:';

  @override
  String get crewUiLabelDeposit => 'Deposit';

  @override
  String get crewUiLabelWithdraw => 'Withdraw';

  @override
  String get crewUiLabelMyTrustScore => 'My Trust Score:';

  @override
  String get crewUiActionDeleteCrew => 'Delete crew';

  @override
  String get crewUiLabelCrewStats => 'Crew Stats:';

  @override
  String get crewUiActionLeaveCrew => 'Leave Crew';

  @override
  String get crewUiSectionBuildings => 'HQ & Upgrades';

  @override
  String get crewUiHintBuildingsTabs =>
      'Open HQ & Upgrades to manage HQ and all crew buildings from one place.';

  @override
  String get crewUiSectionCrewStorage => 'Crew Storage';

  @override
  String get crewUiStateNoStorageData => 'No storage data loaded';

  @override
  String get crewUiActionAddCar => 'Add car/motorcycle';

  @override
  String get crewUiActionAddBoat => 'Add boat';

  @override
  String get crewUiActionAddWeapon => 'Add weapon';

  @override
  String get crewUiActionAddAmmo => 'Add ammo';

  @override
  String get crewUiActionAddDrugs => 'Add drugs';

  @override
  String get crewUiSectionMembersOverview => 'Members overview';

  @override
  String get crewUiHintMembersTab =>
      'Open the Members tab above for member list and join requests.';

  @override
  String get crewUiActionGoToMembers => 'Go to Members';

  @override
  String get crewUiLabelCrewHq => 'Crew HQ';

  @override
  String get crewUiActionGoToCrewHq => 'Go to Crew HQ';

  @override
  String get crewUiActionGoToStorage => 'Go to Storage';

  @override
  String get crewUiStateJoinCrewFirst => 'Create or join a crew first';

  @override
  String get crewUiStateJoinRequests => 'Join Requests';

  @override
  String get crewUiStateNoJoinRequests => 'No pending requests';

  @override
  String get crewUiStateNoCrewsFound => 'No crews found';

  @override
  String get crewUiLabelMemberCount => 'Members';

  @override
  String get crewUiBadgeMyCrew => 'My Crew';

  @override
  String get crewUiActionJoin => 'Join';

  @override
  String get crewUiStateNotInCrew => 'You are not in a crew';

  @override
  String get crewUiHintChatJoinCrew => 'Create or join a crew to chat!';

  @override
  String get crewUiStatusNotOwned => 'Not owned';

  @override
  String get crewUiLabelLevel => 'Level';

  @override
  String get crewUiLabelCapacity => 'Capacity';

  @override
  String get crewUiLabelMemberCap => 'Member cap';

  @override
  String get crewUiLabelParking => 'Parking';

  @override
  String get crewUiActionPurchase => 'Purchase';

  @override
  String get crewUiActionUpgrade => 'Upgrade';

  @override
  String get crewUiActionDetails => 'Details';

  @override
  String get crewUiHelpCapsTitle => 'Level overview';

  @override
  String get crewUiHelpLevel => 'Level';

  @override
  String get crewUiHelpCapacity => 'Cap';

  @override
  String get crewUiHelpUpgradeCost => 'Cost';

  @override
  String get crewUiHelpClose => 'Close';

  @override
  String get crewUiHelpShowCaps => 'Show caps';

  @override
  String get crewUiSectionUpgradeHub => 'HQ & Upgrades';

  @override
  String get crewUiSectionStorageHub => 'Storage Hub';

  @override
  String get crewUiHintStorageTab =>
      'Use the Storage tab for deposits, balances and quick storage actions.';

  @override
  String get crewUiHintUpgradeHub =>
      'Manage HQ and all crew upgrades from one place here.';

  @override
  String get crewUiSectionCrewMissions => 'Crew Missions';

  @override
  String get crewUiStateCrewMissionsEmpty => 'No crew missions available yet';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Join or create a crew to start missions.';

  @override
  String get crewUiActionStartMission => 'Start mission';

  @override
  String get crewUiActionConfigureAndStartMission => 'Configure & start';

  @override
  String get crewUiActionResolveMission => 'Resolve mission';

  @override
  String get crewUiActionClaimRewards => 'Claim rewards';

  @override
  String get crewUiActionSpeedupCooldown => 'Speed up cooldown';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Confirm speed up';

  @override
  String get crewUiLabelActiveMission => 'Active mission';

  @override
  String get crewUiLabelRecentMissions => 'Recent missions';

  @override
  String get crewUiLabelMissionDuration => 'Duration';

  @override
  String get crewUiLabelMissionCooldown => 'Cooldown';

  @override
  String get crewUiLabelMissionTier => 'Tier';

  @override
  String get crewUiLabelMissionRewards => 'Rewards';

  @override
  String get crewUiLabelMissionTradeCargo => 'Trade cargo (crew storage)';

  @override
  String get crewUiHintMissionTradeCargo =>
      'Deposit the listed goods in crew storage before starting.';

  @override
  String get crewUiErrorMissionTradeRequirementsNotMet =>
      'Not enough trade goods in crew storage for this mission.';

  @override
  String get crewUiLabelCrewMissionProgress => 'Crew mission progression';

  @override
  String get crewUiLabelCrewMissionXp => 'Crew mission XP';

  @override
  String get crewUiLabelCrewMissionLevelBonus => 'Crew cash bonus';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus => 'Next level bonus';

  @override
  String get crewUiLabelMissionStatus => 'Status';

  @override
  String get crewUiLabelCooldownActive => 'Cooldown active';

  @override
  String get crewUiLabelRoleContributions => 'Role contributions';

  @override
  String get crewUiLabelContribution => 'contribution';

  @override
  String get crewUiLabelMultiplier => 'multiplier';

  @override
  String get crewUiStatusMissionLocked => 'Locked';

  @override
  String get crewUiStatusInProgress => 'In progress';

  @override
  String get crewUiStatusCompleted => 'Completed';

  @override
  String get crewUiStatusReady => 'Ready';

  @override
  String get crewUiStatusRewardsClaimed => 'Rewards claimed';

  @override
  String get crewUiStateMissionActionBusy => 'Action is being processed...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Only leader/co-leader can start and resolve missions.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Assign roles';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Choose a mission role per crew member.';

  @override
  String get crewUiLabelRoleNone => 'Not assigned';

  @override
  String get crewUiLabelRolePlanner => 'Planner';

  @override
  String get crewUiLabelRoleEnforcer => 'Enforcer';

  @override
  String get crewUiLabelRoleLogistics => 'Logistics';

  @override
  String get crewUiLabelRoleTech => 'Tech';

  @override
  String get crewUiHintRoleBonus =>
      'Each unique role: +3% success chance, -2% duration (max +12% / -8%).';

  @override
  String get crewUiStateRoleAssignNoMembers => 'No crew members found.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Select at least 1 role.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'Tier 2 requires HQ 5+ and 2+ members.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'Tier 3 requires HQ 9+ and 3+ members.';

  @override
  String get crewUiHintMissionLockedDefault => 'Mission is still locked.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Failed to load crew missions.';

  @override
  String get crewUiMessageMissionStarted => 'Mission started';

  @override
  String get crewUiMessageMissionResolved => 'Mission resolved';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Rewards claimed';

  @override
  String get crewUiMessageMissionCooldownSpedUp => 'Cooldown sped up';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Could not load speedup price.';

  @override
  String get crewUiDialogSpeedupTitle => 'Speed up cooldown?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'Instant finish costs $credits credits ($minutes min remaining).';
  }

  @override
  String get crewUiLabelCredits => 'credits';

  @override
  String get crewUiStateLoadingPrice => 'Loading price...';

  @override
  String get crewUiActionCancel => 'Cancel';

  @override
  String get crewUiHintMissionUnlockCta =>
      'Higher-tier missions unlock when HQ and crew size grow. Upgrade HQ or recruit members to open Tier 2+.';

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
    return 'Upgrade all side buildings to at least level $level first.\n\nMissing:\n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 min';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get crewUiMissionNoHistory => 'No history yet.';

  @override
  String get crewUiBuildingHq => 'Crew HQ';

  @override
  String get crewUiBuildingCarStorage => 'Car/Motorcycle Storage';

  @override
  String get crewUiBuildingBoatStorage => 'Boat Storage';

  @override
  String get crewUiBuildingWeaponStorage => 'Weapon Storage';

  @override
  String get crewUiBuildingAmmoStorage => 'Ammo Storage';

  @override
  String get crewUiBuildingDrugStorage => 'Drug Storage';

  @override
  String get crewUiBuildingCashStorage => 'Cash Storage';

  @override
  String get crewUiWarActionKill => 'Kill';

  @override
  String get crewUiWarActionMug => 'Mug';

  @override
  String get crewUiWarActionSabotage => 'Sabotage';

  @override
  String get crewUiWarActionIntel => 'Intel';

  @override
  String get crewUiWarActionRaid => 'Raid';

  @override
  String get crewUiWarActionShield => 'Shield';

  @override
  String get crewUiWarActionBoost => 'Boost';

  @override
  String get crewUiWarActionTerritory => 'Territory';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count members)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Error loading messages: $error';
  }

  @override
  String get crewChatMessageTooLong => 'Message too long (max 500 characters)';

  @override
  String crewChatErrorSending(String error) {
    return 'Error sending message: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Could not delete message: $error';
  }

  @override
  String get crewChatDeleteTitle => 'Delete message?';

  @override
  String get crewChatDeleteBody => 'This message will be permanently deleted.';

  @override
  String get crewChatCancel => 'Cancel';

  @override
  String get crewChatDelete => 'Delete';

  @override
  String get crewChatNoMessages => 'No messages yet';

  @override
  String get crewChatEmptyHint => 'Send the first message to your crew!';

  @override
  String get aviationUiBuyConfirmTitle => 'Buy aircraft?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Do you want to buy $name for $price?';
  }

  @override
  String get aviationUiPurchaseFailed => 'Purchase failed.';

  @override
  String get aviationUiPurchasedSuccess => 'Aircraft purchased.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'License active ($type). Upgrade for heavier aircraft if needed. Full pilot training (Aviation 5 + certs) is also required.';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'School Aviation 5/5 alone is not enough: buy a paid aviation license here before you can purchase aircraft.';

  @override
  String get aviationUiLicensesTitle => 'Aviation licenses';

  @override
  String get aviationUiLicenseBasic => 'Basic (light / turboprop)';

  @override
  String get aviationUiLicenseCommercial =>
      'Commercial (business / luxury jets)';

  @override
  String get aviationUiLicenseCargo => 'Cargo (cargo & heavy freighters)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Min rank $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Buy license';

  @override
  String get aviationUiUpgradeLicense => 'Upgrade license';

  @override
  String get aviationUiLicenseBuyConfirmTitle => 'Buy aviation license?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return 'Buy $name for $price? Requires completed Aviation school (level 5 + certifications).';
  }

  @override
  String get aviationUiLicensePurchaseFailed => 'License purchase failed.';

  @override
  String get aviationUiLicensePurchasedSuccess => 'Aviation license purchased.';

  @override
  String get aviationUiYourAircraft => 'Your aircraft';

  @override
  String get aviationUiNoOwnedAircraft => 'You do not own any aircraft yet.';

  @override
  String get aviationUiAvailableAircraft => 'Available aircraft';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Fuel: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Price: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Min rank: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Speed x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Cargo: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Aircraft';

  @override
  String aviationUiLoadError(String error) {
    return 'Could not load aviation data: $error';
  }

  @override
  String get aviationHeroTitle => 'The hangar';

  @override
  String get aviationHeroSubtitle =>
      'Finish Aviation school, buy a paid license, then buy a plane for faster travel and smuggling.';

  @override
  String aviationSchoolChip(String level) {
    return 'School $level/5';
  }

  @override
  String aviationCertsChip(String count) {
    return 'Flight certs $count/2';
  }

  @override
  String get aviationNoLicenseChip => 'No paid license';

  @override
  String aviationOwnedCountChip(String count) {
    return '$count aircraft';
  }

  @override
  String get aviationOwnedBadge => 'Owned';

  @override
  String get aviationHangarEmptyHint =>
      'Buy a paid license first, then pick a plane below.';

  @override
  String aviationRequiresLicense(String name) {
    return 'Needs $name';
  }

  @override
  String get aviationRankLocked => 'Rank too low';

  @override
  String get aviationRefuel => 'Refuel';

  @override
  String get aviationRefuelConfirmTitle => 'Refuel aircraft?';

  @override
  String aviationRefuelConfirmBody(String liters, String price) {
    return 'Fill the tank with $liters L for $price?';
  }

  @override
  String get aviationRefuelSuccess => 'Aircraft refueled.';

  @override
  String get aviationRefuelFailed => 'Refuel failed.';

  @override
  String get aviationRefuelFull => 'The tank is already full.';

  @override
  String get aviationFlyConfirmTitle => 'Fly now?';

  @override
  String aviationFlyConfirmBody(String name, String country) {
    return 'Fly $name to $country? Uses 100 L and arrives instantly.';
  }

  @override
  String get aviationFlyPickDestination => 'Choose destination';

  @override
  String get aviationFlySuccess => 'You landed.';

  @override
  String get aviationFlyFailed => 'Flight failed.';

  @override
  String get aviationFlyNeedFuel => 'Not enough fuel. A flight uses 100 L.';

  @override
  String get aviationFlyBroken =>
      'This aircraft is broken and must be repaired first.';

  @override
  String get aviationSellConfirmTitle => 'Sell aircraft?';

  @override
  String aviationSellConfirmBody(String name, String price) {
    return 'Sell $name for $price? You get 50% of the purchase price.';
  }

  @override
  String get aviationSoldSuccess => 'Aircraft sold.';

  @override
  String get aviationSellFailed => 'Sale failed.';

  @override
  String get aviationRepair => 'Repair';

  @override
  String get aviationRepairConfirmTitle => 'Repair aircraft?';

  @override
  String aviationRepairConfirmBody(String name, String price) {
    return 'Repair $name for $price?';
  }

  @override
  String get aviationRepairSuccess => 'Aircraft repaired.';

  @override
  String get aviationRepairFailed => 'Repair failed.';

  @override
  String get aviationBrokenBadge => 'Broken';

  @override
  String aviationTravelBonusChip(String percent) {
    return '−$percent% travel time';
  }

  @override
  String get crewUiTr0 => 'HQ upgrade requirements';

  @override
  String get crewUiTr1 =>
      'Upgrade your current HQ style to max level to unlock the next style';

  @override
  String get crewUiTr2 => 'Final HQ style reached';

  @override
  String get crewUiTr3 => 'VIP HQ required for level 11-15';

  @override
  String get crewUiTr4 =>
      'Upgrade all side buildings to the required level for this HQ style first';

  @override
  String get crewUiTr5 => 'Building already owned';

  @override
  String get crewUiTr6 => 'Insufficient crew bank funds';

  @override
  String get crewUiTr7 => 'HQ progression is too low for this upgrade';

  @override
  String get crewUiTr8 => 'Crew VIP required for level 11+';

  @override
  String get crewUiTr9 =>
      'Starter deposit reached. Purchase cash storage first to unlock more crew bank space.';

  @override
  String get crewUiTr10 => 'Action failed';

  @override
  String get crewUiTr11 => 'There is already an active crew mission.';

  @override
  String get crewUiTr12 =>
      'A mission cooldown is still active. Wait for it to finish or speed it up with credits.';

  @override
  String get crewUiTr13 => 'Mission not found.';

  @override
  String get crewUiTr14 => 'This tier is still locked.';

  @override
  String get crewUiTr15 => 'Mission run not found.';

  @override
  String get crewUiTr16 => 'Mission is already resolved.';

  @override
  String get crewUiTr17 => 'Mission is not completed yet.';

  @override
  String get crewUiTr18 => 'No active cooldown.';

  @override
  String get crewUiTr19 => 'Insufficient credits.';

  @override
  String get crewUiTr20 => 'Failed to start mission.';

  @override
  String get crewUiTr21 => 'Failed to resolve mission.';

  @override
  String get crewUiTr22 => 'Failed to claim rewards.';

  @override
  String get crewUiTr23 => 'Failed to speed up cooldown.';

  @override
  String get crewUiTr24 => 'You are not in a crew.';

  @override
  String get crewUiTr25 => 'Only the crew leader can do this.';

  @override
  String get crewUiTr26 => 'Target crew not found.';

  @override
  String get crewUiTr27 => 'This crew is already in a war.';

  @override
  String get crewUiTr28 => 'At least 3 crew members are required.';

  @override
  String get crewUiTr29 => 'War not found.';

  @override
  String get crewUiTr30 => 'This war is not active.';

  @override
  String get crewUiTr31 => 'You cannot join this war right now.';

  @override
  String get crewUiTr32 => 'This action requires a target player.';

  @override
  String get crewUiTr33 => 'Anti-farm block: pick another target.';

  @override
  String get crewUiTr34 => 'A VIP player is required for this action.';

  @override
  String get crewUiTr35 => 'A VIP crew is required for this action.';

  @override
  String get crewUiTr36 => 'Action limit reached for now.';

  @override
  String crewUiTr37(String remaining) {
    return 'Cooldown active: wait $remaining more minutes.';
  }

  @override
  String get crewUiTr38 => 'Invalid territory selected.';

  @override
  String get crewUiTr39 => 'Crew war action failed.';

  @override
  String get crewUiTr40 => 'Target player';

  @override
  String get crewUiTr41 => 'Kills';

  @override
  String get crewUiTr42 => 'Deaths';

  @override
  String get crewUiTr43 => 'Cancel';

  @override
  String get crewUiTr44 => 'Confirm';

  @override
  String get crewUiTr45 => 'Leader';

  @override
  String get crewUiTr46 => 'Co-leader';

  @override
  String get crewUiTr47 => 'Member';

  @override
  String get crewUiTr48 => 'Capital';

  @override
  String get crewUiTr49 => 'Harbor';

  @override
  String get crewUiTr50 => 'Industry';

  @override
  String get crewUiTr51 => 'Border';

  @override
  String get crewUiTr52 => 'Logistics';

  @override
  String get crewUiTr53 => 'Claim';

  @override
  String get crewUiTr54 => 'Tick';

  @override
  String get crewUiTr55 => 'Select territory';

  @override
  String get crewUiTr56 => 'Select a target crew first.';

  @override
  String get crewUiTr57 => 'Crew war declared.';

  @override
  String get crewUiTr58 => 'Failed to declare crew war.';

  @override
  String get crewUiTr59 => 'You joined the war.';

  @override
  String get crewUiTr60 => 'Failed to join the war.';

  @override
  String get crewUiTr61 => 'Crew war action completed.';

  @override
  String get crewUiTr62 => 'Kill War';

  @override
  String get crewUiTr63 => 'Economy War';

  @override
  String get crewUiTr64 => 'Territory War';

  @override
  String get crewUiTr65 => 'Total War';

  @override
  String get crewUiTr66 => 'Preparing';

  @override
  String get crewUiTr67 => 'Active';

  @override
  String get crewUiTr68 => 'Lockdown';

  @override
  String get crewUiTr69 => 'Resolved';

  @override
  String get crewUiTr70 => 'Archived';

  @override
  String get crewUiTr71 => 'Cancelled';

  @override
  String get crewUiTr72 => 'Crew VIP';

  @override
  String get crewUiTr73 => '€9.99/mo';

  @override
  String get crewUiTr74 => '€4.99/mo';

  @override
  String get crewUiTr75 => 'One-time purchases';

  @override
  String get crewUiTr76 => 'Only the leader can buy crew VIP';

  @override
  String get crewUiTr77 => 'Invalid product';

  @override
  String get crewUiTr78 => 'Error opening payment page';

  @override
  String get crewUiTr79 => 'Are you sure?';

  @override
  String get crewUiTr80 => 'Leave crew';

  @override
  String get crewUiTr81 => 'Are you sure you want to leave the crew?';

  @override
  String get crewUiTr82 => 'Leave';

  @override
  String get crewUiTr83 => 'Left crew';

  @override
  String get crewUiTr84 => 'Deposit to crew bank';

  @override
  String get crewUiTr85 => 'Withdraw from crew bank';

  @override
  String get crewUiTr86 => 'Amount';

  @override
  String get crewUiTr87 => 'Invalid amount';

  @override
  String get crewUiTr88 => 'Not enough cash on hand';

  @override
  String get crewUiTr89 => 'Purchase cash storage first for the crew bank';

  @override
  String get crewUiTr90 => 'Crew cash storage is full';

  @override
  String get crewUiTr91 => 'Delete crew';

  @override
  String get crewUiTr92 =>
      'Are you sure you want to delete this crew? This cannot be undone.';

  @override
  String get crewUiTr93 => 'Delete';

  @override
  String get crewUiTr94 => 'Next level';

  @override
  String get crewUiTr95 => 'Cost';

  @override
  String get crewUiTr96 => 'Max level reached';

  @override
  String get crewUiTr97 => 'Building not owned';

  @override
  String get crewUiTr98 => 'Add car/motorcycle';

  @override
  String get crewUiTr99 => 'Add boat';

  @override
  String get crewUiTr100 => 'Motorcycle';

  @override
  String get crewUiTr101 => 'Boat';

  @override
  String get crewUiTr102 => 'Car';

  @override
  String get crewUiTr103 => 'Select';

  @override
  String get crewUiTr104 => 'Add';

  @override
  String get crewUiTr105 => 'Add weapon';

  @override
  String get crewUiTr106 => 'Weapon';

  @override
  String get crewUiTr107 => 'Quantity';

  @override
  String get crewUiTr108 => 'Add ammo';

  @override
  String get crewUiTr109 => 'Ammo type';

  @override
  String get crewUiTr110 => 'Add goods';

  @override
  String get crewUiTr111 => 'Goods type';

  @override
  String get crewUiTr112 => 'Join a crew first to use Crew Wars.';

  @override
  String get crewUiTr113 => 'No opponent crew members are available to target.';

  @override
  String get crewUiTr114 => 'Select target player';

  @override
  String get crewUiTr115 => 'Season overview';

  @override
  String get crewUiTr116 => 'Active season';

  @override
  String get crewUiTr117 => 'My role';

  @override
  String get crewUiTr118 => 'Crew can declare';

  @override
  String get crewUiTr119 => 'Yes';

  @override
  String get crewUiTr120 => 'No';

  @override
  String get crewUiTr121 => 'Declare new war';

  @override
  String get crewUiTr122 => 'Target crew';

  @override
  String get crewUiTr123 => 'War type';

  @override
  String get crewUiTr124 => 'Declare war';

  @override
  String get crewUiTr125 => 'War territories';

  @override
  String get crewUiTr126 => 'Neutral';

  @override
  String get crewUiTr127 => 'Opponent crew';

  @override
  String get crewUiTr128 => 'Active from';

  @override
  String get crewUiTr129 => 'Join war';

  @override
  String get crewUiTr130 => 'Standings';

  @override
  String get crewUiTr131 => 'Territories';

  @override
  String get crewUiTr132 => 'Recent actions';

  @override
  String get crewUiTr133 => 'No war actions yet.';

  @override
  String get crewUiTr134 => 'vs';

  @override
  String get crewUiTr135 => 'Season leaderboard';

  @override
  String get crewUiTr136 => 'No season points yet.';

  @override
  String get crewUiTr137 => 'Loot';

  @override
  String get crewUiTr138 => 'Recent wars';

  @override
  String get crewUiTr139 => 'No recent wars yet.';

  @override
  String get crewUiTr140 => 'Only the leader can purchase or upgrade';

  @override
  String get crewUiTr141 =>
      'HQ upgrade blocked: side buildings first to L\$requiredSideLevel';

  @override
  String get crewUiTr142 => 'Next upgrade not available yet';

  @override
  String get crewUiTr143 => 'HQ progression too low';

  @override
  String get crewUiTr144 => 'HQ level too low for next upgrade';

  @override
  String get premiumUiLoadError => 'Premium data could not be loaded.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Purchase received. Refreshing your credits and premium overview.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Crew VIP payment received. Refreshing your premium overview.';

  @override
  String get premiumUiRedirectPaidVip =>
      'VIP payment received. Refreshing your premium overview.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Purchase cancelled.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Payment cancelled.';

  @override
  String get premiumUiRedirectFailedOneTime => 'Purchase failed or expired.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'Payment failed or expired.';

  @override
  String get premiumUiCheckoutOpenFailed => 'Failed to open the payment page.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'This item requires a vehicle selection and will be redeemed from the vehicle screen.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Credits redeemed.';

  @override
  String get premiumUiRedeemFailed => 'Failed to redeem credits.';

  @override
  String get premiumUiPerMonthShort => 'mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Cash boost';

  @override
  String get premiumUiCreditThemeSecurity => 'Security';

  @override
  String get premiumUiCreditThemeGarage => 'Garage';

  @override
  String get premiumUiCreditThemeTuneShop => 'Tune Shop';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Cooldown: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset => 'Cooldown reset';

  @override
  String get premiumUiCreditThemeEvents => 'Events';

  @override
  String get premiumUiCreditThemePremium => 'Premium';

  @override
  String get premiumUiKpiPlayerVip => 'Player VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew VIP';

  @override
  String get premiumUiCreditsLabel => 'Credits';

  @override
  String get premiumUiStatusActive => 'Active';

  @override
  String get premiumUiStatusInactive => 'Inactive';

  @override
  String get premiumUiNoCrew => 'No crew';

  @override
  String get premiumUiSectionVipTitle => 'VIP subscriptions';

  @override
  String get premiumUiSectionVipSubtitle =>
      'VIP includes monthly auto-renew via Mollie. Cancel anytime; your paid period stays active.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Exclusive account perks, avatar unlocks and premium QoL — renews automatically each month.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Active until $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP';

  @override
  String get premiumUiExtendVip => 'Extend VIP';

  @override
  String get premiumUiBuyVip => 'Buy VIP';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'Player VIP benefits';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Player VIP benefits:\n- 10% shorter action timeouts/cooldowns (jail time stays unchanged).\n- In Drug Production, you get a VIP lightning button on each production card to buy missing materials in one click (after cost confirmation).\n- On death, you lose on-hand cash but restart with EUR 500,000 cash.\n- Your rank is halved instead of a full reset.\n- Education progress and unlocked achievements are preserved.\n- Bank balance and crypto are preserved.\n- Properties, vehicles, prostitutes, carried inventory and stored items are removed.\n- Drug progress and drug stock are reset.\n- You receive 100 premium credits weekly while VIP is active.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'You must be in a crew before you can activate Crew VIP.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'For crew upgrades, side buildings level 11-15 and shared perks.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Crew needed';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Crew required';

  @override
  String get premiumUiExtendCrewVip => 'Extend Crew VIP';

  @override
  String get premiumUiBuyCrewVip => 'Buy Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Crew VIP benefits';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'You must join a crew before buying Crew VIP. Crew VIP unlocks crew-focused perks and higher upgrade progression.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew VIP grants access to extra crew upgrades and shared premium perks for your crew flow. After purchase, active status and expiry are updated immediately.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Buy credits';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Pick a bundle via visual tiles. Popular 1000-credit option gets its own spotlight.';

  @override
  String get premiumUiSectionPassesTitle => 'Event Pass';

  @override
  String get premiumUiSectionPassesSubtitle =>
      'One-time unlock for the monthly Event Pass premium track. Not a subscription.';

  @override
  String get premiumUiBadgeSeasonPass => 'Event Pass';

  @override
  String get premiumUiBadgeEventPass => 'Event Pass';

  @override
  String get premiumUiSeasonPassFallbackTitle => 'Event Pass (this month)';

  @override
  String get premiumUiEventPassFallbackTitle => 'Event Pass';

  @override
  String premiumUiBuyPassCta(String price) {
    return 'Buy · $price';
  }

  @override
  String get premiumUiNoCreditBundles =>
      'There are no active credit bundles right now.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Credit bundle';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Instant credits for your premium wallet.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Buy $amount credits';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count credits';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Ultra deal';

  @override
  String get premiumUiBadgeTopDeal => 'Top deal';

  @override
  String get premiumUiBadgeCredits => 'Credits';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine for $price.\n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'Credit shop';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Each item uses a themed tile based on the effect you are buying.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Premium item';

  @override
  String get premiumUiShopItemFallbackDescription => 'Direct premium perk.';

  @override
  String get premiumUiShopNoActiveCooldown => 'No active cooldown';

  @override
  String get premiumUiShopNotEnoughCredits => 'Not enough credits';

  @override
  String get premiumUiShopRedeem => 'Redeem';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description\n\nTheme: $theme\nCost: $cost credits';
  }

  @override
  String get premiumUiBadgeShop => 'Shop';

  @override
  String get premiumUiActiveEffectsTitle => 'Active premium effects';

  @override
  String get premiumUiIntroSubtitle =>
      'Players manage VIP subscriptions, credit bundles and credit shop items here.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

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
  String get propertiesConfirmPurchaseTitle => 'Are you sure?';

  @override
  String get propertyTypeApartment => 'Apartment';

  @override
  String get propertyTypeNightclub => 'Nightclub';

  @override
  String get propertyTypeShop => 'Shop';

  @override
  String get propertyStatStorageLabel => '📦 Storage';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to slots';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Housing capacity';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to workers';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount slots';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current workers (max $max at level $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current workers • max';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count extra slots';
  }

  @override
  String get propertyManageNightclub => 'Manage nightclub';

  @override
  String get blackMarket => 'Black Market';

  @override
  String get blackMarketShops => 'Shops';

  @override
  String get blackMarketPlayerMarket => 'Player market';

  @override
  String get blackMarketSubtitle =>
      'Buy from the dealer or trade with other players.';

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
  String get casinoHubChooseGameHint => 'Choose a game and place your bet';

  @override
  String get casinoPlayButton => 'Play';

  @override
  String get casinoGameBaccaratName => 'Baccarat';

  @override
  String get casinoGameBaccaratDesc =>
      'Bet on player, banker, or tie with strategic odds.';

  @override
  String get casinoGameVideoPokerName => 'Video Poker';

  @override
  String get casinoGameVideoPokerDesc =>
      'Draw 5 cards and hit combos up to Royal Flush.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Buy casino (locked)';

  @override
  String get casinoErrGenericPlay => 'Something went wrong';

  @override
  String get casinoErrSpinFailed => 'Error while spinning';

  @override
  String get casinoErrBetFailed => 'Error while betting';

  @override
  String get casinoErrGambleFailed => 'Error while gambling';

  @override
  String get casinoErrThrowFailed => 'Error while rolling';

  @override
  String get casinoErrCasinoNotFound =>
      'Casino not found. Make sure the casino is purchased in this country.';

  @override
  String get casinoErrInsufficientFunds => 'Not enough money';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Casino bankroll too low for this payout';

  @override
  String casinoErrNetwork(String error) {
    return 'Network error: $error';
  }

  @override
  String get casinoResultYouWon => 'You won!';

  @override
  String get casinoResultYouLost => 'Lost';

  @override
  String get casinoResultYouWonCelebrate => '🎉 You won!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'You won €$amount!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'You lost €$amount';
  }

  @override
  String get casinoYouLostPlain => 'You lost';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'You won €$amount!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK! €$amount';
  }

  @override
  String get casinoAgain => 'Again';

  @override
  String get casinoBankruptTitle => 'Casino bankrupt!';

  @override
  String get casinoBankruptBody =>
      'The casino went bankrupt!\n\nThe owner did not have enough cash in the bankroll to cover all payouts.\n\nThe casino is now closed and can be purchased again.';

  @override
  String get casinoBackToCasino => 'Back to Casino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Number: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'green';

  @override
  String get casinoColorRed => 'red';

  @override
  String get casinoColorBlack => 'black';

  @override
  String get casinoRoulettePickBet => 'Choose your bet';

  @override
  String get casinoRouletteBetRed => 'Red';

  @override
  String get casinoRouletteBetBlack => 'Black';

  @override
  String get casinoRouletteBetEven => 'Even';

  @override
  String get casinoRouletteBetOdd => 'Odd';

  @override
  String get casinoRouletteSpinButton => 'SPIN!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Last result: $number';
  }

  @override
  String get casinoBetLabel => 'Bet';

  @override
  String get casinoBlackjackPlayButton => 'PLAY!';

  @override
  String get casinoSlotSpinButton => 'SPIN!';

  @override
  String get casinoDiceRollButton => 'ROLL!';

  @override
  String get casinoBlackjackYourCards => 'Your cards';

  @override
  String get casinoBlackjackDealerCards => 'Dealer cards';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Dealer: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'You: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Total: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Predict';

  @override
  String get casinoDiceLowLabel => 'Low (2-6)';

  @override
  String get casinoDiceHighLabel => 'High (8-12)';

  @override
  String get casinoDiceOddsHint => 'Low/High pays 2x • Exact total pays 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Payout table';

  @override
  String get casinoBaccaratPlayer => 'Player';

  @override
  String get casinoBaccaratBanker => 'Banker';

  @override
  String get casinoBaccaratTieBet => 'Tie';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Winner: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Payout: €$amount';
  }

  @override
  String get casinoNoPayout => 'No payout';

  @override
  String casinoResultEuro(String amount) {
    return 'Result: €$amount';
  }

  @override
  String get casinoDealing => 'Dealing…';

  @override
  String get casinoDealCaps => 'DEAL';

  @override
  String get casinoVideoPokerDrawCards => 'DRAW CARDS';

  @override
  String get casinoVideoPokerDrawHint => 'Draw your hand';

  @override
  String get casinoVideoPokerRoyalFlush => 'Royal Flush';

  @override
  String get casinoVideoPokerStraightFlush => 'Straight Flush';

  @override
  String get casinoVideoPokerFourKind => 'Four of a Kind';

  @override
  String get casinoVideoPokerFullHouse => 'Full House';

  @override
  String get casinoVideoPokerFlush => 'Flush';

  @override
  String get casinoVideoPokerStraight => 'Straight';

  @override
  String get casinoVideoPokerThreeKind => 'Three of a Kind';

  @override
  String get casinoVideoPokerTwoPair => 'Two Pair';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jacks or Better';

  @override
  String get casinoVideoPokerNoWinningHand => 'No winning hand';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Payout table: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x';

  @override
  String get bankScreenLoadFailed => 'Failed to load bank';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Network error: $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'To: $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'From: $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Deposit successful';

  @override
  String get bankScreenDepositFailed => 'Deposit failed';

  @override
  String bankScreenDailyDepositQuota(String remaining, String cap) {
    return 'Free deposits left today: $remaining of $cap. Larger amounts must be laundered.';
  }

  @override
  String get bankScreenDailyDepositCapReached =>
      'Today\'s free deposit limit is used up. Launder remaining cash or wait for the UTC reset.';

  @override
  String bankScreenFillRemainingQuota(String amount) {
    return 'Fill remaining ($amount)';
  }

  @override
  String bankScreenDailyDepositResetsIn(String time) {
    return 'Free deposits reset at 00:00 UTC ($time left).';
  }

  @override
  String get bankScreenDailyDepositBelowLaunderMin =>
      'Cash below the launder minimum can be deposited for free after the UTC reset.';

  @override
  String bankScreenDepositCapError(String remaining) {
    return 'That exceeds today\'s free deposit remaining ($remaining). Deposit up to that amount, or use money laundering.';
  }

  @override
  String get bankScreenWithdrawSuccess => 'Withdrawal successful';

  @override
  String get bankScreenWithdrawFailed => 'Withdrawal failed';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '€$amount transferred to $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Transfer failed';

  @override
  String get bankScreenErrRecipientNotFound => 'Player not found';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'You cannot transfer to yourself';

  @override
  String get bankScreenErrInsufficientBalance => 'Insufficient bank balance';

  @override
  String get bankScreenErrInvalidAmount => 'Invalid amount';

  @override
  String get bankScreenTryAgain => 'Try again';

  @override
  String get bankScreenWorldwideSubtitle => 'Bank (worldwide accessible)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Cash on hand: €$amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Bank balance: €$amount';
  }

  @override
  String get bankScreenAmountLabel => 'Amount';

  @override
  String get bankScreenDescriptionOptional => 'Description (optional)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Will be stored with your deposit or withdrawal in transactions.';

  @override
  String get bankScreenDepositButton => 'Deposit';

  @override
  String get bankScreenWithdrawButton => 'Withdraw';

  @override
  String get bankScreenTransferSectionTitle => 'Transfer to player';

  @override
  String get bankScreenRecipientUsername => 'Recipient username';

  @override
  String get bankScreenRecentRecipients => 'Recent recipients';

  @override
  String get bankScreenDescriptionTransferHint =>
      'The recipient will also see this description in transactions.';

  @override
  String get bankScreenTransferButton => 'Transfer';

  @override
  String get bankScreenTransactionsTitle => 'Transactions';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count total';
  }

  @override
  String get bankScreenSummaryDeposits => 'Deposits';

  @override
  String get bankScreenSummaryWithdrawals => 'Withdrawals';

  @override
  String get bankScreenSummarySent => 'Sent';

  @override
  String get bankScreenSummaryReceived => 'Received';

  @override
  String get bankScreenNoTransactions => 'No transactions yet';

  @override
  String get bankScreenTxnDeposit => 'Deposit';

  @override
  String get bankScreenTxnWithdraw => 'Withdrawal';

  @override
  String get bankScreenTxnTransferSent => 'Transfer sent';

  @override
  String get bankScreenTxnTransferReceived => 'Transfer received';

  @override
  String get bankScreenPrevious => 'Previous';

  @override
  String get bankScreenNext => 'Next';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Rank $rank';
  }

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
  String get viewOffer => 'View offer';

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
  String get backpacks => 'Backpacks';

  @override
  String get materials => 'Materials';

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
  String get contrabandSpiritsName => 'Luxury spirits';

  @override
  String get contrabandSpiritsDesc =>
      'Smuggled whisky, cognac and premium liquors';

  @override
  String get contrabandTobaccoName => 'Tobacco';

  @override
  String get contrabandTobaccoDesc => 'Untaxed cigarettes and snuff tobacco';

  @override
  String get contrabandArtName => 'Art & antiques';

  @override
  String get contrabandArtDesc =>
      'Smuggled paintings, sculptures and antique valuables';

  @override
  String get contrabandSpicesName => 'Spices';

  @override
  String get contrabandSpicesDesc => 'Exotic herbs and spices in bulk sacks';

  @override
  String get contrabandCoffeeName => 'Coffee';

  @override
  String get contrabandCoffeeDesc =>
      'Premium coffee beans and ground coffee without certificates';

  @override
  String get contrabandFurLeatherName => 'Fur & leather';

  @override
  String get contrabandFurLeatherDesc =>
      'Illegally sourced fur, exotic leather and luxury pelts';

  @override
  String get contrabandPerfumeName => 'Perfume';

  @override
  String get contrabandPerfumeDesc =>
      'Smuggled designer perfumes and fragrance concentrates';

  @override
  String get contrabandCounterfeitCashName => 'Counterfeit cash';

  @override
  String get contrabandCounterfeitCashDesc =>
      'High-quality forgeries and unused banknote stacks';

  @override
  String get contrabandRareWineName => 'Rare wine';

  @override
  String get contrabandRareWineDesc =>
      'Vintage wines and exclusive wine collections';

  @override
  String get contrabandLuxuryWatchesName => 'Luxury watches';

  @override
  String get contrabandLuxuryWatchesDesc =>
      'Smuggled prestige watches without papers';

  @override
  String get contrabandGoldName => 'Gold';

  @override
  String get contrabandGoldDesc =>
      'Melted gold bars and unmarked bullion blocks';

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
  String get tradeLoadGoodsFailed => 'Could not load goods catalog';

  @override
  String get tradeLoadPricesFailed => 'Could not load current prices';

  @override
  String get tradeLoadInventoryFailed => 'Could not load your trade inventory';

  @override
  String get tradePartialDataBanner =>
      'Some market data could not be refreshed. Pull down to retry.';

  @override
  String get tradeMarketLoadAllFailed =>
      'The market could not be loaded. Pull down to retry.';

  @override
  String get tradeNoGoodsLoaded => 'No goods are available right now.';

  @override
  String get tradeRiskPanelTitle => 'Travel and market risks';

  @override
  String get tradeRiskPanelSubtitle =>
      'Each good shows spoilage, price swings, trip damage or confiscation where it applies.';

  @override
  String get tradeRiskInsightBody =>
      '16 CONTRABAND LINES in 4 categories (starter, bulk, luxury, dangerous). Not every country sells everything — travel to buy cheap and sell where demand is high.\nSTARTER/BULK: spoilage or low margin — great for learning routes.\nLUXURY: diamonds, gold, watches, art — high value, plan your sell country.\nDANGEROUS: weapons and counterfeit cash — high seizure risk; keep Wanted low.\nUse the filters at the top to browse quickly.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h spoil window';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% price swing';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct% seizure risk per trip';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct% damage chance per trip';
  }

  @override
  String tradeRiskHeavyWeight(String weight) {
    return 'Heavy ($weight weight)';
  }

  @override
  String get tradeGoodNotAvailableHere =>
      'This product is not for sale in your current country. Travel to a source country.';

  @override
  String get tradeNoBuyableGoodsInCountry =>
      'No trade goods for sale in this country. Travel to a source country to stock up.';

  @override
  String get tradeUnavailableGoodsTitle => 'Not sold here';

  @override
  String tradeUnavailableGoodsSubtitle(String count) {
    return '$count products only in source countries';
  }

  @override
  String get tradeTravelToSourceHint =>
      'Only sold in source countries — travel to buy';

  @override
  String get tradeCategoryAll => 'All';

  @override
  String get tradeCategoryStarter => 'Starter';

  @override
  String get tradeCategoryBulk => 'Bulk';

  @override
  String get tradeCategoryLuxury => 'Luxury';

  @override
  String get tradeCategoryDangerous => 'Dangerous';

  @override
  String get tradeFilterAvailableHere => 'For sale here';

  @override
  String tradeMarketCatalogSummary(String total, String here) {
    return '$total products · $here for sale in this country';
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
  String get courtLoadFailed => 'Could not load court data. Please try again.';

  @override
  String get courtAppealDialogIntro =>
      'Do you want to submit an appeal for this conviction?';

  @override
  String courtCostLine(String amount) {
    return 'Cost: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Judge: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruptibility: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'On success: roughly 20-40% sentence reduction';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Appeal granted. New sentence: $minutes minutes.';
  }

  @override
  String get courtAppealDenied => 'Appeal denied.';

  @override
  String get courtBribeOfferIntro =>
      'Offer an amount. The amount is always deducted, even on failure.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Bribe amount: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€${thousands}k';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Estimated success chance: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Judge bribed. You are released immediately.';

  @override
  String get courtBribeFailedDebited =>
      'Bribe failed. Amount was still deducted.';

  @override
  String get courtRecordActive => 'Active';

  @override
  String get courtRecordServed => 'Served';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Appeal granted: $fromMinutes → $toMinutes minutes';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Appeal denied: $minutes minutes remained';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Bribe failed: $amount paid';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Convicted to $minutes minutes';
  }

  @override
  String get courtPartialLoadWarning =>
      'Heads up: part of the court data could not be loaded. Pull to refresh to retry.';

  @override
  String get courtNoActiveSentence => 'No active sentence';

  @override
  String get courtNotJailedHint =>
      'You are currently not jailed. Your criminal record remains visible below.';

  @override
  String get courtActiveSentenceTitle => 'Active sentence';

  @override
  String get courtDelictLabel => 'Crime';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Total sentence: $minutes minutes';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Remaining: $minutes minutes';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Current appeal cost: $amount';
  }

  @override
  String get courtButtonAppeal => 'Appeal';

  @override
  String get courtButtonBribeJudge => 'Bribe judge';

  @override
  String get courtUnknownCrime => 'Unknown';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Sentence: $minutes minutes';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Sentence: $original → $reduced minutes';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Date: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Court history';

  @override
  String get courtAppealSubmitted => 'Appeal submitted';

  @override
  String get courtCriminalRecordTitle => 'Criminal record';

  @override
  String courtTotalConvictions(String count) {
    return 'Total convictions: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Past convictions stay visible. A successful judge bribe clears only that one active case.';

  @override
  String get courtNoConvictionsYet => 'No convictions recorded yet.';

  @override
  String get courtHeroTitle => 'The courtroom';

  @override
  String get courtHeroSubtitle =>
      'Appeal or bribe the judge while you serve time. Your criminal record stays after you walk free.';

  @override
  String courtConvictionsChip(String count) {
    return '$count convictions';
  }

  @override
  String get courtActiveChip => 'Serving time';

  @override
  String get courtFreeChip => 'No active case';

  @override
  String get courtJudgeSpecialtyViolence => 'Violent crimes';

  @override
  String get courtJudgeSpecialtyFinancial => 'Financial crimes';

  @override
  String get courtJudgeSpecialtyDrugs => 'Drug-related cases';

  @override
  String get courtJudgeSpecialtyWhiteCollar => 'White-collar crime';

  @override
  String get courtJudgeSpecialtyOrganized => 'Organized crime';

  @override
  String get courtOddsTitle => 'What changes your appeal chance';

  @override
  String courtLawBonus(String level, String percent) {
    return 'Law education $level/5: +$percent%';
  }

  @override
  String courtPriorBonus(String percent) {
    return 'First conviction: +$percent%';
  }

  @override
  String courtPriorPenalty(String count, String percent) {
    return '$count prior convictions: $percent%';
  }

  @override
  String courtPriorNone(String count) {
    return '$count prior convictions: no extra modifier';
  }

  @override
  String courtWantedPenalty(String level, String percent) {
    return 'Wanted $level: -$percent% appeal';
  }

  @override
  String courtWantedOk(String level) {
    return 'Wanted $level: no appeal penalty';
  }

  @override
  String courtFbiPenalty(String level, String percent) {
    return 'FBI heat $level: -$percent% appeal';
  }

  @override
  String courtFbiOk(String level) {
    return 'FBI heat $level: no appeal penalty';
  }

  @override
  String courtAppealChance(String percent) {
    return 'Appeal chance: ~$percent%';
  }

  @override
  String get courtAppealUsed => 'You already appealed this conviction.';

  @override
  String get courtBribeHeatNote =>
      'Wanted and FBI heat change appeal odds, not this bribe.';

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
  String get hospitalCooldownTitle => 'Treatment in recovery period';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Next treatment available in: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Medical Status';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'ICU: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'HP $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle => 'ICU & triage overview';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Patient in ICU. Remaining time: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Critical status detected. Emergency care recommended.';

  @override
  String get hospitalStableStatus => 'Stable. Regular treatment available.';

  @override
  String get hospitalRefreshMedicalRecord => 'Refresh medical record';

  @override
  String get hospitalStandardTreatmentTitle => 'Standard treatment';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Affordable • restore up to $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Intensive treatment';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Faster recovery • up to $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Intensive treatment: €$cost for up to $amount HP recovery.';
  }

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
  String get inventoryCrimeWeaponTitle => 'Selected crime weapon';

  @override
  String get inventoryCrimeWeaponHint => 'Select a weapon for crimes';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Wear weapons on slot 1 and slot 2. Crimes automatically pick the better worn weapon for each crime.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'No usable weapons in inventory. Buy or move a weapon into carried items first.';

  @override
  String get inventoryPaperDoll => 'Equipment';

  @override
  String get inventoryBackpackGrid => 'Backpack';

  @override
  String get inventoryStorageGrid => 'Storage';

  @override
  String get inventoryMaterialsDepot => 'Materials depot';

  @override
  String get inventoryEquipWeapon => 'Crime weapon';

  @override
  String get inventoryEquipSecondary => 'Second weapon';

  @override
  String get inventoryEquipArmor => 'Vest';

  @override
  String get inventoryEmptySlot => 'Empty slot';

  @override
  String inventorySelectHint(String name) {
    return 'Selected: $name. Tap a valid slot to move it.';
  }

  @override
  String get inventoryOpenStorage => 'Open storage';

  @override
  String get inventoryTransferOk => 'Item moved';

  @override
  String get inventoryTransferFailed => 'Move failed';

  @override
  String get inventoryWrongDrop => 'That drop is not allowed here';

  @override
  String get inventoryMoveOne => 'Move 1';

  @override
  String get inventoryMoveAll => 'Move all';

  @override
  String inventorySlotUsage(int used, int max) {
    return 'Backpack $used/$max';
  }

  @override
  String get inventoryCarriedEmpty =>
      'You are not carrying any tools, weapons or ammo.';

  @override
  String get inventorySectionTools => 'Tools';

  @override
  String get inventorySectionWeapons => 'Weapons';

  @override
  String get inventorySectionAmmo => 'Ammo';

  @override
  String get inventoryWeaponFallbackName => 'Weapon';

  @override
  String get inventoryAmmoFallbackName => 'Ammo';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Condition: $condition% • Quantity: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Quantity: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Quantity: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Withdraw from storage: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Max: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Invalid quantity';

  @override
  String get inventorySnackWeaponStored => 'Weapon stored';

  @override
  String get inventorySnackWeaponWithdrawn => 'Weapon withdrawn';

  @override
  String get inventorySnackCashStored => 'Cash deposited';

  @override
  String get inventorySnackCashWithdrawn => 'Cash withdrawn';

  @override
  String get inventorySnackDrugsWithdrawn => 'Drugs withdrawn';

  @override
  String get inventoryActionFailed => 'Action failed';

  @override
  String get inventoryStorageNoCategory => 'No storage type';

  @override
  String get inventoryCountsWeapons => 'Weapons';

  @override
  String get inventoryCountsDrugs => 'Drugs';

  @override
  String get inventoryCountsCash => 'Cash';

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
      'You are in another country. You cannot access this storage here.';

  @override
  String get inventoryWeaponStorageTitle => 'Weapon storage';

  @override
  String get inventoryStoreWeapons => 'Store';

  @override
  String get inventoryInStorage => 'In storage';

  @override
  String get inventoryUnknownWeapon => 'Unknown weapon';

  @override
  String get inventoryTakeOne => 'Take 1';

  @override
  String get inventoryNoWeaponsInStorage => 'No weapons in this storage.';

  @override
  String get inventoryCashStorageTitle => 'Cash storage';

  @override
  String get inventoryDepositCash => 'Deposit cash';

  @override
  String get inventoryWithdrawCash => 'Withdraw cash';

  @override
  String get inventoryDrugStorageTitle => 'Drug storage';

  @override
  String get inventoryNoDrugsInStorage => 'No drugs in storage.';

  @override
  String get inventoryNotForTools =>
      'This property is not for tool storage. Use a warehouse for tools.';

  @override
  String get inventoryCategoryTools => 'Tools';

  @override
  String get inventoryCategoryDrugs => 'Drugs';

  @override
  String get inventoryCategoryWeapons => 'Weapons';

  @override
  String get inventoryCategoryCash => 'Cash';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max slots ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Accessible in current country';

  @override
  String get inventoryStorageNotAccessibleHere =>
      'Not accessible in this country';

  @override
  String get loadoutEquipFailed => 'Failed to equip loadout';

  @override
  String get loadoutDeleteFailed => 'Failed to delete loadout';

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
  String get backpackPurchaseFailedGeneric =>
      'Could not complete the purchase.';

  @override
  String get backpackUpgradeFailedGeneric => 'Could not complete the upgrade.';

  @override
  String get backpackUnknownEvent => 'Unknown action';

  @override
  String get backpackLoadFailedGeneric => 'Something went wrong';

  @override
  String get backpackOwnedBadge => 'Owned';

  @override
  String get availableBackpacks => 'Available backpacks';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Current: $name (+$slots slots)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'New: $name (+$slots slots)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Upgrade: +$delta slots';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Total: $totalSlots slots';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(storage issue — try signing in again)';

  @override
  String get blackMarketTabBackpacks => 'Backpacks';

  @override
  String get bmHubAdjustFiltersHint => 'Try adjusting your filters';

  @override
  String get bmHubEmptyMyListingsHint =>
      'List vehicles from Garage or Marina, or sell carried tools with Sell item';

  @override
  String get bmHubSellerLabel => 'Seller';

  @override
  String get bmHubAskingPriceLabel => 'Asking price';

  @override
  String get bmHubMarketValueShort => 'Market value';

  @override
  String get bmHubBuyNow => 'Buy now';

  @override
  String get bmHubListedFor => 'Listed for';

  @override
  String get bmHubEditPrice => 'Edit price';

  @override
  String get bmHubDelist => 'Delist';

  @override
  String get bmHubFilterListingsTitle => 'Filter listings';

  @override
  String get bmHubLabelCountry => 'Country';

  @override
  String get bmHubAllCountries => 'All countries';

  @override
  String get bmHubLabelVehicleType => 'Vehicle type';

  @override
  String get bmHubAllTypes => 'All types';

  @override
  String get bmHubCars => 'Cars';

  @override
  String get bmHubBoats => 'Boats';

  @override
  String get bmHubPriceRange => 'Price range';

  @override
  String get bmHubClearFilters => 'Clear filters';

  @override
  String get bmHubApply => 'Apply';

  @override
  String get bmHubBuyVehicleTitle => 'Buy vehicle';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Buy $name for $price?';
  }

  @override
  String get bmHubVehiclePurchased => 'Vehicle purchased successfully!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Failed to buy vehicle';

  @override
  String get bmHubNewPriceEuro => 'New price (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Enter new price';

  @override
  String get bmHubCurrentPrice => 'Current price';

  @override
  String get bmHubPriceUpdated => 'Price updated successfully!';

  @override
  String get bmHubPriceUpdateFailed => 'Failed to update price';

  @override
  String get bmHubUpdateButton => 'Update';

  @override
  String get bmHubDelistVehicleTitle => 'Delist vehicle';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Remove $name from the market?';
  }

  @override
  String get bmHubVehicleDelisted => 'Vehicle delisted successfully!';

  @override
  String get bmHubDelistFailed => 'Failed to delist vehicle';

  @override
  String get bmHubLocationUnknown => 'UNKNOWN';

  @override
  String get bmHubNoMarketListingsTitle => 'No listings';

  @override
  String get bmHubNoMarketListingsBody =>
      'No vehicles or items match your filters. You can list carried tools with the Sell item button.';

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
  String get bmHubSellCarriedItem => 'Sell item';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Qty $qty • $pct% condition';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Guide €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Buy item';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return 'Buy $name for $price?';
  }

  @override
  String get bmHubToolPurchased => 'Item purchased';

  @override
  String get bmHubToolPurchaseFailed => 'Could not buy item';

  @override
  String get bmHubDelistToolTitle => 'Remove listing';

  @override
  String bmHubDelistToolConfirm(String name) {
    return 'Remove $name from the market?';
  }

  @override
  String get bmHubToolDelisted => 'Listing removed';

  @override
  String get bmHubListToolTitle => 'List item on marketplace';

  @override
  String get bmHubListToolSelectLabel => 'Carried item';

  @override
  String get bmHubListToolSubmit => 'List';

  @override
  String get bmHubToolListedMessage => 'Item is now listed';

  @override
  String get bmHubListToolFailed => 'Could not list item';

  @override
  String get bmHubLoadCarriedToolsFailed => 'Could not load carried items';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'No carried items to sell (or already listed)';

  @override
  String get bmHubInvalidToolPrice => 'Enter a valid price';

  @override
  String get arrested => 'Arrested!';

  @override
  String get jailMessage =>
      'You were arrested during your journey and all goods were confiscated!';

  @override
  String get confirmAction => 'Are you sure?';

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
  String get hitlistHeroTitle => 'Open contracts';

  @override
  String get hitlistHeroSubtitle =>
      'Place a bounty or take an open contract. Detective intel, weapons and country all apply.';

  @override
  String hitlistOpenCount(String count) {
    return '$count open';
  }

  @override
  String get hitlistEmptyBody =>
      'No public contracts right now. Place a bounty of at least €50,000 to start a hunt.';

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
  String get hitlistErrMissingBounty => 'Bounty amount is required';

  @override
  String get hitlistErrBountyTooLow => 'Minimum bounty is €50,000';

  @override
  String get hitlistErrCannotHitYourself =>
      'You cannot place a hit on yourself';

  @override
  String get hitlistErrHitAlreadyExists =>
      'You already have an active hit on this player';

  @override
  String get hitlistErrInsufficientMoney => 'You don\'t have enough money';

  @override
  String get hitlistErrMissingCounterBounty =>
      'Counter-bounty amount is required';

  @override
  String get hitlistErrHitNotFound => 'Hit not found';

  @override
  String get hitlistErrNotTarget => 'Only the target can place a counter-bid';

  @override
  String get hitlistErrHitNotActive => 'Hit is not active';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'Counter-bounty must be higher than the original bounty';

  @override
  String get hitlistErrMissingWeapon => 'Weapon is required';

  @override
  String get hitlistErrWeaponNotFound => 'Weapon not found';

  @override
  String get hitlistErrWeaponNotOwned =>
      'You do not own this weapon or it is broken';

  @override
  String get hitlistErrWeaponBroken =>
      'Your selected weapon is broken. Repair it first.';

  @override
  String get hitlistErrInsufficientAmmo => 'You do not have enough ammunition';

  @override
  String get hitlistErrInvalidAmmoHit => 'Invalid ammunition quantity';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'Target has active hit protection';

  @override
  String get hitlistErrInvalidInvestigationTier => 'Invalid investigation type';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'An investigation is already pending for this hit. Wait for your detective message.';

  @override
  String get hitlistErrInvalidCaseId => 'Invalid case file number';

  @override
  String get hitlistErrMurderCaseNotFound => 'Case file not found';

  @override
  String get hitlistErrMurderCaseExpired =>
      'Investigation window expired (24 hours)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Investigation for this case has already been started';

  @override
  String get hitlistErrNotPlacer => 'Only the placer can cancel the hit';

  @override
  String get hitlistInvestigationOptions => 'Investigation options';

  @override
  String get hitlistInvestigationChooseSpeedPrice => 'Choose speed and price:';

  @override
  String get hitlistInvestigationQuick =>
      'Quick investigation (€1,000,000 • 1 hour)';

  @override
  String get hitlistInvestigationStandard =>
      'Standard investigation (€500,000 • 6 hours)';

  @override
  String get hitlistInvestigationSlow =>
      'Slow investigation (€250,000 • 24 hours)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Investigation queued. Cost $cost. ETA: $etaMinutes min. Report will arrive via Detective Bureau messages (around $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'Investigation failed';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'Investigation could not be completed';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Hit successful! Bounty and loot received: cash $cash, carried items $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'Hit attempt timed out. Please try again.';

  @override
  String get hitlistNoUsableWeapons =>
      'You have no usable weapons in your inventory. Buy or repair a weapon first.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Error loading weapons: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Error loading players: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => '1 day ago';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count days ago';
  }

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
  String eachGivesDefenseAmount(String defense) {
    return '+$defense defense';
  }

  @override
  String get repairArmor => 'Repair';

  @override
  String get armorRepaired => 'Vest repaired';

  @override
  String get couldNotRepairArmor => 'Could not repair vest';

  @override
  String get couldNotDismissBodyguard => 'Could not dismiss bodyguard';

  @override
  String vestTradeInCredit(String amount) {
    return 'Trade-in $amount';
  }

  @override
  String get vestTradeInHint =>
      'Buying another vest credits part of your current vest, based on condition. Repairing a worn vest is cheaper than replacing it.';

  @override
  String get upgradeArmor => 'Upgrade';

  @override
  String get vestWeakVsStab => 'Weak vs stab';

  @override
  String get vestWeakVsBullets => 'Weak vs bullets';

  @override
  String get vestWeakVsAp => 'Weak vs AP';

  @override
  String get bodyguardStreet => 'Street muscle';

  @override
  String get bodyguardStreetDesc =>
      'Cheap extra eyes. Lower defense, lower daily wage.';

  @override
  String get bodyguardStandard => 'Bodyguard';

  @override
  String get bodyguardStandardDesc =>
      'Standard protection. +10 defense and a €10,000 daily wage.';

  @override
  String get bodyguardElite => 'Elite bodyguard';

  @override
  String get bodyguardEliteDesc =>
      'Hardened closer. Higher defense and a steeper daily wage.';

  @override
  String get bodyguardDismiss => 'Dismiss';

  @override
  String bodyguardCapLine(String used, String cap) {
    return '$used / $cap bodyguards';
  }

  @override
  String get bodyguardCapReached => 'Bodyguard limit reached';

  @override
  String bodyguardHired(String name) {
    return 'Hired $name';
  }

  @override
  String bodyguardDismissed(String name) {
    return 'Dismissed $name';
  }

  @override
  String armorConditionPercent(String percent) {
    return 'Condition $percent%';
  }

  @override
  String get securityErrorNoArmor => 'You are not wearing a vest';

  @override
  String get securityErrorArmorNotDamaged =>
      'This vest is already in full condition';

  @override
  String get securityErrorBodyguardCap =>
      'You already have the maximum number of bodyguards';

  @override
  String get securityErrorInvalidBodyguardType => 'Invalid bodyguard type';

  @override
  String get securityErrorNotEnoughBodyguards =>
      'You do not have that many bodyguards of this type';

  @override
  String get lightArmor => 'Light Armor';

  @override
  String get basicProtection => 'Basic protection';

  @override
  String get heavyArmor => 'Heavy Armor';

  @override
  String get strongProtection => 'Strong protection';

  @override
  String get bulletproofVest => 'Bulletproof vest';

  @override
  String get veryStrongProtection => 'Very strong protection';

  @override
  String get stabVest => 'Stab vest';

  @override
  String get stabVestDesc =>
      'Stops knives and stab weapons. Weak against bullets.';

  @override
  String get bulletproofVestDesc =>
      'Standard ballistic protection against regular ammo.';

  @override
  String get bulletproofVestPremium => 'Premium bulletproof vest';

  @override
  String get bulletproofVestPremiumDesc =>
      'Heavier plates and more coverage against regular rounds.';

  @override
  String get ceramicApVest => 'AP plate vest';

  @override
  String get ceramicApVestDesc =>
      'Ceramic plates that stop armor-piercing rounds.';

  @override
  String get vestProtectsStab => 'Stab';

  @override
  String get vestProtectsBullets => 'Bullets';

  @override
  String get vestProtectsAp => 'Armor-piercing';

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
  String get replaceArmor => 'Replace';

  @override
  String get bodyguardProductName => 'Bodyguard';

  @override
  String securityLoadError(String error) {
    return 'Error loading security: $error';
  }

  @override
  String get securityStatusLoadFailed => 'Could not load security status.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Condition $percent% · base $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Daily wage $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Daily system cost: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Next payroll: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'If you cannot pay the daily wage, all bodyguards leave.';

  @override
  String get armorOneAtATimeHint =>
      'You can only wear 1 vest at a time. Repair a damaged vest, or buy another one and get a condition-based trade-in on the vest you replace.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Now +$defense at $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'Could not buy bodyguard';

  @override
  String get couldNotBuyArmor => 'Could not buy armor';

  @override
  String get armorAlreadyEquippedLong =>
      'You already wear this armor. You can only wear 1 armor at a time.';

  @override
  String get securityErrorArmorNotFound => 'Armor not found';

  @override
  String get securityErrorMinQuantity => 'Quantity must be at least 1';

  @override
  String get hit => 'HIT';

  @override
  String get counterBidLabel => 'COUNTER-BID';

  @override
  String daysAgo(String count, String plural) {
    return '$count day$plural ago';
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
  String get hitDefendedBySecurity =>
      'The target survived — the contract stays open. Bodyguards and HP were hit; try again after the cooldown.';

  @override
  String hitDefendedAttrition(String guards, String health) {
    return '$guards bodyguards down, target -$health HP. Next attempt in 10 minutes.';
  }

  @override
  String hitCombatAttackerAttrition(String guards, String health) {
    return 'You lost $guards bodyguards and $health HP.';
  }

  @override
  String hitlistErrCombatCooldown(String minutes) {
    return 'The target is still under fire. Try again in $minutes minutes.';
  }

  @override
  String hitCombatBreakdown(String armor, String guards, String chance) {
    return 'Vest +$armor · bodyguards +$guards · your chance $chance%';
  }

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
  String get ammoGeneric => 'Ammo';

  @override
  String get ammoPerCrimeSuffix => 'per crime';

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
      'Production started: active for 8 hours, claim every 20 minutes';

  @override
  String get ammoFactoryTitle => 'Ammo Factory';

  @override
  String get ammoFactoryIntro =>
      'Produces in batches; you claim every 20 minutes (up to 8 hours of backlog per session).';

  @override
  String get ammoFactoryWhatYouCanDo => 'What you can do:';

  @override
  String get ammoFactoryActionBuy => 'Buy a factory in your current country';

  @override
  String get ammoFactoryActionProduce =>
      'Claim production (interval: 20 minutes, max backlog: 8 hours per session)';

  @override
  String get ammoFactoryActionOutput =>
      'Upgrade output to level 5 for more rounds per claim';

  @override
  String get ammoFactoryActionQuality =>
      'Upgrade quality for stronger market prices';

  @override
  String get ammoFactoryBlackMarketTitle => 'Ammo for sale';

  @override
  String get ammoFactoryBlackMarketBody =>
      'The ammo factory does not sell bullets directly from this screen. Use the Black Market for buying and selling ammo.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Buy and sell ammo through the Black Market, not directly from the factory.';

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
  String get ammoFactoryErrCountryRequired => 'Country is required';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Player not found';

  @override
  String get ammoFactoryErrWrongCountry =>
      'You must be in the same country to buy this factory';

  @override
  String get ammoFactoryErrCouldNotPurchase => 'Could not purchase factory';

  @override
  String get ammoFactoryErrAlreadyOwned => 'Factory is already owned';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Not enough money to buy factory';

  @override
  String get ammoFactoryErrCouldNotProduce => 'Could not produce ammo';

  @override
  String get ammoFactoryErrNotOwned => 'You do not own a factory';

  @override
  String get ammoFactoryErrOnCooldown => 'Factory is on cooldown';

  @override
  String get ammoFactoryErrInactive =>
      'Factory ownership lost due to inactivity';

  @override
  String get ammoFactoryErrCouldNotUpgrade => 'Could not upgrade factory';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Not enough money to upgrade factory';

  @override
  String get ammoFactoryErrMaxLevel => 'Factory is already max level';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'Upgrade type must be output or quality';

  @override
  String get ammoFactoryErrEducationNotMet => 'Education requirements not met';

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
      'Production window: active (20 min interval)';

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
  String get shootingIntro =>
      'Improve your accuracy and increase your crime success rate';

  @override
  String get shootingTrainSuccess => 'Training complete';

  @override
  String get shootingMaxSessionsReached => 'Maximum training sessions reached';

  @override
  String get shootingTrainingProgressTitle => 'Training Progress';

  @override
  String get shootingSessionsCompletedLabel => 'Sessions completed:';

  @override
  String get shootingProgressCompleteSuffix => 'complete';

  @override
  String get shootingCurrentBonusTitle => 'Current Bonus';

  @override
  String get shootingAccuracyBonusLabel => 'Accuracy Bonus';

  @override
  String get shootingMaximumLabel => 'Maximum';

  @override
  String get shootingBonusAppliedToCrimes =>
      'This bonus is applied to all your crime attempts';

  @override
  String get shootingReadyToTrain => 'Ready to train';

  @override
  String get shootingTrainingCooldownTitle => 'Training Cooldown';

  @override
  String shootingCooldownLabel(String time) {
    return 'Next session at: $time';
  }

  @override
  String get shootingCooldownHint =>
      'You must wait 1 hour between training sessions';

  @override
  String get shootingTrainingInProgress => 'Training...';

  @override
  String get shootingHowItWorksTitle => 'How does it work?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Train every hour for an accuracy boost';

  @override
  String get shootingHowItWorksBullet2 => '• Each session gives +0.1% bonus';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Maximum of 100 sessions (+10% total)';

  @override
  String get shootingHowItWorksBullet4 => '• Increases your crime success rate';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Permanent bonus, every session counts';

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
  String get trainingHubMenuLabel => 'Training';

  @override
  String get trainingHubTitle => 'Training hub';

  @override
  String get trainingHubSubtitle =>
      'Three gym tracks (strength, speed, stamina) plus shooting range. Each track stacks up to 100 sessions with a 1-hour cooldown and adds to your crime success chance.';

  @override
  String get trainingHubSectionGym => 'Gym';

  @override
  String get trainingHubSectionShooting => 'Shooting range';

  @override
  String get trainingHubRefreshStatus => 'Refresh';

  @override
  String get trainingHubRefreshTooltip => 'Reload status from the server';

  @override
  String get trainingHubOpenCrimes => 'Open crimes';

  @override
  String get trainingHubOpenCrimesHint =>
      'Active bonuses show on the Crimes screen.';

  @override
  String get trainingHubMoreInfoTitle => 'More info & options';

  @override
  String get trainingHubMoreInfoCombo =>
      'Same UTC calendar day: complete at least one gym session and one range session for a small extra crime success bonus (+0.5%).';

  @override
  String get trainingHubMoreInfoSeparate =>
      'Gym and range each keep their own 1-hour cooldown and 100-session cap.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'Shooting range progress also feeds hitlist calculations on the server.';

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
    return 'Combo active: +$pct% on crimes';
  }

  @override
  String get gym => 'Gym';

  @override
  String get gymIntro =>
      'Train your strength and increase your crime success rate';

  @override
  String get gymTrainSuccess => 'Training complete';

  @override
  String get gymMaxSessionsReached => 'Maximum sessions reached';

  @override
  String get gymTrainingProgressTitle => 'Training Progress';

  @override
  String get gymSessionsCompletedLabel => 'Sessions completed:';

  @override
  String get gymProgressCompleteSuffix => 'complete';

  @override
  String get gymCurrentBonusTitle => 'Current Bonus';

  @override
  String gymSessions(String count) {
    return 'Sessions: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Strength Bonus';

  @override
  String get gymMaximumLabel => 'Maximum';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Strength bonus: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'This bonus is applied to all your crime attempts';

  @override
  String get gymReadyToTrain => 'Ready to train';

  @override
  String get gymTrainingCooldownTitle => 'Training Cooldown';

  @override
  String gymCooldown(String time) {
    return 'Next session at $time';
  }

  @override
  String get gymCooldownHint =>
      'You must wait 1 hour between training sessions';

  @override
  String get gymTrain => 'Train';

  @override
  String get gymTrainingInProgress => 'Training...';

  @override
  String get gymHowItWorksTitle => 'How does it work?';

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
      '• Three tracks: strength (+4%), speed (+2%), stamina (+2%)';

  @override
  String get gymHowItWorksBullet2 =>
      '• Each track: 100 sessions max, 1 hour cooldown';

  @override
  String get gymHowItWorksBullet3 =>
      '• Combined gym bonus up to +8% on crime success';

  @override
  String get gymHowItWorksBullet4 =>
      '• Smart train picks the first ready track';

  @override
  String get gymHowItWorksBullet5 =>
      '• Permanent progress — every session counts';

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
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Ireland';

  @override
  String get countryLuxembourg => 'Luxembourg';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryDenmark => 'Denmark';

  @override
  String get countrySweden => 'Sweden';

  @override
  String get countryNorway => 'Norway';

  @override
  String get countryFinland => 'Finland';

  @override
  String get countryPoland => 'Poland';

  @override
  String get countryCzechia => 'Czechia';

  @override
  String get countryGreece => 'Greece';

  @override
  String get countryTurkey => 'Turkey';

  @override
  String get countryUae => 'United Arab Emirates';

  @override
  String get countryDubai => 'Dubai';

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
  String get toolThermalDrill => 'Thermal Drill';

  @override
  String get toolCategoryBoltCutter => 'Bolt cutters';

  @override
  String get toolCategoryBurglaryKit => 'Burglary kit';

  @override
  String get toolCategoryCarTools => 'Car theft tools';

  @override
  String get toolCategoryJerryCan => 'Jerry can';

  @override
  String get toolCategorySprayPaint => 'Spray paint';

  @override
  String get toolCategoryCrowbar => 'Crowbar';

  @override
  String get toolCategoryGlassCutter => 'Glass cutter';

  @override
  String get toolCategoryLaptop => 'Laptop';

  @override
  String get toolCategoryCounterfeiting => 'Counterfeiting';

  @override
  String get toolCategoryToolbox => 'Toolbox';

  @override
  String get toolCategoryRope => 'Rope';

  @override
  String get toolCategorySilencer => 'Silencer';

  @override
  String get toolCategoryFakeDocs => 'Fake documents';

  @override
  String get toolCategoryNightVision => 'Night vision';

  @override
  String get toolCategoryBurnerPhone => 'Burner phone';

  @override
  String get toolCategoryGpsJammer => 'GPS jammer';

  @override
  String get toolCategoryThermalDrill => 'Thermal drill';

  @override
  String get toolsScreenTitle => 'Black Market – Tools';

  @override
  String get toolsTabBuy => 'Buy';

  @override
  String get toolsTabMyTools => 'My tools';

  @override
  String get toolsNoToolsAvailable => 'No tools available';

  @override
  String get toolsEmptyInventoryTitle => 'You do not have any tools yet';

  @override
  String get toolsEmptyInventoryHint => 'Buy tools in the shop';

  @override
  String get toolsNotEnoughMoney => 'You do not have enough money!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'You do not have enough money for repair!';

  @override
  String get toolsBuyError => 'Error while buying';

  @override
  String get toolsRepairError => 'Error while repairing';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName purchased!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName repaired for €$cost';
  }

  @override
  String get toolsBadgeInventoryFull => 'FULL';

  @override
  String get toolsBadgeBroken => 'BROKEN';

  @override
  String get toolsBadgeRepair => 'REPAIR';

  @override
  String toolsLoadError(String error) {
    return 'Could not load tools: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Tool not found.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Your inventory is full. Store some tools or upgrade capacity.';

  @override
  String get toolsErrPurchaseServer =>
      'Tool purchase failed due to a server issue.';

  @override
  String get toolsErrToolNotOwned => 'You don\'t own this tool.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'Tool is already at maximum durability.';

  @override
  String get toolsErrRepairServer =>
      'Tool repair failed due to a server issue.';

  @override
  String toolsNetworkError(String error) {
    return 'Network error: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Crime successful!';

  @override
  String get crimeOutcomeFailed => 'Crime failed';

  @override
  String get jobOutcomeSuccess => 'Job completed!';

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
  String get crimeResultMoneyLabel => 'Money';

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
  String get crimeOutcomeRowReward => 'Reward:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Tools:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% durability';
  }

  @override
  String get icuIntensiveCareTitle => 'Intensive care';

  @override
  String get icuInjuredLine =>
      'You were seriously injured during your criminal activities.';

  @override
  String get icuUnconsciousLine =>
      'You are now in intensive care and unconscious.';

  @override
  String get icuRecoveryTimeLabel => 'Recovery time:';

  @override
  String get icuWakeHp => 'You wake up with 10 HP';

  @override
  String get icuNoActionsHint =>
      'You cannot perform actions during this time.\nBe more careful with your health!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 You\'re free! Bail paid: €$amount';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Not enough money for bail (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Please wait: ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => 'Escape succeeded! You are free.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'Escape failed. Sentence extended by $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Escape failed';

  @override
  String jailErrorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get jailTimeLeft => 'Time left';

  @override
  String jailPayBail(int amount) {
    return 'Pay bail (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'You cannot commit crimes, work, or travel while serving your sentence.';

  @override
  String get jailAttemptEscape => 'Attempt escape';

  @override
  String jailEscapeAttemptsLeft(String remaining, String max) {
    return 'Attempt escape ($remaining/$max)';
  }

  @override
  String jailEscapeCooldown(String time) {
    return 'Next escape in $time';
  }

  @override
  String get jailEscapeAttemptsExhausted =>
      'No escape attempts left this sentence';

  @override
  String get jailYouAreInJail => 'You are in jail';

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
  String get prostitutionCollect => 'Collect now';

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
  String get prostitutionDistrictOwnedBadge => 'Owned';

  @override
  String get prostitutionOwnerLabel => 'Owner:';

  @override
  String get prostitutionForSale => 'For sale';

  @override
  String get prostitutionRoomsLabel => 'Rooms:';

  @override
  String get prostitutionRoomsRented => 'rented';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Red Light District ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Occupied';

  @override
  String get prostitutionNotApplicable => 'N/A';

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
  String get prostitutionTabWorkers => 'Workers';

  @override
  String get prostitutionTabRld => 'RLD';

  @override
  String get prostitutionTabEvents => 'Events';

  @override
  String get prostitutionTabSocial => 'Social';

  @override
  String get prostitutionRecruitCeremonyTitle => 'New recruit';

  @override
  String prostitutionCollectConfirm(String amount) {
    return 'Collect €$amount in pending earnings?';
  }

  @override
  String get prostitutionCollectEmpty => 'No earnings to collect right now.';

  @override
  String prostitutionCollectSuccess(String amount) {
    return 'Collected €$amount.';
  }

  @override
  String get prostitutionCollectFailed => 'Could not collect earnings.';

  @override
  String get prostitutionWorkersKpi => 'Workers (S/RLD/NC)';

  @override
  String get prostitutionHourlyKpi => '€/hour';

  @override
  String get prostitutionRecruitReady => 'Ready';

  @override
  String get prostitutionRetry => 'Retry';

  @override
  String get prostitutionMove => 'Move';

  @override
  String get prostitutionFbiHeat => 'FBI Heat';

  @override
  String get prostitutionRaidStatsTitle => 'Raid risk';

  @override
  String get prostitutionRaidStatsDistricts => 'Districts';

  @override
  String get prostitutionRaidStatsBusted => 'Currently busted';

  @override
  String prostitutionUpgradeTierConfirm(String tier, String cost) {
    return 'Upgrade tier to $tier for €$cost?';
  }

  @override
  String prostitutionUpgradeSecurityConfirm(String level, String cost) {
    return 'Upgrade security to level $level for €$cost?';
  }

  @override
  String prostitutionRoomsOccupied(String occupied, String total) {
    return '$occupied/$total rooms';
  }

  @override
  String prostitutionNextEarnings(String net) {
    return 'Next: €$net/h net';
  }

  @override
  String prostitutionCurrentEarningsNet(String net) {
    return 'Now: €$net/h net';
  }

  @override
  String prostitutionRaidReduction(String pct) {
    return 'Raid reduction: $pct';
  }

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
  String get achievementsSectionProgress => 'Progress';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent% complete';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostitution';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Crimes';

  @override
  String get achievementsCategoryNameJobs => 'Jobs';

  @override
  String get achievementsCategoryNameSchool => 'School';

  @override
  String get achievementsCategoryNameVehicles => 'Vehicles';

  @override
  String get achievementsCategoryNameTravel => 'Travel';

  @override
  String get achievementsCategoryNameDrugs => 'Drugs';

  @override
  String get achievementsCategoryNameTrade => 'Trade';

  @override
  String get achievementsCategoryNameGeneral => 'General';

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
  String schoolTrainBonusLevels(int count) {
    return '+$count Lv';
  }

  @override
  String schoolTrainBonusCerts(int count) {
    return '+$count cert';
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
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Asset: Drug facility slot upgrade I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Asset: Drug facility slot upgrade II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Asset: Drug facility slot upgrade III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Asset: Drug facility slot upgrade IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Asset: Drug facility equipment upgrade I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Asset: Drug facility equipment upgrade II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Asset: Drug facility equipment upgrade III';

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
  String get educationTrackNameNarcotics => 'Narcotics Engineering';

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
  String get schoolTrackDescriptionNarcotics =>
      'Controlled cultivation, process electrics and advanced chemical production.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown active: ${seconds}s remaining';
  }

  @override
  String get schoolTrackMaxLevelReached => 'Track is already at max level';

  @override
  String get schoolTrackStartFailed => 'Failed to start training';

  @override
  String get educationCertHydroponicSpecialist =>
      'Hydroponics Specialist Certification';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Process Electrics Specialist Certification';

  @override
  String get educationCertClandestineChemist =>
      'Clandestine Chemist Certification';

  @override
  String get educationCertNarcoGridArchitect =>
      'Narco Grid Architect Certification';

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
  String get rivalryChallengeHint =>
      'Enter a player name (or ID) to start a rivalry.';

  @override
  String get rivalryPlayerIdHint => 'Player name or ID';

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
  String get prostitutionBetrayalDefaultMessage =>
      'Betrayal! Your nightclub was hit by an intel leak.';

  @override
  String get prostitutionLoadError => 'Error loading data';

  @override
  String get prostitutionNoDistrictInCountry =>
      'No Red Light District found in this country';

  @override
  String get prostitutionMovedToStreet => 'Moved to street';

  @override
  String get prostitutionArrestedCannotAssign =>
      'This prostitute is arrested and cannot be assigned.';

  @override
  String get prostitutionNoNightclubVenue =>
      'You do not have a nightclub venue yet to assign staff.';

  @override
  String get prostitutionNightclubVenueName => 'Nightclub';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Nightclub #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Assigned to nightclub';

  @override
  String get prostitutionArrestedCannotWork =>
      'This prostitute is arrested and cannot work.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Needs $duration rest before the next shift.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Work shift completed';

  @override
  String get prostitutionNoWorkersToAssign =>
      'No available prostitutes to send to work.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostitutes sent to work.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success prostitutes sent to work, $failed failed.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Recruited!';

  @override
  String get prostitutionRecruitFailed => 'Recruitment failed';

  @override
  String get prostitutionRecruitConnectionError =>
      'Recruitment failed due to a connection error';

  @override
  String get prostitutionEventUpdate => 'Event updated';

  @override
  String get prostitutionBuyPropertyFirst => 'Buy a house or apartment first';

  @override
  String prostitutionWorkAll(int count) {
    return 'Work all ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'No free housing slot. Buy or upgrade a house or apartment before recruiting more prostitutes.';

  @override
  String get prostitutionHousingTitle => 'Housing';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Each prostitute must work at least one shift every $days days to cover rent.';
  }

  @override
  String get prostitutionHousingSlots => 'Slots';

  @override
  String get prostitutionHousingFree => 'Free';

  @override
  String get prostitutionHousingHomes => 'Homes';

  @override
  String get prostitutionHousingAvgUpgrade => 'Avg upgrade';

  @override
  String get prostitutionHousingHappinessBonus => 'Happiness bonus';

  @override
  String get prostitutionHousingWeeklyRent => 'Weekly rent';

  @override
  String get prostitutionHousingAtRisk => 'At risk';

  @override
  String get prostitutionHousingSafe => 'Safe';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Betrayal triggered: ${grams}g drugs seized, $licenses nightclub license(s) revoked.';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Earnings insight (active prostitutes)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Street: $count • €$euros/hour';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'RLD: $count • €$euros/hour';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nightclub: $count • €$euros/hour';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Total: €$euros/hour';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Ecstatic';

  @override
  String get prostitutionHappinessHappy => 'Happy';

  @override
  String get prostitutionHappinessStable => 'Stable';

  @override
  String get prostitutionHappinessStressed => 'Stressed';

  @override
  String get prostitutionHappinessMiserable => 'Miserable';

  @override
  String get prostitutionHousingExpired => 'Expired';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return '${days}d left';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Less than 1 day';

  @override
  String get prostitutionNightclubShort => 'Nightclub';

  @override
  String get prostitutionMoveToStreetButton => 'To street';

  @override
  String get prostitutionMoveToNightclubButton => 'To nightclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/hour';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Happiness $label ($score%) • Yield $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Housing: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Weekly rent €$amount';
  }

  @override
  String get prostitutionWork8h => 'Work 8h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Rest $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Next shift in $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

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

  @override
  String nightclubErrorLoading(String error) {
    return 'Error loading nightclub: $error';
  }

  @override
  String get nightclubServiceErrorStats => 'Could not load nightclub stats';

  @override
  String get nightclubServiceErrorLeaderboard => 'Could not load leaderboard';

  @override
  String get nightclubServiceErrorSeason => 'Could not load season ranking';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed => 'Resident DJ contract failed';

  @override
  String get nightclubScheduleEventFailed => 'Failed to schedule event';

  @override
  String get nightclubMarketingUpgradeFailed => 'Marketing upgrade failed';

  @override
  String get nightclubUpgradeFailed => 'Upgrade failed';

  @override
  String get nightclubIncidentResponseFailed => 'Incident response failed';

  @override
  String get nightclubRivalActionFailed => 'Rival action failed';

  @override
  String get nightclubSupplierContractFailed => 'Supplier contract failed';

  @override
  String get nightclubPromoterFailed => 'Promoter failed';

  @override
  String get nightclubHeatCooldownFailed => 'Heat cooldown failed';

  @override
  String get nightclubSmugglingFailed => 'Smuggling failed';

  @override
  String get nightclubCounterIntelFailed => 'Counter-intel failed';

  @override
  String get nightclubHospitalityStockFailed => 'Hospitality stock failed';

  @override
  String get nightclubHospitalityPricingFailed => 'Hospitality pricing failed';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Current visitors: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Nightclub Command Deck';

  @override
  String get nightclubOpsDeckRevenueToday => 'Revenue today';

  @override
  String get nightclubStockValueLabel => 'Stock value';

  @override
  String get nightclubCrewOccupancy => 'Crew occupancy';

  @override
  String get nightclubOperationalRisk => 'Operational risk';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidents (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Active crew shifts';

  @override
  String get nightclubRecentCrewHistory => 'Recent crew history';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'STANDARD';

  @override
  String get nightclubActiveDj => 'Active DJ';

  @override
  String get nightclubActiveDjNone => 'Active DJ: none';

  @override
  String nightclubUntilTime(String time) {
    return 'until $time';
  }

  @override
  String get nightclubActiveSecurity => 'Active security';

  @override
  String get nightclubActiveSecurityNone => 'Active security: none';

  @override
  String get nightclubNoDjsLoaded => 'No DJs loaded. Refresh the screen.';

  @override
  String get nightclubNoSecurityLoaded =>
      'No security loaded. Refresh the screen.';

  @override
  String get nightclubCrowdBoost => 'Crowd boost';

  @override
  String get nightclubCostPerHour => 'Cost';

  @override
  String get nightclubReputationLabel => 'Reputation';

  @override
  String get nightclubSpecialtyLabel => 'Specialty';

  @override
  String get nightclubTheftReduction => 'Theft reduction';

  @override
  String get nightclubShiftCost => 'Shift cost';

  @override
  String get nightclubSelectedStock => 'Selected';

  @override
  String get nightclubAvailableGrams => 'Available';

  @override
  String get nightclubMaxChip => 'MAX';

  @override
  String get nightclubStoredInNightclub => 'Stored in nightclub';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Current stock: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'No stored drugs yet.';

  @override
  String get nightclubStockZeroSoldOut =>
      'Current stock is 0g (everything has been sold).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Quality: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g stock';
  }

  @override
  String get nightclubOperationsLabTitle => 'Operations Lab (11 systems)';

  @override
  String get nightclubSectionResidentDjContract => '1) Resident DJ contract';

  @override
  String get nightclubContractDiscount => 'Contract discount';

  @override
  String get nightclubContractDuration => 'Contract duration';

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
  String get nightclubStartResidentContract => 'Start resident contract';

  @override
  String get nightclubSectionEventCalendar => '2) Dynamic event calendar';

  @override
  String get nightclubRecommendedToday => 'Recommended today';

  @override
  String get nightclubEventTemplate => 'Event template';

  @override
  String get nightclubScheduleEventFiveMin => 'Schedule event (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Upcoming events';

  @override
  String get nightclubSectionUpgradeTree => '3) Upgrade tree';

  @override
  String get nightclubUpgradeSoundRig => 'Sound rig';

  @override
  String get nightclubUpgradeVipLounge => 'VIP lounge';

  @override
  String get nightclubUpgradeSurveillance => 'Surveillance';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Choose upgrade';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'This upgrade is already max level.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Upgrade already maxed';

  @override
  String get nightclubUpgradeNow => 'Upgrade now';

  @override
  String get nightclubMarketingInvestment => 'Marketing investment';

  @override
  String get nightclubInvestMarketing => 'Invest in marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Police heat & incidents';

  @override
  String get nightclubHeatLabel => 'Heat';

  @override
  String get nightclubRaidRisk => 'Raid risk';

  @override
  String get nightclubCooldownLabel => 'Cooldown';

  @override
  String get nightclubStartHeatCooldown => 'Start heat cooldown';

  @override
  String get nightclubBribe => 'Bribe';

  @override
  String get nightclubLockdown => 'Lockdown';

  @override
  String get nightclubCounterIntelShort => 'Counter-intel';

  @override
  String get nightclubSectionStaffMorale => '5) Staff fatigue & morale';

  @override
  String get nightclubMorale => 'Morale';

  @override
  String get nightclubFatigue => 'Fatigue';

  @override
  String get nightclubStaffing => 'Staffing';

  @override
  String get nightclubSectionSupplierPromoter => '6) Supplier & promoter';

  @override
  String get nightclubSupplierContract => 'Supplier contract';

  @override
  String get nightclubActivateSupplier => 'Activate supplier';

  @override
  String get nightclubPromoterProfile => 'Promoter profile';

  @override
  String get nightclubHirePromoter => 'Hire promoter';

  @override
  String get nightclubSectionVipClientele => '7) VIP clientele & staff traits';

  @override
  String get nightclubVipShare => 'VIP share';

  @override
  String get nightclubSpendMultiplier => 'Spend x';

  @override
  String get nightclubTier => 'Tier';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Smuggling routes';

  @override
  String get nightclubReady => 'Ready';

  @override
  String get nightclubRoute => 'Route';

  @override
  String get nightclubStartRoute => 'Start route';

  @override
  String get nightclubLastRoute => 'Last route';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Route lock active until $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Bar & Kitchen management';

  @override
  String get nightclubServiceLevel => 'Service level';

  @override
  String get nightclubStockStatus => 'Stock status';

  @override
  String get nightclubSpoilageRisk => 'Spoilage risk';

  @override
  String get nightclubDrinksFoodStock => 'Drinks/Food stock';

  @override
  String get nightclubBuyStock => 'Buy stock';

  @override
  String get nightclubMenuPricingMode => 'Menu pricing mode';

  @override
  String get nightclubApplyPricing => 'Apply pricing';

  @override
  String get nightclubSectionRivals => '10) Rival clubs + counter-intel';

  @override
  String get nightclubSearchPlayerName => 'Search player name';

  @override
  String get nightclubTargetName => 'Target (name)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • crowd $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotage';

  @override
  String get nightclubPromoWar => 'Promo war';

  @override
  String get nightclubCounterIntelSweep => 'Counter-intel sweep';

  @override
  String get nightclubMitigation => 'Mitigation';

  @override
  String get nightclubSectionTimeline => '11) Operations timeline';

  @override
  String get nightclubNoTimelineEvents => 'No timeline events.';

  @override
  String get nightclubOperationsAlerts => 'Operations alerts';

  @override
  String get nightclubNoCriticalAlerts => 'No critical alerts.';

  @override
  String get nightclubQuickAction => 'Quick action';

  @override
  String get nightclubMgmtCrewTitle => 'Crew & shifts';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Staffing, performance and shift history.';

  @override
  String get nightclubMgmtDrugsTitle => 'Drug storage';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Manage and transfer inventory in grams.';

  @override
  String get nightclubMgmtDjTitle => 'DJ command';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Choose DJ, shift length and live crowd boost.';

  @override
  String get nightclubMgmtSecurityTitle => 'Security unit';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Theft reduction, costs and active security.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Ops Lab';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Live alerts: $alerts | Smuggling: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 systems for events, upgrades, routes and rivals.';

  @override
  String get nightclubManagementPanelTitle => 'Nightclub management';

  @override
  String get nightclubChooseZoneHint =>
      'Choose a management zone and control everything without nested inner-scroll.';

  @override
  String get nightclubChipCrew => 'Crew';

  @override
  String get nightclubChipStorage => 'Storage';

  @override
  String get nightclubChipDjShift => 'DJ shift';

  @override
  String get nightclubChipSecurity => 'Security';

  @override
  String get nightclubChipOpsAlerts => 'Ops alerts';

  @override
  String get nightclubNone => 'None';

  @override
  String get nightclubIntelligenceCardTitle => 'Nightclub Intelligence';

  @override
  String get nightclubSeasonStatus => 'Season status';

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
  String get theftCooldownRedeemTitle => 'Skip theft cooldown?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Spend $cost credits to clear the vehicle theft cooldown now? Your balance: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Don\'t show this confirmation again';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Use $credits credits';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'Credit speed-up is not available for this cooldown right now.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'No active theft cooldown to reset.';

  @override
  String get theftCooldownRedeemInsufficientCredits => 'Not enough credits.';

  @override
  String get theftCooldownRedeemFailed =>
      'Could not apply credits to the cooldown.';

  @override
  String get theftCooldownRedeemSuccess => 'Cooldown cleared.';

  @override
  String get settingsTheftCooldownConfirmTitle => 'Theft cooldown (credits)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Ask for confirmation before spending credits to skip the vehicle theft cooldown. Turn off to redeem in one tap (lightning icon next to the timer).';

  @override
  String get supportTicketsScreenTitle => 'Support tickets';

  @override
  String get supportLoadTicketsFailed => 'Failed to load tickets';

  @override
  String get supportLoadTicketFailed => 'Failed to load ticket';

  @override
  String get supportPickImageFailed => 'Failed to select image';

  @override
  String get supportSubjectMessageMinLength =>
      'Fill in subject and message (min. 3 chars).';

  @override
  String get supportTicketCreated => 'Ticket created.';

  @override
  String get supportCreateTicketFailed => 'Failed to create ticket';

  @override
  String get supportReplySent => 'Reply sent.';

  @override
  String get supportReplySendFailed => 'Failed to send reply';

  @override
  String get supportDeleteTicketTitle => 'Delete ticket';

  @override
  String get supportDeleteTicketBody =>
      'Are you sure you want to delete this ticket? This action cannot be undone.';

  @override
  String get supportTicketDeleted => 'Ticket deleted.';

  @override
  String get supportDeleteTicketFailed => 'Failed to delete ticket';

  @override
  String get supportUnknownError => 'Unknown error';

  @override
  String get supportStatusNew => 'New';

  @override
  String get supportStatusTriage => 'Triage';

  @override
  String get supportStatusInProgress => 'In progress';

  @override
  String get supportStatusWaitingPlayer => 'Waiting for player';

  @override
  String get supportStatusBlocked => 'Blocked';

  @override
  String get supportStatusResolved => 'Resolved';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportStatusArchived => 'Archived';

  @override
  String get supportCategoryBug => 'Bug';

  @override
  String get supportCategoryQuestion => 'Question';

  @override
  String get supportCategoryFeedback => 'Feedback';

  @override
  String get supportCategoryOther => 'Other';

  @override
  String get supportPriorityLow => 'Low';

  @override
  String get supportPriorityHigh => 'High';

  @override
  String get supportPriorityUrgent => 'Urgent';

  @override
  String get supportPriorityNormal => 'Normal';

  @override
  String supportTimeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get supportTimeJustNow => 'just now';

  @override
  String get supportSenderSupport => 'Support';

  @override
  String get supportSenderYou => 'You';

  @override
  String get supportImageLoadFailed => 'Failed to load image.';

  @override
  String get supportMyTickets => 'My tickets';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'Support now replies directly inside this screen. You can still optionally receive a push notification when your ticket gets an update.';

  @override
  String get supportNoTicketsYet =>
      'You do not have any tickets yet. Create a new report below.';

  @override
  String get supportSelectTicketPrompt =>
      'Select a ticket to open the conversation.';

  @override
  String get supportConversation => 'Conversation';

  @override
  String get supportNoMessagesYet => 'No messages yet.';

  @override
  String get supportAttachments => 'Attachments';

  @override
  String get supportReplyToTicket => 'Reply to this ticket';

  @override
  String get supportReplyFieldHint =>
      'Use this field when support asks for more information or when you want to provide an update. Inbox and push remain notification channels for new support replies.';

  @override
  String get supportYourReply => 'Your reply';

  @override
  String get supportSendReply => 'Send reply';

  @override
  String get supportNewTicket => 'New ticket';

  @override
  String get supportNewTicketIntro =>
      'Create a new report here. Support can then reply through inbox/push and in this screen, so you can continue the conversation in one place.';

  @override
  String get supportTicketReceivedBanner => 'Ticket received';

  @override
  String supportTicketNumberLine(int id) {
    return 'Ticket number: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'The ticket now appears directly in your list above. New support replies also arrive as inbox messages and push notifications.';

  @override
  String get supportFieldCategory => 'Category';

  @override
  String get supportFieldModule => 'Module';

  @override
  String get supportFieldSubject => 'Subject';

  @override
  String get supportFieldMessage => 'Message';

  @override
  String get supportReferenceOptional => 'Reference (optional)';

  @override
  String get supportReferenceHint =>
      'For example order id, screen name, country or short context';

  @override
  String get supportAddScreenshot => 'Add screenshot';

  @override
  String get supportSubmit => 'Submit';

  @override
  String get supportLastMessagePrefix => 'Last: ';

  @override
  String get supportReferenceLabel => 'Reference';

  @override
  String get supportMod_support => 'General support';

  @override
  String get supportMod_dashboard => 'Dashboard';

  @override
  String get supportMod_messages => 'Messages / inbox';

  @override
  String get supportMod_notifications => 'Notifications / push';

  @override
  String get supportMod_payments => 'Payments / premium';

  @override
  String get supportMod_bank => 'Bank';

  @override
  String get supportMod_crypto => 'Crypto';

  @override
  String get supportMod_travel => 'Travel';

  @override
  String get supportMod_properties => 'Properties';

  @override
  String get supportMod_inventory => 'Inventory / storage';

  @override
  String get supportMod_loadouts => 'Loadouts / equipment';

  @override
  String get supportMod_crimes => 'Crimes';

  @override
  String get supportMod_jobs => 'Work / jobs';

  @override
  String get supportMod_vehicles => 'Car / bike / boat theft';

  @override
  String get supportMod_garage => 'Garage';

  @override
  String get supportMod_marina => 'Marina';

  @override
  String get supportMod_aviation => 'Aviation';

  @override
  String get supportMod_smuggling => 'Smuggling';

  @override
  String get supportMod_drugs => 'Drugs';

  @override
  String get supportMod_nightclub => 'Nightclub';

  @override
  String get supportMod_prostitution => 'Prostitution';

  @override
  String get supportMod_crew => 'Crew';

  @override
  String get supportMod_friends => 'Friends / players';

  @override
  String get supportMod_hitlist => 'Hitlist';

  @override
  String get supportMod_security => 'Security / FBI';

  @override
  String get supportMod_prison => 'Prison / court';

  @override
  String get supportMod_casino => 'Casino';

  @override
  String get supportMod_school => 'School / training';

  @override
  String get supportMod_achievements => 'Achievements';

  @override
  String get supportMod_profile => 'Profile';

  @override
  String get supportMod_settings => 'Settings';

  @override
  String get supportMod_events => 'Events / leaderboard';

  @override
  String get supportMod_other => 'Other';

  @override
  String get gameEventDefaultTitle => 'Event';

  @override
  String get gameEventStatusActive => 'Active';

  @override
  String get gameEventStatusScheduled => 'Scheduled';

  @override
  String get gameEventStatusCompleted => 'Completed';

  @override
  String get gameEventStatusDraft => 'Draft';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle => 'Weekly Theft Hunt';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Steal as many vehicles as you can during the event window.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Smuggling Surge';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Move the most smuggled contraband this round.';

  @override
  String get gameEventTmplLabOutputChallengeTitle => 'Lab Output Challenge';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produce the most output while the event is live.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'Street Crime Spree';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Complete as many crimes as possible in the live window.';

  @override
  String get gameEventTmplContrabandRushTitle => 'Contraband Rush';

  @override
  String get gameEventTmplContrabandRushDesc =>
      'Sell contraband for profit or claim smuggled trade shipments — highest score wins.';

  @override
  String get gameEventTmplMonthlyEmpireShowdownTitle =>
      'Monthly Empire Showdown';

  @override
  String get gameEventTmplMonthlyEmpireShowdownDesc =>
      'All-round monthly challenge: score via crimes, vehicles, drugs, smuggling and trade. Top ranks win rare vehicles, weapons, ammo and parts.';

  @override
  String get gameScreenLoadError => 'Could not load events.';

  @override
  String get gameScreenDetailsLoadError => 'Could not load event details.';

  @override
  String get gameScreenSectionLive => 'Live Events';

  @override
  String get gameScreenNoActive => 'There are no active events right now.';

  @override
  String get gameScreenSectionUpcoming => 'Upcoming Events';

  @override
  String get gameScreenNoUpcoming => 'There are no scheduled events.';

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
    return 'Start: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'End: $date';
  }

  @override
  String get gameScreenYourProgress => 'Your progress';

  @override
  String gameScreenScore(String value) {
    return 'Score: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Rank: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Leaderboard (top 10)';

  @override
  String get gameScreenNoLeaderboard => 'No leaderboard data yet.';

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
  String get gameScreenUnknownPlayer => 'Unknown';

  @override
  String get gameScreenDash => '—';

  @override
  String get gameCardActive => 'Active';

  @override
  String get gameCardScheduled => 'Planned';

  @override
  String gameCardYourScore(String value) {
    return 'Your score: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Your rank: $value';
  }

  @override
  String get gameCardTapDetails => 'Tap for details and leaderboard';

  @override
  String get eventFeedDisconnected => 'Disconnected from the event stream';

  @override
  String get eventFeedReconnecting => 'Reconnecting...';

  @override
  String get eventFeedConnectedWaiting => 'Connected — waiting for events…';

  @override
  String get eventFeedConnecting => 'Connecting to the event stream…';

  @override
  String get evStreamConnectionEstablished => 'Connected to the event stream';

  @override
  String get evStreamAuthRegistered => 'Account created successfully.';

  @override
  String get evStreamAuthLogin => 'Welcome back.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Successfully completed $crimeName! +EUR $reward, +$xpGained XP';
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
    return 'Successfully completed $crimeName! +EUR $reward, +$xpGained XP — but caught! Jailed for $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      ' Your vehicle was seized by the police.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      ' Your weapon was confiscated by the police.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count convictions',
      one: '1 conviction',
    );
    return 'Successfully completed $crimeName! Criminal record cleared: $_temp0 removed. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Arrested by $authority during a $crimeName attempt.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'Caught during $crimeName! Jailed for $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Failed to complete $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return ' Your vehicle took $pct% damage during the chase.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'Caught during $crimeName! Jailed for $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Completed work as $jobName! +€$earnings, +$xpGained XP';
  }

  @override
  String evStreamActorPrefix(String username, String message) {
    return '$username: $message';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return ' (Education bonus +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Failed to complete job as $jobName. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Failed to complete job as $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Invalid job';

  @override
  String get evStreamJobErrorLevel => 'Your rank is too low for this job';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes more minutes',
      one: '1 more minute',
    );
    return 'This job is on cooldown. Wait $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Job error: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Flying to $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Arrived in $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Deposited €$amount to the bank';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Withdrew €$amount from the bank';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Bought $quantity $symbol for €$total';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Sold $quantity $symbol for €$total (P&L €$pnl)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol alert: €$price ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side filled: $quantity $symbol at €$price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig triggered for $symbol at €$price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Market regime changed to $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment news: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Daily mission complete: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Weekly mission complete: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Crypto leaderboard reward: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'bullish';

  @override
  String get evStreamRegimeBear => 'bearish';

  @override
  String get evStreamRegimeSideways => 'sideways';

  @override
  String get evStreamImpactBull => 'Bullish';

  @override
  String get evStreamImpactBear => 'Bearish';

  @override
  String get evStreamImpactNeutral => 'Neutral';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Purchased $name for €$cost';
  }

  @override
  String evStreamPropertyClaimed(String name, String country, String cost) {
    return 'Claimed property $name in $country for €$cost';
  }

  @override
  String evStreamDrugsProductionStarted(String drugName, String minutes) {
    return 'Started $drugName production — ready in $minutes min';
  }

  @override
  String evStreamDrugsProductionCollected(
    String quantity,
    String drugName,
    String quality,
  ) {
    return 'Collected ${quantity}g $drugName ($quality)';
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
    return '${quantity}g $drugType sold in $destination (€$payout)';
  }

  @override
  String evStreamDrugsWholesaleSeized(
    String quantity,
    String drugType,
    String destination,
  ) {
    return '${quantity}g $drugType to $destination seized';
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
    return 'Created crew: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Joined crew: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Crew war declared: #$a vs #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'Crew war started: #$a vs #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'Crew war #$id is in lockdown';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Crew war #$id resolved. Winner: crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Crew war action: $action (+$points pt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Heist “$name” successful! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Heist “$name” failed.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Treated in hospital! +$hp health, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Arrested! Jailed for $mins minutes';
  }

  @override
  String get evStreamPoliceEscaped => 'You escaped the police.';

  @override
  String get evStreamFbiRaid => 'FBI raid! You lost property and money.';

  @override
  String get evStreamErrInsufficientFunds => 'Not enough money';

  @override
  String get evStreamErrInsufficientHealth =>
      'Not enough health for this action';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Requires rank $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes more minutes',
      one: '1 more minute',
    );
    return 'You are in jail for $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'You need to rest and recover your health';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds',
      one: '1 second',
    );
    return 'Wait $_temp0 before trying again';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'You cannot help others while you are in jail';

  @override
  String get evStreamErrTargetNotJailed => 'That player is not in jail';

  @override
  String get evStreamErrCannotRescueSelf => 'You cannot free yourself';

  @override
  String get evStreamJailbreakOk => 'Jailbreak successful! The player is free.';

  @override
  String get evStreamJailbreakFail =>
      'Jailbreak failed! The player is still in jail.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Jailbreak failed! You were caught and jailed for $mins minutes.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Bail paid: €$amount. You are free.';
  }

  @override
  String get evStreamErrInternal => 'Something went wrong. Please try again.';

  @override
  String evStreamTest(String msg) {
    return 'Test: $msg';
  }

  @override
  String get evStreamNoCriminalRecord => 'You have no criminal record to clear';

  @override
  String get evStreamWeaponSelectRequired =>
      'Select a crime weapon before committing this crime';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'You need a suitable weapon: $types';
  }

  @override
  String get evStreamJobFallbackName => 'job';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Connection error';

  @override
  String get crimeWeaponSectionTitle => 'Worn weapons';

  @override
  String get crimeWeaponInstruction =>
      'Crimes look at both weapon slots and automatically use the best worn weapon for that crime.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Wear a usable weapon on slot 1 or slot 2 in Inventory first.';

  @override
  String get crimeWeaponSelectHint => 'Select a weapon for crimes';

  @override
  String get crimeWeaponNoSelectionNote =>
      'No weapon on slot 1 or 2. Armed crimes will not start.';

  @override
  String get crimeWeaponSlotEmpty => 'empty';

  @override
  String crimeWeaponEquippedStatus(String slotOne, String slotTwo) {
    return 'Slot 1: $slotOne. Slot 2: $slotTwo.';
  }

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Selected: $weaponLine. Some crimes still require a matching weapon type on top of that.';
  }

  @override
  String get crimeSetWeaponFailed => 'Failed to set crime weapon.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Wear a suitable weapon on slot 1 or 2 in Inventory first.';

  @override
  String get crimeWeaponFooterNote =>
      'Each crime picks the better worn weapon automatically. A backpack gun does not count.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Training bonuses on success chance: +$strengthPct% strength, +$accuracyPct% accuracy.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Same-day combo (gym + range, UTC calendar): +$pct% extra crime success chance.';
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
      'Forge court files and wipe your full criminal record if the operation succeeds.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% success chance';
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
      'Something went wrong. Please try again.';

  @override
  String get cooldownTimeLeft => 'Time left';

  @override
  String get cooldownMustWaitExplanation =>
      'You must wait before you can perform this action again.';

  @override
  String get cooldownAlreadyFinished => 'Cooldown already finished.';

  @override
  String get cooldownNotEnoughCredits => 'Not enough credits.';

  @override
  String get cooldownNoActiveToReset => 'No active cooldown to reset.';

  @override
  String get cooldownNotAvailableNow => 'Not available right now.';

  @override
  String get cooldownRedeemFailed => 'Failed to speed up with credits.';

  @override
  String get cooldownFinishedInstantly => 'Cooldown finished instantly.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Speed up now (-$cost credits)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Balance: $balance credits';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Loading credit options…';

  @override
  String get cooldownWaitCrime => 'The heat is too high…';

  @override
  String get cooldownWaitJob => 'Taking a rest before you can work again';

  @override
  String get cooldownWaitTravel => 'Next flight departs in';

  @override
  String get cooldownWaitHeist => 'Planning the heist…';

  @override
  String get cooldownWaitAppeal => 'Court is busy…';

  @override
  String get cooldownWaitSchool => 'Catch your breath before the next lesson…';

  @override
  String get cooldownWaitDefault => 'Please wait…';

  @override
  String get weaponLabelKnife => 'Knife';

  @override
  String get weaponLabelHandgun9mm => 'Pistol (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Heavy Pistol (.45)';

  @override
  String get weaponLabelSmgCompact => 'Compact SMG';

  @override
  String get weaponLabelShotgunPump => 'Shotgun (pump)';

  @override
  String get weaponLabelMolotov => 'Molotov cocktail';

  @override
  String get weaponLabelSmgSuppressed => 'Suppressed SMG';

  @override
  String get weaponLabelShotgunTactical => 'Tactical Shotgun';

  @override
  String get weaponLabelAssaultRifle => 'Assault rifle (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Flash grenade';

  @override
  String get weaponLabelGrenadeFrag => 'Fragmentation grenade';

  @override
  String get weaponLabelSniperStandard => 'Sniper rifle';

  @override
  String get weaponLabelAssaultRifleVip => 'Elite assault rifle';

  @override
  String get weaponLabelSniperVip => 'Elite sniper rifle';

  @override
  String get cooldownTitleCrime => 'Crime cooldown';

  @override
  String get cooldownTitleJob => 'Job cooldown';

  @override
  String get cooldownTitleTravel => 'Travel cooldown';

  @override
  String get cooldownTitleHeist => 'Heist cooldown';

  @override
  String get cooldownTitleAppeal => 'Appeal cooldown';

  @override
  String get cooldownTitleSchool => 'School cooldown';

  @override
  String get cooldownTitleGeneric => 'Cooldown';

  @override
  String get crimeOutcomeDefaultTitle => 'Crime result';

  @override
  String get territoryContestStatusPreparing => 'Preparation';

  @override
  String get territoryContestStatusActive => 'Active';

  @override
  String get territoryContestStatusLockdown => 'Lockdown';

  @override
  String get territoryContestStatusResolved => 'Resolved';

  @override
  String get territoryContestStatusCancelled => 'Cancelled';

  @override
  String get territoryContestHintPreparing =>
      'This contest is currently in preparation. Once prep time ends, the region automatically becomes active and actions unlock.';

  @override
  String get territoryContestHintLockdown =>
      'This contest is in lockdown. No new actions can be taken now; the outcome resolves automatically.';

  @override
  String get territoryNow => 'Now';

  @override
  String get territoryRoleAttacker => 'Attacker';

  @override
  String get territoryRoleDefender => 'Defender';

  @override
  String get territoryValueLow => 'Low';

  @override
  String get territoryValueAverage => 'Average';

  @override
  String get territoryValueHigh => 'High';

  @override
  String get territoryValueTop => 'Top';

  @override
  String get territoryTagCapital => 'Administrative center';

  @override
  String get territoryTagHarbor => 'Harbor';

  @override
  String get territoryTagIndustry => 'Industry';

  @override
  String get territoryTagBorder => 'Border region';

  @override
  String get territoryTagLogistics => 'Logistics hub';

  @override
  String get territoryActionPatrol => 'Patrol';

  @override
  String get territoryActionIntelScan => 'Intel scan';

  @override
  String get territoryActionSabotage => 'Sabotage';

  @override
  String get territoryActionSupplyRun => 'Supply run';

  @override
  String get territoryActionRaid => 'Raid';

  @override
  String get territoryActionDefense => 'Defense';

  @override
  String get territoryBonusStrategicRegion => 'Strategic region';

  @override
  String get territoryBonusAdjacentSupport => 'Adjacent support';

  @override
  String get territoryBonusWarPressure => 'War pressure';

  @override
  String get territoryBonusHqLevel => 'HQ level';

  @override
  String get territoryBonusCrewMissionLevel => 'Crew mission level';

  @override
  String get territoryBonusCrewBuildings => 'Crew side buildings';

  @override
  String get territoryBonusOther => 'Other';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'base $basePoints + bonus $bonusPoints = $totalPoints contest points';
  }

  @override
  String get territoryErrorNotInCrew =>
      'You must join a crew before you can attack territory.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'A contest is already running for this region. Refreshing the map to the latest state.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Your crew has already reached the concurrent contest limit.';

  @override
  String get territoryErrorRegionsCap =>
      'Your crew already owns the maximum number of regions.';

  @override
  String get territoryErrorContestNotActive =>
      'This contest is not active yet. Wait for the preparation phase to finish.';

  @override
  String get territoryErrorActionCooldown =>
      'You need to wait before performing another territory action.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'This action belongs to the other side of the contest.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Your HQ level is too low for this territory action.';

  @override
  String get territoryErrorDailyCap =>
      'You have reached your daily limit for territory actions.';

  @override
  String get territoryErrorWrongCountry =>
      'You can view every country, but territory actions only work in the country where you are currently located.';

  @override
  String get territoryErrorGarrisonNotOwner =>
      'Only the crew that holds this region can deploy a garrison.';

  @override
  String get territoryErrorGarrisonAlreadyActive =>
      'This region already has an active garrison.';

  @override
  String get territoryErrorGarrisonCrewLimit =>
      'Your crew already has the maximum number of active garrisons.';

  @override
  String get territoryErrorGarrisonHq =>
      'Your HQ level is too low to deploy a garrison.';

  @override
  String get territoryErrorGarrisonFunds =>
      'Not enough money in the crew bank to deploy this garrison.';

  @override
  String get territoryGarrisonTitle => 'Garrison / air defense';

  @override
  String get territoryGarrisonDesc =>
      'Hire tanks and air defense for a few hours. The region stays attackable, but defense actions hit harder and attackers need a bigger point lead to capture it.';

  @override
  String get territoryGarrisonDeploy => 'Deploy garrison';

  @override
  String territoryGarrisonActiveUntil(String time) {
    return 'Garrison active until $time';
  }

  @override
  String territoryGarrisonCostHours(String cost, int hours) {
    return '$cost from the crew bank · ${hours}h';
  }

  @override
  String get territoryGarrisonDialogTitle => 'Deploy garrison?';

  @override
  String territoryGarrisonDialogBody(String cost, int hours) {
    return 'Pay $cost from the crew bank to station tanks and air defense here for $hours hours. The region can still be attacked, but it is harder to take.';
  }

  @override
  String get territorySnackGarrisonDeployed => 'Garrison deployed.';

  @override
  String get territoryErrorUnknown => 'Unknown territory error.';

  @override
  String get territoryLegendUnderContest => 'Under contest';

  @override
  String get territoryLegendNeutral => 'Neutral';

  @override
  String get territoryTabMap => 'Map';

  @override
  String get territoryTabLeaderboard => 'Leaderboard';

  @override
  String get territoryTabSeason => 'Season';

  @override
  String get territorySelectCountryTooltip => 'Select country';

  @override
  String get territoryUnavailableMessage =>
      'Territory is currently unavailable.';

  @override
  String get territoryMapHintTapMain =>
      'Tap a region on the map to open territory information and the attack button in a modal.';

  @override
  String get territoryMapHintTapPanel =>
      'Tap a region to directly open the modal with territory information and attack actions.';

  @override
  String get territoryMapHintMobile =>
      'On mobile you can pinch in and out with two fingers and drag the zoomed map directly for smaller regions.';

  @override
  String get territoryMapHintColors =>
      'Region colors show ownership; orange = active contest. Thicker borders mark clusters; thinner borders mark pockets. Use the layer toggles for contest scores, projects, and events.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country map (crew control)';
  }

  @override
  String get territoryLegendTitle => 'Legend';

  @override
  String territoryYourCrewLine(String name) {
    return 'Your crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Region preview';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Only the selected region, without the rest of the map.';

  @override
  String get territoryNeutralTerritory => 'Neutral territory';

  @override
  String get territoryDetailOwner => 'Owner';

  @override
  String get territoryDetailNeutral => 'Neutral';

  @override
  String get territoryDetailStability => 'Stability';

  @override
  String get territoryDetailEffectiveStability => 'Effective stability';

  @override
  String get territoryDetailControl => 'Control';

  @override
  String get territoryDetailValueTier => 'Value tier';

  @override
  String get territoryDetailPayout => 'Payout';

  @override
  String get territoryDetailStrategicRole => 'Strategic role';

  @override
  String get territoryDetailAdjacentOwned => 'Adjacent owned regions';

  @override
  String get territoryDetailActionBonuses => 'Action bonuses';

  @override
  String get territoryDetailBonusInfo => 'Bonus info';

  @override
  String get territoryDetailBonusInfoBody =>
      'These bonuses only increase your contest points per action. The region € payout stays the same.';

  @override
  String get territoryDetailWarPressure => 'War pressure';

  @override
  String get territoryDetailAttackPressure => 'attack pressure';

  @override
  String get territoryDetailStabilityWord => 'stability';

  @override
  String get territoryWarRoleTheater => 'theater region';

  @override
  String get territoryWarRoleAdjacent => 'adjacent region';

  @override
  String get territoryWarRoleTarget => 'target region';

  @override
  String get territoryWarPressureEndsIn => 'War pressure ends in';

  @override
  String get territoryDetailIncomeHour => 'Income per hour';

  @override
  String get territoryDetailIncomeDay => 'Income per day';

  @override
  String get territoryDetailYourCrew => 'Your crew';

  @override
  String get territoryDetailContestStatus => 'Contest status';

  @override
  String get territoryDetailYourRole => 'Your role';

  @override
  String get territoryDetailYourHqLevel => 'Your HQ level';

  @override
  String get territoryDetailActionsUnlockIn => 'Actions unlock in';

  @override
  String get territoryDetailActionsCloseIn => 'Actions close in';

  @override
  String get territoryDetailContestEndsIn => 'Contest ends in';

  @override
  String get territoryDetailCooldownPerAction => 'Cooldown per action';

  @override
  String get territoryDetailYourCooldown => 'Your cooldown';

  @override
  String get territoryNoticeCrewOnly =>
      'Territory is only playable for crew members. Create or join a crew first, then you can attack neutral regions.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'You are viewing $viewingCountry, but you are currently in $playerCountry. You can browse this map, but attacks and contest actions only unlock after you travel to this country.';
  }

  @override
  String get territoryNoticeOwnRegion =>
      'Your crew already controls this region.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Your crew is defending this region. Once the active phase starts, you will only see defensive actions.';

  @override
  String get territoryConfirmDefense => 'Confirm defense';

  @override
  String get territoryAttack => 'Attack';

  @override
  String get territoryAttackerActions => 'Attacker actions';

  @override
  String get territoryDefenderActions => 'Defender actions';

  @override
  String get territoryContestActions => 'Contest actions';

  @override
  String get territoryIntelShort => 'Intel scan';

  @override
  String get territoryRequiresHqShort => 'requires HQ';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Higher HQ level required for: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'You are not part of this contest, so you cannot perform actions here.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'This contest is taking place in another country. You can follow it, but you can only join once you are physically in $country.';
  }

  @override
  String get territoryLeaderboardEmpty => 'No territory controlled yet.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regions';
  }

  @override
  String get territorySeasonNone => 'No active season found.';

  @override
  String get territorySeasonCurrent => 'Current season';

  @override
  String get territorySeasonKey => 'Key';

  @override
  String get territorySeasonStatus => 'Status';

  @override
  String get territorySeasonStart => 'Start';

  @override
  String get territorySeasonEnd => 'End';

  @override
  String get territoryDialogAttackTitle => 'Attack?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Start a contest for $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Join a crew first to attack territory.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Contest started. Status: $status. Wait for the preparation phase to finish before taking actions.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'The contest is already started and the map has been refreshed. Status: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points points!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Defense confirmed. Once the active phase starts, you can perform defensive actions.';

  @override
  String get territorySnackContestRefreshed =>
      'The contest state has been refreshed. You can now immediately see the current defense phase.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Requires HQ level $required. Current HQ level: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (requires HQ $level)';
  }

  @override
  String get smugglingHubTitle => 'Smuggling Hub';

  @override
  String get smugglingHubSubtitle =>
      'One system for drugs, trade goods, vehicles, weapons and ammo. Travel empty and claim safely from depot.';

  @override
  String get smugglingClaimPersonal => 'Claim personal';

  @override
  String get smugglingClaimCrew => 'Claim crew';

  @override
  String get smugglingNewShipment => 'New shipment';

  @override
  String get smugglingCategoryDrug => 'Drugs';

  @override
  String get smugglingCategoryTrade => 'Trade goods';

  @override
  String get smugglingCategoryVehicle => 'Vehicles';

  @override
  String get smugglingCategoryWeapon => 'Weapons';

  @override
  String get smugglingCategoryAmmo => 'Ammo';

  @override
  String get smugglingNoItemsInCategory =>
      'No available items in this category.';

  @override
  String get smugglingFieldItem => 'Item';

  @override
  String get smugglingFieldDestination => 'Destination';

  @override
  String get smugglingTransport => 'Transport';

  @override
  String get smugglingCommercialChannel => 'Commercial channel';

  @override
  String get smugglingOwnedVehicleAircraft => 'Owned vehicle / aircraft';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'You do not have an owned vehicle or aircraft available for smuggling in this country.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Owned transport';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capacity: $slots slots • Confiscation on failure: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots slots • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Network';

  @override
  String get smugglingPersonal => 'Personal';

  @override
  String get smugglingCrew => 'Crew';

  @override
  String get smugglingChannelField => 'Smuggling channel';

  @override
  String get smugglingQuantity => 'Quantity';

  @override
  String get smugglingVehiclesOneByOne => 'Vehicles are shipped one by one';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Max: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Start smuggling';

  @override
  String get smugglingSelectItemDestination => 'Select item and destination';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'Crew smuggling for trade goods is not available yet';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Select an owned vehicle or aircraft first';

  @override
  String get smugglingInvalidQuantity => 'Invalid quantity';

  @override
  String get smugglingActionProcessed => 'Action processed';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes min • $risk% risk';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% risk';
  }

  @override
  String get smugglingQuotePrompt =>
      'Select item and destination for a live quote.';

  @override
  String get smugglingQuoteLiveTitle => 'Live quote';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Owned transport: $label';
  }

  @override
  String get smugglingHarborBonus =>
      'Harbor bonus: faster route and lower seizure risk (crew-owned harbor in this country).';

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Cargo slots: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Cooldown active: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Recommended channel: $channel';
  }

  @override
  String get smugglingInsufficientCash => 'Insufficient cash for this shipment';

  @override
  String get smugglingDepotsTitle => 'Country depots';

  @override
  String get smugglingDepotsEmpty => 'No packages ready in depots.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages packages • $totalQuantity units';
  }

  @override
  String get smugglingClaimHere => 'Claim here';

  @override
  String get smugglingStatusTitle => 'Smuggling status';

  @override
  String get smugglingNoShipmentsYet => 'No shipments yet.';

  @override
  String get smugglingStatusInTransit => 'In transit';

  @override
  String get smugglingStatusReady => 'Ready';

  @override
  String get smugglingStatusSeized => 'Seized';

  @override
  String get smugglingStatusClaimed => 'Claimed';

  @override
  String get smugglingStatusUnknown => 'Unknown';

  @override
  String get smugglingChannelPackage => 'Package';

  @override
  String get smugglingChannelCourier => 'Courier';

  @override
  String get smugglingChannelContainer => 'Container';

  @override
  String get smugglingChannelOwned => 'Owned transport';

  @override
  String get smugglingHintOwnedTransport =>
      'Owned transport lowers cost and risk, but it can be confiscated on a failed run.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Tip: vehicles work best with Courier or Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Tip: larger weapon loads are better via Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Tip: bulk ammo via Container for lower risk.';

  @override
  String get smugglingHintDrugsChannel =>
      'Tip: small batches via Package, bulk via Container.';

  @override
  String get smugglingHintCompareChannels =>
      'Tip: compare channels with the live quote.';

  @override
  String get smugglingQuoteBoatCannotFit => 'A boat cannot fit in an aircraft.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'Your owned transport cargo capacity is too small.';

  @override
  String get smugglingQuoteUnavailable => 'Quote unavailable';

  @override
  String get smugglingApiInvalidChannel => 'Invalid smuggling channel';

  @override
  String get smugglingApiInvalidNetwork => 'Invalid network choice';

  @override
  String get smugglingApiInvalidQuantity => 'Invalid quantity';

  @override
  String get smugglingApiInvalidDestination =>
      'Destination country does not exist';

  @override
  String get smugglingApiPlayerNotFound => 'Player not found';

  @override
  String get smugglingApiSameCountryInventory =>
      'Use local inventory for the same country';

  @override
  String get smugglingApiNotInCrew => 'You are not in a crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'Crew smuggling for trade goods is not available yet';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Owned vehicles only work for personal smuggling';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Choose an owned vehicle or aircraft';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'Selected owned vehicle is not available';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'You cannot use the same vehicle as both cargo and transport';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'A car or motorcycle cannot carry another vehicle';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Vehicles cannot use the package channel';

  @override
  String get smugglingApiBoatCannotFit => 'A boat cannot fit in an aircraft.';

  @override
  String get smugglingApiCargoOverflow =>
      'Your owned transport cargo capacity is too small.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Wait ${seconds}s before another $channel shipment';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Not enough money for smuggling fees';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Not enough drugs in crew inventory';

  @override
  String get smugglingApiInsufficientDrugs => 'Not enough drugs in inventory';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Not enough trade goods in inventory';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Not enough weapons in crew inventory';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Not enough weapons in inventory';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Not enough ammo in crew inventory';

  @override
  String get smugglingApiInsufficientAmmo => 'Not enough ammo in inventory';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Invalid crew vehicle';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Crew boat not available for smuggling';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Crew motorcycle not available for smuggling';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Crew car not available for smuggling';

  @override
  String get smugglingApiInvalidVehicleKey => 'Invalid vehicle';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Vehicle not available for smuggling';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Insufficient stock for this shipment';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'No shipments ready at this country depot';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Quantity too high for $channel. Max: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Smuggling shipment ($channel) to $destination started';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Picked up $count shipment(s) in $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Picked up $count crew shipment(s) in $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Shipment failed';

  @override
  String get smugglingClientQuoteFailed => 'Quote failed';

  @override
  String get smugglingClientClaimFailed => 'Claim failed';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Error: $detail';
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
  String get cryptoMarketNoData => 'No crypto market data available';

  @override
  String get cryptoMarketTitle => 'Crypto market';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Open orders: $count';
  }

  @override
  String get cryptoRegimeBull => 'Bull market';

  @override
  String get cryptoRegimeBear => 'Bear market';

  @override
  String get cryptoRegimeSideways => 'Sideways';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Owned: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portfolio';

  @override
  String get cryptoLabelValue => 'Value';

  @override
  String get cryptoLabelCostBasis => 'Cost basis';

  @override
  String get cryptoLabelUnrealized => 'Unrealized';

  @override
  String get cryptoLabelRealized => 'Realized';

  @override
  String get cryptoNoPositionsYet => 'No positions yet';

  @override
  String get cryptoChartDataUnavailable => 'Chart data unavailable';

  @override
  String get cryptoUnknownTime => 'Unknown';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop-loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Take-profit';

  @override
  String get cryptoOrderTypeLimit => 'Limit';

  @override
  String get cryptoSideBuy => 'Buy';

  @override
  String get cryptoSideSell => 'Sell';

  @override
  String get cryptoInvalidQuantity => 'Invalid quantity';

  @override
  String get cryptoPurchaseCompleted => 'Purchase completed';

  @override
  String get cryptoSaleCompleted => 'Sale completed';

  @override
  String get cryptoActionProcessed => 'Action processed';

  @override
  String get cryptoInvalidTargetPrice => 'Invalid target price';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'You cannot sell more than you own.';

  @override
  String get cryptoOpenOrderPlaced => 'Open order placed';

  @override
  String get cryptoOpenOrderFailed => 'Failed to place order';

  @override
  String get cryptoOrderCancelled => 'Order cancelled';

  @override
  String get cryptoCancelOrderFailed => 'Failed to cancel order';

  @override
  String get cryptoDirectTradeTitle => 'Direct trade';

  @override
  String get cryptoLabelQuantity => 'Quantity';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Current price: €$currentPrice • Avg buy: €$avgBuy\nUse ALL to sell your full position instantly.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Current price: €$currentPrice • Avg buy: €$avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Current price: €$currentPrice\nUse ALL to sell your full position instantly.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Current price: €$currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Your history for $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Avg buy';

  @override
  String get cryptoLabelLastBuy => 'Last buy';

  @override
  String get cryptoLabelBuyVolume => 'Buy volume';

  @override
  String get cryptoLabelSellVolume => 'Sell volume';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Last buy at $when';
  }

  @override
  String get cryptoNoTradesForCoinYet => 'No trades for this coin yet.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Open orders for $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Open orders use their own quantity below. Fill in both quantity and target price in this section.';

  @override
  String get cryptoLabelOrderType => 'Order type';

  @override
  String get cryptoLabelSide => 'Side';

  @override
  String get cryptoLabelOrderQuantity => 'Order quantity';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'This order sells from your current position. Owned: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'This quantity is separate from the direct trade above.';

  @override
  String get cryptoLabelTargetPrice => 'Target price';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limit buy below price, limit sell above price';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Executes when price falls to this level';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Executes when price rises to this level';

  @override
  String get cryptoPlaceOpenOrder => 'Place open order';

  @override
  String get cryptoNoOpenOrdersYet =>
      'You do not have any open orders for this coin yet.';

  @override
  String get cryptoLabelCancel => 'Cancel';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Crypto details • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Coin';

  @override
  String get cryptoLabelPrice => 'Price';

  @override
  String get cryptoLabelOwned => 'Owned';

  @override
  String get cryptoLabelOpenOrders => 'Open orders';

  @override
  String get cryptoNotEnoughHistory => 'Not enough history yet';

  @override
  String get cryptoChartPointsWord => 'points';

  @override
  String get cryptoChartHourAbbrev => 'h';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • full history';
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
  String get cryptoChartRange30d => '30d';

  @override
  String get cryptoChartRangeAll => 'All';

  @override
  String get cryptoChartLive1h => 'Live • last 1h';

  @override
  String get cryptoChartLive4h => 'Live • last 4h';

  @override
  String get cryptoChartLive8h => 'Live • last 8h';

  @override
  String get cryptoChartLive24h => 'Live • last 24h';

  @override
  String get cryptoChartLive7d => 'Live • last 7 days';

  @override
  String get cryptoChartLive30d => 'Live • last 30 days';

  @override
  String get cryptoChartLiveAll => 'Live • full history';

  @override
  String get cryptoLabelTotal => 'Total';

  @override
  String get cryptoApiCouldNotLoadMarket => 'Could not load crypto market.';

  @override
  String get cryptoApiAssetNotFound => 'Crypto not found.';

  @override
  String get cryptoApiCouldNotLoadChart => 'Could not load crypto chart data.';

  @override
  String get cryptoApiNotLoggedIn => 'Not logged in.';

  @override
  String get cryptoApiCouldNotLoadPortfolio => 'Could not load portfolio.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Could not load crypto transaction history.';

  @override
  String get cryptoApiInvalidQuantity => 'Invalid quantity.';

  @override
  String get cryptoApiInsufficientFunds => 'Not enough money.';

  @override
  String get cryptoApiPurchaseFailed => 'Purchase failed.';

  @override
  String get cryptoApiNotEnoughCrypto => 'Not enough crypto held.';

  @override
  String get cryptoApiSellFailed => 'Sale failed.';

  @override
  String get cryptoApiCouldNotLoadOrders => 'Could not load crypto orders.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Invalid target price.';

  @override
  String get cryptoApiInvalidOrderType => 'Invalid order type.';

  @override
  String get cryptoApiInvalidOrderSide => 'Invalid order side.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'This order type and side combination is not allowed.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Failed to place order.';

  @override
  String get cryptoApiPlayerNotFound => 'Player not found.';

  @override
  String get cryptoApiInvalidOrderId => 'Invalid order id.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Order not found or no longer active.';

  @override
  String get cryptoApiCancelOrderFailed => 'Failed to cancel order.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'You bought $quantity $symbol for €$total.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'You sold $quantity $symbol for €$total.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Order placed: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Order $orderId cancelled.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Error: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Error while loading: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Error while loading facilities: $error';
  }

  @override
  String get drugsInvTitle => 'Drug Inventory';

  @override
  String get drugsInvKpiGramsLabel => 'inventory';

  @override
  String get drugsCutQualityDCannotCut => 'Quality D cannot be cut further.';

  @override
  String get drugsCutFailed => 'Cutting failed';

  @override
  String get drugsSellFailed => 'Sale failed';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Sell $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Available: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Quality: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Current price: €$price per gram';
  }

  @override
  String get drugsPricesByCountry => 'Prices by country:';

  @override
  String get drugsQuantityGramsField => 'Quantity (grams)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsInvalidQuantity => 'Invalid quantity';

  @override
  String get drugsSellAction => 'Sell';

  @override
  String get drugsExportAction => 'Export';

  @override
  String drugsExportDialogTitle(String name) {
    return 'Export $name';
  }

  @override
  String get drugsExportDestLabel => 'Destination';

  @override
  String drugsExportQuoteStreet(String amount) {
    return 'Dest street: €$amount/g';
  }

  @override
  String drugsExportQuoteB2b(String amount) {
    return 'Wholesale: €$amount/g';
  }

  @override
  String drugsExportPayout(String amount) {
    return 'Payout on arrival: €$amount';
  }

  @override
  String drugsExportFee(String amount) {
    return 'Freight: €$amount';
  }

  @override
  String drugsExportEta(String minutes) {
    return 'ETA: $minutes min';
  }

  @override
  String drugsExportSeizure(String pct) {
    return 'Seizure: $pct%';
  }

  @override
  String drugsExportHeat(String heat, String fbi) {
    return 'Heat +$heat · FBI +$fbi';
  }

  @override
  String get drugsExportHarbor => 'Harbor bonus active';

  @override
  String get drugsExportConfirm => 'Send';

  @override
  String drugsExportMinHint(String grams) {
    return 'Minimum ${grams}g';
  }

  @override
  String get drugsExportFailed => 'Export failed';

  @override
  String get drugsExportStarted => 'Load in transit. Cash on arrival.';

  @override
  String get drugsExportCannotAfford => 'Not enough cash for freight';

  @override
  String get drugsExportCrewFeeHint => 'Crew bank pays the freight';

  @override
  String drugsExportCrewPayout(String crew, String runner) {
    return 'Payout: crew €$crew · runner €$runner';
  }

  @override
  String get drugsExportCannotAffordCrew => 'Crew bank cannot cover freight';

  @override
  String get drugsHubExportCrewPrefix => 'Crew';

  @override
  String get drugsCrewLotsTitle => 'Crew quality lots';

  @override
  String get drugsCrewExportStarted =>
      'Crew load in transit. Cash on arrival to the crew bank.';

  @override
  String get drugsHubExportsTitle => 'Wholesale shipments';

  @override
  String get drugsHubExportInTransit => 'In transit';

  @override
  String get drugsHubExportSold => 'Sold';

  @override
  String get drugsHubExportSeized => 'Seized';

  @override
  String get drugsHubExportEmpty => 'No open exports';

  @override
  String drugsHubExportLine(String qty, String dest, String status) {
    return '${qty}g → $dest · $status';
  }

  @override
  String get drugsInvEmptyTitle => 'No drugs in inventory';

  @override
  String get drugsInvEmptySubtitle => 'Start production to create drugs';

  @override
  String get drugsInvSectionHeader => 'Inventory & distribution';

  @override
  String get drugsInvSectionBody =>
      'Sell locally or export a wholesale load to another country. Street-sell, nightclub, darkweb and Marketplace stay retail.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Current location: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventory: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Current value: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Market: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Cut drugs';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Quality $fromQ → $toQ: +$pct% more units';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Result: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Cut';

  @override
  String get drugsSlotsLabel => 'slots';

  @override
  String get drugsFacilitiesTitle => 'Drug Facilities';

  @override
  String get drugsFacilitiesHeroTitle => 'Manage your drug facilities';

  @override
  String get drugsFacilitiesHeroBody =>
      'Facilities such as greenhouse, mushroom farm, drug lab, crack kitchen and darkweb storefront determine which drugs you can produce, how many slots you have and how strong your quality, yield and speed are.';

  @override
  String get drugsFacCurrentProductions => 'Current productions';

  @override
  String get drugsFacUnknownFacility => 'Unknown facility';

  @override
  String get drugsFacUnknownMessage => 'Unknown message';

  @override
  String get drugsFacUpgradeLockedTitle => '🔒 Drug upgrade locked';

  @override
  String get drugsFacUpgradeLockedBody =>
      'You first need the right Narcotics education levels and certifications.';

  @override
  String get drugsFacEquipLockedTitle => '🔒 Equipment upgrade locked';

  @override
  String get drugsFacEquipLockedBody =>
      'Train your Narcotics track first to unlock the next upgrade level.';

  @override
  String get drugsFacBuy => 'Buy';

  @override
  String get drugsFacOwned => 'Owned';

  @override
  String get drugsFacPrice => 'Price';

  @override
  String get drugsFacRank => 'Rank';

  @override
  String get drugsFacDrugTypes => 'Drugs';

  @override
  String get drugsFacSlots => 'Slots';

  @override
  String get drugsFacQuality => 'Quality';

  @override
  String get drugsFacYield => 'Yield';

  @override
  String get drugsFacSpeed => 'Speed';

  @override
  String get drugsFacMaxSlots => 'Max slots';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Upgrade slots (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Equipment upgrades';

  @override
  String get drugsFacMax => 'Max';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Lvl $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Drug Environment';

  @override
  String get drugsSubviewProduction => 'Drug Production';

  @override
  String get drugsSubviewFacilities => 'Drug Facilities';

  @override
  String get drugsSubviewInventory => 'Drug Inventory';

  @override
  String get drugsTagUndergroundOps => 'Underground Operations';

  @override
  String get drugsTagMobileOptimized => 'Mobile Optimized';

  @override
  String get drugsTagQualityDriven => 'Quality Driven';

  @override
  String get drugsEmpireTitle => 'Drug Empire';

  @override
  String get drugsHubIntro =>
      'Manage production, facilities and inventory here. Buy materials on the Black Market while the rest runs in your own drug environment.';

  @override
  String get drugsStatMaterialFlow => 'Material flow';

  @override
  String get drugsStatBlackMarket => 'Black Market';

  @override
  String get drugsStatProductionChain => 'Production chain';

  @override
  String get drugsStatProductionChainValue =>
      'Greenhouse + Lab + Kitchen + Darkweb';

  @override
  String get drugsStatSalesModel => 'Sales model';

  @override
  String get drugsStatPerQuality => 'Per quality';

  @override
  String get drugsMetricActiveBatches => 'Active batches';

  @override
  String get drugsMetricSlotUsage => 'Slot usage';

  @override
  String get drugsMetricInventoryValue => 'Inventory value';

  @override
  String get drugsMetricInventoryGrams => 'Inventory grams';

  @override
  String get drugsMetricEfficiency => 'Efficiency';

  @override
  String get drugsMetricPoliceHeat => 'Police Heat';

  @override
  String get drugsSectionOperations => 'Operations';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Follow these steps: facilities → production → inventory';

  @override
  String get drugsCardOpenAction => 'Open';

  @override
  String drugsCardStepLabel(int step) {
    return 'Step $step';
  }

  @override
  String get drugsCardFacilitiesEyebrow => 'Infrastructure';

  @override
  String get drugsCardFacilitiesTitle => 'Facilities';

  @override
  String get drugsCardFacilitiesBody =>
      'Buy and upgrade greenhouse, drug lab, crack kitchen and darkweb storefront for more slots, speed and quality.';

  @override
  String get drugsCardProductionEyebrow => 'Pipeline';

  @override
  String get drugsCardProductionTitle => 'Production';

  @override
  String get drugsCardProductionBody =>
      'Start batches, track timers and collect output with quality rolls.';

  @override
  String get drugsCardInventoryEyebrow => 'Distribution';

  @override
  String get drugsCardInventoryTitle => 'Inventory';

  @override
  String get drugsCardInventoryBody =>
      'View stacks by quality and sell at the best market value.';

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
  String get drugsQualityDistribution => 'Quality distribution';

  @override
  String get drugsQualityGradeSuperior => 'Superior';

  @override
  String get drugsQualityGradeHigh => 'High';

  @override
  String get drugsQualityGradeStandardPlus => 'Standard+';

  @override
  String get drugsQualityGradeStandard => 'Standard';

  @override
  String get drugsQualityGradeLow => 'Low';

  @override
  String get drugsHeatLevelLow => 'Low';

  @override
  String get drugsHeatLevelMedium => 'Medium';

  @override
  String get drugsHeatLevelHigh => 'High';

  @override
  String get drugsHeatLevelCritical => 'Critical';

  @override
  String get drugsProdTitle => 'Drug Production';

  @override
  String get drugsProdLineTitle => 'Production line';

  @override
  String get drugsProdLineSubtitle =>
      'Start batches, monitor slot capacity and tune quality via greenhouse and lab upgrades.';

  @override
  String get drugsProdActiveProductions => 'Active Productions';

  @override
  String get drugsProdIncidentLegend => 'Incident legend';

  @override
  String get drugsProdHide => 'Hide';

  @override
  String get drugsProdShow => 'Show';

  @override
  String get drugsProdLegendDelay => 'Delay';

  @override
  String get drugsProdLegendContamination => 'Contamination';

  @override
  String get drugsProdLegendYieldLoss => 'Yield loss';

  @override
  String get drugsProdLegendInstability => 'Instability';

  @override
  String get drugsProdLegendCombined => 'Combined issue';

  @override
  String get drugsProdCollect => 'Collect';

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
  String get drugsProdAvailableDrugs => 'Available Drugs';

  @override
  String get drugsProdNoDrugs => 'No drugs available';

  @override
  String get drugsProdAutoCollectOn => 'Auto-collect on (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Auto-collect off (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'All materials available';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: buy missing materials in one click';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Time: $time | Yield: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total slots used';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility required';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Rank $rank required';
  }

  @override
  String get drugsProdNoFreeSlot => 'No free production slot available';

  @override
  String get drugsProdOpenFacilities => 'Open facilities';

  @override
  String get drugsProdStartProduction => 'Start production';

  @override
  String get drugsProdAutoCollectUpdated => 'Auto-collect updated';

  @override
  String get drugsProdKpiActive => 'active';

  @override
  String get drugsProdKpiReady => 'ready';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Yield: $qty grams';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours hr';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String get drugsTimeHourEn => 'hr';

  @override
  String get drugsProdConfirmTitle => 'Are you sure?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return 'Start $drugName production?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Time: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Yield: $yield grams';
  }

  @override
  String get drugsProdRiskNote =>
      'Production can sometimes suffer setbacks. Better upgrades lower the risk, high drug heat increases it.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Required materials:';

  @override
  String get drugsProdStartProductionButton => 'Start Production';

  @override
  String get drugsProdFailed => 'Production failed';

  @override
  String get drugsProdCollectFailed => 'Collect failed';

  @override
  String drugsProdNeedRank(String rank) {
    return 'You need rank $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Missing';

  @override
  String get drugsFacilityGreenhouse => 'Greenhouse';

  @override
  String get drugsFacilityCrackKitchen => 'Crack Kitchen';

  @override
  String get drugsFacilityDarkweb => 'Darkweb Storefront';

  @override
  String get drugsFacilityMushroomFarm => 'Mushroom Farm';

  @override
  String get drugsFacilityDrugLab => 'Drug Lab';

  @override
  String get drugsVipQuickBuyTitle => 'VIP quick purchase';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'You already have enough materials for $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Buy all missing materials for $name in one click?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsPurchaseCompleted => 'Purchase completed';

  @override
  String get drugsPurchaseFailed => 'Purchase failed';

  @override
  String get drugsServiceErrorGeneric => 'Error';

  @override
  String get drugsApiFailedBuyMaterial => 'Failed to buy material';

  @override
  String get drugsApiFailedStartProduction => 'Failed to start production';

  @override
  String get drugsApiFailedCollect => 'Failed to collect production';

  @override
  String get drugsApiFailedSell => 'Failed to sell drugs';

  @override
  String get drugsApiFailedCut => 'Failed to cut drugs';

  @override
  String get drugsApiFailedShipment => 'Failed to send shipment';

  @override
  String get drugsApiFailedClaim => 'Failed to claim depot shipments';

  @override
  String get helpTopicDashboardCategory => 'Core';

  @override
  String get helpTopicDashboardTitle => 'Dashboard';

  @override
  String get helpTopicDashboardSummary =>
      'Your central overview with all your stats, active cooldowns, live events and shortcuts to every part of the game.';

  @override
  String get helpTopicDashboardHow =>
      'Top bar shows: Cash, Rank, Health (0-100 HP), Wanted Level (0-100) and FBI Heat (0-100).\nRank titles follow the same ladder as your public profile: for example Soldier around rank 25, and Godfather only from rank 60.\nEvery 5 minutes an automatic tick fires: hunger drops -2, thirst -3, you heal passively +5 HP (if HP > 0), wanted level drops slightly when below 10. Passive bank interest stays off.\nIf hunger or thirst reaches 0 you die and spend 3 hours in ICU. Eat and drink on time!\nOn mobile a sticky footer keeps Crimes, Vehicle theft, Work, Bank and Crew one tap away. A gold dot on Crimes, Steal or Work means that cooldown is ready. Everything else is in the hamburger menu or the left sidebar; that menu is grouped (Actions, World, Social, Economy, Empire, Assets) and searchable.\nCooldown timers per section show how long until your next action is available. The timer adapts to show the most relevant unit: minutes, hours or days.\nThe stats card now uses real live counters for breakouts, murders, hitlist contracts, travels and bullets instead of fixed zero placeholders.\nThe dashboard now also has an expanded economy section with cash, bank, crypto, vehicle value, property value, net worth and a 24-hour cashflow trend.\nThe operations block now shows active production, longest cooldown, vehicle status (active/listed/transit), and next production/event timers.\nWhen player events are live (e.g. weekly competition), the same right-hand panel briefly lists their titles and links to the Events page. You can turn push for round start/end on or off under Settings → Player events (in addition to device permissions and other push categories).\nNotifications & risk now includes unread DMs, support tickets waiting for your reply, events from the last 24 hours, and a compact risk score (wanted + FBI).\nWhen your crew is involved in Crew Wars, the dashboard also shows a Crew Wars summary with status, opponent, crew points, season rank and the remaining time in the current phase.\nThe dashboard now also includes a Vehicle Ops overview per Car/Motorcycle/Boat with live cooldown chips (Hotspot, Crew, Crew match, Chop, Contract and Counter), plus heat/reputation, contract and claim counts, and season points.\nLive events appear when other players perform major actions, when you are attacked, or when global market movements occur.\nMessage badge shows unread system messages and personal messages.\nThe avatar menu at the top right opens My profile, messages, help, settings and log out.\nLeft navigation menu grants access to all game sections grouped by category: Actions, World, Social, Economy, Empire and Assets.';

  @override
  String get helpTopicDashboardTips =>
      'Open the dashboard first after every login to see what changed while you were away.\nKeep wanted level below 10 so automatic decay works and arrest chances stay low.\nCheck unread messages before starting risky actions: rewards, order fills and system events all appear in your inbox.';

  @override
  String get helpTopicCrimesCategory => 'Actions';

  @override
  String get helpTopicCrimesTitle => 'Crimes';

  @override
  String get helpTopicCrimesSummary =>
      'Commit illegal actions for cash and XP, but every attempt risks damage, arrest or extra Wanted Level. The late-game Wipe Criminal Record crime removes your full criminal record on success, but it needs heavy tools and carries high federal risk.';

  @override
  String get helpTopicCrimesHow =>
      'Crime cooldowns now scale with potential payout: low-yield crimes stay fast, while high-yield crimes get clearly longer cooldowns.\nGuideline by reward tier: up to €500 ≈ 1.5 min, up to €2,000 ≈ 5 min, up to €10,000 ≈ 15 min, up to €30,000 ≈ 30 min, above that ≈ 60 min.\nThere is no hard daily cap on crimes; active players can keep playing as long as they manage cooldowns, risk and resources.\nCrimes with `required weapon` look at both worn weapon slots and automatically use the best match for that crime. Wear the weapons in Inventory; a backpack gun does not count.\nYour active gym and shooting-range bonuses (up to +8% each) are shown on the Crimes screen; they raise success chance as the server calculates (train more via the Training hub / gym + range).\nIf you complete at least one gym session and one shooting-range session on the same UTC calendar day, the server adds a small extra crime success chance (+0.5%). The Crimes screen shows when this combo is active.\nCrimes with a vehicle requirement use your selected crime vehicle from Garage or Marina. Only a vehicle that is actually in your current country and not in transit or listed for sale counts.\nDrug requirements in crimes are shown in grams and follow the same quantities as your drug inventory and storage.\nIf a crime cannot start because of a missing vehicle, the wrong weapon, or missing ammo, the error message should now show the real cause instead of a generic retry.\nEvery crime attempt: you take 5-15 HP damage, reduced by a worn vest and bodyguards (up to about half off). Wanted Level still rises by 1-4 points depending on success or failure.\nArrest chance scales fast with Wanted Level: Wanted 5 = 25%, Wanted 10 = 50%, Wanted 18+ = maximum 90%.\nOn arrest you go to prison. Sentence = max(wanted level × 10, 5) minutes. Bail = wanted level × €1.000. Even if a crime seems successful at first but you get caught right after, the final outcome still counts as an arrest: required tools are confiscated, the used crime weapon is lost, and vehicles can also be seized.\nSome crimes require a vehicle, tool or minimum rank. Missing these will prevent the crime from starting.\nXP earned raises your rank, unlocking better crimes and higher rewards.\nFBI Heat rises with heavier crimes. Above heat 50 the FBI becomes active with even higher arrest chances.\nWhen country police pressure is enabled, a shared heat meter per country softens crime success and raises arrest chance where you are. Travel shows band badges; rare disrupt ops (crew/rank gated) can temporarily cool the streets.';

  @override
  String get helpTopicCrimesTips =>
      'Use fast beginner crimes to build XP while waiting for big cooldowns.\nAlways bail out if your Wanted Level is high — sitting in jail blocks all your loops.\nWear a vest on crime runs: it cuts the 5-15 HP hit and keeps you out of ICU longer. Keep HP above 30 before starting a run.';

  @override
  String get helpTopicJobsCategory => 'Actions';

  @override
  String get helpTopicJobsTitle => 'Jobs';

  @override
  String get helpTopicJobsSummary =>
      'Earn legal money without Wanted Level risk. Jobs are safer than crimes but peak lower in payout.';

  @override
  String get helpTopicJobsHow =>
      'Available jobs scale with rank and education: better jobs pay more, but also have longer cooldowns.\nJob cooldowns scale on max payout: low-tier jobs around 3-5 min, mid-tier around 8-12 min, top-tier around 17-22 min.\nJobs have a high but not perfect success rate; on failure you do not lose money or HP, but you do lose some XP.\nRequirements per job: minimum 10 HP, hunger > 20, thirst > 20, not in jail, not in ICU.\nThere is no hard daily cap on jobs; progression is paced by cooldown, chance and payout instead of a daily lock.\nJob pay varies per job type and rank. Education (School) can unlock higher positions.\nYou also earn XP per job, though less than comparable crimes.\nUse jobs as a reliable cash flow base, especially when your Wanted Level is too high for safe crimes.';

  @override
  String get helpTopicJobsTips =>
      'Combine jobs and school: education unlocks better jobs with higher payouts.\nWhen Wanted Level is above 8 or you are recovering from ICU, use jobs instead of crimes.\nKeep hunger and thirst from dropping too low: a job with stats below 20 simply will not start.';

  @override
  String get helpTopicTravelCategory => 'World';

  @override
  String get helpTopicTravelTitle => 'Travel';

  @override
  String get helpTopicTravelSummary =>
      'Move between countries for better market prices, unique opportunities and access to international systems.';

  @override
  String get helpTopicTravelHow =>
      'Available countries: Netherlands (start), Belgium, Germany, France, United Kingdom, Spain, Italy, Switzerland, USA, Mexico, Colombia, Brazil.\nTravel costs: neighboring country €500-€2.000, Europe → Americas €5.000-€10.000, long distance €10.000-€20.000.\nTravel requirements: not in jail, not in ICU, minimum 20 HP, travel funds available.\nDrug quantities in your inventory count as real grams for carry weight and travel checks; 500 means 500g, not 50kg.\nEach country has different market prices (up to 300% price difference), different crime payouts and unique trade items.\nTransport risk: police can seize goods based on Wanted Level (chance = wanted × 2%, max 80%). FBI can seize everything internationally if heat is high.\nCustoms inspection has a 10% base chance. You can bribe (€1.000-€5.000) or get caught losing 50% of goods.\nAfter arrival all actions are immediately available in the new country. Markets and crime speed vary by location.';

  @override
  String get helpTopicTravelTips =>
      'Always combine travel with trade, drugs or smuggling — empty travel wastes money.\nLower your Wanted Level before departure: high wanted greatly increases confiscation risk en route.\nPlan your return trip in advance so you already know what to bring back on arrival.\nOwn a plane in Aviation to cut commercial travel cooldown. Instant private flights still need fuel.';

  @override
  String get helpTopicAviationCategory => 'World';

  @override
  String get helpTopicAviationTitle => 'Aviation';

  @override
  String get helpTopicAviationSummary =>
      'Finish Aviation school, buy a paid license, then buy a plane to fly instantly, cut commercial travel time, and sell or repair your hangar fleet.';

  @override
  String get helpTopicAviationHow =>
      'Complete Aviation school to level 5 and earn both flight certificates before you can buy a paid license.\nBuy a paid license on the Aviation screen: basic, commercial or cargo. Higher tiers unlock heavier planes.\nBuy an aircraft from the hangar catalog. New planes start with an empty tank.\nRefuel from the hangar at €50 per litre. A private flight uses 100 L and moves you to another country instantly.\nCommercial Travel still uses tickets and legs. Owning a plane shortens that wait: Cessna −15%, King Air −25%, Citation −30%, Gulfstream −35%, cargo planes −30%. Only the best plane counts.\nSell an owned plane for 50% of the purchase price. Repair a broken plane before you can refuel or fly it.';

  @override
  String get helpTopicAviationTips =>
      'School 5/5 is not enough: you still need the paid license before any purchase.\nTank enough for 100 L before you fly. An empty plane cannot leave the hangar.\nA plane also speeds up normal Travel even if you take the commercial route.\nSell unused planes if you need cash; you only get half of what you paid.';

  @override
  String get helpTopicCrewCategory => 'Social';

  @override
  String get helpTopicCrewTitle => 'Crew';

  @override
  String get helpTopicCrewSummary =>
      'Start a crew or join existing players to pull off heists together, share storage and become stronger as a unit.';

  @override
  String get helpTopicCrewHow =>
      'Creating a crew costs €10.000. The Crew HQ determines how many members your crew can hold and scales up to 150 members. The leader can invite, kick and start heists.\nCrew benefits: access to large heists, shared storage, teamwork bonus (+10% success per extra member, max +30%) and group chat.\nNew crews now start with Crew HQ level 1 and all storage buildings at level 1, including cash storage, so the crew bank and shared storage work immediately.\nCrew car storage now also accepts motorcycles, so land vehicles can be managed together from the same shared crew storage.\nWhen a crew member gets arrested, crew members now receive a push notification that the player is locked up and waiting for help.\nThe crew screen is now grouped into Overview, HQ & Upgrades, Storage, Members, War Room, Crew Missions, Crews and Chat so management feels calmer and more professional.\nCrew Missions shows tier templates, an active run card and recent runs. Leaders/co-leaders can start and resolve; reward claiming and cooldown speedup are handled in the same tab.\nThere are extra crew missions with bank-themed operations (night deposit, skim network, armored route, subsidiary vault, reserve vault and clearing house). There is no second casino crew mission alongside Casino Ledger Raid.\nCrew mission rewards come from the server-side mission economy; other players’ bank balances are not debited for these payouts.\nWhen starting a mission you can now assign a role per crew member (Planner, Enforcer, Logistics, Tech) for team bonuses.\nActive and recent mission cards now also show per-player role contributions with score and any payout multiplier.\nCrew members now also receive push/in-app alerts for mission start, mission result, and when a mission cooldown becomes ready again.\nWhile a mission cooldown is active you cannot start a new mission; first wait for the remaining cooldown or speed it up with credits.\nFor cooldown speedup, you first see the exact credit cost and remaining minutes before you confirm.\nCrew Wars have their own War Room tab inside the crew screen. Only leaders can declare a war and at least 3 crew members are required to participate.\nWar types: Kill War, Economy War, Territory War and Total War. Each war moves through preparation, active phase, lockdown and resolution.\nDuring an active war, participants can perform actions like kills, mugs, sabotage, intel, raids, shields, boosts and territory claims. Targeted actions now let you pick directly from a list of opponent crew members instead of typing a player ID by hand.\nSeason points are aggregated into the Crew Wars leaderboard. The War Room also shows standings, recent actions and recent wars for your crew.\nIn Territory War and Total War you now claim real Territory regions from the territory system instead of generic placeholder targets.\nThose war regions now also show their strategic value in the War Room: claim bonus, tick points and tags such as harbor, capital or logistics. That makes it immediately clear which regions are worth more than a simple ownership swap.\nCrew Wars no longer picks Territory targets on value tier alone, but also on strategic tags and adjacent pressure from attacker or defender territory. That makes Territory War and Total War feel more like a real frontline than three random claims.\nHeists: Small Bank (2 players, 40%, €10.000-€30.000, 30 min cooldown), Jewelry Store (3 players, 35%, €20.000-€50.000, 45 min), Casino Heist (4 players, 25%, €50.000-€150.000, 2 hrs), Federal Reserve (5 players, 15%, €100.000-€500.000, 6 hrs, +20 FBI Heat).\nFor a heist all members must be online at start. If someone is absent the heist fails.\nFailed heist: jail time for everyone, Wanted Level +5, no reward.\nHeist reward is split equally among all participating members.\nCrew chat is available for fast coordination.\nCrew HQ progression: the longer and more active the crew, the more shared upgrades and buffs unlock.';

  @override
  String get helpTopicCrewTips =>
      'New crews can deposit money and use shared storage immediately; after that, focus on upgrades for more capacity instead of a separate starter purchase.\nCheck the War Room first to see whether your crew is still on cooldown before trying to declare a new war.\nCoordinate target calls in crew chat so you do not keep farming the same opponent and trip the anti-farm guard.\nCoordinate heist start times in crew chat so everyone is online and nobody is in jail.\nChoose a crew in the same timezone or activity pattern for better heist success rates.\nUse shared crew storage to separate risky goods from your personal inventory.';

  @override
  String get helpTopicFriendsCategory => 'Social';

  @override
  String get helpTopicFriendsTitle => 'Friends';

  @override
  String get helpTopicFriendsSummary =>
      'Manage your friends list for faster coordination, profile browsing and social feedback.';

  @override
  String get helpTopicFriendsHow =>
      'Friends page shows three lists: current friends, sent requests and received requests.\nFrom a friend you can directly send a message, view their profile or start a collaboration.\nYou can see when friends are active in the game, which helps planning heists or trades.\nFriend requests do not expire automatically; keep the list tidy so pending requests do not distract you.\nFriends outside your crew are valuable for jail escapes (a friend can help you break out) and information sharing.\nWhen a friend gets arrested, accepted friends now also receive a push notification that the player is waiting for help in prison.';

  @override
  String get helpTopicFriendsTips =>
      'Add friends who share your play style: heist partners, trader networks or crime support.\nA friend who executes a jail escape earns €500-€2.000 reward on success. Arrange this for emergencies.';

  @override
  String get helpTopicMessagesCategory => 'Social';

  @override
  String get helpTopicMessagesTitle => 'Messages';

  @override
  String get helpTopicMessagesSummary =>
      'Your inbox with personal player messages and system messages about rewards, orders and game events.';

  @override
  String get helpTopicMessagesHow =>
      'Messages are split into personal conversations and The Mob State system thread.\nSystem messages are sent automatically for: crypto trades, order fills, leaderboard payouts, heist results, jail escapes and achievement badges.\nYou can send messages to other players as long as their privacy settings allow it.\nUnread messages appear as a badge on the message icon and are visible from the dashboard.\nMessages do not expire and are kept as a historical log of account events.\nUse the inbox log when in doubt about a payout, a missed order fill or an unexpected balance change.';

  @override
  String get helpTopicMessagesTips =>
      'Check your inbox after long offline periods: rewards, order fills and events are all recorded there.\nConfigure notification preferences via Settings so you only receive push alerts for truly important events.';

  @override
  String get helpTopicInventoryCategory => 'Management';

  @override
  String get helpTopicInventoryTitle => 'Inventory';

  @override
  String get helpTopicInventorySummary =>
      'Manage everything you carry, store and equip: weapons, tools, vehicles, drugs and trade goods.';

  @override
  String get helpTopicInventoryHow =>
      'Inventory opens as a paper-doll view: your avatar in the center, a crime-weapon slot, a second-weapon slot and a vest slot, plus square backpack slots.\nDrag an item (or tap it, then tap a valid target) to move it. On phones, tap-to-select is more reliable than dragging.\nIf a stack has more than one unit (ammo, materials, stacked weapons or tools), you choose how many to move: 1, all, or a custom amount.\nThe right-hand grid is the current context: a house or warehouse in this country, or the materials depot. Open Storage on a property jumps here with that building selected.\nHouses store weapons, ammo, vests and cash. Warehouses store tools. Materials stay in the country depot, not in a house. Cash uses buttons, not drag.\nYou can wear only one vest. Dropping a vest onto the avatar equips it; storing it in a house unequips it. A second worn vest is refused.\nYou can carry two weapons at once, for example a handgun and a rifle. When you commit a crime, the server looks at both worn slots and automatically uses the best match for that crime.\nOnly usable weapons worn on slot 1 or 2 count for crimes.\nBackpack capacity covers tools, unequipped weapons and carried materials. Worn weapons, ammo and the worn vest do not use backpack slots. The server rejects full packs, wrong country and wrong property type.\nLoadouts remain a second tab for saved crime or travel sets.\nDrugs are stored and shown as grams; 351 means 351g. Crew storage stays a separate safe stash.\nOn arrest police can confiscate items. Drugs in inventory increase FBI risk on international travel.';

  @override
  String get helpTopicInventoryTips =>
      'Keep your carrying load light when traveling or running a high-arrest-risk crime spree.\nUse loadouts so you always have the right gear equipped for each scenario.\nCheck item condition regularly: broken tools silently block crimes without a clear error message.';

  @override
  String get helpTopicPropertiesCategory => 'Economy';

  @override
  String get helpTopicPropertiesTitle => 'Properties';

  @override
  String get helpTopicPropertiesSummary =>
      'Buy properties to expand storage, housing capacity and access to certain systems such as the nightclub. Develop properties for a permanent income boost.';

  @override
  String get helpTopicPropertiesHow =>
      'Each property has its own role: storage space, housing capacity or access to a follow-up module such as the nightclub.\nWarehouse upgrades increase your storage capacity for items and other stock.\nHouses store weapons, ammo, vests and cash; warehouses store tools. Open storage on a house or warehouse opens the Inventory paper-doll with that building selected. You must be in the same country.\nHouses and apartments increase housing capacity; VIP players receive extra slots on top of that.\nSome properties are unique or country locked: you must be in the correct country to buy or manage them.\nSelling yields 70% of purchase price. No cooldown on selling, it is instant.\nA purchased nightclub opens the separate nightclub management screen; that module handles management and revenue, not the properties overview.\nDevelop spends bank money: each level permanently raises that property\'s passive income (max level and cooldown are server-tuned).';

  @override
  String get helpTopicPropertiesTips =>
      'Invest in a Warehouse early if you need more storage space for your other systems.\nChoose houses and apartments when you want to build more housing capacity for related gameplay systems.\nDo not sell too quickly: 70% represents a serious markdown from purchase price.\nDevelop high base-income properties first — the percentage boost matters more there.';

  @override
  String get helpTopicBankCategory => 'Economy';

  @override
  String get helpTopicBankTitle => 'Bank';

  @override
  String get helpTopicBankSummary =>
      'Deposit working cash for free up to a daily cap. Larger street cash must be laundered with a fee, delay and FBI-heat seize risk.';

  @override
  String get helpTopicBankHow =>
      'Free deposits are instant and have no fee, but only up to a daily cap that scales with your rank (UTC day). Withdrawals stay free and unlimited. Use Fill remaining to enter today\'s leftover quota; when the cap is used up the screen shows the countdown to 00:00 UTC.\nPassive bank interest is currently disabled.\nMoney in the bank is protected from police confiscations. Only cash on hand can be lost at arrest.\nTransaction history shows all incoming and outgoing flows with timestamp, amount, transfer counterparty and optional descriptions.\nMoney laundering: wash cash above the free daily cap into your bank with a fee and delay. Each wash has a minimum and maximum, shown on the bank screen. Higher FBI heat raises seize chance; success slightly lowers heat.\nBank Robbery crime: succeeds at 30% and steals 10-30% of a random other player\'s bank balance. High Wanted Level risk.\nTransferring money to other players is possible. You can optionally add a description, and the recipient will also see it in transactions. Double-check both amount and recipient before confirming.';

  @override
  String get helpTopicBankTips =>
      'Use the free daily deposit for small working cash so it is safe from confiscation.\nLaunder larger street cash when you accept the fee and seize risk; lower heat is safer.\nKeep a small working capital as cash for direct expenses (bail, travel, tools).';

  @override
  String get helpTopicCasinoCategory => 'Economy';

  @override
  String get helpTopicCasinoTitle => 'Casino';

  @override
  String get helpTopicCasinoSummary =>
      'Bet cash on slots, blackjack, roulette, dice, baccarat and video poker. The house has three floors (public/VIP/private) with a visible rake and a max bet. High variance: you can win or lose a lot quickly.';

  @override
  String get helpTopicCasinoHow =>
      'Available games: Slots, Blackjack, Roulette, Dice, Baccarat and Video Poker.\nEach table uses the casino floor max bet and a visible rake that stays in the owner bankroll.\nPublic / VIP / Private floors raise max bets and house rake. Owners hire one dealer, one security and one promoter. Dealer slightly raises rake and can trim payouts; promoter raises max bet and heat; security lowers casino_ledger_raid drain.\nStaff salaries come from the bankroll on each game tick. If the bankroll is too low, the cheapest hire is fired.\nA successful crew casino_ledger_raid drains a percentage of the bankroll in the run start country. The crew still gets its normal cash reward; this is extra pressure on the house, not a second cash print.\nCasino uses cash only, not your bank balance. Lost bets are gone; there is no insurance.';

  @override
  String get helpTopicCasinoTips =>
      'Set a session cash limit: never more than 10% of your total cash.\nBlackjack has the best odds for a skilled player.\nOwners: keep the bankroll above €10,000 and hire security before rival crews unlock ledger raids.\nTreat the casino as entertainment — the house edge wins over time.';

  @override
  String get helpTopicBlackMarketCategory => 'Economy';

  @override
  String get helpTopicBlackMarketTitle => 'Black Market';

  @override
  String get helpTopicBlackMarketSummary =>
      'One shop hub under Economy: dealer shops for trade goods, weapons, ammo, tools, security vests, materials and backpacks, plus a player market for vehicles and carried items.';

  @override
  String get helpTopicBlackMarketHow =>
      'Open Black Market from the Economy menu. Shops sit in one strip: Trade goods, Weapons, Ammo, Tools, Security, Materials and Backpacks. Player market has Marketplace and My listings.\nTrade goods: one continuous scroll — first the five contraband lines (pricing, caps, risk chips: spoilage, volatility, trip damage, seizure), then your inventory to sell from. Buy/sell uses the /trade API; partial load failures show a warning banner.\nThe black market is divided into shops (Trade goods, Weapons, Ammo, Tools, Security, Materials, Backpacks) and a player market (Marketplace, My listings).\nPrices and availability vary heavily by country and time. A listing can sell out fast.\nBlack market transactions leave no official trail but increase FBI Heat for large purchases.\nWeapons bought here can be used in crimes, PvP and security. Better weapons give higher damage and success chance.\nFilters by category (type, country, price, availability) help you quickly find the right listing.\nYou can post your own listings as a seller, including price and quantity. Other players buy from you.\nListings expire after a certain time if unsold. Monitor your own offers via your profile.\nMarketplace tab: peer-to-peer cash trades. You’ll see other players’ vehicles for sale and carried tools in one feed (country + price filters). Tap Sell item to list a tool you are carrying; My listings shows your active vehicle and tool ads. You cannot buy your own ad. Selling drugs, crypto or special event rewards player-to-player here is not available yet.';

  @override
  String get helpTopicBlackMarketTips =>
      'Tools, vests and bodyguards are shops on this same screen (Tools / Security), not separate menu pages.\nTrade tab: pull to refresh if a segment fails; watch risk chips and Wanted before risky smuggling runs.\nBuy weapons and ammo in bulk when prices are low: availability is temporary.\nAvoid large black market purchases when FBI Heat is already above 30.\nMarketplace: refresh after listing; only tools in your carried inventory can be placed for sale.';

  @override
  String get helpTopicDrugsCategory => 'Empire';

  @override
  String get helpTopicDrugsTitle => 'Drugs';

  @override
  String get helpTopicDrugsSummary =>
      'Build a complete drug operation from raw materials to finished product. Run production chains, manage storage and sell for high margins but serious risks.';

  @override
  String get helpTopicDrugsHow =>
      'The drug system consists of: Hub (overview and stats), Facilities (upgrade production capacity), Production (active production lines with timer) and Inventory (finished products and raw materials).\nBuy raw materials via the black market (Materials tab, also linked from Hub/Production) or trade. Combine them in a facility to produce drugs.\nProduction timers run while you are offline. You get a notification when a batch is ready to collect.\nYou can spend premium credits to finish a batch early, buy a temporary extra slot, or activate a 24h heat shield (no extra yield).\nFinished output stays visible in Production and keeps that facility slot occupied until you collect it; VIP auto-collect processes ready output, but skips a pending raid until you choose.\nOn collect, heat can trigger a raid: you choose stock loss, facility downtime or a cash fine before receiving loot.\nYou can cool heat with cash or go low-profile (temporarily no new production).\nA darkweb storefront never silent-sells: auto-sale is opt-in, with a fee and extra heat.\nOwn-production drugs get a small nightclub margin bonus. Quality lots can be deposited into crew drug storage.\nFacility cards show price, rank and education requirements before buy or upgrade.\nFrom Inventory you can export a wholesale load to another country: you stay put, pay freight, and receive dest B2B cash when the container arrives. Seizure pays nothing. Street-sell, nightclub, darkweb and Marketplace stay retail.';

  @override
  String get helpTopicDrugsTips =>
      'Buy materials from the Materials tab before starting batches.\nKeep drug heat low with low-profile or cash-cool when you collect a lot.\nOn a raid: pick downtime if you want to keep the batch, or cash if the facility must keep running.\nOnly enable darkweb auto-sale if you accept the fee and heat.\nOwn production stored in the nightclub earns a small extra margin.\nExport only if you accept freight and seizure risk; travel plus street-sell still pays more per gram.';

  @override
  String get helpTopicNightclubCategory => 'Empire';

  @override
  String get helpTopicNightclubTitle => 'Nightclub';

  @override
  String get helpTopicNightclubSummary =>
      'Run a nightclub as part of your criminal empire. Manage staff, security and supply for passive and active income with a dedicated season leaderboard.';

  @override
  String get helpTopicNightclubHow =>
      'At the bottom you now use a Nightclub Management Command Center with zones for Crew, Drug Storage, DJ Command, Security Unit and Ops Lab; all zones run in one continuous page flow without extra inner-scroll.\nThe nightclub screen now includes one central Intelligence section combining overview, revenue trends and risk logs without tab switching.\nOps Lab now includes 11 systems: resident DJ, dynamic event calendar, upgrade tree, police heat/incident response, supplier contracts, promoter profiles, VIP clientele + staff traits, smuggling routes, bar & kitchen management (drinks/food) with pricing, rival sabotage + counter-intel, and an operations timeline.\nSmuggling routes now have a run cooldown (Harbor 60 min, Airstrip 90 min, Borderline 120 min), forcing risk/timing planning instead of infinite spam.\nThe upgrade tree is interactive: explicitly choose Sound Rig, VIP Lounge or Surveillance and buy the next level directly with visible upgrade costs.\nRevenue is generated per tick based on DJ quality, occupancy and supply availability. Missing supply directly reduces income.\nDJ contracts end automatically at the configured end time; after that you must book again for new boosts.\nIncidents (fights, theft) can occur when security is insufficient. This damages visitor score and income.\nEach season has a leaderboard. Players with the highest total nightclub revenue win season rewards.\nSynergy with drugs: own drug production can serve as supply, raising margins.\nDrug storage is gram-based: each selection shows the available grams before you move stock into nightclub inventory.\nRival actions are name-based: you search rival clubs by player name before selecting an action (no player-id required).\nSynergy with prostitution: combined venue events give extra visitors and higher revenue.\nUpgrades improve capacity, supply storage and the maximum number of DJs and guards you can deploy.';

  @override
  String get helpTopicNightclubTips =>
      'Always keep supply stocked: one tick without supply can trigger a visitor dip that is hard to recover from.\nBook the best DJ you can afford: DJ quality has the biggest direct impact on revenue per tick.\nCheck the season leaderboard daily and scale up supply and DJs if you want to finish in the top 10.';

  @override
  String get helpTopicCryptoCategory => 'Economy';

  @override
  String get helpTopicCryptoTitle => 'Crypto';

  @override
  String get helpTopicCryptoSummary =>
      'Trade 30 real cryptocurrencies. Buy and sell directly or automate via limit, stop-loss and take-profit orders. Prices now follow live market anchors with extra in-game regimes and news, and the coin popup uses separate fields for direct trades and open orders.';

  @override
  String get helpTopicCryptoHow =>
      'The crypto list shows 30 coins with current price, 24-hour percentage and your current holding per coin. The price base follows live market data, but it is still influenced by in-game regimes and news.\nClick a coin to open the popup with: live chart (time filters 1h, 4h, 8h, 24h, 7d, 30d, All), purchase history, average buy price and buy/sell form.\nDirect trade: enter quantity and click Buy or Sell. When selling you can press `ALL` to instantly fill your full position. Execution is immediate at the current market price.\nOpen orders: Limit (buy/sell at an exact target price), Stop-loss (auto sell when price drops to a threshold), Take-profit (auto sell when price rises to a target). This section now has its own quantity field and its own target price field.\nOpen orders are executed automatically by the backend as soon as the market price hits the target. You do not need to be online.\nMarket regimes (Bull/Bear/Sideways) and news events influence price movements. You receive regime notifications via push when enabled.\nWeekly crypto leaderboard: the player with the highest realized gain that week wins a cash reward.\nDaily and weekly missions (e.g. 3 profitable trades, diversify across 5 coins) give extra rewards on completion.\nPortfolio overview shows: total value, invested amount, unrealized and realized profit/loss.';

  @override
  String get helpTopicCryptoTips =>
      'Check your purchase history before placing a sell order: the popup shows your average buy price so you do not accidentally sell at a loss.\nUse stop-loss orders on every position you are not actively watching: they protect you automatically when you are offline.\nSwitch time filters in the chart: 1h and 4h show short-term trend, 7d and 30d show the bigger picture.';

  @override
  String get helpTopicSmugglingCategory => 'Empire';

  @override
  String get helpTopicSmugglingTitle => 'Smuggling';

  @override
  String get helpTopicSmugglingSummary =>
      'Move illegal goods and vehicles between countries. Choose a commercial channel or use your own vehicle or aircraft for lower cost and added confiscation risk.';

  @override
  String get helpTopicSmugglingHow =>
      'Choose a category, the specific item, the destination, and then decide between a commercial channel or your own transport.\nOwned cars, motorcycles, boats, and aircraft now show a live quote with cargo slots, lower cost, and risk reduction.\nA boat can carry cars and motorcycles; an aircraft cannot carry a boat and will return an immediate error.\nSuccess chance depends on the selected channel or owned transport, your current Wanted Level, and shipment size.\nOn failure you lose the entire shipment. No refund. Cargo and transport costs are gone.\nWhen you use owned transport and the run fails, the transport asset itself can also be confiscated.\nActive shipments are tracked live in an overview. After arrival the cargo appears in a depot ready for collection.\nCrew network remains available for commercial crew shipments, but owned transport is personal only.';

  @override
  String get helpTopicSmugglingTips =>
      'Never send your entire stock in one shipment: split across multiple smaller loads to limit catastrophic loss.\nLower Wanted Level and FBI Heat to a minimum before starting a large smuggling run.\nUse your best aircraft or boat for expensive runs: lower cost helps, but cargo slots and confiscation chance still decide the risk.\nAlways collect active depots as fast as possible: expired depot contents are permanently lost.';

  @override
  String get helpTopicToolsCategory => 'Management';

  @override
  String get helpTopicToolsTitle => 'Tools';

  @override
  String get helpTopicToolsSummary =>
      'Buy and repair crime tools on Black Market → Tools. Good tools raise your success chance, worn tools lower it.';

  @override
  String get helpTopicToolsHow =>
      'Open Black Market from Economy and pick Tools. The shop shows all available items with price, condition rating and the crime type they are required for.\nEach crime category has preferred tools: burglary requires crowbar or picks, car theft requires a hotwire kit, robbery requires a firearm.\nTools have a condition rating (0-100%). Each successful or failed crime lowers condition by a few percent.\nBelow 20% condition the tool\'s success chance bonus drops drastically. Below 5% the tool has almost no effect.\nRepaired tools through the shop cost a fraction of the purchase price. Replacement is sometimes cheaper than repair for heavily worn tools.\nTools are visible in your inventory tab. You can keep multiple copies of the same type as backup.';

  @override
  String get helpTopicToolsTips =>
      'Buy tools in bulk when they are cheap on the black market: you save compared to the shop.\nSet a personal threshold: always replace tools when condition drops below 25% to keep success chances stable.';

  @override
  String get helpTopicCourtCategory => 'Risk';

  @override
  String get helpTopicCourtTitle => 'Court';

  @override
  String get helpTopicCourtSummary =>
      'During your sentence you can file an appeal or try to bribe the judge to get released sooner.';

  @override
  String get helpTopicCourtHow =>
      'When jailed, the court screen shows your active conviction with remaining time, localized crime name and judge profile.\nAn appeal costs money based on your current sentence length. If granted, your sentence is usually reduced by about 20-40%.\nYou can appeal only once per conviction and a cooldown applies to rapid retries.\nLaw education adds +5% appeal chance per level (max +25% at level 5). Wanted above 20 subtracts 10%, FBI heat above 10 subtracts 15%. A first conviction adds +20%; five or more prior convictions subtract 20%. The screen shows this breakdown and the estimated chance, capped between 10% and 85%.\nBribery uses a player-selected amount. That amount is always deducted, even when the attempt fails.\nA higher bribe amount increases success chance based on the judge\'s corruptibility. Wanted and FBI heat do not change the bribe itself. On success, you are released immediately.\nYour criminal record keeps earlier convictions with dates and court-history details even when you are no longer jailed.\nA successful judge bribe removes only that current conviction from your criminal record.\nIf you want to wipe your full criminal record, you must do it outside court through the late-game Wipe Criminal Record crime.';

  @override
  String get helpTopicCourtTips =>
      'Use appeals on long sentences first: expected time saved is highest there.\nTrain Law at school before you appeal, and drop Wanted/FBI first if they sit above the penalty thresholds.\nUse bribery only with enough cash buffer, because payment is always deducted.';

  @override
  String get helpTopicHitlistCategory => 'Risk';

  @override
  String get helpTopicHitlistTitle => 'Hitlist';

  @override
  String get helpTopicHitlistSummary =>
      'Place a bounty on an enemy or accept a hit contract. Eliminate your target in the same country for the full payout.';

  @override
  String get helpTopicHitlistHow =>
      'Via the hitlist you add a player by setting a bounty. Minimum bounty is €5,000. The payer loses this money immediately.\nIf a bounty is placed on you, you immediately receive a push notification and inbox message from Hitlist Bureau.\nActive hits are visible to all players. The higher the bounty, the more attention the contract attracts.\nDetective investigations no longer return instant intel: reports arrive later via a Detective Bureau message (Quick 1 hour €1,000,000, Standard 6 hours €500,000, Slow 24 hours €250,000). Target bodyguards can cloud or block that report: Quick is easy to stop. Slow always leaks the country, even against a full elite team. After 48 hours offline the cover weakens; after 7 days the report is complete. After a kill, the killer\'s bodyguards also lower the chance a murder-case detective names them, until they stay offline for long.\nIf you are killed through the hitlist, you receive a Hitlist Bureau message with a button to start a killer investigation within 24 hours.\nIf you request this investigation quickly after the murder, the detective report arrives faster. Waiting longer means a longer report delay.\nTo execute a hit you must be in the same country as your target. You attack via the player profile.\nCombat is auto-calculated based on: weapons, armor, stats (strength, reflexes), crew bonuses and active level.\nOn successful elimination you receive the full bounty, but you can still lose HP, bodyguards and vest condition. If the attack fails the contract stays open: both sides lose bodyguards and HP, and you can try again after 10 minutes.\nOn a successful hit, the target receives a hard account-progress reset: assets and progression are reset to baseline status, while bank balance and crew leadership are preserved. You receive a share of available loot in addition to the bounty.\nAfter a successful kill you immediately receive an inbox message from Hitlist Bureau with a breakdown of the bounty and loot (cash + items).\nTargets with an active bodyguard or security protection are harder to hit.\nYou can remove your own name from the hitlist by paying the placer or buying out the bounty yourself.';

  @override
  String get helpTopicHitlistTips =>
      'Check the hitlist daily: high bounties on weak players are quick profit if you are in the same country.\nOnly place a bounty on a player when you have reason to believe they are offline or low on HP.\nSkip cheap Quick intel if the target keeps elite bodyguards and has been playing recently; a Slow report always shows the country. A max tank rarely falls in one shot: a failed hit still cuts guards and HP on both sides, and you can try again after 10 minutes.';

  @override
  String get helpTopicSecurityCategory => 'Risk';

  @override
  String get helpTopicSecurityTitle => 'Security';

  @override
  String get helpTopicSecuritySummary =>
      'Protect your character and empire with armor, bodyguards and installation security. Better security means less damage taken during attacks.';

  @override
  String get helpTopicSecurityHow =>
      'Buy vests on Black Market → Security: Stab vest (€7,500) → Bulletproof vest (€50,000) → Premium bulletproof vest (€125,000) → AP plate vest (€280,000). Rifle calibers 5.56, 7.62 and .308 pierce normal vests unless you wear the AP plate vest.\nYou can only wear 1 vest at a time. A damaged vest can be repaired for half the missing-condition value. Buying another vest replaces the current one and credits 40% of the old vest price, scaled by condition.\nEach vest type reduces incoming damage when it matches the attack: stab vests stop knives, bulletproof vests stop regular bullets, and the AP plate vest also stops armor-piercing rounds. A mismatch keeps only a fraction of the vest defense.\nArmor gets damaged after an attack and loses effectiveness. The lower the condition, the less protection your current armor provides.\nAt 0% condition your armor is destroyed and disappears completely; you need to buy a new set to regain protection.\nBodyguards are capped at 10 in total across three qualities: street muscle (+8 defense, €6,000 hire, €4,000/day), standard (+10, €10,000 hire, €10,000/day) and elite (+22, €35,000 hire, €18,000/day). You can dismiss them at any time.\nIf you cannot pay the combined daily wage, all bodyguards leave and you lose their protection immediately.\nVest and bodyguards also cut crime HP loss (each attempt, up to about half). A failed murder attempt drops bodyguards and your HP, and wears your vest; the contract stays open. On detective reports, bodyguards can hide location and strength while you have been playing recently; Slow always leaks the country, and after a week offline the cover drops. They do not replace nightclub, red-light or territory security.\nInstallation security (for nightclub, drug facility, etc.) lowers raid and incident chance at that specific location.\nThe higher your Wanted Level the more often you are attacked or raided. Better security compensates for this directly.\nCrew members can split security roles so multiple locations are covered simultaneously.';

  @override
  String get helpTopicSecurityTips =>
      'Always wear at least a stab vest when Wanted Level is 2 or higher: savings on hospital bills quickly offset the purchase price.\nRepair a damaged vest instead of buying the same one again; check condition after every attack.\nRifle ammo (5.56, 7.62, .308) punches through normal vests; buy the AP plate vest if those calibers show up against you.\nOnly keep as many bodyguards as you can still afford tomorrow; elite guards hit hardest but their daily wage adds up fast.\nBodyguards do not hide your country if you stay offline for a week; Slow leaks the country anyway.';

  @override
  String get helpTopicHospitalCategory => 'Recovery';

  @override
  String get helpTopicHospitalTitle => 'Hospital';

  @override
  String get helpTopicHospitalSummary =>
      'Recover HP after fights, failed crimes or raids. The hospital offers free emergency care and paid treatments for faster recovery.';

  @override
  String get helpTopicHospitalHow =>
      'Fall below 10 HP and you are automatically admitted to the Emergency Room (ER). This is free but takes longer.\nPaid treatment costs €10,000 per session and restores +30 HP. Cooldown: 60 minutes between paid treatments.\nICU (Intensive Care) is the heaviest treatment for critical damage. Cooldown: 180 minutes. Costs are higher but recovery is more complete.\nWith higher HP (50+) you can still perform actions but are more vulnerable to attacks.\nHospital treatments are blocked while you are in prison. Get out first, then seek treatment.\nSchool certificate in Medicine lowers hospital costs and speeds up recovery times.\nCrew medics or medic skills can restore HP outside the hospital as emergency recovery.';

  @override
  String get helpTopicHospitalTips =>
      'Never recover halfway: wait for full HP before doing PvP or high-risk crimes.\nTime paid treatments around cooldown: start a treatment just before going offline so you come back online at full HP.';

  @override
  String get helpTopicPrisonCategory => 'Recovery';

  @override
  String get helpTopicPrisonTitle => 'Prison';

  @override
  String get helpTopicPrisonSummary =>
      'Serve your prison sentence, pay bail or attempt to escape. The higher your Wanted Level the longer and more expensive your sentence.';

  @override
  String get helpTopicPrisonHow =>
      'After arrest a timer starts based on Wanted Level. Wanted Level 1 = short sentence (minutes), Wanted Level 5+ = hours in prison.\nBail scales with your remaining sentence and never drops below Wanted Level × €1,000. Longer sentences therefore cost more to buy out immediately.\nEscape: you get at most 2 self-escape attempts per sentence, with 15 minutes between them. Success chance is low. Failure adds 15 minutes. After that: pay bail, wait, or let friends/crew break you out.\nIn the Prison list and jail overlay you can always pay your own bail and also attempt your own escape while still jailed.\nCrew members can visit you and provide small benefits (stats, morale) while you are locked up.\nOn arrest your friends and crew members now receive a push notification that you were caught and are waiting for help.\nWeapons and armor are confiscated on arrest if you have no legal cover for them.\nCourt option: go to court for a sentence reduction via a lawyer (see Court).\nWhile locked up production timers (drugs, ammo factory) keep running. Your empire works without you.\nYou cannot visit the hospital while locked up. HP recovery waits until you are free.';

  @override
  String get helpTopicPrisonTips =>
      'Check bail immediately after arrest: the button should remain visible as long as you are still jailed, even if your Wanted Level has already dropped.\nStart production timers just before doing a high-risk crime run: if you get caught production keeps running anyway.';

  @override
  String get helpTopicVaultCategory => 'Events';

  @override
  String get helpTopicVaultTitle => 'Crack the Vault';

  @override
  String get helpTopicVaultSummary =>
      'Monthly vault season: enter a 4-digit code and stake credits for a chance at big prizes.';

  @override
  String get helpTopicVaultHow =>
      'Each month a new season starts on the 1st and ends on the last day of the month.\nPick a stake (e.g. 1/3/5 credits) and enter a 4-digit code.\nYou can also enter the code using the on-screen keypad (digit buttons).\nEach attempt costs credits. If you guess correctly, you win a prize.\nHigher stakes mean bigger prizes; sometimes a VIP reward can drop.\nIf you are already VIP, a VIP reward is converted into credits.\nYou can view your wrong codes for this month. The list resets automatically with the new month.';

  @override
  String get helpTopicVaultTips =>
      'Pick a stake that matches your credit balance: you can try unlimited times, but each attempt costs credits.\nUse the wrong-codes list to avoid retrying the same code.';

  @override
  String get helpTopicGarageCategory => 'Assets';

  @override
  String get helpTopicGarageTitle => 'Garage';

  @override
  String get helpTopicGarageSummary =>
      'Steal and manage cars and motorcycles for crimes and smuggling. Garage handles ownership, timed repairs, selling and scrapping; transport runs through Smuggling Hub.';

  @override
  String get helpTopicGarageHow =>
      'Your garage shows cars and motorcycles with condition (0-100%), fuel, market value, rarity and world-cap status.\nCar storage and motorcycle storage are now separated: cars use garage capacity, motorcycles use motorcycle storage capacity.\nCar and motorcycle storage upgrades are independent per country: upgrading cars does not increase motorcycle capacity (and vice versa). Upgrades are rank-gated; when your rank is too low you see a lock/tooltip. At level 5 the upgrade button is hidden.\nUsing the catalog button you can view all stealable cars and motorcycles, including their most common country and full spawn country list.\nTheft is per vehicle with rank requirements and cooldowns. The more expensive and rare, the lower your success chance.\nIf a model world-cap is full, you cannot steal that model temporarily. When a copy is sold or scrapped, 1 slot reopens immediately.\nFailed theft increases Wanted Level and can trigger arrest. If police catch you during the getaway, you go to jail and the just-stolen vehicle is confiscated immediately.\nRepairs are timed: you pay upfront, the vehicle enters repair and only returns after the timer finishes.\nConcurrent repairs are limited across car, motorcycle and boat together: without VIP max 1 active, with VIP max 2 active.\nScrapping is an alternative to selling: you receive salvage value (35% of base value), scaled by condition and garage upgrade bonus.\nVehicle Ops Intelligence adds 6 extra options. In short:\n1) Hotspot run: a quick action for direct cash, with its own cooldown and added risk.\n2) Parts market: live parts prices per type (car/motorcycle/boat) for tuning; prices refresh periodically.\n3) Crew op: a co-op action with your crew for extra gains/advantages (only if you are in a crew).\n4) Heat: per type (car/motorcycle/boat) an “attention” meter; higher heat makes actions riskier and lowers success chance. Heat decays slowly.\n5) Chop contract: hand in an eligible vehicle from your inventory for a fixed contract payout.\n6) Police pattern: time-of-day patterns can increase checks; this affects risk (e.g. harbor strike/lockdown for boats).\nIn Vehicle Heist, Car/Motorcycle/Boat now use one command layer: select category via the three lane cards at the top, without a second extra tab row.\nEach lane card includes direct quick actions for stealing and storage upgrades, so you do not need to scroll to separate sub-buttons first.\nWhile a steal cooldown is running, a lightning icon appears next to the timer: tap it to spend credits and clear the cooldown. You can turn off the confirmation dialog; turn it back on in Settings under theft cooldown (credits).\nLane cards now also show capacity per type directly (used/total + upgrade level).\nStolen vehicles now render as responsive cards: mobile shows one per row, tablet/desktop show multiple cards side by side.\nNew Ops layer: PvP interception windows for hotspots, crew-role bonuses in crew ops, reputation unlocks per vehicle type, regional blacklist events, and contraband insurance contracts.\nNew Vehicle Ops expansions: Counter-Intercept missions, Crew Matchmaking with seasonal ladder, Country Modifiers (inflation/corruption/harbor strike), and a contracts board with weekly legendary contracts.\nOps now shows live cooldowns per action. Timers count down visibly and refresh automatically.\nCrew actions (Crew Op and Crew Match) are only available when you are in a crew; without a crew you get a clear unlock hint.\nSuccessful ops actions pay cash directly to your wallet. The action overview shows the expected payout type per button.\nInsurance claims now enter review first; using claim dispute lets you contest for extra payout with rejection risk.\nHigher category heat lowers theft success chances and raises hotspot risk. Heat decays gradually each hour.\nChop-Shop Contracts require an eligible vehicle from your inventory; claiming consumes that vehicle and pays out contract cash.\nVehicle transport no longer happens in Garage; use the Smuggling Hub flow.\nResale and scrapping free either car or motorcycle capacity and may reopen world-cap slots for that model.\nEvent-only vehicles such as police interceptors stay locked outside event windows.';

  @override
  String get helpTopicGarageTips =>
      'Steal vehicles actively when Wanted Level is low: higher Wanted = higher failure chance when stealing.\nAlways keep at least one reliable vehicle at high condition for smuggling: a broken vehicle halves your success chance.\nUse scrapping for heavily damaged vehicles as a fast capacity reset; selling is often better at high condition.';

  @override
  String get helpTopicMarinaCategory => 'Assets';

  @override
  String get helpTopicMarinaTitle => 'Marina';

  @override
  String get helpTopicMarinaSummary =>
      'Manage boats with rarity, world caps and repair timers for maritime smuggling routes. Marina focuses on ownership, maintenance, selling and scrapping; transport runs through Smuggling Hub.';

  @override
  String get helpTopicMarinaHow =>
      'The marina shows your boats with condition, fuel, market value, rarity and world-cap status per model.\nUsing the catalog button you can view all stealable boats, including most common country and full spawn country list.\nBoat theft has its own rank gates and cooldowns. More expensive boats are harder to steal but can be more profitable.\nIf a boat model world-cap is full, it temporarily disappears from the available list. Selling/scrapping reopens slots.\nRepairs are timed: you pay upfront and the boat is unavailable until the timer completes.\nConcurrent repairs are limited across car, motorcycle and boat together: without VIP max 1 active, with VIP max 2 active.\nScrapping grants salvage value (35% of base value), scaled with condition and marina upgrade bonus.\nMarina manages ownership and maintenance only; actual transport routing happens in Smuggling Hub.\nEvent-only police boats are for temporary events and remain locked outside event windows.';

  @override
  String get helpTopicMarinaTips =>
      'Invest in the marina if your smuggling routes regularly go via water: lower police interest can significantly boost success chance.\nKeep a speedboat at high condition as a quick alternative when land escape routes are blocked.\nScrap heavily damaged boats with low resale value to free world-cap room and marina capacity faster.';

  @override
  String get helpTopicTuneshopCategory => 'Assets';

  @override
  String get helpTopicTuneshopTitle => 'Tune Shop';

  @override
  String get helpTopicTuneshopSummary =>
      'Use salvaged parts to upgrade vehicles by category. Improve speed, stealth and armor with scaling level costs and category cooldowns.';

  @override
  String get helpTopicTuneshopHow =>
      'You earn parts by scrapping vehicles: car parts, motorcycle parts and boat parts.\nParts are category pooled: any vehicle in the same category uses the same parts stock.\nEach upgrade costs parts and money. Money costs are category based and increase per tuning level.\nYou can upgrade three stats: speed, stealth and armor.\nTuning is per vehicle in your inventory. New vehicles start at level 0 again.\nAfter each tune there is a per-vehicle cooldown: car 180s, motorcycle 120s, boat 240s.\nConcurrent tuning is limited: without VIP max 1 active vehicle in tuning cooldown, with VIP max 5.\nTuned vehicles yield higher sell and salvage value.\nTuning is blocked while a vehicle is in repair or transport.';

  @override
  String get helpTopicTuneshopTips =>
      'Scrap heavily damaged vehicles first to build parts quickly.\nInvest in stealth early for lower capture risk on high-risk runs.\nUse armor upgrades on vehicles you repeatedly deploy in dangerous loops.';

  @override
  String get helpTopicShootingRangeCategory => 'Training';

  @override
  String get helpTopicShootingRangeTitle => 'Shooting Range';

  @override
  String get helpTopicShootingRangeSummary =>
      'Improve your accuracy and weapon skill through structured shooting drills. Higher stats increase damage and hit chance in PvP and crimes.';

  @override
  String get helpTopicShootingRangeHow =>
      'The shooting range offers multiple disciplines: pistol, rifle, shotgun and automatic fire. Each trains a separate weapon skill.\nEach training session has a cooldown of 30 minutes. You cannot train endlessly per day.\nHigher accuracy increases your hit chance in PvP fights and lowers the chance of being hit yourself.\nWeapon skill also determines which weapons you can use effectively: a sniper rifle requires a certain skill before you get its full bonus.\nTraining results stack cumulatively. There is no reset unless you receive a heavy penalty via the court.\nSchool certificate Military Training gives a permanent bonus to each shooting range session.';

  @override
  String get helpTopicShootingRangeTips =>
      'Train the shooting range every day: small cumulative bonuses become noticeable in PvP outcomes within a week.\nTrain the weapon type you use most in crimes and PvP for maximum return on investment.';

  @override
  String get helpTopicGymCategory => 'Training';

  @override
  String get helpTopicGymTitle => 'Gym';

  @override
  String get helpTopicGymSummary =>
      'Train strength, speed and stamina for better stats in PvP, crimes and HP pool. Daily training is key to fast stat growth.';

  @override
  String get helpTopicGymHow =>
      'The gym offers three training categories: Strength (more damage per attack), Speed (higher reflexes, less hits taken), Stamina (higher max HP).\nEach training has a 1 hour cooldown. Maximum 6-8 sessions per day depending on your school certificate.\nStrength increases direct damage in both PvP and certain crime types (robbery, brawl).\nSpeed increases the chance to dodge an attack and lowers the chance of being caught on crime failure.\nStamina increases your max HP pool. More HP = surviving longer in PvP and more room for risky crimes.\nSchool certificate Physical Training gives +15% bonus to all gym sessions.';

  @override
  String get helpTopicGymTips =>
      'Prioritize Stamina training: a higher HP pool improves all your other systems because you stay active longer.\nCombine gym with shooting range: Strength + Accuracy is the strongest PvP combination.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Empire';

  @override
  String get helpTopicAmmoFactoryTitle => 'Ammo Factory';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produce ammunition for personal use and manage your output from the factory. Ammo buying and selling go through the Black Market, not directly from the factory screen.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'The ammo factory has production levels (Level 1 through 5). Higher level = more rounds per claim and better quality.\nDuring an active session you claim production about every 10 minutes (up to 8 hours of backlog within that session).\nProduction keeps accruing while you are offline: when you return you can claim multiple times until backlog is caught up.\nSimply viewing the ammo factory or travelling away and back must not change ownership; a factory should not flip to `for sale` just because the screen was opened.\nProduced ammo is used personally in crimes and PvP. For buying and selling ammo, go through the Black Market; the factory screen itself does not sell bullets directly.\nOutput upgrades increase rounds per claim; quality upgrades improve market value.\nAmmo market price fluctuates with demand. Stock up when prices are low and sell when prices are high.\nDuring a factory raid you lose part of stored output. Security lowers this risk.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Upgrade your factory to Level 3 as soon as possible: the doubled output compared to Level 1 makes it self-sufficient for ammo.\nAlways keep 2-3 production rounds of output in reserve as a buffer so you never run out of ammo during PvP.';

  @override
  String get helpTopicSchoolCategory => 'Training';

  @override
  String get helpTopicSchoolTitle => 'School';

  @override
  String get helpTopicSchoolSummary =>
      'Follow courses in multiple tracks to unlock bonuses, reduce costs and open new systems. School is a multiplier on everything you do.';

  @override
  String get helpTopicSchoolHow =>
      'School offers tracks per domain: Criminal (better crime stats), Economy (lower trade and bank costs), Military (combat bonuses), Medicine (lower hospital costs), Law (lower lawyer costs), Technical (better factory and drug production).\nEach lesson has a study time of 15-60 minutes depending on level. Higher levels take longer.\nAfter completing a lesson you receive a certificate for that track level. This certificate is permanent and grants the bonus immediately.\nYou can only follow one lesson at a time. Plan your studies carefully when you urgently need a specific certificate.\nSchool costs increase per level. Higher education requires earlier levels in the same track to be completed.\nSome advanced game features are locked behind a school certificate: e.g. access to certain jobs, higher factory levels, VIP nightclub events and higher drug facility upgrade tiers.\nCertificates are never reset unless your account receives a heavy penalty.';

  @override
  String get helpTopicSchoolTips =>
      'Always start with the Criminal track: bonuses to crime success chances pay back the study costs within a few sessions.\nSchedule long studies (60 min+) before going to sleep: you wake up with a new certificate without missing active time.';

  @override
  String get helpTopicTerritoryCategory => 'Empire';

  @override
  String get helpTopicTerritoryTitle => 'Territory';

  @override
  String get helpTopicTerritorySummary =>
      'Claim and control geographical regions for passive income, crew prestige and strategic regional bonuses. Territory combines map control with contests and seasonal rewards.';

  @override
  String get helpTopicTerritoryHow =>
      'Territory overview shows all available countries and regions by country. Click a country to see the interactive map.\nAll supported countries are now fully browseable through the same interactive map flow as the Netherlands.\nTap a region on the interactive map to open a modal with territory information and the attack button. The separate region cards below the map are no longer needed.\nViewing is allowed everywhere, but attacks, defense joins and contest actions only work in the country where your character is currently located.\nOn mobile you can now pinch in and out with two fingers and drag the zoomed map directly, making smaller regions easier to tap without extra buttons on the map.\nTerritory is crew-based: you must create or join a crew before the attack button becomes available for neutral or hostile regions.\nEach region can be controlled by at most one crew at a time. Ownership grants passive income per hour, but Territory stops paying into the crew bank once the cash storage cap has been reached.\nStart a contest in an unclaimed region using the contest button. The contest automatically progresses through preparation (prep time), active (actions), and lockdown (resolution).\nWhen preparation ends, attacking and defending crew members receive a push notification and inbox message so you know you can attack or defend. That alert is sent by the minute cron even if nobody has the Territory screen open.\nDuring an active contest the region modal now also shows when actions unlock, when the contest ends, what the per-action cooldown is, and the real cash amount the region pays per payout, per hour and per day.\nRegions now also have strategic roles such as harbor, industry, capital, border region or logistics hub. That role determines which actions can earn extra points there.\nAdjacent regions already owned by your crew now provide extra support during contest actions. The region modal shows which strategic bonuses are active and how much adjacent support your crew has in that area.\nAction bonuses can now also come from crew progression: HQ level, crew mission level, and relevant side buildings (weapon/ammo/car/boat/drug storage). These bonuses only increase contest points, not passive region cash.\nSome advanced contest actions are HQ-gated: if your HQ level is too low, the action button shows `requires HQ level X` immediately.\nTerritory no longer uses a hard daily action cap by default (runtime cap 0 = disabled). Balance stays controlled through cooldowns, anti-farm and strategic action choices.\nWinning a Territory War or Total War can now leave temporary war pressure on the real Territory regions around that frontline. The region modal shows which crew holds the pressure, how much effective stability is reduced, and when the aftermath expires.\nWhen a contest has just started or an older contest was still missing timing fields, the screen now fills those timers immediately and refreshes the modal to the latest contest state without requiring you to navigate away first.\nAttackers only see attacker actions (intel, sabotage, raid) and defenders only see defender actions (patrol, supply run, defense), so the modal no longer shows confusing mixed buttons.\nA region now also shows the real Territory yield. Crew leaders also see how many regions and countries their crew controls on the dashboard, how much the crew is currently earning, and how much Territory has earned in total so far.\nContests result in ownership transfer and rewards (cash, XP, prestige). Losers also get partial xp for participation.\nLarge regions (harbors, capitals) give more passive income but also trigger more opponents and raid attempts.\nSeasonal events give bonus rewards and special challenges per region group.\nPrevent deadlocks: your crew cannot immediately attack the same opponent after a loss; wait for cooldown.\nAnti-abuse checks prevent one crew from attacking the same target repeatedly in short time windows.\nOwning crews can also buy a timed garrison (tanks and air defense) from the crew bank. The region stays attackable, but defense actions score extra points and attackers need a larger lead to capture it. Only a few garrisons can be active at once.';

  @override
  String get helpTopicTerritoryTips =>
      'Start in a balanced country with medium-sized regions: less competition than large countries but reasonable passive income.\nFocus on one country where your crew is strong first: better knowledge leads to better contest strategy than shallow control in many countries.\nUse seasons as strategic resets: if you lose in a dry season, a better season always follows for a comeback.\nBuy a garrison on a valuable region before a long night or a known raid window: it is not a lock, but it makes a sleepy defense much harder to overrun.';

  @override
  String get helpTopicProstitutionCategory => 'Empire';

  @override
  String get helpTopicProstitutionTitle => 'Prostitution';

  @override
  String get helpTopicProstitutionSummary =>
      'Build a prostitution network with recruits, events and VIP clients. A well-run network generates passive income but requires active management to control rivalry and police attention.';

  @override
  String get helpTopicProstitutionHow =>
      'You manage recruits each with their own stats (experience, popularity, availability). More recruits = higher passive income.\nWork shifts run for 8 hours per recruit: after a shift, that recruit needs rest time before you can start again.\nLocation management is flexible: you can move recruits between street, Red Light District and nightclub using the action buttons on each card.\nEvents are temporary boosters: special shows, VIP nights and parties raise income per tick for the duration of the event.\nRivalry: other players or NPC competitors can poach your recruits or sabotage events. Higher security lowers this risk.\nVIP clients pay considerably more but require recruits with high popularity (80+) and a secured location.\nPolice attention (heat) rises with large transactions and raids. High heat leads to income confiscation or temporary shutdown.\nCombination with nightclub: a nightclub provides legal cover for activities making heat rise more slowly.\nUse the earnings insight panel at the top to quickly compare hourly output for street, RLD and nightclub.\nLeaderboard: highest total weekly turnover wins a weekly cash reward and a badge.';

  @override
  String get helpTopicProstitutionTips =>
      'Invest early in security: a rivalry attack that poaches your best recruit costs more than the security investment.\nOnly organise VIP events when recruits are above 80 popularity: below that threshold VIP clients simply pay the standard rate.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Empire';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Red Light Districts';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Claim and manage territorial districts per country. Owning a district gives passive income and control over prostitution activities in that region.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'Each country has one or more Red Light Districts that can be claimed. Claim a district by paying a set purchase amount.\nAs owner of a district you receive a percentage of all prostitution income in that country — including from other players operating there.\nOther players can attack your district to take over ownership. Higher security lowers the attack chance.\nDistrict upgrades (security, marketing, infrastructure) raise your income percentage and lower the chance of losing ownership.\nYou can own up to 3 districts simultaneously. Strategic country choice is essential.\nBusiest countries (Colombia, Dubai, Japan) give the highest passive income but are also the most contested.\nLosing a district does not refund the purchase price: it is permanently lost if an enemy successfully claims it.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Start with a less popular country for your first district: lower attack pressure gives you time to upgrade security before the real competition.\nUpgrade security of each district immediately after purchase: the first 24 hours are the most vulnerable to a takeover.';

  @override
  String get helpTopicAchievementsCategory => 'Meta';

  @override
  String get helpTopicAchievementsTitle => 'Achievements';

  @override
  String get helpTopicAchievementsSummary =>
      'Earn badges by reaching milestones across all game systems. Achievements give rewards, raise your status profile and show your progress per category.';

  @override
  String get helpTopicAchievementsHow =>
      'Achievements are grouped in categories: Crimes, Empire, PvP, Economy, Training, Social and Meta.\nEach achievement has multiple tiers (Bronze, Silver, Gold, Platinum). Each tier gives a higher reward and a more impressive badge.\nRewards per achievement include: cash, XP, special items, permanent bonuses or unique titles for your profile.\nProgress is tracked automatically. You do not need to activate anything: reach the threshold and the badge is awarded immediately.\nSome achievements are hidden until you partially complete them — they then appear with their real name and requirements.\nAchievement badges are visible on your public profile. They show other players your specializations and experience.\nChain achievements: some badges are linked in a chain. Gold requires Silver to be already obtained. Plan early for higher tiers.';

  @override
  String get helpTopicAchievementsTips =>
      'Check your nearly-completed achievements daily: a small extra effort can earn a badge and cash reward that would otherwise be delayed for months.\nFocus early on Economy and Crime categories: these have the most cash rewards and are easiest to combine with your normal gameplay.';

  @override
  String get helpTopicSupportTicketsCategory => 'Support';

  @override
  String get helpTopicSupportTicketsTitle => 'Reports & Tickets';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Report bugs, questions or feedback via the ticket system. Support and admins can reply, manage internal follow-up and send updates back through the support conversation itself and optional push notifications.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Open the separate `Support` menu item to review your tickets or create a new one.\nChoose a category (bug, question, feedback or other), select the related module if needed, and describe your issue as specifically as possible.\nYou can optionally add a reference such as an order id, screen name or short context, plus a screenshot if that helps.\nAfter submission you immediately receive a ticket number and your ticket appears in your support overview, where support can reply and create internal todo tasks.\nWhen support replies or the ticket status changes, you see that directly inside the same support conversation and can optionally receive a push notification (if notifications are enabled).\nThe Support menu item shows a badge as soon as a ticket gets a new support reply or status update since your last visit to the support overview.\nSupport uses statuses such as new, triage, in progress, waiting for player, blocked and resolved to track your report internally.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Always include your country, action and exact error message; this speeds up fixes for developers.\nUse one ticket per issue type so the todo list and follow-up stay clear.';

  @override
  String get helpTopicSettingsCategory => 'Core';

  @override
  String get helpTopicSettingsTitle => 'Settings';

  @override
  String get helpTopicSettingsSummary =>
      'Manage all account settings: language, avatar, privacy, notification preferences per system and security options. Settings directly affect your gameplay experience.';

  @override
  String get helpTopicSettingsHow =>
      'Language: switch between Dutch and English. All UI texts, system messages and notifications update immediately.\nAvatar: upload or select a profile image visible to other players on your public profile and in crew lists.\nPrivacy: set who can see your online status, location (current country) and statistics — only you, crew, friends or everyone.\nPush notifications: toggle per system. Categories: Crimes, Crypto trading, Price alerts, Orders, live player events (competition), Market regime, Heist, Nightclub, general messages.\nIf push was already allowed, the web/PWA version automatically reconnects to your current device token after a refresh or update; you only need to re-enable it in Settings when the browser itself blocks notifications.\nCrypto notification preferences remain saved after leaving Settings and opening it again later.\nIn-app notifications: configurable separately from push. In-app shows alerts inside the app without sending a system notification.\nSecurity: change password, set up two-factor authentication and view active sessions.\nPer-system notification preference: fine tune so you do not get a notification storm from systems you are not actively playing.';

  @override
  String get helpTopicSettingsTips =>
      'Enable push notifications for Crypto Orders and Heist Events: these are time-critical systems where quick reaction matters.\nSet privacy to crew-only for location when you are active on the hitlist: other players can otherwise pinpoint you exactly.';

  @override
  String get helpTopicPremiumCategory => 'Core';

  @override
  String get helpTopicPremiumTitle => 'Premium & Credits';

  @override
  String get helpTopicPremiumSummary =>
      'Buy and manage Player VIP, Crew VIP and credit bundles here. See auto-renew, gift VIP, and build VIP prestige (display only).';

  @override
  String get helpTopicPremiumHow =>
      'Open the separate `Premium & Credits` page from the side menu to view your VIP status, expiry dates, credit balance and purchase options.\nOn each purchase tile, tap/click the `i` icon at the top-left for full details and benefits; the tile itself intentionally shows only short core info and the buy button.\nPlayer VIP is personal. Crew VIP applies to your crew and only has value when you are already in a crew.\nPlayer VIP gives 10% shorter action timeouts (jail time remains unchanged), 100 weekly credits, a VIP one-click purchase button for missing materials in Drug Production (after cost confirmation), and a softer death reset: bank/crypto/education/achievements stay, while assets, inventory and drug stock are removed.\nVIP checkout opens the payment page and then returns to the in-game `Premium & Credits` section, so you immediately see whether the purchase succeeded and how long your VIP runs.\nWhen auto-renew is active you can cancel renewal; your current VIP stays valid until the expiry date.\nGift VIP buys 30 days of Player VIP for another player by username (one-time; recipient does not get auto-renew).\nGift Crew VIP buys 30 days of Crew VIP for a crew by crew name (one-time; no auto-renew).\nVIP prestige (bronze/silver/gold) is display-only from lifetime VIP days and grants no gameplay power.\nCredit bundles are bought with real money. After a successful payment the credits appear in your wallet overview right away.\nEvent Pass (7 days, real money) is listed in the one-time offer grid: +10% score on live player events, plus a small credit bonus after purchase. It is a side-grade: not a direct combat or PvP boost; it mainly helps leaderboard results during running events.\nCredit items use wallet credits instead of euros. Think of hit protection, cooldown resets, event boosts or cash bundles, depending on what admin currently has enabled live.\nOn supported timeout screens (such as crimes, jobs, vehicle/boat theft and school) you also get a direct speed-up button for active cooldowns, so you do not need to go back to Premium & Credits first.\nSome credit items work directly from this screen. Context-bound items, such as certain vehicle actions, are used from the correct vehicle or garage screen instead (damaged vehicles show an instant-repair button directly on the card).\nFor contextual buttons such as repair speed-up, the current credit cost is shown directly on the button/tooltip.\nPrices and available items are managed live in admin. That means VIP prices, credit costs and the available offer can change without an app update.';

  @override
  String get helpTopicPremiumTips =>
      'Check your credit balance and expiry date before buying again; extending is often better than stacking blindly.\nCancel auto-renew in time if you do not want ongoing charges; your paid-through period still runs.\nUse credits mainly on time-critical boosts or protection, not automatically on every small shortcut.\nIf you are not in a crew yet, start with Player VIP or a credit bundle before Crew VIP.';

  @override
  String get landingHeroTitle => 'The Mob State';

  @override
  String get landingHeroSubtitle =>
      'A deep text-based crime strategy game in your browser. Build your empire, run crews, trade, fight for territory — and climb the ranks.';

  @override
  String get landingAboutTitle => 'What awaits you';

  @override
  String get landingAboutBody =>
      'Manage businesses, execute jobs and heists, develop your character through school certificates, compete in live events, and coordinate with your crew on the world map. Fair competitive rules, long-term progression, and regular content updates.';

  @override
  String get landingTopPlayersTitle => 'Top players';

  @override
  String get landingTopCrewsTitle => 'Top crews (territory)';

  @override
  String get landingRankLabel => 'Rank';

  @override
  String get landingRegionsLabel => 'Regions';

  @override
  String get landingLoadError => 'Could not load rankings right now.';

  @override
  String get landingEmptyLeaderboard => 'No entries yet.';

  @override
  String get landingCtaLogin => 'Log in';

  @override
  String get landingCtaRegister => 'Create account';

  @override
  String get landingFooterPrivacy => 'Privacy Policy';

  @override
  String get landingFooterTerms => 'Terms of Service';

  @override
  String get landingFooterDigitalGoods => 'Purchase of Digital Goods';

  @override
  String get landingFooterLanguage => 'Language';

  @override
  String landingCopyright(int year) {
    return '© $year The Mob State. All rights reserved.';
  }

  @override
  String get legalPrivacyTitle => 'Privacy Policy';

  @override
  String get legalPrivacyLastUpdated => 'Last updated: May 2026';

  @override
  String get legalPrivacyIntro =>
      'This Privacy Policy explains how The Mob State (\"we\", \"us\") handles personal data when you use our website, web game and related services. By playing or browsing you agree to this policy where applicable law allows.';

  @override
  String get legalPrivacySection01Title => 'Who we are';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State is an online game operated as a digital service. For privacy requests you can contact us through the in-game support ticket system after registration, or via the official website contact channels if published.';

  @override
  String get legalPrivacySection02Title => 'Data we collect';

  @override
  String get legalPrivacySection02Body =>
      'We may process account data (username, email if provided, hashed password), gameplay and progression data, technical logs (IP address, device/browser type, timestamps), payment-related references from our payment providers (we do not store full card numbers), and communications you send to support.';

  @override
  String get legalPrivacySection03Title => 'Purposes';

  @override
  String get legalPrivacySection03Body =>
      'We use data to provide the game, secure accounts, prevent abuse and fraud, process purchases, improve performance, communicate service messages, and comply with legal obligations.';

  @override
  String get legalPrivacySection04Title => 'Legal bases (EEA/UK)';

  @override
  String get legalPrivacySection04Body =>
      'Where GDPR applies we rely on performance of a contract (providing the game), legitimate interests (security, analytics, product improvement balanced against your rights), consent where required (e.g. certain marketing cookies or optional communications), and legal obligations.';

  @override
  String get legalPrivacySection05Title => 'Cookies and local storage';

  @override
  String get legalPrivacySection05Body =>
      'We use cookies and similar technologies to keep you signed in, remember preferences, measure basic usage, and deliver essential functionality. You can control many cookies through your browser settings.';

  @override
  String get legalPrivacySection06Title => 'Retention';

  @override
  String get legalPrivacySection06Body =>
      'We retain information as long as needed to operate the service and meet legal, tax, and accounting requirements. Some logs may be kept for a limited security window. When data is no longer needed we delete or anonymise it where feasible.';

  @override
  String get legalPrivacySection07Title => 'Sharing';

  @override
  String get legalPrivacySection07Body =>
      'We share data with infrastructure and payment processors strictly as needed to run the service, under appropriate agreements. We do not sell your personal data. We may disclose information if required by law or to protect rights and safety.';

  @override
  String get legalPrivacySection08Title => 'International transfers';

  @override
  String get legalPrivacySection08Body =>
      'Your data may be processed in the European Economic Area and/or other regions where we or our providers operate. We use safeguards such as standard contractual clauses where required.';

  @override
  String get legalPrivacySection09Title => 'Your rights';

  @override
  String get legalPrivacySection09Body =>
      'Depending on your location you may have rights to access, rectify, erase, restrict or object to certain processing, and to data portability. You may lodge a complaint with a supervisory authority. Contact us via support to exercise rights; we may need to verify your identity.';

  @override
  String get legalPrivacySection10Title => 'Children';

  @override
  String get legalPrivacySection10Body =>
      'The game is not directed to children under the age where parental consent is required for processing in your region. If you believe a child provided data improperly, contact us and we will take appropriate steps.';

  @override
  String get legalDigitalGoodsTitle => 'Purchase of Digital Goods';

  @override
  String get legalDigitalGoodsLastUpdated => 'Last updated: May 2026';

  @override
  String get legalDigitalGoodsIntro =>
      'This policy describes purchases of digital content and services in The Mob State (for example premium credits, VIP time, or other virtual items). By completing a purchase you agree to these terms together with any checkout terms shown at payment.';

  @override
  String get legalDigitalGoodsSection01Title => 'Nature of digital purchases';

  @override
  String get legalDigitalGoodsSection01Body =>
      'All purchases are payments for access to additional online features and virtual items within The Mob State. They are delivered digitally in-game and have no physical form.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Immediate delivery and withdrawal (UK/EU)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Where the Consumer Contracts Regulations 2013 (UK) or equivalent EU rules apply, you acknowledge that digital content is supplied immediately after purchase and, where the law permits, you may lose the statutory 14-day right of withdrawal once delivery has begun with your prior express consent.';

  @override
  String get legalDigitalGoodsSection03Title => 'Refunds and chargebacks';

  @override
  String get legalDigitalGoodsSection03Body =>
      'Digital goods are generally non-refundable once delivered except where mandatory consumer law requires otherwise. Chargebacks or payment disputes after delivery may lead to suspension or termination of related accounts; please contact support first so we can help resolve billing issues.';

  @override
  String get legalDigitalGoodsSection04Title => 'Permission and age';

  @override
  String get legalDigitalGoodsSection04Body =>
      'You must be authorised to use the chosen payment method. If you are under 18, you need permission from a parent or guardian to make purchases or use paid services.';

  @override
  String get legalDigitalGoodsSection05Title => 'Payment channels and fees';

  @override
  String get legalDigitalGoodsSection05Body =>
      'Prices may be shown in euros or your provider currency. Mobile carriers or payment platforms may add their own fees; check with your provider before confirming carrier or wallet payments.';

  @override
  String get legalDigitalGoodsSection06Title => 'Availability';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Paid features are delivered virtually through our servers and may change over time. We may adjust, suspend or retire specific items, bundles, or pricing to balance the game or for technical reasons.';

  @override
  String get legalDigitalGoodsSection07Title => 'No real-world cash value';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Virtual items and currencies have no monetary value outside the game, are non-transferable for real money, and may be altered or removed as part of updates, account enforcement, or service discontinuation except where law requires compensation.';

  @override
  String get legalDigitalGoodsSection08Title => 'Prohibited commercial use';

  @override
  String get legalDigitalGoodsSection08Body =>
      'You may not use The Mob State to operate unauthorised real-money trading, including buying or selling accounts, in-game currency, codes, or virtual assets for cash or external services outside our official payment flows.';

  @override
  String get legalDigitalGoodsSection09Title => 'Service changes';

  @override
  String get legalDigitalGoodsSection09Body =>
      'We may update this policy and in-game purchase descriptions. Continued use after changes constitutes acceptance of the revised terms where permitted by law.';

  @override
  String get legalDigitalGoodsSection10Title => 'Governing law';

  @override
  String get legalDigitalGoodsSection10Body =>
      'Unless mandatory local law provides otherwise, this policy is governed by the laws of England and Wales and disputes shall be subject to the exclusive jurisdiction of the courts of England and Wales.';

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
  String get helpTopicTrainingHubCategory => 'Training';

  @override
  String get helpTopicTrainingHubTitle => 'Training hub';

  @override
  String get helpTopicTrainingHubSummary =>
      'Gym (three tracks: strength, speed, stamina) and shooting range in one place. Bonuses add to crime success; range also feeds hitlist. Each track has its own cooldown and 100-session cap.';

  @override
  String get helpTopicTrainingHubHow =>
      'Gym: three tracks — strength (+4%), speed (+2%), stamina (+2%) — up to +8% combined (100 sessions each). 1-hour cooldown per track (VIP may shorten).\nSmart train picks the first track that is ready.\nShooting range: accuracy bonus up to +10% (100 sessions). 1-hour cooldown. Hitlist accuracy scales with range progress.\nSame UTC day: at least one gym and one range session for +0.5% extra crime combo.\nProgress does not reset unless staff applies a heavy penalty.';

  @override
  String get helpTopicTrainingHubTips =>
      'Schedule all tracks daily: small steps stack into a clear edge on crimes.\nUse Smart train for quick sessions; train individual tracks when you want to prioritize one stat.';

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
  String get territoryProjectStart => 'Start region project';

  @override
  String get territoryProjectContribute => 'Supply project';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Requires HQ level $level';
  }

  @override
  String get territoryProjectHint =>
      'Choose a project type for this region. Sabotage damages it in contests; supply runs repair or advance it.';

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
      'Use this for street cash above today\'s free deposit limit.';

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
    return 'Min $min · Max $max per wash.';
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
    return 'Amount is below the minimum ($min).';
  }

  @override
  String launderErrorTooHigh(String max) {
    return 'Amount is above the maximum ($max).';
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
  String get territoryOverlayContest => 'Contest scores';

  @override
  String get territoryOverlayProject => 'Projects';

  @override
  String get territoryOverlayEvent => 'Region events';

  @override
  String get territoryLegendPocket => 'Pocket (thin border)';

  @override
  String get territoryLegendCluster => 'Cluster (thick border)';

  @override
  String get territoryContestHudTitle => 'Contest';

  @override
  String territoryContestHudScore(int attacker, int defender) {
    return 'Score $attacker:$defender';
  }

  @override
  String get territoryProjectSurveillance => 'Surveillance grid';

  @override
  String get territoryProjectArmsCache => 'Arms cache';

  @override
  String get territoryProjectPickTitle => 'Choose a region project';

  @override
  String get territoryProjectPickSubtitle =>
      'One project per region. Type depends on strategic tags and HQ level.';

  @override
  String get territoryProjectStartGeneric => 'Start project';

  @override
  String get territoryProjectLockedTags => 'Needs matching strategic tag';

  @override
  String territoryProjectLockedHq(int level) {
    return 'Requires HQ $level';
  }

  @override
  String get territoryProjectSafehouseDesc =>
      'Passive income bonus on this region.';

  @override
  String get territoryProjectSurveillanceDesc =>
      'Extra intel_scan points and shorter intel cooldown (harbor / airhub / capital).';

  @override
  String get territoryProjectArmsCacheDesc =>
      'Extra raid and defense points (industry / border).';

  @override
  String get territoryBonusRegionProject => 'Region project';

  @override
  String get territoryBonusGarrison => 'Garrison / air defense';

  @override
  String get territoryErrorProjectInvalidType => 'Unknown project type.';

  @override
  String get territoryErrorProjectTagMismatch =>
      'This project type does not fit this region\'s strategic tags.';

  @override
  String get territoryStatsTitle => 'Your crew territory stats';

  @override
  String get territoryStatsAllTime => 'All-time';

  @override
  String get territoryStatsSeason => 'This season';

  @override
  String get territoryStatsWon => 'Won';

  @override
  String get territoryStatsDefended => 'Defended';

  @override
  String get territoryStatsLost => 'Lost';

  @override
  String get territoryStatsContests => 'Contests';

  @override
  String get territoryStatsHoldTotal => 'Hold time total';

  @override
  String get territoryStatsHoldCurrent => 'Current hold';

  @override
  String get territoryStatsOwnedNow => 'Owned now';

  @override
  String get territoryLeaderboardScopeAllTime => 'All-time';

  @override
  String get territoryLeaderboardScopeSeason => 'Season';

  @override
  String territoryLeaderboardStatsLine(
    int won,
    int defended,
    int lost,
    String hold,
  ) {
    return 'W $won · D $defended · L $lost · hold $hold';
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
  String get countryPoliceStripTitle => 'Country police';

  @override
  String get countryPoliceBandCalm => 'Calm';

  @override
  String get countryPoliceBandWatchful => 'Watchful';

  @override
  String get countryPoliceBandHot => 'Hot';

  @override
  String get countryPoliceBandLockdown => 'Lockdown';

  @override
  String countryPolicePressureValue(int pressure) {
    return '$pressure/100';
  }

  @override
  String countryPoliceEffectLine(int successPenalty, int arrestBonus) {
    return 'Crime success −$successPenalty pp · Arrest +$arrestBonus pp';
  }

  @override
  String get countryPoliceDisruptTitle => 'Disrupt police pressure';

  @override
  String get countryPoliceDisruptHint =>
      'Rare ops that can cool local heat. Failure raises Wanted and FBI heat.';

  @override
  String get countryPoliceDisruptButton => 'Disrupt';

  @override
  String get countryPoliceDisruptCorruption => 'Corruption';

  @override
  String get countryPoliceDisruptCorruptionDesc =>
      'Grease palms to ease pressure.';

  @override
  String get countryPoliceDisruptDistract => 'Distract';

  @override
  String get countryPoliceDisruptDistractDesc =>
      'Create a diversion across the city.';

  @override
  String get countryPoliceDisruptRaid => 'Counter-raid';

  @override
  String get countryPoliceDisruptRaidDesc =>
      'Hit a depot to scramble their response.';

  @override
  String countryPoliceDisruptCost(String cost) {
    return 'Cost €$cost';
  }

  @override
  String countryPoliceDisruptDropHint(int drop, int minutes) {
    return 'Pressure −$drop · Cool ~${minutes}m';
  }

  @override
  String countryPoliceDisruptFailHint(int wanted, int fbi) {
    return 'Fail: +$wanted Wanted, +$fbi FBI';
  }

  @override
  String get countryPoliceDisruptSuccess =>
      'Pressure dropped. The streets cool down for a while.';

  @override
  String get countryPoliceDisruptFailed => 'The op failed. Heat went up.';

  @override
  String get countryPoliceCoolActive => 'Cooling active';

  @override
  String get countryPoliceDisabled =>
      'Country police pressure is currently off.';

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
    return 'Maximum bet is €$amount';
  }

  @override
  String get casinoFloorPublic => 'Public';

  @override
  String get casinoFloorVip => 'VIP';

  @override
  String get casinoFloorPrivate => 'Private';

  @override
  String casinoHouseRulesLine(String floor, String maxBet, String rake) {
    return '$floor · max bet €$maxBet · rake $rake%';
  }

  @override
  String get casinoUpgradeFloor => 'Upgrade floor';

  @override
  String casinoUpgradeFloorTo(String floor, String cost) {
    return 'Upgrade to $floor (€$cost)';
  }

  @override
  String get casinoUpgradeSuccess => 'Floor upgraded';

  @override
  String get casinoUpgradeFailed => 'Upgrade failed';

  @override
  String get casinoStaffTitle => 'Staff';

  @override
  String get casinoStaffHire => 'Hire';

  @override
  String get casinoStaffFire => 'Fire';

  @override
  String get casinoStaffDealer => 'Dealer';

  @override
  String get casinoStaffSecurity => 'Security';

  @override
  String get casinoStaffPromoter => 'Promoter';

  @override
  String casinoStaffSalaryPerTick(String amount) {
    return 'Salary €$amount/tick';
  }

  @override
  String get casinoStaffHireSuccess => 'Staff hired';

  @override
  String get casinoStaffFireSuccess => 'Staff fired';

  @override
  String get casinoStaffHireFailed => 'Hire failed';

  @override
  String get casinoStaffFireFailed => 'Fire failed';

  @override
  String get casinoTotalRake => 'Total rake:';

  @override
  String casinoLastRaid(String when) {
    return 'Last raid: $when';
  }

  @override
  String casinoRaidDrain(String percent) {
    return 'Raid drain $percent%';
  }

  @override
  String casinoRaidDefense(String percent) {
    return 'Raid defense $percent%';
  }

  @override
  String get casinoNoStaffHired => 'No staff hired yet';
}
