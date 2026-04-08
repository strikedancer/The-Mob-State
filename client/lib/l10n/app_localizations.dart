import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Mafia Game'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'USERNAME'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernamePlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get registerButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get invalidCredentials;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailPlaceholder;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'SEND RESET LINK'**
  String get resetPasswordButton;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent! Check your email.'**
  String get emailSent;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}!'**
  String welcome(String username);

  /// No description provided for @dashboardTimeouts.
  ///
  /// In en, this message translates to:
  /// **'Timeouts'**
  String get dashboardTimeouts;

  /// No description provided for @dashboardTimeoutCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get dashboardTimeoutCrime;

  /// No description provided for @dashboardTimeoutJob.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get dashboardTimeoutJob;

  /// No description provided for @dashboardTimeoutTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get dashboardTimeoutTravel;

  /// No description provided for @dashboardTimeoutVehicleTheft.
  ///
  /// In en, this message translates to:
  /// **'Steal car'**
  String get dashboardTimeoutVehicleTheft;

  /// No description provided for @dashboardTimeoutBoatTheft.
  ///
  /// In en, this message translates to:
  /// **'Steal boat'**
  String get dashboardTimeoutBoatTheft;

  /// No description provided for @dashboardTimeoutNightclubSeason.
  ///
  /// In en, this message translates to:
  /// **'Nightclub season'**
  String get dashboardTimeoutNightclubSeason;

  /// No description provided for @dashboardTimeoutAmmo.
  ///
  /// In en, this message translates to:
  /// **'Buy bullets'**
  String get dashboardTimeoutAmmo;

  /// No description provided for @dashboardTimeoutShootingRange.
  ///
  /// In en, this message translates to:
  /// **'Shooting range'**
  String get dashboardTimeoutShootingRange;

  /// No description provided for @dashboardTimeoutGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get dashboardTimeoutGym;

  /// No description provided for @dashboardInfoDrugsGrams.
  ///
  /// In en, this message translates to:
  /// **'Drugs (grams)'**
  String get dashboardInfoDrugsGrams;

  /// No description provided for @dashboardInfoNightclubs.
  ///
  /// In en, this message translates to:
  /// **'Nightclubs'**
  String get dashboardInfoNightclubs;

  /// No description provided for @dashboardInfoNightclubRevenue.
  ///
  /// In en, this message translates to:
  /// **'Nightclub revenue'**
  String get dashboardInfoNightclubRevenue;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @crimes.
  ///
  /// In en, this message translates to:
  /// **'Crimes'**
  String get crimes;

  /// No description provided for @errorLoadingCrimes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load crimes'**
  String get errorLoadingCrimes;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionError(String error);

  /// No description provided for @payRange.
  ///
  /// In en, this message translates to:
  /// **'Pay: €{min} - €{max}'**
  String payRange(String min, String max);

  /// No description provided for @requiresRank.
  ///
  /// In en, this message translates to:
  /// **'Requires Rank {rank}'**
  String requiresRank(String rank);

  /// No description provided for @requiresVehicle.
  ///
  /// In en, this message translates to:
  /// **'Requires Vehicle'**
  String get requiresVehicle;

  /// No description provided for @federalCrimeWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Federal Crime - FBI Heat'**
  String get federalCrimeWarning;

  /// No description provided for @crimePickpocketName.
  ///
  /// In en, this message translates to:
  /// **'Pickpocketing'**
  String get crimePickpocketName;

  /// No description provided for @crimePickpocketDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal wallets from passersby'**
  String get crimePickpocketDesc;

  /// No description provided for @crimeShopliftName.
  ///
  /// In en, this message translates to:
  /// **'Shoplifting'**
  String get crimeShopliftName;

  /// No description provided for @crimeShopliftDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal goods from a store'**
  String get crimeShopliftDesc;

  /// No description provided for @crimeStealBikeName.
  ///
  /// In en, this message translates to:
  /// **'Steal Bike'**
  String get crimeStealBikeName;

  /// No description provided for @crimeStealBikeDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal a bike from a rack'**
  String get crimeStealBikeDesc;

  /// No description provided for @crimeCarTheftName.
  ///
  /// In en, this message translates to:
  /// **'Car Theft'**
  String get crimeCarTheftName;

  /// No description provided for @crimeCarTheftDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal a parked car'**
  String get crimeCarTheftDesc;

  /// No description provided for @crimeBurglaryName.
  ///
  /// In en, this message translates to:
  /// **'Burglary'**
  String get crimeBurglaryName;

  /// No description provided for @crimeBurglaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Break into a house'**
  String get crimeBurglaryDesc;

  /// No description provided for @crimeRobStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store Robbery'**
  String get crimeRobStoreName;

  /// No description provided for @crimeRobStoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Rob a small store'**
  String get crimeRobStoreDesc;

  /// No description provided for @crimeMugPersonName.
  ///
  /// In en, this message translates to:
  /// **'Mugging'**
  String get crimeMugPersonName;

  /// No description provided for @crimeMugPersonDesc.
  ///
  /// In en, this message translates to:
  /// **'Mug someone on the street'**
  String get crimeMugPersonDesc;

  /// No description provided for @crimeStealCarPartsName.
  ///
  /// In en, this message translates to:
  /// **'Steal Car Parts'**
  String get crimeStealCarPartsName;

  /// No description provided for @crimeStealCarPartsDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal parts from parked cars'**
  String get crimeStealCarPartsDesc;

  /// No description provided for @crimeHijackTruckName.
  ///
  /// In en, this message translates to:
  /// **'Hijack Truck'**
  String get crimeHijackTruckName;

  /// No description provided for @crimeHijackTruckDesc.
  ///
  /// In en, this message translates to:
  /// **'Hijack a truck carrying goods'**
  String get crimeHijackTruckDesc;

  /// No description provided for @crimeAtmTheftName.
  ///
  /// In en, this message translates to:
  /// **'ATM Theft'**
  String get crimeAtmTheftName;

  /// No description provided for @crimeAtmTheftDesc.
  ///
  /// In en, this message translates to:
  /// **'Break into an ATM'**
  String get crimeAtmTheftDesc;

  /// No description provided for @crimeJewelryHeistName.
  ///
  /// In en, this message translates to:
  /// **'Jewelry Heist'**
  String get crimeJewelryHeistName;

  /// No description provided for @crimeJewelryHeistDesc.
  ///
  /// In en, this message translates to:
  /// **'Rob a jeweler'**
  String get crimeJewelryHeistDesc;

  /// No description provided for @crimeVandalismName.
  ///
  /// In en, this message translates to:
  /// **'Vandalism'**
  String get crimeVandalismName;

  /// No description provided for @crimeVandalismDesc.
  ///
  /// In en, this message translates to:
  /// **'Damage property for money'**
  String get crimeVandalismDesc;

  /// No description provided for @crimeGraffitiName.
  ///
  /// In en, this message translates to:
  /// **'Graffiti'**
  String get crimeGraffitiName;

  /// No description provided for @crimeGraffitiDesc.
  ///
  /// In en, this message translates to:
  /// **'Spray graffiti for local gangs'**
  String get crimeGraffitiDesc;

  /// No description provided for @crimeDrugDealSmallName.
  ///
  /// In en, this message translates to:
  /// **'Small Drug Deal'**
  String get crimeDrugDealSmallName;

  /// No description provided for @crimeDrugDealSmallDesc.
  ///
  /// In en, this message translates to:
  /// **'Sell a small amount of drugs'**
  String get crimeDrugDealSmallDesc;

  /// No description provided for @crimeDrugDealLargeName.
  ///
  /// In en, this message translates to:
  /// **'Large Drug Deal'**
  String get crimeDrugDealLargeName;

  /// No description provided for @crimeDrugDealLargeDesc.
  ///
  /// In en, this message translates to:
  /// **'Sell a large amount of drugs'**
  String get crimeDrugDealLargeDesc;

  /// No description provided for @crimeExtortionName.
  ///
  /// In en, this message translates to:
  /// **'Extortion'**
  String get crimeExtortionName;

  /// No description provided for @crimeExtortionDesc.
  ///
  /// In en, this message translates to:
  /// **'Extort money from local businesses'**
  String get crimeExtortionDesc;

  /// No description provided for @crimeKidnappingName.
  ///
  /// In en, this message translates to:
  /// **'Kidnapping'**
  String get crimeKidnappingName;

  /// No description provided for @crimeKidnappingDesc.
  ///
  /// In en, this message translates to:
  /// **'Kidnap someone for ransom'**
  String get crimeKidnappingDesc;

  /// No description provided for @crimeArsonName.
  ///
  /// In en, this message translates to:
  /// **'Arson'**
  String get crimeArsonName;

  /// No description provided for @crimeArsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a building on fire'**
  String get crimeArsonDesc;

  /// No description provided for @crimeSmugglingName.
  ///
  /// In en, this message translates to:
  /// **'Smuggling'**
  String get crimeSmugglingName;

  /// No description provided for @crimeSmugglingDesc.
  ///
  /// In en, this message translates to:
  /// **'Smuggle goods across the border'**
  String get crimeSmugglingDesc;

  /// No description provided for @crimeAssassinationName.
  ///
  /// In en, this message translates to:
  /// **'Assassination'**
  String get crimeAssassinationName;

  /// No description provided for @crimeAssassinationDesc.
  ///
  /// In en, this message translates to:
  /// **'Carry out a contract killing'**
  String get crimeAssassinationDesc;

  /// No description provided for @crimeHackAccountName.
  ///
  /// In en, this message translates to:
  /// **'Hack Account'**
  String get crimeHackAccountName;

  /// No description provided for @crimeHackAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Hack a bank account'**
  String get crimeHackAccountDesc;

  /// No description provided for @crimeCounterfeitMoneyName.
  ///
  /// In en, this message translates to:
  /// **'Counterfeit Money'**
  String get crimeCounterfeitMoneyName;

  /// No description provided for @crimeCounterfeitMoneyDesc.
  ///
  /// In en, this message translates to:
  /// **'Make fake money'**
  String get crimeCounterfeitMoneyDesc;

  /// No description provided for @crimeIdentityTheftName.
  ///
  /// In en, this message translates to:
  /// **'Identity Theft'**
  String get crimeIdentityTheftName;

  /// No description provided for @crimeIdentityTheftDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal someone\'s identity for fraud'**
  String get crimeIdentityTheftDesc;

  /// No description provided for @crimeRobArmoredTruckName.
  ///
  /// In en, this message translates to:
  /// **'Armored Truck Heist'**
  String get crimeRobArmoredTruckName;

  /// No description provided for @crimeRobArmoredTruckDesc.
  ///
  /// In en, this message translates to:
  /// **'Rob an armored truck'**
  String get crimeRobArmoredTruckDesc;

  /// No description provided for @crimeArtTheftName.
  ///
  /// In en, this message translates to:
  /// **'Art Theft'**
  String get crimeArtTheftName;

  /// No description provided for @crimeArtTheftDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal valuable artwork'**
  String get crimeArtTheftDesc;

  /// No description provided for @crimeProtectionRacketName.
  ///
  /// In en, this message translates to:
  /// **'Protection Racket'**
  String get crimeProtectionRacketName;

  /// No description provided for @crimeProtectionRacketDesc.
  ///
  /// In en, this message translates to:
  /// **'Make businesses pay protection money'**
  String get crimeProtectionRacketDesc;

  /// No description provided for @crimeCasinoHeistName.
  ///
  /// In en, this message translates to:
  /// **'Casino Heist'**
  String get crimeCasinoHeistName;

  /// No description provided for @crimeCasinoHeistDesc.
  ///
  /// In en, this message translates to:
  /// **'Rob a casino'**
  String get crimeCasinoHeistDesc;

  /// No description provided for @crimeBankRobberyName.
  ///
  /// In en, this message translates to:
  /// **'Bank Robbery'**
  String get crimeBankRobberyName;

  /// No description provided for @crimeBankRobberyDesc.
  ///
  /// In en, this message translates to:
  /// **'Rob a bank'**
  String get crimeBankRobberyDesc;

  /// No description provided for @crimeStealYachtName.
  ///
  /// In en, this message translates to:
  /// **'Steal Yacht'**
  String get crimeStealYachtName;

  /// No description provided for @crimeStealYachtDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal a luxury yacht'**
  String get crimeStealYachtDesc;

  /// No description provided for @crimeCorruptOfficialName.
  ///
  /// In en, this message translates to:
  /// **'Bribe Official'**
  String get crimeCorruptOfficialName;

  /// No description provided for @crimeCorruptOfficialDesc.
  ///
  /// In en, this message translates to:
  /// **'Bribe an official for favors'**
  String get crimeCorruptOfficialDesc;

  /// No description provided for @tooltipCrimeRequiresTools.
  ///
  /// In en, this message translates to:
  /// **'Tools Required'**
  String get tooltipCrimeRequiresTools;

  /// No description provided for @tooltipCrimeRequiresVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Required'**
  String get tooltipCrimeRequiresVehicle;

  /// No description provided for @tooltipCrimeRequiresDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs required'**
  String get tooltipCrimeRequiresDrugs;

  /// No description provided for @tooltipCrimeHighValue.
  ///
  /// In en, this message translates to:
  /// **'High Value Operation'**
  String get tooltipCrimeHighValue;

  /// No description provided for @tooltipCrimeRequiresViolence.
  ///
  /// In en, this message translates to:
  /// **'Violence Required'**
  String get tooltipCrimeRequiresViolence;

  /// No description provided for @crimeErrorDrugsRequired.
  ///
  /// In en, this message translates to:
  /// **'You need at least {quantity}x of: {drugs}'**
  String crimeErrorDrugsRequired(String quantity, String drugs);

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @errorLoadingJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed to load jobs'**
  String get errorLoadingJobs;

  /// No description provided for @jobNewspaperDeliveryName.
  ///
  /// In en, this message translates to:
  /// **'Newspaper Delivery'**
  String get jobNewspaperDeliveryName;

  /// No description provided for @jobNewspaperDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Deliver newspapers early in the morning'**
  String get jobNewspaperDeliveryDesc;

  /// No description provided for @jobCarWashName.
  ///
  /// In en, this message translates to:
  /// **'Car Wash'**
  String get jobCarWashName;

  /// No description provided for @jobCarWashDesc.
  ///
  /// In en, this message translates to:
  /// **'Wash cars at the car wash'**
  String get jobCarWashDesc;

  /// No description provided for @jobGroceryBaggerName.
  ///
  /// In en, this message translates to:
  /// **'Grocery Bagger'**
  String get jobGroceryBaggerName;

  /// No description provided for @jobGroceryBaggerDesc.
  ///
  /// In en, this message translates to:
  /// **'Stock shelves at the supermarket'**
  String get jobGroceryBaggerDesc;

  /// No description provided for @jobDishwasherName.
  ///
  /// In en, this message translates to:
  /// **'Dishwasher'**
  String get jobDishwasherName;

  /// No description provided for @jobDishwasherDesc.
  ///
  /// In en, this message translates to:
  /// **'Wash dishes in a restaurant'**
  String get jobDishwasherDesc;

  /// No description provided for @jobStreetSweeperName.
  ///
  /// In en, this message translates to:
  /// **'Street Sweeper'**
  String get jobStreetSweeperName;

  /// No description provided for @jobStreetSweeperDesc.
  ///
  /// In en, this message translates to:
  /// **'Sweep streets clean'**
  String get jobStreetSweeperDesc;

  /// No description provided for @jobPizzaDeliveryName.
  ///
  /// In en, this message translates to:
  /// **'Pizza Delivery'**
  String get jobPizzaDeliveryName;

  /// No description provided for @jobPizzaDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Deliver pizzas in the city'**
  String get jobPizzaDeliveryDesc;

  /// No description provided for @jobTaxiDriverName.
  ///
  /// In en, this message translates to:
  /// **'Taxi Driver'**
  String get jobTaxiDriverName;

  /// No description provided for @jobTaxiDriverDesc.
  ///
  /// In en, this message translates to:
  /// **'Drive a taxi around the city'**
  String get jobTaxiDriverDesc;

  /// No description provided for @jobWarehouseWorkerName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Worker'**
  String get jobWarehouseWorkerName;

  /// No description provided for @jobWarehouseWorkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Work in a warehouse'**
  String get jobWarehouseWorkerDesc;

  /// No description provided for @jobConstructionWorkerName.
  ///
  /// In en, this message translates to:
  /// **'Construction Worker'**
  String get jobConstructionWorkerName;

  /// No description provided for @jobConstructionWorkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Work on a construction site'**
  String get jobConstructionWorkerDesc;

  /// No description provided for @jobBartenderName.
  ///
  /// In en, this message translates to:
  /// **'Bartender'**
  String get jobBartenderName;

  /// No description provided for @jobBartenderDesc.
  ///
  /// In en, this message translates to:
  /// **'Pour beer and mix cocktails'**
  String get jobBartenderDesc;

  /// No description provided for @jobSecurityGuardName.
  ///
  /// In en, this message translates to:
  /// **'Security Guard'**
  String get jobSecurityGuardName;

  /// No description provided for @jobSecurityGuardDesc.
  ///
  /// In en, this message translates to:
  /// **'Guard a building'**
  String get jobSecurityGuardDesc;

  /// No description provided for @jobTruckDriverName.
  ///
  /// In en, this message translates to:
  /// **'Truck Driver'**
  String get jobTruckDriverName;

  /// No description provided for @jobTruckDriverDesc.
  ///
  /// In en, this message translates to:
  /// **'Drive a truck over long distances'**
  String get jobTruckDriverDesc;

  /// No description provided for @jobMechanicName.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get jobMechanicName;

  /// No description provided for @jobMechanicDesc.
  ///
  /// In en, this message translates to:
  /// **'Repair cars in a garage'**
  String get jobMechanicDesc;

  /// No description provided for @jobElectricianName.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get jobElectricianName;

  /// No description provided for @jobElectricianDesc.
  ///
  /// In en, this message translates to:
  /// **'Install and repair electrical systems'**
  String get jobElectricianDesc;

  /// No description provided for @jobPlumberName.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get jobPlumberName;

  /// No description provided for @jobPlumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Repair pipes and plumbing'**
  String get jobPlumberDesc;

  /// No description provided for @jobChefName.
  ///
  /// In en, this message translates to:
  /// **'Chef'**
  String get jobChefName;

  /// No description provided for @jobChefDesc.
  ///
  /// In en, this message translates to:
  /// **'Cook in a restaurant'**
  String get jobChefDesc;

  /// No description provided for @jobParamedicName.
  ///
  /// In en, this message translates to:
  /// **'Paramedic'**
  String get jobParamedicName;

  /// No description provided for @jobParamedicDesc.
  ///
  /// In en, this message translates to:
  /// **'Help people in need'**
  String get jobParamedicDesc;

  /// No description provided for @jobProgrammerName.
  ///
  /// In en, this message translates to:
  /// **'Programmer'**
  String get jobProgrammerName;

  /// No description provided for @jobProgrammerDesc.
  ///
  /// In en, this message translates to:
  /// **'Write software for companies'**
  String get jobProgrammerDesc;

  /// No description provided for @jobAccountantName.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get jobAccountantName;

  /// No description provided for @jobAccountantDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage finances for businesses'**
  String get jobAccountantDesc;

  /// No description provided for @jobLawyerName.
  ///
  /// In en, this message translates to:
  /// **'Lawyer'**
  String get jobLawyerName;

  /// No description provided for @jobLawyerDesc.
  ///
  /// In en, this message translates to:
  /// **'Defend clients in court'**
  String get jobLawyerDesc;

  /// No description provided for @jobRealEstateAgentName.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Agent'**
  String get jobRealEstateAgentName;

  /// No description provided for @jobRealEstateAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Sell houses and buildings'**
  String get jobRealEstateAgentDesc;

  /// No description provided for @jobStockbrokerName.
  ///
  /// In en, this message translates to:
  /// **'Stockbroker'**
  String get jobStockbrokerName;

  /// No description provided for @jobStockbrokerDesc.
  ///
  /// In en, this message translates to:
  /// **'Trade stocks'**
  String get jobStockbrokerDesc;

  /// No description provided for @jobDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get jobDoctorName;

  /// No description provided for @jobDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'Treat patients at the hospital'**
  String get jobDoctorDesc;

  /// No description provided for @jobAirlinePilotName.
  ///
  /// In en, this message translates to:
  /// **'Pilot'**
  String get jobAirlinePilotName;

  /// No description provided for @jobAirlinePilotDesc.
  ///
  /// In en, this message translates to:
  /// **'Fly passenger airplanes'**
  String get jobAirlinePilotDesc;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @errorLoadingCountries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load countries'**
  String get errorLoadingCountries;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @travelTo.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travelTo;

  /// No description provided for @travelCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: €{amount}'**
  String travelCost(String amount);

  /// No description provided for @travelJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start journey?'**
  String get travelJourneyTitle;

  /// No description provided for @travelRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'Route:'**
  String get travelRouteLabel;

  /// No description provided for @travelLegsLabel.
  ///
  /// In en, this message translates to:
  /// **'Legs: {count}'**
  String travelLegsLabel(String count);

  /// No description provided for @travelCostPerLeg.
  ///
  /// In en, this message translates to:
  /// **'Cost per leg: €{amount}'**
  String travelCostPerLeg(String amount);

  /// No description provided for @travelTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost: €{amount}'**
  String travelTotalCost(String amount);

  /// No description provided for @travelCooldownPerLeg.
  ///
  /// In en, this message translates to:
  /// **'Cooldown: {minutes} min per leg'**
  String travelCooldownPerLeg(String minutes);

  /// No description provided for @travelRiskPerLeg.
  ///
  /// In en, this message translates to:
  /// **'Risk: per leg (can be jailed and lose all goods)'**
  String get travelRiskPerLeg;

  /// No description provided for @travelStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get travelStart;

  /// No description provided for @travelInTransitTo.
  ///
  /// In en, this message translates to:
  /// **'In transit to {country}'**
  String travelInTransitTo(String country);

  /// No description provided for @travelLegProgress.
  ///
  /// In en, this message translates to:
  /// **'Leg {current}/{total}'**
  String travelLegProgress(String current, String total);

  /// No description provided for @travelNextStop.
  ///
  /// In en, this message translates to:
  /// **'Next stop: {country}'**
  String travelNextStop(String country);

  /// No description provided for @travelContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get travelContinue;

  /// No description provided for @travelCancelJourney.
  ///
  /// In en, this message translates to:
  /// **'Cancel journey'**
  String get travelCancelJourney;

  /// No description provided for @travelJourneyCanceled.
  ///
  /// In en, this message translates to:
  /// **'Journey canceled'**
  String get travelJourneyCanceled;

  /// No description provided for @travelDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get travelDirect;

  /// No description provided for @travelVia.
  ///
  /// In en, this message translates to:
  /// **'via {countries}'**
  String travelVia(String countries);

  /// No description provided for @travelLegsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} legs'**
  String travelLegsCount(String count);

  /// No description provided for @jailRemainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'You are in jail for {minutes} more minutes'**
  String jailRemainingMinutes(String minutes);

  /// No description provided for @travelSuccessTo.
  ///
  /// In en, this message translates to:
  /// **'Traveled to {country}!'**
  String travelSuccessTo(String country);

  /// No description provided for @travelConfiscated.
  ///
  /// In en, this message translates to:
  /// **'🚨 {quantity} items {item} confiscated!'**
  String travelConfiscated(String quantity, String item);

  /// No description provided for @travelDamaged.
  ///
  /// In en, this message translates to:
  /// **'⚠️ {item} damaged ({percent}% value loss)!'**
  String travelDamaged(String item, String percent);

  /// No description provided for @countryNetherlands.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNetherlands;

  /// No description provided for @countryBelgium.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get countryBelgium;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @countryItaly.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// No description provided for @countryUk.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUk;

  /// No description provided for @countrySwitzerland.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get countrySwitzerland;

  /// No description provided for @crew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crew;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @money.
  ///
  /// In en, this message translates to:
  /// **'€{amount}'**
  String money(String amount);

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @avatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated!'**
  String get avatarUpdated;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / Taal'**
  String get changeLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChanged;

  /// No description provided for @languageChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Language change failed ({code})'**
  String languageChangeFailed(String code);

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language / Taal Kiezen'**
  String get chooseLanguage;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get dutch;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change Username'**
  String get changeUsername;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'3-20 characters'**
  String get usernameHint;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @minChars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 characters'**
  String get minChars;

  /// No description provided for @usernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Username updated!'**
  String get usernameUpdated;

  /// No description provided for @usernameTaken.
  ///
  /// In en, this message translates to:
  /// **'Username already taken'**
  String get usernameTaken;

  /// No description provided for @oncePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Change once per month'**
  String get oncePerMonth;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @allowMessages.
  ///
  /// In en, this message translates to:
  /// **'Allow Messages'**
  String get allowMessages;

  /// No description provided for @allowMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Other players can send you messages'**
  String get allowMessagesDesc;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @vipStatus.
  ///
  /// In en, this message translates to:
  /// **'VIP Status'**
  String get vipStatus;

  /// No description provided for @activeUntil.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String activeUntil(String date);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose an Avatar'**
  String get chooseAvatar;

  /// No description provided for @freeAvatars.
  ///
  /// In en, this message translates to:
  /// **'Free Avatars'**
  String get freeAvatars;

  /// No description provided for @vipAvatars.
  ///
  /// In en, this message translates to:
  /// **'VIP Avatars'**
  String get vipAvatars;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vip;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @foodAndDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get foodAndDrink;

  /// No description provided for @invalidItem.
  ///
  /// In en, this message translates to:
  /// **'This item does not exist'**
  String get invalidItem;

  /// No description provided for @foodBroodje.
  ///
  /// In en, this message translates to:
  /// **'Sandwich'**
  String get foodBroodje;

  /// No description provided for @foodPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get foodPizza;

  /// No description provided for @foodBurger.
  ///
  /// In en, this message translates to:
  /// **'Burger'**
  String get foodBurger;

  /// No description provided for @foodSteak.
  ///
  /// In en, this message translates to:
  /// **'Steak'**
  String get foodSteak;

  /// No description provided for @drinkWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get drinkWater;

  /// No description provided for @drinkSoda.
  ///
  /// In en, this message translates to:
  /// **'Soda'**
  String get drinkSoda;

  /// No description provided for @drinkCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get drinkCoffee;

  /// No description provided for @drinkBeer.
  ///
  /// In en, this message translates to:
  /// **'Beer'**
  String get drinkBeer;

  /// No description provided for @foodInfo3.
  ///
  /// In en, this message translates to:
  /// **'• Buy food and drink to keep your stats up'**
  String get foodInfo3;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @friendActivity.
  ///
  /// In en, this message translates to:
  /// **'Friend Activity'**
  String get friendActivity;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @propertiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get propertiesAvailable;

  /// No description provided for @myProperties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get myProperties;

  /// No description provided for @errorLoadingMyProperties.
  ///
  /// In en, this message translates to:
  /// **'Error loading my properties'**
  String get errorLoadingMyProperties;

  /// No description provided for @errorBuyingProperty.
  ///
  /// In en, this message translates to:
  /// **'Error buying property'**
  String get errorBuyingProperty;

  /// No description provided for @errorCollectingIncome.
  ///
  /// In en, this message translates to:
  /// **'Error collecting income'**
  String get errorCollectingIncome;

  /// No description provided for @noAvailableProperties.
  ///
  /// In en, this message translates to:
  /// **'No available properties'**
  String get noAvailableProperties;

  /// No description provided for @noOwnedProperties.
  ///
  /// In en, this message translates to:
  /// **'You don\'t own any properties yet'**
  String get noOwnedProperties;

  /// No description provided for @buyFirstPropertyHint.
  ///
  /// In en, this message translates to:
  /// **'Buy your first property in the \"Available\" tab'**
  String get buyFirstPropertyHint;

  /// No description provided for @buyPropertyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to buy {name} for €{price}?'**
  String buyPropertyConfirm(String name, String price);

  /// No description provided for @propertyPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get propertyPrice;

  /// No description provided for @propertyMinLevel.
  ///
  /// In en, this message translates to:
  /// **'Required level'**
  String get propertyMinLevel;

  /// No description provided for @propertyIncomePerHour.
  ///
  /// In en, this message translates to:
  /// **'Income/hour'**
  String get propertyIncomePerHour;

  /// No description provided for @propertyMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Max Level'**
  String get propertyMaxLevel;

  /// No description provided for @propertyUniquePerCountry.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Unique - 1 per country'**
  String get propertyUniquePerCountry;

  /// No description provided for @propertyIncomeReady.
  ///
  /// In en, this message translates to:
  /// **'✅ Income ready to collect!'**
  String get propertyIncomeReady;

  /// No description provided for @propertyNextIncome.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Next income in {duration}'**
  String propertyNextIncome(String duration);

  /// No description provided for @propertyBuyAction.
  ///
  /// In en, this message translates to:
  /// **'Buy Property'**
  String get propertyBuyAction;

  /// No description provided for @propertyCollectAction.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get propertyCollectAction;

  /// No description provided for @propertyUpgradeAction.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get propertyUpgradeAction;

  /// No description provided for @propertyMax.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get propertyMax;

  /// No description provided for @propertyLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String propertyLevel(String level);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(String hours, String minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String durationMinutes(String minutes);

  /// No description provided for @propertyTypeHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get propertyTypeHouse;

  /// No description provided for @propertyTypeWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get propertyTypeWarehouse;

  /// No description provided for @propertyTypeCasino.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get propertyTypeCasino;

  /// No description provided for @propertyTypeHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get propertyTypeHotel;

  /// No description provided for @propertyTypeFactory.
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get propertyTypeFactory;

  /// No description provided for @propertyTypeBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get propertyTypeBusiness;

  /// No description provided for @propertyCasinoName.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get propertyCasinoName;

  /// No description provided for @propertyWarehouseName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get propertyWarehouseName;

  /// No description provided for @propertyNightclubName.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get propertyNightclubName;

  /// No description provided for @propertyHouseName.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get propertyHouseName;

  /// No description provided for @propertyApartmentName.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get propertyApartmentName;

  /// No description provided for @propertyShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get propertyShopName;

  /// No description provided for @blackMarket.
  ///
  /// In en, this message translates to:
  /// **'Black Market'**
  String get blackMarket;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @garageCapacity.
  ///
  /// In en, this message translates to:
  /// **'Garage Capacity'**
  String get garageCapacity;

  /// No description provided for @garageVehiclesCount.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} vehicles'**
  String garageVehiclesCount(String current, String total);

  /// No description provided for @garageUpgradeWithCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade (€{cost})'**
  String garageUpgradeWithCost(String cost);

  /// No description provided for @garageMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Max Level'**
  String get garageMaxLevel;

  /// No description provided for @garageLevelRemaining.
  ///
  /// In en, this message translates to:
  /// **'Level {level} | {spots} spots left'**
  String garageLevelRemaining(String level, String spots);

  /// No description provided for @noCarsInGarage.
  ///
  /// In en, this message translates to:
  /// **'No cars in your garage'**
  String get noCarsInGarage;

  /// No description provided for @stealCarsToStart.
  ///
  /// In en, this message translates to:
  /// **'Steal some cars to get started!'**
  String get stealCarsToStart;

  /// No description provided for @stealFailed.
  ///
  /// In en, this message translates to:
  /// **'Steal failed'**
  String get stealFailed;

  /// No description provided for @garageUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upgrade garage'**
  String get garageUpgradeFailed;

  /// No description provided for @saleFailed.
  ///
  /// In en, this message translates to:
  /// **'Sale failed'**
  String get saleFailed;

  /// No description provided for @vehicleTransported.
  ///
  /// In en, this message translates to:
  /// **'Vehicle transported successfully!'**
  String get vehicleTransported;

  /// No description provided for @vehicleTransportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to transport vehicle'**
  String get vehicleTransportFailed;

  /// No description provided for @listOnMarket.
  ///
  /// In en, this message translates to:
  /// **'List on Market'**
  String get listOnMarket;

  /// No description provided for @marketValue.
  ///
  /// In en, this message translates to:
  /// **'Market Value: €{amount}'**
  String marketValue(String amount);

  /// No description provided for @askingPrice.
  ///
  /// In en, this message translates to:
  /// **'Asking Price (€)'**
  String get askingPrice;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// No description provided for @vehicleListed.
  ///
  /// In en, this message translates to:
  /// **'Vehicle listed on market!'**
  String get vehicleListed;

  /// No description provided for @listVehicleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to list vehicle'**
  String get listVehicleFailed;

  /// No description provided for @marina.
  ///
  /// In en, this message translates to:
  /// **'Marina'**
  String get marina;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @court.
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get court;

  /// No description provided for @casino.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get casino;

  /// No description provided for @errorLoadingCasinoStatus.
  ///
  /// In en, this message translates to:
  /// **'Could not check casino status'**
  String get errorLoadingCasinoStatus;

  /// No description provided for @errorLoadingCasinoGames.
  ///
  /// In en, this message translates to:
  /// **'Could not load casino games'**
  String get errorLoadingCasinoGames;

  /// No description provided for @casinoPrice.
  ///
  /// In en, this message translates to:
  /// **'Price: €{amount}'**
  String casinoPrice(String amount);

  /// No description provided for @startingCapital.
  ///
  /// In en, this message translates to:
  /// **'Starting capital'**
  String get startingCapital;

  /// No description provided for @bankrollHelper.
  ///
  /// In en, this message translates to:
  /// **'This will be the casino bankroll'**
  String get bankrollHelper;

  /// No description provided for @casinoOwnershipInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About casino ownership:'**
  String get casinoOwnershipInfoTitle;

  /// No description provided for @casinoClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'CASINO CLOSED'**
  String get casinoClosedTitle;

  /// No description provided for @casinoOwnedByLabel.
  ///
  /// In en, this message translates to:
  /// **'This casino is owned by:'**
  String get casinoOwnedByLabel;

  /// No description provided for @casinoNoOwner.
  ///
  /// In en, this message translates to:
  /// **'This casino has no owner yet'**
  String get casinoNoOwner;

  /// No description provided for @casinoPurchasePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase price:'**
  String get casinoPurchasePriceLabel;

  /// No description provided for @casinoOwnerInfo.
  ///
  /// In en, this message translates to:
  /// **'As owner you manage the casino bankroll and earn money when players lose!'**
  String get casinoOwnerInfo;

  /// No description provided for @casinoGameSlotsName.
  ///
  /// In en, this message translates to:
  /// **'Slot Machine'**
  String get casinoGameSlotsName;

  /// No description provided for @casinoGameSlotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Spin the reels and win up to 100x your bet!'**
  String get casinoGameSlotsDesc;

  /// No description provided for @casinoGameBlackjackName.
  ///
  /// In en, this message translates to:
  /// **'Blackjack'**
  String get casinoGameBlackjackName;

  /// No description provided for @casinoGameBlackjackDesc.
  ///
  /// In en, this message translates to:
  /// **'Beat the dealer and win up to 2x your bet!'**
  String get casinoGameBlackjackDesc;

  /// No description provided for @casinoGameRouletteName.
  ///
  /// In en, this message translates to:
  /// **'Roulette'**
  String get casinoGameRouletteName;

  /// No description provided for @casinoGameRouletteDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick your number and win up to 35x your bet!'**
  String get casinoGameRouletteDesc;

  /// No description provided for @casinoGameDiceName.
  ///
  /// In en, this message translates to:
  /// **'Dice'**
  String get casinoGameDiceName;

  /// No description provided for @casinoGameDiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Roll the dice and win up to 6x your bet!'**
  String get casinoGameDiceDesc;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'EASY'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'HARD'**
  String get difficultyHard;

  /// No description provided for @casinoDepositTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit Money'**
  String get casinoDepositTitle;

  /// No description provided for @casinoWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Money'**
  String get casinoWithdrawTitle;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @casinoDepositSuccess.
  ///
  /// In en, this message translates to:
  /// **'€{amount} deposited into casino bankroll'**
  String casinoDepositSuccess(String amount);

  /// No description provided for @casinoWithdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'€{amount} withdrawn from casino bankroll'**
  String casinoWithdrawSuccess(String amount);

  /// No description provided for @casinoDepositError.
  ///
  /// In en, this message translates to:
  /// **'Error depositing'**
  String get casinoDepositError;

  /// No description provided for @casinoWithdrawError.
  ///
  /// In en, this message translates to:
  /// **'Error withdrawing'**
  String get casinoWithdrawError;

  /// No description provided for @casinoMinBankroll.
  ///
  /// In en, this message translates to:
  /// **'At least €10,000 must remain in the bankroll'**
  String get casinoMinBankroll;

  /// No description provided for @casinoMaxWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Maximum: €{amount}'**
  String casinoMaxWithdraw(String amount);

  /// No description provided for @casinoManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Casino Management'**
  String get casinoManagementTitle;

  /// No description provided for @casinoBankruptWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: Casino bankroll too low!\nDeposit at least €{amount} to avoid bankruptcy.'**
  String casinoBankruptWarning(String amount);

  /// No description provided for @casinoBankroll.
  ///
  /// In en, this message translates to:
  /// **'Casino Bankroll'**
  String get casinoBankroll;

  /// No description provided for @casinoStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get casinoStatsTitle;

  /// No description provided for @casinoTotalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received:'**
  String get casinoTotalReceived;

  /// No description provided for @casinoTotalPaidOut.
  ///
  /// In en, this message translates to:
  /// **'Total Paid Out:'**
  String get casinoTotalPaidOut;

  /// No description provided for @casinoNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit:'**
  String get casinoNetProfit;

  /// No description provided for @casinoProfitMargin.
  ///
  /// In en, this message translates to:
  /// **'Profit margin: {percent}%'**
  String casinoProfitMargin(String percent);

  /// No description provided for @casinoManagementInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Casino Management Info'**
  String get casinoManagementInfoTitle;

  /// No description provided for @casinoManagementInfo5.
  ///
  /// In en, this message translates to:
  /// **'• You can deposit or withdraw money at any time'**
  String get casinoManagementInfo5;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @doAction.
  ///
  /// In en, this message translates to:
  /// **'Do'**
  String get doAction;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @jail.
  ///
  /// In en, this message translates to:
  /// **'Jail'**
  String get jail;

  /// No description provided for @wantedLevel.
  ///
  /// In en, this message translates to:
  /// **'Wanted Level'**
  String get wantedLevel;

  /// No description provided for @cooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get cooldown;

  /// No description provided for @requiredRank.
  ///
  /// In en, this message translates to:
  /// **'Required Player Rank'**
  String get requiredRank;

  /// No description provided for @playerRankLabel.
  ///
  /// In en, this message translates to:
  /// **'Player rank'**
  String get playerRankLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @trade.
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get trade;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available: {count}'**
  String available(String count);

  /// No description provided for @notEnoughMoney.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough money!'**
  String get notEnoughMoney;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @unexpectedResponse.
  ///
  /// In en, this message translates to:
  /// **'Unexpected API response'**
  String get unexpectedResponse;

  /// No description provided for @errorLoadingMenu.
  ///
  /// In en, this message translates to:
  /// **'Error loading menu'**
  String get errorLoadingMenu;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @cooldownMinutes.
  ///
  /// In en, this message translates to:
  /// **'Cooldown: {minutes} min'**
  String cooldownMinutes(String minutes);

  /// No description provided for @xpReward.
  ///
  /// In en, this message translates to:
  /// **'XP: +{amount}'**
  String xpReward(String amount);

  /// No description provided for @fly.
  ///
  /// In en, this message translates to:
  /// **'Fly'**
  String get fly;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased!'**
  String get purchased;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold!'**
  String get sold;

  /// No description provided for @errorBuying.
  ///
  /// In en, this message translates to:
  /// **'Error buying'**
  String get errorBuying;

  /// No description provided for @errorSelling.
  ///
  /// In en, this message translates to:
  /// **'Error selling'**
  String get errorSelling;

  /// No description provided for @goods.
  ///
  /// In en, this message translates to:
  /// **'Goods'**
  String get goods;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @backpacks.
  ///
  /// In en, this message translates to:
  /// **'Backpacks'**
  String get backpacks;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @retryAgain.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAgain;

  /// No description provided for @noVehiclesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get noVehiclesAvailable;

  /// No description provided for @noListings.
  ///
  /// In en, this message translates to:
  /// **'No listings'**
  String get noListings;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @yourHealth.
  ///
  /// In en, this message translates to:
  /// **'Your Health'**
  String get yourHealth;

  /// No description provided for @criticalHealthWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ CRITICAL! You must go to the hospital immediately!'**
  String get criticalHealthWarning;

  /// No description provided for @lowHealthWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Low health! Be careful.'**
  String get lowHealthWarning;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @contrabandFlowersName.
  ///
  /// In en, this message translates to:
  /// **'Flowers'**
  String get contrabandFlowersName;

  /// No description provided for @contrabandFlowersDesc.
  ///
  /// In en, this message translates to:
  /// **'Dutch tulips and other flowers for international trade'**
  String get contrabandFlowersDesc;

  /// No description provided for @contrabandElectronicsName.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get contrabandElectronicsName;

  /// No description provided for @contrabandElectronicsDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced electronics and computer components'**
  String get contrabandElectronicsDesc;

  /// No description provided for @contrabandDiamondsName.
  ///
  /// In en, this message translates to:
  /// **'Diamonds'**
  String get contrabandDiamondsName;

  /// No description provided for @contrabandDiamondsDesc.
  ///
  /// In en, this message translates to:
  /// **'Rough and cut diamonds'**
  String get contrabandDiamondsDesc;

  /// No description provided for @contrabandWeaponsName.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get contrabandWeaponsName;

  /// No description provided for @contrabandWeaponsDesc.
  ///
  /// In en, this message translates to:
  /// **'Illegal weapons and ammunition'**
  String get contrabandWeaponsDesc;

  /// No description provided for @contrabandPharmaceuticalsName.
  ///
  /// In en, this message translates to:
  /// **'Pharmaceuticals'**
  String get contrabandPharmaceuticalsName;

  /// No description provided for @contrabandPharmaceuticalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Rare pharmaceutical products'**
  String get contrabandPharmaceuticalsDesc;

  /// No description provided for @multiplier.
  ///
  /// In en, this message translates to:
  /// **'Multiplier'**
  String get multiplier;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell price'**
  String get sellPrice;

  /// No description provided for @boughtFor.
  ///
  /// In en, this message translates to:
  /// **'Bought for'**
  String get boughtFor;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @ownedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Owned: {quantity}'**
  String ownedQuantity(String quantity);

  /// No description provided for @spoilsInHours.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Spoils in {hours}h'**
  String spoilsInHours(String hours);

  /// No description provided for @spoiledWorthless.
  ///
  /// In en, this message translates to:
  /// **'💀 SPOILED - Worthless'**
  String get spoiledWorthless;

  /// No description provided for @vehicleBought.
  ///
  /// In en, this message translates to:
  /// **'Vehicle successfully bought!'**
  String get vehicleBought;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @listingRemoved.
  ///
  /// In en, this message translates to:
  /// **'Listing removed'**
  String get listingRemoved;

  /// No description provided for @noItemsInInventory.
  ///
  /// In en, this message translates to:
  /// **'No items in inventory'**
  String get noItemsInInventory;

  /// No description provided for @buyItemsInBuyTab.
  ///
  /// In en, this message translates to:
  /// **'Buy items in the Buy tab'**
  String get buyItemsInBuyTab;

  /// No description provided for @errorLoadingMarketData.
  ///
  /// In en, this message translates to:
  /// **'Error loading market data: {error}'**
  String errorLoadingMarketData(String error);

  /// No description provided for @appeal.
  ///
  /// In en, this message translates to:
  /// **'Appeal'**
  String get appeal;

  /// No description provided for @submitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Submit Appeal'**
  String get submitAppeal;

  /// No description provided for @bribeJudge.
  ///
  /// In en, this message translates to:
  /// **'Bribe Judge'**
  String get bribeJudge;

  /// No description provided for @bribe.
  ///
  /// In en, this message translates to:
  /// **'Bribe'**
  String get bribe;

  /// No description provided for @treated.
  ///
  /// In en, this message translates to:
  /// **'Treated!'**
  String get treated;

  /// No description provided for @healthRestored.
  ///
  /// In en, this message translates to:
  /// **'+{hp} HP for €{cost}'**
  String healthRestored(String hp, String cost);

  /// No description provided for @treatmentOptions.
  ///
  /// In en, this message translates to:
  /// **'Treatment Options'**
  String get treatmentOptions;

  /// No description provided for @youAreDead.
  ///
  /// In en, this message translates to:
  /// **'You are dead! Game over.'**
  String get youAreDead;

  /// No description provided for @emergencyOnly.
  ///
  /// In en, this message translates to:
  /// **'Emergency treatment only available below 10 HP'**
  String get emergencyOnly;

  /// No description provided for @emergencyTreatment.
  ///
  /// In en, this message translates to:
  /// **'Emergency treatment! Free +{hp} HP'**
  String emergencyTreatment(String hp);

  /// No description provided for @byValue.
  ///
  /// In en, this message translates to:
  /// **'By Value'**
  String get byValue;

  /// No description provided for @byCondition.
  ///
  /// In en, this message translates to:
  /// **'By Condition'**
  String get byCondition;

  /// No description provided for @byFuel.
  ///
  /// In en, this message translates to:
  /// **'By Fuel'**
  String get byFuel;

  /// No description provided for @byName.
  ///
  /// In en, this message translates to:
  /// **'By Name'**
  String get byName;

  /// No description provided for @stealCar.
  ///
  /// In en, this message translates to:
  /// **'Steal Car'**
  String get stealCar;

  /// No description provided for @stealBoat.
  ///
  /// In en, this message translates to:
  /// **'Steal Boat'**
  String get stealBoat;

  /// No description provided for @sellVehicle.
  ///
  /// In en, this message translates to:
  /// **'Sell Vehicle'**
  String get sellVehicle;

  /// No description provided for @sellBoat.
  ///
  /// In en, this message translates to:
  /// **'Sell Boat'**
  String get sellBoat;

  /// No description provided for @confirmSellVehicle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sell this vehicle?'**
  String get confirmSellVehicle;

  /// No description provided for @confirmSellBoat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sell this boat?'**
  String get confirmSellBoat;

  /// No description provided for @carStolen.
  ///
  /// In en, this message translates to:
  /// **'Car successfully stolen!'**
  String get carStolen;

  /// No description provided for @boatStolen.
  ///
  /// In en, this message translates to:
  /// **'Boat successfully stolen!'**
  String get boatStolen;

  /// No description provided for @vehicleTypeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleTypeCar;

  /// No description provided for @vehicleTypeBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get vehicleTypeBoat;

  /// No description provided for @stolenVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'{vehicleType} stolen!'**
  String stolenVehicleTitle(String vehicleType);

  /// No description provided for @unknownVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Unknown {vehicleType}'**
  String unknownVehicleType(String vehicleType);

  /// No description provided for @vehicleStatSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get vehicleStatSpeed;

  /// No description provided for @vehicleStatFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get vehicleStatFuel;

  /// No description provided for @vehicleStatCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get vehicleStatCargo;

  /// No description provided for @vehicleStatStealth.
  ///
  /// In en, this message translates to:
  /// **'Stealth'**
  String get vehicleStatStealth;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @vehicleSold.
  ///
  /// In en, this message translates to:
  /// **'Vehicle successfully sold!'**
  String get vehicleSold;

  /// No description provided for @boatSold.
  ///
  /// In en, this message translates to:
  /// **'Boat successfully sold!'**
  String get boatSold;

  /// No description provided for @garageUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Garage upgraded!'**
  String get garageUpgraded;

  /// No description provided for @marinaUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Marina successfully upgraded!'**
  String get marinaUpgraded;

  /// No description provided for @marinaCapacity.
  ///
  /// In en, this message translates to:
  /// **'Marina Capacity'**
  String get marinaCapacity;

  /// No description provided for @marinaBoatsCount.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} boats'**
  String marinaBoatsCount(String current, String total);

  /// No description provided for @marinaUpgradeWithCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade (€{cost})'**
  String marinaUpgradeWithCost(String cost);

  /// No description provided for @marinaMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Max Level'**
  String get marinaMaxLevel;

  /// No description provided for @marinaLevelRemaining.
  ///
  /// In en, this message translates to:
  /// **'Level {level} | {remaining} spots left'**
  String marinaLevelRemaining(String level, String remaining);

  /// No description provided for @noBoatsInMarina.
  ///
  /// In en, this message translates to:
  /// **'No boats in your marina'**
  String get noBoatsInMarina;

  /// No description provided for @stealBoatsToStart.
  ///
  /// In en, this message translates to:
  /// **'Steal some boats to get started!'**
  String get stealBoatsToStart;

  /// No description provided for @marinaUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Marina upgrade failed'**
  String get marinaUpgradeFailed;

  /// No description provided for @boatShipped.
  ///
  /// In en, this message translates to:
  /// **'Boat successfully shipped!'**
  String get boatShipped;

  /// No description provided for @boatShipFailed.
  ///
  /// In en, this message translates to:
  /// **'Boat shipping failed'**
  String get boatShipFailed;

  /// No description provided for @buyProperty.
  ///
  /// In en, this message translates to:
  /// **'Buy Property'**
  String get buyProperty;

  /// No description provided for @propertyBought.
  ///
  /// In en, this message translates to:
  /// **'{name} purchased!'**
  String propertyBought(String name);

  /// No description provided for @propertyUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Property upgraded to level {level}!'**
  String propertyUpgraded(String level);

  /// No description provided for @errorLoadingProperties.
  ///
  /// In en, this message translates to:
  /// **'Error loading properties'**
  String get errorLoadingProperties;

  /// No description provided for @errorUpgrading.
  ///
  /// In en, this message translates to:
  /// **'Error upgrading'**
  String get errorUpgrading;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: {error}'**
  String networkError(String error);

  /// No description provided for @unknownResponse.
  ///
  /// In en, this message translates to:
  /// **'Unknown response'**
  String get unknownResponse;

  /// No description provided for @incomeCollected.
  ///
  /// In en, this message translates to:
  /// **'€{amount} collected!'**
  String incomeCollected(String amount);

  /// No description provided for @buyCasino.
  ///
  /// In en, this message translates to:
  /// **'Buy Casino'**
  String get buyCasino;

  /// No description provided for @manageCasino.
  ///
  /// In en, this message translates to:
  /// **'Manage Casino'**
  String get manageCasino;

  /// No description provided for @casinoBought.
  ///
  /// In en, this message translates to:
  /// **'Casino successfully bought! 🎰'**
  String get casinoBought;

  /// No description provided for @errorBuyCasino.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while buying the casino'**
  String get errorBuyCasino;

  /// No description provided for @minimumDeposit.
  ///
  /// In en, this message translates to:
  /// **'Minimum deposit is €{amount}'**
  String minimumDeposit(String amount);

  /// No description provided for @casinoInfo1.
  ///
  /// In en, this message translates to:
  /// **'Players bet against the casino bankroll'**
  String get casinoInfo1;

  /// No description provided for @casinoInfo2.
  ///
  /// In en, this message translates to:
  /// **'Winnings are paid from the bankroll'**
  String get casinoInfo2;

  /// No description provided for @casinoInfo3.
  ///
  /// In en, this message translates to:
  /// **'You can deposit and withdraw money'**
  String get casinoInfo3;

  /// No description provided for @casinoInfo4.
  ///
  /// In en, this message translates to:
  /// **'Minimum €10,000 in bankroll required'**
  String get casinoInfo4;

  /// No description provided for @casinoInfo5.
  ///
  /// In en, this message translates to:
  /// **'Below that: bankruptcy'**
  String get casinoInfo5;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @alreadyFullHealth.
  ///
  /// In en, this message translates to:
  /// **'You are already at full health!'**
  String get alreadyFullHealth;

  /// No description provided for @errorTreatment.
  ///
  /// In en, this message translates to:
  /// **'Error during treatment'**
  String get errorTreatment;

  /// No description provided for @waitMinutes.
  ///
  /// In en, this message translates to:
  /// **'You must wait {minutes} more minutes for the next treatment!'**
  String waitMinutes(String minutes);

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get emergencyHelp;

  /// No description provided for @onlyNeedHp.
  ///
  /// In en, this message translates to:
  /// **'(You only need {hp} HP)'**
  String onlyNeedHp(String hp);

  /// No description provided for @emergencyInfo.
  ///
  /// In en, this message translates to:
  /// **'• 🊘 Emergency Help is FREE below 10 HP (+20 HP)'**
  String get emergencyInfo;

  /// No description provided for @hospitalInfo1.
  ///
  /// In en, this message translates to:
  /// **'• Health decreases when committing crimes'**
  String get hospitalInfo1;

  /// No description provided for @hospitalInfo2.
  ///
  /// In en, this message translates to:
  /// **'• At 0 HP you cannot commit crimes'**
  String get hospitalInfo2;

  /// No description provided for @hospitalInfo3.
  ///
  /// In en, this message translates to:
  /// **'• Treatment costs €{cost} per time'**
  String hospitalInfo3(String cost);

  /// No description provided for @hospitalInfo4.
  ///
  /// In en, this message translates to:
  /// **'• You can restore max {amount} HP per treatment'**
  String hospitalInfo4(String amount);

  /// No description provided for @hospitalInfo5.
  ///
  /// In en, this message translates to:
  /// **'• ⏱️ 1 hour cooldown between treatments'**
  String get hospitalInfo5;

  /// No description provided for @hospitalInfo6.
  ///
  /// In en, this message translates to:
  /// **'• 💚 Passive healing: +5 HP per 5 minutes (if HP > 0)'**
  String get hospitalInfo6;

  /// No description provided for @medicalTreatment.
  ///
  /// In en, this message translates to:
  /// **'Medical Treatment'**
  String get medicalTreatment;

  /// No description provided for @restoreCritical.
  ///
  /// In en, this message translates to:
  /// **'Restore +20 HP (critical condition)'**
  String get restoreCritical;

  /// No description provided for @restoreUp.
  ///
  /// In en, this message translates to:
  /// **'Restore up to {amount} HP'**
  String restoreUp(String amount);

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @crimeErrorToolRequired.
  ///
  /// In en, this message translates to:
  /// **'⚒️ You need {tools} for this crime'**
  String crimeErrorToolRequired(String tools);

  /// No description provided for @crimeErrorToolInStorage.
  ///
  /// In en, this message translates to:
  /// **'⚒️ You have {tools}, but it\'s at home! Go to Inventory → Transfer'**
  String crimeErrorToolInStorage(String tools);

  /// No description provided for @crimeErrorVehicleRequired.
  ///
  /// In en, this message translates to:
  /// **'🚗 This crime requires a vehicle'**
  String get crimeErrorVehicleRequired;

  /// No description provided for @crimeErrorVehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'🚗 Vehicle not found'**
  String get crimeErrorVehicleNotFound;

  /// No description provided for @crimeErrorNotVehicleOwner.
  ///
  /// In en, this message translates to:
  /// **'🚗 You don\'t own this vehicle'**
  String get crimeErrorNotVehicleOwner;

  /// No description provided for @crimeErrorVehicleBroken.
  ///
  /// In en, this message translates to:
  /// **'🚗 Your vehicle is broken and needs repair'**
  String get crimeErrorVehicleBroken;

  /// No description provided for @crimeErrorNoFuel.
  ///
  /// In en, this message translates to:
  /// **'⛽ Your vehicle has no fuel'**
  String get crimeErrorNoFuel;

  /// No description provided for @crimeErrorLevelTooLow.
  ///
  /// In en, this message translates to:
  /// **'⭐ Your level is too low for this crime'**
  String get crimeErrorLevelTooLow;

  /// No description provided for @crimeErrorInvalidCrimeId.
  ///
  /// In en, this message translates to:
  /// **'❌ Invalid crime'**
  String get crimeErrorInvalidCrimeId;

  /// No description provided for @crimeErrorWeaponRequired.
  ///
  /// In en, this message translates to:
  /// **'🔫 You need a weapon for this crime'**
  String get crimeErrorWeaponRequired;

  /// No description provided for @crimeErrorWeaponBroken.
  ///
  /// In en, this message translates to:
  /// **'🔫 Your weapon is broken and needs repair'**
  String get crimeErrorWeaponBroken;

  /// No description provided for @crimeErrorNoAmmo.
  ///
  /// In en, this message translates to:
  /// **'🔫 You have no ammo'**
  String get crimeErrorNoAmmo;

  /// No description provided for @crimeErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'❌ Something went wrong with this crime'**
  String get crimeErrorGeneric;

  /// No description provided for @inventoryFull.
  ///
  /// In en, this message translates to:
  /// **'🎒 Your inventory is full! Store tools in a property'**
  String get inventoryFull;

  /// No description provided for @storageFull.
  ///
  /// In en, this message translates to:
  /// **'📦 Property storage is full'**
  String get storageFull;

  /// No description provided for @transferSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ {tool} moved to {location}'**
  String transferSuccess(String tool, String location);

  /// No description provided for @carried.
  ///
  /// In en, this message translates to:
  /// **'Carried'**
  String get carried;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @property.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get property;

  /// No description provided for @inventorySlots.
  ///
  /// In en, this message translates to:
  /// **'{used} / {max} slots'**
  String inventorySlots(int used, int max);

  /// No description provided for @loadouts.
  ///
  /// In en, this message translates to:
  /// **'Loadouts'**
  String get loadouts;

  /// No description provided for @createLoadout.
  ///
  /// In en, this message translates to:
  /// **'Create Loadout'**
  String get createLoadout;

  /// No description provided for @equipLoadout.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get equipLoadout;

  /// No description provided for @loadoutEquipped.
  ///
  /// In en, this message translates to:
  /// **'✅ Loadout equipped'**
  String get loadoutEquipped;

  /// No description provided for @loadoutMaxReached.
  ///
  /// In en, this message translates to:
  /// **'❌ Maximum loadouts reached (5)'**
  String get loadoutMaxReached;

  /// No description provided for @loadoutMissingTools.
  ///
  /// In en, this message translates to:
  /// **'❌ Missing tools: {tools}'**
  String loadoutMissingTools(String tools);

  /// No description provided for @backpackUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Backpack Upgrade'**
  String get backpackUpgrade;

  /// No description provided for @backpackBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Backpack (+5 slots)'**
  String get backpackBasic;

  /// No description provided for @backpackTactical.
  ///
  /// In en, this message translates to:
  /// **'Tactical Vest (+10 slots)'**
  String get backpackTactical;

  /// No description provided for @backpackCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo Pants (+3 slots)'**
  String get backpackCargo;

  /// No description provided for @upgradeInventory.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Inventory'**
  String get upgradeInventory;

  /// No description provided for @noToolsCarried.
  ///
  /// In en, this message translates to:
  /// **'No tools carried'**
  String get noToolsCarried;

  /// No description provided for @visitShopToBuyTools.
  ///
  /// In en, this message translates to:
  /// **'Visit the shop to buy tools'**
  String get visitShopToBuyTools;

  /// No description provided for @noProperties.
  ///
  /// In en, this message translates to:
  /// **'No properties'**
  String get noProperties;

  /// No description provided for @buyPropertyForStorage.
  ///
  /// In en, this message translates to:
  /// **'Buy a property to store tools'**
  String get buyPropertyForStorage;

  /// No description provided for @noToolsInStorage.
  ///
  /// In en, this message translates to:
  /// **'No tools in storage'**
  String get noToolsInStorage;

  /// No description provided for @selectProperty.
  ///
  /// In en, this message translates to:
  /// **'Select property'**
  String get selectProperty;

  /// No description provided for @slotsRemaining.
  ///
  /// In en, this message translates to:
  /// **'slots remaining'**
  String get slotsRemaining;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'tools'**
  String get tools;

  /// No description provided for @noLoadouts.
  ///
  /// In en, this message translates to:
  /// **'No loadouts'**
  String get noLoadouts;

  /// No description provided for @createLoadoutToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a loadout to get started'**
  String get createLoadoutToStart;

  /// No description provided for @deleteLoadout.
  ///
  /// In en, this message translates to:
  /// **'Delete Loadout'**
  String get deleteLoadout;

  /// No description provided for @confirmDeleteLoadout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this loadout?'**
  String get confirmDeleteLoadout;

  /// No description provided for @loadoutDeleted.
  ///
  /// In en, this message translates to:
  /// **'Loadout deleted'**
  String get loadoutDeleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @durability.
  ///
  /// In en, this message translates to:
  /// **'Durability'**
  String get durability;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @slotSize.
  ///
  /// In en, this message translates to:
  /// **'Slot size'**
  String get slotSize;

  /// No description provided for @repairCost.
  ///
  /// In en, this message translates to:
  /// **'Repair cost'**
  String get repairCost;

  /// No description provided for @wearPerUse.
  ///
  /// In en, this message translates to:
  /// **'Wear per use'**
  String get wearPerUse;

  /// No description provided for @loseChance.
  ///
  /// In en, this message translates to:
  /// **'Chance to lose'**
  String get loseChance;

  /// No description provided for @requiredFor.
  ///
  /// In en, this message translates to:
  /// **'Required for'**
  String get requiredFor;

  /// No description provided for @lowDurability.
  ///
  /// In en, this message translates to:
  /// **'Low durability'**
  String get lowDurability;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @toolDetails.
  ///
  /// In en, this message translates to:
  /// **'Tool Details'**
  String get toolDetails;

  /// No description provided for @transferTool.
  ///
  /// In en, this message translates to:
  /// **'Transfer Tool'**
  String get transferTool;

  /// No description provided for @selectQuantity.
  ///
  /// In en, this message translates to:
  /// **'Select quantity'**
  String get selectQuantity;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @editLoadout.
  ///
  /// In en, this message translates to:
  /// **'Edit Loadout'**
  String get editLoadout;

  /// No description provided for @loadoutName.
  ///
  /// In en, this message translates to:
  /// **'Loadout Name'**
  String get loadoutName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @selectedTools.
  ///
  /// In en, this message translates to:
  /// **'Selected tools'**
  String get selectedTools;

  /// No description provided for @noToolsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tools available'**
  String get noToolsAvailable;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseSelectTools.
  ///
  /// In en, this message translates to:
  /// **'Please select at least 1 tool'**
  String get pleaseSelectTools;

  /// No description provided for @loadoutCreated.
  ///
  /// In en, this message translates to:
  /// **'Loadout created'**
  String get loadoutCreated;

  /// No description provided for @loadoutUpdated.
  ///
  /// In en, this message translates to:
  /// **'Loadout updated'**
  String get loadoutUpdated;

  /// No description provided for @goToInventory.
  ///
  /// In en, this message translates to:
  /// **'Go to Inventory'**
  String get goToInventory;

  /// No description provided for @slots.
  ///
  /// In en, this message translates to:
  /// **'slots'**
  String get slots;

  /// No description provided for @backpackShop.
  ///
  /// In en, this message translates to:
  /// **'Backpack Shop'**
  String get backpackShop;

  /// No description provided for @yourBackpack.
  ///
  /// In en, this message translates to:
  /// **'Your backpack'**
  String get yourBackpack;

  /// No description provided for @availableUpgrades.
  ///
  /// In en, this message translates to:
  /// **'Available upgrades'**
  String get availableUpgrades;

  /// No description provided for @otherBackpacks.
  ///
  /// In en, this message translates to:
  /// **'Other backpacks'**
  String get otherBackpacks;

  /// No description provided for @youHaveBestBackpack.
  ///
  /// In en, this message translates to:
  /// **'You have the best backpack!'**
  String get youHaveBestBackpack;

  /// No description provided for @backpackPurchased.
  ///
  /// In en, this message translates to:
  /// **'Backpack purchased!'**
  String get backpackPurchased;

  /// No description provided for @backpackUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Backpack upgraded!'**
  String get backpackUpgraded;

  /// No description provided for @buyBackpack.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyBackpack;

  /// No description provided for @upgradeBackpack.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgradeBackpack;

  /// No description provided for @backpackPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get backpackPrice;

  /// No description provided for @extraSlots.
  ///
  /// In en, this message translates to:
  /// **'Extra slots'**
  String get extraSlots;

  /// No description provided for @totalSlots.
  ///
  /// In en, this message translates to:
  /// **'Total slots'**
  String get totalSlots;

  /// No description provided for @vipOnly.
  ///
  /// In en, this message translates to:
  /// **'VIP only'**
  String get vipOnly;

  /// No description provided for @tradeInValue.
  ///
  /// In en, this message translates to:
  /// **'Trade-in value'**
  String get tradeInValue;

  /// No description provided for @upgradeCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade cost'**
  String get upgradeCost;

  /// No description provided for @rankRequired.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank} required'**
  String rankRequired(Object rank);

  /// No description provided for @insufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'You need €{needed}. You have €{have}'**
  String insufficientFunds(String needed, String have);

  /// No description provided for @alreadyHasBackpack.
  ///
  /// In en, this message translates to:
  /// **'You already have a backpack'**
  String get alreadyHasBackpack;

  /// No description provided for @backpackNotFound.
  ///
  /// In en, this message translates to:
  /// **'Backpack not found'**
  String get backpackNotFound;

  /// No description provided for @playerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found'**
  String get playerNotFound;

  /// No description provided for @notAnUpgrade.
  ///
  /// In en, this message translates to:
  /// **'This is not an upgrade'**
  String get notAnUpgrade;

  /// No description provided for @backpackPurchasedEvent.
  ///
  /// In en, this message translates to:
  /// **'You purchased {name}! +{slots} slots.'**
  String backpackPurchasedEvent(Object name, Object slots);

  /// No description provided for @backpackUpgradedEvent.
  ///
  /// In en, this message translates to:
  /// **'Upgraded to {newName}! +{upgradeSlots} extra slots.'**
  String backpackUpgradedEvent(Object newName, Object upgradeSlots);

  /// No description provided for @backpackPurchaseFailedNotFound.
  ///
  /// In en, this message translates to:
  /// **'Backpack not found'**
  String get backpackPurchaseFailedNotFound;

  /// No description provided for @backpackPurchaseFailedAlready.
  ///
  /// In en, this message translates to:
  /// **'You already have a backpack. You can only use one at a time.'**
  String get backpackPurchaseFailedAlready;

  /// No description provided for @backpackPurchaseFailedRank.
  ///
  /// In en, this message translates to:
  /// **'You need rank {required} (you are rank {current})'**
  String backpackPurchaseFailedRank(Object current, Object required);

  /// No description provided for @backpackPurchaseFailedFunds.
  ///
  /// In en, this message translates to:
  /// **'You need €{needed}. You have €{have}'**
  String backpackPurchaseFailedFunds(Object have, Object needed);

  /// No description provided for @backpackPurchaseFailedVip.
  ///
  /// In en, this message translates to:
  /// **'This backpack is for VIP members only'**
  String get backpackPurchaseFailedVip;

  /// No description provided for @backpackUpgradeFailedNo.
  ///
  /// In en, this message translates to:
  /// **'You have no backpack to upgrade'**
  String get backpackUpgradeFailedNo;

  /// No description provided for @backpackUpgradeFailedNotUpgrade.
  ///
  /// In en, this message translates to:
  /// **'This is not an upgrade. Choose a larger backpack.'**
  String get backpackUpgradeFailedNotUpgrade;

  /// No description provided for @backpackUpgradeFailedRank.
  ///
  /// In en, this message translates to:
  /// **'You need rank {required} (you are rank {current})'**
  String backpackUpgradeFailedRank(Object current, Object required);

  /// No description provided for @backpackUpgradeFailedFunds.
  ///
  /// In en, this message translates to:
  /// **'You need €{needed}. You have €{have}'**
  String backpackUpgradeFailedFunds(Object have, Object needed);

  /// No description provided for @backpackUpgradeFailedVip.
  ///
  /// In en, this message translates to:
  /// **'This backpack is for VIP members only'**
  String get backpackUpgradeFailedVip;

  /// No description provided for @arrested.
  ///
  /// In en, this message translates to:
  /// **'Arrested!'**
  String get arrested;

  /// No description provided for @jailMessage.
  ///
  /// In en, this message translates to:
  /// **'You were arrested during your journey and all goods were confiscated!'**
  String get jailMessage;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmAction;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @travelContinueConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Proceed to next leg?'**
  String get travelContinueConfirmTitle;

  /// No description provided for @travelContinueConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Border checks are active. Continue your journey?'**
  String get travelContinueConfirmBody;

  /// No description provided for @travelJourneyCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Journey complete'**
  String get travelJourneyCompleteTitle;

  /// No description provided for @travelJourneyCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'You made it safely to your destination.'**
  String get travelJourneyCompleteBody;

  /// No description provided for @hitlist.
  ///
  /// In en, this message translates to:
  /// **'Hit List'**
  String get hitlist;

  /// No description provided for @hitlistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading hit list: {error}'**
  String hitlistLoadError(String error);

  /// No description provided for @noActiveHits.
  ///
  /// In en, this message translates to:
  /// **'No active hits placed'**
  String get noActiveHits;

  /// No description provided for @selectTarget.
  ///
  /// In en, this message translates to:
  /// **'Select Target'**
  String get selectTarget;

  /// No description provided for @searchPlayer.
  ///
  /// In en, this message translates to:
  /// **'Search player...'**
  String get searchPlayer;

  /// No description provided for @placeHitTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Hit'**
  String get placeHitTitle;

  /// No description provided for @minimumBounty.
  ///
  /// In en, this message translates to:
  /// **'Minimum bounty: €50,000'**
  String get minimumBounty;

  /// No description provided for @bountyAmount.
  ///
  /// In en, this message translates to:
  /// **'Bounty amount'**
  String get bountyAmount;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @hitPlaced.
  ///
  /// In en, this message translates to:
  /// **'Hit placed for €{amount}'**
  String hitPlaced(String amount);

  /// No description provided for @hitError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String hitError(String error);

  /// No description provided for @hitDifferentCountry.
  ///
  /// In en, this message translates to:
  /// **'You must be in the same country as the target'**
  String get hitDifferentCountry;

  /// No description provided for @counterBountyTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Counter-Bounty'**
  String get counterBountyTitle;

  /// No description provided for @minimumAmount.
  ///
  /// In en, this message translates to:
  /// **'Minimum amount: €{amount}'**
  String minimumAmount(String amount);

  /// No description provided for @counterBountyAmount.
  ///
  /// In en, this message translates to:
  /// **'Counter-bounty amount'**
  String get counterBountyAmount;

  /// No description provided for @counterBountyPlaced.
  ///
  /// In en, this message translates to:
  /// **'Counter-bounty of €{amount} placed'**
  String counterBountyPlaced(String amount);

  /// No description provided for @cancelHitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel hit?'**
  String get cancelHitConfirmTitle;

  /// No description provided for @cancelHitConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your bounty will be refunded.'**
  String get cancelHitConfirmBody;

  /// No description provided for @hitCancelled.
  ///
  /// In en, this message translates to:
  /// **'Hit cancelled'**
  String get hitCancelled;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @placer.
  ///
  /// In en, this message translates to:
  /// **'Placer'**
  String get placer;

  /// No description provided for @bounty.
  ///
  /// In en, this message translates to:
  /// **'Bounty'**
  String get bounty;

  /// No description provided for @counterBid.
  ///
  /// In en, this message translates to:
  /// **'COUNTER-BID'**
  String get counterBid;

  /// No description provided for @counterBidPlaced.
  ///
  /// In en, this message translates to:
  /// **'Counter-bid placed! The contract has been reversed.'**
  String get counterBidPlaced;

  /// No description provided for @attemptHit.
  ///
  /// In en, this message translates to:
  /// **'Attempt Hit'**
  String get attemptHit;

  /// No description provided for @selectWeapon.
  ///
  /// In en, this message translates to:
  /// **'Select Weapon and Ammo'**
  String get selectWeapon;

  /// No description provided for @youAreTargeted.
  ///
  /// In en, this message translates to:
  /// **'You are on the hit list'**
  String get youAreTargeted;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @currentDefense.
  ///
  /// In en, this message translates to:
  /// **'Current Defense'**
  String get currentDefense;

  /// No description provided for @totalDefense.
  ///
  /// In en, this message translates to:
  /// **'Total Defense'**
  String get totalDefense;

  /// No description provided for @currentArmor.
  ///
  /// In en, this message translates to:
  /// **'Current Armor'**
  String get currentArmor;

  /// No description provided for @bodyguards.
  ///
  /// In en, this message translates to:
  /// **'Bodyguards'**
  String get bodyguards;

  /// No description provided for @buyBodyguards.
  ///
  /// In en, this message translates to:
  /// **'Buy Bodyguards'**
  String get buyBodyguards;

  /// No description provided for @bodyguardPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per Bodyguard'**
  String get bodyguardPrice;

  /// No description provided for @armor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get armor;

  /// No description provided for @protectorsFollow.
  ///
  /// In en, this message translates to:
  /// **'Protectors that follow you'**
  String get protectorsFollow;

  /// No description provided for @eachGivesDefense.
  ///
  /// In en, this message translates to:
  /// **'Each gives +10 defense'**
  String get eachGivesDefense;

  /// No description provided for @lightArmor.
  ///
  /// In en, this message translates to:
  /// **'Light Armor'**
  String get lightArmor;

  /// No description provided for @basicProtection.
  ///
  /// In en, this message translates to:
  /// **'Basic protection'**
  String get basicProtection;

  /// No description provided for @heavyArmor.
  ///
  /// In en, this message translates to:
  /// **'Heavy Armor'**
  String get heavyArmor;

  /// No description provided for @strongProtection.
  ///
  /// In en, this message translates to:
  /// **'Strong protection'**
  String get strongProtection;

  /// No description provided for @bulletproofVest.
  ///
  /// In en, this message translates to:
  /// **'Bulletproof Vest'**
  String get bulletproofVest;

  /// No description provided for @veryStrongProtection.
  ///
  /// In en, this message translates to:
  /// **'Very strong protection'**
  String get veryStrongProtection;

  /// No description provided for @tacticalSuit.
  ///
  /// In en, this message translates to:
  /// **'Tactical Outfit'**
  String get tacticalSuit;

  /// No description provided for @premiumProtection.
  ///
  /// In en, this message translates to:
  /// **'Premium protection'**
  String get premiumProtection;

  /// No description provided for @defense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get defense;

  /// No description provided for @defenseIncrease.
  ///
  /// In en, this message translates to:
  /// **'You purchased {armor}! +{defense} defense'**
  String defenseIncrease(String armor, String defense);

  /// No description provided for @worn.
  ///
  /// In en, this message translates to:
  /// **'Worn'**
  String get worn;

  /// No description provided for @hit.
  ///
  /// In en, this message translates to:
  /// **'HIT'**
  String get hit;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} day{plural} ago'**
  String daysAgo(String count, String plural);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(String count);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(String count);

  /// No description provided for @justPlaced.
  ///
  /// In en, this message translates to:
  /// **'Just placed'**
  String get justPlaced;

  /// No description provided for @youAreTheTarget.
  ///
  /// In en, this message translates to:
  /// **'You are the target'**
  String get youAreTheTarget;

  /// No description provided for @youAreThePlacer.
  ///
  /// In en, this message translates to:
  /// **'You are the placer'**
  String get youAreThePlacer;

  /// No description provided for @onlyTargetCanCounterBid.
  ///
  /// In en, this message translates to:
  /// **'Only the target can place a counter-bid'**
  String get onlyTargetCanCounterBid;

  /// No description provided for @executeHit.
  ///
  /// In en, this message translates to:
  /// **'Execute Hit'**
  String get executeHit;

  /// No description provided for @moneyNotEnough.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough money'**
  String get moneyNotEnough;

  /// No description provided for @securityScreen.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityScreen;

  /// No description provided for @currentDefenseStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Defense Status'**
  String get currentDefenseStatus;

  /// No description provided for @noWeapons.
  ///
  /// In en, this message translates to:
  /// **'You have no weapons in your inventory'**
  String get noWeapons;

  /// No description provided for @ammoQuantity.
  ///
  /// In en, this message translates to:
  /// **'Ammo Quantity'**
  String get ammoQuantity;

  /// No description provided for @noAmmoRequired.
  ///
  /// In en, this message translates to:
  /// **'No ammunition required for this weapon'**
  String get noAmmoRequired;

  /// No description provided for @weaponStats.
  ///
  /// In en, this message translates to:
  /// **'Weapon Stats'**
  String get weaponStats;

  /// No description provided for @damage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get damage;

  /// No description provided for @intimidation.
  ///
  /// In en, this message translates to:
  /// **'Intimidation'**
  String get intimidation;

  /// No description provided for @execute.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get execute;

  /// No description provided for @hitExecuted.
  ///
  /// In en, this message translates to:
  /// **'Hit executed successfully!'**
  String get hitExecuted;

  /// No description provided for @invalidAmmo.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid ammo quantity'**
  String get invalidAmmo;

  /// No description provided for @weaponsMarket.
  ///
  /// In en, this message translates to:
  /// **'Weapons Market'**
  String get weaponsMarket;

  /// No description provided for @ammoMarket.
  ///
  /// In en, this message translates to:
  /// **'Ammo Market'**
  String get ammoMarket;

  /// No description provided for @shootingRange.
  ///
  /// In en, this message translates to:
  /// **'Shooting Range'**
  String get shootingRange;

  /// No description provided for @ammoFactory.
  ///
  /// In en, this message translates to:
  /// **'Ammo Factory'**
  String get ammoFactory;

  /// No description provided for @weaponShop.
  ///
  /// In en, this message translates to:
  /// **'Weapon Shop'**
  String get weaponShop;

  /// No description provided for @myWeapons.
  ///
  /// In en, this message translates to:
  /// **'My Weapons'**
  String get myWeapons;

  /// No description provided for @weaponPurchased.
  ///
  /// In en, this message translates to:
  /// **'Weapon purchased'**
  String get weaponPurchased;

  /// No description provided for @weaponRankRequired.
  ///
  /// In en, this message translates to:
  /// **'Rank required: {rank}'**
  String weaponRankRequired(String rank);

  /// No description provided for @buyWeapon.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyWeapon;

  /// No description provided for @ammoShop.
  ///
  /// In en, this message translates to:
  /// **'Ammo Market'**
  String get ammoShop;

  /// No description provided for @myAmmo.
  ///
  /// In en, this message translates to:
  /// **'My Ammo'**
  String get myAmmo;

  /// No description provided for @ammoPurchased.
  ///
  /// In en, this message translates to:
  /// **'Ammo purchased'**
  String get ammoPurchased;

  /// No description provided for @purchaseCooldown.
  ///
  /// In en, this message translates to:
  /// **'You must wait before the next purchase'**
  String get purchaseCooldown;

  /// No description provided for @insufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock available'**
  String get insufficientStock;

  /// No description provided for @maxInventoryReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum inventory capacity reached'**
  String get maxInventoryReached;

  /// No description provided for @invalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get invalidQuantity;

  /// No description provided for @nextAmmoPurchase.
  ///
  /// In en, this message translates to:
  /// **'Next purchase available in'**
  String get nextAmmoPurchase;

  /// No description provided for @ammoBoxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get ammoBoxes;

  /// No description provided for @ammoRoundsPerBox.
  ///
  /// In en, this message translates to:
  /// **'{rounds} rounds per box'**
  String ammoRoundsPerBox(String rounds);

  /// No description provided for @ammoYouWillReceive.
  ///
  /// In en, this message translates to:
  /// **'You will receive: {rounds} rounds'**
  String ammoYouWillReceive(String rounds);

  /// No description provided for @ammoTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost: €{cost}'**
  String ammoTotalCost(String cost);

  /// No description provided for @ammoRounds.
  ///
  /// In en, this message translates to:
  /// **'rounds'**
  String get ammoRounds;

  /// No description provided for @ammoBoxesUnit.
  ///
  /// In en, this message translates to:
  /// **'boxes'**
  String get ammoBoxesUnit;

  /// No description provided for @ammoStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get ammoStock;

  /// No description provided for @ammoQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get ammoQuality;

  /// No description provided for @factoryBought.
  ///
  /// In en, this message translates to:
  /// **'Factory purchased'**
  String get factoryBought;

  /// No description provided for @factoryProduced.
  ///
  /// In en, this message translates to:
  /// **'Production updated'**
  String get factoryProduced;

  /// No description provided for @factorySessionStarted.
  ///
  /// In en, this message translates to:
  /// **'Production started: active for 8 hours, new ammo every 5 minutes'**
  String get factorySessionStarted;

  /// No description provided for @ammoFactoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Ammo Factory'**
  String get ammoFactoryTitle;

  /// No description provided for @ammoFactoryIntro.
  ///
  /// In en, this message translates to:
  /// **'Produces automatically every 5 minutes. You can claim up to 8 hours of backlog.'**
  String get ammoFactoryIntro;

  /// No description provided for @ammoFactoryWhatYouCanDo.
  ///
  /// In en, this message translates to:
  /// **'What you can do:'**
  String get ammoFactoryWhatYouCanDo;

  /// No description provided for @ammoFactoryActionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy a factory in your current country'**
  String get ammoFactoryActionBuy;

  /// No description provided for @ammoFactoryActionProduce.
  ///
  /// In en, this message translates to:
  /// **'Claim production (interval: 5 minutes, max backlog: 8 hours)'**
  String get ammoFactoryActionProduce;

  /// No description provided for @ammoFactoryActionOutput.
  ///
  /// In en, this message translates to:
  /// **'Upgrade output to level 5 (max ±3200 per 8h / ±400 per hour)'**
  String get ammoFactoryActionOutput;

  /// No description provided for @ammoFactoryActionQuality.
  ///
  /// In en, this message translates to:
  /// **'Upgrade quality for stronger market prices'**
  String get ammoFactoryActionQuality;

  /// No description provided for @factoryUpgradeOutputSuccess.
  ///
  /// In en, this message translates to:
  /// **'Output upgraded'**
  String get factoryUpgradeOutputSuccess;

  /// No description provided for @factoryUpgradeQualitySuccess.
  ///
  /// In en, this message translates to:
  /// **'Quality upgraded'**
  String get factoryUpgradeQualitySuccess;

  /// No description provided for @myFactory.
  ///
  /// In en, this message translates to:
  /// **'My Factory'**
  String get myFactory;

  /// No description provided for @noFactoryOwned.
  ///
  /// In en, this message translates to:
  /// **'You do not own a factory'**
  String get noFactoryOwned;

  /// No description provided for @factoryCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get factoryCountry;

  /// No description provided for @factoryOutputLevel.
  ///
  /// In en, this message translates to:
  /// **'Output level'**
  String get factoryOutputLevel;

  /// No description provided for @factoryQualityLevel.
  ///
  /// In en, this message translates to:
  /// **'Quality level'**
  String get factoryQualityLevel;

  /// No description provided for @factoryLastProduced.
  ///
  /// In en, this message translates to:
  /// **'Last produced'**
  String get factoryLastProduced;

  /// No description provided for @factoryProduceStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Produce status'**
  String get factoryProduceStatusLabel;

  /// No description provided for @factoryProduceStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get factoryProduceStatusReady;

  /// No description provided for @factoryProduceStatusCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get factoryProduceStatusCooldown;

  /// No description provided for @factorySessionActive.
  ///
  /// In en, this message translates to:
  /// **'Production window: active (5 min interval)'**
  String get factorySessionActive;

  /// No description provided for @factorySessionStopped.
  ///
  /// In en, this message translates to:
  /// **'Production window: stopped (click Produce to start a new 8-hour window)'**
  String get factorySessionStopped;

  /// No description provided for @factorySessionEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Window ends in: {duration}'**
  String factorySessionEndsIn(String duration);

  /// No description provided for @factoryNextProductionReady.
  ///
  /// In en, this message translates to:
  /// **'Next production: available now (press Produce to claim)'**
  String get factoryNextProductionReady;

  /// No description provided for @factoryNextProductionIn.
  ///
  /// In en, this message translates to:
  /// **'Next production in: {duration}'**
  String factoryNextProductionIn(String duration);

  /// No description provided for @factoryProduce.
  ///
  /// In en, this message translates to:
  /// **'Produce'**
  String get factoryProduce;

  /// No description provided for @factoryUpgradeOutput.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Output'**
  String get factoryUpgradeOutput;

  /// No description provided for @factoryUpgradeQuality.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Quality'**
  String get factoryUpgradeQuality;

  /// No description provided for @factoryList.
  ///
  /// In en, this message translates to:
  /// **'Factories by Country'**
  String get factoryList;

  /// No description provided for @factoryUnowned.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get factoryUnowned;

  /// No description provided for @factoryOwnedBy.
  ///
  /// In en, this message translates to:
  /// **'Owner: {owner}'**
  String factoryOwnedBy(String owner);

  /// No description provided for @factoryBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get factoryBuy;

  /// No description provided for @shootingTrainSuccess.
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get shootingTrainSuccess;

  /// No description provided for @shootingSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}/100'**
  String shootingSessions(String count);

  /// No description provided for @shootingAccuracyBonus.
  ///
  /// In en, this message translates to:
  /// **'Accuracy bonus: {bonus}%'**
  String shootingAccuracyBonus(String bonus);

  /// No description provided for @shootingCooldown.
  ///
  /// In en, this message translates to:
  /// **'Next session at {time}'**
  String shootingCooldown(String time);

  /// No description provided for @shootingTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get shootingTrain;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @gymTrainSuccess.
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get gymTrainSuccess;

  /// No description provided for @gymSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}/100'**
  String gymSessions(String count);

  /// No description provided for @gymStrengthBonus.
  ///
  /// In en, this message translates to:
  /// **'Strength bonus: {bonus}%'**
  String gymStrengthBonus(String bonus);

  /// No description provided for @gymCooldown.
  ///
  /// In en, this message translates to:
  /// **'Next session at {time}'**
  String gymCooldown(String time);

  /// No description provided for @gymTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get gymTrain;

  /// No description provided for @buyAmmo.
  ///
  /// In en, this message translates to:
  /// **'Buy Ammo'**
  String get buyAmmo;

  /// No description provided for @factoryPurchaseCost.
  ///
  /// In en, this message translates to:
  /// **'Purchase Cost: €{cost}'**
  String factoryPurchaseCost(String cost);

  /// No description provided for @factoryProductionOutput.
  ///
  /// In en, this message translates to:
  /// **'Output per cycle: {amount} units'**
  String factoryProductionOutput(String amount);

  /// No description provided for @factoryQualityMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Quality Multiplier: {multiplier}x'**
  String factoryQualityMultiplier(String multiplier);

  /// No description provided for @upgradeOutputCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Output - Cost: €{cost}, Next Output: {nextAmount}'**
  String upgradeOutputCost(String cost, String nextAmount);

  /// No description provided for @upgradeQualityCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Quality - Cost: €{cost}, Next Quality: {nextQuality}x'**
  String upgradeQualityCost(String cost, String nextQuality);

  /// No description provided for @factoryCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get factoryCostLabel;

  /// No description provided for @factoryCurrentOutput.
  ///
  /// In en, this message translates to:
  /// **'Current Output'**
  String get factoryCurrentOutput;

  /// No description provided for @factoryNextOutput.
  ///
  /// In en, this message translates to:
  /// **'Next Output'**
  String get factoryNextOutput;

  /// No description provided for @factoryCurrentQuality.
  ///
  /// In en, this message translates to:
  /// **'Current Quality'**
  String get factoryCurrentQuality;

  /// No description provided for @factoryNextQuality.
  ///
  /// In en, this message translates to:
  /// **'Next Quality'**
  String get factoryNextQuality;

  /// No description provided for @factoryUnitsPerCycle.
  ///
  /// In en, this message translates to:
  /// **'units/8h max'**
  String get factoryUnitsPerCycle;

  /// No description provided for @factoryUnitsPerHour.
  ///
  /// In en, this message translates to:
  /// **'units/hour'**
  String get factoryUnitsPerHour;

  /// No description provided for @factoryUpgradeMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Factory is at max level'**
  String get factoryUpgradeMaxLevel;

  /// No description provided for @countryUsa.
  ///
  /// In en, this message translates to:
  /// **'USA'**
  String get countryUsa;

  /// No description provided for @countryMexico.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMexico;

  /// No description provided for @countryColombia.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get countryColombia;

  /// No description provided for @countryBrazil.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBrazil;

  /// No description provided for @countryArgentina.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryArgentina;

  /// No description provided for @countryJapan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJapan;

  /// No description provided for @countryChina.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryChina;

  /// No description provided for @countryRussia.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRussia;

  /// No description provided for @countryIndia.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIndia;

  /// No description provided for @countryAustralia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAustralia;

  /// No description provided for @countrySouthAfrica.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get countrySouthAfrica;

  /// No description provided for @countryCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCanada;

  /// No description provided for @toolBoltCutter.
  ///
  /// In en, this message translates to:
  /// **'Bolt Cutter'**
  String get toolBoltCutter;

  /// No description provided for @toolCarTheftTools.
  ///
  /// In en, this message translates to:
  /// **'Car Theft Tools'**
  String get toolCarTheftTools;

  /// No description provided for @toolBurglaryKit.
  ///
  /// In en, this message translates to:
  /// **'Burglary Kit'**
  String get toolBurglaryKit;

  /// No description provided for @toolToolbox.
  ///
  /// In en, this message translates to:
  /// **'Toolbox'**
  String get toolToolbox;

  /// No description provided for @toolCrowbar.
  ///
  /// In en, this message translates to:
  /// **'Crowbar'**
  String get toolCrowbar;

  /// No description provided for @toolGlassCutter.
  ///
  /// In en, this message translates to:
  /// **'Glass Cutter'**
  String get toolGlassCutter;

  /// No description provided for @toolSprayPaint.
  ///
  /// In en, this message translates to:
  /// **'Spray Paint'**
  String get toolSprayPaint;

  /// No description provided for @toolJerryCan.
  ///
  /// In en, this message translates to:
  /// **'Jerry Can'**
  String get toolJerryCan;

  /// No description provided for @toolFakeDocuments.
  ///
  /// In en, this message translates to:
  /// **'Fake Documents'**
  String get toolFakeDocuments;

  /// No description provided for @toolHackingLaptop.
  ///
  /// In en, this message translates to:
  /// **'Hacking Laptop'**
  String get toolHackingLaptop;

  /// No description provided for @toolCounterfeitingKit.
  ///
  /// In en, this message translates to:
  /// **'Counterfeiting Kit'**
  String get toolCounterfeitingKit;

  /// No description provided for @toolRope.
  ///
  /// In en, this message translates to:
  /// **'Rope'**
  String get toolRope;

  /// No description provided for @toolSilencer.
  ///
  /// In en, this message translates to:
  /// **'Silencer'**
  String get toolSilencer;

  /// No description provided for @toolNightVision.
  ///
  /// In en, this message translates to:
  /// **'Night Vision'**
  String get toolNightVision;

  /// No description provided for @toolGpsJammer.
  ///
  /// In en, this message translates to:
  /// **'GPS Jammer'**
  String get toolGpsJammer;

  /// No description provided for @toolBurnerPhone.
  ///
  /// In en, this message translates to:
  /// **'Burner Phone'**
  String get toolBurnerPhone;

  /// No description provided for @crimeOutcomeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crime successful!'**
  String get crimeOutcomeSuccess;

  /// No description provided for @crimeOutcomeCaught.
  ///
  /// In en, this message translates to:
  /// **'Caught by police'**
  String get crimeOutcomeCaught;

  /// No description provided for @crimeOutcomeVehicleBreakdownBefore.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle broke down before reaching the crime scene'**
  String get crimeOutcomeVehicleBreakdownBefore;

  /// No description provided for @crimeOutcomeVehicleBreakdownDuring.
  ///
  /// In en, this message translates to:
  /// **'Vehicle broke down during escape - abandoned most loot'**
  String get crimeOutcomeVehicleBreakdownDuring;

  /// No description provided for @crimeOutcomeOutOfFuel.
  ///
  /// In en, this message translates to:
  /// **'Ran out of fuel during escape - fled on foot, lost loot and vehicle'**
  String get crimeOutcomeOutOfFuel;

  /// No description provided for @crimeOutcomeToolBroke.
  ///
  /// In en, this message translates to:
  /// **'Your tool broke during the crime, leaving evidence'**
  String get crimeOutcomeToolBroke;

  /// No description provided for @crimeOutcomeFledNoLoot.
  ///
  /// In en, this message translates to:
  /// **'Fled the scene without loot'**
  String get crimeOutcomeFledNoLoot;

  /// No description provided for @vehicleCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get vehicleCondition;

  /// No description provided for @vehicleFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get vehicleFuel;

  /// No description provided for @vehicleSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get vehicleSpeed;

  /// No description provided for @vehicleArmor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get vehicleArmor;

  /// No description provided for @vehicleStealth.
  ///
  /// In en, this message translates to:
  /// **'Stealth'**
  String get vehicleStealth;

  /// No description provided for @vehicleCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get vehicleCargo;

  /// No description provided for @vehicleRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get vehicleRepair;

  /// No description provided for @vehicleRefuel.
  ///
  /// In en, this message translates to:
  /// **'Refuel'**
  String get vehicleRefuel;

  /// No description provided for @selectCrimeVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle for Crimes'**
  String get selectCrimeVehicle;

  /// No description provided for @noVehicleSelected.
  ///
  /// In en, this message translates to:
  /// **'No vehicle selected'**
  String get noVehicleSelected;

  /// No description provided for @selectedVehicle.
  ///
  /// In en, this message translates to:
  /// **'Crime Vehicle'**
  String get selectedVehicle;

  /// No description provided for @changeVehicle.
  ///
  /// In en, this message translates to:
  /// **'Change Vehicle'**
  String get changeVehicle;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// No description provided for @vehicleConditionLow.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Condition Low'**
  String get vehicleConditionLow;

  /// No description provided for @vehicleFuelLow.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Fuel Low'**
  String get vehicleFuelLow;

  /// No description provided for @vehicleSelectedForCrimes.
  ///
  /// In en, this message translates to:
  /// **'Vehicle selected for crimes!'**
  String get vehicleSelectedForCrimes;

  /// No description provided for @vehicleDeselectedForCrimes.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deselected for crimes!'**
  String get vehicleDeselectedForCrimes;

  /// No description provided for @vehicleWrongCountry.
  ///
  /// In en, this message translates to:
  /// **'Vehicle must be in the same country as you'**
  String get vehicleWrongCountry;

  /// No description provided for @failedSelectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Failed to select vehicle'**
  String get failedSelectVehicle;

  /// No description provided for @failedDeselectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Failed to deselect vehicle'**
  String get failedDeselectVehicle;

  /// No description provided for @selectedForCrimesBadge.
  ///
  /// In en, this message translates to:
  /// **'Selected for crimes'**
  String get selectedForCrimesBadge;

  /// No description provided for @selectedButton.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedButton;

  /// No description provided for @selectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectButton;

  /// No description provided for @deselectButton.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselectButton;

  /// No description provided for @prostitutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prostitution'**
  String get prostitutionTitle;

  /// No description provided for @prostitutionTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get prostitutionTotal;

  /// No description provided for @prostitutionStreet.
  ///
  /// In en, this message translates to:
  /// **'On Street'**
  String get prostitutionStreet;

  /// No description provided for @prostitutionRedLight.
  ///
  /// In en, this message translates to:
  /// **'Red Light'**
  String get prostitutionRedLight;

  /// No description provided for @prostitutionPotentialEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get prostitutionPotentialEarnings;

  /// No description provided for @prostitutionCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get prostitutionCollect;

  /// No description provided for @prostitutionRecruit.
  ///
  /// In en, this message translates to:
  /// **'Recruit'**
  String get prostitutionRecruit;

  /// No description provided for @prostitutionMyProstitutes.
  ///
  /// In en, this message translates to:
  /// **'My Prostitutes'**
  String get prostitutionMyProstitutes;

  /// No description provided for @prostitutionRedLightDistricts.
  ///
  /// In en, this message translates to:
  /// **'Red Light Districts'**
  String get prostitutionRedLightDistricts;

  /// No description provided for @prostitutionNoProstitutes.
  ///
  /// In en, this message translates to:
  /// **'No prostitutes recruited yet'**
  String get prostitutionNoProstitutes;

  /// No description provided for @prostitutionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get prostitutionLocation;

  /// No description provided for @prostitutionMoveToRedLight.
  ///
  /// In en, this message translates to:
  /// **'Move to Red Light'**
  String get prostitutionMoveToRedLight;

  /// No description provided for @prostitutionMoveToRldShort.
  ///
  /// In en, this message translates to:
  /// **'To RLD'**
  String get prostitutionMoveToRldShort;

  /// No description provided for @prostitutionMoveToStreet.
  ///
  /// In en, this message translates to:
  /// **'Move to Street'**
  String get prostitutionMoveToStreet;

  /// No description provided for @prostitutionViewDistricts.
  ///
  /// In en, this message translates to:
  /// **'View Districts'**
  String get prostitutionViewDistricts;

  /// No description provided for @prostitutionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get prostitutionAvailable;

  /// No description provided for @prostitutionMyDistricts.
  ///
  /// In en, this message translates to:
  /// **'My Districts'**
  String get prostitutionMyDistricts;

  /// No description provided for @prostitutionCurrentRLD.
  ///
  /// In en, this message translates to:
  /// **'Current RLD'**
  String get prostitutionCurrentRLD;

  /// No description provided for @prostitutionMyRLDs.
  ///
  /// In en, this message translates to:
  /// **'My RLDs'**
  String get prostitutionMyRLDs;

  /// No description provided for @prostitutionNoAvailableDistricts.
  ///
  /// In en, this message translates to:
  /// **'No districts available'**
  String get prostitutionNoAvailableDistricts;

  /// No description provided for @prostitutionNoOwnedDistricts.
  ///
  /// In en, this message translates to:
  /// **'You don\'t own any districts yet'**
  String get prostitutionNoOwnedDistricts;

  /// No description provided for @prostitutionRooms.
  ///
  /// In en, this message translates to:
  /// **'rooms'**
  String get prostitutionRooms;

  /// No description provided for @prostitutionOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get prostitutionOccupancy;

  /// No description provided for @prostitutionIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get prostitutionIncome;

  /// No description provided for @prostitutionTenants.
  ///
  /// In en, this message translates to:
  /// **'Tenants'**
  String get prostitutionTenants;

  /// No description provided for @prostitutionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get prostitutionBuy;

  /// No description provided for @prostitutionManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get prostitutionManage;

  /// No description provided for @prostitutionPurchaseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy District'**
  String get prostitutionPurchaseConfirmTitle;

  /// No description provided for @prostitutionPurchaseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to buy the Red Light District in {country} for €{price}?'**
  String prostitutionPurchaseConfirmMessage(String country, int price);

  /// No description provided for @prostitutionPurchase.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get prostitutionPurchase;

  /// No description provided for @prostitutionPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'District purchased successfully!'**
  String get prostitutionPurchaseSuccess;

  /// No description provided for @prostitutionPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get prostitutionPurchaseFailed;

  /// No description provided for @prostitutionDistrictManagement.
  ///
  /// In en, this message translates to:
  /// **'District Management'**
  String get prostitutionDistrictManagement;

  /// No description provided for @prostitutionDistrictNotFound.
  ///
  /// In en, this message translates to:
  /// **'District not found'**
  String get prostitutionDistrictNotFound;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @prostitutionMoveToStreetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to move {name} from the Red Light District to the street?'**
  String prostitutionMoveToStreetConfirm(String name);

  /// No description provided for @prostitutionMoveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully moved'**
  String get prostitutionMoveSuccess;

  /// No description provided for @prostitutionMoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Move failed'**
  String get prostitutionMoveFailed;

  /// No description provided for @prostitutionNoStreetProstitutes.
  ///
  /// In en, this message translates to:
  /// **'No prostitutes available on the street'**
  String get prostitutionNoStreetProstitutes;

  /// No description provided for @prostitutionSelectProstitute.
  ///
  /// In en, this message translates to:
  /// **'Select Prostitute'**
  String get prostitutionSelectProstitute;

  /// No description provided for @prostitutionOnStreet.
  ///
  /// In en, this message translates to:
  /// **'On street'**
  String get prostitutionOnStreet;

  /// No description provided for @prostitutionRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get prostitutionRoom;

  /// No description provided for @prostitutionInRedLight.
  ///
  /// In en, this message translates to:
  /// **'In Red Light District'**
  String get prostitutionInRedLight;

  /// No description provided for @prostitutionEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get prostitutionEarnings;

  /// No description provided for @prostitutionRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get prostitutionRent;

  /// No description provided for @prostitutionNetIncome.
  ///
  /// In en, this message translates to:
  /// **'Net Income'**
  String get prostitutionNetIncome;

  /// No description provided for @prostitutionLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get prostitutionLevel;

  /// No description provided for @prostitutionXpToNext.
  ///
  /// In en, this message translates to:
  /// **'XP to next level'**
  String get prostitutionXpToNext;

  /// No description provided for @prostitutionBusted.
  ///
  /// In en, this message translates to:
  /// **'BUSTED'**
  String get prostitutionBusted;

  /// No description provided for @prostitutionBustedCount.
  ///
  /// In en, this message translates to:
  /// **'Times busted'**
  String get prostitutionBustedCount;

  /// No description provided for @prostitutionLevelBonus.
  ///
  /// In en, this message translates to:
  /// **'Level bonus'**
  String get prostitutionLevelBonus;

  /// No description provided for @prostitutionVipBonus.
  ///
  /// In en, this message translates to:
  /// **'VIP bonus: +50% earnings'**
  String get prostitutionVipBonus;

  /// No description provided for @prostitutionUpgradeTier.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Tier'**
  String get prostitutionUpgradeTier;

  /// No description provided for @prostitutionUpgradeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Security'**
  String get prostitutionUpgradeSecurity;

  /// No description provided for @prostitutionTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get prostitutionTier;

  /// No description provided for @prostitutionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get prostitutionSecurity;

  /// No description provided for @prostitutionTierBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get prostitutionTierBasic;

  /// No description provided for @prostitutionTierLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get prostitutionTierLuxury;

  /// No description provided for @prostitutionTierVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get prostitutionTierVip;

  /// No description provided for @prostitutionSecurityLevel.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get prostitutionSecurityLevel;

  /// No description provided for @prostitutionRaidChance.
  ///
  /// In en, this message translates to:
  /// **'Raid Chance'**
  String get prostitutionRaidChance;

  /// No description provided for @prostitutionMaxTier.
  ///
  /// In en, this message translates to:
  /// **'Max tier reached'**
  String get prostitutionMaxTier;

  /// No description provided for @prostitutionMaxSecurity.
  ///
  /// In en, this message translates to:
  /// **'Max security reached'**
  String get prostitutionMaxSecurity;

  /// No description provided for @prostitutionUpgradeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upgrade successful!'**
  String get prostitutionUpgradeSuccess;

  /// No description provided for @prostitutionUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade failed'**
  String get prostitutionUpgradeFailed;

  /// No description provided for @vipEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP Events'**
  String get vipEventsTitle;

  /// No description provided for @vipEventsTabTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP Events'**
  String get vipEventsTabTitle;

  /// No description provided for @vipEventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Assign prostitutes to VIP events for bonus earnings!'**
  String get vipEventsDescription;

  /// No description provided for @vipEventsActive.
  ///
  /// In en, this message translates to:
  /// **'Active Events'**
  String get vipEventsActive;

  /// No description provided for @vipEventsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get vipEventsUpcoming;

  /// No description provided for @vipEventsMyParticipations.
  ///
  /// In en, this message translates to:
  /// **'My Active Participations'**
  String get vipEventsMyParticipations;

  /// No description provided for @vipEventTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP Event'**
  String get vipEventTypeTitle;

  /// No description provided for @vipEventCelebrity.
  ///
  /// In en, this message translates to:
  /// **'Celebrity Visit'**
  String get vipEventCelebrity;

  /// No description provided for @vipEventBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor Party'**
  String get vipEventBachelor;

  /// No description provided for @vipEventConvention.
  ///
  /// In en, this message translates to:
  /// **'Convention'**
  String get vipEventConvention;

  /// No description provided for @vipEventFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get vipEventFestival;

  /// No description provided for @vipEventBonus.
  ///
  /// In en, this message translates to:
  /// **'BONUS'**
  String get vipEventBonus;

  /// No description provided for @vipEventSpots.
  ///
  /// In en, this message translates to:
  /// **'spots'**
  String get vipEventSpots;

  /// No description provided for @vipEventParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get vipEventParticipants;

  /// No description provided for @vipEventFull.
  ///
  /// In en, this message translates to:
  /// **'EVENT FULL'**
  String get vipEventFull;

  /// No description provided for @vipEventRequires.
  ///
  /// In en, this message translates to:
  /// **'Requires'**
  String get vipEventRequires;

  /// No description provided for @vipEventLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get vipEventLevel;

  /// No description provided for @vipEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get vipEventLocation;

  /// No description provided for @vipEventEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get vipEventEndsIn;

  /// No description provided for @vipEventStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in'**
  String get vipEventStartsIn;

  /// No description provided for @vipEventNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active events at the moment'**
  String get vipEventNoActive;

  /// No description provided for @vipEventNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get vipEventNoUpcoming;

  /// No description provided for @vipEventAssignProstitute.
  ///
  /// In en, this message translates to:
  /// **'Assign Prostitute'**
  String get vipEventAssignProstitute;

  /// No description provided for @vipEventAssignDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get vipEventAssignDialogTitle;

  /// No description provided for @vipEventNoEligible.
  ///
  /// In en, this message translates to:
  /// **'No eligible prostitutes. Need level {level}+ in {country}'**
  String vipEventNoEligible(int level, String country);

  /// No description provided for @vipEventJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined event!'**
  String get vipEventJoinSuccess;

  /// No description provided for @vipEventJoinFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to join event'**
  String get vipEventJoinFailed;

  /// No description provided for @vipEventLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave Event'**
  String get vipEventLeave;

  /// No description provided for @vipEventLeaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Left event'**
  String get vipEventLeaveSuccess;

  /// No description provided for @vipEventLeaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not leave event'**
  String get vipEventLeaveFailed;

  /// No description provided for @vipEventAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get vipEventAssigned;

  /// No description provided for @vipEventPerHour.
  ///
  /// In en, this message translates to:
  /// **'/hour'**
  String get vipEventPerHour;

  /// No description provided for @vipEventEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get vipEventEarnings;

  /// No description provided for @prostitutionLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Prostitution Leaderboard'**
  String get prostitutionLeaderboardTitle;

  /// No description provided for @prostitutionLeaderboardWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get prostitutionLeaderboardWeekly;

  /// No description provided for @prostitutionLeaderboardMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get prostitutionLeaderboardMonthly;

  /// No description provided for @prostitutionLeaderboardAllTime.
  ///
  /// In en, this message translates to:
  /// **'All-Time'**
  String get prostitutionLeaderboardAllTime;

  /// No description provided for @prostitutionLeaderboardYourRank.
  ///
  /// In en, this message translates to:
  /// **'Your Weekly Rank'**
  String get prostitutionLeaderboardYourRank;

  /// No description provided for @prostitutionLeaderboardUnranked.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get prostitutionLeaderboardUnranked;

  /// No description provided for @prostitutionLeaderboardNoData.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data yet'**
  String get prostitutionLeaderboardNoData;

  /// No description provided for @prostitutionLeaderboardButton.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get prostitutionLeaderboardButton;

  /// No description provided for @prostitutionRivalryButton.
  ///
  /// In en, this message translates to:
  /// **'Rivalry'**
  String get prostitutionRivalryButton;

  /// No description provided for @prostitutionLeaderboardAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get prostitutionLeaderboardAchievements;

  /// No description provided for @prostitutionLeaderboardLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load leaderboard'**
  String get prostitutionLeaderboardLoadFailed;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} unlocked'**
  String achievementsProgress(int unlocked, int total);

  /// No description provided for @achievementsCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get achievementsCategoryAll;

  /// No description provided for @achievementsCategoryProgression.
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get achievementsCategoryProgression;

  /// No description provided for @achievementsCategoryWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get achievementsCategoryWealth;

  /// No description provided for @achievementsCategoryPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get achievementsCategoryPower;

  /// No description provided for @achievementsCategorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get achievementsCategorySocial;

  /// No description provided for @achievementsCategoryMastery.
  ///
  /// In en, this message translates to:
  /// **'Mastery'**
  String get achievementsCategoryMastery;

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get achievementLocked;

  /// No description provided for @achievementReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get achievementReward;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get achievementUnlocked;

  /// No description provided for @achievementNoData.
  ///
  /// In en, this message translates to:
  /// **'No achievements found'**
  String get achievementNoData;

  /// No description provided for @achievementLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load achievements'**
  String get achievementLoadFailed;

  /// No description provided for @achievementsMoney.
  ///
  /// In en, this message translates to:
  /// **'€{amount}'**
  String achievementsMoney(String amount);

  /// No description provided for @achievementsXp.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String achievementsXp(String xp);

  /// No description provided for @achievementsUnlockedDate.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String achievementsUnlockedDate(String date);

  /// No description provided for @achievementsDetailProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {current}/{required}'**
  String achievementsDetailProgress(int current, int required);

  /// No description provided for @achievementsNoRewardConfigured.
  ///
  /// In en, this message translates to:
  /// **'No reward configured yet'**
  String get achievementsNoRewardConfigured;

  /// No description provided for @achievementsRewardOnUnlock.
  ///
  /// In en, this message translates to:
  /// **'You receive this reward once the achievement is unlocked.'**
  String get achievementsRewardOnUnlock;

  /// No description provided for @achievementsDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get achievementsDateToday;

  /// No description provided for @achievementsDateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get achievementsDateYesterday;

  /// No description provided for @achievementsDateDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String achievementsDateDaysAgo(int days);

  /// No description provided for @achievementsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get achievementsDetails;

  /// No description provided for @achievementsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get achievementsCategory;

  /// No description provided for @achievementJobItSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'IT Specialist'**
  String get achievementJobItSpecialistTitle;

  /// No description provided for @achievementJobItSpecialistDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Programmer'**
  String get achievementJobItSpecialistDescription;

  /// No description provided for @achievementJobLawyerTitle.
  ///
  /// In en, this message translates to:
  /// **'Street Lawyer'**
  String get achievementJobLawyerTitle;

  /// No description provided for @achievementJobLawyerDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Lawyer'**
  String get achievementJobLawyerDescription;

  /// No description provided for @achievementJobDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Underground Doctor'**
  String get achievementJobDoctorTitle;

  /// No description provided for @achievementJobDoctorDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Doctor'**
  String get achievementJobDoctorDescription;

  /// No description provided for @achievementSchoolCertifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Certified Student'**
  String get achievementSchoolCertifiedTitle;

  /// No description provided for @achievementSchoolCertifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'Earn 3 school certifications'**
  String get achievementSchoolCertifiedDescription;

  /// No description provided for @achievementSchoolMultiCertifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Certified'**
  String get achievementSchoolMultiCertifiedTitle;

  /// No description provided for @achievementSchoolMultiCertifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'Earn 6 school certifications'**
  String get achievementSchoolMultiCertifiedDescription;

  /// No description provided for @achievementSchoolTrackSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Specialist'**
  String get achievementSchoolTrackSpecialistTitle;

  /// No description provided for @achievementSchoolTrackSpecialistDescription.
  ///
  /// In en, this message translates to:
  /// **'Max out 3 school tracks'**
  String get achievementSchoolTrackSpecialistDescription;

  /// No description provided for @schoolMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolMenuLabel;

  /// No description provided for @schoolMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Level your education and certifications'**
  String get schoolMenuSubtitle;

  /// No description provided for @schoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School & Education'**
  String get schoolTitle;

  /// No description provided for @schoolIntro.
  ///
  /// In en, this message translates to:
  /// **'Unlock jobs and assets through levels and certifications.'**
  String get schoolIntro;

  /// No description provided for @schoolTracksTitle.
  ///
  /// In en, this message translates to:
  /// **'Available educations'**
  String get schoolTracksTitle;

  /// No description provided for @schoolUnlockableContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Locked educations'**
  String get schoolUnlockableContentTitle;

  /// No description provided for @schoolOverallLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'School level: {level}'**
  String schoolOverallLevelLabel(int level);

  /// No description provided for @schoolLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load school data: {error}'**
  String schoolLoadError(String error);

  /// No description provided for @schoolTrackLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Lv {current}/{max}'**
  String schoolTrackLevelLabel(int current, int max);

  /// No description provided for @schoolXpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP: {xp}'**
  String schoolXpLabel(int xp);

  /// No description provided for @schoolCertificationRequiredLevel.
  ///
  /// In en, this message translates to:
  /// **'{name} (Lv {level})'**
  String schoolCertificationRequiredLevel(String name, int level);

  /// No description provided for @schoolGateStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'OPEN'**
  String get schoolGateStatusOpen;

  /// No description provided for @schoolGateStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get schoolGateStatusLocked;

  /// No description provided for @schoolGateRankProgress.
  ///
  /// In en, this message translates to:
  /// **'Player rank: {current}/{required}'**
  String schoolGateRankProgress(int current, int required);

  /// No description provided for @schoolGateTrackLevelProgress.
  ///
  /// In en, this message translates to:
  /// **'{track} level: {current}/{required}'**
  String schoolGateTrackLevelProgress(String track, int current, int required);

  /// No description provided for @schoolGateJobTarget.
  ///
  /// In en, this message translates to:
  /// **'Job: {target}'**
  String schoolGateJobTarget(String target);

  /// No description provided for @schoolGateAssetCasinoPurchase.
  ///
  /// In en, this message translates to:
  /// **'Asset: Casino purchase'**
  String get schoolGateAssetCasinoPurchase;

  /// No description provided for @schoolGateAssetAmmoFactoryPurchase.
  ///
  /// In en, this message translates to:
  /// **'Asset: Ammo factory purchase'**
  String get schoolGateAssetAmmoFactoryPurchase;

  /// No description provided for @schoolGateAssetAmmoOutputUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Asset: Ammo output upgrade'**
  String get schoolGateAssetAmmoOutputUpgrade;

  /// No description provided for @schoolGateAssetAmmoQualityUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Asset: Ammo quality upgrade'**
  String get schoolGateAssetAmmoQualityUpgrade;

  /// No description provided for @schoolGateAssetGeneric.
  ///
  /// In en, this message translates to:
  /// **'Asset: {target}'**
  String schoolGateAssetGeneric(String target);

  /// No description provided for @schoolGateSystemGeneric.
  ///
  /// In en, this message translates to:
  /// **'{type}: {target}'**
  String schoolGateSystemGeneric(String type, String target);

  /// No description provided for @educationDialogDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Education required'**
  String get educationDialogDefaultTitle;

  /// No description provided for @educationDialogFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Requirements not met. Complete education requirements to continue.'**
  String get educationDialogFallbackMessage;

  /// No description provided for @educationDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get educationDialogClose;

  /// No description provided for @educationLockedJobsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Locked jobs (education required)'**
  String get educationLockedJobsSectionTitle;

  /// No description provided for @educationAmmoOutputUpgradeLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Output upgrade locked'**
  String get educationAmmoOutputUpgradeLockedTitle;

  /// No description provided for @educationAmmoQualityUpgradeLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Quality upgrade locked'**
  String get educationAmmoQualityUpgradeLockedTitle;

  /// No description provided for @educationAmmoFactoryPurchaseLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Factory purchase locked'**
  String get educationAmmoFactoryPurchaseLockedTitle;

  /// No description provided for @educationRequirementRankProgress.
  ///
  /// In en, this message translates to:
  /// **'Need player rank {requiredRank} · Current player rank {currentRank}'**
  String educationRequirementRankProgress(int requiredRank, int currentRank);

  /// No description provided for @educationRequirementTrackLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Education level'**
  String get educationRequirementTrackLevelTitle;

  /// No description provided for @educationRequirementTrackLevelProgress.
  ///
  /// In en, this message translates to:
  /// **'{trackName} level {requiredLevel} required · Current {currentLevel}'**
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  );

  /// No description provided for @educationRequirementCertificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Certification required'**
  String get educationRequirementCertificationTitle;

  /// No description provided for @educationRequirementGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirement'**
  String get educationRequirementGenericTitle;

  /// No description provided for @educationRequirementUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown requirement'**
  String get educationRequirementUnknown;

  /// No description provided for @educationTrackNameAviation.
  ///
  /// In en, this message translates to:
  /// **'Aviation'**
  String get educationTrackNameAviation;

  /// No description provided for @educationTrackNameLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get educationTrackNameLaw;

  /// No description provided for @educationTrackNameMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get educationTrackNameMedicine;

  /// No description provided for @educationTrackNameFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get educationTrackNameFinance;

  /// No description provided for @educationTrackNameEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get educationTrackNameEngineering;

  /// No description provided for @educationTrackNameIt.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get educationTrackNameIt;

  /// No description provided for @schoolTrackDescriptionAviation.
  ///
  /// In en, this message translates to:
  /// **'Flight theory, navigation, and aircraft operation.'**
  String get schoolTrackDescriptionAviation;

  /// No description provided for @schoolTrackDescriptionLaw.
  ///
  /// In en, this message translates to:
  /// **'Criminal law, procedure, and courtroom practice.'**
  String get schoolTrackDescriptionLaw;

  /// No description provided for @schoolTrackDescriptionMedicine.
  ///
  /// In en, this message translates to:
  /// **'Emergency response, diagnostics, and medical practice.'**
  String get schoolTrackDescriptionMedicine;

  /// No description provided for @schoolTrackDescriptionFinance.
  ///
  /// In en, this message translates to:
  /// **'Accounting, investment, and business operations.'**
  String get schoolTrackDescriptionFinance;

  /// No description provided for @schoolTrackDescriptionEngineering.
  ///
  /// In en, this message translates to:
  /// **'Mechanical systems, industrial safety, and manufacturing.'**
  String get schoolTrackDescriptionEngineering;

  /// No description provided for @schoolTrackDescriptionIt.
  ///
  /// In en, this message translates to:
  /// **'Software development, systems, and network operations.'**
  String get schoolTrackDescriptionIt;

  /// No description provided for @schoolTrackCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Cooldown active: {seconds}s remaining'**
  String schoolTrackCooldownActive(int seconds);

  /// No description provided for @schoolTrackMaxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Track is already at max level'**
  String get schoolTrackMaxLevelReached;

  /// No description provided for @schoolTrackStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start training'**
  String get schoolTrackStartFailed;

  /// No description provided for @educationCertSoftwareEngineer.
  ///
  /// In en, this message translates to:
  /// **'Software Engineer Certification'**
  String get educationCertSoftwareEngineer;

  /// No description provided for @educationCertBarExam.
  ///
  /// In en, this message translates to:
  /// **'Bar Exam'**
  String get educationCertBarExam;

  /// No description provided for @educationCertMedicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Medical License'**
  String get educationCertMedicalLicense;

  /// No description provided for @educationCertFlightCommercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial Flight License'**
  String get educationCertFlightCommercial;

  /// No description provided for @educationCertFlightBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Flight License'**
  String get educationCertFlightBasic;

  /// No description provided for @educationCertIndustrialSafety.
  ///
  /// In en, this message translates to:
  /// **'Industrial Safety Certification'**
  String get educationCertIndustrialSafety;

  /// No description provided for @educationCertFinancialAnalyst.
  ///
  /// In en, this message translates to:
  /// **'Financial Analyst Certification'**
  String get educationCertFinancialAnalyst;

  /// No description provided for @educationCertCasinoManagement.
  ///
  /// In en, this message translates to:
  /// **'Casino Management Certification'**
  String get educationCertCasinoManagement;

  /// No description provided for @educationCertParamedic.
  ///
  /// In en, this message translates to:
  /// **'Paramedic Certification'**
  String get educationCertParamedic;

  /// No description provided for @prostitutionLeaderboardProstitutesUnit.
  ///
  /// In en, this message translates to:
  /// **'prostitutes'**
  String get prostitutionLeaderboardProstitutesUnit;

  /// No description provided for @prostitutionLeaderboardDistrictsUnit.
  ///
  /// In en, this message translates to:
  /// **'districts'**
  String get prostitutionLeaderboardDistrictsUnit;

  /// No description provided for @rivalryTitle.
  ///
  /// In en, this message translates to:
  /// **'Rivalry'**
  String get rivalryTitle;

  /// No description provided for @rivalryChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge Player'**
  String get rivalryChallengeTitle;

  /// No description provided for @rivalryChallengeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a player ID to start a rivalry.'**
  String get rivalryChallengeHint;

  /// No description provided for @rivalryPlayerIdHint.
  ///
  /// In en, this message translates to:
  /// **'Player ID'**
  String get rivalryPlayerIdHint;

  /// No description provided for @rivalryStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get rivalryStartButton;

  /// No description provided for @rivalryNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active rivalries yet.'**
  String get rivalryNoActive;

  /// No description provided for @rivalryActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Rivals'**
  String get rivalryActiveTitle;

  /// No description provided for @rivalryScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Rivalry score'**
  String get rivalryScoreLabel;

  /// No description provided for @rivalryRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get rivalryRecentActivity;

  /// No description provided for @rivalryNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No sabotage activity yet'**
  String get rivalryNoActivity;

  /// No description provided for @rivalryCooldownReady.
  ///
  /// In en, this message translates to:
  /// **'Sabotage ready'**
  String get rivalryCooldownReady;

  /// No description provided for @rivalryCooldownIn.
  ///
  /// In en, this message translates to:
  /// **'Cooldown: {duration}'**
  String rivalryCooldownIn(String duration);

  /// No description provided for @rivalryActionTipPolice.
  ///
  /// In en, this message translates to:
  /// **'Tip Police (€5k)'**
  String get rivalryActionTipPolice;

  /// No description provided for @rivalryActionStealCustomer.
  ///
  /// In en, this message translates to:
  /// **'Steal Customer (€3k)'**
  String get rivalryActionStealCustomer;

  /// No description provided for @rivalryActionDamageReputation.
  ///
  /// In en, this message translates to:
  /// **'Damage Reputation (€10k)'**
  String get rivalryActionDamageReputation;

  /// No description provided for @rivalryActionBribeEmployee.
  ///
  /// In en, this message translates to:
  /// **'Bribe Employee (€8k)'**
  String get rivalryActionBribeEmployee;

  /// No description provided for @rivalryUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'Rivalry updated'**
  String get rivalryUpdateMessage;

  /// No description provided for @rivalrySabotageExecuted.
  ///
  /// In en, this message translates to:
  /// **'Sabotage executed'**
  String get rivalrySabotageExecuted;

  /// No description provided for @rivalryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm sabotage'**
  String get rivalryConfirmTitle;

  /// No description provided for @rivalryConfirmTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: {username}'**
  String rivalryConfirmTarget(String username);

  /// No description provided for @rivalryConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Action: {action}'**
  String rivalryConfirmAction(String action);

  /// No description provided for @rivalryConfirmCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: €{amount}'**
  String rivalryConfirmCost(int amount);

  /// No description provided for @rivalryConfirmEffect.
  ///
  /// In en, this message translates to:
  /// **'Effect: {effect}'**
  String rivalryConfirmEffect(String effect);

  /// No description provided for @rivalryConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'Success is not guaranteed and you can lose money.'**
  String get rivalryConfirmWarning;

  /// No description provided for @rivalryExecuteButton.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get rivalryExecuteButton;

  /// No description provided for @rivalryEffectTipPolice.
  ///
  /// In en, this message translates to:
  /// **'Increase rival police pressure'**
  String get rivalryEffectTipPolice;

  /// No description provided for @rivalryEffectStealCustomer.
  ///
  /// In en, this message translates to:
  /// **'Steal part of rival cashflow'**
  String get rivalryEffectStealCustomer;

  /// No description provided for @rivalryEffectDamageReputation.
  ///
  /// In en, this message translates to:
  /// **'Lower rival prostitute progress'**
  String get rivalryEffectDamageReputation;

  /// No description provided for @rivalryEffectBribeEmployee.
  ///
  /// In en, this message translates to:
  /// **'Force one rival prostitute into busted state'**
  String get rivalryEffectBribeEmployee;

  /// No description provided for @prostitutionUnderAttackTitle.
  ///
  /// In en, this message translates to:
  /// **'Your empire is under attack'**
  String get prostitutionUnderAttackTitle;

  /// No description provided for @prostitutionUnderAttackBody.
  ///
  /// In en, this message translates to:
  /// **'{attacker} used {action} against you in the last 24h.'**
  String prostitutionUnderAttackBody(String attacker, String action);

  /// No description provided for @prostitutionUnderAttackAction.
  ///
  /// In en, this message translates to:
  /// **'Open rivalry'**
  String get prostitutionUnderAttackAction;

  /// No description provided for @rivalryProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Protection Insurance'**
  String get rivalryProtectionTitle;

  /// No description provided for @rivalryProtectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduces incoming sabotage impact by 30% for 7 days.'**
  String get rivalryProtectionDescription;

  /// No description provided for @rivalryProtectionInactive.
  ///
  /// In en, this message translates to:
  /// **'No active protection'**
  String get rivalryProtectionInactive;

  /// No description provided for @rivalryProtectionActive.
  ///
  /// In en, this message translates to:
  /// **'Active until: {date}'**
  String rivalryProtectionActive(String date);

  /// No description provided for @rivalryProtectionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy protection (€25k/week)'**
  String get rivalryProtectionBuy;

  /// No description provided for @rivalryProtectionActivated.
  ///
  /// In en, this message translates to:
  /// **'Protection insurance activated'**
  String get rivalryProtectionActivated;

  /// No description provided for @achievementTitle_first_steps.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get achievementTitle_first_steps;

  /// No description provided for @achievementDescription_first_steps.
  ///
  /// In en, this message translates to:
  /// **'Recruit your first prostitute'**
  String get achievementDescription_first_steps;

  /// No description provided for @achievementTitle_growing_empire.
  ///
  /// In en, this message translates to:
  /// **'Growing Empire'**
  String get achievementTitle_growing_empire;

  /// No description provided for @achievementDescription_growing_empire.
  ///
  /// In en, this message translates to:
  /// **'Recruit 5 prostitutes'**
  String get achievementDescription_growing_empire;

  /// No description provided for @achievementTitle_first_district.
  ///
  /// In en, this message translates to:
  /// **'First District'**
  String get achievementTitle_first_district;

  /// No description provided for @achievementDescription_first_district.
  ///
  /// In en, this message translates to:
  /// **'Purchase your first red light district'**
  String get achievementDescription_first_district;

  /// No description provided for @achievementTitle_empire_builder.
  ///
  /// In en, this message translates to:
  /// **'Empire Builder'**
  String get achievementTitle_empire_builder;

  /// No description provided for @achievementDescription_empire_builder.
  ///
  /// In en, this message translates to:
  /// **'Own 5 red light districts'**
  String get achievementDescription_empire_builder;

  /// No description provided for @achievementTitle_district_master.
  ///
  /// In en, this message translates to:
  /// **'District Master'**
  String get achievementTitle_district_master;

  /// No description provided for @achievementDescription_district_master.
  ///
  /// In en, this message translates to:
  /// **'Own 10 red light districts'**
  String get achievementDescription_district_master;

  /// No description provided for @achievementTitle_leveling_master.
  ///
  /// In en, this message translates to:
  /// **'Leveling Master'**
  String get achievementTitle_leveling_master;

  /// No description provided for @achievementDescription_leveling_master.
  ///
  /// In en, this message translates to:
  /// **'Max out a prostitute to level 10'**
  String get achievementDescription_leveling_master;

  /// No description provided for @achievementTitle_untouchable.
  ///
  /// In en, this message translates to:
  /// **'Untouchable'**
  String get achievementTitle_untouchable;

  /// No description provided for @achievementDescription_untouchable.
  ///
  /// In en, this message translates to:
  /// **'Never get busted for 7 consecutive days'**
  String get achievementDescription_untouchable;

  /// No description provided for @achievementTitle_millionaire.
  ///
  /// In en, this message translates to:
  /// **'Millionaire'**
  String get achievementTitle_millionaire;

  /// No description provided for @achievementDescription_millionaire.
  ///
  /// In en, this message translates to:
  /// **'Accumulate €1,000,000 total earnings'**
  String get achievementDescription_millionaire;

  /// No description provided for @achievementTitle_high_roller.
  ///
  /// In en, this message translates to:
  /// **'High Roller'**
  String get achievementTitle_high_roller;

  /// No description provided for @achievementDescription_high_roller.
  ///
  /// In en, this message translates to:
  /// **'Accumulate €5,000,000 total earnings'**
  String get achievementDescription_high_roller;

  /// No description provided for @achievementTitle_vip_service.
  ///
  /// In en, this message translates to:
  /// **'VIP Service'**
  String get achievementTitle_vip_service;

  /// No description provided for @achievementDescription_vip_service.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 VIP events'**
  String get achievementDescription_vip_service;

  /// No description provided for @achievementTitle_event_enthusiast.
  ///
  /// In en, this message translates to:
  /// **'Event Enthusiast'**
  String get achievementTitle_event_enthusiast;

  /// No description provided for @achievementDescription_event_enthusiast.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 VIP events'**
  String get achievementDescription_event_enthusiast;

  /// No description provided for @achievementTitle_security_expert.
  ///
  /// In en, this message translates to:
  /// **'Security Expert'**
  String get achievementTitle_security_expert;

  /// No description provided for @achievementDescription_security_expert.
  ///
  /// In en, this message translates to:
  /// **'Maximize security level on all owned districts'**
  String get achievementDescription_security_expert;

  /// No description provided for @achievementTitle_luxury_provider.
  ///
  /// In en, this message translates to:
  /// **'Luxury Provider'**
  String get achievementTitle_luxury_provider;

  /// No description provided for @achievementDescription_luxury_provider.
  ///
  /// In en, this message translates to:
  /// **'Upgrade 3 districts to VIP tier'**
  String get achievementDescription_luxury_provider;

  /// No description provided for @achievementTitle_rivalry_victor.
  ///
  /// In en, this message translates to:
  /// **'Rivalry Victor'**
  String get achievementTitle_rivalry_victor;

  /// No description provided for @achievementDescription_rivalry_victor.
  ///
  /// In en, this message translates to:
  /// **'Successfully sabotage rivals 10 times'**
  String get achievementDescription_rivalry_victor;

  /// No description provided for @achievementTitle_untouchable_rival.
  ///
  /// In en, this message translates to:
  /// **'Untouchable Rival'**
  String get achievementTitle_untouchable_rival;

  /// No description provided for @achievementDescription_untouchable_rival.
  ///
  /// In en, this message translates to:
  /// **'Defend against 20 sabotage attempts'**
  String get achievementDescription_untouchable_rival;

  /// No description provided for @achievementTitle_crime_first_blood.
  ///
  /// In en, this message translates to:
  /// **'Crime First Blood'**
  String get achievementTitle_crime_first_blood;

  /// No description provided for @achievementDescription_crime_first_blood.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete your first crime'**
  String get achievementDescription_crime_first_blood;

  /// No description provided for @achievementTitle_crime_hustler.
  ///
  /// In en, this message translates to:
  /// **'Crime Hustler'**
  String get achievementTitle_crime_hustler;

  /// No description provided for @achievementDescription_crime_hustler.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 5 crimes'**
  String get achievementDescription_crime_hustler;

  /// No description provided for @achievementTitle_crime_novice.
  ///
  /// In en, this message translates to:
  /// **'Crime Novice'**
  String get achievementTitle_crime_novice;

  /// No description provided for @achievementDescription_crime_novice.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 10 crimes'**
  String get achievementDescription_crime_novice;

  /// No description provided for @achievementTitle_crime_operator.
  ///
  /// In en, this message translates to:
  /// **'Crime Operator'**
  String get achievementTitle_crime_operator;

  /// No description provided for @achievementDescription_crime_operator.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 25 crimes'**
  String get achievementDescription_crime_operator;

  /// No description provided for @achievementTitle_crime_wave.
  ///
  /// In en, this message translates to:
  /// **'Crime Wave'**
  String get achievementTitle_crime_wave;

  /// No description provided for @achievementDescription_crime_wave.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 50 crimes'**
  String get achievementDescription_crime_wave;

  /// No description provided for @achievementTitle_crime_mastermind.
  ///
  /// In en, this message translates to:
  /// **'Crime Mastermind'**
  String get achievementTitle_crime_mastermind;

  /// No description provided for @achievementDescription_crime_mastermind.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 100 crimes'**
  String get achievementDescription_crime_mastermind;

  /// No description provided for @achievementTitle_the_godfather.
  ///
  /// In en, this message translates to:
  /// **'The Godfather'**
  String get achievementTitle_the_godfather;

  /// No description provided for @achievementDescription_the_godfather.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 250 crimes'**
  String get achievementDescription_the_godfather;

  /// No description provided for @achievementTitle_crime_emperor.
  ///
  /// In en, this message translates to:
  /// **'Crime Emperor'**
  String get achievementTitle_crime_emperor;

  /// No description provided for @achievementDescription_crime_emperor.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 500 crimes'**
  String get achievementDescription_crime_emperor;

  /// No description provided for @achievementTitle_crime_legend.
  ///
  /// In en, this message translates to:
  /// **'Crime Legend'**
  String get achievementTitle_crime_legend;

  /// No description provided for @achievementDescription_crime_legend.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 1000 crimes'**
  String get achievementDescription_crime_legend;

  /// No description provided for @achievementTitle_crime_getaway_driver.
  ///
  /// In en, this message translates to:
  /// **'Getaway Driver'**
  String get achievementTitle_crime_getaway_driver;

  /// No description provided for @achievementDescription_crime_getaway_driver.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete your first crime with a vehicle'**
  String get achievementDescription_crime_getaway_driver;

  /// No description provided for @achievementTitle_crime_armed_and_ready.
  ///
  /// In en, this message translates to:
  /// **'Armed & Ready'**
  String get achievementTitle_crime_armed_and_ready;

  /// No description provided for @achievementDescription_crime_armed_and_ready.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete your first crime that requires a weapon'**
  String get achievementDescription_crime_armed_and_ready;

  /// No description provided for @achievementTitle_crime_full_loadout.
  ///
  /// In en, this message translates to:
  /// **'Full Loadout'**
  String get achievementTitle_crime_full_loadout;

  /// No description provided for @achievementDescription_crime_full_loadout.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete a crime requiring vehicle, weapon, and tools'**
  String get achievementDescription_crime_full_loadout;

  /// No description provided for @achievementTitle_crime_completionist.
  ///
  /// In en, this message translates to:
  /// **'Crime Completionist'**
  String get achievementTitle_crime_completionist;

  /// No description provided for @achievementDescription_crime_completionist.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete every crime type at least once'**
  String get achievementDescription_crime_completionist;

  /// No description provided for @achievementTitle_job_first_shift.
  ///
  /// In en, this message translates to:
  /// **'First Shift'**
  String get achievementTitle_job_first_shift;

  /// No description provided for @achievementDescription_job_first_shift.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete your first job'**
  String get achievementDescription_job_first_shift;

  /// No description provided for @achievementTitle_job_hustler.
  ///
  /// In en, this message translates to:
  /// **'Job Hustler'**
  String get achievementTitle_job_hustler;

  /// No description provided for @achievementDescription_job_hustler.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 5 jobs'**
  String get achievementDescription_job_hustler;

  /// No description provided for @achievementTitle_job_starter.
  ///
  /// In en, this message translates to:
  /// **'Job Starter'**
  String get achievementTitle_job_starter;

  /// No description provided for @achievementDescription_job_starter.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 10 jobs'**
  String get achievementDescription_job_starter;

  /// No description provided for @achievementTitle_job_operator.
  ///
  /// In en, this message translates to:
  /// **'Job Operator'**
  String get achievementTitle_job_operator;

  /// No description provided for @achievementDescription_job_operator.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 25 jobs'**
  String get achievementDescription_job_operator;

  /// No description provided for @achievementTitle_job_grinder.
  ///
  /// In en, this message translates to:
  /// **'Job Grinder'**
  String get achievementTitle_job_grinder;

  /// No description provided for @achievementDescription_job_grinder.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 50 jobs'**
  String get achievementDescription_job_grinder;

  /// No description provided for @achievementTitle_job_master.
  ///
  /// In en, this message translates to:
  /// **'Job Master'**
  String get achievementTitle_job_master;

  /// No description provided for @achievementDescription_job_master.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 100 jobs'**
  String get achievementDescription_job_master;

  /// No description provided for @achievementTitle_job_expert.
  ///
  /// In en, this message translates to:
  /// **'Job Expert'**
  String get achievementTitle_job_expert;

  /// No description provided for @achievementDescription_job_expert.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 250 jobs'**
  String get achievementDescription_job_expert;

  /// No description provided for @achievementTitle_job_elite.
  ///
  /// In en, this message translates to:
  /// **'Job Elite'**
  String get achievementTitle_job_elite;

  /// No description provided for @achievementDescription_job_elite.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 500 jobs'**
  String get achievementDescription_job_elite;

  /// No description provided for @achievementTitle_job_legend.
  ///
  /// In en, this message translates to:
  /// **'Job Legend'**
  String get achievementTitle_job_legend;

  /// No description provided for @achievementDescription_job_legend.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete 1000 jobs'**
  String get achievementDescription_job_legend;

  /// No description provided for @achievementTitle_job_completionist.
  ///
  /// In en, this message translates to:
  /// **'Job Completionist'**
  String get achievementTitle_job_completionist;

  /// No description provided for @achievementDescription_job_completionist.
  ///
  /// In en, this message translates to:
  /// **'Successfully complete every job type at least once'**
  String get achievementDescription_job_completionist;

  /// No description provided for @achievementTitle_job_educated_worker.
  ///
  /// In en, this message translates to:
  /// **'Educated Worker'**
  String get achievementTitle_job_educated_worker;

  /// No description provided for @achievementDescription_job_educated_worker.
  ///
  /// In en, this message translates to:
  /// **'Complete 1 job that has education requirements'**
  String get achievementDescription_job_educated_worker;

  /// No description provided for @achievementTitle_job_certified_hustler.
  ///
  /// In en, this message translates to:
  /// **'Certified Hustler'**
  String get achievementTitle_job_certified_hustler;

  /// No description provided for @achievementDescription_job_certified_hustler.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 jobs with education requirements'**
  String get achievementDescription_job_certified_hustler;

  /// No description provided for @achievementTitle_job_education_completionist.
  ///
  /// In en, this message translates to:
  /// **'Education Job Completionist'**
  String get achievementTitle_job_education_completionist;

  /// No description provided for @achievementDescription_job_education_completionist.
  ///
  /// In en, this message translates to:
  /// **'Complete every education-gated job type at least once'**
  String get achievementDescription_job_education_completionist;

  /// No description provided for @achievementTitle_job_it_specialist.
  ///
  /// In en, this message translates to:
  /// **'IT Specialist'**
  String get achievementTitle_job_it_specialist;

  /// No description provided for @achievementDescription_job_it_specialist.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Programmer'**
  String get achievementDescription_job_it_specialist;

  /// No description provided for @achievementTitle_job_lawyer.
  ///
  /// In en, this message translates to:
  /// **'Street Lawyer'**
  String get achievementTitle_job_lawyer;

  /// No description provided for @achievementDescription_job_lawyer.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Lawyer'**
  String get achievementDescription_job_lawyer;

  /// No description provided for @achievementTitle_job_doctor.
  ///
  /// In en, this message translates to:
  /// **'Underground Doctor'**
  String get achievementTitle_job_doctor;

  /// No description provided for @achievementDescription_job_doctor.
  ///
  /// In en, this message translates to:
  /// **'Complete your first shift as a Doctor'**
  String get achievementDescription_job_doctor;

  /// No description provided for @achievementTitle_school_certified.
  ///
  /// In en, this message translates to:
  /// **'Certified Student'**
  String get achievementTitle_school_certified;

  /// No description provided for @achievementDescription_school_certified.
  ///
  /// In en, this message translates to:
  /// **'Earn 3 school certifications'**
  String get achievementDescription_school_certified;

  /// No description provided for @achievementTitle_school_multi_certified.
  ///
  /// In en, this message translates to:
  /// **'Multi-Certified'**
  String get achievementTitle_school_multi_certified;

  /// No description provided for @achievementDescription_school_multi_certified.
  ///
  /// In en, this message translates to:
  /// **'Earn 6 school certifications'**
  String get achievementDescription_school_multi_certified;

  /// No description provided for @achievementTitle_school_track_specialist.
  ///
  /// In en, this message translates to:
  /// **'Track Specialist'**
  String get achievementTitle_school_track_specialist;

  /// No description provided for @achievementDescription_school_track_specialist.
  ///
  /// In en, this message translates to:
  /// **'Max out 3 school tracks'**
  String get achievementDescription_school_track_specialist;

  /// No description provided for @achievementTitle_school_freshman.
  ///
  /// In en, this message translates to:
  /// **'School Freshman'**
  String get achievementTitle_school_freshman;

  /// No description provided for @achievementDescription_school_freshman.
  ///
  /// In en, this message translates to:
  /// **'Reach education level 1'**
  String get achievementDescription_school_freshman;

  /// No description provided for @achievementTitle_school_scholar.
  ///
  /// In en, this message translates to:
  /// **'School Scholar'**
  String get achievementTitle_school_scholar;

  /// No description provided for @achievementDescription_school_scholar.
  ///
  /// In en, this message translates to:
  /// **'Reach education level 3'**
  String get achievementDescription_school_scholar;

  /// No description provided for @achievementTitle_school_graduate.
  ///
  /// In en, this message translates to:
  /// **'School Graduate'**
  String get achievementTitle_school_graduate;

  /// No description provided for @achievementDescription_school_graduate.
  ///
  /// In en, this message translates to:
  /// **'Reach education level 5'**
  String get achievementDescription_school_graduate;

  /// No description provided for @achievementTitle_school_mastermind.
  ///
  /// In en, this message translates to:
  /// **'Academic Mastermind'**
  String get achievementTitle_school_mastermind;

  /// No description provided for @achievementDescription_school_mastermind.
  ///
  /// In en, this message translates to:
  /// **'Reach education level 10'**
  String get achievementDescription_school_mastermind;

  /// No description provided for @achievementTitle_school_doctorate.
  ///
  /// In en, this message translates to:
  /// **'Street Doctorate'**
  String get achievementTitle_school_doctorate;

  /// No description provided for @achievementDescription_school_doctorate.
  ///
  /// In en, this message translates to:
  /// **'Reach education level 20'**
  String get achievementDescription_school_doctorate;

  /// No description provided for @achievementTitle_road_bandit.
  ///
  /// In en, this message translates to:
  /// **'Road Bandit'**
  String get achievementTitle_road_bandit;

  /// No description provided for @achievementDescription_road_bandit.
  ///
  /// In en, this message translates to:
  /// **'Steal 5 cars'**
  String get achievementDescription_road_bandit;

  /// No description provided for @achievementTitle_grand_theft_fleet.
  ///
  /// In en, this message translates to:
  /// **'Grand Theft Fleet'**
  String get achievementTitle_grand_theft_fleet;

  /// No description provided for @achievementDescription_grand_theft_fleet.
  ///
  /// In en, this message translates to:
  /// **'Steal 25 cars'**
  String get achievementDescription_grand_theft_fleet;

  /// No description provided for @achievementTitle_sea_raider.
  ///
  /// In en, this message translates to:
  /// **'Sea Raider'**
  String get achievementTitle_sea_raider;

  /// No description provided for @achievementDescription_sea_raider.
  ///
  /// In en, this message translates to:
  /// **'Steal 3 boats'**
  String get achievementDescription_sea_raider;

  /// No description provided for @achievementTitle_captain_of_smugglers.
  ///
  /// In en, this message translates to:
  /// **'Captain of Smugglers'**
  String get achievementTitle_captain_of_smugglers;

  /// No description provided for @achievementDescription_captain_of_smugglers.
  ///
  /// In en, this message translates to:
  /// **'Steal 12 boats'**
  String get achievementDescription_captain_of_smugglers;

  /// No description provided for @achievementTitle_globe_trotter.
  ///
  /// In en, this message translates to:
  /// **'Globe Trotter'**
  String get achievementTitle_globe_trotter;

  /// No description provided for @achievementDescription_globe_trotter.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 journeys'**
  String get achievementDescription_globe_trotter;

  /// No description provided for @achievementTitle_jet_setter.
  ///
  /// In en, this message translates to:
  /// **'Jet Setter'**
  String get achievementTitle_jet_setter;

  /// No description provided for @achievementDescription_jet_setter.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 journeys'**
  String get achievementDescription_jet_setter;

  /// No description provided for @achievementTitle_chemist_apprentice.
  ///
  /// In en, this message translates to:
  /// **'Chemist Apprentice'**
  String get achievementTitle_chemist_apprentice;

  /// No description provided for @achievementDescription_chemist_apprentice.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 drug productions'**
  String get achievementDescription_chemist_apprentice;

  /// No description provided for @achievementTitle_narco_chemist.
  ///
  /// In en, this message translates to:
  /// **'Narco Chemist'**
  String get achievementTitle_narco_chemist;

  /// No description provided for @achievementDescription_narco_chemist.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 drug productions'**
  String get achievementDescription_narco_chemist;

  /// No description provided for @achievementTitle_street_merchant.
  ///
  /// In en, this message translates to:
  /// **'Street Merchant'**
  String get achievementTitle_street_merchant;

  /// No description provided for @achievementDescription_street_merchant.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 trades'**
  String get achievementDescription_street_merchant;

  /// No description provided for @achievementTitle_trade_tycoon.
  ///
  /// In en, this message translates to:
  /// **'Trade Tycoon'**
  String get achievementTitle_trade_tycoon;

  /// No description provided for @achievementDescription_trade_tycoon.
  ///
  /// In en, this message translates to:
  /// **'Complete 150 trades'**
  String get achievementDescription_trade_tycoon;

  /// No description provided for @achievementTitle_prostitute_lineup.
  ///
  /// In en, this message translates to:
  /// **'Lineup Built'**
  String get achievementTitle_prostitute_lineup;

  /// No description provided for @achievementDescription_prostitute_lineup.
  ///
  /// In en, this message translates to:
  /// **'Recruit 10 prostitutes'**
  String get achievementDescription_prostitute_lineup;

  /// No description provided for @achievementTitle_prostitute_network.
  ///
  /// In en, this message translates to:
  /// **'Street Network'**
  String get achievementTitle_prostitute_network;

  /// No description provided for @achievementDescription_prostitute_network.
  ///
  /// In en, this message translates to:
  /// **'Recruit 25 prostitutes'**
  String get achievementDescription_prostitute_network;

  /// No description provided for @achievementTitle_prostitute_syndicate.
  ///
  /// In en, this message translates to:
  /// **'Syndicate'**
  String get achievementTitle_prostitute_syndicate;

  /// No description provided for @achievementDescription_prostitute_syndicate.
  ///
  /// In en, this message translates to:
  /// **'Recruit 50 prostitutes'**
  String get achievementDescription_prostitute_syndicate;

  /// No description provided for @achievementTitle_prostitute_dynasty.
  ///
  /// In en, this message translates to:
  /// **'Dynasty'**
  String get achievementTitle_prostitute_dynasty;

  /// No description provided for @achievementDescription_prostitute_dynasty.
  ///
  /// In en, this message translates to:
  /// **'Recruit 100 prostitutes'**
  String get achievementDescription_prostitute_dynasty;

  /// No description provided for @achievementTitle_prostitute_empire_250.
  ///
  /// In en, this message translates to:
  /// **'Empire 250'**
  String get achievementTitle_prostitute_empire_250;

  /// No description provided for @achievementDescription_prostitute_empire_250.
  ///
  /// In en, this message translates to:
  /// **'Recruit 250 prostitutes'**
  String get achievementDescription_prostitute_empire_250;

  /// No description provided for @achievementTitle_prostitute_cartel_500.
  ///
  /// In en, this message translates to:
  /// **'Cartel 500'**
  String get achievementTitle_prostitute_cartel_500;

  /// No description provided for @achievementDescription_prostitute_cartel_500.
  ///
  /// In en, this message translates to:
  /// **'Recruit 500 prostitutes'**
  String get achievementDescription_prostitute_cartel_500;

  /// No description provided for @achievementTitle_prostitute_legend_1000.
  ///
  /// In en, this message translates to:
  /// **'Legend 1000'**
  String get achievementTitle_prostitute_legend_1000;

  /// No description provided for @achievementDescription_prostitute_legend_1000.
  ///
  /// In en, this message translates to:
  /// **'Recruit 1000 prostitutes'**
  String get achievementDescription_prostitute_legend_1000;

  /// No description provided for @achievementTitle_vip_prostitute_level_10.
  ///
  /// In en, this message translates to:
  /// **'VIP Beginner'**
  String get achievementTitle_vip_prostitute_level_10;

  /// No description provided for @achievementDescription_vip_prostitute_level_10.
  ///
  /// In en, this message translates to:
  /// **'Reach level 3 with a VIP prostitute'**
  String get achievementDescription_vip_prostitute_level_10;

  /// No description provided for @achievementTitle_vip_prostitute_level_25.
  ///
  /// In en, this message translates to:
  /// **'VIP Headliner'**
  String get achievementTitle_vip_prostitute_level_25;

  /// No description provided for @achievementDescription_vip_prostitute_level_25.
  ///
  /// In en, this message translates to:
  /// **'Reach level 5 with a VIP prostitute'**
  String get achievementDescription_vip_prostitute_level_25;

  /// No description provided for @achievementTitle_vip_prostitute_level_50.
  ///
  /// In en, this message translates to:
  /// **'VIP Icon'**
  String get achievementTitle_vip_prostitute_level_50;

  /// No description provided for @achievementDescription_vip_prostitute_level_50.
  ///
  /// In en, this message translates to:
  /// **'Reach level 7 with a VIP prostitute'**
  String get achievementDescription_vip_prostitute_level_50;

  /// No description provided for @achievementTitle_vip_prostitute_level_100.
  ///
  /// In en, this message translates to:
  /// **'VIP Legend'**
  String get achievementTitle_vip_prostitute_level_100;

  /// No description provided for @achievementDescription_vip_prostitute_level_100.
  ///
  /// In en, this message translates to:
  /// **'Reach level 10 with a VIP prostitute'**
  String get achievementDescription_vip_prostitute_level_100;

  /// No description provided for @achievementTitle_nightclub_opening_night.
  ///
  /// In en, this message translates to:
  /// **'Opening Night'**
  String get achievementTitle_nightclub_opening_night;

  /// No description provided for @achievementDescription_nightclub_opening_night.
  ///
  /// In en, this message translates to:
  /// **'Open your first nightclub venue'**
  String get achievementDescription_nightclub_opening_night;

  /// No description provided for @achievementTitle_nightclub_headliner.
  ///
  /// In en, this message translates to:
  /// **'Headliner Booker'**
  String get achievementTitle_nightclub_headliner;

  /// No description provided for @achievementDescription_nightclub_headliner.
  ///
  /// In en, this message translates to:
  /// **'Book 10 DJ shifts for your nightclub empire'**
  String get achievementDescription_nightclub_headliner;

  /// No description provided for @achievementTitle_nightclub_full_house.
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get achievementTitle_nightclub_full_house;

  /// No description provided for @achievementDescription_nightclub_full_house.
  ///
  /// In en, this message translates to:
  /// **'Push a nightclub crowd to 90% capacity'**
  String get achievementDescription_nightclub_full_house;

  /// No description provided for @achievementTitle_nightclub_cash_machine.
  ///
  /// In en, this message translates to:
  /// **'Cash Machine'**
  String get achievementTitle_nightclub_cash_machine;

  /// No description provided for @achievementDescription_nightclub_cash_machine.
  ///
  /// In en, this message translates to:
  /// **'Earn €250,000 total nightclub revenue'**
  String get achievementDescription_nightclub_cash_machine;

  /// No description provided for @achievementTitle_nightclub_empire.
  ///
  /// In en, this message translates to:
  /// **'Nightlife Empire'**
  String get achievementTitle_nightclub_empire;

  /// No description provided for @achievementDescription_nightclub_empire.
  ///
  /// In en, this message translates to:
  /// **'Earn €1,000,000 total nightclub revenue'**
  String get achievementDescription_nightclub_empire;

  /// No description provided for @achievementTitle_nightclub_staffing_boss.
  ///
  /// In en, this message translates to:
  /// **'Staffing Boss'**
  String get achievementTitle_nightclub_staffing_boss;

  /// No description provided for @achievementDescription_nightclub_staffing_boss.
  ///
  /// In en, this message translates to:
  /// **'Run 3 active nightclub crew members at the same time'**
  String get achievementDescription_nightclub_staffing_boss;

  /// No description provided for @achievementTitle_nightclub_vip_room.
  ///
  /// In en, this message translates to:
  /// **'VIP Room'**
  String get achievementTitle_nightclub_vip_room;

  /// No description provided for @achievementDescription_nightclub_vip_room.
  ///
  /// In en, this message translates to:
  /// **'Assign 2 VIP crew members to your nightclub'**
  String get achievementDescription_nightclub_vip_room;

  /// No description provided for @achievementTitle_nightclub_head_of_security.
  ///
  /// In en, this message translates to:
  /// **'Head of Security'**
  String get achievementTitle_nightclub_head_of_security;

  /// No description provided for @achievementDescription_nightclub_head_of_security.
  ///
  /// In en, this message translates to:
  /// **'Hire nightclub security for 10 shifts'**
  String get achievementDescription_nightclub_head_of_security;

  /// No description provided for @achievementTitle_nightclub_podium_finish.
  ///
  /// In en, this message translates to:
  /// **'Podium Finish'**
  String get achievementTitle_nightclub_podium_finish;

  /// No description provided for @achievementDescription_nightclub_podium_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish in the top 3 of a weekly nightclub season'**
  String get achievementDescription_nightclub_podium_finish;

  /// No description provided for @achievementTitle_nightclub_season_champion.
  ///
  /// In en, this message translates to:
  /// **'Season Champion'**
  String get achievementTitle_nightclub_season_champion;

  /// No description provided for @achievementDescription_nightclub_season_champion.
  ///
  /// In en, this message translates to:
  /// **'Win a weekly nightclub season'**
  String get achievementDescription_nightclub_season_champion;

  /// No description provided for @nightclubManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub Management'**
  String get nightclubManagementTitle;

  /// No description provided for @nightclubRealtimeStatus.
  ///
  /// In en, this message translates to:
  /// **'Realtime status active'**
  String get nightclubRealtimeStatus;

  /// No description provided for @nightclubRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get nightclubRefresh;

  /// No description provided for @nightclubEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No nightclub found yet'**
  String get nightclubEmptyTitle;

  /// No description provided for @nightclubEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Buy a nightclub in Properties first to activate this system.'**
  String get nightclubEmptyBody;

  /// No description provided for @nightclubLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub Location'**
  String get nightclubLocationTitle;

  /// No description provided for @nightclubSelectVenue.
  ///
  /// In en, this message translates to:
  /// **'Select venue'**
  String get nightclubSelectVenue;

  /// No description provided for @nightclubLiveStatistics.
  ///
  /// In en, this message translates to:
  /// **'Live Statistics'**
  String get nightclubLiveStatistics;

  /// No description provided for @nightclubKpiCrowd.
  ///
  /// In en, this message translates to:
  /// **'Crowd'**
  String get nightclubKpiCrowd;

  /// No description provided for @nightclubKpiVibe.
  ///
  /// In en, this message translates to:
  /// **'Vibe'**
  String get nightclubKpiVibe;

  /// No description provided for @nightclubKpiToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nightclubKpiToday;

  /// No description provided for @nightclubKpiAllTime.
  ///
  /// In en, this message translates to:
  /// **'All-time'**
  String get nightclubKpiAllTime;

  /// No description provided for @nightclubKpiStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get nightclubKpiStock;

  /// No description provided for @nightclubKpiDj.
  ///
  /// In en, this message translates to:
  /// **'DJ'**
  String get nightclubKpiDj;

  /// No description provided for @nightclubKpiThefts.
  ///
  /// In en, this message translates to:
  /// **'Thefts'**
  String get nightclubKpiThefts;

  /// No description provided for @nightclubKpiStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get nightclubKpiStaff;

  /// No description provided for @nightclubKpiSalesBoost.
  ///
  /// In en, this message translates to:
  /// **'Sales boost'**
  String get nightclubKpiSalesBoost;

  /// No description provided for @nightclubKpiPriceBoost.
  ///
  /// In en, this message translates to:
  /// **'Price boost'**
  String get nightclubKpiPriceBoost;

  /// No description provided for @nightclubKpiVipBonus.
  ///
  /// In en, this message translates to:
  /// **'VIP bonus'**
  String get nightclubKpiVipBonus;

  /// No description provided for @nightclubStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get nightclubStatusActive;

  /// No description provided for @nightclubStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get nightclubStatusOff;

  /// No description provided for @nightclubStatusActiveLower.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get nightclubStatusActiveLower;

  /// No description provided for @nightclubRevenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend (live)'**
  String get nightclubRevenueTrend;

  /// No description provided for @nightclubLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Nightclubs'**
  String get nightclubLeaderboardTitle;

  /// No description provided for @nightclubLeaderboardCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get nightclubLeaderboardCountry;

  /// No description provided for @nightclubLeaderboardGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get nightclubLeaderboardGlobal;

  /// No description provided for @nightclubLeaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data yet'**
  String get nightclubLeaderboardEmpty;

  /// No description provided for @nightclubLeaderboardRevenue24h.
  ///
  /// In en, this message translates to:
  /// **'24h revenue'**
  String get nightclubLeaderboardRevenue24h;

  /// No description provided for @nightclubSeasonProcessing.
  ///
  /// In en, this message translates to:
  /// **'processing...'**
  String get nightclubSeasonProcessing;

  /// No description provided for @nightclubSeasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Season Ranking'**
  String get nightclubSeasonTitle;

  /// No description provided for @nightclubSeasonResetIn.
  ///
  /// In en, this message translates to:
  /// **'Reset in'**
  String get nightclubSeasonResetIn;

  /// No description provided for @nightclubSeasonYourRewards.
  ///
  /// In en, this message translates to:
  /// **'Your season rewards'**
  String get nightclubSeasonYourRewards;

  /// No description provided for @nightclubSeasonCurrentTop5.
  ///
  /// In en, this message translates to:
  /// **'Current week top 5'**
  String get nightclubSeasonCurrentTop5;

  /// No description provided for @nightclubSeasonEmpty.
  ///
  /// In en, this message translates to:
  /// **'No season data yet'**
  String get nightclubSeasonEmpty;

  /// No description provided for @nightclubSeasonWeekRevenue.
  ///
  /// In en, this message translates to:
  /// **'Week revenue'**
  String get nightclubSeasonWeekRevenue;

  /// No description provided for @nightclubSeasonScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get nightclubSeasonScore;

  /// No description provided for @nightclubSeasonRecentPayouts.
  ///
  /// In en, this message translates to:
  /// **'Recent payouts'**
  String get nightclubSeasonRecentPayouts;

  /// No description provided for @nightclubSeasonNoPayouts.
  ///
  /// In en, this message translates to:
  /// **'No payouts yet'**
  String get nightclubSeasonNoPayouts;

  /// No description provided for @nightclubSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Sales'**
  String get nightclubSalesTitle;

  /// No description provided for @nightclubSalesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sales data yet'**
  String get nightclubSalesEmpty;

  /// No description provided for @nightclubTheftTitle.
  ///
  /// In en, this message translates to:
  /// **'Theft Log'**
  String get nightclubTheftTitle;

  /// No description provided for @nightclubTheftEmpty.
  ///
  /// In en, this message translates to:
  /// **'No thefts recorded'**
  String get nightclubTheftEmpty;

  /// No description provided for @nightclubTheftLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get nightclubTheftLoss;

  /// No description provided for @nightclubStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Pimp Crew in Club'**
  String get nightclubStaffTitle;

  /// No description provided for @nightclubStaffVipExtraActive.
  ///
  /// In en, this message translates to:
  /// **' (VIP +2 active)'**
  String get nightclubStaffVipExtraActive;

  /// No description provided for @nightclubStaffCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity: {assigned}/{cap}{vipSuffix}'**
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix);

  /// No description provided for @nightclubStaffBoostMix.
  ///
  /// In en, this message translates to:
  /// **'Boost mix: sales x{sales} | price x{price} | vibe x{vibe} | security x{security} | vip player x{vipPlayer} | vip staff x{vipStaff} ({vipAssigned})'**
  String nightclubStaffBoostMix(
    String sales,
    String price,
    String vibe,
    String security,
    String vipPlayer,
    String vipStaff,
    String vipAssigned,
  );

  /// No description provided for @nightclubSelectCrewMember.
  ///
  /// In en, this message translates to:
  /// **'Select crew member'**
  String get nightclubSelectCrewMember;

  /// No description provided for @nightclubAssignShift.
  ///
  /// In en, this message translates to:
  /// **'Assign to nightclub shift'**
  String get nightclubAssignShift;

  /// No description provided for @nightclubTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get nightclubTabActive;

  /// No description provided for @nightclubTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get nightclubTabHistory;

  /// No description provided for @nightclubNoCrewAssigned.
  ///
  /// In en, this message translates to:
  /// **'No crew assigned yet'**
  String get nightclubNoCrewAssigned;

  /// No description provided for @nightclubCrewBoostDescription.
  ///
  /// In en, this message translates to:
  /// **'Boosts demand and margin in your club'**
  String get nightclubCrewBoostDescription;

  /// No description provided for @nightclubRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get nightclubRemove;

  /// No description provided for @nightclubNoStaffHistory.
  ///
  /// In en, this message translates to:
  /// **'No staffing history yet'**
  String get nightclubNoStaffHistory;

  /// No description provided for @nightclubFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get nightclubFrom;

  /// No description provided for @nightclubTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get nightclubTo;

  /// No description provided for @nightclubRevenueImpact.
  ///
  /// In en, this message translates to:
  /// **'Revenue impact'**
  String get nightclubRevenueImpact;

  /// No description provided for @nightclubSalesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'sales'**
  String get nightclubSalesCountLabel;

  /// No description provided for @nightclubDjTitle.
  ///
  /// In en, this message translates to:
  /// **'Hire DJ'**
  String get nightclubDjTitle;

  /// No description provided for @nightclubChooseDj.
  ///
  /// In en, this message translates to:
  /// **'Choose DJ'**
  String get nightclubChooseDj;

  /// No description provided for @nightclubShiftLength.
  ///
  /// In en, this message translates to:
  /// **'Shift length'**
  String get nightclubShiftLength;

  /// No description provided for @nightclubHireDj.
  ///
  /// In en, this message translates to:
  /// **'Hire DJ'**
  String get nightclubHireDj;

  /// No description provided for @nightclubSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get nightclubSecurityTitle;

  /// No description provided for @nightclubChooseSecurity.
  ///
  /// In en, this message translates to:
  /// **'Choose security'**
  String get nightclubChooseSecurity;

  /// No description provided for @nightclubHireSecurity.
  ///
  /// In en, this message translates to:
  /// **'Hire security'**
  String get nightclubHireSecurity;

  /// No description provided for @nightclubStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Drugs'**
  String get nightclubStoreTitle;

  /// No description provided for @nightclubChooseStock.
  ///
  /// In en, this message translates to:
  /// **'Choose stock'**
  String get nightclubChooseStock;

  /// No description provided for @nightclubAmountGrams.
  ///
  /// In en, this message translates to:
  /// **'Amount in grams'**
  String get nightclubAmountGrams;

  /// No description provided for @nightclubStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Store in nightclub'**
  String get nightclubStoreButton;

  /// No description provided for @nightclubHireDjSuccess.
  ///
  /// In en, this message translates to:
  /// **'DJ hired'**
  String get nightclubHireDjSuccess;

  /// No description provided for @nightclubHireSecuritySuccess.
  ///
  /// In en, this message translates to:
  /// **'Security hired'**
  String get nightclubHireSecuritySuccess;

  /// No description provided for @nightclubAssignCrewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crew member assigned'**
  String get nightclubAssignCrewSuccess;

  /// No description provided for @nightclubRemoveCrewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crew member removed'**
  String get nightclubRemoveCrewSuccess;

  /// No description provided for @nightclubStoreDrugsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Drugs stored'**
  String get nightclubStoreDrugsSuccess;

  /// No description provided for @nightclubSeasonPayoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Season payout received'**
  String get nightclubSeasonPayoutDialogTitle;

  /// No description provided for @nightclubSeasonPayoutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your nightclub finished at rank #{rank} this week.'**
  String nightclubSeasonPayoutDialogBody(String rank);

  /// No description provided for @nightclubSeasonPayoutDialogReward.
  ///
  /// In en, this message translates to:
  /// **'Reward: {amount}'**
  String nightclubSeasonPayoutDialogReward(String amount);

  /// No description provided for @nightclubSeasonPayoutDialogRevenue.
  ///
  /// In en, this message translates to:
  /// **'Weekly revenue: {amount}'**
  String nightclubSeasonPayoutDialogRevenue(String amount);

  /// No description provided for @nightclubSeasonPayoutDialogLoss.
  ///
  /// In en, this message translates to:
  /// **'Theft loss: {amount}'**
  String nightclubSeasonPayoutDialogLoss(String amount);

  /// No description provided for @nightclubSeasonPayoutDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get nightclubSeasonPayoutDialogAction;

  /// No description provided for @nightclubVibeChill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get nightclubVibeChill;

  /// No description provided for @nightclubVibeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get nightclubVibeNormal;

  /// No description provided for @nightclubVibeWild.
  ///
  /// In en, this message translates to:
  /// **'Wild'**
  String get nightclubVibeWild;

  /// No description provided for @nightclubVibeRaging.
  ///
  /// In en, this message translates to:
  /// **'Raging'**
  String get nightclubVibeRaging;

  /// No description provided for @nightclubTheftTypeCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer theft'**
  String get nightclubTheftTypeCustomer;

  /// No description provided for @nightclubTheftTypeEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee heist'**
  String get nightclubTheftTypeEmployee;

  /// No description provided for @nightclubTheftTypeRival.
  ///
  /// In en, this message translates to:
  /// **'Rival sabotage'**
  String get nightclubTheftTypeRival;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
