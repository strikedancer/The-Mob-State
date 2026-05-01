import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
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

  /// No description provided for @crimeEliminateWitnessName.
  ///
  /// In en, this message translates to:
  /// **'Eliminate Witness'**
  String get crimeEliminateWitnessName;

  /// No description provided for @crimeEliminateWitnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Eliminate a witness before trial'**
  String get crimeEliminateWitnessDesc;

  /// No description provided for @crimeDiamondHeistName.
  ///
  /// In en, this message translates to:
  /// **'Diamond Transport Heist'**
  String get crimeDiamondHeistName;

  /// No description provided for @crimeDiamondHeistDesc.
  ///
  /// In en, this message translates to:
  /// **'Hijack a transport of rough diamonds'**
  String get crimeDiamondHeistDesc;

  /// No description provided for @crimeEvidenceRoomHeistName.
  ///
  /// In en, this message translates to:
  /// **'Evidence Room Heist'**
  String get crimeEvidenceRoomHeistName;

  /// No description provided for @crimeEvidenceRoomHeistDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal evidence from a federal storage facility'**
  String get crimeEvidenceRoomHeistDesc;

  /// No description provided for @crimeMuseumHeistName.
  ///
  /// In en, this message translates to:
  /// **'Museum Heist'**
  String get crimeMuseumHeistName;

  /// No description provided for @crimeMuseumHeistDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal valuable artifacts from a museum'**
  String get crimeMuseumHeistDesc;

  /// No description provided for @crimeBossAssassinationName.
  ///
  /// In en, this message translates to:
  /// **'Rival Boss Assassination'**
  String get crimeBossAssassinationName;

  /// No description provided for @crimeBossAssassinationDesc.
  ///
  /// In en, this message translates to:
  /// **'Eliminate the leader of a rival organization'**
  String get crimeBossAssassinationDesc;

  /// No description provided for @crimeCriminalRecordWipeName.
  ///
  /// In en, this message translates to:
  /// **'Wipe Criminal Record'**
  String get crimeCriminalRecordWipeName;

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

  /// No description provided for @tooltipCrimeRequiresWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapon required'**
  String get tooltipCrimeRequiresWeapon;

  /// No description provided for @tooltipCrimeRequirementsHeading.
  ///
  /// In en, this message translates to:
  /// **'Required:'**
  String get tooltipCrimeRequirementsHeading;

  /// No description provided for @crimeCriminalRecordWipeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Wipes your full criminal record on success. Only available if you already have convictions.'**
  String get crimeCriminalRecordWipeTooltip;

  /// No description provided for @crimeErrorDrugsRequired.
  ///
  /// In en, this message translates to:
  /// **'You need at least {quantity}g of: {drugs}'**
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

  /// No description provided for @jobSuccessChancePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% chance'**
  String jobSuccessChancePercent(String percent);

  /// No description provided for @jobXpRewardShort.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String jobXpRewardShort(String xp);

  /// No description provided for @jobPayRangeEuro.
  ///
  /// In en, this message translates to:
  /// **'€{min}-€{max}'**
  String jobPayRangeEuro(String min, String max);

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

  /// No description provided for @travelNotInTransit.
  ///
  /// In en, this message translates to:
  /// **'You are not on a journey.'**
  String get travelNotInTransit;

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

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @noDirectMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noDirectMessagesYet;

  /// No description provided for @sendMessageToFriendsHint.
  ///
  /// In en, this message translates to:
  /// **'Send a message to your friends!'**
  String get sendMessageToFriendsHint;

  /// No description provided for @errorLoadingConversations.
  ///
  /// In en, this message translates to:
  /// **'Error loading conversations: {error}'**
  String errorLoadingConversations(String error);

  /// No description provided for @messageSystemBadge.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get messageSystemBadge;

  /// No description provided for @messageSystemInboxPreview.
  ///
  /// In en, this message translates to:
  /// **'Achievements and system messages'**
  String get messageSystemInboxPreview;

  /// No description provided for @messageSystemThreadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements and system messages'**
  String get messageSystemThreadSubtitle;

  /// No description provided for @messageSystemThreadEmptyDetail.
  ///
  /// In en, this message translates to:
  /// **'Achievements and system messages appear here automatically.'**
  String get messageSystemThreadEmptyDetail;

  /// No description provided for @messageSendFirst.
  ///
  /// In en, this message translates to:
  /// **'Send the first message!'**
  String get messageSendFirst;

  /// No description provided for @chatFriendRankLine.
  ///
  /// In en, this message translates to:
  /// **'★ Rank {rank}'**
  String chatFriendRankLine(int rank);

  /// No description provided for @errorLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Error loading messages: {error}'**
  String errorLoadingMessages(String error);

  /// No description provided for @messageDeleteOwnOnly.
  ///
  /// In en, this message translates to:
  /// **'You can only delete your own messages'**
  String get messageDeleteOwnOnly;

  /// No description provided for @messageDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get messageDeleteTitle;

  /// No description provided for @messageDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This message will be permanently deleted.'**
  String get messageDeleteBody;

  /// No description provided for @messageSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get messageSendFailed;

  /// No description provided for @messageDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete message'**
  String get messageDeleteFailed;

  /// No description provided for @investigationWindowExpired.
  ///
  /// In en, this message translates to:
  /// **'Investigation window expired (24 hours).'**
  String get investigationWindowExpired;

  /// No description provided for @investigationStartedInboxHint.
  ///
  /// In en, this message translates to:
  /// **'Investigation started. Check your inbox for the detective report.'**
  String get investigationStartedInboxHint;

  /// No description provided for @investigationAlreadyInProgress.
  ///
  /// In en, this message translates to:
  /// **'This investigation is already in progress or completed.'**
  String get investigationAlreadyInProgress;

  /// No description provided for @investigationStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start investigation: {error}'**
  String investigationStartFailed(String error);

  /// No description provided for @investigationExpired.
  ///
  /// In en, this message translates to:
  /// **'Investigation expired'**
  String get investigationExpired;

  /// No description provided for @investigationStarted.
  ///
  /// In en, this message translates to:
  /// **'Investigation started'**
  String get investigationStarted;

  /// No description provided for @investigationStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get investigationStarting;

  /// No description provided for @startMurderInvestigation.
  ///
  /// In en, this message translates to:
  /// **'Start murder investigation'**
  String get startMurderInvestigation;

  /// No description provided for @systemMessagesReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'System messages cannot be replied to'**
  String get systemMessagesReadOnlyHint;

  /// No description provided for @helpAndGuide.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpAndGuide;

  /// No description provided for @helpUiManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Game manual'**
  String get helpUiManualTitle;

  /// No description provided for @helpUiSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by module, explanation or tip'**
  String get helpUiSearchHint;

  /// No description provided for @helpUiTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get helpUiTopicLabel;

  /// No description provided for @helpUiAllChip.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get helpUiAllChip;

  /// No description provided for @helpUiNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No topics found'**
  String get helpUiNoResultsTitle;

  /// No description provided for @helpUiNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Change your search or category to see results again.'**
  String get helpUiNoResultsBody;

  /// No description provided for @helpUiHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get helpUiHowItWorks;

  /// No description provided for @helpUiTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get helpUiTips;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @liveEvents.
  ///
  /// In en, this message translates to:
  /// **'Live Events'**
  String get liveEvents;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @aviation.
  ///
  /// In en, this message translates to:
  /// **'Aviation'**
  String get aviation;

  /// No description provided for @premiumAndCredits.
  ///
  /// In en, this message translates to:
  /// **'Premium & Credits'**
  String get premiumAndCredits;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @tradeGoods.
  ///
  /// In en, this message translates to:
  /// **'Trade goods'**
  String get tradeGoods;

  /// No description provided for @drugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get drugs;

  /// No description provided for @nightclub.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get nightclub;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @smuggling.
  ///
  /// In en, this message translates to:
  /// **'Smuggling'**
  String get smuggling;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'tools'**
  String get tools;

  /// No description provided for @vehicleHeist.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Heist'**
  String get vehicleHeist;

  /// No description provided for @vehicleHeistTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Heist'**
  String get vehicleHeistTitle;

  /// No description provided for @vehicleHeistTabSubtitleCar.
  ///
  /// In en, this message translates to:
  /// **'Steal cars for cash and parts.'**
  String get vehicleHeistTabSubtitleCar;

  /// No description provided for @vehicleHeistTabSubtitleMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Steal motorcycles for cash and parts.'**
  String get vehicleHeistTabSubtitleMotorcycle;

  /// No description provided for @vehicleHeistTabSubtitleBoat.
  ///
  /// In en, this message translates to:
  /// **'Steal boats for cash and parts.'**
  String get vehicleHeistTabSubtitleBoat;

  /// No description provided for @vehicleHeistReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get vehicleHeistReady;

  /// No description provided for @vehicleHeistMotorStorage.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle storage'**
  String get vehicleHeistMotorStorage;

  /// No description provided for @vehicleHeistCapacityPolicyCar.
  ///
  /// In en, this message translates to:
  /// **'Car capacity is shared across all car heists.'**
  String get vehicleHeistCapacityPolicyCar;

  /// No description provided for @vehicleHeistCapacityPolicyMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle capacity is shared across all motorcycle heists.'**
  String get vehicleHeistCapacityPolicyMotorcycle;

  /// No description provided for @vehicleHeistCapacityPolicyBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat capacity is shared across all boat heists.'**
  String get vehicleHeistCapacityPolicyBoat;

  /// No description provided for @vehicleHeistRankRequired.
  ///
  /// In en, this message translates to:
  /// **'Rank required: {rank}'**
  String vehicleHeistRankRequired(String rank);

  /// No description provided for @vehicleHeistCapacityLine.
  ///
  /// In en, this message translates to:
  /// **'Storage: {stored}/{total} (lane lvl {level})'**
  String vehicleHeistCapacityLine(String stored, String total, String level);

  /// No description provided for @vehicleHeistStealCar.
  ///
  /// In en, this message translates to:
  /// **'Steal car'**
  String get vehicleHeistStealCar;

  /// No description provided for @vehicleHeistStealMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Steal motorcycle'**
  String get vehicleHeistStealMotorcycle;

  /// No description provided for @vehicleHeistStealBoat.
  ///
  /// In en, this message translates to:
  /// **'Steal boat'**
  String get vehicleHeistStealBoat;

  /// No description provided for @vehicleHeistGenericVehicle.
  ///
  /// In en, this message translates to:
  /// **'vehicle'**
  String get vehicleHeistGenericVehicle;

  /// No description provided for @vehicleHeistSuccessStolen.
  ///
  /// In en, this message translates to:
  /// **'Success: {vehicle} stolen.'**
  String vehicleHeistSuccessStolen(String vehicle);

  /// No description provided for @vehicleHeistCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Cooldown active: {duration}'**
  String vehicleHeistCooldownActive(String duration);

  /// No description provided for @vehicleHeistArrested.
  ///
  /// In en, this message translates to:
  /// **'You got arrested ({minutes} min jail).'**
  String vehicleHeistArrested(String minutes);

  /// No description provided for @vehicleHeistUntil.
  ///
  /// In en, this message translates to:
  /// **'until'**
  String get vehicleHeistUntil;

  /// No description provided for @vehicleHeistRegionalLockActive.
  ///
  /// In en, this message translates to:
  /// **'Regional lock active.'**
  String get vehicleHeistRegionalLockActive;

  /// No description provided for @vehicleHeistStealFailed.
  ///
  /// In en, this message translates to:
  /// **'Steal action failed.'**
  String get vehicleHeistStealFailed;

  /// No description provided for @vehicleHeistUpgradeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Upgrade completed.'**
  String get vehicleHeistUpgradeCompleted;

  /// No description provided for @vehicleHeistUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade failed.'**
  String get vehicleHeistUpgradeFailed;

  /// No description provided for @vehicleHeistCatalogTitleCars.
  ///
  /// In en, this message translates to:
  /// **'Available cars'**
  String get vehicleHeistCatalogTitleCars;

  /// No description provided for @vehicleHeistCatalogTitleMotorcycles.
  ///
  /// In en, this message translates to:
  /// **'Available motorcycles'**
  String get vehicleHeistCatalogTitleMotorcycles;

  /// No description provided for @vehicleHeistCatalogTitleBoats.
  ///
  /// In en, this message translates to:
  /// **'Available boats'**
  String get vehicleHeistCatalogTitleBoats;

  /// No description provided for @vehicleHeistCatalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vehicles in this catalog.'**
  String get vehicleHeistCatalogEmpty;

  /// No description provided for @vehicleHeistRarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get vehicleHeistRarityCommon;

  /// No description provided for @vehicleHeistRarityUncommon.
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get vehicleHeistRarityUncommon;

  /// No description provided for @vehicleHeistRarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get vehicleHeistRarityRare;

  /// No description provided for @vehicleHeistRarityEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get vehicleHeistRarityEpic;

  /// No description provided for @vehicleHeistRarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get vehicleHeistRarityLegendary;

  /// No description provided for @vehicleHeistEventOnlyTag.
  ///
  /// In en, this message translates to:
  /// **'Event-only'**
  String get vehicleHeistEventOnlyTag;

  /// No description provided for @vehicleHeistCatalogValue.
  ///
  /// In en, this message translates to:
  /// **'Value: {value}'**
  String vehicleHeistCatalogValue(String value);

  /// No description provided for @vehicleHeistCatalogRank.
  ///
  /// In en, this message translates to:
  /// **'Rank: {rank}'**
  String vehicleHeistCatalogRank(String rank);

  /// No description provided for @vehicleHeistCatalogInGameAvailability.
  ///
  /// In en, this message translates to:
  /// **'In-game availability: {label}'**
  String vehicleHeistCatalogInGameAvailability(String label);

  /// No description provided for @vehicleHeistCatalogMostCommonIn.
  ///
  /// In en, this message translates to:
  /// **'Most common in: {country}'**
  String vehicleHeistCatalogMostCommonIn(String country);

  /// No description provided for @vehicleHeistCatalogCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries: {countries}'**
  String vehicleHeistCatalogCountries(String countries);

  /// No description provided for @vehicleHeistUpgradeCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade ({cost})'**
  String vehicleHeistUpgradeCost(String cost);

  /// No description provided for @vehicleHeistUpgradeRankRequired.
  ///
  /// In en, this message translates to:
  /// **'Upgrade locked: rank {rank} required'**
  String vehicleHeistUpgradeRankRequired(String rank);

  /// No description provided for @vehicleHeistUpgradeLocked.
  ///
  /// In en, this message translates to:
  /// **'Upgrade locked'**
  String get vehicleHeistUpgradeLocked;

  /// No description provided for @vehicleHeistSpeedUpWithCredits.
  ///
  /// In en, this message translates to:
  /// **'Speed up for {credits} credits'**
  String vehicleHeistSpeedUpWithCredits(String credits);

  /// No description provided for @vehicleHeistSpeedUpWithCreditsNextScreen.
  ///
  /// In en, this message translates to:
  /// **'Speed up (next screen)'**
  String get vehicleHeistSpeedUpWithCreditsNextScreen;

  /// No description provided for @vehicleHeistExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get vehicleHeistExpand;

  /// No description provided for @vehicleHeistCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get vehicleHeistCollapse;

  /// No description provided for @vehicleHeistActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get vehicleHeistActive;

  /// No description provided for @vehicleHeistOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get vehicleHeistOff;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @vehicleHeistOpsHotspotRunButton.
  ///
  /// In en, this message translates to:
  /// **'Run Hotspot'**
  String get vehicleHeistOpsHotspotRunButton;

  /// No description provided for @vehicleHeistOpsHotspotRunTitle.
  ///
  /// In en, this message translates to:
  /// **'Hotspot run'**
  String get vehicleHeistOpsHotspotRunTitle;

  /// No description provided for @vehicleHeistOpsHotspotSuccess.
  ///
  /// In en, this message translates to:
  /// **'Hotspot run completed: +{reward}'**
  String vehicleHeistOpsHotspotSuccess(String reward);

  /// No description provided for @vehicleHeistOpsHotspotCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Hotspot cooldown active ({duration})'**
  String vehicleHeistOpsHotspotCooldownActive(String duration);

  /// No description provided for @vehicleHeistOpsHotspotFailedHeatIncreased.
  ///
  /// In en, this message translates to:
  /// **'Hotspot failed. Heat increased.'**
  String get vehicleHeistOpsHotspotFailedHeatIncreased;

  /// No description provided for @vehicleHeistOpsCrewOpButton.
  ///
  /// In en, this message translates to:
  /// **'Crew Op'**
  String get vehicleHeistOpsCrewOpButton;

  /// No description provided for @vehicleHeistOpsCrewOpTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew op'**
  String get vehicleHeistOpsCrewOpTitle;

  /// No description provided for @vehicleHeistOpsCrewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crew op completed: you earned {reward}'**
  String vehicleHeistOpsCrewSuccess(String reward);

  /// No description provided for @vehicleHeistOpsCrewRequired.
  ///
  /// In en, this message translates to:
  /// **'Crew required.'**
  String get vehicleHeistOpsCrewRequired;

  /// No description provided for @vehicleHeistOpsCrewCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Crew op cooldown active ({duration})'**
  String vehicleHeistOpsCrewCooldownActive(String duration);

  /// No description provided for @vehicleHeistOpsCrewFailed.
  ///
  /// In en, this message translates to:
  /// **'Crew op failed.'**
  String get vehicleHeistOpsCrewFailed;

  /// No description provided for @vehicleHeistOpsCrewJoinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Join a crew to unlock crew actions'**
  String get vehicleHeistOpsCrewJoinToUnlock;

  /// No description provided for @vehicleHeistOpsCrewRequiredYes.
  ///
  /// In en, this message translates to:
  /// **'Crew required: yes'**
  String get vehicleHeistOpsCrewRequiredYes;

  /// No description provided for @vehicleHeistOpsCrewRequiredNoJoinFirst.
  ///
  /// In en, this message translates to:
  /// **'Crew required: no (join a crew first)'**
  String get vehicleHeistOpsCrewRequiredNoJoinFirst;

  /// No description provided for @vehicleHeistOpsBuyPartsButton.
  ///
  /// In en, this message translates to:
  /// **'Buy Parts'**
  String get vehicleHeistOpsBuyPartsButton;

  /// No description provided for @vehicleHeistOpsBuyPartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy parts'**
  String get vehicleHeistOpsBuyPartsTitle;

  /// No description provided for @vehicleHeistOpsBuyPartsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Buy which parts? ({type})'**
  String vehicleHeistOpsBuyPartsPrompt(String type);

  /// No description provided for @vehicleHeistOpsPartsPurchased.
  ///
  /// In en, this message translates to:
  /// **'Parts purchased: -{cost}'**
  String vehicleHeistOpsPartsPurchased(String cost);

  /// No description provided for @vehicleHeistOpsPartsPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Parts purchase failed.'**
  String get vehicleHeistOpsPartsPurchaseFailed;

  /// No description provided for @vehicleHeistOpsClaimContractButton.
  ///
  /// In en, this message translates to:
  /// **'Claim Contract'**
  String get vehicleHeistOpsClaimContractButton;

  /// No description provided for @vehicleHeistOpsClaimContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim contract'**
  String get vehicleHeistOpsClaimContractTitle;

  /// No description provided for @vehicleHeistOpsChopContractCompleted.
  ///
  /// In en, this message translates to:
  /// **'Contract completed: +{reward}'**
  String vehicleHeistOpsChopContractCompleted(String reward);

  /// No description provided for @vehicleHeistOpsChopNoEligibleVehicle.
  ///
  /// In en, this message translates to:
  /// **'No eligible vehicle in inventory for this contract.'**
  String get vehicleHeistOpsChopNoEligibleVehicle;

  /// No description provided for @vehicleHeistOpsChopContractCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Contract cooldown active ({duration})'**
  String vehicleHeistOpsChopContractCooldownActive(String duration);

  /// No description provided for @vehicleHeistOpsChopContractClaimFailed.
  ///
  /// In en, this message translates to:
  /// **'Contract claim failed.'**
  String get vehicleHeistOpsChopContractClaimFailed;

  /// No description provided for @vehicleHeistOpsInsuranceButton.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get vehicleHeistOpsInsuranceButton;

  /// No description provided for @vehicleHeistOpsInsuranceTitle.
  ///
  /// In en, this message translates to:
  /// **'Contraband Insurance'**
  String get vehicleHeistOpsInsuranceTitle;

  /// No description provided for @vehicleHeistOpsInsuranceBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a coverage tier for this vehicle category.'**
  String get vehicleHeistOpsInsuranceBody;

  /// No description provided for @vehicleHeistOpsInsuranceTierBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get vehicleHeistOpsInsuranceTierBasic;

  /// No description provided for @vehicleHeistOpsInsuranceTierPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get vehicleHeistOpsInsuranceTierPro;

  /// No description provided for @vehicleHeistOpsInsuranceActive.
  ///
  /// In en, this message translates to:
  /// **'Insurance active ({tier}) for {price}.'**
  String vehicleHeistOpsInsuranceActive(String tier, String price);

  /// No description provided for @vehicleHeistOpsInsurancePurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Insurance purchase failed.'**
  String get vehicleHeistOpsInsurancePurchaseFailed;

  /// No description provided for @vehicleHeistOpsCrewMatchButton.
  ///
  /// In en, this message translates to:
  /// **'Crew Match'**
  String get vehicleHeistOpsCrewMatchButton;

  /// No description provided for @vehicleHeistOpsCrewMatchWon.
  ///
  /// In en, this message translates to:
  /// **'Crew match won: +{reward}'**
  String vehicleHeistOpsCrewMatchWon(String reward);

  /// No description provided for @vehicleHeistOpsCrewMatchLost.
  ///
  /// In en, this message translates to:
  /// **'Crew match lost: +{reward} consolation'**
  String vehicleHeistOpsCrewMatchLost(String reward);

  /// No description provided for @vehicleHeistOpsCrewMatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Crew matchmaking failed.'**
  String get vehicleHeistOpsCrewMatchFailed;

  /// No description provided for @vehicleHeistOpsCounterButton.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get vehicleHeistOpsCounterButton;

  /// No description provided for @vehicleHeistOpsCounterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Counter-intercept success: +{reward}'**
  String vehicleHeistOpsCounterSuccess(String reward);

  /// No description provided for @vehicleHeistOpsCounterFailed.
  ///
  /// In en, this message translates to:
  /// **'Counter-intercept unavailable or failed.'**
  String get vehicleHeistOpsCounterFailed;

  /// No description provided for @vehicleHeistOpsOpsContractButton.
  ///
  /// In en, this message translates to:
  /// **'Ops Contract'**
  String get vehicleHeistOpsOpsContractButton;

  /// No description provided for @vehicleHeistOpsOpsContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Ops Contract'**
  String get vehicleHeistOpsOpsContractTitle;

  /// No description provided for @vehicleHeistOpsContractCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ops contract completed: +{reward}'**
  String vehicleHeistOpsContractCompleted(String reward);

  /// No description provided for @vehicleHeistOpsContractFailedOrCooldown.
  ///
  /// In en, this message translates to:
  /// **'Ops contract failed or on cooldown.'**
  String get vehicleHeistOpsContractFailedOrCooldown;

  /// No description provided for @vehicleHeistOpsClaimDisputeButton.
  ///
  /// In en, this message translates to:
  /// **'Claim dispute'**
  String get vehicleHeistOpsClaimDisputeButton;

  /// No description provided for @vehicleHeistOpsNoOpenClaims.
  ///
  /// In en, this message translates to:
  /// **'No open insurance claims.'**
  String get vehicleHeistOpsNoOpenClaims;

  /// No description provided for @vehicleHeistOpsNoValidClaimFound.
  ///
  /// In en, this message translates to:
  /// **'No valid claim found.'**
  String get vehicleHeistOpsNoValidClaimFound;

  /// No description provided for @vehicleHeistOpsClaimApproved.
  ///
  /// In en, this message translates to:
  /// **'Claim approved: +{amount}'**
  String vehicleHeistOpsClaimApproved(String amount);

  /// No description provided for @vehicleHeistOpsClaimRejected.
  ///
  /// In en, this message translates to:
  /// **'Claim rejected: -{amount}'**
  String vehicleHeistOpsClaimRejected(String amount);

  /// No description provided for @vehicleHeistOpsClaimResolutionFailed.
  ///
  /// In en, this message translates to:
  /// **'Claim resolution failed.'**
  String get vehicleHeistOpsClaimResolutionFailed;

  /// No description provided for @vehicleHeistOpsIntelTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Ops Intelligence'**
  String get vehicleHeistOpsIntelTitle;

  /// No description provided for @vehicleHeistOpsIntelRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh intelligence'**
  String get vehicleHeistOpsIntelRefreshTooltip;

  /// No description provided for @vehicleHeistOpsIntelTapToExpand.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand and view all actions.'**
  String get vehicleHeistOpsIntelTapToExpand;

  /// No description provided for @vehicleHeistOpsIntelHeatPill.
  ///
  /// In en, this message translates to:
  /// **'Heat {current} ({level})'**
  String vehicleHeistOpsIntelHeatPill(String current, String level);

  /// No description provided for @vehicleHeistOpsIntelPolicePill.
  ///
  /// In en, this message translates to:
  /// **'Police: {name}'**
  String vehicleHeistOpsIntelPolicePill(String name);

  /// No description provided for @vehicleHeistOpsIntelRepPill.
  ///
  /// In en, this message translates to:
  /// **'Rep lvl {level}'**
  String vehicleHeistOpsIntelRepPill(String level);

  /// No description provided for @vehicleHeistOpsIntelPartsMarketPill.
  ///
  /// In en, this message translates to:
  /// **'Parts market: {trend}'**
  String vehicleHeistOpsIntelPartsMarketPill(String trend);

  /// No description provided for @vehicleHeistOpsIntelHotspotLine.
  ///
  /// In en, this message translates to:
  /// **'Hotspot: {name}'**
  String vehicleHeistOpsIntelHotspotLine(String name);

  /// No description provided for @vehicleHeistOpsIntelHotspotRewardLine.
  ///
  /// In en, this message translates to:
  /// **'Reward: {min} - {max}'**
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max);

  /// No description provided for @vehicleHeistOpsIntelWhyCashLine.
  ///
  /// In en, this message translates to:
  /// **'Why you get cash: successful ops actions pay out directly to wallet cash.'**
  String get vehicleHeistOpsIntelWhyCashLine;

  /// No description provided for @vehicleHeistOpsIntelCashRangePayout.
  ///
  /// In en, this message translates to:
  /// **'Cash: {min} - {max}'**
  String vehicleHeistOpsIntelCashRangePayout(String min, String max);

  /// No description provided for @vehicleHeistOpsIntelYouCashRangePayout.
  ///
  /// In en, this message translates to:
  /// **'You: {min} - {max}'**
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max);

  /// No description provided for @vehicleHeistOpsIntelCashPayout.
  ///
  /// In en, this message translates to:
  /// **'Cash: {amount}'**
  String vehicleHeistOpsIntelCashPayout(String amount);

  /// No description provided for @vehicleHeistOpsIntelContractsPayout.
  ///
  /// In en, this message translates to:
  /// **'Contracts: {count}{fromPart}'**
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart);

  /// No description provided for @vehicleHeistOpsIntelContractsFrom.
  ///
  /// In en, this message translates to:
  /// **' | from {amount}'**
  String vehicleHeistOpsIntelContractsFrom(String amount);

  /// No description provided for @vehicleHeistOpsIntelPartsPricesLine.
  ///
  /// In en, this message translates to:
  /// **'Part prices (car/motorcycle/boat): {car} / {motorcycle} / {boat}'**
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  );

  /// No description provided for @vehicleHeistOpsIntelPartsMarketRefreshLine.
  ///
  /// In en, this message translates to:
  /// **'Parts market refresh: {cooldown}'**
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown);

  /// No description provided for @vehicleHeistOpsIntelCrewLine.
  ///
  /// In en, this message translates to:
  /// **'Crew: {name} ({size} members)'**
  String vehicleHeistOpsIntelCrewLine(String name, String size);

  /// No description provided for @vehicleHeistOpsIntelChopRewardLine.
  ///
  /// In en, this message translates to:
  /// **'Chop contract reward: {reward}'**
  String vehicleHeistOpsIntelChopRewardLine(String reward);

  /// No description provided for @vehicleHeistOpsIntelInterceptWindowLine.
  ///
  /// In en, this message translates to:
  /// **'Intercept window: {status}'**
  String vehicleHeistOpsIntelInterceptWindowLine(String status);

  /// No description provided for @vehicleHeistOpsIntelBlacklistLine.
  ///
  /// In en, this message translates to:
  /// **'Blacklist: {reason}'**
  String vehicleHeistOpsIntelBlacklistLine(String reason);

  /// No description provided for @vehicleHeistOpsIntelBlacklistNoneLine.
  ///
  /// In en, this message translates to:
  /// **'Blacklist: none'**
  String get vehicleHeistOpsIntelBlacklistNoneLine;

  /// No description provided for @vehicleHeistOpsIntelInsuranceActiveLine.
  ///
  /// In en, this message translates to:
  /// **'Insurance: {tier} active'**
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier);

  /// No description provided for @vehicleHeistOpsIntelInsuranceInactiveLine.
  ///
  /// In en, this message translates to:
  /// **'Insurance: inactive'**
  String get vehicleHeistOpsIntelInsuranceInactiveLine;

  /// No description provided for @vehicleHeistOpsIntelCountryModifierLine.
  ///
  /// In en, this message translates to:
  /// **'Country modifier: {name} ({multiplier}x)'**
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  );

  /// No description provided for @vehicleHeistOpsIntelCrewSeasonLine.
  ///
  /// In en, this message translates to:
  /// **'Crew season: {season} | points {points}'**
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points);

  /// No description provided for @vehicleHeistOpsIntelContractsCooldownLine.
  ///
  /// In en, this message translates to:
  /// **'Contracts: {count} | cooldown {cooldown}'**
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  );

  /// No description provided for @vehicleHeistOpsIntelCounterCooldownLine.
  ///
  /// In en, this message translates to:
  /// **'Counter cooldown: {cooldown} | open claims: {claims}'**
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  );

  /// No description provided for @tuneShop.
  ///
  /// In en, this message translates to:
  /// **'Tune Shop'**
  String get tuneShop;

  /// No description provided for @tuneShopIntro.
  ///
  /// In en, this message translates to:
  /// **'Scrap vehicles for parts and upgrade speed, stealth and armor. Parts are shared per category (car/motorcycle/boat), so you can tune any vehicle within the same category.'**
  String get tuneShopIntro;

  /// No description provided for @tuneShopCarPartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Car parts'**
  String get tuneShopCarPartsLabel;

  /// No description provided for @tuneShopMotorcyclePartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle parts'**
  String get tuneShopMotorcyclePartsLabel;

  /// No description provided for @tuneShopBoatPartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Boat parts'**
  String get tuneShopBoatPartsLabel;

  /// No description provided for @tuneShopEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available for tuning'**
  String get tuneShopEmptyTitle;

  /// No description provided for @tuneShopEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Steal some vehicles first and scrap a few for parts.'**
  String get tuneShopEmptyBody;

  /// No description provided for @tuneShopVehicleTypeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get tuneShopVehicleTypeCar;

  /// No description provided for @tuneShopVehicleTypeMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get tuneShopVehicleTypeMotorcycle;

  /// No description provided for @tuneShopVehicleTypeBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get tuneShopVehicleTypeBoat;

  /// No description provided for @tuneShopStatSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get tuneShopStatSpeed;

  /// No description provided for @tuneShopStatStealth.
  ///
  /// In en, this message translates to:
  /// **'Stealth'**
  String get tuneShopStatStealth;

  /// No description provided for @tuneShopStatArmor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get tuneShopStatArmor;

  /// No description provided for @tuneShopValueMultiplierPrefix.
  ///
  /// In en, this message translates to:
  /// **'Value x'**
  String get tuneShopValueMultiplierPrefix;

  /// No description provided for @tuneShopUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get tuneShopUpgradeButton;

  /// No description provided for @tuneShopMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get tuneShopMaxLabel;

  /// No description provided for @tuneShopPartsAbbrev.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get tuneShopPartsAbbrev;

  /// No description provided for @tuneShopUpgradeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Upgrade completed'**
  String get tuneShopUpgradeCompleted;

  /// No description provided for @tuneShopUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade failed'**
  String get tuneShopUpgradeFailed;

  /// No description provided for @tuneShopLockedVehicleInTransit.
  ///
  /// In en, this message translates to:
  /// **'Tuning locked: vehicle is in transit.'**
  String get tuneShopLockedVehicleInTransit;

  /// No description provided for @tuneShopLockedVehicleInRepair.
  ///
  /// In en, this message translates to:
  /// **'Tuning locked: vehicle is in repair.'**
  String get tuneShopLockedVehicleInRepair;

  /// No description provided for @tuneShopLockedCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Tuning cooldown active: {duration} remaining.'**
  String tuneShopLockedCooldownActive(String duration);

  /// No description provided for @tuneShopErrorVehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not found'**
  String get tuneShopErrorVehicleNotFound;

  /// No description provided for @tuneShopErrorNotOwner.
  ///
  /// In en, this message translates to:
  /// **'You do not own this vehicle'**
  String get tuneShopErrorNotOwner;

  /// No description provided for @tuneShopErrorVehicleInTransit.
  ///
  /// In en, this message translates to:
  /// **'Tuning locked: vehicle is in transit.'**
  String get tuneShopErrorVehicleInTransit;

  /// No description provided for @tuneShopErrorVehicleInRepair.
  ///
  /// In en, this message translates to:
  /// **'Tuning locked: vehicle is in repair.'**
  String get tuneShopErrorVehicleInRepair;

  /// No description provided for @tuneShopErrorInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Not enough money'**
  String get tuneShopErrorInsufficientFunds;

  /// No description provided for @tuneShopErrorInsufficientParts.
  ///
  /// In en, this message translates to:
  /// **'Not enough parts'**
  String get tuneShopErrorInsufficientParts;

  /// No description provided for @tuneShopErrorStatMaxed.
  ///
  /// In en, this message translates to:
  /// **'This tuning level is maxed'**
  String get tuneShopErrorStatMaxed;

  /// No description provided for @tuneShopErrorCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Tuning cooldown active: {duration} remaining.'**
  String tuneShopErrorCooldownActive(String duration);

  /// No description provided for @tuneShopErrorConcurrencyLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit reached: max {max} concurrent tuning, currently {active}.'**
  String tuneShopErrorConcurrencyLimit(String max, String active);

  /// No description provided for @tuneShopErrorInvalidStat.
  ///
  /// In en, this message translates to:
  /// **'Invalid tuning stat'**
  String get tuneShopErrorInvalidStat;

  /// No description provided for @territory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get territory;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @menuCrackVault.
  ///
  /// In en, this message translates to:
  /// **'Crack the Vault'**
  String get menuCrackVault;

  /// No description provided for @vaultHeroTagline.
  ///
  /// In en, this message translates to:
  /// **'Guess the code and win big prizes.'**
  String get vaultHeroTagline;

  /// No description provided for @vaultSeasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Season: {range}'**
  String vaultSeasonLabel(String range);

  /// No description provided for @vaultYourCredits.
  ///
  /// In en, this message translates to:
  /// **'Your credits'**
  String get vaultYourCredits;

  /// No description provided for @vaultChooseStake.
  ///
  /// In en, this message translates to:
  /// **'Choose your stake'**
  String get vaultChooseStake;

  /// No description provided for @vaultStakeCredits.
  ///
  /// In en, this message translates to:
  /// **'{stake, plural, one{{stake} credit} other{{stake} credits}}'**
  String vaultStakeCredits(int stake);

  /// No description provided for @vaultExpectedPrize.
  ///
  /// In en, this message translates to:
  /// **'Expected prize: +{reward} credits'**
  String vaultExpectedPrize(int reward);

  /// No description provided for @vaultCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get vaultCodeLabel;

  /// No description provided for @vaultSubmitStake.
  ///
  /// In en, this message translates to:
  /// **'Submit stake'**
  String get vaultSubmitStake;

  /// No description provided for @vaultWrongCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrong codes (this month)'**
  String get vaultWrongCodesTitle;

  /// No description provided for @vaultShowWrongCodes.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get vaultShowWrongCodes;

  /// No description provided for @vaultHideWrongCodes.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get vaultHideWrongCodes;

  /// No description provided for @vaultNoWrongCodesYet.
  ///
  /// In en, this message translates to:
  /// **'No wrong codes saved yet.'**
  String get vaultNoWrongCodesYet;

  /// No description provided for @couldNotLoadVaultStatus.
  ///
  /// In en, this message translates to:
  /// **'Could not load status.'**
  String get couldNotLoadVaultStatus;

  /// No description provided for @vaultEnterFourDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a 4-digit code.'**
  String get vaultEnterFourDigitCode;

  /// No description provided for @vaultAttemptSuccessGeneric.
  ///
  /// In en, this message translates to:
  /// **'Success.'**
  String get vaultAttemptSuccessGeneric;

  /// No description provided for @vaultAttemptFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Failed.'**
  String get vaultAttemptFailedGeneric;

  /// No description provided for @vaultAttemptFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Failed. Please try again.'**
  String get vaultAttemptFailedRetry;

  /// No description provided for @dashboardNewMessagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new messages'**
  String dashboardNewMessagesCount(int count);

  /// No description provided for @rankProgress.
  ///
  /// In en, this message translates to:
  /// **'Rank Progress'**
  String get rankProgress;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @sessionRecap.
  ///
  /// In en, this message translates to:
  /// **'Session recap'**
  String get sessionRecap;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @wantedLevel.
  ///
  /// In en, this message translates to:
  /// **'Wanted Level'**
  String get wantedLevel;

  /// No description provided for @fbiHeat.
  ///
  /// In en, this message translates to:
  /// **'FBI Heat'**
  String get fbiHeat;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @netWorth.
  ///
  /// In en, this message translates to:
  /// **'Net worth'**
  String get netWorth;

  /// No description provided for @securityLabel.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityLabel;

  /// No description provided for @noSecurity.
  ///
  /// In en, this message translates to:
  /// **'No security'**
  String get noSecurity;

  /// No description provided for @weaponLabel.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get weaponLabel;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @breakouts.
  ///
  /// In en, this message translates to:
  /// **'Breakouts'**
  String get breakouts;

  /// No description provided for @murders.
  ///
  /// In en, this message translates to:
  /// **'Murders'**
  String get murders;

  /// No description provided for @hitlistContracts.
  ///
  /// In en, this message translates to:
  /// **'Hitlist contracts'**
  String get hitlistContracts;

  /// No description provided for @carsStolen.
  ///
  /// In en, this message translates to:
  /// **'Cars stolen'**
  String get carsStolen;

  /// No description provided for @boatsStolen.
  ///
  /// In en, this message translates to:
  /// **'Boats stolen'**
  String get boatsStolen;

  /// No description provided for @crimeAttempts.
  ///
  /// In en, this message translates to:
  /// **'Crime attempts'**
  String get crimeAttempts;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @jobAttempts.
  ///
  /// In en, this message translates to:
  /// **'Job attempts'**
  String get jobAttempts;

  /// No description provided for @streetProstitutes.
  ///
  /// In en, this message translates to:
  /// **'Street prostitutes'**
  String get streetProstitutes;

  /// No description provided for @rldProstitutes.
  ///
  /// In en, this message translates to:
  /// **'RLD prostitutes'**
  String get rldProstitutes;

  /// No description provided for @travels.
  ///
  /// In en, this message translates to:
  /// **'Travels'**
  String get travels;

  /// No description provided for @bullets.
  ///
  /// In en, this message translates to:
  /// **'Bullets'**
  String get bullets;

  /// No description provided for @moneyStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Money status'**
  String get moneyStatusLabel;

  /// No description provided for @moneyStatusPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get moneyStatusPoor;

  /// No description provided for @moneyStatusRising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get moneyStatusRising;

  /// No description provided for @moneyStatusRich.
  ///
  /// In en, this message translates to:
  /// **'Rich'**
  String get moneyStatusRich;

  /// No description provided for @moneyStatusMultimillionaire.
  ///
  /// In en, this message translates to:
  /// **'Multimillionaire'**
  String get moneyStatusMultimillionaire;

  /// No description provided for @rankBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get rankBeginner;

  /// No description provided for @rankCriminal.
  ///
  /// In en, this message translates to:
  /// **'Criminal'**
  String get rankCriminal;

  /// No description provided for @rankGangster.
  ///
  /// In en, this message translates to:
  /// **'Gangster'**
  String get rankGangster;

  /// No description provided for @rankMafioso.
  ///
  /// In en, this message translates to:
  /// **'Mafioso'**
  String get rankMafioso;

  /// No description provided for @rankGodfather.
  ///
  /// In en, this message translates to:
  /// **'Godfather'**
  String get rankGodfather;

  /// No description provided for @dailyGoalTitle_crime_3.
  ///
  /// In en, this message translates to:
  /// **'Do 3 crimes'**
  String get dailyGoalTitle_crime_3;

  /// No description provided for @dailyGoalTitle_job_2.
  ///
  /// In en, this message translates to:
  /// **'Work 2 times'**
  String get dailyGoalTitle_job_2;

  /// No description provided for @dailyGoalTitle_vehicle_theft_1.
  ///
  /// In en, this message translates to:
  /// **'Steal 1 vehicle'**
  String get dailyGoalTitle_vehicle_theft_1;

  /// No description provided for @dailyGoalTitle_travel_1.
  ///
  /// In en, this message translates to:
  /// **'Complete 1 travel'**
  String get dailyGoalTitle_travel_1;

  /// No description provided for @dailyGoalTitle_weekly_crime_20.
  ///
  /// In en, this message translates to:
  /// **'Weekly: 20 crimes'**
  String get dailyGoalTitle_weekly_crime_20;

  /// No description provided for @dailyGoalTitle_weekly_job_10.
  ///
  /// In en, this message translates to:
  /// **'Weekly: work 10 times'**
  String get dailyGoalTitle_weekly_job_10;

  /// No description provided for @dailyGoalTitle_weekly_vehicle_theft_5.
  ///
  /// In en, this message translates to:
  /// **'Weekly: steal 5 vehicles'**
  String get dailyGoalTitle_weekly_vehicle_theft_5;

  /// No description provided for @dailyGoalTitle_weekly_travel_3.
  ///
  /// In en, this message translates to:
  /// **'Weekly: 3 travels'**
  String get dailyGoalTitle_weekly_travel_3;

  /// No description provided for @dailyGoalReward.
  ///
  /// In en, this message translates to:
  /// **'Reward: +{cash} and +{xp} XP'**
  String dailyGoalReward(String cash, String xp);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s ago'**
  String secondsAgo(String seconds);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(String count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(String count);

  /// No description provided for @last10EventsLive.
  ///
  /// In en, this message translates to:
  /// **'Last 10 events (live).'**
  String get last10EventsLive;

  /// No description provided for @noEventsYetSession.
  ///
  /// In en, this message translates to:
  /// **'No events yet in this session.'**
  String get noEventsYetSession;

  /// No description provided for @clearRecap.
  ///
  /// In en, this message translates to:
  /// **'Clear recap'**
  String get clearRecap;

  /// No description provided for @weeklyGoalClaimed.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal claimed!'**
  String get weeklyGoalClaimed;

  /// No description provided for @dailyGoalClaimed.
  ///
  /// In en, this message translates to:
  /// **'Daily goal claimed!'**
  String get dailyGoalClaimed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed.'**
  String get failed;

  /// No description provided for @failedPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed. Please try again.'**
  String get failedPleaseTryAgain;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily goals'**
  String get dailyGoals;

  /// No description provided for @weeklyGoals.
  ///
  /// In en, this message translates to:
  /// **'Weekly goals'**
  String get weeklyGoals;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @readyToClaim.
  ///
  /// In en, this message translates to:
  /// **'{count} ready to claim'**
  String readyToClaim(String count);

  /// No description provided for @completedOutOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} completed'**
  String completedOutOfTotal(String completed, String total);

  /// No description provided for @noPlayerData.
  ///
  /// In en, this message translates to:
  /// **'No player data'**
  String get noPlayerData;

  /// No description provided for @economy24h.
  ///
  /// In en, this message translates to:
  /// **'Economy 24h'**
  String get economy24h;

  /// No description provided for @grossIncome.
  ///
  /// In en, this message translates to:
  /// **'Gross income'**
  String get grossIncome;

  /// No description provided for @propertySpend.
  ///
  /// In en, this message translates to:
  /// **'Property spend'**
  String get propertySpend;

  /// No description provided for @netCashflow.
  ///
  /// In en, this message translates to:
  /// **'Net cashflow'**
  String get netCashflow;

  /// No description provided for @trendVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'Trend vs previous'**
  String get trendVsPrevious;

  /// No description provided for @activity7d.
  ///
  /// In en, this message translates to:
  /// **'Activity 7d'**
  String get activity7d;

  /// No description provided for @vehicleThefts.
  ///
  /// In en, this message translates to:
  /// **'Vehicle thefts'**
  String get vehicleThefts;

  /// No description provided for @opsOverview.
  ///
  /// In en, this message translates to:
  /// **'Ops Overview'**
  String get opsOverview;

  /// No description provided for @activeCooldowns.
  ///
  /// In en, this message translates to:
  /// **'Active cooldowns'**
  String get activeCooldowns;

  /// No description provided for @longestTimer.
  ///
  /// In en, this message translates to:
  /// **'Longest timer'**
  String get longestTimer;

  /// No description provided for @activeProduction.
  ///
  /// In en, this message translates to:
  /// **'Active production'**
  String get activeProduction;

  /// No description provided for @productionReadyIn.
  ///
  /// In en, this message translates to:
  /// **'Production ready in'**
  String get productionReadyIn;

  /// No description provided for @nightclubEvents.
  ///
  /// In en, this message translates to:
  /// **'Nightclub events'**
  String get nightclubEvents;

  /// No description provided for @nextEventStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Next event starts in'**
  String get nextEventStartsIn;

  /// No description provided for @vehiclesActiveListedTransit.
  ///
  /// In en, this message translates to:
  /// **'Vehicles active/listed/transit'**
  String get vehiclesActiveListedTransit;

  /// No description provided for @livePlayerEvents.
  ///
  /// In en, this message translates to:
  /// **'Live player events'**
  String get livePlayerEvents;

  /// No description provided for @openEvents.
  ///
  /// In en, this message translates to:
  /// **'Open Events'**
  String get openEvents;

  /// No description provided for @notificationsAndRisk.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Risk'**
  String get notificationsAndRisk;

  /// No description provided for @unreadDm.
  ///
  /// In en, this message translates to:
  /// **'Unread DM'**
  String get unreadDm;

  /// No description provided for @supportWaitingOnYou.
  ///
  /// In en, this message translates to:
  /// **'Support waiting on you'**
  String get supportWaitingOnYou;

  /// No description provided for @eventsLast24h.
  ///
  /// In en, this message translates to:
  /// **'Events last 24h'**
  String get eventsLast24h;

  /// No description provided for @riskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk score'**
  String get riskScore;

  /// No description provided for @recruitProstitute.
  ///
  /// In en, this message translates to:
  /// **'Recruit prostitute'**
  String get recruitProstitute;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// No description provided for @crewWars.
  ///
  /// In en, this message translates to:
  /// **'Crew Wars'**
  String get crewWars;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @canDeclare.
  ///
  /// In en, this message translates to:
  /// **'Can declare'**
  String get canDeclare;

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

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @opponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// No description provided for @crewPoints.
  ///
  /// In en, this message translates to:
  /// **'Crew points'**
  String get crewPoints;

  /// No description provided for @warRank.
  ///
  /// In en, this message translates to:
  /// **'War rank'**
  String get warRank;

  /// No description provided for @seasonRank.
  ///
  /// In en, this message translates to:
  /// **'Season rank'**
  String get seasonRank;

  /// No description provided for @openTargets.
  ///
  /// In en, this message translates to:
  /// **'Open targets'**
  String get openTargets;

  /// No description provided for @phaseEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Phase ends in'**
  String get phaseEndsIn;

  /// No description provided for @crewTerritory.
  ///
  /// In en, this message translates to:
  /// **'Crew Territory'**
  String get crewTerritory;

  /// No description provided for @regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions;

  /// No description provided for @countriesCaptured.
  ///
  /// In en, this message translates to:
  /// **'Countries captured'**
  String get countriesCaptured;

  /// No description provided for @payout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get payout;

  /// No description provided for @earningPerHour.
  ///
  /// In en, this message translates to:
  /// **'Earning now per hour'**
  String get earningPerHour;

  /// No description provided for @earningPerDay.
  ///
  /// In en, this message translates to:
  /// **'Earning now per day'**
  String get earningPerDay;

  /// No description provided for @totalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total earned'**
  String get totalEarned;

  /// No description provided for @crewBank.
  ///
  /// In en, this message translates to:
  /// **'Crew bank'**
  String get crewBank;

  /// No description provided for @dashboardEconomy24h.
  ///
  /// In en, this message translates to:
  /// **'Economy 24h'**
  String get dashboardEconomy24h;

  /// No description provided for @dashboardGrossIncome.
  ///
  /// In en, this message translates to:
  /// **'Gross income'**
  String get dashboardGrossIncome;

  /// No description provided for @dashboardPropertySpend.
  ///
  /// In en, this message translates to:
  /// **'Property spend'**
  String get dashboardPropertySpend;

  /// No description provided for @dashboardNetCashflow.
  ///
  /// In en, this message translates to:
  /// **'Net cashflow'**
  String get dashboardNetCashflow;

  /// No description provided for @dashboardTrendVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'Trend vs previous'**
  String get dashboardTrendVsPrevious;

  /// No description provided for @dashboardActivity7d.
  ///
  /// In en, this message translates to:
  /// **'Activity 7d'**
  String get dashboardActivity7d;

  /// No description provided for @dashboardVehicleThefts.
  ///
  /// In en, this message translates to:
  /// **'Vehicle thefts'**
  String get dashboardVehicleThefts;

  /// No description provided for @dashboardOpsOverview.
  ///
  /// In en, this message translates to:
  /// **'Ops Overview'**
  String get dashboardOpsOverview;

  /// No description provided for @dashboardActiveCooldowns.
  ///
  /// In en, this message translates to:
  /// **'Active cooldowns'**
  String get dashboardActiveCooldowns;

  /// No description provided for @dashboardLongestTimer.
  ///
  /// In en, this message translates to:
  /// **'Longest timer'**
  String get dashboardLongestTimer;

  /// No description provided for @dashboardActiveProduction.
  ///
  /// In en, this message translates to:
  /// **'Active production'**
  String get dashboardActiveProduction;

  /// No description provided for @dashboardProductionReadyIn.
  ///
  /// In en, this message translates to:
  /// **'Production ready in'**
  String get dashboardProductionReadyIn;

  /// No description provided for @dashboardNightclubEvents.
  ///
  /// In en, this message translates to:
  /// **'Nightclub events'**
  String get dashboardNightclubEvents;

  /// No description provided for @dashboardNextEventStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Next event starts in'**
  String get dashboardNextEventStartsIn;

  /// No description provided for @dashboardVehiclesActiveListedTransit.
  ///
  /// In en, this message translates to:
  /// **'Vehicles active/listed/transit'**
  String get dashboardVehiclesActiveListedTransit;

  /// No description provided for @dashboardLivePlayerEvents.
  ///
  /// In en, this message translates to:
  /// **'Live player events'**
  String get dashboardLivePlayerEvents;

  /// No description provided for @dashboardOpenEvents.
  ///
  /// In en, this message translates to:
  /// **'Open Events'**
  String get dashboardOpenEvents;

  /// No description provided for @dashboardNotificationsAndRisk.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Risk'**
  String get dashboardNotificationsAndRisk;

  /// No description provided for @dashboardUnreadDm.
  ///
  /// In en, this message translates to:
  /// **'Unread DM'**
  String get dashboardUnreadDm;

  /// No description provided for @dashboardSupportWaitingOnYou.
  ///
  /// In en, this message translates to:
  /// **'Support waiting on you'**
  String get dashboardSupportWaitingOnYou;

  /// No description provided for @dashboardEventsLast24h.
  ///
  /// In en, this message translates to:
  /// **'Events last 24h'**
  String get dashboardEventsLast24h;

  /// No description provided for @dashboardRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk score'**
  String get dashboardRiskScore;

  /// No description provided for @dashboardRecruitProstitute.
  ///
  /// In en, this message translates to:
  /// **'Recruit prostitute'**
  String get dashboardRecruitProstitute;

  /// No description provided for @dashboardCrewWars.
  ///
  /// In en, this message translates to:
  /// **'Crew Wars'**
  String get dashboardCrewWars;

  /// No description provided for @dashboardStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashboardStatusLabel;

  /// No description provided for @dashboardCanDeclare.
  ///
  /// In en, this message translates to:
  /// **'Can declare'**
  String get dashboardCanDeclare;

  /// No description provided for @dashboardTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get dashboardTypeLabel;

  /// No description provided for @dashboardOpponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get dashboardOpponent;

  /// No description provided for @dashboardCrewPoints.
  ///
  /// In en, this message translates to:
  /// **'Crew points'**
  String get dashboardCrewPoints;

  /// No description provided for @dashboardWarRank.
  ///
  /// In en, this message translates to:
  /// **'War rank'**
  String get dashboardWarRank;

  /// No description provided for @dashboardSeasonRank.
  ///
  /// In en, this message translates to:
  /// **'Season rank'**
  String get dashboardSeasonRank;

  /// No description provided for @dashboardOpenTargets.
  ///
  /// In en, this message translates to:
  /// **'Open targets'**
  String get dashboardOpenTargets;

  /// No description provided for @dashboardPhaseEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Phase ends in'**
  String get dashboardPhaseEndsIn;

  /// No description provided for @dashboardJailStatusIn.
  ///
  /// In en, this message translates to:
  /// **'In jail ({duration})'**
  String dashboardJailStatusIn(String duration);

  /// No description provided for @dashboardCrewWarStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get dashboardCrewWarStatusPreparing;

  /// No description provided for @dashboardCrewWarStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dashboardCrewWarStatusActive;

  /// No description provided for @dashboardCrewWarStatusLockdown.
  ///
  /// In en, this message translates to:
  /// **'Lockdown'**
  String get dashboardCrewWarStatusLockdown;

  /// No description provided for @dashboardCrewWarStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get dashboardCrewWarStatusResolved;

  /// No description provided for @dashboardCrewWarStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get dashboardCrewWarStatusArchived;

  /// No description provided for @dashboardCrewWarStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dashboardCrewWarStatusCancelled;

  /// No description provided for @dashboardCrewWarStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No active war'**
  String get dashboardCrewWarStatusNone;

  /// No description provided for @dashboardCrewWarTypeKill.
  ///
  /// In en, this message translates to:
  /// **'Kill War'**
  String get dashboardCrewWarTypeKill;

  /// No description provided for @dashboardCrewWarTypeEconomy.
  ///
  /// In en, this message translates to:
  /// **'Economy War'**
  String get dashboardCrewWarTypeEconomy;

  /// No description provided for @dashboardCrewWarTypeTerritory.
  ///
  /// In en, this message translates to:
  /// **'Territory War'**
  String get dashboardCrewWarTypeTerritory;

  /// No description provided for @dashboardCrewWarTypeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total War'**
  String get dashboardCrewWarTypeTotal;

  /// No description provided for @dashboardClicks.
  ///
  /// In en, this message translates to:
  /// **'Clicks'**
  String get dashboardClicks;

  /// No description provided for @dashboardValueNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dashboardValueNotAvailable;

  /// No description provided for @dashboardPremiumOfferDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Special offer'**
  String get dashboardPremiumOfferDefaultTitle;

  /// No description provided for @dashboardCrewWarTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dashboardCrewWarTypeUnknown;

  /// No description provided for @dashboardTerritoryIncomeNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'not configured'**
  String get dashboardTerritoryIncomeNotConfigured;

  /// No description provided for @dashboardTerritoryIncomeEveryHours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, one{every hour} other{every {hours} hours}}'**
  String dashboardTerritoryIncomeEveryHours(int hours);

  /// No description provided for @dashboardTerritoryIncomeEveryMinutes.
  ///
  /// In en, this message translates to:
  /// **'every {minutes} min'**
  String dashboardTerritoryIncomeEveryMinutes(int minutes);

  /// No description provided for @dashboardCrewTerritory.
  ///
  /// In en, this message translates to:
  /// **'Crew Territory'**
  String get dashboardCrewTerritory;

  /// No description provided for @dashboardRegions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get dashboardRegions;

  /// No description provided for @dashboardCountriesCaptured.
  ///
  /// In en, this message translates to:
  /// **'Countries captured'**
  String get dashboardCountriesCaptured;

  /// No description provided for @dashboardPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get dashboardPayout;

  /// No description provided for @dashboardEarningPerHour.
  ///
  /// In en, this message translates to:
  /// **'Earning now per hour'**
  String get dashboardEarningPerHour;

  /// No description provided for @dashboardEarningPerDay.
  ///
  /// In en, this message translates to:
  /// **'Earning now per day'**
  String get dashboardEarningPerDay;

  /// No description provided for @dashboardTotalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total earned'**
  String get dashboardTotalEarned;

  /// No description provided for @dashboardVehicleOps.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Ops'**
  String get dashboardVehicleOps;

  /// No description provided for @dashboardKillProgress.
  ///
  /// In en, this message translates to:
  /// **'Kill Progress'**
  String get dashboardKillProgress;

  /// No description provided for @vehicleOpsHeat.
  ///
  /// In en, this message translates to:
  /// **'Heat'**
  String get vehicleOpsHeat;

  /// No description provided for @vehicleOpsHeatLevelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get vehicleOpsHeatLevelLow;

  /// No description provided for @vehicleOpsHeatLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get vehicleOpsHeatLevelMedium;

  /// No description provided for @vehicleOpsHeatLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get vehicleOpsHeatLevelHigh;

  /// No description provided for @vehicleOpsReputation.
  ///
  /// In en, this message translates to:
  /// **'Rep'**
  String get vehicleOpsReputation;

  /// No description provided for @vehicleOpsPartsTrendUp.
  ///
  /// In en, this message translates to:
  /// **'parts market rising'**
  String get vehicleOpsPartsTrendUp;

  /// No description provided for @vehicleOpsPartsTrendDown.
  ///
  /// In en, this message translates to:
  /// **'parts market falling'**
  String get vehicleOpsPartsTrendDown;

  /// No description provided for @vehicleOpsPartsTrendStable.
  ///
  /// In en, this message translates to:
  /// **'parts market stable'**
  String get vehicleOpsPartsTrendStable;

  /// No description provided for @vehicleOpsBlacklistActive.
  ///
  /// In en, this message translates to:
  /// **'Blacklist active'**
  String get vehicleOpsBlacklistActive;

  /// No description provided for @vehicleOpsNoBlacklist.
  ///
  /// In en, this message translates to:
  /// **'No blacklist'**
  String get vehicleOpsNoBlacklist;

  /// No description provided for @prisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Prison'**
  String get prisonTitle;

  /// No description provided for @prisonLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load prisoners'**
  String get prisonLoadFailed;

  /// No description provided for @prisonNoPrisonersFound.
  ///
  /// In en, this message translates to:
  /// **'No prisoners found'**
  String get prisonNoPrisonersFound;

  /// No description provided for @prisonRankLine.
  ///
  /// In en, this message translates to:
  /// **'Rank: {rank}'**
  String prisonRankLine(String rank);

  /// No description provided for @prisonRankYouLine.
  ///
  /// In en, this message translates to:
  /// **'Rank: {rank} · You'**
  String prisonRankYouLine(String rank);

  /// No description provided for @prisonRemainingTimeLine.
  ///
  /// In en, this message translates to:
  /// **'Remaining time: {duration}'**
  String prisonRemainingTimeLine(String duration);

  /// No description provided for @prisonBailLine.
  ///
  /// In en, this message translates to:
  /// **'Bail: €{amount}'**
  String prisonBailLine(String amount);

  /// No description provided for @prisonPayBailButton.
  ///
  /// In en, this message translates to:
  /// **'Pay bail'**
  String get prisonPayBailButton;

  /// No description provided for @prisonBuyOutButton.
  ///
  /// In en, this message translates to:
  /// **'Buy out'**
  String get prisonBuyOutButton;

  /// No description provided for @prisonAttemptEscapeButton.
  ///
  /// In en, this message translates to:
  /// **'Attempt escape'**
  String get prisonAttemptEscapeButton;

  /// No description provided for @prisonJailbreakButton.
  ///
  /// In en, this message translates to:
  /// **'Jailbreak'**
  String get prisonJailbreakButton;

  /// No description provided for @prisonActionFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Action failed'**
  String get prisonActionFailed;

  /// No description provided for @prisonBuyoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Bought out {username} for €{amount}'**
  String prisonBuyoutSuccess(String username, String amount);

  /// No description provided for @prisonPaidBailSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ You paid bail for €{amount} and are free'**
  String prisonPaidBailSuccess(String amount);

  /// No description provided for @prisonEscapeSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Escape succeeded! You are free.'**
  String get prisonEscapeSuccess;

  /// No description provided for @prisonEscapeFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Escape failed. Sentence extended by {penalty}.'**
  String prisonEscapeFailed(String penalty);

  /// No description provided for @prisonCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Cooldown active: wait {duration}'**
  String prisonCooldownActive(String duration);

  /// No description provided for @prisonEscapeGenericFailure.
  ///
  /// In en, this message translates to:
  /// **'❌ Escape failed'**
  String get prisonEscapeGenericFailure;

  /// No description provided for @prisonErrorInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'❌ Not enough money'**
  String get prisonErrorInsufficientFunds;

  /// No description provided for @prisonErrorTargetNotJailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Target is no longer in prison'**
  String get prisonErrorTargetNotJailed;

  /// No description provided for @prisonErrorCannotBuyoutSelf.
  ///
  /// In en, this message translates to:
  /// **'❌ You cannot buy yourself out'**
  String get prisonErrorCannotBuyoutSelf;

  /// No description provided for @prisonErrorPlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'❌ Player not found'**
  String get prisonErrorPlayerNotFound;

  /// No description provided for @prisonJailbreakSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Jailbreak succeeded! Prisoner is free.'**
  String get prisonJailbreakSuccess;

  /// No description provided for @prisonJailbreakCaught.
  ///
  /// In en, this message translates to:
  /// **'🚔 Jailbreak failed, you got caught ({minutes} min jail).'**
  String prisonJailbreakCaught(String minutes);

  /// No description provided for @prisonJailbreakFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Jailbreak failed. Prisoner is still locked up.'**
  String get prisonJailbreakFailed;

  /// No description provided for @prisonErrorRescuerJailed.
  ///
  /// In en, this message translates to:
  /// **'❌ You are in jail yourself'**
  String get prisonErrorRescuerJailed;

  /// No description provided for @prisonJailbreakGenericFailure.
  ///
  /// In en, this message translates to:
  /// **'❌ Jailbreak failed'**
  String get prisonJailbreakGenericFailure;

  /// No description provided for @crewJailbreakTitle.
  ///
  /// In en, this message translates to:
  /// **'🚔 Jailed Crew'**
  String get crewJailbreakTitle;

  /// No description provided for @crewJailbreakLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load jailed members'**
  String get crewJailbreakLoadFailed;

  /// No description provided for @crewJailbreakEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 No one in jail!'**
  String get crewJailbreakEmptyTitle;

  /// No description provided for @crewJailbreakEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'All crew members are free'**
  String get crewJailbreakEmptyBody;

  /// No description provided for @crewJailbreakAttemptFor.
  ///
  /// In en, this message translates to:
  /// **'Jailbreak attempt for {username}:'**
  String crewJailbreakAttemptFor(String username);

  /// No description provided for @crewJailbreakRiskSuccess.
  ///
  /// In en, this message translates to:
  /// **'If successful: Player freed!'**
  String get crewJailbreakRiskSuccess;

  /// No description provided for @crewJailbreakRiskFailChance.
  ///
  /// In en, this message translates to:
  /// **'If failed: 60% chance caught'**
  String get crewJailbreakRiskFailChance;

  /// No description provided for @crewJailbreakRiskCaughtPenalty.
  ///
  /// In en, this message translates to:
  /// **'Caught: 30-60 min jail + wanted +10'**
  String get crewJailbreakRiskCaughtPenalty;

  /// No description provided for @crewJailbreakTip.
  ///
  /// In en, this message translates to:
  /// **'Success chance increases with rank and crew bonus!'**
  String get crewJailbreakTip;

  /// No description provided for @crewJailbreakAttemptButton.
  ///
  /// In en, this message translates to:
  /// **'Attempt Jailbreak'**
  String get crewJailbreakAttemptButton;

  /// No description provided for @crewJailbreakActionFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Action failed'**
  String get crewJailbreakActionFailed;

  /// No description provided for @crewJailbreakMemberJailTimeLine.
  ///
  /// In en, this message translates to:
  /// **'⏱️ {minutes} minutes in jail'**
  String crewJailbreakMemberJailTimeLine(String minutes);

  /// No description provided for @crewJailbreakRescueButton.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get crewJailbreakRescueButton;

  /// No description provided for @crewRoleLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get crewRoleLeader;

  /// No description provided for @crewRoleCoLeader.
  ///
  /// In en, this message translates to:
  /// **'Co-leader'**
  String get crewRoleCoLeader;

  /// No description provided for @crewRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get crewRoleMember;

  /// No description provided for @vehicleOpsHotspot.
  ///
  /// In en, this message translates to:
  /// **'Hotspot'**
  String get vehicleOpsHotspot;

  /// No description provided for @vehicleOpsCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get vehicleOpsCrew;

  /// No description provided for @vehicleOpsCrewMatch.
  ///
  /// In en, this message translates to:
  /// **'Crew match'**
  String get vehicleOpsCrewMatch;

  /// No description provided for @vehicleOpsChop.
  ///
  /// In en, this message translates to:
  /// **'Chop'**
  String get vehicleOpsChop;

  /// No description provided for @vehicleOpsContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get vehicleOpsContract;

  /// No description provided for @vehicleOpsCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get vehicleOpsCounter;

  /// No description provided for @vehicleOpsContracts.
  ///
  /// In en, this message translates to:
  /// **'Contracts'**
  String get vehicleOpsContracts;

  /// No description provided for @vehicleOpsClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get vehicleOpsClaims;

  /// No description provided for @vehicleOpsSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get vehicleOpsSeason;

  /// No description provided for @dashboardCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get dashboardCar;

  /// No description provided for @dashboardMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get dashboardMotorcycle;

  /// No description provided for @dashboardBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get dashboardBoat;

  /// No description provided for @dashboardCrewAccess.
  ///
  /// In en, this message translates to:
  /// **'Crew access'**
  String get dashboardCrewAccess;

  /// No description provided for @dashboardCrewRole.
  ///
  /// In en, this message translates to:
  /// **'Crew role'**
  String get dashboardCrewRole;

  /// No description provided for @dashboardUnavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get dashboardUnavailable;

  /// No description provided for @vehicleOps.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Ops'**
  String get vehicleOps;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @boat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get boat;

  /// No description provided for @crewAccess.
  ///
  /// In en, this message translates to:
  /// **'Crew access'**
  String get crewAccess;

  /// No description provided for @crewRole.
  ///
  /// In en, this message translates to:
  /// **'Crew role'**
  String get crewRole;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get unavailable;

  /// No description provided for @quickActionsCrimesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Commit criminal acts'**
  String get quickActionsCrimesSubtitle;

  /// No description provided for @quickActionsVehicleHeistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Car, motorcycle and boat'**
  String get quickActionsVehicleHeistSubtitle;

  /// No description provided for @quickActionsTuneShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Parts and upgrades'**
  String get quickActionsTuneShopSubtitle;

  /// No description provided for @quickActionsEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active and upcoming events'**
  String get quickActionsEventsSubtitle;

  /// No description provided for @quickActionsJobsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Earn legal money'**
  String get quickActionsJobsSubtitle;

  /// No description provided for @quickActionsCasinoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gamble your money'**
  String get quickActionsCasinoSubtitle;

  /// No description provided for @quickActionsBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your global balance'**
  String get quickActionsBankSubtitle;

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

  /// No description provided for @avatarChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change avatar'**
  String get avatarChangeFailed;

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

  /// No description provided for @usernameChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change username'**
  String get usernameChangeFailed;

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

  /// No description provided for @settingsSystemNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'System notifications for app'**
  String get settingsSystemNotificationsTitle;

  /// No description provided for @settingsPushPermissionAllowedLinked.
  ///
  /// In en, this message translates to:
  /// **'Permission: allowed, device linked'**
  String get settingsPushPermissionAllowedLinked;

  /// No description provided for @settingsPushPermissionAllowedRelinking.
  ///
  /// In en, this message translates to:
  /// **'Permission: allowed, device is re-linking'**
  String get settingsPushPermissionAllowedRelinking;

  /// No description provided for @settingsPushPermissionProvisionalLinked.
  ///
  /// In en, this message translates to:
  /// **'Permission: provisional, device linked'**
  String get settingsPushPermissionProvisionalLinked;

  /// No description provided for @settingsPushPermissionProvisionalRelinking.
  ///
  /// In en, this message translates to:
  /// **'Permission: provisional, device is re-linking'**
  String get settingsPushPermissionProvisionalRelinking;

  /// No description provided for @settingsPushPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission: denied'**
  String get settingsPushPermissionDenied;

  /// No description provided for @settingsPushPermissionNotRequested.
  ///
  /// In en, this message translates to:
  /// **'Permission: not requested yet'**
  String get settingsPushPermissionNotRequested;

  /// No description provided for @settingsPushPermissionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Permission: unknown'**
  String get settingsPushPermissionUnknown;

  /// No description provided for @settingsDeviceTokenRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device token registered on server'**
  String get settingsDeviceTokenRegistered;

  /// No description provided for @settingsDeviceTokenNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'No device token registered yet'**
  String get settingsDeviceTokenNotRegistered;

  /// No description provided for @settingsPushHelpText.
  ///
  /// In en, this message translates to:
  /// **'Use this button to request browser/iPhone permission again and register your push token.'**
  String get settingsPushHelpText;

  /// No description provided for @working.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get working;

  /// No description provided for @settingsEnablePush.
  ///
  /// In en, this message translates to:
  /// **'Enable push'**
  String get settingsEnablePush;

  /// No description provided for @settingsPushEnabledToast.
  ///
  /// In en, this message translates to:
  /// **'Push notifications enabled. New notifications will now be received.'**
  String get settingsPushEnabledToast;

  /// No description provided for @settingsPushDisabledInSystem.
  ///
  /// In en, this message translates to:
  /// **'Push is disabled in your browser/iPhone settings. Enable notifications for this app.'**
  String get settingsPushDisabledInSystem;

  /// No description provided for @settingsEnablePushFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable push notifications: {error}'**
  String settingsEnablePushFailed(String error);

  /// No description provided for @settingsPlayerEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Player events'**
  String get settingsPlayerEventsTitle;

  /// No description provided for @settingsPushLivePlayerEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: live player events'**
  String get settingsPushLivePlayerEventsTitle;

  /// No description provided for @settingsPushLivePlayerEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start and end of recurring competition events (e.g. top-score rounds).'**
  String get settingsPushLivePlayerEventsSubtitle;

  /// No description provided for @settingsCryptoNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Crypto Notifications'**
  String get settingsCryptoNotificationsTitle;

  /// No description provided for @settingsCryptoPushTradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: Trades'**
  String get settingsCryptoPushTradesTitle;

  /// No description provided for @settingsCryptoPushTradesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification for buy/sell trades'**
  String get settingsCryptoPushTradesSubtitle;

  /// No description provided for @settingsCryptoPushPriceAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: Price alerts'**
  String get settingsCryptoPushPriceAlertsTitle;

  /// No description provided for @settingsCryptoPushPriceAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification for relevant price moves'**
  String get settingsCryptoPushPriceAlertsSubtitle;

  /// No description provided for @settingsCryptoPushOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: Orders'**
  String get settingsCryptoPushOrdersTitle;

  /// No description provided for @settingsCryptoPushOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification when order is triggered or filled'**
  String get settingsCryptoPushOrdersSubtitle;

  /// No description provided for @settingsCryptoPushMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: Missions'**
  String get settingsCryptoPushMissionsTitle;

  /// No description provided for @settingsCryptoPushMissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification when a crypto mission is completed'**
  String get settingsCryptoPushMissionsSubtitle;

  /// No description provided for @settingsCryptoPushLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Push: Leaderboard'**
  String get settingsCryptoPushLeaderboardTitle;

  /// No description provided for @settingsCryptoPushLeaderboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification for crypto leaderboard rewards'**
  String get settingsCryptoPushLeaderboardSubtitle;

  /// No description provided for @settingsCryptoInAppTradesTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app: Trades'**
  String get settingsCryptoInAppTradesTitle;

  /// No description provided for @settingsCryptoInAppTradesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show trade events in your event feed'**
  String get settingsCryptoInAppTradesSubtitle;

  /// No description provided for @settingsCryptoInAppPriceAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app: Price alerts'**
  String get settingsCryptoInAppPriceAlertsTitle;

  /// No description provided for @settingsCryptoInAppPriceAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show price alert events in your event feed'**
  String get settingsCryptoInAppPriceAlertsSubtitle;

  /// No description provided for @settingsCryptoInAppOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app: Orders'**
  String get settingsCryptoInAppOrdersTitle;

  /// No description provided for @settingsCryptoInAppOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show order events in your event feed'**
  String get settingsCryptoInAppOrdersSubtitle;

  /// No description provided for @settingsCryptoInAppMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app: Missions'**
  String get settingsCryptoInAppMissionsTitle;

  /// No description provided for @settingsCryptoInAppMissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show mission completions in your event feed'**
  String get settingsCryptoInAppMissionsSubtitle;

  /// No description provided for @settingsCryptoInAppLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app: Leaderboard'**
  String get settingsCryptoInAppLeaderboardTitle;

  /// No description provided for @settingsCryptoInAppLeaderboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show leaderboard rewards in your event feed'**
  String get settingsCryptoInAppLeaderboardSubtitle;

  /// No description provided for @settingsAvatarChangeWeeklyLimit.
  ///
  /// In en, this message translates to:
  /// **'You can only change your avatar once per week'**
  String get settingsAvatarChangeWeeklyLimit;

  /// No description provided for @settingsUsernameChangeMonthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'You can only change your username once per month'**
  String get settingsUsernameChangeMonthlyLimit;

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

  /// No description provided for @friendsUiTabActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get friendsUiTabActivity;

  /// No description provided for @friendsUiTabRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get friendsUiTabRequests;

  /// No description provided for @friendsUiTabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get friendsUiTabSearch;

  /// No description provided for @friendsUiEmptyListTitle.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get friendsUiEmptyListTitle;

  /// No description provided for @friendsUiEmptyListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for players and add them as friends!'**
  String get friendsUiEmptyListSubtitle;

  /// No description provided for @friendsUiNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get friendsUiNoRequests;

  /// No description provided for @friendsUiLineRank.
  ///
  /// In en, this message translates to:
  /// **'Rank: {rank}'**
  String friendsUiLineRank(String rank);

  /// No description provided for @friendsUiLineLocation.
  ///
  /// In en, this message translates to:
  /// **'Location: {location}'**
  String friendsUiLineLocation(String location);

  /// No description provided for @friendsUiLineHealth.
  ///
  /// In en, this message translates to:
  /// **'Health: {percent}%'**
  String friendsUiLineHealth(String percent);

  /// No description provided for @friendsUiLineFriendsSince.
  ///
  /// In en, this message translates to:
  /// **'Friends since: {date}'**
  String friendsUiLineFriendsSince(String date);

  /// No description provided for @friendsUiRemoveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get friendsUiRemoveDialogTitle;

  /// No description provided for @friendsUiRemoveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this friend?'**
  String get friendsUiRemoveDialogBody;

  /// No description provided for @friendsUiRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get friendsUiRemoveConfirm;

  /// No description provided for @friendsUiBlockDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Block player'**
  String get friendsUiBlockDialogTitle;

  /// No description provided for @friendsUiBlockDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block {username}? You won\'t be able to send or receive messages.'**
  String friendsUiBlockDialogBody(String username);

  /// No description provided for @friendsUiBlockButton.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get friendsUiBlockButton;

  /// No description provided for @friendsUiSnackRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friendsUiSnackRequestSent;

  /// No description provided for @friendsUiSnackRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get friendsUiSnackRequestAccepted;

  /// No description provided for @friendsUiSnackRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Friend request rejected'**
  String get friendsUiSnackRequestRejected;

  /// No description provided for @friendsUiSnackFriendRemoved.
  ///
  /// In en, this message translates to:
  /// **'Friend removed'**
  String get friendsUiSnackFriendRemoved;

  /// No description provided for @friendsUiSnackPlayerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Player blocked'**
  String get friendsUiSnackPlayerBlocked;

  /// No description provided for @friendsUiSnackError.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String friendsUiSnackError(String details);

  /// No description provided for @friendsUiSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search player'**
  String get friendsUiSearchLabel;

  /// No description provided for @friendsUiSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters'**
  String get friendsUiSearchHint;

  /// No description provided for @friendsUiSearchMinChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search'**
  String get friendsUiSearchMinChars;

  /// No description provided for @friendsUiNoPlayersFound.
  ///
  /// In en, this message translates to:
  /// **'No players found'**
  String get friendsUiNoPlayersFound;

  /// No description provided for @friendsUiMenuBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get friendsUiMenuBlock;

  /// No description provided for @friendsUiMenuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get friendsUiMenuRemove;

  /// No description provided for @friendsUiChipFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friendsUiChipFriend;

  /// No description provided for @friendsUiChipPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get friendsUiChipPending;

  /// No description provided for @friendsUiAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get friendsUiAccept;

  /// No description provided for @friendsUiReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get friendsUiReject;

  /// No description provided for @friendsUiActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No friend activity yet'**
  String get friendsUiActivityEmpty;

  /// No description provided for @friendsUiActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String friendsUiActivityLevel(String level);

  /// No description provided for @friendsUiLineCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew: {name}'**
  String friendsUiLineCrew(String name);

  /// No description provided for @crewUiAppCrews.
  ///
  /// In en, this message translates to:
  /// **'Crews'**
  String get crewUiAppCrews;

  /// No description provided for @crewUiTabMyCrew.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get crewUiTabMyCrew;

  /// No description provided for @crewUiTabCrewHq.
  ///
  /// In en, this message translates to:
  /// **'HQ & Upgrades'**
  String get crewUiTabCrewHq;

  /// No description provided for @crewUiTabStorageHub.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get crewUiTabStorageHub;

  /// No description provided for @crewUiTabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get crewUiTabMembers;

  /// No description provided for @crewUiTabWarRoom.
  ///
  /// In en, this message translates to:
  /// **'War Room'**
  String get crewUiTabWarRoom;

  /// No description provided for @crewUiTabCrewMissions.
  ///
  /// In en, this message translates to:
  /// **'Crew Missions'**
  String get crewUiTabCrewMissions;

  /// No description provided for @crewUiTabCarStorage.
  ///
  /// In en, this message translates to:
  /// **'Car/Motorcycle Storage'**
  String get crewUiTabCarStorage;

  /// No description provided for @crewUiTabBoatStorage.
  ///
  /// In en, this message translates to:
  /// **'Boat Storage'**
  String get crewUiTabBoatStorage;

  /// No description provided for @crewUiTabWeaponStorage.
  ///
  /// In en, this message translates to:
  /// **'Weapon Storage'**
  String get crewUiTabWeaponStorage;

  /// No description provided for @crewUiTabAmmoStorage.
  ///
  /// In en, this message translates to:
  /// **'Ammo Storage'**
  String get crewUiTabAmmoStorage;

  /// No description provided for @crewUiTabDrugStorage.
  ///
  /// In en, this message translates to:
  /// **'Drug Storage'**
  String get crewUiTabDrugStorage;

  /// No description provided for @crewUiTabCashStorage.
  ///
  /// In en, this message translates to:
  /// **'Cash Storage'**
  String get crewUiTabCashStorage;

  /// No description provided for @crewUiTabAllCrews.
  ///
  /// In en, this message translates to:
  /// **'Crews'**
  String get crewUiTabAllCrews;

  /// No description provided for @crewUiTabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get crewUiTabChat;

  /// No description provided for @crewUiActionCreateCrewShort.
  ///
  /// In en, this message translates to:
  /// **'Create Crew (€50k)'**
  String get crewUiActionCreateCrewShort;

  /// No description provided for @crewUiStateNotInCrewYet.
  ///
  /// In en, this message translates to:
  /// **'You are not in a crew yet'**
  String get crewUiStateNotInCrewYet;

  /// No description provided for @crewUiActionCreateCrew.
  ///
  /// In en, this message translates to:
  /// **'Create Crew (€50,000)'**
  String get crewUiActionCreateCrew;

  /// No description provided for @crewUiLabelCrewBank.
  ///
  /// In en, this message translates to:
  /// **'Crew Bank:'**
  String get crewUiLabelCrewBank;

  /// No description provided for @crewUiLabelDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get crewUiLabelDeposit;

  /// No description provided for @crewUiLabelWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get crewUiLabelWithdraw;

  /// No description provided for @crewUiLabelMyTrustScore.
  ///
  /// In en, this message translates to:
  /// **'My Trust Score:'**
  String get crewUiLabelMyTrustScore;

  /// No description provided for @crewUiActionDeleteCrew.
  ///
  /// In en, this message translates to:
  /// **'Delete crew'**
  String get crewUiActionDeleteCrew;

  /// No description provided for @crewUiLabelCrewStats.
  ///
  /// In en, this message translates to:
  /// **'Crew Stats:'**
  String get crewUiLabelCrewStats;

  /// No description provided for @crewUiActionLeaveCrew.
  ///
  /// In en, this message translates to:
  /// **'Leave Crew'**
  String get crewUiActionLeaveCrew;

  /// No description provided for @crewUiSectionBuildings.
  ///
  /// In en, this message translates to:
  /// **'HQ & Upgrades'**
  String get crewUiSectionBuildings;

  /// No description provided for @crewUiHintBuildingsTabs.
  ///
  /// In en, this message translates to:
  /// **'Open HQ & Upgrades to manage HQ and all crew buildings from one place.'**
  String get crewUiHintBuildingsTabs;

  /// No description provided for @crewUiSectionCrewStorage.
  ///
  /// In en, this message translates to:
  /// **'Crew Storage'**
  String get crewUiSectionCrewStorage;

  /// No description provided for @crewUiStateNoStorageData.
  ///
  /// In en, this message translates to:
  /// **'No storage data loaded'**
  String get crewUiStateNoStorageData;

  /// No description provided for @crewUiActionAddCar.
  ///
  /// In en, this message translates to:
  /// **'Add car/motorcycle'**
  String get crewUiActionAddCar;

  /// No description provided for @crewUiActionAddBoat.
  ///
  /// In en, this message translates to:
  /// **'Add boat'**
  String get crewUiActionAddBoat;

  /// No description provided for @crewUiActionAddWeapon.
  ///
  /// In en, this message translates to:
  /// **'Add weapon'**
  String get crewUiActionAddWeapon;

  /// No description provided for @crewUiActionAddAmmo.
  ///
  /// In en, this message translates to:
  /// **'Add ammo'**
  String get crewUiActionAddAmmo;

  /// No description provided for @crewUiActionAddDrugs.
  ///
  /// In en, this message translates to:
  /// **'Add drugs'**
  String get crewUiActionAddDrugs;

  /// No description provided for @crewUiSectionMembersOverview.
  ///
  /// In en, this message translates to:
  /// **'Members overview'**
  String get crewUiSectionMembersOverview;

  /// No description provided for @crewUiHintMembersTab.
  ///
  /// In en, this message translates to:
  /// **'Open the Members tab above for member list and join requests.'**
  String get crewUiHintMembersTab;

  /// No description provided for @crewUiActionGoToMembers.
  ///
  /// In en, this message translates to:
  /// **'Go to Members'**
  String get crewUiActionGoToMembers;

  /// No description provided for @crewUiLabelCrewHq.
  ///
  /// In en, this message translates to:
  /// **'Crew HQ'**
  String get crewUiLabelCrewHq;

  /// No description provided for @crewUiActionGoToCrewHq.
  ///
  /// In en, this message translates to:
  /// **'Go to Crew HQ'**
  String get crewUiActionGoToCrewHq;

  /// No description provided for @crewUiActionGoToStorage.
  ///
  /// In en, this message translates to:
  /// **'Go to Storage'**
  String get crewUiActionGoToStorage;

  /// No description provided for @crewUiStateJoinCrewFirst.
  ///
  /// In en, this message translates to:
  /// **'Create or join a crew first'**
  String get crewUiStateJoinCrewFirst;

  /// No description provided for @crewUiStateJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'Join Requests'**
  String get crewUiStateJoinRequests;

  /// No description provided for @crewUiStateNoJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get crewUiStateNoJoinRequests;

  /// No description provided for @crewUiStateNoCrewsFound.
  ///
  /// In en, this message translates to:
  /// **'No crews found'**
  String get crewUiStateNoCrewsFound;

  /// No description provided for @crewUiLabelMemberCount.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get crewUiLabelMemberCount;

  /// No description provided for @crewUiBadgeMyCrew.
  ///
  /// In en, this message translates to:
  /// **'My Crew'**
  String get crewUiBadgeMyCrew;

  /// No description provided for @crewUiActionJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get crewUiActionJoin;

  /// No description provided for @crewUiStateNotInCrew.
  ///
  /// In en, this message translates to:
  /// **'You are not in a crew'**
  String get crewUiStateNotInCrew;

  /// No description provided for @crewUiHintChatJoinCrew.
  ///
  /// In en, this message translates to:
  /// **'Create or join a crew to chat!'**
  String get crewUiHintChatJoinCrew;

  /// No description provided for @crewUiStatusNotOwned.
  ///
  /// In en, this message translates to:
  /// **'Not owned'**
  String get crewUiStatusNotOwned;

  /// No description provided for @crewUiLabelLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get crewUiLabelLevel;

  /// No description provided for @crewUiLabelCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get crewUiLabelCapacity;

  /// No description provided for @crewUiLabelMemberCap.
  ///
  /// In en, this message translates to:
  /// **'Member cap'**
  String get crewUiLabelMemberCap;

  /// No description provided for @crewUiLabelParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get crewUiLabelParking;

  /// No description provided for @crewUiActionPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get crewUiActionPurchase;

  /// No description provided for @crewUiActionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get crewUiActionUpgrade;

  /// No description provided for @crewUiActionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get crewUiActionDetails;

  /// No description provided for @crewUiHelpCapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Level overview'**
  String get crewUiHelpCapsTitle;

  /// No description provided for @crewUiHelpLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get crewUiHelpLevel;

  /// No description provided for @crewUiHelpCapacity.
  ///
  /// In en, this message translates to:
  /// **'Cap'**
  String get crewUiHelpCapacity;

  /// No description provided for @crewUiHelpUpgradeCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get crewUiHelpUpgradeCost;

  /// No description provided for @crewUiHelpClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get crewUiHelpClose;

  /// No description provided for @crewUiHelpShowCaps.
  ///
  /// In en, this message translates to:
  /// **'Show caps'**
  String get crewUiHelpShowCaps;

  /// No description provided for @crewUiSectionUpgradeHub.
  ///
  /// In en, this message translates to:
  /// **'HQ & Upgrades'**
  String get crewUiSectionUpgradeHub;

  /// No description provided for @crewUiSectionStorageHub.
  ///
  /// In en, this message translates to:
  /// **'Storage Hub'**
  String get crewUiSectionStorageHub;

  /// No description provided for @crewUiHintStorageTab.
  ///
  /// In en, this message translates to:
  /// **'Use the Storage tab for deposits, balances and quick storage actions.'**
  String get crewUiHintStorageTab;

  /// No description provided for @crewUiHintUpgradeHub.
  ///
  /// In en, this message translates to:
  /// **'Manage HQ and all crew upgrades from one place here.'**
  String get crewUiHintUpgradeHub;

  /// No description provided for @crewUiSectionCrewMissions.
  ///
  /// In en, this message translates to:
  /// **'Crew Missions'**
  String get crewUiSectionCrewMissions;

  /// No description provided for @crewUiStateCrewMissionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No crew missions available yet'**
  String get crewUiStateCrewMissionsEmpty;

  /// No description provided for @crewUiStateCrewMissionNoCrew.
  ///
  /// In en, this message translates to:
  /// **'Join or create a crew to start missions.'**
  String get crewUiStateCrewMissionNoCrew;

  /// No description provided for @crewUiActionStartMission.
  ///
  /// In en, this message translates to:
  /// **'Start mission'**
  String get crewUiActionStartMission;

  /// No description provided for @crewUiActionConfigureAndStartMission.
  ///
  /// In en, this message translates to:
  /// **'Configure & start'**
  String get crewUiActionConfigureAndStartMission;

  /// No description provided for @crewUiActionResolveMission.
  ///
  /// In en, this message translates to:
  /// **'Resolve mission'**
  String get crewUiActionResolveMission;

  /// No description provided for @crewUiActionClaimRewards.
  ///
  /// In en, this message translates to:
  /// **'Claim rewards'**
  String get crewUiActionClaimRewards;

  /// No description provided for @crewUiActionSpeedupCooldown.
  ///
  /// In en, this message translates to:
  /// **'Speed up cooldown'**
  String get crewUiActionSpeedupCooldown;

  /// No description provided for @crewUiActionConfirmSpeedupCooldown.
  ///
  /// In en, this message translates to:
  /// **'Confirm speed up'**
  String get crewUiActionConfirmSpeedupCooldown;

  /// No description provided for @crewUiLabelActiveMission.
  ///
  /// In en, this message translates to:
  /// **'Active mission'**
  String get crewUiLabelActiveMission;

  /// No description provided for @crewUiLabelRecentMissions.
  ///
  /// In en, this message translates to:
  /// **'Recent missions'**
  String get crewUiLabelRecentMissions;

  /// No description provided for @crewUiLabelMissionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get crewUiLabelMissionDuration;

  /// No description provided for @crewUiLabelMissionCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get crewUiLabelMissionCooldown;

  /// No description provided for @crewUiLabelMissionTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get crewUiLabelMissionTier;

  /// No description provided for @crewUiLabelMissionRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get crewUiLabelMissionRewards;

  /// No description provided for @crewUiLabelCrewMissionProgress.
  ///
  /// In en, this message translates to:
  /// **'Crew mission progression'**
  String get crewUiLabelCrewMissionProgress;

  /// No description provided for @crewUiLabelCrewMissionXp.
  ///
  /// In en, this message translates to:
  /// **'Crew mission XP'**
  String get crewUiLabelCrewMissionXp;

  /// No description provided for @crewUiLabelCrewMissionLevelBonus.
  ///
  /// In en, this message translates to:
  /// **'Crew cash bonus'**
  String get crewUiLabelCrewMissionLevelBonus;

  /// No description provided for @crewUiLabelCrewMissionNextLevelBonus.
  ///
  /// In en, this message translates to:
  /// **'Next level bonus'**
  String get crewUiLabelCrewMissionNextLevelBonus;

  /// No description provided for @crewUiLabelMissionStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get crewUiLabelMissionStatus;

  /// No description provided for @crewUiLabelCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Cooldown active'**
  String get crewUiLabelCooldownActive;

  /// No description provided for @crewUiLabelRoleContributions.
  ///
  /// In en, this message translates to:
  /// **'Role contributions'**
  String get crewUiLabelRoleContributions;

  /// No description provided for @crewUiLabelContribution.
  ///
  /// In en, this message translates to:
  /// **'contribution'**
  String get crewUiLabelContribution;

  /// No description provided for @crewUiLabelMultiplier.
  ///
  /// In en, this message translates to:
  /// **'multiplier'**
  String get crewUiLabelMultiplier;

  /// No description provided for @crewUiStatusMissionLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get crewUiStatusMissionLocked;

  /// No description provided for @crewUiStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get crewUiStatusInProgress;

  /// No description provided for @crewUiStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get crewUiStatusCompleted;

  /// No description provided for @crewUiStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get crewUiStatusReady;

  /// No description provided for @crewUiStatusRewardsClaimed.
  ///
  /// In en, this message translates to:
  /// **'Rewards claimed'**
  String get crewUiStatusRewardsClaimed;

  /// No description provided for @crewUiStateMissionActionBusy.
  ///
  /// In en, this message translates to:
  /// **'Action is being processed...'**
  String get crewUiStateMissionActionBusy;

  /// No description provided for @crewUiHintMissionLeaderOnly.
  ///
  /// In en, this message translates to:
  /// **'Only leader/co-leader can start and resolve missions.'**
  String get crewUiHintMissionLeaderOnly;

  /// No description provided for @crewUiDialogRoleAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign roles'**
  String get crewUiDialogRoleAssignTitle;

  /// No description provided for @crewUiDialogRoleAssignSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a mission role per crew member.'**
  String get crewUiDialogRoleAssignSubtitle;

  /// No description provided for @crewUiLabelRoleNone.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get crewUiLabelRoleNone;

  /// No description provided for @crewUiLabelRolePlanner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get crewUiLabelRolePlanner;

  /// No description provided for @crewUiLabelRoleEnforcer.
  ///
  /// In en, this message translates to:
  /// **'Enforcer'**
  String get crewUiLabelRoleEnforcer;

  /// No description provided for @crewUiLabelRoleLogistics.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get crewUiLabelRoleLogistics;

  /// No description provided for @crewUiLabelRoleTech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get crewUiLabelRoleTech;

  /// No description provided for @crewUiHintRoleBonus.
  ///
  /// In en, this message translates to:
  /// **'Each unique role: +3% success chance, -2% duration (max +12% / -8%).'**
  String get crewUiHintRoleBonus;

  /// No description provided for @crewUiStateRoleAssignNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No crew members found.'**
  String get crewUiStateRoleAssignNoMembers;

  /// No description provided for @crewUiStateRoleAssignPickOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least 1 role.'**
  String get crewUiStateRoleAssignPickOne;

  /// No description provided for @crewUiHintMissionLockedTier2.
  ///
  /// In en, this message translates to:
  /// **'Tier 2 requires HQ 5+ and 2+ members.'**
  String get crewUiHintMissionLockedTier2;

  /// No description provided for @crewUiHintMissionLockedTier3.
  ///
  /// In en, this message translates to:
  /// **'Tier 3 requires HQ 9+ and 3+ members.'**
  String get crewUiHintMissionLockedTier3;

  /// No description provided for @crewUiHintMissionLockedDefault.
  ///
  /// In en, this message translates to:
  /// **'Mission is still locked.'**
  String get crewUiHintMissionLockedDefault;

  /// No description provided for @crewUiMessageMissionOverviewLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load crew missions.'**
  String get crewUiMessageMissionOverviewLoadFailed;

  /// No description provided for @crewUiMessageMissionStarted.
  ///
  /// In en, this message translates to:
  /// **'Mission started'**
  String get crewUiMessageMissionStarted;

  /// No description provided for @crewUiMessageMissionResolved.
  ///
  /// In en, this message translates to:
  /// **'Mission resolved'**
  String get crewUiMessageMissionResolved;

  /// No description provided for @crewUiMessageMissionRewardsClaimed.
  ///
  /// In en, this message translates to:
  /// **'Rewards claimed'**
  String get crewUiMessageMissionRewardsClaimed;

  /// No description provided for @crewUiMessageMissionCooldownSpedUp.
  ///
  /// In en, this message translates to:
  /// **'Cooldown sped up'**
  String get crewUiMessageMissionCooldownSpedUp;

  /// No description provided for @crewUiMessageMissionSpeedupQuoteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load speedup price.'**
  String get crewUiMessageMissionSpeedupQuoteFailed;

  /// No description provided for @crewUiDialogSpeedupTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed up cooldown?'**
  String get crewUiDialogSpeedupTitle;

  /// No description provided for @crewUiDialogSpeedupBody.
  ///
  /// In en, this message translates to:
  /// **'Instant finish costs {credits} credits ({minutes} min remaining).'**
  String crewUiDialogSpeedupBody(String credits, String minutes);

  /// No description provided for @crewUiLabelCredits.
  ///
  /// In en, this message translates to:
  /// **'credits'**
  String get crewUiLabelCredits;

  /// No description provided for @crewUiStateLoadingPrice.
  ///
  /// In en, this message translates to:
  /// **'Loading price...'**
  String get crewUiStateLoadingPrice;

  /// No description provided for @crewUiActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get crewUiActionCancel;

  /// No description provided for @crewUiHqUpgradeSideBuildingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade all side buildings to at least level {level} first.\n\nMissing:\n{missing}'**
  String crewUiHqUpgradeSideBuildingsMessage(String level, String missing);

  /// No description provided for @crewUiFormatRemainingUnderOneMinute.
  ///
  /// In en, this message translates to:
  /// **'<1 min'**
  String get crewUiFormatRemainingUnderOneMinute;

  /// No description provided for @crewUiFormatRemainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String crewUiFormatRemainingMinutes(int minutes);

  /// No description provided for @crewUiMissionNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get crewUiMissionNoHistory;

  /// No description provided for @crewUiBuildingHq.
  ///
  /// In en, this message translates to:
  /// **'Crew HQ'**
  String get crewUiBuildingHq;

  /// No description provided for @crewUiBuildingCarStorage.
  ///
  /// In en, this message translates to:
  /// **'Car/Motorcycle Storage'**
  String get crewUiBuildingCarStorage;

  /// No description provided for @crewUiBuildingBoatStorage.
  ///
  /// In en, this message translates to:
  /// **'Boat Storage'**
  String get crewUiBuildingBoatStorage;

  /// No description provided for @crewUiBuildingWeaponStorage.
  ///
  /// In en, this message translates to:
  /// **'Weapon Storage'**
  String get crewUiBuildingWeaponStorage;

  /// No description provided for @crewUiBuildingAmmoStorage.
  ///
  /// In en, this message translates to:
  /// **'Ammo Storage'**
  String get crewUiBuildingAmmoStorage;

  /// No description provided for @crewUiBuildingDrugStorage.
  ///
  /// In en, this message translates to:
  /// **'Drug Storage'**
  String get crewUiBuildingDrugStorage;

  /// No description provided for @crewUiBuildingCashStorage.
  ///
  /// In en, this message translates to:
  /// **'Cash Storage'**
  String get crewUiBuildingCashStorage;

  /// No description provided for @crewUiWarActionKill.
  ///
  /// In en, this message translates to:
  /// **'Kill'**
  String get crewUiWarActionKill;

  /// No description provided for @crewUiWarActionMug.
  ///
  /// In en, this message translates to:
  /// **'Mug'**
  String get crewUiWarActionMug;

  /// No description provided for @crewUiWarActionSabotage.
  ///
  /// In en, this message translates to:
  /// **'Sabotage'**
  String get crewUiWarActionSabotage;

  /// No description provided for @crewUiWarActionIntel.
  ///
  /// In en, this message translates to:
  /// **'Intel'**
  String get crewUiWarActionIntel;

  /// No description provided for @crewUiWarActionRaid.
  ///
  /// In en, this message translates to:
  /// **'Raid'**
  String get crewUiWarActionRaid;

  /// No description provided for @crewUiWarActionShield.
  ///
  /// In en, this message translates to:
  /// **'Shield'**
  String get crewUiWarActionShield;

  /// No description provided for @crewUiWarActionBoost.
  ///
  /// In en, this message translates to:
  /// **'Boost'**
  String get crewUiWarActionBoost;

  /// No description provided for @crewUiWarActionTerritory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get crewUiWarActionTerritory;

  /// No description provided for @crewUiWarTargetCrewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} ({count} members)'**
  String crewUiWarTargetCrewSubtitle(String name, int count);

  /// No description provided for @crewChatErrorLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Error loading messages: {error}'**
  String crewChatErrorLoadingMessages(String error);

  /// No description provided for @crewChatMessageTooLong.
  ///
  /// In en, this message translates to:
  /// **'Message too long (max 500 characters)'**
  String get crewChatMessageTooLong;

  /// No description provided for @crewChatErrorSending.
  ///
  /// In en, this message translates to:
  /// **'Error sending message: {error}'**
  String crewChatErrorSending(String error);

  /// No description provided for @crewChatErrorDelete.
  ///
  /// In en, this message translates to:
  /// **'Could not delete message: {error}'**
  String crewChatErrorDelete(String error);

  /// No description provided for @crewChatDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get crewChatDeleteTitle;

  /// No description provided for @crewChatDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This message will be permanently deleted.'**
  String get crewChatDeleteBody;

  /// No description provided for @crewChatCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get crewChatCancel;

  /// No description provided for @crewChatDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get crewChatDelete;

  /// No description provided for @crewChatNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get crewChatNoMessages;

  /// No description provided for @crewChatEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Send the first message to your crew!'**
  String get crewChatEmptyHint;

  /// No description provided for @aviationUiBuyConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy aircraft?'**
  String get aviationUiBuyConfirmTitle;

  /// No description provided for @aviationUiBuyConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to buy {name} for {price}?'**
  String aviationUiBuyConfirmBody(String name, String price);

  /// No description provided for @aviationUiPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed.'**
  String get aviationUiPurchaseFailed;

  /// No description provided for @aviationUiPurchasedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Aircraft purchased.'**
  String get aviationUiPurchasedSuccess;

  /// No description provided for @aviationUiLicenseActiveBlurb.
  ///
  /// In en, this message translates to:
  /// **'License active. Aircraft purchase now requires full pilot training (Aviation level 5 + all certifications).'**
  String get aviationUiLicenseActiveBlurb;

  /// No description provided for @aviationUiLicenseMissingBlurb.
  ///
  /// In en, this message translates to:
  /// **'You do not have an aviation license yet. Buy a license in this module before purchasing aircraft.'**
  String get aviationUiLicenseMissingBlurb;

  /// No description provided for @aviationUiYourAircraft.
  ///
  /// In en, this message translates to:
  /// **'Your aircraft'**
  String get aviationUiYourAircraft;

  /// No description provided for @aviationUiNoOwnedAircraft.
  ///
  /// In en, this message translates to:
  /// **'You do not own any aircraft yet.'**
  String get aviationUiNoOwnedAircraft;

  /// No description provided for @aviationUiAvailableAircraft.
  ///
  /// In en, this message translates to:
  /// **'Available aircraft'**
  String get aviationUiAvailableAircraft;

  /// No description provided for @aviationUiFuelLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel: {fuel} / {max}'**
  String aviationUiFuelLabel(int fuel, int max);

  /// No description provided for @aviationUiPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price: {price}'**
  String aviationUiPriceLabel(String price);

  /// No description provided for @aviationUiMinRank.
  ///
  /// In en, this message translates to:
  /// **'Min rank: {rank}'**
  String aviationUiMinRank(int rank);

  /// No description provided for @aviationUiSpeedMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Speed x{value}'**
  String aviationUiSpeedMultiplier(String value);

  /// No description provided for @aviationUiCargoCapacity.
  ///
  /// In en, this message translates to:
  /// **'Cargo: {amount}'**
  String aviationUiCargoCapacity(int amount);

  /// No description provided for @aviationUiDefaultAircraftName.
  ///
  /// In en, this message translates to:
  /// **'Aircraft'**
  String get aviationUiDefaultAircraftName;

  /// No description provided for @aviationUiLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load aviation data: {error}'**
  String aviationUiLoadError(String error);

  /// No description provided for @crewUiTr0.
  ///
  /// In en, this message translates to:
  /// **'HQ upgrade requirements'**
  String get crewUiTr0;

  /// No description provided for @crewUiTr1.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your current HQ style to max level to unlock the next style'**
  String get crewUiTr1;

  /// No description provided for @crewUiTr2.
  ///
  /// In en, this message translates to:
  /// **'Final HQ style reached'**
  String get crewUiTr2;

  /// No description provided for @crewUiTr3.
  ///
  /// In en, this message translates to:
  /// **'VIP HQ required for level 11-15'**
  String get crewUiTr3;

  /// No description provided for @crewUiTr4.
  ///
  /// In en, this message translates to:
  /// **'Upgrade all side buildings to the required level for this HQ style first'**
  String get crewUiTr4;

  /// No description provided for @crewUiTr5.
  ///
  /// In en, this message translates to:
  /// **'Building already owned'**
  String get crewUiTr5;

  /// No description provided for @crewUiTr6.
  ///
  /// In en, this message translates to:
  /// **'Insufficient crew bank funds'**
  String get crewUiTr6;

  /// No description provided for @crewUiTr7.
  ///
  /// In en, this message translates to:
  /// **'HQ progression is too low for this upgrade'**
  String get crewUiTr7;

  /// No description provided for @crewUiTr8.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP required for level 11+'**
  String get crewUiTr8;

  /// No description provided for @crewUiTr9.
  ///
  /// In en, this message translates to:
  /// **'Starter deposit reached. Purchase cash storage first to unlock more crew bank space.'**
  String get crewUiTr9;

  /// No description provided for @crewUiTr10.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get crewUiTr10;

  /// No description provided for @crewUiTr11.
  ///
  /// In en, this message translates to:
  /// **'There is already an active crew mission.'**
  String get crewUiTr11;

  /// No description provided for @crewUiTr12.
  ///
  /// In en, this message translates to:
  /// **'A mission cooldown is still active. Wait for it to finish or speed it up with credits.'**
  String get crewUiTr12;

  /// No description provided for @crewUiTr13.
  ///
  /// In en, this message translates to:
  /// **'Mission not found.'**
  String get crewUiTr13;

  /// No description provided for @crewUiTr14.
  ///
  /// In en, this message translates to:
  /// **'This tier is still locked.'**
  String get crewUiTr14;

  /// No description provided for @crewUiTr15.
  ///
  /// In en, this message translates to:
  /// **'Mission run not found.'**
  String get crewUiTr15;

  /// No description provided for @crewUiTr16.
  ///
  /// In en, this message translates to:
  /// **'Mission is already resolved.'**
  String get crewUiTr16;

  /// No description provided for @crewUiTr17.
  ///
  /// In en, this message translates to:
  /// **'Mission is not completed yet.'**
  String get crewUiTr17;

  /// No description provided for @crewUiTr18.
  ///
  /// In en, this message translates to:
  /// **'No active cooldown.'**
  String get crewUiTr18;

  /// No description provided for @crewUiTr19.
  ///
  /// In en, this message translates to:
  /// **'Insufficient credits.'**
  String get crewUiTr19;

  /// No description provided for @crewUiTr20.
  ///
  /// In en, this message translates to:
  /// **'Failed to start mission.'**
  String get crewUiTr20;

  /// No description provided for @crewUiTr21.
  ///
  /// In en, this message translates to:
  /// **'Failed to resolve mission.'**
  String get crewUiTr21;

  /// No description provided for @crewUiTr22.
  ///
  /// In en, this message translates to:
  /// **'Failed to claim rewards.'**
  String get crewUiTr22;

  /// No description provided for @crewUiTr23.
  ///
  /// In en, this message translates to:
  /// **'Failed to speed up cooldown.'**
  String get crewUiTr23;

  /// No description provided for @crewUiTr24.
  ///
  /// In en, this message translates to:
  /// **'You are not in a crew.'**
  String get crewUiTr24;

  /// No description provided for @crewUiTr25.
  ///
  /// In en, this message translates to:
  /// **'Only the crew leader can do this.'**
  String get crewUiTr25;

  /// No description provided for @crewUiTr26.
  ///
  /// In en, this message translates to:
  /// **'Target crew not found.'**
  String get crewUiTr26;

  /// No description provided for @crewUiTr27.
  ///
  /// In en, this message translates to:
  /// **'This crew is already in a war.'**
  String get crewUiTr27;

  /// No description provided for @crewUiTr28.
  ///
  /// In en, this message translates to:
  /// **'At least 3 crew members are required.'**
  String get crewUiTr28;

  /// No description provided for @crewUiTr29.
  ///
  /// In en, this message translates to:
  /// **'War not found.'**
  String get crewUiTr29;

  /// No description provided for @crewUiTr30.
  ///
  /// In en, this message translates to:
  /// **'This war is not active.'**
  String get crewUiTr30;

  /// No description provided for @crewUiTr31.
  ///
  /// In en, this message translates to:
  /// **'You cannot join this war right now.'**
  String get crewUiTr31;

  /// No description provided for @crewUiTr32.
  ///
  /// In en, this message translates to:
  /// **'This action requires a target player.'**
  String get crewUiTr32;

  /// No description provided for @crewUiTr33.
  ///
  /// In en, this message translates to:
  /// **'Anti-farm block: pick another target.'**
  String get crewUiTr33;

  /// No description provided for @crewUiTr34.
  ///
  /// In en, this message translates to:
  /// **'A VIP player is required for this action.'**
  String get crewUiTr34;

  /// No description provided for @crewUiTr35.
  ///
  /// In en, this message translates to:
  /// **'A VIP crew is required for this action.'**
  String get crewUiTr35;

  /// No description provided for @crewUiTr36.
  ///
  /// In en, this message translates to:
  /// **'Action limit reached for now.'**
  String get crewUiTr36;

  /// No description provided for @crewUiTr37.
  ///
  /// In en, this message translates to:
  /// **'Cooldown active: wait {remaining} more minutes.'**
  String crewUiTr37(String remaining);

  /// No description provided for @crewUiTr38.
  ///
  /// In en, this message translates to:
  /// **'Invalid territory selected.'**
  String get crewUiTr38;

  /// No description provided for @crewUiTr39.
  ///
  /// In en, this message translates to:
  /// **'Crew war action failed.'**
  String get crewUiTr39;

  /// No description provided for @crewUiTr40.
  ///
  /// In en, this message translates to:
  /// **'Target player'**
  String get crewUiTr40;

  /// No description provided for @crewUiTr41.
  ///
  /// In en, this message translates to:
  /// **'Kills'**
  String get crewUiTr41;

  /// No description provided for @crewUiTr42.
  ///
  /// In en, this message translates to:
  /// **'Deaths'**
  String get crewUiTr42;

  /// No description provided for @crewUiTr43.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get crewUiTr43;

  /// No description provided for @crewUiTr44.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get crewUiTr44;

  /// No description provided for @crewUiTr45.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get crewUiTr45;

  /// No description provided for @crewUiTr46.
  ///
  /// In en, this message translates to:
  /// **'Co-leader'**
  String get crewUiTr46;

  /// No description provided for @crewUiTr47.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get crewUiTr47;

  /// No description provided for @crewUiTr48.
  ///
  /// In en, this message translates to:
  /// **'Capital'**
  String get crewUiTr48;

  /// No description provided for @crewUiTr49.
  ///
  /// In en, this message translates to:
  /// **'Harbor'**
  String get crewUiTr49;

  /// No description provided for @crewUiTr50.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get crewUiTr50;

  /// No description provided for @crewUiTr51.
  ///
  /// In en, this message translates to:
  /// **'Border'**
  String get crewUiTr51;

  /// No description provided for @crewUiTr52.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get crewUiTr52;

  /// No description provided for @crewUiTr53.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get crewUiTr53;

  /// No description provided for @crewUiTr54.
  ///
  /// In en, this message translates to:
  /// **'Tick'**
  String get crewUiTr54;

  /// No description provided for @crewUiTr55.
  ///
  /// In en, this message translates to:
  /// **'Select territory'**
  String get crewUiTr55;

  /// No description provided for @crewUiTr56.
  ///
  /// In en, this message translates to:
  /// **'Select a target crew first.'**
  String get crewUiTr56;

  /// No description provided for @crewUiTr57.
  ///
  /// In en, this message translates to:
  /// **'Crew war declared.'**
  String get crewUiTr57;

  /// No description provided for @crewUiTr58.
  ///
  /// In en, this message translates to:
  /// **'Failed to declare crew war.'**
  String get crewUiTr58;

  /// No description provided for @crewUiTr59.
  ///
  /// In en, this message translates to:
  /// **'You joined the war.'**
  String get crewUiTr59;

  /// No description provided for @crewUiTr60.
  ///
  /// In en, this message translates to:
  /// **'Failed to join the war.'**
  String get crewUiTr60;

  /// No description provided for @crewUiTr61.
  ///
  /// In en, this message translates to:
  /// **'Crew war action completed.'**
  String get crewUiTr61;

  /// No description provided for @crewUiTr62.
  ///
  /// In en, this message translates to:
  /// **'Kill War'**
  String get crewUiTr62;

  /// No description provided for @crewUiTr63.
  ///
  /// In en, this message translates to:
  /// **'Economy War'**
  String get crewUiTr63;

  /// No description provided for @crewUiTr64.
  ///
  /// In en, this message translates to:
  /// **'Territory War'**
  String get crewUiTr64;

  /// No description provided for @crewUiTr65.
  ///
  /// In en, this message translates to:
  /// **'Total War'**
  String get crewUiTr65;

  /// No description provided for @crewUiTr66.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get crewUiTr66;

  /// No description provided for @crewUiTr67.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get crewUiTr67;

  /// No description provided for @crewUiTr68.
  ///
  /// In en, this message translates to:
  /// **'Lockdown'**
  String get crewUiTr68;

  /// No description provided for @crewUiTr69.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get crewUiTr69;

  /// No description provided for @crewUiTr70.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get crewUiTr70;

  /// No description provided for @crewUiTr71.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get crewUiTr71;

  /// No description provided for @crewUiTr72.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP'**
  String get crewUiTr72;

  /// No description provided for @crewUiTr73.
  ///
  /// In en, this message translates to:
  /// **'€9.99/mo'**
  String get crewUiTr73;

  /// No description provided for @crewUiTr74.
  ///
  /// In en, this message translates to:
  /// **'€4.99/mo'**
  String get crewUiTr74;

  /// No description provided for @crewUiTr75.
  ///
  /// In en, this message translates to:
  /// **'One-time purchases'**
  String get crewUiTr75;

  /// No description provided for @crewUiTr76.
  ///
  /// In en, this message translates to:
  /// **'Only the leader can buy crew VIP'**
  String get crewUiTr76;

  /// No description provided for @crewUiTr77.
  ///
  /// In en, this message translates to:
  /// **'Invalid product'**
  String get crewUiTr77;

  /// No description provided for @crewUiTr78.
  ///
  /// In en, this message translates to:
  /// **'Error opening payment page'**
  String get crewUiTr78;

  /// No description provided for @crewUiTr79.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get crewUiTr79;

  /// No description provided for @crewUiTr80.
  ///
  /// In en, this message translates to:
  /// **'Leave crew'**
  String get crewUiTr80;

  /// No description provided for @crewUiTr81.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the crew?'**
  String get crewUiTr81;

  /// No description provided for @crewUiTr82.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get crewUiTr82;

  /// No description provided for @crewUiTr83.
  ///
  /// In en, this message translates to:
  /// **'Left crew'**
  String get crewUiTr83;

  /// No description provided for @crewUiTr84.
  ///
  /// In en, this message translates to:
  /// **'Deposit to crew bank'**
  String get crewUiTr84;

  /// No description provided for @crewUiTr85.
  ///
  /// In en, this message translates to:
  /// **'Withdraw from crew bank'**
  String get crewUiTr85;

  /// No description provided for @crewUiTr86.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get crewUiTr86;

  /// No description provided for @crewUiTr87.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get crewUiTr87;

  /// No description provided for @crewUiTr88.
  ///
  /// In en, this message translates to:
  /// **'Not enough cash on hand'**
  String get crewUiTr88;

  /// No description provided for @crewUiTr89.
  ///
  /// In en, this message translates to:
  /// **'Purchase cash storage first for the crew bank'**
  String get crewUiTr89;

  /// No description provided for @crewUiTr90.
  ///
  /// In en, this message translates to:
  /// **'Crew cash storage is full'**
  String get crewUiTr90;

  /// No description provided for @crewUiTr91.
  ///
  /// In en, this message translates to:
  /// **'Delete crew'**
  String get crewUiTr91;

  /// No description provided for @crewUiTr92.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this crew? This cannot be undone.'**
  String get crewUiTr92;

  /// No description provided for @crewUiTr93.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get crewUiTr93;

  /// No description provided for @crewUiTr94.
  ///
  /// In en, this message translates to:
  /// **'Next level'**
  String get crewUiTr94;

  /// No description provided for @crewUiTr95.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get crewUiTr95;

  /// No description provided for @crewUiTr96.
  ///
  /// In en, this message translates to:
  /// **'Max level reached'**
  String get crewUiTr96;

  /// No description provided for @crewUiTr97.
  ///
  /// In en, this message translates to:
  /// **'Building not owned'**
  String get crewUiTr97;

  /// No description provided for @crewUiTr98.
  ///
  /// In en, this message translates to:
  /// **'Add car/motorcycle'**
  String get crewUiTr98;

  /// No description provided for @crewUiTr99.
  ///
  /// In en, this message translates to:
  /// **'Add boat'**
  String get crewUiTr99;

  /// No description provided for @crewUiTr100.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get crewUiTr100;

  /// No description provided for @crewUiTr101.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get crewUiTr101;

  /// No description provided for @crewUiTr102.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get crewUiTr102;

  /// No description provided for @crewUiTr103.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get crewUiTr103;

  /// No description provided for @crewUiTr104.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get crewUiTr104;

  /// No description provided for @crewUiTr105.
  ///
  /// In en, this message translates to:
  /// **'Add weapon'**
  String get crewUiTr105;

  /// No description provided for @crewUiTr106.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get crewUiTr106;

  /// No description provided for @crewUiTr107.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get crewUiTr107;

  /// No description provided for @crewUiTr108.
  ///
  /// In en, this message translates to:
  /// **'Add ammo'**
  String get crewUiTr108;

  /// No description provided for @crewUiTr109.
  ///
  /// In en, this message translates to:
  /// **'Ammo type'**
  String get crewUiTr109;

  /// No description provided for @crewUiTr110.
  ///
  /// In en, this message translates to:
  /// **'Add goods'**
  String get crewUiTr110;

  /// No description provided for @crewUiTr111.
  ///
  /// In en, this message translates to:
  /// **'Goods type'**
  String get crewUiTr111;

  /// No description provided for @crewUiTr112.
  ///
  /// In en, this message translates to:
  /// **'Join a crew first to use Crew Wars.'**
  String get crewUiTr112;

  /// No description provided for @crewUiTr113.
  ///
  /// In en, this message translates to:
  /// **'No opponent crew members are available to target.'**
  String get crewUiTr113;

  /// No description provided for @crewUiTr114.
  ///
  /// In en, this message translates to:
  /// **'Select target player'**
  String get crewUiTr114;

  /// No description provided for @crewUiTr115.
  ///
  /// In en, this message translates to:
  /// **'Season overview'**
  String get crewUiTr115;

  /// No description provided for @crewUiTr116.
  ///
  /// In en, this message translates to:
  /// **'Active season'**
  String get crewUiTr116;

  /// No description provided for @crewUiTr117.
  ///
  /// In en, this message translates to:
  /// **'My role'**
  String get crewUiTr117;

  /// No description provided for @crewUiTr118.
  ///
  /// In en, this message translates to:
  /// **'Crew can declare'**
  String get crewUiTr118;

  /// No description provided for @crewUiTr119.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get crewUiTr119;

  /// No description provided for @crewUiTr120.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get crewUiTr120;

  /// No description provided for @crewUiTr121.
  ///
  /// In en, this message translates to:
  /// **'Declare new war'**
  String get crewUiTr121;

  /// No description provided for @crewUiTr122.
  ///
  /// In en, this message translates to:
  /// **'Target crew'**
  String get crewUiTr122;

  /// No description provided for @crewUiTr123.
  ///
  /// In en, this message translates to:
  /// **'War type'**
  String get crewUiTr123;

  /// No description provided for @crewUiTr124.
  ///
  /// In en, this message translates to:
  /// **'Declare war'**
  String get crewUiTr124;

  /// No description provided for @crewUiTr125.
  ///
  /// In en, this message translates to:
  /// **'War territories'**
  String get crewUiTr125;

  /// No description provided for @crewUiTr126.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get crewUiTr126;

  /// No description provided for @crewUiTr127.
  ///
  /// In en, this message translates to:
  /// **'Opponent crew'**
  String get crewUiTr127;

  /// No description provided for @crewUiTr128.
  ///
  /// In en, this message translates to:
  /// **'Active from'**
  String get crewUiTr128;

  /// No description provided for @crewUiTr129.
  ///
  /// In en, this message translates to:
  /// **'Join war'**
  String get crewUiTr129;

  /// No description provided for @crewUiTr130.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get crewUiTr130;

  /// No description provided for @crewUiTr131.
  ///
  /// In en, this message translates to:
  /// **'Territories'**
  String get crewUiTr131;

  /// No description provided for @crewUiTr132.
  ///
  /// In en, this message translates to:
  /// **'Recent actions'**
  String get crewUiTr132;

  /// No description provided for @crewUiTr133.
  ///
  /// In en, this message translates to:
  /// **'No war actions yet.'**
  String get crewUiTr133;

  /// No description provided for @crewUiTr134.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get crewUiTr134;

  /// No description provided for @crewUiTr135.
  ///
  /// In en, this message translates to:
  /// **'Season leaderboard'**
  String get crewUiTr135;

  /// No description provided for @crewUiTr136.
  ///
  /// In en, this message translates to:
  /// **'No season points yet.'**
  String get crewUiTr136;

  /// No description provided for @crewUiTr137.
  ///
  /// In en, this message translates to:
  /// **'Loot'**
  String get crewUiTr137;

  /// No description provided for @crewUiTr138.
  ///
  /// In en, this message translates to:
  /// **'Recent wars'**
  String get crewUiTr138;

  /// No description provided for @crewUiTr139.
  ///
  /// In en, this message translates to:
  /// **'No recent wars yet.'**
  String get crewUiTr139;

  /// No description provided for @crewUiTr140.
  ///
  /// In en, this message translates to:
  /// **'Only the leader can purchase or upgrade'**
  String get crewUiTr140;

  /// No description provided for @crewUiTr141.
  ///
  /// In en, this message translates to:
  /// **'HQ upgrade blocked: side buildings first to L\$requiredSideLevel'**
  String get crewUiTr141;

  /// No description provided for @crewUiTr142.
  ///
  /// In en, this message translates to:
  /// **'Next upgrade not available yet'**
  String get crewUiTr142;

  /// No description provided for @crewUiTr143.
  ///
  /// In en, this message translates to:
  /// **'HQ progression too low'**
  String get crewUiTr143;

  /// No description provided for @crewUiTr144.
  ///
  /// In en, this message translates to:
  /// **'HQ level too low for next upgrade'**
  String get crewUiTr144;

  /// No description provided for @premiumUiLoadError.
  ///
  /// In en, this message translates to:
  /// **'Premium data could not be loaded.'**
  String get premiumUiLoadError;

  /// No description provided for @premiumUiRedirectPaidOneTime.
  ///
  /// In en, this message translates to:
  /// **'Purchase received. Refreshing your credits and premium overview.'**
  String get premiumUiRedirectPaidOneTime;

  /// No description provided for @premiumUiRedirectPaidCrewVip.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP payment received. Refreshing your premium overview.'**
  String get premiumUiRedirectPaidCrewVip;

  /// No description provided for @premiumUiRedirectPaidVip.
  ///
  /// In en, this message translates to:
  /// **'VIP payment received. Refreshing your premium overview.'**
  String get premiumUiRedirectPaidVip;

  /// No description provided for @premiumUiRedirectCancelledOneTime.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled.'**
  String get premiumUiRedirectCancelledOneTime;

  /// No description provided for @premiumUiRedirectCancelledSubscription.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled.'**
  String get premiumUiRedirectCancelledSubscription;

  /// No description provided for @premiumUiRedirectFailedOneTime.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed or expired.'**
  String get premiumUiRedirectFailedOneTime;

  /// No description provided for @premiumUiRedirectFailedSubscription.
  ///
  /// In en, this message translates to:
  /// **'Payment failed or expired.'**
  String get premiumUiRedirectFailedSubscription;

  /// No description provided for @premiumUiCheckoutOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open the payment page.'**
  String get premiumUiCheckoutOpenFailed;

  /// No description provided for @premiumUiRedeemNeedsVehicle.
  ///
  /// In en, this message translates to:
  /// **'This item requires a vehicle selection and will be redeemed from the vehicle screen.'**
  String get premiumUiRedeemNeedsVehicle;

  /// No description provided for @premiumUiRedeemSuccessDefault.
  ///
  /// In en, this message translates to:
  /// **'Credits redeemed.'**
  String get premiumUiRedeemSuccessDefault;

  /// No description provided for @premiumUiRedeemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to redeem credits.'**
  String get premiumUiRedeemFailed;

  /// No description provided for @premiumUiPerMonthShort.
  ///
  /// In en, this message translates to:
  /// **'mo'**
  String get premiumUiPerMonthShort;

  /// No description provided for @premiumUiCreditThemeCashBoost.
  ///
  /// In en, this message translates to:
  /// **'Cash boost'**
  String get premiumUiCreditThemeCashBoost;

  /// No description provided for @premiumUiCreditThemeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get premiumUiCreditThemeSecurity;

  /// No description provided for @premiumUiCreditThemeGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get premiumUiCreditThemeGarage;

  /// No description provided for @premiumUiCreditThemeTuneShop.
  ///
  /// In en, this message translates to:
  /// **'Tune Shop'**
  String get premiumUiCreditThemeTuneShop;

  /// No description provided for @premiumUiCreditThemeCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown: {actionType}'**
  String premiumUiCreditThemeCooldown(String actionType);

  /// No description provided for @premiumUiCreditThemeCooldownReset.
  ///
  /// In en, this message translates to:
  /// **'Cooldown reset'**
  String get premiumUiCreditThemeCooldownReset;

  /// No description provided for @premiumUiCreditThemeEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get premiumUiCreditThemeEvents;

  /// No description provided for @premiumUiCreditThemePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumUiCreditThemePremium;

  /// No description provided for @premiumUiKpiPlayerVip.
  ///
  /// In en, this message translates to:
  /// **'Player VIP'**
  String get premiumUiKpiPlayerVip;

  /// No description provided for @premiumUiKpiCrewVip.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP'**
  String get premiumUiKpiCrewVip;

  /// No description provided for @premiumUiCreditsLabel.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get premiumUiCreditsLabel;

  /// No description provided for @premiumUiStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get premiumUiStatusActive;

  /// No description provided for @premiumUiStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get premiumUiStatusInactive;

  /// No description provided for @premiumUiNoCrew.
  ///
  /// In en, this message translates to:
  /// **'No crew'**
  String get premiumUiNoCrew;

  /// No description provided for @premiumUiSectionVipTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP subscriptions'**
  String get premiumUiSectionVipTitle;

  /// No description provided for @premiumUiSectionVipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Professional VIP tiles with clear pricing, status and benefits.'**
  String get premiumUiSectionVipSubtitle;

  /// No description provided for @premiumUiPlayerVipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exclusive account perks, avatar unlocks and premium QoL.'**
  String get premiumUiPlayerVipSubtitle;

  /// No description provided for @premiumUiActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String premiumUiActiveUntil(String date);

  /// No description provided for @premiumUiBadgeVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get premiumUiBadgeVip;

  /// No description provided for @premiumUiExtendVip.
  ///
  /// In en, this message translates to:
  /// **'Extend VIP'**
  String get premiumUiExtendVip;

  /// No description provided for @premiumUiBuyVip.
  ///
  /// In en, this message translates to:
  /// **'Buy VIP'**
  String get premiumUiBuyVip;

  /// No description provided for @premiumUiPlayerVipBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Player VIP benefits'**
  String get premiumUiPlayerVipBenefitsTitle;

  /// No description provided for @premiumUiPlayerVipBenefitsBody.
  ///
  /// In en, this message translates to:
  /// **'Player VIP benefits:\n- 10% shorter action timeouts/cooldowns (jail time stays unchanged).\n- In Drug Production, you get a VIP lightning button on each production card to buy missing materials in one click (after cost confirmation).\n- On death, you lose on-hand cash but restart with EUR 500,000 cash.\n- Your rank is halved instead of a full reset.\n- Education progress and unlocked achievements are preserved.\n- Bank balance and crypto are preserved.\n- Properties, vehicles, prostitutes, carried inventory and stored items are removed.\n- Drug progress and drug stock are reset.\n- You receive 100 premium credits weekly while VIP is active.'**
  String get premiumUiPlayerVipBenefitsBody;

  /// No description provided for @premiumUiCrewVipSubtitleNoCrew.
  ///
  /// In en, this message translates to:
  /// **'You must be in a crew before you can activate Crew VIP.'**
  String get premiumUiCrewVipSubtitleNoCrew;

  /// No description provided for @premiumUiCrewVipSubtitleInCrew.
  ///
  /// In en, this message translates to:
  /// **'For crew upgrades, side buildings level 11-15 and shared perks.'**
  String get premiumUiCrewVipSubtitleInCrew;

  /// No description provided for @premiumUiBadgeCrewNeeded.
  ///
  /// In en, this message translates to:
  /// **'Crew needed'**
  String get premiumUiBadgeCrewNeeded;

  /// No description provided for @premiumUiBadgeCrewVipLabel.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP'**
  String get premiumUiBadgeCrewVipLabel;

  /// No description provided for @premiumUiCtaCrewRequired.
  ///
  /// In en, this message translates to:
  /// **'Crew required'**
  String get premiumUiCtaCrewRequired;

  /// No description provided for @premiumUiExtendCrewVip.
  ///
  /// In en, this message translates to:
  /// **'Extend Crew VIP'**
  String get premiumUiExtendCrewVip;

  /// No description provided for @premiumUiBuyCrewVip.
  ///
  /// In en, this message translates to:
  /// **'Buy Crew VIP'**
  String get premiumUiBuyCrewVip;

  /// No description provided for @premiumUiCrewVipBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP benefits'**
  String get premiumUiCrewVipBenefitsTitle;

  /// No description provided for @premiumUiCrewVipBenefitsNoCrewBody.
  ///
  /// In en, this message translates to:
  /// **'You must join a crew before buying Crew VIP. Crew VIP unlocks crew-focused perks and higher upgrade progression.'**
  String get premiumUiCrewVipBenefitsNoCrewBody;

  /// No description provided for @premiumUiCrewVipBenefitsInCrewBody.
  ///
  /// In en, this message translates to:
  /// **'Crew VIP grants access to extra crew upgrades and shared premium perks for your crew flow. After purchase, active status and expiry are updated immediately.'**
  String get premiumUiCrewVipBenefitsInCrewBody;

  /// No description provided for @premiumUiSectionBuyCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy credits'**
  String get premiumUiSectionBuyCreditsTitle;

  /// No description provided for @premiumUiSectionBuyCreditsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a bundle via visual tiles. Popular 1000-credit option gets its own spotlight.'**
  String get premiumUiSectionBuyCreditsSubtitle;

  /// No description provided for @premiumUiNoCreditBundles.
  ///
  /// In en, this message translates to:
  /// **'There are no active credit bundles right now.'**
  String get premiumUiNoCreditBundles;

  /// No description provided for @premiumUiCreditBundleFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit bundle'**
  String get premiumUiCreditBundleFallbackTitle;

  /// No description provided for @premiumUiCreditBundleFallbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Instant credits for your premium wallet.'**
  String get premiumUiCreditBundleFallbackDescription;

  /// No description provided for @premiumUiBuyCredits.
  ///
  /// In en, this message translates to:
  /// **'Buy {amount} credits'**
  String premiumUiBuyCredits(int amount);

  /// No description provided for @premiumUiCreditsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} credits'**
  String premiumUiCreditsCount(int count);

  /// No description provided for @premiumUiBadgeUltraDeal.
  ///
  /// In en, this message translates to:
  /// **'Ultra deal'**
  String get premiumUiBadgeUltraDeal;

  /// No description provided for @premiumUiBadgeTopDeal.
  ///
  /// In en, this message translates to:
  /// **'Top deal'**
  String get premiumUiBadgeTopDeal;

  /// No description provided for @premiumUiBadgeCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get premiumUiBadgeCredits;

  /// No description provided for @premiumUiCreditOfferInfo.
  ///
  /// In en, this message translates to:
  /// **'{buyLine} for {price}.\n\n{description}'**
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  );

  /// No description provided for @premiumUiSectionShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit shop'**
  String get premiumUiSectionShopTitle;

  /// No description provided for @premiumUiSectionShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each item uses a themed tile based on the effect you are buying.'**
  String get premiumUiSectionShopSubtitle;

  /// No description provided for @premiumUiShopItemFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium item'**
  String get premiumUiShopItemFallbackTitle;

  /// No description provided for @premiumUiShopItemFallbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Direct premium perk.'**
  String get premiumUiShopItemFallbackDescription;

  /// No description provided for @premiumUiShopNoActiveCooldown.
  ///
  /// In en, this message translates to:
  /// **'No active cooldown'**
  String get premiumUiShopNoActiveCooldown;

  /// No description provided for @premiumUiShopNotEnoughCredits.
  ///
  /// In en, this message translates to:
  /// **'Not enough credits'**
  String get premiumUiShopNotEnoughCredits;

  /// No description provided for @premiumUiShopRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get premiumUiShopRedeem;

  /// No description provided for @premiumUiShopItemInfo.
  ///
  /// In en, this message translates to:
  /// **'{description}\n\nTheme: {theme}\nCost: {cost} credits'**
  String premiumUiShopItemInfo(String description, String theme, int cost);

  /// No description provided for @premiumUiBadgeShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get premiumUiBadgeShop;

  /// No description provided for @premiumUiActiveEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active premium effects'**
  String get premiumUiActiveEffectsTitle;

  /// No description provided for @premiumUiIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Players manage VIP subscriptions, credit bundles and credit shop items here.'**
  String get premiumUiIntroSubtitle;

  /// No description provided for @premiumUiEntitlementChip.
  ///
  /// In en, this message translates to:
  /// **'{key} - {date}'**
  String premiumUiEntitlementChip(String key, String date);

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

  /// No description provided for @propertiesConfirmPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get propertiesConfirmPurchaseTitle;

  /// No description provided for @propertyTypeApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get propertyTypeApartment;

  /// No description provided for @propertyTypeNightclub.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get propertyTypeNightclub;

  /// No description provided for @propertyTypeShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get propertyTypeShop;

  /// No description provided for @propertyStatStorageLabel.
  ///
  /// In en, this message translates to:
  /// **'📦 Storage'**
  String get propertyStatStorageLabel;

  /// No description provided for @propertyStatStorageSlotsRange.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to} slots'**
  String propertyStatStorageSlotsRange(int from, int to);

  /// No description provided for @propertyStatHousingCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'👩 Housing capacity'**
  String get propertyStatHousingCapacityLabel;

  /// No description provided for @propertyStatHousingWorkersRange.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to} workers'**
  String propertyStatHousingWorkersRange(int from, int to);

  /// No description provided for @propertyStatStorageAmountSlots.
  ///
  /// In en, this message translates to:
  /// **'{amount} slots'**
  String propertyStatStorageAmountSlots(int amount);

  /// No description provided for @propertyHousingCapacityWithMax.
  ///
  /// In en, this message translates to:
  /// **'{current} workers (max {max} at level {level})'**
  String propertyHousingCapacityWithMax(int current, int max, int level);

  /// No description provided for @propertyHousingCapacityMaxReached.
  ///
  /// In en, this message translates to:
  /// **'{current} workers • max'**
  String propertyHousingCapacityMaxReached(int current);

  /// No description provided for @propertyVipExtraSlots.
  ///
  /// In en, this message translates to:
  /// **'VIP +{count} extra slots'**
  String propertyVipExtraSlots(int count);

  /// No description provided for @propertyManageNightclub.
  ///
  /// In en, this message translates to:
  /// **'Manage nightclub'**
  String get propertyManageNightclub;

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

  /// No description provided for @casinoHubChooseGameHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a game and place your bet'**
  String get casinoHubChooseGameHint;

  /// No description provided for @casinoPlayButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get casinoPlayButton;

  /// No description provided for @casinoGameBaccaratName.
  ///
  /// In en, this message translates to:
  /// **'Baccarat'**
  String get casinoGameBaccaratName;

  /// No description provided for @casinoGameBaccaratDesc.
  ///
  /// In en, this message translates to:
  /// **'Bet on player, banker, or tie with strategic odds.'**
  String get casinoGameBaccaratDesc;

  /// No description provided for @casinoGameVideoPokerName.
  ///
  /// In en, this message translates to:
  /// **'Video Poker'**
  String get casinoGameVideoPokerName;

  /// No description provided for @casinoGameVideoPokerDesc.
  ///
  /// In en, this message translates to:
  /// **'Draw 5 cards and hit combos up to Royal Flush.'**
  String get casinoGameVideoPokerDesc;

  /// No description provided for @casinoBuyCasinoLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy casino (locked)'**
  String get casinoBuyCasinoLockedTitle;

  /// No description provided for @casinoErrGenericPlay.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get casinoErrGenericPlay;

  /// No description provided for @casinoErrSpinFailed.
  ///
  /// In en, this message translates to:
  /// **'Error while spinning'**
  String get casinoErrSpinFailed;

  /// No description provided for @casinoErrBetFailed.
  ///
  /// In en, this message translates to:
  /// **'Error while betting'**
  String get casinoErrBetFailed;

  /// No description provided for @casinoErrGambleFailed.
  ///
  /// In en, this message translates to:
  /// **'Error while gambling'**
  String get casinoErrGambleFailed;

  /// No description provided for @casinoErrThrowFailed.
  ///
  /// In en, this message translates to:
  /// **'Error while rolling'**
  String get casinoErrThrowFailed;

  /// No description provided for @casinoErrCasinoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Casino not found. Make sure the casino is purchased in this country.'**
  String get casinoErrCasinoNotFound;

  /// No description provided for @casinoErrInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Not enough money'**
  String get casinoErrInsufficientFunds;

  /// No description provided for @casinoErrInsufficientBankrollPayout.
  ///
  /// In en, this message translates to:
  /// **'Casino bankroll too low for this payout'**
  String get casinoErrInsufficientBankrollPayout;

  /// No description provided for @casinoErrNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error: {error}'**
  String casinoErrNetwork(String error);

  /// No description provided for @casinoResultYouWon.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get casinoResultYouWon;

  /// No description provided for @casinoResultYouLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get casinoResultYouLost;

  /// No description provided for @casinoResultYouWonCelebrate.
  ///
  /// In en, this message translates to:
  /// **'🎉 You won!'**
  String get casinoResultYouWonCelebrate;

  /// No description provided for @casinoWonEuroAmount.
  ///
  /// In en, this message translates to:
  /// **'You won €{amount}!'**
  String casinoWonEuroAmount(String amount);

  /// No description provided for @casinoLostEuroAmount.
  ///
  /// In en, this message translates to:
  /// **'You lost €{amount}'**
  String casinoLostEuroAmount(String amount);

  /// No description provided for @casinoYouLostPlain.
  ///
  /// In en, this message translates to:
  /// **'You lost'**
  String get casinoYouLostPlain;

  /// No description provided for @casinoBlackjackWinAmount.
  ///
  /// In en, this message translates to:
  /// **'You won €{amount}!'**
  String casinoBlackjackWinAmount(String amount);

  /// No description provided for @casinoBlackjackCelebrate.
  ///
  /// In en, this message translates to:
  /// **'BLACKJACK! €{amount}'**
  String casinoBlackjackCelebrate(String amount);

  /// No description provided for @casinoAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get casinoAgain;

  /// No description provided for @casinoBankruptTitle.
  ///
  /// In en, this message translates to:
  /// **'Casino bankrupt!'**
  String get casinoBankruptTitle;

  /// No description provided for @casinoBankruptBody.
  ///
  /// In en, this message translates to:
  /// **'The casino went bankrupt!\n\nThe owner did not have enough cash in the bankroll to cover all payouts.\n\nThe casino is now closed and can be purchased again.'**
  String get casinoBankruptBody;

  /// No description provided for @casinoBackToCasino.
  ///
  /// In en, this message translates to:
  /// **'Back to Casino'**
  String get casinoBackToCasino;

  /// No description provided for @casinoRouletteNumberColor.
  ///
  /// In en, this message translates to:
  /// **'Number: {number} ({color})'**
  String casinoRouletteNumberColor(String number, String color);

  /// No description provided for @casinoColorGreen.
  ///
  /// In en, this message translates to:
  /// **'green'**
  String get casinoColorGreen;

  /// No description provided for @casinoColorRed.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get casinoColorRed;

  /// No description provided for @casinoColorBlack.
  ///
  /// In en, this message translates to:
  /// **'black'**
  String get casinoColorBlack;

  /// No description provided for @casinoRoulettePickBet.
  ///
  /// In en, this message translates to:
  /// **'Choose your bet'**
  String get casinoRoulettePickBet;

  /// No description provided for @casinoRouletteBetRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get casinoRouletteBetRed;

  /// No description provided for @casinoRouletteBetBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get casinoRouletteBetBlack;

  /// No description provided for @casinoRouletteBetEven.
  ///
  /// In en, this message translates to:
  /// **'Even'**
  String get casinoRouletteBetEven;

  /// No description provided for @casinoRouletteBetOdd.
  ///
  /// In en, this message translates to:
  /// **'Odd'**
  String get casinoRouletteBetOdd;

  /// No description provided for @casinoRouletteSpinButton.
  ///
  /// In en, this message translates to:
  /// **'SPIN!'**
  String get casinoRouletteSpinButton;

  /// No description provided for @casinoRouletteLastResult.
  ///
  /// In en, this message translates to:
  /// **'Last result: {number}'**
  String casinoRouletteLastResult(String number);

  /// No description provided for @casinoBetLabel.
  ///
  /// In en, this message translates to:
  /// **'Bet'**
  String get casinoBetLabel;

  /// No description provided for @casinoBlackjackPlayButton.
  ///
  /// In en, this message translates to:
  /// **'PLAY!'**
  String get casinoBlackjackPlayButton;

  /// No description provided for @casinoSlotSpinButton.
  ///
  /// In en, this message translates to:
  /// **'SPIN!'**
  String get casinoSlotSpinButton;

  /// No description provided for @casinoDiceRollButton.
  ///
  /// In en, this message translates to:
  /// **'ROLL!'**
  String get casinoDiceRollButton;

  /// No description provided for @casinoBlackjackYourCards.
  ///
  /// In en, this message translates to:
  /// **'Your cards'**
  String get casinoBlackjackYourCards;

  /// No description provided for @casinoBlackjackDealerCards.
  ///
  /// In en, this message translates to:
  /// **'Dealer cards'**
  String get casinoBlackjackDealerCards;

  /// No description provided for @casinoBlackjackDealerTotal.
  ///
  /// In en, this message translates to:
  /// **'Dealer: {total}'**
  String casinoBlackjackDealerTotal(String total);

  /// No description provided for @casinoBlackjackYouTotal.
  ///
  /// In en, this message translates to:
  /// **'You: {total}'**
  String casinoBlackjackYouTotal(String total);

  /// No description provided for @casinoDiceTotalShowing.
  ///
  /// In en, this message translates to:
  /// **'Total: {total}'**
  String casinoDiceTotalShowing(String total);

  /// No description provided for @casinoDicePredictTitle.
  ///
  /// In en, this message translates to:
  /// **'Predict'**
  String get casinoDicePredictTitle;

  /// No description provided for @casinoDiceLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Low (2-6)'**
  String get casinoDiceLowLabel;

  /// No description provided for @casinoDiceHighLabel.
  ///
  /// In en, this message translates to:
  /// **'High (8-12)'**
  String get casinoDiceHighLabel;

  /// No description provided for @casinoDiceOddsHint.
  ///
  /// In en, this message translates to:
  /// **'Low/High pays 2x • Exact total pays 6x'**
  String get casinoDiceOddsHint;

  /// No description provided for @casinoSlotPayoutTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout table'**
  String get casinoSlotPayoutTableTitle;

  /// No description provided for @casinoBaccaratPlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get casinoBaccaratPlayer;

  /// No description provided for @casinoBaccaratBanker.
  ///
  /// In en, this message translates to:
  /// **'Banker'**
  String get casinoBaccaratBanker;

  /// No description provided for @casinoBaccaratTieBet.
  ///
  /// In en, this message translates to:
  /// **'Tie'**
  String get casinoBaccaratTieBet;

  /// No description provided for @casinoWinnerPrefix.
  ///
  /// In en, this message translates to:
  /// **'Winner: {who}'**
  String casinoWinnerPrefix(String who);

  /// No description provided for @casinoPayoutEuro.
  ///
  /// In en, this message translates to:
  /// **'Payout: €{amount}'**
  String casinoPayoutEuro(String amount);

  /// No description provided for @casinoNoPayout.
  ///
  /// In en, this message translates to:
  /// **'No payout'**
  String get casinoNoPayout;

  /// No description provided for @casinoResultEuro.
  ///
  /// In en, this message translates to:
  /// **'Result: €{amount}'**
  String casinoResultEuro(String amount);

  /// No description provided for @casinoDealing.
  ///
  /// In en, this message translates to:
  /// **'Dealing…'**
  String get casinoDealing;

  /// No description provided for @casinoDealCaps.
  ///
  /// In en, this message translates to:
  /// **'DEAL'**
  String get casinoDealCaps;

  /// No description provided for @casinoVideoPokerDrawCards.
  ///
  /// In en, this message translates to:
  /// **'DRAW CARDS'**
  String get casinoVideoPokerDrawCards;

  /// No description provided for @casinoVideoPokerDrawHint.
  ///
  /// In en, this message translates to:
  /// **'Draw your hand'**
  String get casinoVideoPokerDrawHint;

  /// No description provided for @casinoVideoPokerRoyalFlush.
  ///
  /// In en, this message translates to:
  /// **'Royal Flush'**
  String get casinoVideoPokerRoyalFlush;

  /// No description provided for @casinoVideoPokerStraightFlush.
  ///
  /// In en, this message translates to:
  /// **'Straight Flush'**
  String get casinoVideoPokerStraightFlush;

  /// No description provided for @casinoVideoPokerFourKind.
  ///
  /// In en, this message translates to:
  /// **'Four of a Kind'**
  String get casinoVideoPokerFourKind;

  /// No description provided for @casinoVideoPokerFullHouse.
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get casinoVideoPokerFullHouse;

  /// No description provided for @casinoVideoPokerFlush.
  ///
  /// In en, this message translates to:
  /// **'Flush'**
  String get casinoVideoPokerFlush;

  /// No description provided for @casinoVideoPokerStraight.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get casinoVideoPokerStraight;

  /// No description provided for @casinoVideoPokerThreeKind.
  ///
  /// In en, this message translates to:
  /// **'Three of a Kind'**
  String get casinoVideoPokerThreeKind;

  /// No description provided for @casinoVideoPokerTwoPair.
  ///
  /// In en, this message translates to:
  /// **'Two Pair'**
  String get casinoVideoPokerTwoPair;

  /// No description provided for @casinoVideoPokerJacksOrBetter.
  ///
  /// In en, this message translates to:
  /// **'Jacks or Better'**
  String get casinoVideoPokerJacksOrBetter;

  /// No description provided for @casinoVideoPokerNoWinningHand.
  ///
  /// In en, this message translates to:
  /// **'No winning hand'**
  String get casinoVideoPokerNoWinningHand;

  /// No description provided for @casinoVideoPokerPayoutTableLong.
  ///
  /// In en, this message translates to:
  /// **'Payout table: Jacks+ 1x • Two Pair 2x • Trips 3x • Straight 4x • Flush 6x • Full House 9x • Four 25x • Straight Flush 50x • Royal 250x'**
  String get casinoVideoPokerPayoutTableLong;

  /// No description provided for @bankScreenLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bank'**
  String get bankScreenLoadFailed;

  /// No description provided for @bankScreenErrNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error: {details}'**
  String bankScreenErrNetwork(String details);

  /// No description provided for @bankScreenCounterpartyTo.
  ///
  /// In en, this message translates to:
  /// **'To: {username}'**
  String bankScreenCounterpartyTo(String username);

  /// No description provided for @bankScreenCounterpartyFrom.
  ///
  /// In en, this message translates to:
  /// **'From: {username}'**
  String bankScreenCounterpartyFrom(String username);

  /// No description provided for @bankScreenDepositSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deposit successful'**
  String get bankScreenDepositSuccess;

  /// No description provided for @bankScreenDepositFailed.
  ///
  /// In en, this message translates to:
  /// **'Deposit failed'**
  String get bankScreenDepositFailed;

  /// No description provided for @bankScreenWithdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal successful'**
  String get bankScreenWithdrawSuccess;

  /// No description provided for @bankScreenWithdrawFailed.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal failed'**
  String get bankScreenWithdrawFailed;

  /// No description provided for @bankScreenTransferSuccess.
  ///
  /// In en, this message translates to:
  /// **'€{amount} transferred to {recipient}'**
  String bankScreenTransferSuccess(String amount, String recipient);

  /// No description provided for @bankScreenTransferFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get bankScreenTransferFailed;

  /// No description provided for @bankScreenErrRecipientNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found'**
  String get bankScreenErrRecipientNotFound;

  /// No description provided for @bankScreenErrCannotTransferToSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot transfer to yourself'**
  String get bankScreenErrCannotTransferToSelf;

  /// No description provided for @bankScreenErrInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient bank balance'**
  String get bankScreenErrInsufficientBalance;

  /// No description provided for @bankScreenErrInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get bankScreenErrInvalidAmount;

  /// No description provided for @bankScreenTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get bankScreenTryAgain;

  /// No description provided for @bankScreenWorldwideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bank (worldwide accessible)'**
  String get bankScreenWorldwideSubtitle;

  /// No description provided for @bankScreenCashOnHand.
  ///
  /// In en, this message translates to:
  /// **'Cash on hand: €{amount}'**
  String bankScreenCashOnHand(int amount);

  /// No description provided for @bankScreenBalanceLine.
  ///
  /// In en, this message translates to:
  /// **'Bank balance: €{amount}'**
  String bankScreenBalanceLine(int amount);

  /// No description provided for @bankScreenAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get bankScreenAmountLabel;

  /// No description provided for @bankScreenDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get bankScreenDescriptionOptional;

  /// No description provided for @bankScreenDescriptionDepositHint.
  ///
  /// In en, this message translates to:
  /// **'Will be stored with your deposit or withdrawal in transactions.'**
  String get bankScreenDescriptionDepositHint;

  /// No description provided for @bankScreenDepositButton.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get bankScreenDepositButton;

  /// No description provided for @bankScreenWithdrawButton.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get bankScreenWithdrawButton;

  /// No description provided for @bankScreenTransferSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer to player'**
  String get bankScreenTransferSectionTitle;

  /// No description provided for @bankScreenRecipientUsername.
  ///
  /// In en, this message translates to:
  /// **'Recipient username'**
  String get bankScreenRecipientUsername;

  /// No description provided for @bankScreenRecentRecipients.
  ///
  /// In en, this message translates to:
  /// **'Recent recipients'**
  String get bankScreenRecentRecipients;

  /// No description provided for @bankScreenDescriptionTransferHint.
  ///
  /// In en, this message translates to:
  /// **'The recipient will also see this description in transactions.'**
  String get bankScreenDescriptionTransferHint;

  /// No description provided for @bankScreenTransferButton.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get bankScreenTransferButton;

  /// No description provided for @bankScreenTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get bankScreenTransactionsTitle;

  /// No description provided for @bankScreenTransactionsTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String bankScreenTransactionsTotal(int count);

  /// No description provided for @bankScreenSummaryDeposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get bankScreenSummaryDeposits;

  /// No description provided for @bankScreenSummaryWithdrawals.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals'**
  String get bankScreenSummaryWithdrawals;

  /// No description provided for @bankScreenSummarySent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get bankScreenSummarySent;

  /// No description provided for @bankScreenSummaryReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get bankScreenSummaryReceived;

  /// No description provided for @bankScreenNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get bankScreenNoTransactions;

  /// No description provided for @bankScreenTxnDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get bankScreenTxnDeposit;

  /// No description provided for @bankScreenTxnWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get bankScreenTxnWithdraw;

  /// No description provided for @bankScreenTxnTransferSent.
  ///
  /// In en, this message translates to:
  /// **'Transfer sent'**
  String get bankScreenTxnTransferSent;

  /// No description provided for @bankScreenTxnTransferReceived.
  ///
  /// In en, this message translates to:
  /// **'Transfer received'**
  String get bankScreenTxnTransferReceived;

  /// No description provided for @bankScreenPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get bankScreenPrevious;

  /// No description provided for @bankScreenNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get bankScreenNext;

  /// No description provided for @bankScreenPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String bankScreenPageOf(int current, int total);

  /// No description provided for @bankScreenRankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank}'**
  String bankScreenRankLabel(String rank);

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

  /// No description provided for @viewOffer.
  ///
  /// In en, this message translates to:
  /// **'View offer'**
  String get viewOffer;

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

  /// No description provided for @courtLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load court data. Please try again.'**
  String get courtLoadFailed;

  /// No description provided for @courtAppealDialogIntro.
  ///
  /// In en, this message translates to:
  /// **'Do you want to submit an appeal for this conviction?'**
  String get courtAppealDialogIntro;

  /// No description provided for @courtCostLine.
  ///
  /// In en, this message translates to:
  /// **'Cost: {amount}'**
  String courtCostLine(String amount);

  /// No description provided for @courtJudgeNamed.
  ///
  /// In en, this message translates to:
  /// **'Judge: {name}'**
  String courtJudgeNamed(String name);

  /// No description provided for @courtCorruptibilityPercent.
  ///
  /// In en, this message translates to:
  /// **'Corruptibility: {percent}%'**
  String courtCorruptibilityPercent(String percent);

  /// No description provided for @courtAppealSuccessHint.
  ///
  /// In en, this message translates to:
  /// **'On success: roughly 20-40% sentence reduction'**
  String get courtAppealSuccessHint;

  /// No description provided for @courtAppealGrantedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Appeal granted. New sentence: {minutes} minutes.'**
  String courtAppealGrantedMinutes(String minutes);

  /// No description provided for @courtAppealDenied.
  ///
  /// In en, this message translates to:
  /// **'Appeal denied.'**
  String get courtAppealDenied;

  /// No description provided for @courtBribeOfferIntro.
  ///
  /// In en, this message translates to:
  /// **'Offer an amount. The amount is always deducted, even on failure.'**
  String get courtBribeOfferIntro;

  /// No description provided for @courtBribeAmountFormatted.
  ///
  /// In en, this message translates to:
  /// **'Bribe amount: {amount}'**
  String courtBribeAmountFormatted(String amount);

  /// No description provided for @courtBribeSliderLabel.
  ///
  /// In en, this message translates to:
  /// **'€{thousands}k'**
  String courtBribeSliderLabel(String thousands);

  /// No description provided for @courtEstimatedSuccessChance.
  ///
  /// In en, this message translates to:
  /// **'Estimated success chance: ~{percent}%'**
  String courtEstimatedSuccessChance(String percent);

  /// No description provided for @courtBribeSuccessReleased.
  ///
  /// In en, this message translates to:
  /// **'Judge bribed. You are released immediately.'**
  String get courtBribeSuccessReleased;

  /// No description provided for @courtBribeFailedDebited.
  ///
  /// In en, this message translates to:
  /// **'Bribe failed. Amount was still deducted.'**
  String get courtBribeFailedDebited;

  /// No description provided for @courtRecordActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get courtRecordActive;

  /// No description provided for @courtRecordServed.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get courtRecordServed;

  /// No description provided for @courtHistoryAppealGranted.
  ///
  /// In en, this message translates to:
  /// **'Appeal granted: {fromMinutes} → {toMinutes} minutes'**
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes);

  /// No description provided for @courtHistoryAppealDenied.
  ///
  /// In en, this message translates to:
  /// **'Appeal denied: {minutes} minutes remained'**
  String courtHistoryAppealDenied(String minutes);

  /// No description provided for @courtHistoryBribeFailedPaid.
  ///
  /// In en, this message translates to:
  /// **'Bribe failed: {amount} paid'**
  String courtHistoryBribeFailedPaid(String amount);

  /// No description provided for @courtHistoryConvictedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Convicted to {minutes} minutes'**
  String courtHistoryConvictedMinutes(String minutes);

  /// No description provided for @courtPartialLoadWarning.
  ///
  /// In en, this message translates to:
  /// **'Heads up: part of the court data could not be loaded. Pull to refresh to retry.'**
  String get courtPartialLoadWarning;

  /// No description provided for @courtNoActiveSentence.
  ///
  /// In en, this message translates to:
  /// **'No active sentence'**
  String get courtNoActiveSentence;

  /// No description provided for @courtNotJailedHint.
  ///
  /// In en, this message translates to:
  /// **'You are currently not jailed. Your criminal record remains visible below.'**
  String get courtNotJailedHint;

  /// No description provided for @courtActiveSentenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Active sentence'**
  String get courtActiveSentenceTitle;

  /// No description provided for @courtDelictLabel.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get courtDelictLabel;

  /// No description provided for @courtTotalSentenceMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total sentence: {minutes} minutes'**
  String courtTotalSentenceMinutes(String minutes);

  /// No description provided for @courtRemainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {minutes} minutes'**
  String courtRemainingMinutes(String minutes);

  /// No description provided for @courtAppealCostCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current appeal cost: {amount}'**
  String courtAppealCostCurrent(String amount);

  /// No description provided for @courtButtonAppeal.
  ///
  /// In en, this message translates to:
  /// **'Appeal'**
  String get courtButtonAppeal;

  /// No description provided for @courtButtonBribeJudge.
  ///
  /// In en, this message translates to:
  /// **'Bribe judge'**
  String get courtButtonBribeJudge;

  /// No description provided for @courtUnknownCrime.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get courtUnknownCrime;

  /// No description provided for @courtSentenceMinutesOnly.
  ///
  /// In en, this message translates to:
  /// **'Sentence: {minutes} minutes'**
  String courtSentenceMinutesOnly(String minutes);

  /// No description provided for @courtSentenceReducedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Sentence: {original} → {reduced} minutes'**
  String courtSentenceReducedMinutes(String original, String reduced);

  /// No description provided for @courtDateLabeled.
  ///
  /// In en, this message translates to:
  /// **'Date: {datetime}'**
  String courtDateLabeled(String datetime);

  /// No description provided for @courtHistoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Court history'**
  String get courtHistoryHeading;

  /// No description provided for @courtAppealSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Appeal submitted'**
  String get courtAppealSubmitted;

  /// No description provided for @courtCriminalRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Criminal record'**
  String get courtCriminalRecordTitle;

  /// No description provided for @courtTotalConvictions.
  ///
  /// In en, this message translates to:
  /// **'Total convictions: {count}'**
  String courtTotalConvictions(String count);

  /// No description provided for @courtRecordBribeNote.
  ///
  /// In en, this message translates to:
  /// **'Past convictions stay visible. A successful judge bribe clears only that one active case.'**
  String get courtRecordBribeNote;

  /// No description provided for @courtNoConvictionsYet.
  ///
  /// In en, this message translates to:
  /// **'No convictions recorded yet.'**
  String get courtNoConvictionsYet;

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

  /// No description provided for @hospitalCooldownTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment in recovery period'**
  String get hospitalCooldownTitle;

  /// No description provided for @hospitalCooldownNextAvailable.
  ///
  /// In en, this message translates to:
  /// **'Next treatment available in: {duration}'**
  String hospitalCooldownNextAvailable(String duration);

  /// No description provided for @hospitalMedicalStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Status'**
  String get hospitalMedicalStatusTitle;

  /// No description provided for @hospitalIcuRemaining.
  ///
  /// In en, this message translates to:
  /// **'ICU: {duration}'**
  String hospitalIcuRemaining(String duration);

  /// No description provided for @hospitalHpLine.
  ///
  /// In en, this message translates to:
  /// **'HP {hp}/100'**
  String hospitalHpLine(String hp);

  /// No description provided for @hospitalIcuTriageTitle.
  ///
  /// In en, this message translates to:
  /// **'ICU & triage overview'**
  String get hospitalIcuTriageTitle;

  /// No description provided for @hospitalIcuPatientRemaining.
  ///
  /// In en, this message translates to:
  /// **'Patient in ICU. Remaining time: {duration}'**
  String hospitalIcuPatientRemaining(String duration);

  /// No description provided for @hospitalCriticalStatusDetected.
  ///
  /// In en, this message translates to:
  /// **'Critical status detected. Emergency care recommended.'**
  String get hospitalCriticalStatusDetected;

  /// No description provided for @hospitalStableStatus.
  ///
  /// In en, this message translates to:
  /// **'Stable. Regular treatment available.'**
  String get hospitalStableStatus;

  /// No description provided for @hospitalRefreshMedicalRecord.
  ///
  /// In en, this message translates to:
  /// **'Refresh medical record'**
  String get hospitalRefreshMedicalRecord;

  /// No description provided for @hospitalStandardTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Standard treatment'**
  String get hospitalStandardTreatmentTitle;

  /// No description provided for @hospitalStandardTreatmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Affordable • restore up to {amount} HP'**
  String hospitalStandardTreatmentSubtitle(String amount);

  /// No description provided for @hospitalIntensiveTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Intensive treatment'**
  String get hospitalIntensiveTreatmentTitle;

  /// No description provided for @hospitalIntensiveTreatmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Faster recovery • up to {amount} HP'**
  String hospitalIntensiveTreatmentSubtitle(String amount);

  /// No description provided for @hospitalIntensiveTreatmentInfoLine.
  ///
  /// In en, this message translates to:
  /// **'• Intensive treatment: €{cost} for up to {amount} HP recovery.'**
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount);

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

  /// No description provided for @inventoryCrimeWeaponTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected crime weapon'**
  String get inventoryCrimeWeaponTitle;

  /// No description provided for @inventoryCrimeWeaponHint.
  ///
  /// In en, this message translates to:
  /// **'Select a weapon for crimes'**
  String get inventoryCrimeWeaponHint;

  /// No description provided for @inventoryCrimeWeaponHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose your crime weapon here. The crimes screen uses this selection immediately.'**
  String get inventoryCrimeWeaponHelp;

  /// No description provided for @inventoryCrimeWeaponEmpty.
  ///
  /// In en, this message translates to:
  /// **'No usable weapons in inventory. Buy or move a weapon into carried items first.'**
  String get inventoryCrimeWeaponEmpty;

  /// No description provided for @inventoryCarriedEmpty.
  ///
  /// In en, this message translates to:
  /// **'You are not carrying any tools, weapons or ammo.'**
  String get inventoryCarriedEmpty;

  /// No description provided for @inventorySectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get inventorySectionTools;

  /// No description provided for @inventorySectionWeapons.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get inventorySectionWeapons;

  /// No description provided for @inventorySectionAmmo.
  ///
  /// In en, this message translates to:
  /// **'Ammo'**
  String get inventorySectionAmmo;

  /// No description provided for @inventoryWeaponFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get inventoryWeaponFallbackName;

  /// No description provided for @inventoryAmmoFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Ammo'**
  String get inventoryAmmoFallbackName;

  /// No description provided for @inventoryWeaponSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Condition: {condition}% • Quantity: {qty}'**
  String inventoryWeaponSubtitle(String condition, String qty);

  /// No description provided for @inventoryAmmoQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {qty}'**
  String inventoryAmmoQuantity(String qty);

  /// No description provided for @inventoryQuantityValue.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {qty}'**
  String inventoryQuantityValue(int qty);

  /// No description provided for @inventoryWithdrawDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw from storage: {itemName}'**
  String inventoryWithdrawDialogTitle(String itemName);

  /// No description provided for @inventoryMaxShort.
  ///
  /// In en, this message translates to:
  /// **'Max: {max}'**
  String inventoryMaxShort(int max);

  /// No description provided for @inventoryInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get inventoryInvalidQuantity;

  /// No description provided for @inventorySnackWeaponStored.
  ///
  /// In en, this message translates to:
  /// **'Weapon stored'**
  String get inventorySnackWeaponStored;

  /// No description provided for @inventorySnackWeaponWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Weapon withdrawn'**
  String get inventorySnackWeaponWithdrawn;

  /// No description provided for @inventorySnackCashStored.
  ///
  /// In en, this message translates to:
  /// **'Cash deposited'**
  String get inventorySnackCashStored;

  /// No description provided for @inventorySnackCashWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Cash withdrawn'**
  String get inventorySnackCashWithdrawn;

  /// No description provided for @inventorySnackDrugsWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Drugs withdrawn'**
  String get inventorySnackDrugsWithdrawn;

  /// No description provided for @inventoryActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get inventoryActionFailed;

  /// No description provided for @inventoryStorageNoCategory.
  ///
  /// In en, this message translates to:
  /// **'No storage type'**
  String get inventoryStorageNoCategory;

  /// No description provided for @inventoryCountsWeapons.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get inventoryCountsWeapons;

  /// No description provided for @inventoryCountsDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get inventoryCountsDrugs;

  /// No description provided for @inventoryCountsCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get inventoryCountsCash;

  /// No description provided for @inventoryStorageCountsLine.
  ///
  /// In en, this message translates to:
  /// **'{weapons}: {weaponCount} • {drugs}: {drugCount} • {cash}: €{cashAmount}'**
  String inventoryStorageCountsLine(
    String weapons,
    int weaponCount,
    String drugs,
    int drugCount,
    String cash,
    int cashAmount,
  );

  /// No description provided for @inventoryStorageWrongCountry.
  ///
  /// In en, this message translates to:
  /// **'You are in another country. You cannot access this storage here.'**
  String get inventoryStorageWrongCountry;

  /// No description provided for @inventoryWeaponStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Weapon storage'**
  String get inventoryWeaponStorageTitle;

  /// No description provided for @inventoryStoreWeapons.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get inventoryStoreWeapons;

  /// No description provided for @inventoryInStorage.
  ///
  /// In en, this message translates to:
  /// **'In storage'**
  String get inventoryInStorage;

  /// No description provided for @inventoryUnknownWeapon.
  ///
  /// In en, this message translates to:
  /// **'Unknown weapon'**
  String get inventoryUnknownWeapon;

  /// No description provided for @inventoryTakeOne.
  ///
  /// In en, this message translates to:
  /// **'Take 1'**
  String get inventoryTakeOne;

  /// No description provided for @inventoryNoWeaponsInStorage.
  ///
  /// In en, this message translates to:
  /// **'No weapons in this storage.'**
  String get inventoryNoWeaponsInStorage;

  /// No description provided for @inventoryCashStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash storage'**
  String get inventoryCashStorageTitle;

  /// No description provided for @inventoryDepositCash.
  ///
  /// In en, this message translates to:
  /// **'Deposit cash'**
  String get inventoryDepositCash;

  /// No description provided for @inventoryWithdrawCash.
  ///
  /// In en, this message translates to:
  /// **'Withdraw cash'**
  String get inventoryWithdrawCash;

  /// No description provided for @inventoryDrugStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug storage'**
  String get inventoryDrugStorageTitle;

  /// No description provided for @inventoryNoDrugsInStorage.
  ///
  /// In en, this message translates to:
  /// **'No drugs in storage.'**
  String get inventoryNoDrugsInStorage;

  /// No description provided for @inventoryNotForTools.
  ///
  /// In en, this message translates to:
  /// **'This property is not for tool storage. Use a warehouse for tools.'**
  String get inventoryNotForTools;

  /// No description provided for @inventoryCategoryTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get inventoryCategoryTools;

  /// No description provided for @inventoryCategoryDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get inventoryCategoryDrugs;

  /// No description provided for @inventoryCategoryWeapons.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get inventoryCategoryWeapons;

  /// No description provided for @inventoryCategoryCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get inventoryCategoryCash;

  /// No description provided for @inventoryStorageSlotsDetail.
  ///
  /// In en, this message translates to:
  /// **'{used}/{max} slots ({percent}%)'**
  String inventoryStorageSlotsDetail(int used, int max, String percent);

  /// No description provided for @inventoryStorageAccessibleHere.
  ///
  /// In en, this message translates to:
  /// **'Accessible in current country'**
  String get inventoryStorageAccessibleHere;

  /// No description provided for @inventoryStorageNotAccessibleHere.
  ///
  /// In en, this message translates to:
  /// **'Not accessible in this country'**
  String get inventoryStorageNotAccessibleHere;

  /// No description provided for @loadoutEquipFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to equip loadout'**
  String get loadoutEquipFailed;

  /// No description provided for @loadoutDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete loadout'**
  String get loadoutDeleteFailed;

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

  /// No description provided for @backpackPurchaseFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the purchase.'**
  String get backpackPurchaseFailedGeneric;

  /// No description provided for @backpackUpgradeFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the upgrade.'**
  String get backpackUpgradeFailedGeneric;

  /// No description provided for @backpackUnknownEvent.
  ///
  /// In en, this message translates to:
  /// **'Unknown action'**
  String get backpackUnknownEvent;

  /// No description provided for @backpackLoadFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get backpackLoadFailedGeneric;

  /// No description provided for @backpackOwnedBadge.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get backpackOwnedBadge;

  /// No description provided for @availableBackpacks.
  ///
  /// In en, this message translates to:
  /// **'Available backpacks'**
  String get availableBackpacks;

  /// No description provided for @backpackDialogCurrentLine.
  ///
  /// In en, this message translates to:
  /// **'Current: {name} (+{slots} slots)'**
  String backpackDialogCurrentLine(String name, int slots);

  /// No description provided for @backpackDialogNewLine.
  ///
  /// In en, this message translates to:
  /// **'New: {name} (+{slots} slots)'**
  String backpackDialogNewLine(String name, int slots);

  /// No description provided for @backpackDialogUpgradeDelta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade: +{delta} slots'**
  String backpackDialogUpgradeDelta(int delta);

  /// No description provided for @backpackDialogTotalCapacity.
  ///
  /// In en, this message translates to:
  /// **'Total: {totalSlots} slots'**
  String backpackDialogTotalCapacity(int totalSlots);

  /// No description provided for @notLoggedInTokenStorageHint.
  ///
  /// In en, this message translates to:
  /// **'(storage issue — try signing in again)'**
  String get notLoggedInTokenStorageHint;

  /// No description provided for @blackMarketTabBackpacks.
  ///
  /// In en, this message translates to:
  /// **'Backpacks'**
  String get blackMarketTabBackpacks;

  /// No description provided for @bmHubAdjustFiltersHint.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get bmHubAdjustFiltersHint;

  /// No description provided for @bmHubEmptyMyListingsHint.
  ///
  /// In en, this message translates to:
  /// **'Go to Garage or Marina to list vehicles'**
  String get bmHubEmptyMyListingsHint;

  /// No description provided for @bmHubSellerLabel.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get bmHubSellerLabel;

  /// No description provided for @bmHubAskingPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Asking price'**
  String get bmHubAskingPriceLabel;

  /// No description provided for @bmHubMarketValueShort.
  ///
  /// In en, this message translates to:
  /// **'Market value'**
  String get bmHubMarketValueShort;

  /// No description provided for @bmHubBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get bmHubBuyNow;

  /// No description provided for @bmHubListedFor.
  ///
  /// In en, this message translates to:
  /// **'Listed for'**
  String get bmHubListedFor;

  /// No description provided for @bmHubEditPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get bmHubEditPrice;

  /// No description provided for @bmHubDelist.
  ///
  /// In en, this message translates to:
  /// **'Delist'**
  String get bmHubDelist;

  /// No description provided for @bmHubFilterListingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter listings'**
  String get bmHubFilterListingsTitle;

  /// No description provided for @bmHubLabelCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get bmHubLabelCountry;

  /// No description provided for @bmHubAllCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get bmHubAllCountries;

  /// No description provided for @bmHubLabelVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get bmHubLabelVehicleType;

  /// No description provided for @bmHubAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get bmHubAllTypes;

  /// No description provided for @bmHubCars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get bmHubCars;

  /// No description provided for @bmHubBoats.
  ///
  /// In en, this message translates to:
  /// **'Boats'**
  String get bmHubBoats;

  /// No description provided for @bmHubPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get bmHubPriceRange;

  /// No description provided for @bmHubClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get bmHubClearFilters;

  /// No description provided for @bmHubApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get bmHubApply;

  /// No description provided for @bmHubBuyVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy vehicle'**
  String get bmHubBuyVehicleTitle;

  /// No description provided for @bmHubBuyVehicleForConfirm.
  ///
  /// In en, this message translates to:
  /// **'Buy {name} for {price}?'**
  String bmHubBuyVehicleForConfirm(String name, String price);

  /// No description provided for @bmHubVehiclePurchased.
  ///
  /// In en, this message translates to:
  /// **'Vehicle purchased successfully!'**
  String get bmHubVehiclePurchased;

  /// No description provided for @bmHubVehiclePurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to buy vehicle'**
  String get bmHubVehiclePurchaseFailed;

  /// No description provided for @bmHubNewPriceEuro.
  ///
  /// In en, this message translates to:
  /// **'New price (€)'**
  String get bmHubNewPriceEuro;

  /// No description provided for @bmHubEnterNewPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new price'**
  String get bmHubEnterNewPriceHint;

  /// No description provided for @bmHubCurrentPrice.
  ///
  /// In en, this message translates to:
  /// **'Current price'**
  String get bmHubCurrentPrice;

  /// No description provided for @bmHubPriceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Price updated successfully!'**
  String get bmHubPriceUpdated;

  /// No description provided for @bmHubPriceUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update price'**
  String get bmHubPriceUpdateFailed;

  /// No description provided for @bmHubUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get bmHubUpdateButton;

  /// No description provided for @bmHubDelistVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delist vehicle'**
  String get bmHubDelistVehicleTitle;

  /// No description provided for @bmHubRemoveFromMarketConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the market?'**
  String bmHubRemoveFromMarketConfirm(String name);

  /// No description provided for @bmHubVehicleDelisted.
  ///
  /// In en, this message translates to:
  /// **'Vehicle delisted successfully!'**
  String get bmHubVehicleDelisted;

  /// No description provided for @bmHubDelistFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delist vehicle'**
  String get bmHubDelistFailed;

  /// No description provided for @bmHubLocationUnknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get bmHubLocationUnknown;

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

  /// No description provided for @hitlistErrMissingBounty.
  ///
  /// In en, this message translates to:
  /// **'Bounty amount is required'**
  String get hitlistErrMissingBounty;

  /// No description provided for @hitlistErrBountyTooLow.
  ///
  /// In en, this message translates to:
  /// **'Minimum bounty is €50,000'**
  String get hitlistErrBountyTooLow;

  /// No description provided for @hitlistErrCannotHitYourself.
  ///
  /// In en, this message translates to:
  /// **'You cannot place a hit on yourself'**
  String get hitlistErrCannotHitYourself;

  /// No description provided for @hitlistErrHitAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'You already have an active hit on this player'**
  String get hitlistErrHitAlreadyExists;

  /// No description provided for @hitlistErrInsufficientMoney.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough money'**
  String get hitlistErrInsufficientMoney;

  /// No description provided for @hitlistErrMissingCounterBounty.
  ///
  /// In en, this message translates to:
  /// **'Counter-bounty amount is required'**
  String get hitlistErrMissingCounterBounty;

  /// No description provided for @hitlistErrHitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Hit not found'**
  String get hitlistErrHitNotFound;

  /// No description provided for @hitlistErrNotTarget.
  ///
  /// In en, this message translates to:
  /// **'Only the target can place a counter-bid'**
  String get hitlistErrNotTarget;

  /// No description provided for @hitlistErrHitNotActive.
  ///
  /// In en, this message translates to:
  /// **'Hit is not active'**
  String get hitlistErrHitNotActive;

  /// No description provided for @hitlistErrCounterBountyMustBeHigher.
  ///
  /// In en, this message translates to:
  /// **'Counter-bounty must be higher than the original bounty'**
  String get hitlistErrCounterBountyMustBeHigher;

  /// No description provided for @hitlistErrMissingWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapon is required'**
  String get hitlistErrMissingWeapon;

  /// No description provided for @hitlistErrWeaponNotFound.
  ///
  /// In en, this message translates to:
  /// **'Weapon not found'**
  String get hitlistErrWeaponNotFound;

  /// No description provided for @hitlistErrWeaponNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You do not own this weapon or it is broken'**
  String get hitlistErrWeaponNotOwned;

  /// No description provided for @hitlistErrWeaponBroken.
  ///
  /// In en, this message translates to:
  /// **'Your selected weapon is broken. Repair it first.'**
  String get hitlistErrWeaponBroken;

  /// No description provided for @hitlistErrInsufficientAmmo.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough ammunition'**
  String get hitlistErrInsufficientAmmo;

  /// No description provided for @hitlistErrInvalidAmmoHit.
  ///
  /// In en, this message translates to:
  /// **'Invalid ammunition quantity'**
  String get hitlistErrInvalidAmmoHit;

  /// No description provided for @hitlistErrTargetUnderHitProtection.
  ///
  /// In en, this message translates to:
  /// **'Target has active hit protection'**
  String get hitlistErrTargetUnderHitProtection;

  /// No description provided for @hitlistErrInvalidInvestigationTier.
  ///
  /// In en, this message translates to:
  /// **'Invalid investigation type'**
  String get hitlistErrInvalidInvestigationTier;

  /// No description provided for @hitlistErrInvestigationAlreadyPending.
  ///
  /// In en, this message translates to:
  /// **'An investigation is already pending for this hit. Wait for your detective message.'**
  String get hitlistErrInvestigationAlreadyPending;

  /// No description provided for @hitlistErrInvalidCaseId.
  ///
  /// In en, this message translates to:
  /// **'Invalid case file number'**
  String get hitlistErrInvalidCaseId;

  /// No description provided for @hitlistErrMurderCaseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Case file not found'**
  String get hitlistErrMurderCaseNotFound;

  /// No description provided for @hitlistErrMurderCaseExpired.
  ///
  /// In en, this message translates to:
  /// **'Investigation window expired (24 hours)'**
  String get hitlistErrMurderCaseExpired;

  /// No description provided for @hitlistErrMurderCaseAlreadyRequested.
  ///
  /// In en, this message translates to:
  /// **'Investigation for this case has already been started'**
  String get hitlistErrMurderCaseAlreadyRequested;

  /// No description provided for @hitlistErrNotPlacer.
  ///
  /// In en, this message translates to:
  /// **'Only the placer can cancel the hit'**
  String get hitlistErrNotPlacer;

  /// No description provided for @hitlistInvestigationOptions.
  ///
  /// In en, this message translates to:
  /// **'Investigation options'**
  String get hitlistInvestigationOptions;

  /// No description provided for @hitlistInvestigationChooseSpeedPrice.
  ///
  /// In en, this message translates to:
  /// **'Choose speed and price:'**
  String get hitlistInvestigationChooseSpeedPrice;

  /// No description provided for @hitlistInvestigationQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick investigation (€1,000,000 • 1 hour)'**
  String get hitlistInvestigationQuick;

  /// No description provided for @hitlistInvestigationStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard investigation (€500,000 • 6 hours)'**
  String get hitlistInvestigationStandard;

  /// No description provided for @hitlistInvestigationSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow investigation (€250,000 • 24 hours)'**
  String get hitlistInvestigationSlow;

  /// No description provided for @hitlistInvestigationQueued.
  ///
  /// In en, this message translates to:
  /// **'Investigation queued. Cost {cost}. ETA: {etaMinutes} min. Report will arrive via Detective Bureau messages (around {resolveAt}).'**
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  );

  /// No description provided for @hitlistInvestigationFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Investigation failed'**
  String get hitlistInvestigationFailedGeneric;

  /// No description provided for @hitlistInvestigationCouldNotComplete.
  ///
  /// In en, this message translates to:
  /// **'Investigation could not be completed'**
  String get hitlistInvestigationCouldNotComplete;

  /// No description provided for @hitlistHitSuccessWithLoot.
  ///
  /// In en, this message translates to:
  /// **'Hit successful! Bounty and loot received: cash {cash}, carried items {items}.'**
  String hitlistHitSuccessWithLoot(String cash, String items);

  /// No description provided for @hitlistAttemptTimeout.
  ///
  /// In en, this message translates to:
  /// **'Hit attempt timed out. Please try again.'**
  String get hitlistAttemptTimeout;

  /// No description provided for @hitlistNoUsableWeapons.
  ///
  /// In en, this message translates to:
  /// **'You have no usable weapons in your inventory. Buy or repair a weapon first.'**
  String get hitlistNoUsableWeapons;

  /// No description provided for @hitlistWeaponsInventoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading weapons: {error}'**
  String hitlistWeaponsInventoryLoadError(String error);

  /// No description provided for @hitlistPlayersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading players: {error}'**
  String hitlistPlayersLoadError(String error);

  /// No description provided for @hitlistRelativeOneDayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get hitlistRelativeOneDayAgo;

  /// No description provided for @hitlistRelativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String hitlistRelativeDaysAgo(String count);

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

  /// No description provided for @replaceArmor.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceArmor;

  /// No description provided for @bodyguardProductName.
  ///
  /// In en, this message translates to:
  /// **'Bodyguard'**
  String get bodyguardProductName;

  /// No description provided for @securityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading security: {error}'**
  String securityLoadError(String error);

  /// No description provided for @securityStatusLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load security status.'**
  String get securityStatusLoadFailed;

  /// No description provided for @armorConditionLine.
  ///
  /// In en, this message translates to:
  /// **'Condition {percent}% · base {base}'**
  String armorConditionLine(String percent, String base);

  /// No description provided for @dailyWageAmount.
  ///
  /// In en, this message translates to:
  /// **'Daily wage {amount}'**
  String dailyWageAmount(String amount);

  /// No description provided for @dailySystemCostLine.
  ///
  /// In en, this message translates to:
  /// **'Daily system cost: {amount}'**
  String dailySystemCostLine(String amount);

  /// No description provided for @nextPayrollAt.
  ///
  /// In en, this message translates to:
  /// **'Next payroll: {datetime}'**
  String nextPayrollAt(String datetime);

  /// No description provided for @bodyguardsLeaveIfUnpaid.
  ///
  /// In en, this message translates to:
  /// **'If you cannot pay the daily wage, all bodyguards leave.'**
  String get bodyguardsLeaveIfUnpaid;

  /// No description provided for @armorOneAtATimeHint.
  ///
  /// In en, this message translates to:
  /// **'You can only wear 1 armor at a time. A new armor always replaces your current one.'**
  String get armorOneAtATimeHint;

  /// No description provided for @armorDefenseNowAtCondition.
  ///
  /// In en, this message translates to:
  /// **'Now +{defense} at {percent}%'**
  String armorDefenseNowAtCondition(String defense, String percent);

  /// No description provided for @couldNotBuyBodyguard.
  ///
  /// In en, this message translates to:
  /// **'Could not buy bodyguard'**
  String get couldNotBuyBodyguard;

  /// No description provided for @couldNotBuyArmor.
  ///
  /// In en, this message translates to:
  /// **'Could not buy armor'**
  String get couldNotBuyArmor;

  /// No description provided for @armorAlreadyEquippedLong.
  ///
  /// In en, this message translates to:
  /// **'You already wear this armor. You can only wear 1 armor at a time.'**
  String get armorAlreadyEquippedLong;

  /// No description provided for @securityErrorArmorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Armor not found'**
  String get securityErrorArmorNotFound;

  /// No description provided for @securityErrorMinQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be at least 1'**
  String get securityErrorMinQuantity;

  /// No description provided for @hit.
  ///
  /// In en, this message translates to:
  /// **'HIT'**
  String get hit;

  /// No description provided for @counterBidLabel.
  ///
  /// In en, this message translates to:
  /// **'COUNTER-BID'**
  String get counterBidLabel;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} day{plural} ago'**
  String daysAgo(String count, String plural);

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

  /// No description provided for @ammoGeneric.
  ///
  /// In en, this message translates to:
  /// **'Ammo'**
  String get ammoGeneric;

  /// No description provided for @ammoPerCrimeSuffix.
  ///
  /// In en, this message translates to:
  /// **'per crime'**
  String get ammoPerCrimeSuffix;

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
  /// **'Production started: active for 8 hours, claim every 10 minutes'**
  String get factorySessionStarted;

  /// No description provided for @ammoFactoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Ammo Factory'**
  String get ammoFactoryTitle;

  /// No description provided for @ammoFactoryIntro.
  ///
  /// In en, this message translates to:
  /// **'Produces in batches; you claim every 10 minutes (up to 8 hours of backlog per session).'**
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
  /// **'Claim production (interval: 10 minutes, max backlog: 8 hours per session)'**
  String get ammoFactoryActionProduce;

  /// No description provided for @ammoFactoryActionOutput.
  ///
  /// In en, this message translates to:
  /// **'Upgrade output to level 5 for more rounds per claim'**
  String get ammoFactoryActionOutput;

  /// No description provided for @ammoFactoryActionQuality.
  ///
  /// In en, this message translates to:
  /// **'Upgrade quality for stronger market prices'**
  String get ammoFactoryActionQuality;

  /// No description provided for @ammoFactoryBlackMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Ammo for sale'**
  String get ammoFactoryBlackMarketTitle;

  /// No description provided for @ammoFactoryBlackMarketBody.
  ///
  /// In en, this message translates to:
  /// **'The ammo factory does not sell bullets directly from this screen. Use the Black Market for buying and selling ammo.'**
  String get ammoFactoryBlackMarketBody;

  /// No description provided for @ammoFactoryActionBlackMarket.
  ///
  /// In en, this message translates to:
  /// **'Buy and sell ammo through the Black Market, not directly from the factory.'**
  String get ammoFactoryActionBlackMarket;

  /// No description provided for @ammoFactoryErrCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get ammoFactoryErrCountryRequired;

  /// No description provided for @ammoFactoryErrPlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found'**
  String get ammoFactoryErrPlayerNotFound;

  /// No description provided for @ammoFactoryErrWrongCountry.
  ///
  /// In en, this message translates to:
  /// **'You must be in the same country to buy this factory'**
  String get ammoFactoryErrWrongCountry;

  /// No description provided for @ammoFactoryErrCouldNotPurchase.
  ///
  /// In en, this message translates to:
  /// **'Could not purchase factory'**
  String get ammoFactoryErrCouldNotPurchase;

  /// No description provided for @ammoFactoryErrAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'Factory is already owned'**
  String get ammoFactoryErrAlreadyOwned;

  /// No description provided for @ammoFactoryErrInsufficientMoneyBuy.
  ///
  /// In en, this message translates to:
  /// **'Not enough money to buy factory'**
  String get ammoFactoryErrInsufficientMoneyBuy;

  /// No description provided for @ammoFactoryErrCouldNotProduce.
  ///
  /// In en, this message translates to:
  /// **'Could not produce ammo'**
  String get ammoFactoryErrCouldNotProduce;

  /// No description provided for @ammoFactoryErrNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You do not own a factory'**
  String get ammoFactoryErrNotOwned;

  /// No description provided for @ammoFactoryErrOnCooldown.
  ///
  /// In en, this message translates to:
  /// **'Factory is on cooldown'**
  String get ammoFactoryErrOnCooldown;

  /// No description provided for @ammoFactoryErrInactive.
  ///
  /// In en, this message translates to:
  /// **'Factory ownership lost due to inactivity'**
  String get ammoFactoryErrInactive;

  /// No description provided for @ammoFactoryErrCouldNotUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Could not upgrade factory'**
  String get ammoFactoryErrCouldNotUpgrade;

  /// No description provided for @ammoFactoryErrInsufficientMoneyUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Not enough money to upgrade factory'**
  String get ammoFactoryErrInsufficientMoneyUpgrade;

  /// No description provided for @ammoFactoryErrMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Factory is already max level'**
  String get ammoFactoryErrMaxLevel;

  /// No description provided for @ammoFactoryErrInvalidUpgradeType.
  ///
  /// In en, this message translates to:
  /// **'Upgrade type must be output or quality'**
  String get ammoFactoryErrInvalidUpgradeType;

  /// No description provided for @ammoFactoryErrEducationNotMet.
  ///
  /// In en, this message translates to:
  /// **'Education requirements not met'**
  String get ammoFactoryErrEducationNotMet;

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
  /// **'Production window: active (10 min interval)'**
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

  /// No description provided for @shootingIntro.
  ///
  /// In en, this message translates to:
  /// **'Improve your accuracy and increase your crime success rate'**
  String get shootingIntro;

  /// No description provided for @shootingTrainSuccess.
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get shootingTrainSuccess;

  /// No description provided for @shootingMaxSessionsReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum training sessions reached'**
  String get shootingMaxSessionsReached;

  /// No description provided for @shootingTrainingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Progress'**
  String get shootingTrainingProgressTitle;

  /// No description provided for @shootingSessionsCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions completed:'**
  String get shootingSessionsCompletedLabel;

  /// No description provided for @shootingProgressCompleteSuffix.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get shootingProgressCompleteSuffix;

  /// No description provided for @shootingCurrentBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Bonus'**
  String get shootingCurrentBonusTitle;

  /// No description provided for @shootingAccuracyBonusLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy Bonus'**
  String get shootingAccuracyBonusLabel;

  /// No description provided for @shootingMaximumLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get shootingMaximumLabel;

  /// No description provided for @shootingBonusAppliedToCrimes.
  ///
  /// In en, this message translates to:
  /// **'This bonus is applied to all your crime attempts'**
  String get shootingBonusAppliedToCrimes;

  /// No description provided for @shootingReadyToTrain.
  ///
  /// In en, this message translates to:
  /// **'Ready to train'**
  String get shootingReadyToTrain;

  /// No description provided for @shootingTrainingCooldownTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Cooldown'**
  String get shootingTrainingCooldownTitle;

  /// No description provided for @shootingCooldownLabel.
  ///
  /// In en, this message translates to:
  /// **'Next session at: {time}'**
  String shootingCooldownLabel(String time);

  /// No description provided for @shootingCooldownHint.
  ///
  /// In en, this message translates to:
  /// **'You must wait 1 hour between training sessions'**
  String get shootingCooldownHint;

  /// No description provided for @shootingTrainingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Training...'**
  String get shootingTrainingInProgress;

  /// No description provided for @shootingHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get shootingHowItWorksTitle;

  /// No description provided for @shootingHowItWorksBullet1.
  ///
  /// In en, this message translates to:
  /// **'• Train every hour for an accuracy boost'**
  String get shootingHowItWorksBullet1;

  /// No description provided for @shootingHowItWorksBullet2.
  ///
  /// In en, this message translates to:
  /// **'• Each session gives +0.1% bonus'**
  String get shootingHowItWorksBullet2;

  /// No description provided for @shootingHowItWorksBullet3.
  ///
  /// In en, this message translates to:
  /// **'• Maximum of 100 sessions (+10% total)'**
  String get shootingHowItWorksBullet3;

  /// No description provided for @shootingHowItWorksBullet4.
  ///
  /// In en, this message translates to:
  /// **'• Increases your crime success rate'**
  String get shootingHowItWorksBullet4;

  /// No description provided for @shootingHowItWorksBullet5.
  ///
  /// In en, this message translates to:
  /// **'• Permanent bonus, every session counts'**
  String get shootingHowItWorksBullet5;

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

  /// No description provided for @gymIntro.
  ///
  /// In en, this message translates to:
  /// **'Train your strength and increase your crime success rate'**
  String get gymIntro;

  /// No description provided for @gymTrainSuccess.
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get gymTrainSuccess;

  /// No description provided for @gymMaxSessionsReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum sessions reached'**
  String get gymMaxSessionsReached;

  /// No description provided for @gymTrainingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Progress'**
  String get gymTrainingProgressTitle;

  /// No description provided for @gymSessionsCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions completed:'**
  String get gymSessionsCompletedLabel;

  /// No description provided for @gymProgressCompleteSuffix.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get gymProgressCompleteSuffix;

  /// No description provided for @gymCurrentBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Bonus'**
  String get gymCurrentBonusTitle;

  /// No description provided for @gymSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}/100'**
  String gymSessions(String count);

  /// No description provided for @gymStrengthBonusLabel.
  ///
  /// In en, this message translates to:
  /// **'Strength Bonus'**
  String get gymStrengthBonusLabel;

  /// No description provided for @gymMaximumLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get gymMaximumLabel;

  /// No description provided for @gymStrengthBonus.
  ///
  /// In en, this message translates to:
  /// **'Strength bonus: {bonus}%'**
  String gymStrengthBonus(String bonus);

  /// No description provided for @gymBonusAppliedToCrimes.
  ///
  /// In en, this message translates to:
  /// **'This bonus is applied to all your crime attempts'**
  String get gymBonusAppliedToCrimes;

  /// No description provided for @gymReadyToTrain.
  ///
  /// In en, this message translates to:
  /// **'Ready to train'**
  String get gymReadyToTrain;

  /// No description provided for @gymTrainingCooldownTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Cooldown'**
  String get gymTrainingCooldownTitle;

  /// No description provided for @gymCooldown.
  ///
  /// In en, this message translates to:
  /// **'Next session at {time}'**
  String gymCooldown(String time);

  /// No description provided for @gymCooldownHint.
  ///
  /// In en, this message translates to:
  /// **'You must wait 1 hour between training sessions'**
  String get gymCooldownHint;

  /// No description provided for @gymTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get gymTrain;

  /// No description provided for @gymTrainingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Training...'**
  String get gymTrainingInProgress;

  /// No description provided for @gymHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get gymHowItWorksTitle;

  /// No description provided for @gymHowItWorksBullet1.
  ///
  /// In en, this message translates to:
  /// **'• Train every hour for a strength boost'**
  String get gymHowItWorksBullet1;

  /// No description provided for @gymHowItWorksBullet2.
  ///
  /// In en, this message translates to:
  /// **'• Each session gives +0.08% bonus'**
  String get gymHowItWorksBullet2;

  /// No description provided for @gymHowItWorksBullet3.
  ///
  /// In en, this message translates to:
  /// **'• Maximum of 100 sessions (+8% total)'**
  String get gymHowItWorksBullet3;

  /// No description provided for @gymHowItWorksBullet4.
  ///
  /// In en, this message translates to:
  /// **'• Increases your crime success rate'**
  String get gymHowItWorksBullet4;

  /// No description provided for @gymHowItWorksBullet5.
  ///
  /// In en, this message translates to:
  /// **'• Permanent bonus, every session counts'**
  String get gymHowItWorksBullet5;

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

  /// No description provided for @countryPortugal.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryPortugal;

  /// No description provided for @countryIreland.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryIreland;

  /// No description provided for @countryLuxembourg.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get countryLuxembourg;

  /// No description provided for @countryAustria.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get countryAustria;

  /// No description provided for @countryDenmark.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get countryDenmark;

  /// No description provided for @countrySweden.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get countrySweden;

  /// No description provided for @countryNorway.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get countryNorway;

  /// No description provided for @countryFinland.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get countryFinland;

  /// No description provided for @countryPoland.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get countryPoland;

  /// No description provided for @countryCzechia.
  ///
  /// In en, this message translates to:
  /// **'Czechia'**
  String get countryCzechia;

  /// No description provided for @countryGreece.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGreece;

  /// No description provided for @countryTurkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get countryTurkey;

  /// No description provided for @countryUae.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get countryUae;

  /// No description provided for @countryDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get countryDubai;

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

  /// No description provided for @toolThermalDrill.
  ///
  /// In en, this message translates to:
  /// **'Thermal Drill'**
  String get toolThermalDrill;

  /// No description provided for @toolCategoryBoltCutter.
  ///
  /// In en, this message translates to:
  /// **'Bolt cutters'**
  String get toolCategoryBoltCutter;

  /// No description provided for @toolCategoryBurglaryKit.
  ///
  /// In en, this message translates to:
  /// **'Burglary kit'**
  String get toolCategoryBurglaryKit;

  /// No description provided for @toolCategoryCarTools.
  ///
  /// In en, this message translates to:
  /// **'Car theft tools'**
  String get toolCategoryCarTools;

  /// No description provided for @toolCategoryJerryCan.
  ///
  /// In en, this message translates to:
  /// **'Jerry can'**
  String get toolCategoryJerryCan;

  /// No description provided for @toolCategorySprayPaint.
  ///
  /// In en, this message translates to:
  /// **'Spray paint'**
  String get toolCategorySprayPaint;

  /// No description provided for @toolCategoryCrowbar.
  ///
  /// In en, this message translates to:
  /// **'Crowbar'**
  String get toolCategoryCrowbar;

  /// No description provided for @toolCategoryGlassCutter.
  ///
  /// In en, this message translates to:
  /// **'Glass cutter'**
  String get toolCategoryGlassCutter;

  /// No description provided for @toolCategoryLaptop.
  ///
  /// In en, this message translates to:
  /// **'Laptop'**
  String get toolCategoryLaptop;

  /// No description provided for @toolCategoryCounterfeiting.
  ///
  /// In en, this message translates to:
  /// **'Counterfeiting'**
  String get toolCategoryCounterfeiting;

  /// No description provided for @toolCategoryToolbox.
  ///
  /// In en, this message translates to:
  /// **'Toolbox'**
  String get toolCategoryToolbox;

  /// No description provided for @toolCategoryRope.
  ///
  /// In en, this message translates to:
  /// **'Rope'**
  String get toolCategoryRope;

  /// No description provided for @toolCategorySilencer.
  ///
  /// In en, this message translates to:
  /// **'Silencer'**
  String get toolCategorySilencer;

  /// No description provided for @toolCategoryFakeDocs.
  ///
  /// In en, this message translates to:
  /// **'Fake documents'**
  String get toolCategoryFakeDocs;

  /// No description provided for @toolCategoryNightVision.
  ///
  /// In en, this message translates to:
  /// **'Night vision'**
  String get toolCategoryNightVision;

  /// No description provided for @toolCategoryBurnerPhone.
  ///
  /// In en, this message translates to:
  /// **'Burner phone'**
  String get toolCategoryBurnerPhone;

  /// No description provided for @toolCategoryGpsJammer.
  ///
  /// In en, this message translates to:
  /// **'GPS jammer'**
  String get toolCategoryGpsJammer;

  /// No description provided for @toolCategoryThermalDrill.
  ///
  /// In en, this message translates to:
  /// **'Thermal drill'**
  String get toolCategoryThermalDrill;

  /// No description provided for @toolsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Black Market – Tools'**
  String get toolsScreenTitle;

  /// No description provided for @toolsTabBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get toolsTabBuy;

  /// No description provided for @toolsTabMyTools.
  ///
  /// In en, this message translates to:
  /// **'My tools'**
  String get toolsTabMyTools;

  /// No description provided for @toolsNoToolsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tools available'**
  String get toolsNoToolsAvailable;

  /// No description provided for @toolsEmptyInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'You do not have any tools yet'**
  String get toolsEmptyInventoryTitle;

  /// No description provided for @toolsEmptyInventoryHint.
  ///
  /// In en, this message translates to:
  /// **'Buy tools in the shop'**
  String get toolsEmptyInventoryHint;

  /// No description provided for @toolsNotEnoughMoney.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough money!'**
  String get toolsNotEnoughMoney;

  /// No description provided for @toolsNotEnoughMoneyRepair.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough money for repair!'**
  String get toolsNotEnoughMoneyRepair;

  /// No description provided for @toolsBuyError.
  ///
  /// In en, this message translates to:
  /// **'Error while buying'**
  String get toolsBuyError;

  /// No description provided for @toolsRepairError.
  ///
  /// In en, this message translates to:
  /// **'Error while repairing'**
  String get toolsRepairError;

  /// No description provided for @toolsPurchased.
  ///
  /// In en, this message translates to:
  /// **'{toolName} purchased!'**
  String toolsPurchased(String toolName);

  /// No description provided for @toolsRepaired.
  ///
  /// In en, this message translates to:
  /// **'{toolName} repaired for €{cost}'**
  String toolsRepaired(String toolName, String cost);

  /// No description provided for @toolsBadgeInventoryFull.
  ///
  /// In en, this message translates to:
  /// **'FULL'**
  String get toolsBadgeInventoryFull;

  /// No description provided for @toolsBadgeBroken.
  ///
  /// In en, this message translates to:
  /// **'BROKEN'**
  String get toolsBadgeBroken;

  /// No description provided for @toolsBadgeRepair.
  ///
  /// In en, this message translates to:
  /// **'REPAIR'**
  String get toolsBadgeRepair;

  /// No description provided for @toolsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tools: {error}'**
  String toolsLoadError(String error);

  /// No description provided for @toolsErrToolNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tool not found.'**
  String get toolsErrToolNotFound;

  /// No description provided for @toolsErrInventoryFullBuy.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is full. Store some tools or upgrade capacity.'**
  String get toolsErrInventoryFullBuy;

  /// No description provided for @toolsErrPurchaseServer.
  ///
  /// In en, this message translates to:
  /// **'Tool purchase failed due to a server issue.'**
  String get toolsErrPurchaseServer;

  /// No description provided for @toolsErrToolNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You don\'t own this tool.'**
  String get toolsErrToolNotOwned;

  /// No description provided for @toolsErrAlreadyMaxDurability.
  ///
  /// In en, this message translates to:
  /// **'Tool is already at maximum durability.'**
  String get toolsErrAlreadyMaxDurability;

  /// No description provided for @toolsErrRepairServer.
  ///
  /// In en, this message translates to:
  /// **'Tool repair failed due to a server issue.'**
  String get toolsErrRepairServer;

  /// No description provided for @toolsNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: {error}'**
  String toolsNetworkError(String error);

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

  /// No description provided for @crimeResultMoneyLabel.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get crimeResultMoneyLabel;

  /// No description provided for @crimeResultXpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get crimeResultXpLabel;

  /// No description provided for @crimeOutcomeRowReward.
  ///
  /// In en, this message translates to:
  /// **'Reward:'**
  String get crimeOutcomeRowReward;

  /// No description provided for @crimeOutcomeRowXp.
  ///
  /// In en, this message translates to:
  /// **'XP:'**
  String get crimeOutcomeRowXp;

  /// No description provided for @crimeOutcomeRowTools.
  ///
  /// In en, this message translates to:
  /// **'Tools:'**
  String get crimeOutcomeRowTools;

  /// No description provided for @crimeOutcomeToolDurabilityValue.
  ///
  /// In en, this message translates to:
  /// **'-{percent}% durability'**
  String crimeOutcomeToolDurabilityValue(int percent);

  /// No description provided for @icuIntensiveCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Intensive care'**
  String get icuIntensiveCareTitle;

  /// No description provided for @icuInjuredLine.
  ///
  /// In en, this message translates to:
  /// **'You were seriously injured during your criminal activities.'**
  String get icuInjuredLine;

  /// No description provided for @icuUnconsciousLine.
  ///
  /// In en, this message translates to:
  /// **'You are now in intensive care and unconscious.'**
  String get icuUnconsciousLine;

  /// No description provided for @icuRecoveryTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovery time:'**
  String get icuRecoveryTimeLabel;

  /// No description provided for @icuWakeHp.
  ///
  /// In en, this message translates to:
  /// **'You wake up with 10 HP'**
  String get icuWakeHp;

  /// No description provided for @icuNoActionsHint.
  ///
  /// In en, this message translates to:
  /// **'You cannot perform actions during this time.\nBe more careful with your health!'**
  String get icuNoActionsHint;

  /// No description provided for @jailBailPaidSnackbar.
  ///
  /// In en, this message translates to:
  /// **'🎉 You\'re free! Bail paid: €{amount}'**
  String jailBailPaidSnackbar(int amount);

  /// No description provided for @jailInsufficientBail.
  ///
  /// In en, this message translates to:
  /// **'Not enough money for bail (€{amount})'**
  String jailInsufficientBail(int amount);

  /// No description provided for @jailCooldownWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait: {seconds}s'**
  String jailCooldownWait(int seconds);

  /// No description provided for @jailEscapeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Escape succeeded! You are free.'**
  String get jailEscapeSuccess;

  /// No description provided for @jailEscapeFailed.
  ///
  /// In en, this message translates to:
  /// **'Escape failed. Sentence extended by {penalty}.'**
  String jailEscapeFailed(String penalty);

  /// No description provided for @jailEscapeGenericFailure.
  ///
  /// In en, this message translates to:
  /// **'Escape failed'**
  String get jailEscapeGenericFailure;

  /// No description provided for @jailErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String jailErrorPrefix(String message);

  /// No description provided for @jailTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get jailTimeLeft;

  /// No description provided for @jailPayBail.
  ///
  /// In en, this message translates to:
  /// **'Pay bail (€{amount})'**
  String jailPayBail(int amount);

  /// No description provided for @jailCannotActWhileIn.
  ///
  /// In en, this message translates to:
  /// **'You cannot commit crimes, work, or travel while serving your sentence.'**
  String get jailCannotActWhileIn;

  /// No description provided for @jailAttemptEscape.
  ///
  /// In en, this message translates to:
  /// **'Attempt escape'**
  String get jailAttemptEscape;

  /// No description provided for @jailYouAreInJail.
  ///
  /// In en, this message translates to:
  /// **'You are in jail'**
  String get jailYouAreInJail;

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

  /// No description provided for @prostitutionDistrictOwnedBadge.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get prostitutionDistrictOwnedBadge;

  /// No description provided for @prostitutionOwnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner:'**
  String get prostitutionOwnerLabel;

  /// No description provided for @prostitutionForSale.
  ///
  /// In en, this message translates to:
  /// **'For sale'**
  String get prostitutionForSale;

  /// No description provided for @prostitutionRoomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms:'**
  String get prostitutionRoomsLabel;

  /// No description provided for @prostitutionRoomsRented.
  ///
  /// In en, this message translates to:
  /// **'rented'**
  String get prostitutionRoomsRented;

  /// No description provided for @prostitutionRldAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Red Light District ({country})'**
  String prostitutionRldAppBarTitle(String country);

  /// No description provided for @prostitutionOccupiedShort.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get prostitutionOccupiedShort;

  /// No description provided for @prostitutionNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get prostitutionNotApplicable;

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

  /// No description provided for @achievementsSectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get achievementsSectionProgress;

  /// No description provided for @achievementsPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String achievementsPercentComplete(int percent);

  /// No description provided for @achievementsCategoryNameProstitution.
  ///
  /// In en, this message translates to:
  /// **'Prostitution'**
  String get achievementsCategoryNameProstitution;

  /// No description provided for @achievementsCategoryNameRld.
  ///
  /// In en, this message translates to:
  /// **'RLD'**
  String get achievementsCategoryNameRld;

  /// No description provided for @achievementsCategoryNameCrimes.
  ///
  /// In en, this message translates to:
  /// **'Crimes'**
  String get achievementsCategoryNameCrimes;

  /// No description provided for @achievementsCategoryNameJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get achievementsCategoryNameJobs;

  /// No description provided for @achievementsCategoryNameSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get achievementsCategoryNameSchool;

  /// No description provided for @achievementsCategoryNameVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get achievementsCategoryNameVehicles;

  /// No description provided for @achievementsCategoryNameTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get achievementsCategoryNameTravel;

  /// No description provided for @achievementsCategoryNameDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get achievementsCategoryNameDrugs;

  /// No description provided for @achievementsCategoryNameTrade.
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get achievementsCategoryNameTrade;

  /// No description provided for @achievementsCategoryNameGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get achievementsCategoryNameGeneral;

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

  /// No description provided for @schoolGateAssetDrugFacilitySlotsTier1.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility slot upgrade I'**
  String get schoolGateAssetDrugFacilitySlotsTier1;

  /// No description provided for @schoolGateAssetDrugFacilitySlotsTier2.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility slot upgrade II'**
  String get schoolGateAssetDrugFacilitySlotsTier2;

  /// No description provided for @schoolGateAssetDrugFacilitySlotsTier3.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility slot upgrade III'**
  String get schoolGateAssetDrugFacilitySlotsTier3;

  /// No description provided for @schoolGateAssetDrugFacilitySlotsTier4.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility slot upgrade IV'**
  String get schoolGateAssetDrugFacilitySlotsTier4;

  /// No description provided for @schoolGateAssetDrugFacilityEquipmentTier1.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility equipment upgrade I'**
  String get schoolGateAssetDrugFacilityEquipmentTier1;

  /// No description provided for @schoolGateAssetDrugFacilityEquipmentTier2.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility equipment upgrade II'**
  String get schoolGateAssetDrugFacilityEquipmentTier2;

  /// No description provided for @schoolGateAssetDrugFacilityEquipmentTier3.
  ///
  /// In en, this message translates to:
  /// **'Asset: Drug facility equipment upgrade III'**
  String get schoolGateAssetDrugFacilityEquipmentTier3;

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

  /// No description provided for @educationTrackNameNarcotics.
  ///
  /// In en, this message translates to:
  /// **'Narcotics Engineering'**
  String get educationTrackNameNarcotics;

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

  /// No description provided for @schoolTrackDescriptionNarcotics.
  ///
  /// In en, this message translates to:
  /// **'Controlled cultivation, process electrics and advanced chemical production.'**
  String get schoolTrackDescriptionNarcotics;

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

  /// No description provided for @educationCertHydroponicSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Hydroponics Specialist Certification'**
  String get educationCertHydroponicSpecialist;

  /// No description provided for @educationCertProcessElectricsSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Process Electrics Specialist Certification'**
  String get educationCertProcessElectricsSpecialist;

  /// No description provided for @educationCertClandestineChemist.
  ///
  /// In en, this message translates to:
  /// **'Clandestine Chemist Certification'**
  String get educationCertClandestineChemist;

  /// No description provided for @educationCertNarcoGridArchitect.
  ///
  /// In en, this message translates to:
  /// **'Narco Grid Architect Certification'**
  String get educationCertNarcoGridArchitect;

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

  /// No description provided for @prostitutionBetrayalDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Betrayal! Your nightclub was hit by an intel leak.'**
  String get prostitutionBetrayalDefaultMessage;

  /// No description provided for @prostitutionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get prostitutionLoadError;

  /// No description provided for @prostitutionNoDistrictInCountry.
  ///
  /// In en, this message translates to:
  /// **'No Red Light District found in this country'**
  String get prostitutionNoDistrictInCountry;

  /// No description provided for @prostitutionMovedToStreet.
  ///
  /// In en, this message translates to:
  /// **'Moved to street'**
  String get prostitutionMovedToStreet;

  /// No description provided for @prostitutionArrestedCannotAssign.
  ///
  /// In en, this message translates to:
  /// **'This prostitute is arrested and cannot be assigned.'**
  String get prostitutionArrestedCannotAssign;

  /// No description provided for @prostitutionNoNightclubVenue.
  ///
  /// In en, this message translates to:
  /// **'You do not have a nightclub venue yet to assign staff.'**
  String get prostitutionNoNightclubVenue;

  /// No description provided for @prostitutionNightclubVenueName.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get prostitutionNightclubVenueName;

  /// No description provided for @prostitutionNightclubVenueNumbered.
  ///
  /// In en, this message translates to:
  /// **'Nightclub #{id}'**
  String prostitutionNightclubVenueNumbered(int id);

  /// No description provided for @prostitutionAssignedNightclub.
  ///
  /// In en, this message translates to:
  /// **'Assigned to nightclub'**
  String get prostitutionAssignedNightclub;

  /// No description provided for @prostitutionArrestedCannotWork.
  ///
  /// In en, this message translates to:
  /// **'This prostitute is arrested and cannot work.'**
  String get prostitutionArrestedCannotWork;

  /// No description provided for @prostitutionShiftRestNeeded.
  ///
  /// In en, this message translates to:
  /// **'Needs {duration} rest before the next shift.'**
  String prostitutionShiftRestNeeded(String duration);

  /// No description provided for @prostitutionWorkShiftCompleted.
  ///
  /// In en, this message translates to:
  /// **'Work shift completed'**
  String get prostitutionWorkShiftCompleted;

  /// No description provided for @prostitutionNoWorkersToAssign.
  ///
  /// In en, this message translates to:
  /// **'No available prostitutes to send to work.'**
  String get prostitutionNoWorkersToAssign;

  /// No description provided for @prostitutionWorkAllSentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} prostitutes sent to work.'**
  String prostitutionWorkAllSentCount(int count);

  /// No description provided for @prostitutionWorkAllPartial.
  ///
  /// In en, this message translates to:
  /// **'{success} prostitutes sent to work, {failed} failed.'**
  String prostitutionWorkAllPartial(int success, int failed);

  /// No description provided for @prostitutionRecruitedDefault.
  ///
  /// In en, this message translates to:
  /// **'Recruited!'**
  String get prostitutionRecruitedDefault;

  /// No description provided for @prostitutionRecruitFailed.
  ///
  /// In en, this message translates to:
  /// **'Recruitment failed'**
  String get prostitutionRecruitFailed;

  /// No description provided for @prostitutionRecruitConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Recruitment failed due to a connection error'**
  String get prostitutionRecruitConnectionError;

  /// No description provided for @prostitutionEventUpdate.
  ///
  /// In en, this message translates to:
  /// **'Event updated'**
  String get prostitutionEventUpdate;

  /// No description provided for @prostitutionBuyPropertyFirst.
  ///
  /// In en, this message translates to:
  /// **'Buy a house or apartment first'**
  String get prostitutionBuyPropertyFirst;

  /// No description provided for @prostitutionWorkAll.
  ///
  /// In en, this message translates to:
  /// **'Work all ({count})'**
  String prostitutionWorkAll(int count);

  /// No description provided for @prostitutionNoHousingForRecruit.
  ///
  /// In en, this message translates to:
  /// **'No free housing slot. Buy or upgrade a house or apartment before recruiting more prostitutes.'**
  String get prostitutionNoHousingForRecruit;

  /// No description provided for @prostitutionHousingTitle.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get prostitutionHousingTitle;

  /// No description provided for @prostitutionHousingRentRule.
  ///
  /// In en, this message translates to:
  /// **'Each prostitute must work at least one shift every {days} days to cover rent.'**
  String prostitutionHousingRentRule(int days);

  /// No description provided for @prostitutionHousingSlots.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get prostitutionHousingSlots;

  /// No description provided for @prostitutionHousingFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get prostitutionHousingFree;

  /// No description provided for @prostitutionHousingHomes.
  ///
  /// In en, this message translates to:
  /// **'Homes'**
  String get prostitutionHousingHomes;

  /// No description provided for @prostitutionHousingAvgUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Avg upgrade'**
  String get prostitutionHousingAvgUpgrade;

  /// No description provided for @prostitutionHousingHappinessBonus.
  ///
  /// In en, this message translates to:
  /// **'Happiness bonus'**
  String get prostitutionHousingHappinessBonus;

  /// No description provided for @prostitutionHousingWeeklyRent.
  ///
  /// In en, this message translates to:
  /// **'Weekly rent'**
  String get prostitutionHousingWeeklyRent;

  /// No description provided for @prostitutionHousingAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get prostitutionHousingAtRisk;

  /// No description provided for @prostitutionHousingSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get prostitutionHousingSafe;

  /// No description provided for @prostitutionBetrayalActiveDetail.
  ///
  /// In en, this message translates to:
  /// **'Betrayal triggered: {grams}g drugs seized, {licenses} nightclub license(s) revoked.'**
  String prostitutionBetrayalActiveDetail(int grams, int licenses);

  /// No description provided for @prostitutionEarningsInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings insight (active prostitutes)'**
  String get prostitutionEarningsInsightTitle;

  /// No description provided for @prostitutionEarningsStreetDetail.
  ///
  /// In en, this message translates to:
  /// **'Street: {count} • €{euros}/hour'**
  String prostitutionEarningsStreetDetail(int count, int euros);

  /// No description provided for @prostitutionEarningsRldDetail.
  ///
  /// In en, this message translates to:
  /// **'RLD: {count} • €{euros}/hour'**
  String prostitutionEarningsRldDetail(int count, int euros);

  /// No description provided for @prostitutionEarningsNightclubDetail.
  ///
  /// In en, this message translates to:
  /// **'Nightclub: {count} • €{euros}/hour'**
  String prostitutionEarningsNightclubDetail(int count, int euros);

  /// No description provided for @prostitutionEarningsTotalDetail.
  ///
  /// In en, this message translates to:
  /// **'Total: €{euros}/hour'**
  String prostitutionEarningsTotalDetail(int euros);

  /// No description provided for @prostitutionHappinessEcstatic.
  ///
  /// In en, this message translates to:
  /// **'Ecstatic'**
  String get prostitutionHappinessEcstatic;

  /// No description provided for @prostitutionHappinessHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get prostitutionHappinessHappy;

  /// No description provided for @prostitutionHappinessStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get prostitutionHappinessStable;

  /// No description provided for @prostitutionHappinessStressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get prostitutionHappinessStressed;

  /// No description provided for @prostitutionHappinessMiserable.
  ///
  /// In en, this message translates to:
  /// **'Miserable'**
  String get prostitutionHappinessMiserable;

  /// No description provided for @prostitutionHousingExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get prostitutionHousingExpired;

  /// No description provided for @prostitutionHousingDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days}d left'**
  String prostitutionHousingDaysLeft(int days);

  /// No description provided for @prostitutionHousingLessThanOneDay.
  ///
  /// In en, this message translates to:
  /// **'Less than 1 day'**
  String get prostitutionHousingLessThanOneDay;

  /// No description provided for @prostitutionNightclubShort.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get prostitutionNightclubShort;

  /// No description provided for @prostitutionMoveToStreetButton.
  ///
  /// In en, this message translates to:
  /// **'To street'**
  String get prostitutionMoveToStreetButton;

  /// No description provided for @prostitutionMoveToNightclubButton.
  ///
  /// In en, this message translates to:
  /// **'To nightclub'**
  String get prostitutionMoveToNightclubButton;

  /// No description provided for @prostitutionEuroPerHour.
  ///
  /// In en, this message translates to:
  /// **'€{amount}/hour'**
  String prostitutionEuroPerHour(String amount);

  /// No description provided for @prostitutionHappinessDetail.
  ///
  /// In en, this message translates to:
  /// **'Happiness {label} ({score}%) • Yield {bonus}'**
  String prostitutionHappinessDetail(String label, int score, String bonus);

  /// No description provided for @prostitutionHousingStatus.
  ///
  /// In en, this message translates to:
  /// **'Housing: {status}'**
  String prostitutionHousingStatus(String status);

  /// No description provided for @prostitutionWeeklyRentEuro.
  ///
  /// In en, this message translates to:
  /// **'Weekly rent €{amount}'**
  String prostitutionWeeklyRentEuro(int amount);

  /// No description provided for @prostitutionWork8h.
  ///
  /// In en, this message translates to:
  /// **'Work 8h'**
  String get prostitutionWork8h;

  /// No description provided for @prostitutionRestFor.
  ///
  /// In en, this message translates to:
  /// **'Rest {duration}'**
  String prostitutionRestFor(String duration);

  /// No description provided for @prostitutionNextShiftIn.
  ///
  /// In en, this message translates to:
  /// **'Next shift in {duration}'**
  String prostitutionNextShiftIn(String duration);

  /// No description provided for @prostitutionTimeHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String prostitutionTimeHoursMinutes(int hours, int minutes);

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

  /// No description provided for @nightclubErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading nightclub: {error}'**
  String nightclubErrorLoading(String error);

  /// No description provided for @nightclubServiceErrorStats.
  ///
  /// In en, this message translates to:
  /// **'Could not load nightclub stats'**
  String get nightclubServiceErrorStats;

  /// No description provided for @nightclubServiceErrorLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Could not load leaderboard'**
  String get nightclubServiceErrorLeaderboard;

  /// No description provided for @nightclubServiceErrorSeason.
  ///
  /// In en, this message translates to:
  /// **'Could not load season ranking'**
  String get nightclubServiceErrorSeason;

  /// No description provided for @nightclubErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String nightclubErrorWithDetail(String detail);

  /// No description provided for @nightclubResidentDjContractFailed.
  ///
  /// In en, this message translates to:
  /// **'Resident DJ contract failed'**
  String get nightclubResidentDjContractFailed;

  /// No description provided for @nightclubScheduleEventFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to schedule event'**
  String get nightclubScheduleEventFailed;

  /// No description provided for @nightclubMarketingUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Marketing upgrade failed'**
  String get nightclubMarketingUpgradeFailed;

  /// No description provided for @nightclubUpgradeFailed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade failed'**
  String get nightclubUpgradeFailed;

  /// No description provided for @nightclubIncidentResponseFailed.
  ///
  /// In en, this message translates to:
  /// **'Incident response failed'**
  String get nightclubIncidentResponseFailed;

  /// No description provided for @nightclubRivalActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Rival action failed'**
  String get nightclubRivalActionFailed;

  /// No description provided for @nightclubSupplierContractFailed.
  ///
  /// In en, this message translates to:
  /// **'Supplier contract failed'**
  String get nightclubSupplierContractFailed;

  /// No description provided for @nightclubPromoterFailed.
  ///
  /// In en, this message translates to:
  /// **'Promoter failed'**
  String get nightclubPromoterFailed;

  /// No description provided for @nightclubHeatCooldownFailed.
  ///
  /// In en, this message translates to:
  /// **'Heat cooldown failed'**
  String get nightclubHeatCooldownFailed;

  /// No description provided for @nightclubSmugglingFailed.
  ///
  /// In en, this message translates to:
  /// **'Smuggling failed'**
  String get nightclubSmugglingFailed;

  /// No description provided for @nightclubCounterIntelFailed.
  ///
  /// In en, this message translates to:
  /// **'Counter-intel failed'**
  String get nightclubCounterIntelFailed;

  /// No description provided for @nightclubHospitalityStockFailed.
  ///
  /// In en, this message translates to:
  /// **'Hospitality stock failed'**
  String get nightclubHospitalityStockFailed;

  /// No description provided for @nightclubHospitalityPricingFailed.
  ///
  /// In en, this message translates to:
  /// **'Hospitality pricing failed'**
  String get nightclubHospitalityPricingFailed;

  /// No description provided for @nightclubCurrentVisitorsPct.
  ///
  /// In en, this message translates to:
  /// **'Current visitors: {pct}%'**
  String nightclubCurrentVisitorsPct(String pct);

  /// No description provided for @nightclubCommandDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub Command Deck'**
  String get nightclubCommandDeckTitle;

  /// No description provided for @nightclubOpsDeckRevenueToday.
  ///
  /// In en, this message translates to:
  /// **'Revenue today'**
  String get nightclubOpsDeckRevenueToday;

  /// No description provided for @nightclubStockValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get nightclubStockValueLabel;

  /// No description provided for @nightclubCrewOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Crew occupancy'**
  String get nightclubCrewOccupancy;

  /// No description provided for @nightclubOperationalRisk.
  ///
  /// In en, this message translates to:
  /// **'Operational risk'**
  String get nightclubOperationalRisk;

  /// No description provided for @nightclubIncidents24h.
  ///
  /// In en, this message translates to:
  /// **'{count} incidents (24h)'**
  String nightclubIncidents24h(String count);

  /// No description provided for @nightclubActiveCrewShifts.
  ///
  /// In en, this message translates to:
  /// **'Active crew shifts'**
  String get nightclubActiveCrewShifts;

  /// No description provided for @nightclubRecentCrewHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent crew history'**
  String get nightclubRecentCrewHistory;

  /// No description provided for @nightclubBadgeVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get nightclubBadgeVip;

  /// No description provided for @nightclubBadgeStandard.
  ///
  /// In en, this message translates to:
  /// **'STANDARD'**
  String get nightclubBadgeStandard;

  /// No description provided for @nightclubActiveDj.
  ///
  /// In en, this message translates to:
  /// **'Active DJ'**
  String get nightclubActiveDj;

  /// No description provided for @nightclubActiveDjNone.
  ///
  /// In en, this message translates to:
  /// **'Active DJ: none'**
  String get nightclubActiveDjNone;

  /// No description provided for @nightclubUntilTime.
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String nightclubUntilTime(String time);

  /// No description provided for @nightclubActiveSecurity.
  ///
  /// In en, this message translates to:
  /// **'Active security'**
  String get nightclubActiveSecurity;

  /// No description provided for @nightclubActiveSecurityNone.
  ///
  /// In en, this message translates to:
  /// **'Active security: none'**
  String get nightclubActiveSecurityNone;

  /// No description provided for @nightclubNoDjsLoaded.
  ///
  /// In en, this message translates to:
  /// **'No DJs loaded. Refresh the screen.'**
  String get nightclubNoDjsLoaded;

  /// No description provided for @nightclubNoSecurityLoaded.
  ///
  /// In en, this message translates to:
  /// **'No security loaded. Refresh the screen.'**
  String get nightclubNoSecurityLoaded;

  /// No description provided for @nightclubCrowdBoost.
  ///
  /// In en, this message translates to:
  /// **'Crowd boost'**
  String get nightclubCrowdBoost;

  /// No description provided for @nightclubCostPerHour.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get nightclubCostPerHour;

  /// No description provided for @nightclubReputationLabel.
  ///
  /// In en, this message translates to:
  /// **'Reputation'**
  String get nightclubReputationLabel;

  /// No description provided for @nightclubSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get nightclubSpecialtyLabel;

  /// No description provided for @nightclubTheftReduction.
  ///
  /// In en, this message translates to:
  /// **'Theft reduction'**
  String get nightclubTheftReduction;

  /// No description provided for @nightclubShiftCost.
  ///
  /// In en, this message translates to:
  /// **'Shift cost'**
  String get nightclubShiftCost;

  /// No description provided for @nightclubSelectedStock.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get nightclubSelectedStock;

  /// No description provided for @nightclubAvailableGrams.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get nightclubAvailableGrams;

  /// No description provided for @nightclubMaxChip.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get nightclubMaxChip;

  /// No description provided for @nightclubStoredInNightclub.
  ///
  /// In en, this message translates to:
  /// **'Stored in nightclub'**
  String get nightclubStoredInNightclub;

  /// No description provided for @nightclubCurrentStockGrams.
  ///
  /// In en, this message translates to:
  /// **'Current stock: {grams}g'**
  String nightclubCurrentStockGrams(String grams);

  /// No description provided for @nightclubNoStoredDrugs.
  ///
  /// In en, this message translates to:
  /// **'No stored drugs yet.'**
  String get nightclubNoStoredDrugs;

  /// No description provided for @nightclubStockZeroSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Current stock is 0g (everything has been sold).'**
  String get nightclubStockZeroSoldOut;

  /// No description provided for @nightclubQualityWithValue.
  ///
  /// In en, this message translates to:
  /// **'Quality: {value}'**
  String nightclubQualityWithValue(String value);

  /// No description provided for @nightclubGramsStock.
  ///
  /// In en, this message translates to:
  /// **'{grams}g stock'**
  String nightclubGramsStock(String grams);

  /// No description provided for @nightclubOperationsLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations Lab (11 systems)'**
  String get nightclubOperationsLabTitle;

  /// No description provided for @nightclubSectionResidentDjContract.
  ///
  /// In en, this message translates to:
  /// **'1) Resident DJ contract'**
  String get nightclubSectionResidentDjContract;

  /// No description provided for @nightclubContractDiscount.
  ///
  /// In en, this message translates to:
  /// **'Contract discount'**
  String get nightclubContractDiscount;

  /// No description provided for @nightclubContractDuration.
  ///
  /// In en, this message translates to:
  /// **'Contract duration'**
  String get nightclubContractDuration;

  /// No description provided for @nightclubContractDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String nightclubContractDays(int count);

  /// No description provided for @nightclubStartResidentContract.
  ///
  /// In en, this message translates to:
  /// **'Start resident contract'**
  String get nightclubStartResidentContract;

  /// No description provided for @nightclubSectionEventCalendar.
  ///
  /// In en, this message translates to:
  /// **'2) Dynamic event calendar'**
  String get nightclubSectionEventCalendar;

  /// No description provided for @nightclubRecommendedToday.
  ///
  /// In en, this message translates to:
  /// **'Recommended today'**
  String get nightclubRecommendedToday;

  /// No description provided for @nightclubEventTemplate.
  ///
  /// In en, this message translates to:
  /// **'Event template'**
  String get nightclubEventTemplate;

  /// No description provided for @nightclubScheduleEventFiveMin.
  ///
  /// In en, this message translates to:
  /// **'Schedule event (+5 min)'**
  String get nightclubScheduleEventFiveMin;

  /// No description provided for @nightclubUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get nightclubUpcomingEvents;

  /// No description provided for @nightclubSectionUpgradeTree.
  ///
  /// In en, this message translates to:
  /// **'3) Upgrade tree'**
  String get nightclubSectionUpgradeTree;

  /// No description provided for @nightclubUpgradeSoundRig.
  ///
  /// In en, this message translates to:
  /// **'Sound rig'**
  String get nightclubUpgradeSoundRig;

  /// No description provided for @nightclubUpgradeVipLounge.
  ///
  /// In en, this message translates to:
  /// **'VIP lounge'**
  String get nightclubUpgradeVipLounge;

  /// No description provided for @nightclubUpgradeSurveillance.
  ///
  /// In en, this message translates to:
  /// **'Surveillance'**
  String get nightclubUpgradeSurveillance;

  /// No description provided for @nightclubUpgradeWithCost.
  ///
  /// In en, this message translates to:
  /// **'{name} ({cost})'**
  String nightclubUpgradeWithCost(String name, String cost);

  /// No description provided for @nightclubChooseUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Choose upgrade'**
  String get nightclubChooseUpgrade;

  /// No description provided for @nightclubUpgradeAlreadyMaxMessage.
  ///
  /// In en, this message translates to:
  /// **'This upgrade is already max level.'**
  String get nightclubUpgradeAlreadyMaxMessage;

  /// No description provided for @nightclubUpgradeAlreadyMaxed.
  ///
  /// In en, this message translates to:
  /// **'Upgrade already maxed'**
  String get nightclubUpgradeAlreadyMaxed;

  /// No description provided for @nightclubUpgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get nightclubUpgradeNow;

  /// No description provided for @nightclubMarketingInvestment.
  ///
  /// In en, this message translates to:
  /// **'Marketing investment'**
  String get nightclubMarketingInvestment;

  /// No description provided for @nightclubInvestMarketing.
  ///
  /// In en, this message translates to:
  /// **'Invest in marketing'**
  String get nightclubInvestMarketing;

  /// No description provided for @nightclubSectionPoliceHeat.
  ///
  /// In en, this message translates to:
  /// **'4) Police heat & incidents'**
  String get nightclubSectionPoliceHeat;

  /// No description provided for @nightclubHeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Heat'**
  String get nightclubHeatLabel;

  /// No description provided for @nightclubRaidRisk.
  ///
  /// In en, this message translates to:
  /// **'Raid risk'**
  String get nightclubRaidRisk;

  /// No description provided for @nightclubCooldownLabel.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get nightclubCooldownLabel;

  /// No description provided for @nightclubStartHeatCooldown.
  ///
  /// In en, this message translates to:
  /// **'Start heat cooldown'**
  String get nightclubStartHeatCooldown;

  /// No description provided for @nightclubBribe.
  ///
  /// In en, this message translates to:
  /// **'Bribe'**
  String get nightclubBribe;

  /// No description provided for @nightclubLockdown.
  ///
  /// In en, this message translates to:
  /// **'Lockdown'**
  String get nightclubLockdown;

  /// No description provided for @nightclubCounterIntelShort.
  ///
  /// In en, this message translates to:
  /// **'Counter-intel'**
  String get nightclubCounterIntelShort;

  /// No description provided for @nightclubSectionStaffMorale.
  ///
  /// In en, this message translates to:
  /// **'5) Staff fatigue & morale'**
  String get nightclubSectionStaffMorale;

  /// No description provided for @nightclubMorale.
  ///
  /// In en, this message translates to:
  /// **'Morale'**
  String get nightclubMorale;

  /// No description provided for @nightclubFatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get nightclubFatigue;

  /// No description provided for @nightclubStaffing.
  ///
  /// In en, this message translates to:
  /// **'Staffing'**
  String get nightclubStaffing;

  /// No description provided for @nightclubSectionSupplierPromoter.
  ///
  /// In en, this message translates to:
  /// **'6) Supplier & promoter'**
  String get nightclubSectionSupplierPromoter;

  /// No description provided for @nightclubSupplierContract.
  ///
  /// In en, this message translates to:
  /// **'Supplier contract'**
  String get nightclubSupplierContract;

  /// No description provided for @nightclubActivateSupplier.
  ///
  /// In en, this message translates to:
  /// **'Activate supplier'**
  String get nightclubActivateSupplier;

  /// No description provided for @nightclubPromoterProfile.
  ///
  /// In en, this message translates to:
  /// **'Promoter profile'**
  String get nightclubPromoterProfile;

  /// No description provided for @nightclubHirePromoter.
  ///
  /// In en, this message translates to:
  /// **'Hire promoter'**
  String get nightclubHirePromoter;

  /// No description provided for @nightclubSectionVipClientele.
  ///
  /// In en, this message translates to:
  /// **'7) VIP clientele & staff traits'**
  String get nightclubSectionVipClientele;

  /// No description provided for @nightclubVipShare.
  ///
  /// In en, this message translates to:
  /// **'VIP share'**
  String get nightclubVipShare;

  /// No description provided for @nightclubSpendMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Spend x'**
  String get nightclubSpendMultiplier;

  /// No description provided for @nightclubTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get nightclubTier;

  /// No description provided for @nightclubSectionSmugglingRoutes.
  ///
  /// In en, this message translates to:
  /// **'8) Smuggling routes'**
  String get nightclubSectionSmugglingRoutes;

  /// No description provided for @nightclubReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get nightclubReady;

  /// No description provided for @nightclubRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get nightclubRoute;

  /// No description provided for @nightclubStartRoute.
  ///
  /// In en, this message translates to:
  /// **'Start route'**
  String get nightclubStartRoute;

  /// No description provided for @nightclubLastRoute.
  ///
  /// In en, this message translates to:
  /// **'Last route'**
  String get nightclubLastRoute;

  /// No description provided for @nightclubRouteLockUntil.
  ///
  /// In en, this message translates to:
  /// **'Route lock active until {date}'**
  String nightclubRouteLockUntil(String date);

  /// No description provided for @nightclubSectionBarKitchen.
  ///
  /// In en, this message translates to:
  /// **'9) Bar & Kitchen management'**
  String get nightclubSectionBarKitchen;

  /// No description provided for @nightclubServiceLevel.
  ///
  /// In en, this message translates to:
  /// **'Service level'**
  String get nightclubServiceLevel;

  /// No description provided for @nightclubStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Stock status'**
  String get nightclubStockStatus;

  /// No description provided for @nightclubSpoilageRisk.
  ///
  /// In en, this message translates to:
  /// **'Spoilage risk'**
  String get nightclubSpoilageRisk;

  /// No description provided for @nightclubDrinksFoodStock.
  ///
  /// In en, this message translates to:
  /// **'Drinks/Food stock'**
  String get nightclubDrinksFoodStock;

  /// No description provided for @nightclubBuyStock.
  ///
  /// In en, this message translates to:
  /// **'Buy stock'**
  String get nightclubBuyStock;

  /// No description provided for @nightclubMenuPricingMode.
  ///
  /// In en, this message translates to:
  /// **'Menu pricing mode'**
  String get nightclubMenuPricingMode;

  /// No description provided for @nightclubApplyPricing.
  ///
  /// In en, this message translates to:
  /// **'Apply pricing'**
  String get nightclubApplyPricing;

  /// No description provided for @nightclubSectionRivals.
  ///
  /// In en, this message translates to:
  /// **'10) Rival clubs + counter-intel'**
  String get nightclubSectionRivals;

  /// No description provided for @nightclubSearchPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Search player name'**
  String get nightclubSearchPlayerName;

  /// No description provided for @nightclubTargetName.
  ///
  /// In en, this message translates to:
  /// **'Target (name)'**
  String get nightclubTargetName;

  /// No description provided for @nightclubRivalCrowdLine.
  ///
  /// In en, this message translates to:
  /// **'{name} • {country} • crowd {pct}%'**
  String nightclubRivalCrowdLine(String name, String country, String pct);

  /// No description provided for @nightclubSabotage.
  ///
  /// In en, this message translates to:
  /// **'Sabotage'**
  String get nightclubSabotage;

  /// No description provided for @nightclubPromoWar.
  ///
  /// In en, this message translates to:
  /// **'Promo war'**
  String get nightclubPromoWar;

  /// No description provided for @nightclubCounterIntelSweep.
  ///
  /// In en, this message translates to:
  /// **'Counter-intel sweep'**
  String get nightclubCounterIntelSweep;

  /// No description provided for @nightclubMitigation.
  ///
  /// In en, this message translates to:
  /// **'Mitigation'**
  String get nightclubMitigation;

  /// No description provided for @nightclubSectionTimeline.
  ///
  /// In en, this message translates to:
  /// **'11) Operations timeline'**
  String get nightclubSectionTimeline;

  /// No description provided for @nightclubNoTimelineEvents.
  ///
  /// In en, this message translates to:
  /// **'No timeline events.'**
  String get nightclubNoTimelineEvents;

  /// No description provided for @nightclubOperationsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Operations alerts'**
  String get nightclubOperationsAlerts;

  /// No description provided for @nightclubNoCriticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'No critical alerts.'**
  String get nightclubNoCriticalAlerts;

  /// No description provided for @nightclubQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick action'**
  String get nightclubQuickAction;

  /// No description provided for @nightclubMgmtCrewTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew & shifts'**
  String get nightclubMgmtCrewTitle;

  /// No description provided for @nightclubMgmtCrewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staffing, performance and shift history.'**
  String get nightclubMgmtCrewSubtitle;

  /// No description provided for @nightclubMgmtDrugsTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug storage'**
  String get nightclubMgmtDrugsTitle;

  /// No description provided for @nightclubMgmtDrugsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and transfer inventory in grams.'**
  String get nightclubMgmtDrugsSubtitle;

  /// No description provided for @nightclubMgmtDjTitle.
  ///
  /// In en, this message translates to:
  /// **'DJ command'**
  String get nightclubMgmtDjTitle;

  /// No description provided for @nightclubMgmtDjSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose DJ, shift length and live crowd boost.'**
  String get nightclubMgmtDjSubtitle;

  /// No description provided for @nightclubMgmtSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security unit'**
  String get nightclubMgmtSecurityTitle;

  /// No description provided for @nightclubMgmtSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theft reduction, costs and active security.'**
  String get nightclubMgmtSecuritySubtitle;

  /// No description provided for @nightclubMgmtOpsLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Ops Lab'**
  String get nightclubMgmtOpsLabTitle;

  /// No description provided for @nightclubMgmtOpsLabSubtitleAlert.
  ///
  /// In en, this message translates to:
  /// **'Live alerts: {alerts} | Smuggling: {smuggling}'**
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling);

  /// No description provided for @nightclubMgmtOpsLabSubtitleDefault.
  ///
  /// In en, this message translates to:
  /// **'11 systems for events, upgrades, routes and rivals.'**
  String get nightclubMgmtOpsLabSubtitleDefault;

  /// No description provided for @nightclubManagementPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub management'**
  String get nightclubManagementPanelTitle;

  /// No description provided for @nightclubChooseZoneHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a management zone and control everything without nested inner-scroll.'**
  String get nightclubChooseZoneHint;

  /// No description provided for @nightclubChipCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get nightclubChipCrew;

  /// No description provided for @nightclubChipStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get nightclubChipStorage;

  /// No description provided for @nightclubChipDjShift.
  ///
  /// In en, this message translates to:
  /// **'DJ shift'**
  String get nightclubChipDjShift;

  /// No description provided for @nightclubChipSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get nightclubChipSecurity;

  /// No description provided for @nightclubChipOpsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Ops alerts'**
  String get nightclubChipOpsAlerts;

  /// No description provided for @nightclubNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get nightclubNone;

  /// No description provided for @nightclubIntelligenceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub Intelligence'**
  String get nightclubIntelligenceCardTitle;

  /// No description provided for @nightclubSeasonStatus.
  ///
  /// In en, this message translates to:
  /// **'Season status'**
  String get nightclubSeasonStatus;

  /// No description provided for @nightclubSeasonCountdown.
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h {minutes}m'**
  String nightclubSeasonCountdown(String days, String hours, String minutes);

  /// No description provided for @nightclubShiftHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String nightclubShiftHours(String hours);

  /// No description provided for @nightclubTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String nightclubTimeMinutes(String minutes);

  /// No description provided for @nightclubTimeHoursOnly.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String nightclubTimeHoursOnly(String hours);

  /// No description provided for @nightclubTimeHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String nightclubTimeHoursMinutes(String hours, String minutes);

  /// No description provided for @theftCooldownRedeemTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip theft cooldown?'**
  String get theftCooldownRedeemTitle;

  /// No description provided for @theftCooldownRedeemMessage.
  ///
  /// In en, this message translates to:
  /// **'Spend {cost} credits to clear the vehicle theft cooldown now? Your balance: {balance}.'**
  String theftCooldownRedeemMessage(int cost, int balance);

  /// No description provided for @theftCooldownRedeemDontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show this confirmation again'**
  String get theftCooldownRedeemDontShowAgain;

  /// No description provided for @theftCooldownRedeemConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Use {credits} credits'**
  String theftCooldownRedeemConfirmAction(int credits);

  /// No description provided for @theftCooldownRedeemNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Credit speed-up is not available for this cooldown right now.'**
  String get theftCooldownRedeemNotAvailable;

  /// No description provided for @theftCooldownRedeemNoActiveCooldown.
  ///
  /// In en, this message translates to:
  /// **'No active theft cooldown to reset.'**
  String get theftCooldownRedeemNoActiveCooldown;

  /// No description provided for @theftCooldownRedeemInsufficientCredits.
  ///
  /// In en, this message translates to:
  /// **'Not enough credits.'**
  String get theftCooldownRedeemInsufficientCredits;

  /// No description provided for @theftCooldownRedeemFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not apply credits to the cooldown.'**
  String get theftCooldownRedeemFailed;

  /// No description provided for @theftCooldownRedeemSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cooldown cleared.'**
  String get theftCooldownRedeemSuccess;

  /// No description provided for @settingsTheftCooldownConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Theft cooldown (credits)'**
  String get settingsTheftCooldownConfirmTitle;

  /// No description provided for @settingsTheftCooldownConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for confirmation before spending credits to skip the vehicle theft cooldown. Turn off to redeem in one tap (lightning icon next to the timer).'**
  String get settingsTheftCooldownConfirmSubtitle;

  /// No description provided for @supportTicketsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get supportTicketsScreenTitle;

  /// No description provided for @supportLoadTicketsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tickets'**
  String get supportLoadTicketsFailed;

  /// No description provided for @supportLoadTicketFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ticket'**
  String get supportLoadTicketFailed;

  /// No description provided for @supportPickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image'**
  String get supportPickImageFailed;

  /// No description provided for @supportSubjectMessageMinLength.
  ///
  /// In en, this message translates to:
  /// **'Fill in subject and message (min. 3 chars).'**
  String get supportSubjectMessageMinLength;

  /// No description provided for @supportTicketCreated.
  ///
  /// In en, this message translates to:
  /// **'Ticket created.'**
  String get supportTicketCreated;

  /// No description provided for @supportCreateTicketFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create ticket'**
  String get supportCreateTicketFailed;

  /// No description provided for @supportReplySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent.'**
  String get supportReplySent;

  /// No description provided for @supportReplySendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply'**
  String get supportReplySendFailed;

  /// No description provided for @supportDeleteTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete ticket'**
  String get supportDeleteTicketTitle;

  /// No description provided for @supportDeleteTicketBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this ticket? This action cannot be undone.'**
  String get supportDeleteTicketBody;

  /// No description provided for @supportTicketDeleted.
  ///
  /// In en, this message translates to:
  /// **'Ticket deleted.'**
  String get supportTicketDeleted;

  /// No description provided for @supportDeleteTicketFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete ticket'**
  String get supportDeleteTicketFailed;

  /// No description provided for @supportUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get supportUnknownError;

  /// No description provided for @supportStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get supportStatusNew;

  /// No description provided for @supportStatusTriage.
  ///
  /// In en, this message translates to:
  /// **'Triage'**
  String get supportStatusTriage;

  /// No description provided for @supportStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get supportStatusInProgress;

  /// No description provided for @supportStatusWaitingPlayer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for player'**
  String get supportStatusWaitingPlayer;

  /// No description provided for @supportStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get supportStatusBlocked;

  /// No description provided for @supportStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportStatusResolved;

  /// No description provided for @supportStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportStatusClosed;

  /// No description provided for @supportStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get supportStatusArchived;

  /// No description provided for @supportCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get supportCategoryBug;

  /// No description provided for @supportCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get supportCategoryQuestion;

  /// No description provided for @supportCategoryFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get supportCategoryFeedback;

  /// No description provided for @supportCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportCategoryOther;

  /// No description provided for @supportPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get supportPriorityLow;

  /// No description provided for @supportPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get supportPriorityHigh;

  /// No description provided for @supportPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get supportPriorityUrgent;

  /// No description provided for @supportPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get supportPriorityNormal;

  /// No description provided for @supportTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String supportTimeDaysAgo(int count);

  /// No description provided for @supportTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String supportTimeHoursAgo(int count);

  /// No description provided for @supportTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String supportTimeMinutesAgo(int count);

  /// No description provided for @supportTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get supportTimeJustNow;

  /// No description provided for @supportSenderSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSenderSupport;

  /// No description provided for @supportSenderYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get supportSenderYou;

  /// No description provided for @supportImageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image.'**
  String get supportImageLoadFailed;

  /// No description provided for @supportMyTickets.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get supportMyTickets;

  /// No description provided for @supportTicketsCountInList.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String supportTicketsCountInList(String count);

  /// No description provided for @supportMyTicketsIntro.
  ///
  /// In en, this message translates to:
  /// **'Support now replies directly inside this screen. You can still optionally receive a push notification when your ticket gets an update.'**
  String get supportMyTicketsIntro;

  /// No description provided for @supportNoTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'You do not have any tickets yet. Create a new report below.'**
  String get supportNoTicketsYet;

  /// No description provided for @supportSelectTicketPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a ticket to open the conversation.'**
  String get supportSelectTicketPrompt;

  /// No description provided for @supportConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get supportConversation;

  /// No description provided for @supportNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get supportNoMessagesYet;

  /// No description provided for @supportAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get supportAttachments;

  /// No description provided for @supportReplyToTicket.
  ///
  /// In en, this message translates to:
  /// **'Reply to this ticket'**
  String get supportReplyToTicket;

  /// No description provided for @supportReplyFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Use this field when support asks for more information or when you want to provide an update. Inbox and push remain notification channels for new support replies.'**
  String get supportReplyFieldHint;

  /// No description provided for @supportYourReply.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get supportYourReply;

  /// No description provided for @supportSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get supportSendReply;

  /// No description provided for @supportNewTicket.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get supportNewTicket;

  /// No description provided for @supportNewTicketIntro.
  ///
  /// In en, this message translates to:
  /// **'Create a new report here. Support can then reply through inbox/push and in this screen, so you can continue the conversation in one place.'**
  String get supportNewTicketIntro;

  /// No description provided for @supportTicketReceivedBanner.
  ///
  /// In en, this message translates to:
  /// **'Ticket received'**
  String get supportTicketReceivedBanner;

  /// No description provided for @supportTicketNumberLine.
  ///
  /// In en, this message translates to:
  /// **'Ticket number: #{id}'**
  String supportTicketNumberLine(int id);

  /// No description provided for @supportTicketReceivedDetail.
  ///
  /// In en, this message translates to:
  /// **'The ticket now appears directly in your list above. New support replies also arrive as inbox messages and push notifications.'**
  String get supportTicketReceivedDetail;

  /// No description provided for @supportFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportFieldCategory;

  /// No description provided for @supportFieldModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get supportFieldModule;

  /// No description provided for @supportFieldSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportFieldSubject;

  /// No description provided for @supportFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportFieldMessage;

  /// No description provided for @supportReferenceOptional.
  ///
  /// In en, this message translates to:
  /// **'Reference (optional)'**
  String get supportReferenceOptional;

  /// No description provided for @supportReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'For example order id, screen name, country or short context'**
  String get supportReferenceHint;

  /// No description provided for @supportAddScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Add screenshot'**
  String get supportAddScreenshot;

  /// No description provided for @supportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get supportSubmit;

  /// No description provided for @supportLastMessagePrefix.
  ///
  /// In en, this message translates to:
  /// **'Last: '**
  String get supportLastMessagePrefix;

  /// No description provided for @supportReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get supportReferenceLabel;

  /// No description provided for @supportMod_support.
  ///
  /// In en, this message translates to:
  /// **'General support'**
  String get supportMod_support;

  /// No description provided for @supportMod_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get supportMod_dashboard;

  /// No description provided for @supportMod_messages.
  ///
  /// In en, this message translates to:
  /// **'Messages / inbox'**
  String get supportMod_messages;

  /// No description provided for @supportMod_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications / push'**
  String get supportMod_notifications;

  /// No description provided for @supportMod_payments.
  ///
  /// In en, this message translates to:
  /// **'Payments / premium'**
  String get supportMod_payments;

  /// No description provided for @supportMod_bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get supportMod_bank;

  /// No description provided for @supportMod_crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get supportMod_crypto;

  /// No description provided for @supportMod_travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get supportMod_travel;

  /// No description provided for @supportMod_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get supportMod_properties;

  /// No description provided for @supportMod_inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory / storage'**
  String get supportMod_inventory;

  /// No description provided for @supportMod_loadouts.
  ///
  /// In en, this message translates to:
  /// **'Loadouts / equipment'**
  String get supportMod_loadouts;

  /// No description provided for @supportMod_crimes.
  ///
  /// In en, this message translates to:
  /// **'Crimes'**
  String get supportMod_crimes;

  /// No description provided for @supportMod_jobs.
  ///
  /// In en, this message translates to:
  /// **'Work / jobs'**
  String get supportMod_jobs;

  /// No description provided for @supportMod_vehicles.
  ///
  /// In en, this message translates to:
  /// **'Car / bike / boat theft'**
  String get supportMod_vehicles;

  /// No description provided for @supportMod_garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get supportMod_garage;

  /// No description provided for @supportMod_marina.
  ///
  /// In en, this message translates to:
  /// **'Marina'**
  String get supportMod_marina;

  /// No description provided for @supportMod_aviation.
  ///
  /// In en, this message translates to:
  /// **'Aviation'**
  String get supportMod_aviation;

  /// No description provided for @supportMod_smuggling.
  ///
  /// In en, this message translates to:
  /// **'Smuggling'**
  String get supportMod_smuggling;

  /// No description provided for @supportMod_drugs.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get supportMod_drugs;

  /// No description provided for @supportMod_nightclub.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get supportMod_nightclub;

  /// No description provided for @supportMod_prostitution.
  ///
  /// In en, this message translates to:
  /// **'Prostitution'**
  String get supportMod_prostitution;

  /// No description provided for @supportMod_crew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get supportMod_crew;

  /// No description provided for @supportMod_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends / players'**
  String get supportMod_friends;

  /// No description provided for @supportMod_hitlist.
  ///
  /// In en, this message translates to:
  /// **'Hitlist'**
  String get supportMod_hitlist;

  /// No description provided for @supportMod_security.
  ///
  /// In en, this message translates to:
  /// **'Security / FBI'**
  String get supportMod_security;

  /// No description provided for @supportMod_prison.
  ///
  /// In en, this message translates to:
  /// **'Prison / court'**
  String get supportMod_prison;

  /// No description provided for @supportMod_casino.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get supportMod_casino;

  /// No description provided for @supportMod_school.
  ///
  /// In en, this message translates to:
  /// **'School / training'**
  String get supportMod_school;

  /// No description provided for @supportMod_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get supportMod_achievements;

  /// No description provided for @supportMod_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get supportMod_profile;

  /// No description provided for @supportMod_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get supportMod_settings;

  /// No description provided for @supportMod_events.
  ///
  /// In en, this message translates to:
  /// **'Events / leaderboard'**
  String get supportMod_events;

  /// No description provided for @supportMod_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportMod_other;

  /// No description provided for @gameEventDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get gameEventDefaultTitle;

  /// No description provided for @gameEventStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get gameEventStatusActive;

  /// No description provided for @gameEventStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get gameEventStatusScheduled;

  /// No description provided for @gameEventStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get gameEventStatusCompleted;

  /// No description provided for @gameEventStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get gameEventStatusDraft;

  /// No description provided for @gameEventTmplWeeklyVehicleTheftHuntTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Theft Hunt'**
  String get gameEventTmplWeeklyVehicleTheftHuntTitle;

  /// No description provided for @gameEventTmplWeeklyVehicleTheftHuntDesc.
  ///
  /// In en, this message translates to:
  /// **'Steal as many vehicles as you can during the event window.'**
  String get gameEventTmplWeeklyVehicleTheftHuntDesc;

  /// No description provided for @gameEventTmplSmugglingSurgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Smuggling Surge'**
  String get gameEventTmplSmugglingSurgeTitle;

  /// No description provided for @gameEventTmplSmugglingSurgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Move the most smuggled contraband this round.'**
  String get gameEventTmplSmugglingSurgeDesc;

  /// No description provided for @gameEventTmplLabOutputChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Output Challenge'**
  String get gameEventTmplLabOutputChallengeTitle;

  /// No description provided for @gameEventTmplLabOutputChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Produce the most output while the event is live.'**
  String get gameEventTmplLabOutputChallengeDesc;

  /// No description provided for @gameEventTmplStreetCrimeSpreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Street Crime Spree'**
  String get gameEventTmplStreetCrimeSpreeTitle;

  /// No description provided for @gameEventTmplStreetCrimeSpreeDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete as many crimes as possible in the live window.'**
  String get gameEventTmplStreetCrimeSpreeDesc;

  /// No description provided for @gameScreenLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load events.'**
  String get gameScreenLoadError;

  /// No description provided for @gameScreenDetailsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load event details.'**
  String get gameScreenDetailsLoadError;

  /// No description provided for @gameScreenSectionLive.
  ///
  /// In en, this message translates to:
  /// **'Live Events'**
  String get gameScreenSectionLive;

  /// No description provided for @gameScreenNoActive.
  ///
  /// In en, this message translates to:
  /// **'There are no active events right now.'**
  String get gameScreenNoActive;

  /// No description provided for @gameScreenSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get gameScreenSectionUpcoming;

  /// No description provided for @gameScreenNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'There are no scheduled events.'**
  String get gameScreenNoUpcoming;

  /// No description provided for @gameScreenStatusPrefix.
  ///
  /// In en, this message translates to:
  /// **'Status: {value}'**
  String gameScreenStatusPrefix(String value);

  /// No description provided for @gameScreenStartLine.
  ///
  /// In en, this message translates to:
  /// **'Start: {date}'**
  String gameScreenStartLine(String date);

  /// No description provided for @gameScreenEndLine.
  ///
  /// In en, this message translates to:
  /// **'End: {date}'**
  String gameScreenEndLine(String date);

  /// No description provided for @gameScreenYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get gameScreenYourProgress;

  /// No description provided for @gameScreenScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {value}'**
  String gameScreenScore(String value);

  /// No description provided for @gameScreenRank.
  ///
  /// In en, this message translates to:
  /// **'Rank: {value}'**
  String gameScreenRank(String value);

  /// No description provided for @gameScreenLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard (top 10)'**
  String get gameScreenLeaderboard;

  /// No description provided for @gameScreenNoLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data yet.'**
  String get gameScreenNoLeaderboard;

  /// No description provided for @gameScreenUnknownPlayer.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get gameScreenUnknownPlayer;

  /// No description provided for @gameScreenDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get gameScreenDash;

  /// No description provided for @gameCardActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get gameCardActive;

  /// No description provided for @gameCardScheduled.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get gameCardScheduled;

  /// No description provided for @gameCardYourScore.
  ///
  /// In en, this message translates to:
  /// **'Your score: {value}'**
  String gameCardYourScore(String value);

  /// No description provided for @gameCardYourRank.
  ///
  /// In en, this message translates to:
  /// **'Your rank: {value}'**
  String gameCardYourRank(String value);

  /// No description provided for @gameCardTapDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details and leaderboard'**
  String get gameCardTapDetails;

  /// No description provided for @eventFeedDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected from the event stream'**
  String get eventFeedDisconnected;

  /// No description provided for @eventFeedReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get eventFeedReconnecting;

  /// No description provided for @eventFeedConnectedWaiting.
  ///
  /// In en, this message translates to:
  /// **'Connected — waiting for events…'**
  String get eventFeedConnectedWaiting;

  /// No description provided for @eventFeedConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the event stream…'**
  String get eventFeedConnecting;

  /// No description provided for @evStreamConnectionEstablished.
  ///
  /// In en, this message translates to:
  /// **'Connected to the event stream'**
  String get evStreamConnectionEstablished;

  /// No description provided for @evStreamAuthRegistered.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get evStreamAuthRegistered;

  /// No description provided for @evStreamAuthLogin.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get evStreamAuthLogin;

  /// No description provided for @evStreamCrimeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully completed {crimeName}! +EUR {reward}, +{xpGained} XP'**
  String evStreamCrimeSuccess(String crimeName, String reward, String xpGained);

  /// No description provided for @evStreamCrimeSuccessJailed.
  ///
  /// In en, this message translates to:
  /// **'Successfully completed {crimeName}! +EUR {reward}, +{xpGained} XP — but caught! Jailed for {minutes, plural, one{1 minute} other{{minutes} minutes}}.'**
  String evStreamCrimeSuccessJailed(
    String crimeName,
    String reward,
    String xpGained,
    int minutes,
  );

  /// No description provided for @evStreamCrimeSeizedVehicle.
  ///
  /// In en, this message translates to:
  /// **' Your vehicle was seized by the police.'**
  String get evStreamCrimeSeizedVehicle;

  /// No description provided for @evStreamCrimeSeizedWeapon.
  ///
  /// In en, this message translates to:
  /// **' Your weapon was confiscated by the police.'**
  String get evStreamCrimeSeizedWeapon;

  /// No description provided for @evStreamCrimeSuccessCleared.
  ///
  /// In en, this message translates to:
  /// **'Successfully completed {crimeName}! Criminal record cleared: {count, plural, one{1 conviction} other{{count} convictions}} removed. +{xpGained} XP'**
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  );

  /// No description provided for @evStreamCrimeFailedArrested.
  ///
  /// In en, this message translates to:
  /// **'Arrested by {authority} during a {crimeName} attempt.'**
  String evStreamCrimeFailedArrested(String authority, String crimeName);

  /// No description provided for @evStreamCrimeFailedJailed.
  ///
  /// In en, this message translates to:
  /// **'Caught during {crimeName}! Jailed for {minutes, plural, one{1 minute} other{{minutes} minutes}}.'**
  String evStreamCrimeFailedJailed(String crimeName, int minutes);

  /// No description provided for @evStreamCrimeFailedBase.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete {crimeName}'**
  String evStreamCrimeFailedBase(String crimeName);

  /// No description provided for @evStreamChaseDamage.
  ///
  /// In en, this message translates to:
  /// **' Your vehicle took {pct}% damage during the chase.'**
  String evStreamChaseDamage(String pct);

  /// No description provided for @evStreamCrimeJailed.
  ///
  /// In en, this message translates to:
  /// **'Caught during {crimeName}! Jailed for {minutes, plural, one{1 minute} other{{minutes} minutes}}.'**
  String evStreamCrimeJailed(String crimeName, int minutes);

  /// No description provided for @evStreamJobSuccess.
  ///
  /// In en, this message translates to:
  /// **'Completed work as {jobName}! +€{earnings}, +{xpGained} XP'**
  String evStreamJobSuccess(String jobName, String earnings, String xpGained);

  /// No description provided for @evStreamJobSuccessEdu.
  ///
  /// In en, this message translates to:
  /// **' (Education bonus +{pct}%)'**
  String evStreamJobSuccessEdu(String pct);

  /// No description provided for @evStreamJobFailedXp.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete job as {jobName}. −{xpLost} XP'**
  String evStreamJobFailedXp(String jobName, String xpLost);

  /// No description provided for @evStreamJobFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete job as {jobName}'**
  String evStreamJobFailed(String jobName);

  /// No description provided for @evStreamJobErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid job'**
  String get evStreamJobErrorInvalid;

  /// No description provided for @evStreamJobErrorLevel.
  ///
  /// In en, this message translates to:
  /// **'Your rank is too low for this job'**
  String get evStreamJobErrorLevel;

  /// No description provided for @evStreamJobErrorCooldown.
  ///
  /// In en, this message translates to:
  /// **'This job is on cooldown. Wait {minutes, plural, one{1 more minute} other{{minutes} more minutes}}'**
  String evStreamJobErrorCooldown(int minutes);

  /// No description provided for @evStreamJobErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Job error: {reason}'**
  String evStreamJobErrorGeneric(String reason);

  /// No description provided for @evStreamTravelDeparted.
  ///
  /// In en, this message translates to:
  /// **'Flying to {dest}… −€{cost}'**
  String evStreamTravelDeparted(String dest, String cost);

  /// No description provided for @evStreamTravelArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived in {country}.'**
  String evStreamTravelArrived(String country);

  /// No description provided for @evStreamBankDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposited €{amount} to the bank'**
  String evStreamBankDeposit(String amount);

  /// No description provided for @evStreamBankWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdrew €{amount} from the bank'**
  String evStreamBankWithdraw(String amount);

  /// No description provided for @evStreamCryptoBuy.
  ///
  /// In en, this message translates to:
  /// **'Bought {quantity} {symbol} for €{total}'**
  String evStreamCryptoBuy(String quantity, String symbol, String total);

  /// No description provided for @evStreamCryptoSell.
  ///
  /// In en, this message translates to:
  /// **'Sold {quantity} {symbol} for €{total} (P&L €{pnl})'**
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  );

  /// No description provided for @evStreamCryptoAlert.
  ///
  /// In en, this message translates to:
  /// **'{symbol} alert: €{price} ({chg}% 24h)'**
  String evStreamCryptoAlert(String symbol, String price, String chg);

  /// No description provided for @evStreamCryptoOrderFilled.
  ///
  /// In en, this message translates to:
  /// **'{order} {side} filled: {quantity} {symbol} at €{price}'**
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  );

  /// No description provided for @evStreamCryptoOrderTriggered.
  ///
  /// In en, this message translates to:
  /// **'{trig} triggered for {symbol} at €{price}'**
  String evStreamCryptoOrderTriggered(String trig, String symbol, String price);

  /// No description provided for @evStreamCryptoRegime.
  ///
  /// In en, this message translates to:
  /// **'Market regime changed to {regime} ({move}% 24h)'**
  String evStreamCryptoRegime(String regime, String move);

  /// No description provided for @evStreamCryptoNews.
  ///
  /// In en, this message translates to:
  /// **'{sentiment} news: {headline}'**
  String evStreamCryptoNews(String sentiment, String headline);

  /// No description provided for @evStreamCryptoMissionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily mission complete: {title} (+EUR {reward})'**
  String evStreamCryptoMissionDaily(String title, String reward);

  /// No description provided for @evStreamCryptoMissionWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly mission complete: {title} (+EUR {reward})'**
  String evStreamCryptoMissionWeekly(String title, String reward);

  /// No description provided for @evStreamCryptoLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Crypto leaderboard reward: #{rank} (+EUR {reward})'**
  String evStreamCryptoLeaderboard(String rank, String reward);

  /// No description provided for @evStreamRegimeBull.
  ///
  /// In en, this message translates to:
  /// **'bullish'**
  String get evStreamRegimeBull;

  /// No description provided for @evStreamRegimeBear.
  ///
  /// In en, this message translates to:
  /// **'bearish'**
  String get evStreamRegimeBear;

  /// No description provided for @evStreamRegimeSideways.
  ///
  /// In en, this message translates to:
  /// **'sideways'**
  String get evStreamRegimeSideways;

  /// No description provided for @evStreamImpactBull.
  ///
  /// In en, this message translates to:
  /// **'Bullish'**
  String get evStreamImpactBull;

  /// No description provided for @evStreamImpactBear.
  ///
  /// In en, this message translates to:
  /// **'Bearish'**
  String get evStreamImpactBear;

  /// No description provided for @evStreamImpactNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get evStreamImpactNeutral;

  /// No description provided for @evStreamPropertyBought.
  ///
  /// In en, this message translates to:
  /// **'Purchased {name} for €{cost}'**
  String evStreamPropertyBought(String name, String cost);

  /// No description provided for @evStreamCrewCreated.
  ///
  /// In en, this message translates to:
  /// **'Created crew: {name}'**
  String evStreamCrewCreated(String name);

  /// No description provided for @evStreamCrewJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined crew: {name}'**
  String evStreamCrewJoined(String name);

  /// No description provided for @evStreamCrewWarDeclared.
  ///
  /// In en, this message translates to:
  /// **'Crew war declared: #{a} vs #{b} ({type})'**
  String evStreamCrewWarDeclared(String a, String b, String type);

  /// No description provided for @evStreamCrewWarStarted.
  ///
  /// In en, this message translates to:
  /// **'Crew war started: #{a} vs #{b}'**
  String evStreamCrewWarStarted(String a, String b);

  /// No description provided for @evStreamCrewLockdown.
  ///
  /// In en, this message translates to:
  /// **'Crew war #{id} is in lockdown'**
  String evStreamCrewLockdown(String id);

  /// No description provided for @evStreamCrewResolved.
  ///
  /// In en, this message translates to:
  /// **'Crew war #{id} resolved. Winner: crew #{winner}'**
  String evStreamCrewResolved(String id, String winner);

  /// No description provided for @evStreamCrewAction.
  ///
  /// In en, this message translates to:
  /// **'Crew war action: {action} (+{points} pt)'**
  String evStreamCrewAction(String action, String points);

  /// No description provided for @evStreamHeistOk.
  ///
  /// In en, this message translates to:
  /// **'Heist “{name}” successful! +€{money}'**
  String evStreamHeistOk(String name, String money);

  /// No description provided for @evStreamHeistFail.
  ///
  /// In en, this message translates to:
  /// **'Heist “{name}” failed.'**
  String evStreamHeistFail(String name);

  /// No description provided for @evStreamHospital.
  ///
  /// In en, this message translates to:
  /// **'Treated in hospital! +{hp} health, −€{cost}'**
  String evStreamHospital(String hp, String cost);

  /// No description provided for @evStreamPoliceArrested.
  ///
  /// In en, this message translates to:
  /// **'Arrested! Jailed for {mins} minutes'**
  String evStreamPoliceArrested(String mins);

  /// No description provided for @evStreamPoliceEscaped.
  ///
  /// In en, this message translates to:
  /// **'You escaped the police.'**
  String get evStreamPoliceEscaped;

  /// No description provided for @evStreamFbiRaid.
  ///
  /// In en, this message translates to:
  /// **'FBI raid! You lost property and money.'**
  String get evStreamFbiRaid;

  /// No description provided for @evStreamErrInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Not enough money'**
  String get evStreamErrInsufficientFunds;

  /// No description provided for @evStreamErrInsufficientHealth.
  ///
  /// In en, this message translates to:
  /// **'Not enough health for this action'**
  String get evStreamErrInsufficientHealth;

  /// No description provided for @evStreamErrInsufficientRank.
  ///
  /// In en, this message translates to:
  /// **'Requires rank {rank}'**
  String evStreamErrInsufficientRank(String rank);

  /// No description provided for @evStreamErrJailed.
  ///
  /// In en, this message translates to:
  /// **'You are in jail for {minutes, plural, one{1 more minute} other{{minutes} more minutes}}'**
  String evStreamErrJailed(int minutes);

  /// No description provided for @evStreamErrNoHealthDefault.
  ///
  /// In en, this message translates to:
  /// **'You need to rest and recover your health'**
  String get evStreamErrNoHealthDefault;

  /// No description provided for @evStreamErrCooldown.
  ///
  /// In en, this message translates to:
  /// **'Wait {seconds, plural, one{1 second} other{{seconds} seconds}} before trying again'**
  String evStreamErrCooldown(int seconds);

  /// No description provided for @evStreamErrRescuerJailed.
  ///
  /// In en, this message translates to:
  /// **'You cannot help others while you are in jail'**
  String get evStreamErrRescuerJailed;

  /// No description provided for @evStreamErrTargetNotJailed.
  ///
  /// In en, this message translates to:
  /// **'That player is not in jail'**
  String get evStreamErrTargetNotJailed;

  /// No description provided for @evStreamErrCannotRescueSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot free yourself'**
  String get evStreamErrCannotRescueSelf;

  /// No description provided for @evStreamJailbreakOk.
  ///
  /// In en, this message translates to:
  /// **'Jailbreak successful! The player is free.'**
  String get evStreamJailbreakOk;

  /// No description provided for @evStreamJailbreakFail.
  ///
  /// In en, this message translates to:
  /// **'Jailbreak failed! The player is still in jail.'**
  String get evStreamJailbreakFail;

  /// No description provided for @evStreamJailbreakCaught.
  ///
  /// In en, this message translates to:
  /// **'Jailbreak failed! You were caught and jailed for {mins} minutes.'**
  String evStreamJailbreakCaught(String mins);

  /// No description provided for @evStreamBailPaid.
  ///
  /// In en, this message translates to:
  /// **'Bail paid: €{amount}. You are free.'**
  String evStreamBailPaid(String amount);

  /// No description provided for @evStreamErrInternal.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get evStreamErrInternal;

  /// No description provided for @evStreamTest.
  ///
  /// In en, this message translates to:
  /// **'Test: {msg}'**
  String evStreamTest(String msg);

  /// No description provided for @evStreamNoCriminalRecord.
  ///
  /// In en, this message translates to:
  /// **'You have no criminal record to clear'**
  String get evStreamNoCriminalRecord;

  /// No description provided for @evStreamWeaponSelectRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a crime weapon before committing this crime'**
  String get evStreamWeaponSelectRequired;

  /// No description provided for @evStreamWeaponNotSuitable.
  ///
  /// In en, this message translates to:
  /// **'You need a suitable weapon: {types}'**
  String evStreamWeaponNotSuitable(String types);

  /// No description provided for @evStreamJobFallbackName.
  ///
  /// In en, this message translates to:
  /// **'job'**
  String get evStreamJobFallbackName;

  /// No description provided for @evStreamUnknownKey.
  ///
  /// In en, this message translates to:
  /// **'{key}'**
  String evStreamUnknownKey(String key);

  /// No description provided for @connectionErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionErrorGeneric;

  /// No description provided for @crimeWeaponSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Crime weapon'**
  String get crimeWeaponSectionTitle;

  /// No description provided for @crimeWeaponInstruction.
  ///
  /// In en, this message translates to:
  /// **'Choose which carried weapon you use by default for crimes that require one.'**
  String get crimeWeaponInstruction;

  /// No description provided for @crimeWeaponEmptyInventoryHelp.
  ///
  /// In en, this message translates to:
  /// **'Buy or move a usable weapon into your carried inventory first.'**
  String get crimeWeaponEmptyInventoryHelp;

  /// No description provided for @crimeWeaponSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select a weapon for crimes'**
  String get crimeWeaponSelectHint;

  /// No description provided for @crimeWeaponNoSelectionNote.
  ///
  /// In en, this message translates to:
  /// **'Without a selection, weapon-based crimes will not start.'**
  String get crimeWeaponNoSelectionNote;

  /// No description provided for @crimeWeaponSelectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Selected: {weaponLine}. Some crimes still require a matching weapon type on top of that.'**
  String crimeWeaponSelectedStatus(String weaponLine);

  /// No description provided for @crimeSetWeaponFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set crime weapon.'**
  String get crimeSetWeaponFailed;

  /// No description provided for @crimeChooseWeaponBeforeCommit.
  ///
  /// In en, this message translates to:
  /// **'Choose a crime weapon at the top of this screen or via Inventory first.'**
  String get crimeChooseWeaponBeforeCommit;

  /// No description provided for @crimeWeaponFooterNote.
  ///
  /// In en, this message translates to:
  /// **'Weapon-based crimes use the selected crime weapon above.'**
  String get crimeWeaponFooterNote;

  /// No description provided for @crimeCriminalRecordWipeDesc.
  ///
  /// In en, this message translates to:
  /// **'Forge court files and wipe your full criminal record if the operation succeeds.'**
  String get crimeCriminalRecordWipeDesc;

  /// No description provided for @crimeCardSuccessChance.
  ///
  /// In en, this message translates to:
  /// **'{percent}% success chance'**
  String crimeCardSuccessChance(int percent);

  /// No description provided for @crimeRequirementDrugsFull.
  ///
  /// In en, this message translates to:
  /// **'💊 {drugsRequired} (min {quantity}g): {names}'**
  String crimeRequirementDrugsFull(
    String drugsRequired,
    String quantity,
    String names,
  );

  /// No description provided for @crimeCommitUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get crimeCommitUnexpectedError;

  /// No description provided for @cooldownTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get cooldownTimeLeft;

  /// No description provided for @cooldownMustWaitExplanation.
  ///
  /// In en, this message translates to:
  /// **'You must wait before you can perform this action again.'**
  String get cooldownMustWaitExplanation;

  /// No description provided for @cooldownAlreadyFinished.
  ///
  /// In en, this message translates to:
  /// **'Cooldown already finished.'**
  String get cooldownAlreadyFinished;

  /// No description provided for @cooldownNotEnoughCredits.
  ///
  /// In en, this message translates to:
  /// **'Not enough credits.'**
  String get cooldownNotEnoughCredits;

  /// No description provided for @cooldownNoActiveToReset.
  ///
  /// In en, this message translates to:
  /// **'No active cooldown to reset.'**
  String get cooldownNoActiveToReset;

  /// No description provided for @cooldownNotAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Not available right now.'**
  String get cooldownNotAvailableNow;

  /// No description provided for @cooldownRedeemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to speed up with credits.'**
  String get cooldownRedeemFailed;

  /// No description provided for @cooldownFinishedInstantly.
  ///
  /// In en, this message translates to:
  /// **'Cooldown finished instantly.'**
  String get cooldownFinishedInstantly;

  /// No description provided for @cooldownSpeedUpNow.
  ///
  /// In en, this message translates to:
  /// **'Speed up now (-{cost} credits)'**
  String cooldownSpeedUpNow(int cost);

  /// No description provided for @cooldownCreditBalanceLine.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance} credits'**
  String cooldownCreditBalanceLine(int balance);

  /// No description provided for @cooldownLoadingCreditOptions.
  ///
  /// In en, this message translates to:
  /// **'Loading credit options…'**
  String get cooldownLoadingCreditOptions;

  /// No description provided for @cooldownWaitCrime.
  ///
  /// In en, this message translates to:
  /// **'The heat is too high…'**
  String get cooldownWaitCrime;

  /// No description provided for @cooldownWaitJob.
  ///
  /// In en, this message translates to:
  /// **'Taking a rest before you can work again'**
  String get cooldownWaitJob;

  /// No description provided for @cooldownWaitTravel.
  ///
  /// In en, this message translates to:
  /// **'Next flight departs in'**
  String get cooldownWaitTravel;

  /// No description provided for @cooldownWaitHeist.
  ///
  /// In en, this message translates to:
  /// **'Planning the heist…'**
  String get cooldownWaitHeist;

  /// No description provided for @cooldownWaitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Court is busy…'**
  String get cooldownWaitAppeal;

  /// No description provided for @cooldownWaitSchool.
  ///
  /// In en, this message translates to:
  /// **'Catch your breath before the next lesson…'**
  String get cooldownWaitSchool;

  /// No description provided for @cooldownWaitDefault.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get cooldownWaitDefault;

  /// No description provided for @weaponLabelKnife.
  ///
  /// In en, this message translates to:
  /// **'Knife'**
  String get weaponLabelKnife;

  /// No description provided for @weaponLabelHandgun9mm.
  ///
  /// In en, this message translates to:
  /// **'Pistol (9mm)'**
  String get weaponLabelHandgun9mm;

  /// No description provided for @weaponLabelHandgunHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy Pistol (.45)'**
  String get weaponLabelHandgunHeavy;

  /// No description provided for @weaponLabelSmgCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact SMG'**
  String get weaponLabelSmgCompact;

  /// No description provided for @weaponLabelShotgunPump.
  ///
  /// In en, this message translates to:
  /// **'Shotgun (pump)'**
  String get weaponLabelShotgunPump;

  /// No description provided for @weaponLabelMolotov.
  ///
  /// In en, this message translates to:
  /// **'Molotov cocktail'**
  String get weaponLabelMolotov;

  /// No description provided for @weaponLabelSmgSuppressed.
  ///
  /// In en, this message translates to:
  /// **'Suppressed SMG'**
  String get weaponLabelSmgSuppressed;

  /// No description provided for @weaponLabelShotgunTactical.
  ///
  /// In en, this message translates to:
  /// **'Tactical Shotgun'**
  String get weaponLabelShotgunTactical;

  /// No description provided for @weaponLabelAssaultRifle.
  ///
  /// In en, this message translates to:
  /// **'Assault rifle (AK-47)'**
  String get weaponLabelAssaultRifle;

  /// No description provided for @weaponLabelGrenadeFlash.
  ///
  /// In en, this message translates to:
  /// **'Flash grenade'**
  String get weaponLabelGrenadeFlash;

  /// No description provided for @weaponLabelGrenadeFrag.
  ///
  /// In en, this message translates to:
  /// **'Fragmentation grenade'**
  String get weaponLabelGrenadeFrag;

  /// No description provided for @weaponLabelSniperStandard.
  ///
  /// In en, this message translates to:
  /// **'Sniper rifle'**
  String get weaponLabelSniperStandard;

  /// No description provided for @weaponLabelAssaultRifleVip.
  ///
  /// In en, this message translates to:
  /// **'Elite assault rifle'**
  String get weaponLabelAssaultRifleVip;

  /// No description provided for @weaponLabelSniperVip.
  ///
  /// In en, this message translates to:
  /// **'Elite sniper rifle'**
  String get weaponLabelSniperVip;

  /// No description provided for @cooldownTitleCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime cooldown'**
  String get cooldownTitleCrime;

  /// No description provided for @cooldownTitleJob.
  ///
  /// In en, this message translates to:
  /// **'Job cooldown'**
  String get cooldownTitleJob;

  /// No description provided for @cooldownTitleTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel cooldown'**
  String get cooldownTitleTravel;

  /// No description provided for @cooldownTitleHeist.
  ///
  /// In en, this message translates to:
  /// **'Heist cooldown'**
  String get cooldownTitleHeist;

  /// No description provided for @cooldownTitleAppeal.
  ///
  /// In en, this message translates to:
  /// **'Appeal cooldown'**
  String get cooldownTitleAppeal;

  /// No description provided for @cooldownTitleSchool.
  ///
  /// In en, this message translates to:
  /// **'School cooldown'**
  String get cooldownTitleSchool;

  /// No description provided for @cooldownTitleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get cooldownTitleGeneric;

  /// No description provided for @crimeOutcomeDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Crime result'**
  String get crimeOutcomeDefaultTitle;

  /// No description provided for @territoryContestStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get territoryContestStatusPreparing;

  /// No description provided for @territoryContestStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get territoryContestStatusActive;

  /// No description provided for @territoryContestStatusLockdown.
  ///
  /// In en, this message translates to:
  /// **'Lockdown'**
  String get territoryContestStatusLockdown;

  /// No description provided for @territoryContestStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get territoryContestStatusResolved;

  /// No description provided for @territoryContestStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get territoryContestStatusCancelled;

  /// No description provided for @territoryContestHintPreparing.
  ///
  /// In en, this message translates to:
  /// **'This contest is currently in preparation. Once prep time ends, the region automatically becomes active and actions unlock.'**
  String get territoryContestHintPreparing;

  /// No description provided for @territoryContestHintLockdown.
  ///
  /// In en, this message translates to:
  /// **'This contest is in lockdown. No new actions can be taken now; the outcome resolves automatically.'**
  String get territoryContestHintLockdown;

  /// No description provided for @territoryNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get territoryNow;

  /// No description provided for @territoryRoleAttacker.
  ///
  /// In en, this message translates to:
  /// **'Attacker'**
  String get territoryRoleAttacker;

  /// No description provided for @territoryRoleDefender.
  ///
  /// In en, this message translates to:
  /// **'Defender'**
  String get territoryRoleDefender;

  /// No description provided for @territoryValueLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get territoryValueLow;

  /// No description provided for @territoryValueAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get territoryValueAverage;

  /// No description provided for @territoryValueHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get territoryValueHigh;

  /// No description provided for @territoryValueTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get territoryValueTop;

  /// No description provided for @territoryTagCapital.
  ///
  /// In en, this message translates to:
  /// **'Administrative center'**
  String get territoryTagCapital;

  /// No description provided for @territoryTagHarbor.
  ///
  /// In en, this message translates to:
  /// **'Harbor'**
  String get territoryTagHarbor;

  /// No description provided for @territoryTagIndustry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get territoryTagIndustry;

  /// No description provided for @territoryTagBorder.
  ///
  /// In en, this message translates to:
  /// **'Border region'**
  String get territoryTagBorder;

  /// No description provided for @territoryTagLogistics.
  ///
  /// In en, this message translates to:
  /// **'Logistics hub'**
  String get territoryTagLogistics;

  /// No description provided for @territoryActionPatrol.
  ///
  /// In en, this message translates to:
  /// **'Patrol'**
  String get territoryActionPatrol;

  /// No description provided for @territoryActionIntelScan.
  ///
  /// In en, this message translates to:
  /// **'Intel scan'**
  String get territoryActionIntelScan;

  /// No description provided for @territoryActionSabotage.
  ///
  /// In en, this message translates to:
  /// **'Sabotage'**
  String get territoryActionSabotage;

  /// No description provided for @territoryActionSupplyRun.
  ///
  /// In en, this message translates to:
  /// **'Supply run'**
  String get territoryActionSupplyRun;

  /// No description provided for @territoryActionRaid.
  ///
  /// In en, this message translates to:
  /// **'Raid'**
  String get territoryActionRaid;

  /// No description provided for @territoryActionDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get territoryActionDefense;

  /// No description provided for @territoryBonusStrategicRegion.
  ///
  /// In en, this message translates to:
  /// **'Strategic region'**
  String get territoryBonusStrategicRegion;

  /// No description provided for @territoryBonusAdjacentSupport.
  ///
  /// In en, this message translates to:
  /// **'Adjacent support'**
  String get territoryBonusAdjacentSupport;

  /// No description provided for @territoryBonusWarPressure.
  ///
  /// In en, this message translates to:
  /// **'War pressure'**
  String get territoryBonusWarPressure;

  /// No description provided for @territoryBonusHqLevel.
  ///
  /// In en, this message translates to:
  /// **'HQ level'**
  String get territoryBonusHqLevel;

  /// No description provided for @territoryBonusCrewMissionLevel.
  ///
  /// In en, this message translates to:
  /// **'Crew mission level'**
  String get territoryBonusCrewMissionLevel;

  /// No description provided for @territoryBonusCrewBuildings.
  ///
  /// In en, this message translates to:
  /// **'Crew side buildings'**
  String get territoryBonusCrewBuildings;

  /// No description provided for @territoryBonusOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get territoryBonusOther;

  /// No description provided for @territoryPointsLogicLine.
  ///
  /// In en, this message translates to:
  /// **'base {basePoints} + bonus {bonusPoints} = {totalPoints} contest points'**
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  );

  /// No description provided for @territoryErrorNotInCrew.
  ///
  /// In en, this message translates to:
  /// **'You must join a crew before you can attack territory.'**
  String get territoryErrorNotInCrew;

  /// No description provided for @territoryErrorContestAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'A contest is already running for this region. Refreshing the map to the latest state.'**
  String get territoryErrorContestAlreadyActive;

  /// No description provided for @territoryErrorCrewContestLimit.
  ///
  /// In en, this message translates to:
  /// **'Your crew has already reached the concurrent contest limit.'**
  String get territoryErrorCrewContestLimit;

  /// No description provided for @territoryErrorRegionsCap.
  ///
  /// In en, this message translates to:
  /// **'Your crew already owns the maximum number of regions.'**
  String get territoryErrorRegionsCap;

  /// No description provided for @territoryErrorContestNotActive.
  ///
  /// In en, this message translates to:
  /// **'This contest is not active yet. Wait for the preparation phase to finish.'**
  String get territoryErrorContestNotActive;

  /// No description provided for @territoryErrorActionCooldown.
  ///
  /// In en, this message translates to:
  /// **'You need to wait before performing another territory action.'**
  String get territoryErrorActionCooldown;

  /// No description provided for @territoryErrorActionRoleMismatch.
  ///
  /// In en, this message translates to:
  /// **'This action belongs to the other side of the contest.'**
  String get territoryErrorActionRoleMismatch;

  /// No description provided for @territoryErrorHqLevelRequired.
  ///
  /// In en, this message translates to:
  /// **'Your HQ level is too low for this territory action.'**
  String get territoryErrorHqLevelRequired;

  /// No description provided for @territoryErrorDailyCap.
  ///
  /// In en, this message translates to:
  /// **'You have reached your daily limit for territory actions.'**
  String get territoryErrorDailyCap;

  /// No description provided for @territoryErrorWrongCountry.
  ///
  /// In en, this message translates to:
  /// **'You can view every country, but territory actions only work in the country where you are currently located.'**
  String get territoryErrorWrongCountry;

  /// No description provided for @territoryErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown territory error.'**
  String get territoryErrorUnknown;

  /// No description provided for @territoryLegendUnderContest.
  ///
  /// In en, this message translates to:
  /// **'Under contest'**
  String get territoryLegendUnderContest;

  /// No description provided for @territoryLegendNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get territoryLegendNeutral;

  /// No description provided for @territoryTabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get territoryTabMap;

  /// No description provided for @territoryTabLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get territoryTabLeaderboard;

  /// No description provided for @territoryTabSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get territoryTabSeason;

  /// No description provided for @territorySelectCountryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get territorySelectCountryTooltip;

  /// No description provided for @territoryUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Territory is currently unavailable.'**
  String get territoryUnavailableMessage;

  /// No description provided for @territoryMapHintTapMain.
  ///
  /// In en, this message translates to:
  /// **'Tap a region on the map to open territory information and the attack button in a modal.'**
  String get territoryMapHintTapMain;

  /// No description provided for @territoryMapHintTapPanel.
  ///
  /// In en, this message translates to:
  /// **'Tap a region to directly open the modal with territory information and attack actions.'**
  String get territoryMapHintTapPanel;

  /// No description provided for @territoryMapHintMobile.
  ///
  /// In en, this message translates to:
  /// **'On mobile you can pinch in and out with two fingers and drag the zoomed map directly for smaller regions.'**
  String get territoryMapHintMobile;

  /// No description provided for @territoryMapHintColors.
  ///
  /// In en, this message translates to:
  /// **'Region colors show ownership; orange = active contest.'**
  String get territoryMapHintColors;

  /// No description provided for @territoryMapOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{country} map (crew control)'**
  String territoryMapOverviewTitle(String country);

  /// No description provided for @territoryLegendTitle.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get territoryLegendTitle;

  /// No description provided for @territoryYourCrewLine.
  ///
  /// In en, this message translates to:
  /// **'Your crew: {name}'**
  String territoryYourCrewLine(String name);

  /// No description provided for @territoryDetailRegionPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Region preview'**
  String get territoryDetailRegionPreviewTitle;

  /// No description provided for @territoryDetailRegionPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only the selected region, without the rest of the map.'**
  String get territoryDetailRegionPreviewSubtitle;

  /// No description provided for @territoryNeutralTerritory.
  ///
  /// In en, this message translates to:
  /// **'Neutral territory'**
  String get territoryNeutralTerritory;

  /// No description provided for @territoryDetailOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get territoryDetailOwner;

  /// No description provided for @territoryDetailNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get territoryDetailNeutral;

  /// No description provided for @territoryDetailStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get territoryDetailStability;

  /// No description provided for @territoryDetailEffectiveStability.
  ///
  /// In en, this message translates to:
  /// **'Effective stability'**
  String get territoryDetailEffectiveStability;

  /// No description provided for @territoryDetailControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get territoryDetailControl;

  /// No description provided for @territoryDetailValueTier.
  ///
  /// In en, this message translates to:
  /// **'Value tier'**
  String get territoryDetailValueTier;

  /// No description provided for @territoryDetailPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get territoryDetailPayout;

  /// No description provided for @territoryDetailStrategicRole.
  ///
  /// In en, this message translates to:
  /// **'Strategic role'**
  String get territoryDetailStrategicRole;

  /// No description provided for @territoryDetailAdjacentOwned.
  ///
  /// In en, this message translates to:
  /// **'Adjacent owned regions'**
  String get territoryDetailAdjacentOwned;

  /// No description provided for @territoryDetailActionBonuses.
  ///
  /// In en, this message translates to:
  /// **'Action bonuses'**
  String get territoryDetailActionBonuses;

  /// No description provided for @territoryDetailBonusInfo.
  ///
  /// In en, this message translates to:
  /// **'Bonus info'**
  String get territoryDetailBonusInfo;

  /// No description provided for @territoryDetailBonusInfoBody.
  ///
  /// In en, this message translates to:
  /// **'These bonuses only increase your contest points per action. The region € payout stays the same.'**
  String get territoryDetailBonusInfoBody;

  /// No description provided for @territoryDetailWarPressure.
  ///
  /// In en, this message translates to:
  /// **'War pressure'**
  String get territoryDetailWarPressure;

  /// No description provided for @territoryDetailAttackPressure.
  ///
  /// In en, this message translates to:
  /// **'attack pressure'**
  String get territoryDetailAttackPressure;

  /// No description provided for @territoryDetailStabilityWord.
  ///
  /// In en, this message translates to:
  /// **'stability'**
  String get territoryDetailStabilityWord;

  /// No description provided for @territoryWarRoleTheater.
  ///
  /// In en, this message translates to:
  /// **'theater region'**
  String get territoryWarRoleTheater;

  /// No description provided for @territoryWarRoleAdjacent.
  ///
  /// In en, this message translates to:
  /// **'adjacent region'**
  String get territoryWarRoleAdjacent;

  /// No description provided for @territoryWarRoleTarget.
  ///
  /// In en, this message translates to:
  /// **'target region'**
  String get territoryWarRoleTarget;

  /// No description provided for @territoryWarPressureEndsIn.
  ///
  /// In en, this message translates to:
  /// **'War pressure ends in'**
  String get territoryWarPressureEndsIn;

  /// No description provided for @territoryDetailIncomeHour.
  ///
  /// In en, this message translates to:
  /// **'Income per hour'**
  String get territoryDetailIncomeHour;

  /// No description provided for @territoryDetailIncomeDay.
  ///
  /// In en, this message translates to:
  /// **'Income per day'**
  String get territoryDetailIncomeDay;

  /// No description provided for @territoryDetailYourCrew.
  ///
  /// In en, this message translates to:
  /// **'Your crew'**
  String get territoryDetailYourCrew;

  /// No description provided for @territoryDetailContestStatus.
  ///
  /// In en, this message translates to:
  /// **'Contest status'**
  String get territoryDetailContestStatus;

  /// No description provided for @territoryDetailYourRole.
  ///
  /// In en, this message translates to:
  /// **'Your role'**
  String get territoryDetailYourRole;

  /// No description provided for @territoryDetailYourHqLevel.
  ///
  /// In en, this message translates to:
  /// **'Your HQ level'**
  String get territoryDetailYourHqLevel;

  /// No description provided for @territoryDetailActionsUnlockIn.
  ///
  /// In en, this message translates to:
  /// **'Actions unlock in'**
  String get territoryDetailActionsUnlockIn;

  /// No description provided for @territoryDetailActionsCloseIn.
  ///
  /// In en, this message translates to:
  /// **'Actions close in'**
  String get territoryDetailActionsCloseIn;

  /// No description provided for @territoryDetailContestEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Contest ends in'**
  String get territoryDetailContestEndsIn;

  /// No description provided for @territoryDetailCooldownPerAction.
  ///
  /// In en, this message translates to:
  /// **'Cooldown per action'**
  String get territoryDetailCooldownPerAction;

  /// No description provided for @territoryDetailYourCooldown.
  ///
  /// In en, this message translates to:
  /// **'Your cooldown'**
  String get territoryDetailYourCooldown;

  /// No description provided for @territoryNoticeCrewOnly.
  ///
  /// In en, this message translates to:
  /// **'Territory is only playable for crew members. Create or join a crew first, then you can attack neutral regions.'**
  String get territoryNoticeCrewOnly;

  /// No description provided for @territoryNoticeWrongCountry.
  ///
  /// In en, this message translates to:
  /// **'You are viewing {viewingCountry}, but you are currently in {playerCountry}. You can browse this map, but attacks and contest actions only unlock after you travel to this country.'**
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  );

  /// No description provided for @territoryNoticeOwnRegion.
  ///
  /// In en, this message translates to:
  /// **'Your crew already controls this region.'**
  String get territoryNoticeOwnRegion;

  /// No description provided for @territoryNoticeDefenderPrep.
  ///
  /// In en, this message translates to:
  /// **'Your crew is defending this region. Once the active phase starts, you will only see defensive actions.'**
  String get territoryNoticeDefenderPrep;

  /// No description provided for @territoryConfirmDefense.
  ///
  /// In en, this message translates to:
  /// **'Confirm defense'**
  String get territoryConfirmDefense;

  /// No description provided for @territoryAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get territoryAttack;

  /// No description provided for @territoryAttackerActions.
  ///
  /// In en, this message translates to:
  /// **'Attacker actions'**
  String get territoryAttackerActions;

  /// No description provided for @territoryDefenderActions.
  ///
  /// In en, this message translates to:
  /// **'Defender actions'**
  String get territoryDefenderActions;

  /// No description provided for @territoryContestActions.
  ///
  /// In en, this message translates to:
  /// **'Contest actions'**
  String get territoryContestActions;

  /// No description provided for @territoryIntelShort.
  ///
  /// In en, this message translates to:
  /// **'Intel scan'**
  String get territoryIntelShort;

  /// No description provided for @territoryRequiresHqShort.
  ///
  /// In en, this message translates to:
  /// **'requires HQ'**
  String get territoryRequiresHqShort;

  /// No description provided for @territoryHqLockedNotice.
  ///
  /// In en, this message translates to:
  /// **'Higher HQ level required for: {actions}.'**
  String territoryHqLockedNotice(String actions);

  /// No description provided for @territoryNotInContestNotice.
  ///
  /// In en, this message translates to:
  /// **'You are not part of this contest, so you cannot perform actions here.'**
  String get territoryNotInContestNotice;

  /// No description provided for @territoryContestOtherCountryNotice.
  ///
  /// In en, this message translates to:
  /// **'This contest is taking place in another country. You can follow it, but you can only join once you are physically in {country}.'**
  String territoryContestOtherCountryNotice(String country);

  /// No description provided for @territoryLeaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No territory controlled yet.'**
  String get territoryLeaderboardEmpty;

  /// No description provided for @territoryLeaderboardRegionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} regions'**
  String territoryLeaderboardRegionsCount(int count);

  /// No description provided for @territorySeasonNone.
  ///
  /// In en, this message translates to:
  /// **'No active season found.'**
  String get territorySeasonNone;

  /// No description provided for @territorySeasonCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current season'**
  String get territorySeasonCurrent;

  /// No description provided for @territorySeasonKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get territorySeasonKey;

  /// No description provided for @territorySeasonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get territorySeasonStatus;

  /// No description provided for @territorySeasonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get territorySeasonStart;

  /// No description provided for @territorySeasonEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get territorySeasonEnd;

  /// No description provided for @territoryDialogAttackTitle.
  ///
  /// In en, this message translates to:
  /// **'Attack?'**
  String get territoryDialogAttackTitle;

  /// No description provided for @territoryDialogAttackBody.
  ///
  /// In en, this message translates to:
  /// **'Start a contest for {regionKey}?'**
  String territoryDialogAttackBody(String regionKey);

  /// No description provided for @territorySnackJoinCrewFirst.
  ///
  /// In en, this message translates to:
  /// **'Join a crew first to attack territory.'**
  String get territorySnackJoinCrewFirst;

  /// No description provided for @territorySnackContestStarted.
  ///
  /// In en, this message translates to:
  /// **'Contest started. Status: {status}. Wait for the preparation phase to finish before taking actions.'**
  String territorySnackContestStarted(String status);

  /// No description provided for @territorySnackContestAlreadyLive.
  ///
  /// In en, this message translates to:
  /// **'The contest is already started and the map has been refreshed. Status: {status}.'**
  String territorySnackContestAlreadyLive(String status);

  /// No description provided for @territoryPointsDelta.
  ///
  /// In en, this message translates to:
  /// **'+{points} points!'**
  String territoryPointsDelta(String points);

  /// No description provided for @territorySnackDefenseConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Defense confirmed. Once the active phase starts, you can perform defensive actions.'**
  String get territorySnackDefenseConfirmed;

  /// No description provided for @territorySnackContestRefreshed.
  ///
  /// In en, this message translates to:
  /// **'The contest state has been refreshed. You can now immediately see the current defense phase.'**
  String get territorySnackContestRefreshed;

  /// No description provided for @territoryHqTooltipLocked.
  ///
  /// In en, this message translates to:
  /// **'Requires HQ level {required}. Current HQ level: {current}.'**
  String territoryHqTooltipLocked(int required, int current);

  /// No description provided for @territoryHqButtonLocked.
  ///
  /// In en, this message translates to:
  /// **'{label} (requires HQ {level})'**
  String territoryHqButtonLocked(String label, int level);

  /// No description provided for @smugglingHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Smuggling Hub'**
  String get smugglingHubTitle;

  /// No description provided for @smugglingHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One system for drugs, trade goods, vehicles, weapons and ammo. Travel empty and claim safely from depot.'**
  String get smugglingHubSubtitle;

  /// No description provided for @smugglingClaimPersonal.
  ///
  /// In en, this message translates to:
  /// **'Claim personal'**
  String get smugglingClaimPersonal;

  /// No description provided for @smugglingClaimCrew.
  ///
  /// In en, this message translates to:
  /// **'Claim crew'**
  String get smugglingClaimCrew;

  /// No description provided for @smugglingNewShipment.
  ///
  /// In en, this message translates to:
  /// **'New shipment'**
  String get smugglingNewShipment;

  /// No description provided for @smugglingCategoryDrug.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get smugglingCategoryDrug;

  /// No description provided for @smugglingCategoryTrade.
  ///
  /// In en, this message translates to:
  /// **'Trade goods'**
  String get smugglingCategoryTrade;

  /// No description provided for @smugglingCategoryVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get smugglingCategoryVehicle;

  /// No description provided for @smugglingCategoryWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get smugglingCategoryWeapon;

  /// No description provided for @smugglingCategoryAmmo.
  ///
  /// In en, this message translates to:
  /// **'Ammo'**
  String get smugglingCategoryAmmo;

  /// No description provided for @smugglingNoItemsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No available items in this category.'**
  String get smugglingNoItemsInCategory;

  /// No description provided for @smugglingFieldItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get smugglingFieldItem;

  /// No description provided for @smugglingFieldDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get smugglingFieldDestination;

  /// No description provided for @smugglingTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get smugglingTransport;

  /// No description provided for @smugglingCommercialChannel.
  ///
  /// In en, this message translates to:
  /// **'Commercial channel'**
  String get smugglingCommercialChannel;

  /// No description provided for @smugglingOwnedVehicleAircraft.
  ///
  /// In en, this message translates to:
  /// **'Owned vehicle / aircraft'**
  String get smugglingOwnedVehicleAircraft;

  /// No description provided for @smugglingNoOwnedTransportInCountry.
  ///
  /// In en, this message translates to:
  /// **'You do not have an owned vehicle or aircraft available for smuggling in this country.'**
  String get smugglingNoOwnedTransportInCountry;

  /// No description provided for @smugglingOwnedTransportFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Owned transport'**
  String get smugglingOwnedTransportFieldLabel;

  /// No description provided for @smugglingOwnedTransportCapacityLine.
  ///
  /// In en, this message translates to:
  /// **'Capacity: {slots} slots • Confiscation on failure: {percent}%'**
  String smugglingOwnedTransportCapacityLine(int slots, String percent);

  /// No description provided for @smugglingOwnedTransportDropdownRow.
  ///
  /// In en, this message translates to:
  /// **'{label} • {slots} slots • -{riskReduction}%'**
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  );

  /// No description provided for @smugglingNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get smugglingNetwork;

  /// No description provided for @smugglingPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get smugglingPersonal;

  /// No description provided for @smugglingCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get smugglingCrew;

  /// No description provided for @smugglingChannelField.
  ///
  /// In en, this message translates to:
  /// **'Smuggling channel'**
  String get smugglingChannelField;

  /// No description provided for @smugglingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get smugglingQuantity;

  /// No description provided for @smugglingVehiclesOneByOne.
  ///
  /// In en, this message translates to:
  /// **'Vehicles are shipped one by one'**
  String get smugglingVehiclesOneByOne;

  /// No description provided for @smugglingMaxQuantity.
  ///
  /// In en, this message translates to:
  /// **'Max: {max}'**
  String smugglingMaxQuantity(int max);

  /// No description provided for @smugglingStartSmuggling.
  ///
  /// In en, this message translates to:
  /// **'Start smuggling'**
  String get smugglingStartSmuggling;

  /// No description provided for @smugglingSelectItemDestination.
  ///
  /// In en, this message translates to:
  /// **'Select item and destination'**
  String get smugglingSelectItemDestination;

  /// No description provided for @smugglingCrewTradeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Crew smuggling for trade goods is not available yet'**
  String get smugglingCrewTradeNotAvailable;

  /// No description provided for @smugglingSelectOwnedTransportFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an owned vehicle or aircraft first'**
  String get smugglingSelectOwnedTransportFirst;

  /// No description provided for @smugglingInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get smugglingInvalidQuantity;

  /// No description provided for @smugglingActionProcessed.
  ///
  /// In en, this message translates to:
  /// **'Action processed'**
  String get smugglingActionProcessed;

  /// No description provided for @smugglingQuoteSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'€{fee} • {etaMinutes} min • {risk}% risk'**
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk);

  /// No description provided for @smugglingSeizureRiskPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% risk'**
  String smugglingSeizureRiskPercent(String percent);

  /// No description provided for @smugglingQuotePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select item and destination for a live quote.'**
  String get smugglingQuotePrompt;

  /// No description provided for @smugglingQuoteLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live quote'**
  String get smugglingQuoteLiveTitle;

  /// No description provided for @smugglingOwnedTransportCaption.
  ///
  /// In en, this message translates to:
  /// **'Owned transport: {label}'**
  String smugglingOwnedTransportCaption(String label);

  /// No description provided for @smugglingCargoSlotsLine.
  ///
  /// In en, this message translates to:
  /// **'Cargo slots: {required} / {available}'**
  String smugglingCargoSlotsLine(int required, int available);

  /// No description provided for @smugglingCooldownActive.
  ///
  /// In en, this message translates to:
  /// **'Cooldown active: {duration}'**
  String smugglingCooldownActive(String duration);

  /// No description provided for @smugglingRecommendedChannel.
  ///
  /// In en, this message translates to:
  /// **'Recommended channel: {channel}'**
  String smugglingRecommendedChannel(String channel);

  /// No description provided for @smugglingInsufficientCash.
  ///
  /// In en, this message translates to:
  /// **'Insufficient cash for this shipment'**
  String get smugglingInsufficientCash;

  /// No description provided for @smugglingDepotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Country depots'**
  String get smugglingDepotsTitle;

  /// No description provided for @smugglingDepotsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No packages ready in depots.'**
  String get smugglingDepotsEmpty;

  /// No description provided for @smugglingDepotLine.
  ///
  /// In en, this message translates to:
  /// **'{packages} packages • {totalQuantity} units'**
  String smugglingDepotLine(int packages, int totalQuantity);

  /// No description provided for @smugglingClaimHere.
  ///
  /// In en, this message translates to:
  /// **'Claim here'**
  String get smugglingClaimHere;

  /// No description provided for @smugglingStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Smuggling status'**
  String get smugglingStatusTitle;

  /// No description provided for @smugglingNoShipmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No shipments yet.'**
  String get smugglingNoShipmentsYet;

  /// No description provided for @smugglingStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get smugglingStatusInTransit;

  /// No description provided for @smugglingStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get smugglingStatusReady;

  /// No description provided for @smugglingStatusSeized.
  ///
  /// In en, this message translates to:
  /// **'Seized'**
  String get smugglingStatusSeized;

  /// No description provided for @smugglingStatusClaimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get smugglingStatusClaimed;

  /// No description provided for @smugglingStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get smugglingStatusUnknown;

  /// No description provided for @smugglingChannelPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get smugglingChannelPackage;

  /// No description provided for @smugglingChannelCourier.
  ///
  /// In en, this message translates to:
  /// **'Courier'**
  String get smugglingChannelCourier;

  /// No description provided for @smugglingChannelContainer.
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get smugglingChannelContainer;

  /// No description provided for @smugglingChannelOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned transport'**
  String get smugglingChannelOwned;

  /// No description provided for @smugglingHintOwnedTransport.
  ///
  /// In en, this message translates to:
  /// **'Owned transport lowers cost and risk, but it can be confiscated on a failed run.'**
  String get smugglingHintOwnedTransport;

  /// No description provided for @smugglingHintVehiclesChannel.
  ///
  /// In en, this message translates to:
  /// **'Tip: vehicles work best with Courier or Container.'**
  String get smugglingHintVehiclesChannel;

  /// No description provided for @smugglingHintWeaponsChannel.
  ///
  /// In en, this message translates to:
  /// **'Tip: larger weapon loads are better via Container.'**
  String get smugglingHintWeaponsChannel;

  /// No description provided for @smugglingHintAmmoChannel.
  ///
  /// In en, this message translates to:
  /// **'Tip: bulk ammo via Container for lower risk.'**
  String get smugglingHintAmmoChannel;

  /// No description provided for @smugglingHintDrugsChannel.
  ///
  /// In en, this message translates to:
  /// **'Tip: small batches via Package, bulk via Container.'**
  String get smugglingHintDrugsChannel;

  /// No description provided for @smugglingHintCompareChannels.
  ///
  /// In en, this message translates to:
  /// **'Tip: compare channels with the live quote.'**
  String get smugglingHintCompareChannels;

  /// No description provided for @smugglingQuoteBoatCannotFit.
  ///
  /// In en, this message translates to:
  /// **'A boat cannot fit in an aircraft.'**
  String get smugglingQuoteBoatCannotFit;

  /// No description provided for @smugglingQuoteCargoOverflow.
  ///
  /// In en, this message translates to:
  /// **'Your owned transport cargo capacity is too small.'**
  String get smugglingQuoteCargoOverflow;

  /// No description provided for @smugglingQuoteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Quote unavailable'**
  String get smugglingQuoteUnavailable;

  /// No description provided for @smugglingApiInvalidChannel.
  ///
  /// In en, this message translates to:
  /// **'Invalid smuggling channel'**
  String get smugglingApiInvalidChannel;

  /// No description provided for @smugglingApiInvalidNetwork.
  ///
  /// In en, this message translates to:
  /// **'Invalid network choice'**
  String get smugglingApiInvalidNetwork;

  /// No description provided for @smugglingApiInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get smugglingApiInvalidQuantity;

  /// No description provided for @smugglingApiInvalidDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination country does not exist'**
  String get smugglingApiInvalidDestination;

  /// No description provided for @smugglingApiPlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found'**
  String get smugglingApiPlayerNotFound;

  /// No description provided for @smugglingApiSameCountryInventory.
  ///
  /// In en, this message translates to:
  /// **'Use local inventory for the same country'**
  String get smugglingApiSameCountryInventory;

  /// No description provided for @smugglingApiNotInCrew.
  ///
  /// In en, this message translates to:
  /// **'You are not in a crew'**
  String get smugglingApiNotInCrew;

  /// No description provided for @smugglingApiCrewTradeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Crew smuggling for trade goods is not available yet'**
  String get smugglingApiCrewTradeUnavailable;

  /// No description provided for @smugglingApiOwnedVehiclesPersonalOnly.
  ///
  /// In en, this message translates to:
  /// **'Owned vehicles only work for personal smuggling'**
  String get smugglingApiOwnedVehiclesPersonalOnly;

  /// No description provided for @smugglingApiChooseOwnedTransport.
  ///
  /// In en, this message translates to:
  /// **'Choose an owned vehicle or aircraft'**
  String get smugglingApiChooseOwnedTransport;

  /// No description provided for @smugglingApiChosenOwnedTransportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Selected owned vehicle is not available'**
  String get smugglingApiChosenOwnedTransportUnavailable;

  /// No description provided for @smugglingApiSameVehicleCargoConflict.
  ///
  /// In en, this message translates to:
  /// **'You cannot use the same vehicle as both cargo and transport'**
  String get smugglingApiSameVehicleCargoConflict;

  /// No description provided for @smugglingApiCarCannotCarryOtherVehicle.
  ///
  /// In en, this message translates to:
  /// **'A car or motorcycle cannot carry another vehicle'**
  String get smugglingApiCarCannotCarryOtherVehicle;

  /// No description provided for @smugglingApiVehiclesCannotUsePackageChannel.
  ///
  /// In en, this message translates to:
  /// **'Vehicles cannot use the package channel'**
  String get smugglingApiVehiclesCannotUsePackageChannel;

  /// No description provided for @smugglingApiBoatCannotFit.
  ///
  /// In en, this message translates to:
  /// **'A boat cannot fit in an aircraft.'**
  String get smugglingApiBoatCannotFit;

  /// No description provided for @smugglingApiCargoOverflow.
  ///
  /// In en, this message translates to:
  /// **'Your owned transport cargo capacity is too small.'**
  String get smugglingApiCargoOverflow;

  /// No description provided for @smugglingApiCooldownWait.
  ///
  /// In en, this message translates to:
  /// **'Wait {seconds}s before another {channel} shipment'**
  String smugglingApiCooldownWait(int seconds, String channel);

  /// No description provided for @smugglingApiInsufficientMoney.
  ///
  /// In en, this message translates to:
  /// **'Not enough money for smuggling fees'**
  String get smugglingApiInsufficientMoney;

  /// No description provided for @smugglingApiInsufficientDrugsCrew.
  ///
  /// In en, this message translates to:
  /// **'Not enough drugs in crew inventory'**
  String get smugglingApiInsufficientDrugsCrew;

  /// No description provided for @smugglingApiInsufficientDrugs.
  ///
  /// In en, this message translates to:
  /// **'Not enough drugs in inventory'**
  String get smugglingApiInsufficientDrugs;

  /// No description provided for @smugglingApiInsufficientTradeGoods.
  ///
  /// In en, this message translates to:
  /// **'Not enough trade goods in inventory'**
  String get smugglingApiInsufficientTradeGoods;

  /// No description provided for @smugglingApiInsufficientWeaponsCrew.
  ///
  /// In en, this message translates to:
  /// **'Not enough weapons in crew inventory'**
  String get smugglingApiInsufficientWeaponsCrew;

  /// No description provided for @smugglingApiInsufficientWeapons.
  ///
  /// In en, this message translates to:
  /// **'Not enough weapons in inventory'**
  String get smugglingApiInsufficientWeapons;

  /// No description provided for @smugglingApiInsufficientAmmoCrew.
  ///
  /// In en, this message translates to:
  /// **'Not enough ammo in crew inventory'**
  String get smugglingApiInsufficientAmmoCrew;

  /// No description provided for @smugglingApiInsufficientAmmo.
  ///
  /// In en, this message translates to:
  /// **'Not enough ammo in inventory'**
  String get smugglingApiInsufficientAmmo;

  /// No description provided for @smugglingApiInvalidCrewVehicle.
  ///
  /// In en, this message translates to:
  /// **'Invalid crew vehicle'**
  String get smugglingApiInvalidCrewVehicle;

  /// No description provided for @smugglingApiCrewBoatUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Crew boat not available for smuggling'**
  String get smugglingApiCrewBoatUnavailable;

  /// No description provided for @smugglingApiCrewMotorcycleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Crew motorcycle not available for smuggling'**
  String get smugglingApiCrewMotorcycleUnavailable;

  /// No description provided for @smugglingApiCrewCarUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Crew car not available for smuggling'**
  String get smugglingApiCrewCarUnavailable;

  /// No description provided for @smugglingApiInvalidVehicleKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid vehicle'**
  String get smugglingApiInvalidVehicleKey;

  /// No description provided for @smugglingApiVehicleUnavailableForSmuggling.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not available for smuggling'**
  String get smugglingApiVehicleUnavailableForSmuggling;

  /// No description provided for @smugglingApiInsufficientStockForShipment.
  ///
  /// In en, this message translates to:
  /// **'Insufficient stock for this shipment'**
  String get smugglingApiInsufficientStockForShipment;

  /// No description provided for @smugglingApiDepotNoShipmentsReady.
  ///
  /// In en, this message translates to:
  /// **'No shipments ready at this country depot'**
  String get smugglingApiDepotNoShipmentsReady;

  /// No description provided for @smugglingApiQuantityTooHighForChannel.
  ///
  /// In en, this message translates to:
  /// **'Quantity too high for {channel}. Max: {max}'**
  String smugglingApiQuantityTooHighForChannel(String channel, int max);

  /// No description provided for @smugglingApiShipmentStarted.
  ///
  /// In en, this message translates to:
  /// **'Smuggling shipment ({channel}) to {destination} started'**
  String smugglingApiShipmentStarted(String channel, String destination);

  /// No description provided for @smugglingApiClaimedPersonal.
  ///
  /// In en, this message translates to:
  /// **'Picked up {count} shipment(s) in {country}'**
  String smugglingApiClaimedPersonal(int count, String country);

  /// No description provided for @smugglingApiClaimedCrew.
  ///
  /// In en, this message translates to:
  /// **'Picked up {count} crew shipment(s) in {country}'**
  String smugglingApiClaimedCrew(int count, String country);

  /// No description provided for @smugglingClientShipmentFailed.
  ///
  /// In en, this message translates to:
  /// **'Shipment failed'**
  String get smugglingClientShipmentFailed;

  /// No description provided for @smugglingClientQuoteFailed.
  ///
  /// In en, this message translates to:
  /// **'Quote failed'**
  String get smugglingClientQuoteFailed;

  /// No description provided for @smugglingClientClaimFailed.
  ///
  /// In en, this message translates to:
  /// **'Claim failed'**
  String get smugglingClientClaimFailed;

  /// No description provided for @smugglingClientErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String smugglingClientErrorPrefix(String detail);

  /// No description provided for @cryptoMarketNoData.
  ///
  /// In en, this message translates to:
  /// **'No crypto market data available'**
  String get cryptoMarketNoData;

  /// No description provided for @cryptoMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Crypto market'**
  String get cryptoMarketTitle;

  /// No description provided for @cryptoMarketOpenOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'Open orders: {count}'**
  String cryptoMarketOpenOrdersCount(int count);

  /// No description provided for @cryptoRegimeBull.
  ///
  /// In en, this message translates to:
  /// **'Bull market'**
  String get cryptoRegimeBull;

  /// No description provided for @cryptoRegimeBear.
  ///
  /// In en, this message translates to:
  /// **'Bear market'**
  String get cryptoRegimeBear;

  /// No description provided for @cryptoRegimeSideways.
  ///
  /// In en, this message translates to:
  /// **'Sideways'**
  String get cryptoRegimeSideways;

  /// No description provided for @cryptoOwnedAmountLine.
  ///
  /// In en, this message translates to:
  /// **'Owned: {amount}'**
  String cryptoOwnedAmountLine(String amount);

  /// No description provided for @cryptoPortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get cryptoPortfolioTitle;

  /// No description provided for @cryptoLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get cryptoLabelValue;

  /// No description provided for @cryptoLabelCostBasis.
  ///
  /// In en, this message translates to:
  /// **'Cost basis'**
  String get cryptoLabelCostBasis;

  /// No description provided for @cryptoLabelUnrealized.
  ///
  /// In en, this message translates to:
  /// **'Unrealized'**
  String get cryptoLabelUnrealized;

  /// No description provided for @cryptoLabelRealized.
  ///
  /// In en, this message translates to:
  /// **'Realized'**
  String get cryptoLabelRealized;

  /// No description provided for @cryptoNoPositionsYet.
  ///
  /// In en, this message translates to:
  /// **'No positions yet'**
  String get cryptoNoPositionsYet;

  /// No description provided for @cryptoChartDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Chart data unavailable'**
  String get cryptoChartDataUnavailable;

  /// No description provided for @cryptoUnknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get cryptoUnknownTime;

  /// No description provided for @cryptoOrderTypeStopLoss.
  ///
  /// In en, this message translates to:
  /// **'Stop-loss'**
  String get cryptoOrderTypeStopLoss;

  /// No description provided for @cryptoOrderTypeTakeProfit.
  ///
  /// In en, this message translates to:
  /// **'Take-profit'**
  String get cryptoOrderTypeTakeProfit;

  /// No description provided for @cryptoOrderTypeLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get cryptoOrderTypeLimit;

  /// No description provided for @cryptoSideBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get cryptoSideBuy;

  /// No description provided for @cryptoSideSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get cryptoSideSell;

  /// No description provided for @cryptoInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get cryptoInvalidQuantity;

  /// No description provided for @cryptoPurchaseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed'**
  String get cryptoPurchaseCompleted;

  /// No description provided for @cryptoSaleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sale completed'**
  String get cryptoSaleCompleted;

  /// No description provided for @cryptoActionProcessed.
  ///
  /// In en, this message translates to:
  /// **'Action processed'**
  String get cryptoActionProcessed;

  /// No description provided for @cryptoInvalidTargetPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid target price'**
  String get cryptoInvalidTargetPrice;

  /// No description provided for @cryptoCannotSellMoreThanOwned.
  ///
  /// In en, this message translates to:
  /// **'You cannot sell more than you own.'**
  String get cryptoCannotSellMoreThanOwned;

  /// No description provided for @cryptoOpenOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Open order placed'**
  String get cryptoOpenOrderPlaced;

  /// No description provided for @cryptoOpenOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get cryptoOpenOrderFailed;

  /// No description provided for @cryptoOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get cryptoOrderCancelled;

  /// No description provided for @cryptoCancelOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order'**
  String get cryptoCancelOrderFailed;

  /// No description provided for @cryptoDirectTradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct trade'**
  String get cryptoDirectTradeTitle;

  /// No description provided for @cryptoLabelQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cryptoLabelQuantity;

  /// No description provided for @cryptoDirectTradeHelperWithAvgAndAll.
  ///
  /// In en, this message translates to:
  /// **'Current price: €{currentPrice} • Avg buy: €{avgBuy}\nUse ALL to sell your full position instantly.'**
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  );

  /// No description provided for @cryptoDirectTradeHelperWithAvgOnly.
  ///
  /// In en, this message translates to:
  /// **'Current price: €{currentPrice} • Avg buy: €{avgBuy}'**
  String cryptoDirectTradeHelperWithAvgOnly(String currentPrice, String avgBuy);

  /// No description provided for @cryptoDirectTradeHelperPriceAndAll.
  ///
  /// In en, this message translates to:
  /// **'Current price: €{currentPrice}\nUse ALL to sell your full position instantly.'**
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice);

  /// No description provided for @cryptoDirectTradeHelperPriceOnly.
  ///
  /// In en, this message translates to:
  /// **'Current price: €{currentPrice}'**
  String cryptoDirectTradeHelperPriceOnly(String currentPrice);

  /// No description provided for @cryptoYourHistoryForSymbol.
  ///
  /// In en, this message translates to:
  /// **'Your history for {symbol}'**
  String cryptoYourHistoryForSymbol(String symbol);

  /// No description provided for @cryptoLabelAvgBuy.
  ///
  /// In en, this message translates to:
  /// **'Avg buy'**
  String get cryptoLabelAvgBuy;

  /// No description provided for @cryptoLabelLastBuy.
  ///
  /// In en, this message translates to:
  /// **'Last buy'**
  String get cryptoLabelLastBuy;

  /// No description provided for @cryptoLabelBuyVolume.
  ///
  /// In en, this message translates to:
  /// **'Buy volume'**
  String get cryptoLabelBuyVolume;

  /// No description provided for @cryptoLabelSellVolume.
  ///
  /// In en, this message translates to:
  /// **'Sell volume'**
  String get cryptoLabelSellVolume;

  /// No description provided for @cryptoLastBuyAt.
  ///
  /// In en, this message translates to:
  /// **'Last buy at {when}'**
  String cryptoLastBuyAt(String when);

  /// No description provided for @cryptoNoTradesForCoinYet.
  ///
  /// In en, this message translates to:
  /// **'No trades for this coin yet.'**
  String get cryptoNoTradesForCoinYet;

  /// No description provided for @cryptoOpenOrdersForSymbol.
  ///
  /// In en, this message translates to:
  /// **'Open orders for {symbol}'**
  String cryptoOpenOrdersForSymbol(String symbol);

  /// No description provided for @cryptoOpenOrdersSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Open orders use their own quantity below. Fill in both quantity and target price in this section.'**
  String get cryptoOpenOrdersSectionHint;

  /// No description provided for @cryptoLabelOrderType.
  ///
  /// In en, this message translates to:
  /// **'Order type'**
  String get cryptoLabelOrderType;

  /// No description provided for @cryptoLabelSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get cryptoLabelSide;

  /// No description provided for @cryptoLabelOrderQuantity.
  ///
  /// In en, this message translates to:
  /// **'Order quantity'**
  String get cryptoLabelOrderQuantity;

  /// No description provided for @cryptoOrderQtyHelperOwned.
  ///
  /// In en, this message translates to:
  /// **'This order sells from your current position. Owned: {quantity}'**
  String cryptoOrderQtyHelperOwned(String quantity);

  /// No description provided for @cryptoOrderQtyHelperStandalone.
  ///
  /// In en, this message translates to:
  /// **'This quantity is separate from the direct trade above.'**
  String get cryptoOrderQtyHelperStandalone;

  /// No description provided for @cryptoLabelTargetPrice.
  ///
  /// In en, this message translates to:
  /// **'Target price'**
  String get cryptoLabelTargetPrice;

  /// No description provided for @cryptoTargetPriceHelperLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit buy below price, limit sell above price'**
  String get cryptoTargetPriceHelperLimit;

  /// No description provided for @cryptoTargetPriceHelperStopLoss.
  ///
  /// In en, this message translates to:
  /// **'Executes when price falls to this level'**
  String get cryptoTargetPriceHelperStopLoss;

  /// No description provided for @cryptoTargetPriceHelperTakeProfit.
  ///
  /// In en, this message translates to:
  /// **'Executes when price rises to this level'**
  String get cryptoTargetPriceHelperTakeProfit;

  /// No description provided for @cryptoPlaceOpenOrder.
  ///
  /// In en, this message translates to:
  /// **'Place open order'**
  String get cryptoPlaceOpenOrder;

  /// No description provided for @cryptoNoOpenOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'You do not have any open orders for this coin yet.'**
  String get cryptoNoOpenOrdersYet;

  /// No description provided for @cryptoLabelCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cryptoLabelCancel;

  /// No description provided for @cryptoDetailsTitleWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Crypto details • {symbol}'**
  String cryptoDetailsTitleWithSymbol(String symbol);

  /// No description provided for @cryptoLabelCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get cryptoLabelCoin;

  /// No description provided for @cryptoLabelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get cryptoLabelPrice;

  /// No description provided for @cryptoLabelOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get cryptoLabelOwned;

  /// No description provided for @cryptoLabelOpenOrders.
  ///
  /// In en, this message translates to:
  /// **'Open orders'**
  String get cryptoLabelOpenOrders;

  /// No description provided for @cryptoNotEnoughHistory.
  ///
  /// In en, this message translates to:
  /// **'Not enough history yet'**
  String get cryptoNotEnoughHistory;

  /// No description provided for @cryptoChartPointsWord.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get cryptoChartPointsWord;

  /// No description provided for @cryptoChartHourAbbrev.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get cryptoChartHourAbbrev;

  /// No description provided for @cryptoChartDataCaptionFullHistory.
  ///
  /// In en, this message translates to:
  /// **'{count} {points} • full history'**
  String cryptoChartDataCaptionFullHistory(int count, String points);

  /// No description provided for @cryptoChartDataCaptionHours.
  ///
  /// In en, this message translates to:
  /// **'{count} {points} • {hours}'**
  String cryptoChartDataCaptionHours(int count, String points, String hours);

  /// No description provided for @cryptoChartRange1h.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get cryptoChartRange1h;

  /// No description provided for @cryptoChartRange4h.
  ///
  /// In en, this message translates to:
  /// **'4h'**
  String get cryptoChartRange4h;

  /// No description provided for @cryptoChartRange8h.
  ///
  /// In en, this message translates to:
  /// **'8h'**
  String get cryptoChartRange8h;

  /// No description provided for @cryptoChartRange24h.
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get cryptoChartRange24h;

  /// No description provided for @cryptoChartRange7d.
  ///
  /// In en, this message translates to:
  /// **'7d'**
  String get cryptoChartRange7d;

  /// No description provided for @cryptoChartRange30d.
  ///
  /// In en, this message translates to:
  /// **'30d'**
  String get cryptoChartRange30d;

  /// No description provided for @cryptoChartRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get cryptoChartRangeAll;

  /// No description provided for @cryptoChartLive1h.
  ///
  /// In en, this message translates to:
  /// **'Live • last 1h'**
  String get cryptoChartLive1h;

  /// No description provided for @cryptoChartLive4h.
  ///
  /// In en, this message translates to:
  /// **'Live • last 4h'**
  String get cryptoChartLive4h;

  /// No description provided for @cryptoChartLive8h.
  ///
  /// In en, this message translates to:
  /// **'Live • last 8h'**
  String get cryptoChartLive8h;

  /// No description provided for @cryptoChartLive24h.
  ///
  /// In en, this message translates to:
  /// **'Live • last 24h'**
  String get cryptoChartLive24h;

  /// No description provided for @cryptoChartLive7d.
  ///
  /// In en, this message translates to:
  /// **'Live • last 7 days'**
  String get cryptoChartLive7d;

  /// No description provided for @cryptoChartLive30d.
  ///
  /// In en, this message translates to:
  /// **'Live • last 30 days'**
  String get cryptoChartLive30d;

  /// No description provided for @cryptoChartLiveAll.
  ///
  /// In en, this message translates to:
  /// **'Live • full history'**
  String get cryptoChartLiveAll;

  /// No description provided for @cryptoLabelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cryptoLabelTotal;

  /// No description provided for @cryptoApiCouldNotLoadMarket.
  ///
  /// In en, this message translates to:
  /// **'Could not load crypto market.'**
  String get cryptoApiCouldNotLoadMarket;

  /// No description provided for @cryptoApiAssetNotFound.
  ///
  /// In en, this message translates to:
  /// **'Crypto not found.'**
  String get cryptoApiAssetNotFound;

  /// No description provided for @cryptoApiCouldNotLoadChart.
  ///
  /// In en, this message translates to:
  /// **'Could not load crypto chart data.'**
  String get cryptoApiCouldNotLoadChart;

  /// No description provided for @cryptoApiNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in.'**
  String get cryptoApiNotLoggedIn;

  /// No description provided for @cryptoApiCouldNotLoadPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Could not load portfolio.'**
  String get cryptoApiCouldNotLoadPortfolio;

  /// No description provided for @cryptoApiCouldNotLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'Could not load crypto transaction history.'**
  String get cryptoApiCouldNotLoadTransactions;

  /// No description provided for @cryptoApiInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity.'**
  String get cryptoApiInvalidQuantity;

  /// No description provided for @cryptoApiInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Not enough money.'**
  String get cryptoApiInsufficientFunds;

  /// No description provided for @cryptoApiPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed.'**
  String get cryptoApiPurchaseFailed;

  /// No description provided for @cryptoApiNotEnoughCrypto.
  ///
  /// In en, this message translates to:
  /// **'Not enough crypto held.'**
  String get cryptoApiNotEnoughCrypto;

  /// No description provided for @cryptoApiSellFailed.
  ///
  /// In en, this message translates to:
  /// **'Sale failed.'**
  String get cryptoApiSellFailed;

  /// No description provided for @cryptoApiCouldNotLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Could not load crypto orders.'**
  String get cryptoApiCouldNotLoadOrders;

  /// No description provided for @cryptoApiInvalidTargetPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid target price.'**
  String get cryptoApiInvalidTargetPrice;

  /// No description provided for @cryptoApiInvalidOrderType.
  ///
  /// In en, this message translates to:
  /// **'Invalid order type.'**
  String get cryptoApiInvalidOrderType;

  /// No description provided for @cryptoApiInvalidOrderSide.
  ///
  /// In en, this message translates to:
  /// **'Invalid order side.'**
  String get cryptoApiInvalidOrderSide;

  /// No description provided for @cryptoApiInvalidOrderCombination.
  ///
  /// In en, this message translates to:
  /// **'This order type and side combination is not allowed.'**
  String get cryptoApiInvalidOrderCombination;

  /// No description provided for @cryptoApiPlaceOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order.'**
  String get cryptoApiPlaceOrderFailed;

  /// No description provided for @cryptoApiPlayerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Player not found.'**
  String get cryptoApiPlayerNotFound;

  /// No description provided for @cryptoApiInvalidOrderId.
  ///
  /// In en, this message translates to:
  /// **'Invalid order id.'**
  String get cryptoApiInvalidOrderId;

  /// No description provided for @cryptoApiOrderNotFoundOrClosed.
  ///
  /// In en, this message translates to:
  /// **'Order not found or no longer active.'**
  String get cryptoApiOrderNotFoundOrClosed;

  /// No description provided for @cryptoApiCancelOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order.'**
  String get cryptoApiCancelOrderFailed;

  /// No description provided for @cryptoApiBuySuccess.
  ///
  /// In en, this message translates to:
  /// **'You bought {quantity} {symbol} for €{total}.'**
  String cryptoApiBuySuccess(String quantity, String symbol, String total);

  /// No description provided for @cryptoApiSellSuccess.
  ///
  /// In en, this message translates to:
  /// **'You sold {quantity} {symbol} for €{total}.'**
  String cryptoApiSellSuccess(String quantity, String symbol, String total);

  /// No description provided for @cryptoApiOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed: {side} {quantity} {symbol} @ {price}.'**
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  );

  /// No description provided for @cryptoApiOrderCancelledDetail.
  ///
  /// In en, this message translates to:
  /// **'Order {orderId} cancelled.'**
  String cryptoApiOrderCancelledDetail(int orderId);

  /// No description provided for @cryptoClientErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String cryptoClientErrorPrefix(String detail);

  /// No description provided for @drugsClientErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error while loading: {error}'**
  String drugsClientErrorLoading(String error);

  /// No description provided for @drugsFacilitiesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error while loading facilities: {error}'**
  String drugsFacilitiesErrorLoading(String error);

  /// No description provided for @drugsInvTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug Inventory'**
  String get drugsInvTitle;

  /// No description provided for @drugsInvKpiGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'inventory'**
  String get drugsInvKpiGramsLabel;

  /// No description provided for @drugsCutQualityDCannotCut.
  ///
  /// In en, this message translates to:
  /// **'Quality D cannot be cut further.'**
  String get drugsCutQualityDCannotCut;

  /// No description provided for @drugsCutFailed.
  ///
  /// In en, this message translates to:
  /// **'Cutting failed'**
  String get drugsCutFailed;

  /// No description provided for @drugsSellFailed.
  ///
  /// In en, this message translates to:
  /// **'Sale failed'**
  String get drugsSellFailed;

  /// No description provided for @drugsSellDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell {name}'**
  String drugsSellDialogTitle(String name);

  /// No description provided for @drugsInvAvailableQty.
  ///
  /// In en, this message translates to:
  /// **'Available: {qty} g'**
  String drugsInvAvailableQty(String qty);

  /// No description provided for @drugsQualityWithGrade.
  ///
  /// In en, this message translates to:
  /// **'Quality: {grade}'**
  String drugsQualityWithGrade(String grade);

  /// No description provided for @drugsCurrentPricePerGram.
  ///
  /// In en, this message translates to:
  /// **'Current price: €{price} per gram'**
  String drugsCurrentPricePerGram(String price);

  /// No description provided for @drugsPricesByCountry.
  ///
  /// In en, this message translates to:
  /// **'Prices by country:'**
  String get drugsPricesByCountry;

  /// No description provided for @drugsQuantityGramsField.
  ///
  /// In en, this message translates to:
  /// **'Quantity (grams)'**
  String get drugsQuantityGramsField;

  /// No description provided for @drugsInvTotalLine.
  ///
  /// In en, this message translates to:
  /// **'Total: €{amount}'**
  String drugsInvTotalLine(String amount);

  /// No description provided for @drugsInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get drugsInvalidQuantity;

  /// No description provided for @drugsSellAction.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get drugsSellAction;

  /// No description provided for @drugsInvEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No drugs in inventory'**
  String get drugsInvEmptyTitle;

  /// No description provided for @drugsInvEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start production to create drugs'**
  String get drugsInvEmptySubtitle;

  /// No description provided for @drugsInvSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Inventory & distribution'**
  String get drugsInvSectionHeader;

  /// No description provided for @drugsInvSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Sell drugs by quality and use price differences between countries.'**
  String get drugsInvSectionBody;

  /// No description provided for @drugsInvCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location: {place}'**
  String drugsInvCurrentLocation(String place);

  /// No description provided for @drugsInvStockLine.
  ///
  /// In en, this message translates to:
  /// **'Inventory: {qty} g'**
  String drugsInvStockLine(String qty);

  /// No description provided for @drugsInvCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Current value: €{amount}'**
  String drugsInvCurrentValue(String amount);

  /// No description provided for @drugsInvMarketLine.
  ///
  /// In en, this message translates to:
  /// **'Market: {emoji} {pct}%'**
  String drugsInvMarketLine(String emoji, String pct);

  /// No description provided for @drugsCutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cut drugs'**
  String get drugsCutDialogTitle;

  /// No description provided for @drugsCutQualityBanner.
  ///
  /// In en, this message translates to:
  /// **'Quality {fromQ} → {toQ}: +{pct}% more units'**
  String drugsCutQualityBanner(String fromQ, String toQ, String pct);

  /// No description provided for @drugsCutResultLine.
  ///
  /// In en, this message translates to:
  /// **'Result: {qty} g {qFrom} → {result} g {qTo}'**
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  );

  /// No description provided for @drugsCutAction.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get drugsCutAction;

  /// No description provided for @drugsSlotsLabel.
  ///
  /// In en, this message translates to:
  /// **'slots'**
  String get drugsSlotsLabel;

  /// No description provided for @drugsFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug Facilities'**
  String get drugsFacilitiesTitle;

  /// No description provided for @drugsFacilitiesHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your drug facilities'**
  String get drugsFacilitiesHeroTitle;

  /// No description provided for @drugsFacilitiesHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Facilities such as greenhouse, mushroom farm, drug lab, crack kitchen and darkweb storefront determine which drugs you can produce, how many slots you have and how strong your quality, yield and speed are.'**
  String get drugsFacilitiesHeroBody;

  /// No description provided for @drugsFacCurrentProductions.
  ///
  /// In en, this message translates to:
  /// **'Current productions'**
  String get drugsFacCurrentProductions;

  /// No description provided for @drugsFacUnknownFacility.
  ///
  /// In en, this message translates to:
  /// **'Unknown facility'**
  String get drugsFacUnknownFacility;

  /// No description provided for @drugsFacUnknownMessage.
  ///
  /// In en, this message translates to:
  /// **'Unknown message'**
  String get drugsFacUnknownMessage;

  /// No description provided for @drugsFacUpgradeLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Drug upgrade locked'**
  String get drugsFacUpgradeLockedTitle;

  /// No description provided for @drugsFacUpgradeLockedBody.
  ///
  /// In en, this message translates to:
  /// **'You first need the right Narcotics education levels and certifications.'**
  String get drugsFacUpgradeLockedBody;

  /// No description provided for @drugsFacEquipLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Equipment upgrade locked'**
  String get drugsFacEquipLockedTitle;

  /// No description provided for @drugsFacEquipLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Train your Narcotics track first to unlock the next upgrade level.'**
  String get drugsFacEquipLockedBody;

  /// No description provided for @drugsFacBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get drugsFacBuy;

  /// No description provided for @drugsFacOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get drugsFacOwned;

  /// No description provided for @drugsFacPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get drugsFacPrice;

  /// No description provided for @drugsFacRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get drugsFacRank;

  /// No description provided for @drugsFacDrugTypes.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get drugsFacDrugTypes;

  /// No description provided for @drugsFacSlots.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get drugsFacSlots;

  /// No description provided for @drugsFacQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get drugsFacQuality;

  /// No description provided for @drugsFacYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get drugsFacYield;

  /// No description provided for @drugsFacSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get drugsFacSpeed;

  /// No description provided for @drugsFacMaxSlots.
  ///
  /// In en, this message translates to:
  /// **'Max slots'**
  String get drugsFacMaxSlots;

  /// No description provided for @drugsFacUpgradeSlots.
  ///
  /// In en, this message translates to:
  /// **'Upgrade slots (€{cost})'**
  String drugsFacUpgradeSlots(String cost);

  /// No description provided for @drugsFacEquipmentUpgrades.
  ///
  /// In en, this message translates to:
  /// **'Equipment upgrades'**
  String get drugsFacEquipmentUpgrades;

  /// No description provided for @drugsFacMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get drugsFacMax;

  /// No description provided for @drugsFacLvlPrice.
  ///
  /// In en, this message translates to:
  /// **'Lvl {level} (€{price})'**
  String drugsFacLvlPrice(String level, String price);

  /// No description provided for @drugsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug Environment'**
  String get drugsHubTitle;

  /// No description provided for @drugsSubviewProduction.
  ///
  /// In en, this message translates to:
  /// **'Drug Production'**
  String get drugsSubviewProduction;

  /// No description provided for @drugsSubviewFacilities.
  ///
  /// In en, this message translates to:
  /// **'Drug Facilities'**
  String get drugsSubviewFacilities;

  /// No description provided for @drugsSubviewInventory.
  ///
  /// In en, this message translates to:
  /// **'Drug Inventory'**
  String get drugsSubviewInventory;

  /// No description provided for @drugsTagUndergroundOps.
  ///
  /// In en, this message translates to:
  /// **'Underground Operations'**
  String get drugsTagUndergroundOps;

  /// No description provided for @drugsTagMobileOptimized.
  ///
  /// In en, this message translates to:
  /// **'Mobile Optimized'**
  String get drugsTagMobileOptimized;

  /// No description provided for @drugsTagQualityDriven.
  ///
  /// In en, this message translates to:
  /// **'Quality Driven'**
  String get drugsTagQualityDriven;

  /// No description provided for @drugsEmpireTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug Empire'**
  String get drugsEmpireTitle;

  /// No description provided for @drugsHubIntro.
  ///
  /// In en, this message translates to:
  /// **'Manage production, facilities and inventory here. Buy materials on the Black Market while the rest runs in your own drug environment.'**
  String get drugsHubIntro;

  /// No description provided for @drugsStatMaterialFlow.
  ///
  /// In en, this message translates to:
  /// **'Material flow'**
  String get drugsStatMaterialFlow;

  /// No description provided for @drugsStatBlackMarket.
  ///
  /// In en, this message translates to:
  /// **'Black Market'**
  String get drugsStatBlackMarket;

  /// No description provided for @drugsStatProductionChain.
  ///
  /// In en, this message translates to:
  /// **'Production chain'**
  String get drugsStatProductionChain;

  /// No description provided for @drugsStatProductionChainValue.
  ///
  /// In en, this message translates to:
  /// **'Greenhouse + Lab + Kitchen + Darkweb'**
  String get drugsStatProductionChainValue;

  /// No description provided for @drugsStatSalesModel.
  ///
  /// In en, this message translates to:
  /// **'Sales model'**
  String get drugsStatSalesModel;

  /// No description provided for @drugsStatPerQuality.
  ///
  /// In en, this message translates to:
  /// **'Per quality'**
  String get drugsStatPerQuality;

  /// No description provided for @drugsMetricActiveBatches.
  ///
  /// In en, this message translates to:
  /// **'Active batches'**
  String get drugsMetricActiveBatches;

  /// No description provided for @drugsMetricSlotUsage.
  ///
  /// In en, this message translates to:
  /// **'Slot usage'**
  String get drugsMetricSlotUsage;

  /// No description provided for @drugsMetricInventoryValue.
  ///
  /// In en, this message translates to:
  /// **'Inventory value'**
  String get drugsMetricInventoryValue;

  /// No description provided for @drugsMetricInventoryGrams.
  ///
  /// In en, this message translates to:
  /// **'Inventory grams'**
  String get drugsMetricInventoryGrams;

  /// No description provided for @drugsMetricEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get drugsMetricEfficiency;

  /// No description provided for @drugsMetricPoliceHeat.
  ///
  /// In en, this message translates to:
  /// **'Police Heat'**
  String get drugsMetricPoliceHeat;

  /// No description provided for @drugsSectionOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get drugsSectionOperations;

  /// No description provided for @drugsSectionOperationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a branch of your drug empire'**
  String get drugsSectionOperationsSubtitle;

  /// No description provided for @drugsCardFacilitiesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get drugsCardFacilitiesEyebrow;

  /// No description provided for @drugsCardFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get drugsCardFacilitiesTitle;

  /// No description provided for @drugsCardFacilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'Buy and upgrade greenhouse, drug lab, crack kitchen and darkweb storefront for more slots, speed and quality.'**
  String get drugsCardFacilitiesBody;

  /// No description provided for @drugsCardProductionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Pipeline'**
  String get drugsCardProductionEyebrow;

  /// No description provided for @drugsCardProductionTitle.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get drugsCardProductionTitle;

  /// No description provided for @drugsCardProductionBody.
  ///
  /// In en, this message translates to:
  /// **'Start batches, track timers and collect output with quality rolls.'**
  String get drugsCardProductionBody;

  /// No description provided for @drugsCardInventoryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get drugsCardInventoryEyebrow;

  /// No description provided for @drugsCardInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get drugsCardInventoryTitle;

  /// No description provided for @drugsCardInventoryBody.
  ///
  /// In en, this message translates to:
  /// **'View stacks by quality and sell at the best market value.'**
  String get drugsCardInventoryBody;

  /// No description provided for @drugsQualityDistribution.
  ///
  /// In en, this message translates to:
  /// **'Quality distribution'**
  String get drugsQualityDistribution;

  /// No description provided for @drugsQualityGradeSuperior.
  ///
  /// In en, this message translates to:
  /// **'Superior'**
  String get drugsQualityGradeSuperior;

  /// No description provided for @drugsQualityGradeHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get drugsQualityGradeHigh;

  /// No description provided for @drugsQualityGradeStandardPlus.
  ///
  /// In en, this message translates to:
  /// **'Standard+'**
  String get drugsQualityGradeStandardPlus;

  /// No description provided for @drugsQualityGradeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get drugsQualityGradeStandard;

  /// No description provided for @drugsQualityGradeLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get drugsQualityGradeLow;

  /// No description provided for @drugsHeatLevelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get drugsHeatLevelLow;

  /// No description provided for @drugsHeatLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get drugsHeatLevelMedium;

  /// No description provided for @drugsHeatLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get drugsHeatLevelHigh;

  /// No description provided for @drugsHeatLevelCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get drugsHeatLevelCritical;

  /// No description provided for @drugsProdTitle.
  ///
  /// In en, this message translates to:
  /// **'Drug Production'**
  String get drugsProdTitle;

  /// No description provided for @drugsProdLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Production line'**
  String get drugsProdLineTitle;

  /// No description provided for @drugsProdLineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start batches, monitor slot capacity and tune quality via greenhouse and lab upgrades.'**
  String get drugsProdLineSubtitle;

  /// No description provided for @drugsProdActiveProductions.
  ///
  /// In en, this message translates to:
  /// **'Active Productions'**
  String get drugsProdActiveProductions;

  /// No description provided for @drugsProdIncidentLegend.
  ///
  /// In en, this message translates to:
  /// **'Incident legend'**
  String get drugsProdIncidentLegend;

  /// No description provided for @drugsProdHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get drugsProdHide;

  /// No description provided for @drugsProdShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get drugsProdShow;

  /// No description provided for @drugsProdLegendDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get drugsProdLegendDelay;

  /// No description provided for @drugsProdLegendContamination.
  ///
  /// In en, this message translates to:
  /// **'Contamination'**
  String get drugsProdLegendContamination;

  /// No description provided for @drugsProdLegendYieldLoss.
  ///
  /// In en, this message translates to:
  /// **'Yield loss'**
  String get drugsProdLegendYieldLoss;

  /// No description provided for @drugsProdLegendInstability.
  ///
  /// In en, this message translates to:
  /// **'Instability'**
  String get drugsProdLegendInstability;

  /// No description provided for @drugsProdLegendCombined.
  ///
  /// In en, this message translates to:
  /// **'Combined issue'**
  String get drugsProdLegendCombined;

  /// No description provided for @drugsProdCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get drugsProdCollect;

  /// No description provided for @drugsProdAvailableDrugs.
  ///
  /// In en, this message translates to:
  /// **'Available Drugs'**
  String get drugsProdAvailableDrugs;

  /// No description provided for @drugsProdNoDrugs.
  ///
  /// In en, this message translates to:
  /// **'No drugs available'**
  String get drugsProdNoDrugs;

  /// No description provided for @drugsProdAutoCollectOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-collect on (VIP)'**
  String get drugsProdAutoCollectOn;

  /// No description provided for @drugsProdAutoCollectOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-collect off (VIP)'**
  String get drugsProdAutoCollectOff;

  /// No description provided for @drugsProdVipMaterialsOk.
  ///
  /// In en, this message translates to:
  /// **'All materials available'**
  String get drugsProdVipMaterialsOk;

  /// No description provided for @drugsProdVipBuyMissing.
  ///
  /// In en, this message translates to:
  /// **'VIP: buy missing materials in one click'**
  String get drugsProdVipBuyMissing;

  /// No description provided for @drugsProdTimeYieldLine.
  ///
  /// In en, this message translates to:
  /// **'Time: {time} | Yield: {yield}g'**
  String drugsProdTimeYieldLine(String time, String yield);

  /// No description provided for @drugsProdSlotsUsedLine.
  ///
  /// In en, this message translates to:
  /// **'{facility}: {used}/{total} slots used'**
  String drugsProdSlotsUsedLine(String facility, String used, String total);

  /// No description provided for @drugsProdFacilityRequired.
  ///
  /// In en, this message translates to:
  /// **'{facility} required'**
  String drugsProdFacilityRequired(String facility);

  /// No description provided for @drugsProdRankRequired.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank} required'**
  String drugsProdRankRequired(String rank);

  /// No description provided for @drugsProdNoFreeSlot.
  ///
  /// In en, this message translates to:
  /// **'No free production slot available'**
  String get drugsProdNoFreeSlot;

  /// No description provided for @drugsProdOpenFacilities.
  ///
  /// In en, this message translates to:
  /// **'Open facilities'**
  String get drugsProdOpenFacilities;

  /// No description provided for @drugsProdStartProduction.
  ///
  /// In en, this message translates to:
  /// **'Start production'**
  String get drugsProdStartProduction;

  /// No description provided for @drugsProdAutoCollectUpdated.
  ///
  /// In en, this message translates to:
  /// **'Auto-collect updated'**
  String get drugsProdAutoCollectUpdated;

  /// No description provided for @drugsProdKpiActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get drugsProdKpiActive;

  /// No description provided for @drugsProdKpiReady.
  ///
  /// In en, this message translates to:
  /// **'ready'**
  String get drugsProdKpiReady;

  /// No description provided for @drugsProdYieldGrams.
  ///
  /// In en, this message translates to:
  /// **'Yield: {qty} grams'**
  String drugsProdYieldGrams(String qty);

  /// No description provided for @drugsTimeMinSuffix.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get drugsTimeMinSuffix;

  /// No description provided for @drugsFmtMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String drugsFmtMinutes(String minutes);

  /// No description provided for @drugsFmtHoursOnly.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr'**
  String drugsFmtHoursOnly(String hours);

  /// No description provided for @drugsFmtHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min'**
  String drugsFmtHoursMinutes(String hours, String minutes);

  /// No description provided for @drugsTimeHourEn.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get drugsTimeHourEn;

  /// No description provided for @drugsProdConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get drugsProdConfirmTitle;

  /// No description provided for @drugsProdConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Start {drugName} production?'**
  String drugsProdConfirmBody(String drugName);

  /// No description provided for @drugsProdTimeLine.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String drugsProdTimeLine(String time);

  /// No description provided for @drugsProdYieldLine.
  ///
  /// In en, this message translates to:
  /// **'Yield: {yield} grams'**
  String drugsProdYieldLine(String yield);

  /// No description provided for @drugsProdRiskNote.
  ///
  /// In en, this message translates to:
  /// **'Production can sometimes suffer setbacks. Better upgrades lower the risk, high drug heat increases it.'**
  String get drugsProdRiskNote;

  /// No description provided for @drugsProdRequiredMaterialsHeader.
  ///
  /// In en, this message translates to:
  /// **'Required materials:'**
  String get drugsProdRequiredMaterialsHeader;

  /// No description provided for @drugsProdStartProductionButton.
  ///
  /// In en, this message translates to:
  /// **'Start Production'**
  String get drugsProdStartProductionButton;

  /// No description provided for @drugsProdFailed.
  ///
  /// In en, this message translates to:
  /// **'Production failed'**
  String get drugsProdFailed;

  /// No description provided for @drugsProdCollectFailed.
  ///
  /// In en, this message translates to:
  /// **'Collect failed'**
  String get drugsProdCollectFailed;

  /// No description provided for @drugsProdNeedRank.
  ///
  /// In en, this message translates to:
  /// **'You need rank {rank}'**
  String drugsProdNeedRank(String rank);

  /// No description provided for @drugsProdMissingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get drugsProdMissingPrefix;

  /// No description provided for @drugsFacilityGreenhouse.
  ///
  /// In en, this message translates to:
  /// **'Greenhouse'**
  String get drugsFacilityGreenhouse;

  /// No description provided for @drugsFacilityCrackKitchen.
  ///
  /// In en, this message translates to:
  /// **'Crack Kitchen'**
  String get drugsFacilityCrackKitchen;

  /// No description provided for @drugsFacilityDarkweb.
  ///
  /// In en, this message translates to:
  /// **'Darkweb Storefront'**
  String get drugsFacilityDarkweb;

  /// No description provided for @drugsFacilityMushroomFarm.
  ///
  /// In en, this message translates to:
  /// **'Mushroom Farm'**
  String get drugsFacilityMushroomFarm;

  /// No description provided for @drugsFacilityDrugLab.
  ///
  /// In en, this message translates to:
  /// **'Drug Lab'**
  String get drugsFacilityDrugLab;

  /// No description provided for @drugsVipQuickBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP quick purchase'**
  String get drugsVipQuickBuyTitle;

  /// No description provided for @drugsVipAlreadyEnough.
  ///
  /// In en, this message translates to:
  /// **'You already have enough materials for {name}'**
  String drugsVipAlreadyEnough(String name);

  /// No description provided for @drugsVipBuyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Buy all missing materials for {name} in one click?'**
  String drugsVipBuyPrompt(String name);

  /// No description provided for @drugsVipTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: €{amount}'**
  String drugsVipTotal(String amount);

  /// No description provided for @drugsPurchaseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed'**
  String get drugsPurchaseCompleted;

  /// No description provided for @drugsPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get drugsPurchaseFailed;

  /// No description provided for @drugsServiceErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get drugsServiceErrorGeneric;

  /// No description provided for @drugsApiFailedBuyMaterial.
  ///
  /// In en, this message translates to:
  /// **'Failed to buy material'**
  String get drugsApiFailedBuyMaterial;

  /// No description provided for @drugsApiFailedStartProduction.
  ///
  /// In en, this message translates to:
  /// **'Failed to start production'**
  String get drugsApiFailedStartProduction;

  /// No description provided for @drugsApiFailedCollect.
  ///
  /// In en, this message translates to:
  /// **'Failed to collect production'**
  String get drugsApiFailedCollect;

  /// No description provided for @drugsApiFailedSell.
  ///
  /// In en, this message translates to:
  /// **'Failed to sell drugs'**
  String get drugsApiFailedSell;

  /// No description provided for @drugsApiFailedCut.
  ///
  /// In en, this message translates to:
  /// **'Failed to cut drugs'**
  String get drugsApiFailedCut;

  /// No description provided for @drugsApiFailedShipment.
  ///
  /// In en, this message translates to:
  /// **'Failed to send shipment'**
  String get drugsApiFailedShipment;

  /// No description provided for @drugsApiFailedClaim.
  ///
  /// In en, this message translates to:
  /// **'Failed to claim depot shipments'**
  String get drugsApiFailedClaim;

  /// No description provided for @helpTopicDashboardCategory.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get helpTopicDashboardCategory;

  /// No description provided for @helpTopicDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get helpTopicDashboardTitle;

  /// No description provided for @helpTopicDashboardSummary.
  ///
  /// In en, this message translates to:
  /// **'Your central overview with all your stats, active cooldowns, live events and shortcuts to every part of the game.'**
  String get helpTopicDashboardSummary;

  /// No description provided for @helpTopicDashboardHow.
  ///
  /// In en, this message translates to:
  /// **'Top bar shows: Cash, Rank, Health (0-100 HP), Wanted Level (0-100) and FBI Heat (0-100).\nEvery 5 minutes an automatic tick fires: hunger drops -2, thirst -3, you heal passively +5 HP (if HP > 0), bank interest is added (0.5%) and wanted level drops slightly when below 10.\nIf hunger or thirst reaches 0 you die and spend 3 hours in ICU. Eat and drink on time!\nQuick Action blocks on the right are shortcuts to Crimes, Car Theft, Boat Theft, Work, Casino, Bank and School.\nCooldown timers per section show how long until your next action is available. The timer adapts to show the most relevant unit: minutes, hours or days.\nThe stats card now uses real live counters for breakouts, murders, hitlist contracts, travels and bullets instead of fixed zero placeholders.\nThe dashboard now also has an expanded economy section with cash, bank, crypto, vehicle value, property value, net worth and a 24-hour cashflow trend.\nThe operations block now shows active production, longest cooldown, vehicle status (active/listed/transit), and next production/event timers.\nWhen player events are live (e.g. weekly competition), the same right-hand panel briefly lists their titles and links to the Events page. You can turn push for round start/end on or off under Settings → Player events (in addition to device permissions and other push categories).\nNotifications & risk now includes unread DMs, support tickets waiting for your reply, events from the last 24 hours, and a compact risk score (wanted + FBI).\nWhen your crew is involved in Crew Wars, the dashboard also shows a Crew Wars summary with status, opponent, crew points, season rank and the remaining time in the current phase.\nThe dashboard now also includes a Vehicle Ops overview per Car/Motorcycle/Boat with live cooldown chips (Hotspot, Crew, Crew match, Chop, Contract and Counter), plus heat/reputation, contract and claim counts, and season points.\nLive events appear when other players perform major actions, when you are attacked, or when global market movements occur.\nMessage badge shows unread system messages and personal messages.\nLeft navigation menu grants access to all game sections grouped by category: Actions, World, Social, Economy, Empire and Assets.'**
  String get helpTopicDashboardHow;

  /// No description provided for @helpTopicDashboardTips.
  ///
  /// In en, this message translates to:
  /// **'Open the dashboard first after every login to see what changed while you were away.\nKeep wanted level below 10 so automatic decay works and arrest chances stay low.\nCheck unread messages before starting risky actions: rewards, order fills and system events all appear in your inbox.'**
  String get helpTopicDashboardTips;

  /// No description provided for @helpTopicCrimesCategory.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get helpTopicCrimesCategory;

  /// No description provided for @helpTopicCrimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Crimes'**
  String get helpTopicCrimesTitle;

  /// No description provided for @helpTopicCrimesSummary.
  ///
  /// In en, this message translates to:
  /// **'Commit illegal actions for cash and XP, but every attempt risks damage, arrest or extra Wanted Level. The late-game Wipe Criminal Record crime removes your full criminal record on success, but it needs heavy tools and carries high federal risk.'**
  String get helpTopicCrimesSummary;

  /// No description provided for @helpTopicCrimesHow.
  ///
  /// In en, this message translates to:
  /// **'Crime cooldowns now scale with potential payout: low-yield crimes stay fast, while high-yield crimes get clearly longer cooldowns.\nGuideline by reward tier: up to €500 ≈ 1.5 min, up to €2,000 ≈ 5 min, up to €10,000 ≈ 15 min, up to €30,000 ≈ 30 min, above that ≈ 60 min.\nThere is no hard daily cap on crimes; active players can keep playing as long as they manage cooldowns, risk and resources.\nCrimes with `required weapon` use your selected crime weapon. You can now choose it directly at the top of the Crimes screen or through Inventory.\nCrimes with a vehicle requirement use your selected crime vehicle from Garage or Marina. Only a vehicle that is actually in your current country and not in transit or listed for sale counts.\nDrug requirements in crimes are shown in grams and follow the same quantities as your drug inventory and storage.\nIf a crime cannot start because of a missing vehicle, the wrong weapon, or missing ammo, the error message should now show the real cause instead of a generic retry.\nEvery crime attempt: you take 5-15 HP damage and Wanted Level rises by 1-4 points depending on success or failure.\nArrest chance scales fast with Wanted Level: Wanted 5 = 25%, Wanted 10 = 50%, Wanted 18+ = maximum 90%.\nOn arrest you go to prison. Sentence = max(wanted level × 10, 5) minutes. Bail = wanted level × €1.000. Even if a crime seems successful at first but you get caught right after, the final outcome still counts as an arrest: required tools are confiscated, the used crime weapon is lost, and vehicles can also be seized.\nSome crimes require a vehicle, tool or minimum rank. Missing these will prevent the crime from starting.\nXP earned raises your rank, unlocking better crimes and higher rewards.\nFBI Heat rises with heavier crimes. Above heat 50 the FBI becomes active with even higher arrest chances.'**
  String get helpTopicCrimesHow;

  /// No description provided for @helpTopicCrimesTips.
  ///
  /// In en, this message translates to:
  /// **'Use fast beginner crimes to build XP while waiting for big cooldowns.\nAlways bail out if your Wanted Level is high — sitting in jail blocks all your loops.\nKeep HP above 30 before starting a crime run: every attempt costs HP and at 0 HP you spend 3 hours in ICU.'**
  String get helpTopicCrimesTips;

  /// No description provided for @helpTopicJobsCategory.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get helpTopicJobsCategory;

  /// No description provided for @helpTopicJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get helpTopicJobsTitle;

  /// No description provided for @helpTopicJobsSummary.
  ///
  /// In en, this message translates to:
  /// **'Earn legal money without Wanted Level risk. Jobs are safer than crimes but peak lower in payout.'**
  String get helpTopicJobsSummary;

  /// No description provided for @helpTopicJobsHow.
  ///
  /// In en, this message translates to:
  /// **'Available jobs scale with rank and education: better jobs pay more, but also have longer cooldowns.\nJob cooldowns scale on max payout: low-tier jobs around 3-5 min, mid-tier around 8-12 min, top-tier around 17-22 min.\nJobs have a high but not perfect success rate; on failure you do not lose money or HP, but you do lose some XP.\nRequirements per job: minimum 10 HP, hunger > 20, thirst > 20, not in jail, not in ICU.\nThere is no hard daily cap on jobs; progression is paced by cooldown, chance and payout instead of a daily lock.\nJob pay varies per job type and rank. Education (School) can unlock higher positions.\nYou also earn XP per job, though less than comparable crimes.\nUse jobs as a reliable cash flow base, especially when your Wanted Level is too high for safe crimes.'**
  String get helpTopicJobsHow;

  /// No description provided for @helpTopicJobsTips.
  ///
  /// In en, this message translates to:
  /// **'Combine jobs and school: education unlocks better jobs with higher payouts.\nWhen Wanted Level is above 8 or you are recovering from ICU, use jobs instead of crimes.\nKeep hunger and thirst from dropping too low: a job with stats below 20 simply will not start.'**
  String get helpTopicJobsTips;

  /// No description provided for @helpTopicTravelCategory.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get helpTopicTravelCategory;

  /// No description provided for @helpTopicTravelTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get helpTopicTravelTitle;

  /// No description provided for @helpTopicTravelSummary.
  ///
  /// In en, this message translates to:
  /// **'Move between countries for better market prices, unique opportunities and access to international systems.'**
  String get helpTopicTravelSummary;

  /// No description provided for @helpTopicTravelHow.
  ///
  /// In en, this message translates to:
  /// **'Available countries: Netherlands (start), Belgium, Germany, France, United Kingdom, Spain, Italy, Switzerland, USA, Mexico, Colombia, Brazil.\nTravel costs: neighboring country €500-€2.000, Europe → Americas €5.000-€10.000, long distance €10.000-€20.000.\nTravel requirements: not in jail, not in ICU, minimum 20 HP, travel funds available.\nDrug quantities in your inventory count as real grams for carry weight and travel checks; 500 means 500g, not 50kg.\nEach country has different market prices (up to 300% price difference), different crime payouts and unique trade items.\nTransport risk: police can seize goods based on Wanted Level (chance = wanted × 2%, max 80%). FBI can seize everything internationally if heat is high.\nCustoms inspection has a 10% base chance. You can bribe (€1.000-€5.000) or get caught losing 50% of goods.\nAfter arrival all actions are immediately available in the new country. Markets and crime speed vary by location.'**
  String get helpTopicTravelHow;

  /// No description provided for @helpTopicTravelTips.
  ///
  /// In en, this message translates to:
  /// **'Always combine travel with trade, drugs or smuggling — empty travel wastes money.\nLower your Wanted Level before departure: high wanted greatly increases confiscation risk en route.\nPlan your return trip in advance so you already know what to bring back on arrival.'**
  String get helpTopicTravelTips;

  /// No description provided for @helpTopicCrewCategory.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get helpTopicCrewCategory;

  /// No description provided for @helpTopicCrewTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get helpTopicCrewTitle;

  /// No description provided for @helpTopicCrewSummary.
  ///
  /// In en, this message translates to:
  /// **'Start a crew or join existing players to pull off heists together, share storage and become stronger as a unit.'**
  String get helpTopicCrewSummary;

  /// No description provided for @helpTopicCrewHow.
  ///
  /// In en, this message translates to:
  /// **'Creating a crew costs €10.000. The Crew HQ determines how many members your crew can hold and scales up to 150 members. The leader can invite, kick and start heists.\nCrew benefits: access to large heists, shared storage, teamwork bonus (+10% success per extra member, max +30%) and group chat.\nNew crews now start with Crew HQ level 1 and all storage buildings at level 1, including cash storage, so the crew bank and shared storage work immediately.\nCrew car storage now also accepts motorcycles, so land vehicles can be managed together from the same shared crew storage.\nWhen a crew member gets arrested, crew members now receive a push notification that the player is locked up and waiting for help.\nThe crew screen is now grouped into Overview, HQ & Upgrades, Storage, Members, War Room, Crew Missions, Crews and Chat so management feels calmer and more professional.\nCrew Missions shows tier templates, an active run card and recent runs. Leaders/co-leaders can start and resolve; reward claiming and cooldown speedup are handled in the same tab.\nThere are extra crew missions with bank-themed operations (night deposit, skim network, armored route, subsidiary vault, reserve vault and clearing house). There is no second casino crew mission alongside Casino Ledger Raid.\nCrew mission rewards come from the server-side mission economy; other players’ bank balances are not debited for these payouts.\nWhen starting a mission you can now assign a role per crew member (Planner, Enforcer, Logistics, Tech) for team bonuses.\nActive and recent mission cards now also show per-player role contributions with score and any payout multiplier.\nCrew members now also receive push/in-app alerts for mission start, mission result, and when a mission cooldown becomes ready again.\nWhile a mission cooldown is active you cannot start a new mission; first wait for the remaining cooldown or speed it up with credits.\nFor cooldown speedup, you first see the exact credit cost and remaining minutes before you confirm.\nCrew Wars have their own War Room tab inside the crew screen. Only leaders can declare a war and at least 3 crew members are required to participate.\nWar types: Kill War, Economy War, Territory War and Total War. Each war moves through preparation, active phase, lockdown and resolution.\nDuring an active war, participants can perform actions like kills, mugs, sabotage, intel, raids, shields, boosts and territory claims. Targeted actions now let you pick directly from a list of opponent crew members instead of typing a player ID by hand.\nSeason points are aggregated into the Crew Wars leaderboard. The War Room also shows standings, recent actions and recent wars for your crew.\nIn Territory War and Total War you now claim real Territory regions from the territory system instead of generic placeholder targets.\nThose war regions now also show their strategic value in the War Room: claim bonus, tick points and tags such as harbor, capital or logistics. That makes it immediately clear which regions are worth more than a simple ownership swap.\nCrew Wars no longer picks Territory targets on value tier alone, but also on strategic tags and adjacent pressure from attacker or defender territory. That makes Territory War and Total War feel more like a real frontline than three random claims.\nHeists: Small Bank (2 players, 40%, €10.000-€30.000, 30 min cooldown), Jewelry Store (3 players, 35%, €20.000-€50.000, 45 min), Casino Heist (4 players, 25%, €50.000-€150.000, 2 hrs), Federal Reserve (5 players, 15%, €100.000-€500.000, 6 hrs, +20 FBI Heat).\nFor a heist all members must be online at start. If someone is absent the heist fails.\nFailed heist: jail time for everyone, Wanted Level +5, no reward.\nHeist reward is split equally among all participating members.\nCrew chat is available for fast coordination.\nCrew HQ progression: the longer and more active the crew, the more shared upgrades and buffs unlock.'**
  String get helpTopicCrewHow;

  /// No description provided for @helpTopicCrewTips.
  ///
  /// In en, this message translates to:
  /// **'New crews can deposit money and use shared storage immediately; after that, focus on upgrades for more capacity instead of a separate starter purchase.\nCheck the War Room first to see whether your crew is still on cooldown before trying to declare a new war.\nCoordinate target calls in crew chat so you do not keep farming the same opponent and trip the anti-farm guard.\nCoordinate heist start times in crew chat so everyone is online and nobody is in jail.\nChoose a crew in the same timezone or activity pattern for better heist success rates.\nUse shared crew storage to separate risky goods from your personal inventory.'**
  String get helpTopicCrewTips;

  /// No description provided for @helpTopicFriendsCategory.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get helpTopicFriendsCategory;

  /// No description provided for @helpTopicFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get helpTopicFriendsTitle;

  /// No description provided for @helpTopicFriendsSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage your friends list for faster coordination, profile browsing and social feedback.'**
  String get helpTopicFriendsSummary;

  /// No description provided for @helpTopicFriendsHow.
  ///
  /// In en, this message translates to:
  /// **'Friends page shows three lists: current friends, sent requests and received requests.\nFrom a friend you can directly send a message, view their profile or start a collaboration.\nYou can see when friends are active in the game, which helps planning heists or trades.\nFriend requests do not expire automatically; keep the list tidy so pending requests do not distract you.\nFriends outside your crew are valuable for jail escapes (a friend can help you break out) and information sharing.\nWhen a friend gets arrested, accepted friends now also receive a push notification that the player is waiting for help in prison.'**
  String get helpTopicFriendsHow;

  /// No description provided for @helpTopicFriendsTips.
  ///
  /// In en, this message translates to:
  /// **'Add friends who share your play style: heist partners, trader networks or crime support.\nA friend who executes a jail escape earns €500-€2.000 reward on success. Arrange this for emergencies.'**
  String get helpTopicFriendsTips;

  /// No description provided for @helpTopicMessagesCategory.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get helpTopicMessagesCategory;

  /// No description provided for @helpTopicMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get helpTopicMessagesTitle;

  /// No description provided for @helpTopicMessagesSummary.
  ///
  /// In en, this message translates to:
  /// **'Your inbox with personal player messages and system messages about rewards, orders and game events.'**
  String get helpTopicMessagesSummary;

  /// No description provided for @helpTopicMessagesHow.
  ///
  /// In en, this message translates to:
  /// **'Messages are split into personal conversations and The Mob State system thread.\nSystem messages are sent automatically for: crypto trades, order fills, leaderboard payouts, heist results, jail escapes and achievement badges.\nYou can send messages to other players as long as their privacy settings allow it.\nUnread messages appear as a badge on the message icon and are visible from the dashboard.\nMessages do not expire and are kept as a historical log of account events.\nUse the inbox log when in doubt about a payout, a missed order fill or an unexpected balance change.'**
  String get helpTopicMessagesHow;

  /// No description provided for @helpTopicMessagesTips.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox after long offline periods: rewards, order fills and events are all recorded there.\nConfigure notification preferences via Settings so you only receive push alerts for truly important events.'**
  String get helpTopicMessagesTips;

  /// No description provided for @helpTopicInventoryCategory.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get helpTopicInventoryCategory;

  /// No description provided for @helpTopicInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get helpTopicInventoryTitle;

  /// No description provided for @helpTopicInventorySummary.
  ///
  /// In en, this message translates to:
  /// **'Manage everything you carry, store and equip: weapons, tools, vehicles, drugs and trade goods.'**
  String get helpTopicInventorySummary;

  /// No description provided for @helpTopicInventoryHow.
  ///
  /// In en, this message translates to:
  /// **'Inventory is split into carried items (on you), stored items (warehouse/crew storage) and active loadouts.\nWeight determines your carrying capacity. Some crimes or travel block if you are overloaded.\nDrugs are stored and shown in inventory and storage as grams; 351 means 351g.\nItem condition degrades with use. Weapons in poor condition perform worse and tools can break.\nAt the top of Inventory you can also choose your default crime weapon. Only carried, usable weapons count for that selection.\nLoadouts let you switch quickly between a crime set (tool + weapon) and a travel set (light, minimal valuables).\nOn arrest police can confiscate items. Do not carry valuables with a high Wanted Level.\nDrugs in inventory increase the chance of FBI intervention during international travel.\nCrew storage is a safe place to keep items outside your personal carrying risk.'**
  String get helpTopicInventoryHow;

  /// No description provided for @helpTopicInventoryTips.
  ///
  /// In en, this message translates to:
  /// **'Keep your carrying load light when traveling or running a high-arrest-risk crime spree.\nUse loadouts so you always have the right gear equipped for each scenario.\nCheck item condition regularly: broken tools silently block crimes without a clear error message.'**
  String get helpTopicInventoryTips;

  /// No description provided for @helpTopicPropertiesCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicPropertiesCategory;

  /// No description provided for @helpTopicPropertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get helpTopicPropertiesTitle;

  /// No description provided for @helpTopicPropertiesSummary.
  ///
  /// In en, this message translates to:
  /// **'Buy properties to expand storage, housing capacity and access to certain systems such as the nightclub.'**
  String get helpTopicPropertiesSummary;

  /// No description provided for @helpTopicPropertiesHow.
  ///
  /// In en, this message translates to:
  /// **'Each property has its own role: storage space, housing capacity or access to a follow-up module such as the nightclub.\nWarehouse upgrades increase your storage capacity for items and other stock.\nHouses and apartments increase housing capacity; VIP players receive extra slots on top of that.\nSome properties are unique or country locked: you must be in the correct country to buy or manage them.\nSelling yields 70% of purchase price. No cooldown on selling, it is instant.\nA purchased nightclub opens the separate nightclub management screen; that module handles management and revenue, not the properties overview.'**
  String get helpTopicPropertiesHow;

  /// No description provided for @helpTopicPropertiesTips.
  ///
  /// In en, this message translates to:
  /// **'Invest in a Warehouse early if you need more storage space for your other systems.\nChoose houses and apartments when you want to build more housing capacity for related gameplay systems.\nDo not sell too quickly: 70% represents a serious markdown from purchase price.'**
  String get helpTopicPropertiesTips;

  /// No description provided for @helpTopicBankCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicBankCategory;

  /// No description provided for @helpTopicBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get helpTopicBankTitle;

  /// No description provided for @helpTopicBankSummary.
  ///
  /// In en, this message translates to:
  /// **'Deposit money to earn interest and keep cash beyond the reach of police confiscations.'**
  String get helpTopicBankSummary;

  /// No description provided for @helpTopicBankHow.
  ///
  /// In en, this message translates to:
  /// **'Interest: 0.5% of your bank balance per tick (every 5 minutes). Example: €10.000 in bank = €50 interest per tick = €600 per hour = €14.400 per day.\nDeposits and withdrawals are both free and instant with no minimum or maximum limit.\nMoney in the bank is protected from police confiscations. Only cash on hand can be lost at arrest.\nTransaction history shows all incoming and outgoing flows with timestamp, amount, transfer counterparty and optional descriptions.\nBank Robbery crime: succeeds at 30% and steals 10-30% of a random other player\'s bank balance. High Wanted Level risk.\nTransferring money to other players is possible. You can optionally add a description, and the recipient will also see it in transactions. Double-check both amount and recipient before confirming.'**
  String get helpTopicBankHow;

  /// No description provided for @helpTopicBankTips.
  ///
  /// In en, this message translates to:
  /// **'Send large amounts to the bank immediately — cash on hand is at risk with every crime attempt.\nGrow interest returns by building large amounts steadily in the bank.\nKeep a small working capital as cash for direct expenses (bail, travel, tools).'**
  String get helpTopicBankTips;

  /// No description provided for @helpTopicCasinoCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicCasinoCategory;

  /// No description provided for @helpTopicCasinoTitle.
  ///
  /// In en, this message translates to:
  /// **'Casino'**
  String get helpTopicCasinoTitle;

  /// No description provided for @helpTopicCasinoSummary.
  ///
  /// In en, this message translates to:
  /// **'Gamble with cash on slots, blackjack, roulette, dice, baccarat and video poker. High variance: you can win or lose large amounts fast.'**
  String get helpTopicCasinoSummary;

  /// No description provided for @helpTopicCasinoHow.
  ///
  /// In en, this message translates to:
  /// **'Available games: Slots (low stake, random payout), Blackjack (strategy matters), Roulette (outside/inside bets with own odds), Dice (high variance), Baccarat (player/banker/tie), Video Poker (5-card hand-rank payouts).\nEach game has a minimum bet. Payout ratios differ per game type (e.g. roulette outside bet ~1.97x, single number 35x).\nCasino uses cash only, not your bank balance. Make sure you have cash before you play.\nThere is no cooldown between rounds: you can play as fast as you want.\nLarge wins above a threshold can trigger an event visible to other players.\nLost bets are permanently gone; there is no insurance or buyback.'**
  String get helpTopicCasinoHow;

  /// No description provided for @helpTopicCasinoTips.
  ///
  /// In en, this message translates to:
  /// **'Always set a session bankroll limit: never more than 10% of total cash per session.\nBlackjack has the best odds for a skilled player. Learn basic strategy before betting large.\nTreat casino as entertainment, not income: the house edge ensures long-term loss.'**
  String get helpTopicCasinoTips;

  /// No description provided for @helpTopicTradeCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicTradeCategory;

  /// No description provided for @helpTopicTradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Trade Goods'**
  String get helpTopicTradeTitle;

  /// No description provided for @helpTopicTradeSummary.
  ///
  /// In en, this message translates to:
  /// **'Buy goods cheap in one country and sell expensive in another. Price differences up to 300% are possible.'**
  String get helpTopicTradeSummary;

  /// No description provided for @helpTopicTradeHow.
  ///
  /// In en, this message translates to:
  /// **'Each country has unique trade goods with own base prices: Diamonds (South Africa), Drugs (Colombia), Weapons (USA), Art (France), Electronics (Japan), Alcohol (Scotland).\nMarket prices fluctuate every tick (5 minutes) between 0.5x and 2.0x base price. Prices can drop while you are traveling.\nBuying is only possible in the country where the good is available. Selling is most valuable in a different country.\nTransport risk: police confiscate at high Wanted Level (chance = wanted × 2%, max 80%); FBI raids internationally based on heat + goods value.\nCustoms has a 10% base chance at border crossings. Pay €1.000-€5.000 bribe or lose 50% of cargo.\nCombine trade with smuggling for higher margins but also higher seizure risk.\nYou can buy unlimited quantities as long as you have enough cash and inventory space.'**
  String get helpTopicTradeHow;

  /// No description provided for @helpTopicTradeTips.
  ///
  /// In en, this message translates to:
  /// **'Check market prices right before departure, not earlier — prices move every 5 minutes.\nLower Wanted Level before every trade trip: confiscation of a full cargo is a catastrophic loss.\nAlways include travel costs, customs risk and time loss in your profit calculation.'**
  String get helpTopicTradeTips;

  /// No description provided for @helpTopicBlackMarketCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicBlackMarketCategory;

  /// No description provided for @helpTopicBlackMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Black Market'**
  String get helpTopicBlackMarketTitle;

  /// No description provided for @helpTopicBlackMarketSummary.
  ///
  /// In en, this message translates to:
  /// **'Buy and sell illegal and scarce goods: weapons, ammo, drugs and materials unavailable elsewhere.'**
  String get helpTopicBlackMarketSummary;

  /// No description provided for @helpTopicBlackMarketHow.
  ///
  /// In en, this message translates to:
  /// **'The black market is divided into submarkets: Materials (raw materials), Weapons (firearms and knives), Ammo (ammo per caliber), Vehicles (illegal vehicles).\nPrices and availability vary heavily by country and time. A listing can sell out fast.\nBlack market transactions leave no official trail but increase FBI Heat for large purchases.\nWeapons bought here can be used in crimes, PvP and security. Better weapons give higher damage and success chance.\nFilters by category (type, country, price, availability) help you quickly find the right listing.\nYou can post your own listings as a seller, including price and quantity. Other players buy from you.\nListings expire after a certain time if unsold. Monitor your own offers via your profile.'**
  String get helpTopicBlackMarketHow;

  /// No description provided for @helpTopicBlackMarketTips.
  ///
  /// In en, this message translates to:
  /// **'Always check whether the black market price is lower than the open trade alternative including travel.\nBuy weapons and ammo in bulk when prices are low: availability is temporary.\nAvoid large black market purchases when FBI Heat is already above 30.'**
  String get helpTopicBlackMarketTips;

  /// No description provided for @helpTopicDrugsCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicDrugsCategory;

  /// No description provided for @helpTopicDrugsTitle.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get helpTopicDrugsTitle;

  /// No description provided for @helpTopicDrugsSummary.
  ///
  /// In en, this message translates to:
  /// **'Build a complete drug operation from raw materials to finished product. Run production chains, manage storage and sell for high margins but serious risks.'**
  String get helpTopicDrugsSummary;

  /// No description provided for @helpTopicDrugsHow.
  ///
  /// In en, this message translates to:
  /// **'The drug system consists of: Hub (overview and stats), Facilities (upgrade production capacity), Production (active production lines with timer) and Inventory (finished products and raw materials).\nBuy raw materials via the black market or trade. Combine them in a facility to produce drugs.\nProduction timers run while you are offline. No active clicking needed: check back when the timer finishes.\nFinished output stays visible in Production and keeps that facility slot occupied until you collect it; VIP auto-collect processes ready output automatically in the background.\nStorage capacity is limited per facility. When storage is full production stops automatically.\nA darkweb storefront or other facility does not auto-sell finished output: selling still happens manually through the intended sale flow.\nSell drugs via the black market, Colombia or other special sales locations for the highest margin.\nFBI Heat rises every production cycle and extra on large sales. High heat leads to raid events that can shut down your operation.\nFacility upgrades reduce production time, increase output and expand storage capacity.\nVIP players get a lightning button on production cards: after a confirmation modal, you can buy all missing batch materials in one click.\nAdvanced slot and equipment upgrades are tied to the new Narcotics education track (Hydroponics Specialist, Process Electrics Specialist, Clandestine Chemist). Without the required level/certification you cannot progress to the next upgrade tier.\nDrugs in inventory increase confiscation risk during travel and police checks.'**
  String get helpTopicDrugsHow;

  /// No description provided for @helpTopicDrugsTips.
  ///
  /// In en, this message translates to:
  /// **'Upgrade storage before production: full storage stops production and you lose that production time.\nKeep FBI Heat below 50: above that threshold you are actively hunted with heavy raid chances that shut everything down.\nCombine drug sales with smuggling for higher margins and distributed risk.'**
  String get helpTopicDrugsTips;

  /// No description provided for @helpTopicNightclubCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicNightclubCategory;

  /// No description provided for @helpTopicNightclubTitle.
  ///
  /// In en, this message translates to:
  /// **'Nightclub'**
  String get helpTopicNightclubTitle;

  /// No description provided for @helpTopicNightclubSummary.
  ///
  /// In en, this message translates to:
  /// **'Run a nightclub as part of your criminal empire. Manage staff, security and supply for passive and active income with a dedicated season leaderboard.'**
  String get helpTopicNightclubSummary;

  /// No description provided for @helpTopicNightclubHow.
  ///
  /// In en, this message translates to:
  /// **'At the bottom you now use a Nightclub Management Command Center with zones for Crew, Drug Storage, DJ Command, Security Unit and Ops Lab; all zones run in one continuous page flow without extra inner-scroll.\nThe nightclub screen now includes one central Intelligence section combining overview, revenue trends and risk logs without tab switching.\nOps Lab now includes 11 systems: resident DJ, dynamic event calendar, upgrade tree, police heat/incident response, supplier contracts, promoter profiles, VIP clientele + staff traits, smuggling routes, bar & kitchen management (drinks/food) with pricing, rival sabotage + counter-intel, and an operations timeline.\nSmuggling routes now have a run cooldown (Harbor 60 min, Airstrip 90 min, Borderline 120 min), forcing risk/timing planning instead of infinite spam.\nThe upgrade tree is interactive: explicitly choose Sound Rig, VIP Lounge or Surveillance and buy the next level directly with visible upgrade costs.\nRevenue is generated per tick based on DJ quality, occupancy and supply availability. Missing supply directly reduces income.\nDJ contracts end automatically at the configured end time; after that you must book again for new boosts.\nIncidents (fights, theft) can occur when security is insufficient. This damages visitor score and income.\nEach season has a leaderboard. Players with the highest total nightclub revenue win season rewards.\nSynergy with drugs: own drug production can serve as supply, raising margins.\nDrug storage is gram-based: each selection shows the available grams before you move stock into nightclub inventory.\nRival actions are name-based: you search rival clubs by player name before selecting an action (no player-id required).\nSynergy with prostitution: combined venue events give extra visitors and higher revenue.\nUpgrades improve capacity, supply storage and the maximum number of DJs and guards you can deploy.'**
  String get helpTopicNightclubHow;

  /// No description provided for @helpTopicNightclubTips.
  ///
  /// In en, this message translates to:
  /// **'Always keep supply stocked: one tick without supply can trigger a visitor dip that is hard to recover from.\nBook the best DJ you can afford: DJ quality has the biggest direct impact on revenue per tick.\nCheck the season leaderboard daily and scale up supply and DJs if you want to finish in the top 10.'**
  String get helpTopicNightclubTips;

  /// No description provided for @helpTopicCryptoCategory.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get helpTopicCryptoCategory;

  /// No description provided for @helpTopicCryptoTitle.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get helpTopicCryptoTitle;

  /// No description provided for @helpTopicCryptoSummary.
  ///
  /// In en, this message translates to:
  /// **'Trade 30 real cryptocurrencies. Buy and sell directly or automate via limit, stop-loss and take-profit orders. Prices now follow live market anchors with extra in-game regimes and news, and the coin popup uses separate fields for direct trades and open orders.'**
  String get helpTopicCryptoSummary;

  /// No description provided for @helpTopicCryptoHow.
  ///
  /// In en, this message translates to:
  /// **'The crypto list shows 30 coins with current price, 24-hour percentage and your current holding per coin. The price base follows live market data, but it is still influenced by in-game regimes and news.\nClick a coin to open the popup with: live chart (time filters 1h, 4h, 8h, 24h, 7d, 30d, All), purchase history, average buy price and buy/sell form.\nDirect trade: enter quantity and click Buy or Sell. When selling you can press `ALL` to instantly fill your full position. Execution is immediate at the current market price.\nOpen orders: Limit (buy/sell at an exact target price), Stop-loss (auto sell when price drops to a threshold), Take-profit (auto sell when price rises to a target). This section now has its own quantity field and its own target price field.\nOpen orders are executed automatically by the backend as soon as the market price hits the target. You do not need to be online.\nMarket regimes (Bull/Bear/Sideways) and news events influence price movements. You receive regime notifications via push when enabled.\nWeekly crypto leaderboard: the player with the highest realized gain that week wins a cash reward.\nDaily and weekly missions (e.g. 3 profitable trades, diversify across 5 coins) give extra rewards on completion.\nPortfolio overview shows: total value, invested amount, unrealized and realized profit/loss.'**
  String get helpTopicCryptoHow;

  /// No description provided for @helpTopicCryptoTips.
  ///
  /// In en, this message translates to:
  /// **'Check your purchase history before placing a sell order: the popup shows your average buy price so you do not accidentally sell at a loss.\nUse stop-loss orders on every position you are not actively watching: they protect you automatically when you are offline.\nSwitch time filters in the chart: 1h and 4h show short-term trend, 7d and 30d show the bigger picture.'**
  String get helpTopicCryptoTips;

  /// No description provided for @helpTopicSmugglingCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicSmugglingCategory;

  /// No description provided for @helpTopicSmugglingTitle.
  ///
  /// In en, this message translates to:
  /// **'Smuggling'**
  String get helpTopicSmugglingTitle;

  /// No description provided for @helpTopicSmugglingSummary.
  ///
  /// In en, this message translates to:
  /// **'Move illegal goods and vehicles between countries. Choose a commercial channel or use your own vehicle or aircraft for lower cost and added confiscation risk.'**
  String get helpTopicSmugglingSummary;

  /// No description provided for @helpTopicSmugglingHow.
  ///
  /// In en, this message translates to:
  /// **'Choose a category, the specific item, the destination, and then decide between a commercial channel or your own transport.\nOwned cars, motorcycles, boats, and aircraft now show a live quote with cargo slots, lower cost, and risk reduction.\nA boat can carry cars and motorcycles; an aircraft cannot carry a boat and will return an immediate error.\nSuccess chance depends on the selected channel or owned transport, your current Wanted Level, and shipment size.\nOn failure you lose the entire shipment. No refund. Cargo and transport costs are gone.\nWhen you use owned transport and the run fails, the transport asset itself can also be confiscated.\nActive shipments are tracked live in an overview. After arrival the cargo appears in a depot ready for collection.\nCrew network remains available for commercial crew shipments, but owned transport is personal only.'**
  String get helpTopicSmugglingHow;

  /// No description provided for @helpTopicSmugglingTips.
  ///
  /// In en, this message translates to:
  /// **'Never send your entire stock in one shipment: split across multiple smaller loads to limit catastrophic loss.\nLower Wanted Level and FBI Heat to a minimum before starting a large smuggling run.\nUse your best aircraft or boat for expensive runs: lower cost helps, but cargo slots and confiscation chance still decide the risk.\nAlways collect active depots as fast as possible: expired depot contents are permanently lost.'**
  String get helpTopicSmugglingTips;

  /// No description provided for @helpTopicToolsCategory.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get helpTopicToolsCategory;

  /// No description provided for @helpTopicToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get helpTopicToolsTitle;

  /// No description provided for @helpTopicToolsSummary.
  ///
  /// In en, this message translates to:
  /// **'Buy and manage tools required for specific crimes. Good tools raise your success chance, worn tools lower it.'**
  String get helpTopicToolsSummary;

  /// No description provided for @helpTopicToolsHow.
  ///
  /// In en, this message translates to:
  /// **'The tool shop shows all available items with price, condition rating and the crime type they are required for.\nEach crime category has preferred tools: burglary requires crowbar or picks, car theft requires a hotwire kit, robbery requires a firearm.\nTools have a condition rating (0-100%). Each successful or failed crime lowers condition by a few percent.\nBelow 20% condition the tool\'s success chance bonus drops drastically. Below 5% the tool has almost no effect.\nRepaired tools through the shop cost a fraction of the purchase price. Replacement is sometimes cheaper than repair for heavily worn tools.\nTools are visible in your inventory tab. You can keep multiple copies of the same type as backup.'**
  String get helpTopicToolsHow;

  /// No description provided for @helpTopicToolsTips.
  ///
  /// In en, this message translates to:
  /// **'Buy tools in bulk when they are cheap on the black market: you save compared to the shop.\nSet a personal threshold: always replace tools when condition drops below 25% to keep success chances stable.'**
  String get helpTopicToolsTips;

  /// No description provided for @helpTopicCourtCategory.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get helpTopicCourtCategory;

  /// No description provided for @helpTopicCourtTitle.
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get helpTopicCourtTitle;

  /// No description provided for @helpTopicCourtSummary.
  ///
  /// In en, this message translates to:
  /// **'During your sentence you can file an appeal or try to bribe the judge to get released sooner.'**
  String get helpTopicCourtSummary;

  /// No description provided for @helpTopicCourtHow.
  ///
  /// In en, this message translates to:
  /// **'When jailed, the court screen shows your active conviction with remaining time, crime and judge profile.\nAn appeal costs money based on your current sentence length. If granted, your sentence is usually reduced by about 20-40%.\nYou can appeal only once per conviction and a cooldown applies to rapid retries.\nBribery uses a player-selected amount. That amount is always deducted, even when the attempt fails.\nA higher bribe amount increases success chance. On success, you are released immediately.\nYour criminal record keeps earlier convictions with dates and court-history details even when you are no longer jailed.\nA successful judge bribe removes only that current conviction from your criminal record.\nIf you want to wipe your full criminal record, you must do it outside court through the late-game Wipe Criminal Record crime.'**
  String get helpTopicCourtHow;

  /// No description provided for @helpTopicCourtTips.
  ///
  /// In en, this message translates to:
  /// **'Use appeals on long sentences first: expected time saved is highest there.\nUse bribery only with enough cash buffer, because payment is always deducted.'**
  String get helpTopicCourtTips;

  /// No description provided for @helpTopicHitlistCategory.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get helpTopicHitlistCategory;

  /// No description provided for @helpTopicHitlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Hitlist'**
  String get helpTopicHitlistTitle;

  /// No description provided for @helpTopicHitlistSummary.
  ///
  /// In en, this message translates to:
  /// **'Place a bounty on an enemy or accept a hit contract. Eliminate your target in the same country for the full payout.'**
  String get helpTopicHitlistSummary;

  /// No description provided for @helpTopicHitlistHow.
  ///
  /// In en, this message translates to:
  /// **'Via the hitlist you add a player by setting a bounty. Minimum bounty is €5,000. The payer loses this money immediately.\nIf a bounty is placed on you, you immediately receive a push notification and inbox message from Hitlist Bureau.\nActive hits are visible to all players. The higher the bounty, the more attention the contract attracts.\nDetective investigations no longer return instant intel: reports arrive later via a Detective Bureau message (Quick 1 hour €1,000,000, Standard 6 hours €500,000, Slow 24 hours €250,000).\nIf you are killed through the hitlist, you receive a Hitlist Bureau message with a button to start a killer investigation within 24 hours.\nIf you request this investigation quickly after the murder, the detective report arrives faster. Waiting longer means a longer report delay.\nTo execute a hit you must be in the same country as your target. You attack via the player profile.\nCombat is auto-calculated based on: weapons, armor, stats (strength, reflexes), crew bonuses and active level.\nOn successful elimination you receive the full bounty. If the attack fails you lose HP and the target survives.\nOn a successful hit, the target receives a hard account-progress reset: assets and progression are reset to baseline status, while bank balance and crew leadership are preserved. You receive a share of available loot in addition to the bounty.\nAfter a successful kill you immediately receive an inbox message from Hitlist Bureau with a breakdown of the bounty and loot (cash + items).\nTargets with an active bodyguard or security protection are harder to hit.\nYou can remove your own name from the hitlist by paying the placer or buying out the bounty yourself.'**
  String get helpTopicHitlistHow;

  /// No description provided for @helpTopicHitlistTips.
  ///
  /// In en, this message translates to:
  /// **'Check the hitlist daily: high bounties on weak players are quick profit if you are in the same country.\nOnly place a bounty on a player when you have reason to believe they are offline or low on HP.'**
  String get helpTopicHitlistTips;

  /// No description provided for @helpTopicSecurityCategory.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get helpTopicSecurityCategory;

  /// No description provided for @helpTopicSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get helpTopicSecurityTitle;

  /// No description provided for @helpTopicSecuritySummary.
  ///
  /// In en, this message translates to:
  /// **'Protect your character and empire with armor, bodyguards and installation security. Better security means less damage taken during attacks.'**
  String get helpTopicSecuritySummary;

  /// No description provided for @helpTopicSecurityHow.
  ///
  /// In en, this message translates to:
  /// **'Armor types in ascending strength: Light Armor → Heavy Armor → Bulletproof Vest → Tactical Outfit.\nYou can only wear 1 armor at a time; if you buy another vest it immediately replaces your current armor.\nEach armor class reduces incoming damage per attack by a fixed percentage. Better armor = more survival in PvP and raids.\nArmor gets damaged after an attack and loses effectiveness. The lower the condition, the less protection your current armor provides.\nAt 100% damage your armor is destroyed and disappears completely; you need to buy a new set to regain protection.\nBodyguards give +10 defense each, but every 24 hours they charge a €10,000 daily wage per bodyguard.\nIf you cannot pay that daily bodyguard wage, all of them leave and you lose their protection immediately.\nInstallation security (for nightclub, drug facility, etc.) lowers raid and incident chance at that specific location.\nThe higher your Wanted Level the more often you are attacked or raided. Better security compensates for this directly.\nCrew members can split security roles so multiple locations are covered simultaneously.'**
  String get helpTopicSecurityHow;

  /// No description provided for @helpTopicSecurityTips.
  ///
  /// In en, this message translates to:
  /// **'Always carry at least Light Armor when Wanted Level is 2 or higher: savings on hospital bills quickly offset the purchase price.\nCheck your armor condition after every attack: a damaged vest only provides part of its original protection.\nOnly keep as many bodyguards as you can still afford tomorrow; large teams become expensive in daily upkeep quickly.'**
  String get helpTopicSecurityTips;

  /// No description provided for @helpTopicHospitalCategory.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get helpTopicHospitalCategory;

  /// No description provided for @helpTopicHospitalTitle.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get helpTopicHospitalTitle;

  /// No description provided for @helpTopicHospitalSummary.
  ///
  /// In en, this message translates to:
  /// **'Recover HP after fights, failed crimes or raids. The hospital offers free emergency care and paid treatments for faster recovery.'**
  String get helpTopicHospitalSummary;

  /// No description provided for @helpTopicHospitalHow.
  ///
  /// In en, this message translates to:
  /// **'Fall below 10 HP and you are automatically admitted to the Emergency Room (ER). This is free but takes longer.\nPaid treatment costs €10,000 per session and restores +30 HP. Cooldown: 60 minutes between paid treatments.\nICU (Intensive Care) is the heaviest treatment for critical damage. Cooldown: 180 minutes. Costs are higher but recovery is more complete.\nWith higher HP (50+) you can still perform actions but are more vulnerable to attacks.\nHospital treatments are blocked while you are in prison. Get out first, then seek treatment.\nSchool certificate in Medicine lowers hospital costs and speeds up recovery times.\nCrew medics or medic skills can restore HP outside the hospital as emergency recovery.'**
  String get helpTopicHospitalHow;

  /// No description provided for @helpTopicHospitalTips.
  ///
  /// In en, this message translates to:
  /// **'Never recover halfway: wait for full HP before doing PvP or high-risk crimes.\nTime paid treatments around cooldown: start a treatment just before going offline so you come back online at full HP.'**
  String get helpTopicHospitalTips;

  /// No description provided for @helpTopicPrisonCategory.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get helpTopicPrisonCategory;

  /// No description provided for @helpTopicPrisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Prison'**
  String get helpTopicPrisonTitle;

  /// No description provided for @helpTopicPrisonSummary.
  ///
  /// In en, this message translates to:
  /// **'Serve your prison sentence, pay bail or attempt to escape. The higher your Wanted Level the longer and more expensive your sentence.'**
  String get helpTopicPrisonSummary;

  /// No description provided for @helpTopicPrisonHow.
  ///
  /// In en, this message translates to:
  /// **'After arrest a timer starts based on Wanted Level. Wanted Level 1 = short sentence (minutes), Wanted Level 5+ = hours in prison.\nBail scales with your remaining sentence and never drops below Wanted Level × €1,000. Longer sentences therefore cost more to buy out immediately.\nEscape: you can attempt a prison break but success chance is low. Failure extends your sentence by a fixed amount.\nIn the Prison list and jail overlay you can always pay your own bail and also attempt your own escape while still jailed.\nCrew members can visit you and provide small benefits (stats, morale) while you are locked up.\nOn arrest your friends and crew members now receive a push notification that you were caught and are waiting for help.\nWeapons and armor are confiscated on arrest if you have no legal cover for them.\nCourt option: go to court for a sentence reduction via a lawyer (see Court).\nWhile locked up production timers (drugs, ammo factory) keep running. Your empire works without you.\nYou cannot visit the hospital while locked up. HP recovery waits until you are free.'**
  String get helpTopicPrisonHow;

  /// No description provided for @helpTopicPrisonTips.
  ///
  /// In en, this message translates to:
  /// **'Check bail immediately after arrest: the button should remain visible as long as you are still jailed, even if your Wanted Level has already dropped.\nStart production timers just before doing a high-risk crime run: if you get caught production keeps running anyway.'**
  String get helpTopicPrisonTips;

  /// No description provided for @helpTopicVaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get helpTopicVaultCategory;

  /// No description provided for @helpTopicVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Crack the Vault'**
  String get helpTopicVaultTitle;

  /// No description provided for @helpTopicVaultSummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly vault season: enter a 4-digit code and stake credits for a chance at big prizes.'**
  String get helpTopicVaultSummary;

  /// No description provided for @helpTopicVaultHow.
  ///
  /// In en, this message translates to:
  /// **'Each month a new season starts on the 1st and ends on the last day of the month.\nPick a stake (e.g. 1/3/5 credits) and enter a 4-digit code.\nYou can also enter the code using the on-screen keypad (digit buttons).\nEach attempt costs credits. If you guess correctly, you win a prize.\nHigher stakes mean bigger prizes; sometimes a VIP reward can drop.\nIf you are already VIP, a VIP reward is converted into credits.\nYou can view your wrong codes for this month. The list resets automatically with the new month.'**
  String get helpTopicVaultHow;

  /// No description provided for @helpTopicVaultTips.
  ///
  /// In en, this message translates to:
  /// **'Pick a stake that matches your credit balance: you can try unlimited times, but each attempt costs credits.\nUse the wrong-codes list to avoid retrying the same code.'**
  String get helpTopicVaultTips;

  /// No description provided for @helpTopicGarageCategory.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get helpTopicGarageCategory;

  /// No description provided for @helpTopicGarageTitle.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get helpTopicGarageTitle;

  /// No description provided for @helpTopicGarageSummary.
  ///
  /// In en, this message translates to:
  /// **'Steal and manage cars and motorcycles for crimes and smuggling. Garage handles ownership, timed repairs, selling and scrapping; transport runs through Smuggling Hub.'**
  String get helpTopicGarageSummary;

  /// No description provided for @helpTopicGarageHow.
  ///
  /// In en, this message translates to:
  /// **'Your garage shows cars and motorcycles with condition (0-100%), fuel, market value, rarity and world-cap status.\nCar storage and motorcycle storage are now separated: cars use garage capacity, motorcycles use motorcycle storage capacity.\nCar and motorcycle storage upgrades are independent per country: upgrading cars does not increase motorcycle capacity (and vice versa). Upgrades are rank-gated; when your rank is too low you see a lock/tooltip. At level 5 the upgrade button is hidden.\nUsing the catalog button you can view all stealable cars and motorcycles, including their most common country and full spawn country list.\nTheft is per vehicle with rank requirements and cooldowns. The more expensive and rare, the lower your success chance.\nIf a model world-cap is full, you cannot steal that model temporarily. When a copy is sold or scrapped, 1 slot reopens immediately.\nFailed theft increases Wanted Level and can trigger arrest. If police catch you during the getaway, you go to jail and the just-stolen vehicle is confiscated immediately.\nRepairs are timed: you pay upfront, the vehicle enters repair and only returns after the timer finishes.\nConcurrent repairs are limited across car, motorcycle and boat together: without VIP max 1 active, with VIP max 2 active.\nScrapping is an alternative to selling: you receive salvage value (35% of base value), scaled by condition and garage upgrade bonus.\nVehicle Ops Intelligence adds 6 extra options. In short:\n1) Hotspot run: a quick action for direct cash, with its own cooldown and added risk.\n2) Parts market: live parts prices per type (car/motorcycle/boat) for tuning; prices refresh periodically.\n3) Crew op: a co-op action with your crew for extra gains/advantages (only if you are in a crew).\n4) Heat: per type (car/motorcycle/boat) an “attention” meter; higher heat makes actions riskier and lowers success chance. Heat decays slowly.\n5) Chop contract: hand in an eligible vehicle from your inventory for a fixed contract payout.\n6) Police pattern: time-of-day patterns can increase checks; this affects risk (e.g. harbor strike/lockdown for boats).\nIn Vehicle Heist, Car/Motorcycle/Boat now use one command layer: select category via the three lane cards at the top, without a second extra tab row.\nEach lane card includes direct quick actions for stealing and storage upgrades, so you do not need to scroll to separate sub-buttons first.\nWhile a steal cooldown is running, a lightning icon appears next to the timer: tap it to spend credits and clear the cooldown. You can turn off the confirmation dialog; turn it back on in Settings under theft cooldown (credits).\nLane cards now also show capacity per type directly (used/total + upgrade level).\nStolen vehicles now render as responsive cards: mobile shows one per row, tablet/desktop show multiple cards side by side.\nNew Ops layer: PvP interception windows for hotspots, crew-role bonuses in crew ops, reputation unlocks per vehicle type, regional blacklist events, and contraband insurance contracts.\nNew Vehicle Ops expansions: Counter-Intercept missions, Crew Matchmaking with seasonal ladder, Country Modifiers (inflation/corruption/harbor strike), and a contracts board with weekly legendary contracts.\nOps now shows live cooldowns per action. Timers count down visibly and refresh automatically.\nCrew actions (Crew Op and Crew Match) are only available when you are in a crew; without a crew you get a clear unlock hint.\nSuccessful ops actions pay cash directly to your wallet. The action overview shows the expected payout type per button.\nInsurance claims now enter review first; using claim dispute lets you contest for extra payout with rejection risk.\nHigher category heat lowers theft success chances and raises hotspot risk. Heat decays gradually each hour.\nChop-Shop Contracts require an eligible vehicle from your inventory; claiming consumes that vehicle and pays out contract cash.\nVehicle transport no longer happens in Garage; use the Smuggling Hub flow.\nResale and scrapping free either car or motorcycle capacity and may reopen world-cap slots for that model.\nEvent-only vehicles such as police interceptors stay locked outside event windows.'**
  String get helpTopicGarageHow;

  /// No description provided for @helpTopicGarageTips.
  ///
  /// In en, this message translates to:
  /// **'Steal vehicles actively when Wanted Level is low: higher Wanted = higher failure chance when stealing.\nAlways keep at least one reliable vehicle at high condition for smuggling: a broken vehicle halves your success chance.\nUse scrapping for heavily damaged vehicles as a fast capacity reset; selling is often better at high condition.'**
  String get helpTopicGarageTips;

  /// No description provided for @helpTopicMarinaCategory.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get helpTopicMarinaCategory;

  /// No description provided for @helpTopicMarinaTitle.
  ///
  /// In en, this message translates to:
  /// **'Marina'**
  String get helpTopicMarinaTitle;

  /// No description provided for @helpTopicMarinaSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage boats with rarity, world caps and repair timers for maritime smuggling routes. Marina focuses on ownership, maintenance, selling and scrapping; transport runs through Smuggling Hub.'**
  String get helpTopicMarinaSummary;

  /// No description provided for @helpTopicMarinaHow.
  ///
  /// In en, this message translates to:
  /// **'The marina shows your boats with condition, fuel, market value, rarity and world-cap status per model.\nUsing the catalog button you can view all stealable boats, including most common country and full spawn country list.\nBoat theft has its own rank gates and cooldowns. More expensive boats are harder to steal but can be more profitable.\nIf a boat model world-cap is full, it temporarily disappears from the available list. Selling/scrapping reopens slots.\nRepairs are timed: you pay upfront and the boat is unavailable until the timer completes.\nConcurrent repairs are limited across car, motorcycle and boat together: without VIP max 1 active, with VIP max 2 active.\nScrapping grants salvage value (35% of base value), scaled with condition and marina upgrade bonus.\nMarina manages ownership and maintenance only; actual transport routing happens in Smuggling Hub.\nEvent-only police boats are for temporary events and remain locked outside event windows.'**
  String get helpTopicMarinaHow;

  /// No description provided for @helpTopicMarinaTips.
  ///
  /// In en, this message translates to:
  /// **'Invest in the marina if your smuggling routes regularly go via water: lower police interest can significantly boost success chance.\nKeep a speedboat at high condition as a quick alternative when land escape routes are blocked.\nScrap heavily damaged boats with low resale value to free world-cap room and marina capacity faster.'**
  String get helpTopicMarinaTips;

  /// No description provided for @helpTopicTuneshopCategory.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get helpTopicTuneshopCategory;

  /// No description provided for @helpTopicTuneshopTitle.
  ///
  /// In en, this message translates to:
  /// **'Tune Shop'**
  String get helpTopicTuneshopTitle;

  /// No description provided for @helpTopicTuneshopSummary.
  ///
  /// In en, this message translates to:
  /// **'Use salvaged parts to upgrade vehicles by category. Improve speed, stealth and armor with scaling level costs and category cooldowns.'**
  String get helpTopicTuneshopSummary;

  /// No description provided for @helpTopicTuneshopHow.
  ///
  /// In en, this message translates to:
  /// **'You earn parts by scrapping vehicles: car parts, motorcycle parts and boat parts.\nParts are category pooled: any vehicle in the same category uses the same parts stock.\nEach upgrade costs parts and money. Money costs are category based and increase per tuning level.\nYou can upgrade three stats: speed, stealth and armor.\nTuning is per vehicle in your inventory. New vehicles start at level 0 again.\nAfter each tune there is a per-vehicle cooldown: car 180s, motorcycle 120s, boat 240s.\nConcurrent tuning is limited: without VIP max 1 active vehicle in tuning cooldown, with VIP max 5.\nTuned vehicles yield higher sell and salvage value.\nTuning is blocked while a vehicle is in repair or transport.'**
  String get helpTopicTuneshopHow;

  /// No description provided for @helpTopicTuneshopTips.
  ///
  /// In en, this message translates to:
  /// **'Scrap heavily damaged vehicles first to build parts quickly.\nInvest in stealth early for lower capture risk on high-risk runs.\nUse armor upgrades on vehicles you repeatedly deploy in dangerous loops.'**
  String get helpTopicTuneshopTips;

  /// No description provided for @helpTopicShootingRangeCategory.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get helpTopicShootingRangeCategory;

  /// No description provided for @helpTopicShootingRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Shooting Range'**
  String get helpTopicShootingRangeTitle;

  /// No description provided for @helpTopicShootingRangeSummary.
  ///
  /// In en, this message translates to:
  /// **'Improve your accuracy and weapon skill through structured shooting drills. Higher stats increase damage and hit chance in PvP and crimes.'**
  String get helpTopicShootingRangeSummary;

  /// No description provided for @helpTopicShootingRangeHow.
  ///
  /// In en, this message translates to:
  /// **'The shooting range offers multiple disciplines: pistol, rifle, shotgun and automatic fire. Each trains a separate weapon skill.\nEach training session has a cooldown of 30 minutes. You cannot train endlessly per day.\nHigher accuracy increases your hit chance in PvP fights and lowers the chance of being hit yourself.\nWeapon skill also determines which weapons you can use effectively: a sniper rifle requires a certain skill before you get its full bonus.\nTraining results stack cumulatively. There is no reset unless you receive a heavy penalty via the court.\nSchool certificate Military Training gives a permanent bonus to each shooting range session.'**
  String get helpTopicShootingRangeHow;

  /// No description provided for @helpTopicShootingRangeTips.
  ///
  /// In en, this message translates to:
  /// **'Train the shooting range every day: small cumulative bonuses become noticeable in PvP outcomes within a week.\nTrain the weapon type you use most in crimes and PvP for maximum return on investment.'**
  String get helpTopicShootingRangeTips;

  /// No description provided for @helpTopicGymCategory.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get helpTopicGymCategory;

  /// No description provided for @helpTopicGymTitle.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get helpTopicGymTitle;

  /// No description provided for @helpTopicGymSummary.
  ///
  /// In en, this message translates to:
  /// **'Train strength, speed and stamina for better stats in PvP, crimes and HP pool. Daily training is key to fast stat growth.'**
  String get helpTopicGymSummary;

  /// No description provided for @helpTopicGymHow.
  ///
  /// In en, this message translates to:
  /// **'The gym offers three training categories: Strength (more damage per attack), Speed (higher reflexes, less hits taken), Stamina (higher max HP).\nEach training has a 1 hour cooldown. Maximum 6-8 sessions per day depending on your school certificate.\nStrength increases direct damage in both PvP and certain crime types (robbery, brawl).\nSpeed increases the chance to dodge an attack and lowers the chance of being caught on crime failure.\nStamina increases your max HP pool. More HP = surviving longer in PvP and more room for risky crimes.\nSchool certificate Physical Training gives +15% bonus to all gym sessions.'**
  String get helpTopicGymHow;

  /// No description provided for @helpTopicGymTips.
  ///
  /// In en, this message translates to:
  /// **'Prioritize Stamina training: a higher HP pool improves all your other systems because you stay active longer.\nCombine gym with shooting range: Strength + Accuracy is the strongest PvP combination.'**
  String get helpTopicGymTips;

  /// No description provided for @helpTopicAmmoFactoryCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicAmmoFactoryCategory;

  /// No description provided for @helpTopicAmmoFactoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Ammo Factory'**
  String get helpTopicAmmoFactoryTitle;

  /// No description provided for @helpTopicAmmoFactorySummary.
  ///
  /// In en, this message translates to:
  /// **'Produce ammunition for personal use and manage your output from the factory. Ammo buying and selling go through the Black Market, not directly from the factory screen.'**
  String get helpTopicAmmoFactorySummary;

  /// No description provided for @helpTopicAmmoFactoryHow.
  ///
  /// In en, this message translates to:
  /// **'The ammo factory has production levels (Level 1 through 5). Higher level = more rounds per claim and better quality.\nDuring an active session you claim production about every 10 minutes (up to 8 hours of backlog within that session).\nProduction keeps accruing while you are offline: when you return you can claim multiple times until backlog is caught up.\nSimply viewing the ammo factory or travelling away and back must not change ownership; a factory should not flip to `for sale` just because the screen was opened.\nProduced ammo is used personally in crimes and PvP. For buying and selling ammo, go through the Black Market; the factory screen itself does not sell bullets directly.\nOutput upgrades increase rounds per claim; quality upgrades improve market value.\nAmmo market price fluctuates with demand. Stock up when prices are low and sell when prices are high.\nDuring a factory raid you lose part of stored output. Security lowers this risk.'**
  String get helpTopicAmmoFactoryHow;

  /// No description provided for @helpTopicAmmoFactoryTips.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your factory to Level 3 as soon as possible: the doubled output compared to Level 1 makes it self-sufficient for ammo.\nAlways keep 2-3 production rounds of output in reserve as a buffer so you never run out of ammo during PvP.'**
  String get helpTopicAmmoFactoryTips;

  /// No description provided for @helpTopicSchoolCategory.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get helpTopicSchoolCategory;

  /// No description provided for @helpTopicSchoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get helpTopicSchoolTitle;

  /// No description provided for @helpTopicSchoolSummary.
  ///
  /// In en, this message translates to:
  /// **'Follow courses in multiple tracks to unlock bonuses, reduce costs and open new systems. School is a multiplier on everything you do.'**
  String get helpTopicSchoolSummary;

  /// No description provided for @helpTopicSchoolHow.
  ///
  /// In en, this message translates to:
  /// **'School offers tracks per domain: Criminal (better crime stats), Economy (lower trade and bank costs), Military (combat bonuses), Medicine (lower hospital costs), Law (lower lawyer costs), Technical (better factory and drug production).\nEach lesson has a study time of 15-60 minutes depending on level. Higher levels take longer.\nAfter completing a lesson you receive a certificate for that track level. This certificate is permanent and grants the bonus immediately.\nYou can only follow one lesson at a time. Plan your studies carefully when you urgently need a specific certificate.\nSchool costs increase per level. Higher education requires earlier levels in the same track to be completed.\nSome advanced game features are locked behind a school certificate: e.g. access to certain jobs, higher factory levels, VIP nightclub events and higher drug facility upgrade tiers.\nCertificates are never reset unless your account receives a heavy penalty.'**
  String get helpTopicSchoolHow;

  /// No description provided for @helpTopicSchoolTips.
  ///
  /// In en, this message translates to:
  /// **'Always start with the Criminal track: bonuses to crime success chances pay back the study costs within a few sessions.\nSchedule long studies (60 min+) before going to sleep: you wake up with a new certificate without missing active time.'**
  String get helpTopicSchoolTips;

  /// No description provided for @helpTopicTerritoryCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicTerritoryCategory;

  /// No description provided for @helpTopicTerritoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get helpTopicTerritoryTitle;

  /// No description provided for @helpTopicTerritorySummary.
  ///
  /// In en, this message translates to:
  /// **'Claim and control geographical regions for passive income, crew prestige and strategic regional bonuses. Territory combines map control with contests and seasonal rewards.'**
  String get helpTopicTerritorySummary;

  /// No description provided for @helpTopicTerritoryHow.
  ///
  /// In en, this message translates to:
  /// **'Territory overview shows all available countries and regions by country. Click a country to see the interactive map.\nAll supported countries are now fully browseable through the same interactive map flow as the Netherlands.\nTap a region on the interactive map to open a modal with territory information and the attack button. The separate region cards below the map are no longer needed.\nViewing is allowed everywhere, but attacks, defense joins and contest actions only work in the country where your character is currently located.\nOn mobile you can now pinch in and out with two fingers and drag the zoomed map directly, making smaller regions easier to tap without extra buttons on the map.\nTerritory is crew-based: you must create or join a crew before the attack button becomes available for neutral or hostile regions.\nEach region can be controlled by at most one crew at a time. Ownership grants passive income per hour, but Territory stops paying into the crew bank once the cash storage cap has been reached.\nStart a contest in an unclaimed region using the contest button. The contest automatically progresses through preparation (prep time), active (actions), and lockdown (resolution).\nDuring an active contest the region modal now also shows when actions unlock, when the contest ends, what the per-action cooldown is, and the real cash amount the region pays per payout, per hour and per day.\nRegions now also have strategic roles such as harbor, industry, capital, border region or logistics hub. That role determines which actions can earn extra points there.\nAdjacent regions already owned by your crew now provide extra support during contest actions. The region modal shows which strategic bonuses are active and how much adjacent support your crew has in that area.\nAction bonuses can now also come from crew progression: HQ level, crew mission level, and relevant side buildings (weapon/ammo/car/boat/drug storage). These bonuses only increase contest points, not passive region cash.\nSome advanced contest actions are HQ-gated: if your HQ level is too low, the action button shows `requires HQ level X` immediately.\nTerritory no longer uses a hard daily action cap by default (runtime cap 0 = disabled). Balance stays controlled through cooldowns, anti-farm and strategic action choices.\nWinning a Territory War or Total War can now leave temporary war pressure on the real Territory regions around that frontline. The region modal shows which crew holds the pressure, how much effective stability is reduced, and when the aftermath expires.\nWhen a contest has just started or an older contest was still missing timing fields, the screen now fills those timers immediately and refreshes the modal to the latest contest state without requiring you to navigate away first.\nAttackers only see attacker actions (intel, sabotage, raid) and defenders only see defender actions (patrol, supply run, defense), so the modal no longer shows confusing mixed buttons.\nA region now also shows the real Territory yield. Crew leaders also see how many regions and countries their crew controls on the dashboard, how much the crew is currently earning, and how much Territory has earned in total so far.\nContests result in ownership transfer and rewards (cash, XP, prestige). Losers also get partial xp for participation.\nLarge regions (harbors, capitals) give more passive income but also trigger more opponents and raid attempts.\nSeasonal events give bonus rewards and special challenges per region group.\nPrevent deadlocks: your crew cannot immediately attack the same opponent after a loss; wait for cooldown.\nAnti-abuse checks prevent one crew from attacking the same target repeatedly in short time windows.'**
  String get helpTopicTerritoryHow;

  /// No description provided for @helpTopicTerritoryTips.
  ///
  /// In en, this message translates to:
  /// **'Start in a balanced country with medium-sized regions: less competition than large countries but reasonable passive income.\nFocus on one country where your crew is strong first: better knowledge leads to better contest strategy than shallow control in many countries.\nUse seasons as strategic resets: if you lose in a dry season, a better season always follows for a comeback.'**
  String get helpTopicTerritoryTips;

  /// No description provided for @helpTopicProstitutionCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicProstitutionCategory;

  /// No description provided for @helpTopicProstitutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prostitution'**
  String get helpTopicProstitutionTitle;

  /// No description provided for @helpTopicProstitutionSummary.
  ///
  /// In en, this message translates to:
  /// **'Build a prostitution network with recruits, events and VIP clients. A well-run network generates passive income but requires active management to control rivalry and police attention.'**
  String get helpTopicProstitutionSummary;

  /// No description provided for @helpTopicProstitutionHow.
  ///
  /// In en, this message translates to:
  /// **'You manage recruits each with their own stats (experience, popularity, availability). More recruits = higher passive income.\nWork shifts run for 8 hours per recruit: after a shift, that recruit needs rest time before you can start again.\nLocation management is flexible: you can move recruits between street, Red Light District and nightclub using the action buttons on each card.\nEvents are temporary boosters: special shows, VIP nights and parties raise income per tick for the duration of the event.\nRivalry: other players or NPC competitors can poach your recruits or sabotage events. Higher security lowers this risk.\nVIP clients pay considerably more but require recruits with high popularity (80+) and a secured location.\nPolice attention (heat) rises with large transactions and raids. High heat leads to income confiscation or temporary shutdown.\nCombination with nightclub: a nightclub provides legal cover for activities making heat rise more slowly.\nUse the earnings insight panel at the top to quickly compare hourly output for street, RLD and nightclub.\nLeaderboard: highest total weekly turnover wins a weekly cash reward and a badge.'**
  String get helpTopicProstitutionHow;

  /// No description provided for @helpTopicProstitutionTips.
  ///
  /// In en, this message translates to:
  /// **'Invest early in security: a rivalry attack that poaches your best recruit costs more than the security investment.\nOnly organise VIP events when recruits are above 80 popularity: below that threshold VIP clients simply pay the standard rate.'**
  String get helpTopicProstitutionTips;

  /// No description provided for @helpTopicRedLightDistrictsCategory.
  ///
  /// In en, this message translates to:
  /// **'Empire'**
  String get helpTopicRedLightDistrictsCategory;

  /// No description provided for @helpTopicRedLightDistrictsTitle.
  ///
  /// In en, this message translates to:
  /// **'Red Light Districts'**
  String get helpTopicRedLightDistrictsTitle;

  /// No description provided for @helpTopicRedLightDistrictsSummary.
  ///
  /// In en, this message translates to:
  /// **'Claim and manage territorial districts per country. Owning a district gives passive income and control over prostitution activities in that region.'**
  String get helpTopicRedLightDistrictsSummary;

  /// No description provided for @helpTopicRedLightDistrictsHow.
  ///
  /// In en, this message translates to:
  /// **'Each country has one or more Red Light Districts that can be claimed. Claim a district by paying a set purchase amount.\nAs owner of a district you receive a percentage of all prostitution income in that country — including from other players operating there.\nOther players can attack your district to take over ownership. Higher security lowers the attack chance.\nDistrict upgrades (security, marketing, infrastructure) raise your income percentage and lower the chance of losing ownership.\nYou can own up to 3 districts simultaneously. Strategic country choice is essential.\nBusiest countries (Colombia, Dubai, Japan) give the highest passive income but are also the most contested.\nLosing a district does not refund the purchase price: it is permanently lost if an enemy successfully claims it.'**
  String get helpTopicRedLightDistrictsHow;

  /// No description provided for @helpTopicRedLightDistrictsTips.
  ///
  /// In en, this message translates to:
  /// **'Start with a less popular country for your first district: lower attack pressure gives you time to upgrade security before the real competition.\nUpgrade security of each district immediately after purchase: the first 24 hours are the most vulnerable to a takeover.'**
  String get helpTopicRedLightDistrictsTips;

  /// No description provided for @helpTopicAchievementsCategory.
  ///
  /// In en, this message translates to:
  /// **'Meta'**
  String get helpTopicAchievementsCategory;

  /// No description provided for @helpTopicAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get helpTopicAchievementsTitle;

  /// No description provided for @helpTopicAchievementsSummary.
  ///
  /// In en, this message translates to:
  /// **'Earn badges by reaching milestones across all game systems. Achievements give rewards, raise your status profile and show your progress per category.'**
  String get helpTopicAchievementsSummary;

  /// No description provided for @helpTopicAchievementsHow.
  ///
  /// In en, this message translates to:
  /// **'Achievements are grouped in categories: Crimes, Empire, PvP, Economy, Training, Social and Meta.\nEach achievement has multiple tiers (Bronze, Silver, Gold, Platinum). Each tier gives a higher reward and a more impressive badge.\nRewards per achievement include: cash, XP, special items, permanent bonuses or unique titles for your profile.\nProgress is tracked automatically. You do not need to activate anything: reach the threshold and the badge is awarded immediately.\nSome achievements are hidden until you partially complete them — they then appear with their real name and requirements.\nAchievement badges are visible on your public profile. They show other players your specializations and experience.\nChain achievements: some badges are linked in a chain. Gold requires Silver to be already obtained. Plan early for higher tiers.'**
  String get helpTopicAchievementsHow;

  /// No description provided for @helpTopicAchievementsTips.
  ///
  /// In en, this message translates to:
  /// **'Check your nearly-completed achievements daily: a small extra effort can earn a badge and cash reward that would otherwise be delayed for months.\nFocus early on Economy and Crime categories: these have the most cash rewards and are easiest to combine with your normal gameplay.'**
  String get helpTopicAchievementsTips;

  /// No description provided for @helpTopicSupportTicketsCategory.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get helpTopicSupportTicketsCategory;

  /// No description provided for @helpTopicSupportTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports & Tickets'**
  String get helpTopicSupportTicketsTitle;

  /// No description provided for @helpTopicSupportTicketsSummary.
  ///
  /// In en, this message translates to:
  /// **'Report bugs, questions or feedback via the ticket system. Support and admins can reply, manage internal follow-up and send updates back through the support conversation itself and optional push notifications.'**
  String get helpTopicSupportTicketsSummary;

  /// No description provided for @helpTopicSupportTicketsHow.
  ///
  /// In en, this message translates to:
  /// **'Open the separate `Support` menu item to review your tickets or create a new one.\nChoose a category (bug, question, feedback or other), select the related module if needed, and describe your issue as specifically as possible.\nYou can optionally add a reference such as an order id, screen name or short context, plus a screenshot if that helps.\nAfter submission you immediately receive a ticket number and your ticket appears in your support overview, where support can reply and create internal todo tasks.\nWhen support replies or the ticket status changes, you see that directly inside the same support conversation and can optionally receive a push notification (if notifications are enabled).\nThe Support menu item shows a badge as soon as a ticket gets a new support reply or status update since your last visit to the support overview.\nSupport uses statuses such as new, triage, in progress, waiting for player, blocked and resolved to track your report internally.'**
  String get helpTopicSupportTicketsHow;

  /// No description provided for @helpTopicSupportTicketsTips.
  ///
  /// In en, this message translates to:
  /// **'Always include your country, action and exact error message; this speeds up fixes for developers.\nUse one ticket per issue type so the todo list and follow-up stay clear.'**
  String get helpTopicSupportTicketsTips;

  /// No description provided for @helpTopicSettingsCategory.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get helpTopicSettingsCategory;

  /// No description provided for @helpTopicSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get helpTopicSettingsTitle;

  /// No description provided for @helpTopicSettingsSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage all account settings: language, avatar, privacy, notification preferences per system and security options. Settings directly affect your gameplay experience.'**
  String get helpTopicSettingsSummary;

  /// No description provided for @helpTopicSettingsHow.
  ///
  /// In en, this message translates to:
  /// **'Language: switch between Dutch and English. All UI texts, system messages and notifications update immediately.\nAvatar: upload or select a profile image visible to other players on your public profile and in crew lists.\nPrivacy: set who can see your online status, location (current country) and statistics — only you, crew, friends or everyone.\nPush notifications: toggle per system. Categories: Crimes, Crypto trading, Price alerts, Orders, live player events (competition), Market regime, Heist, Nightclub, general messages.\nIf push was already allowed, the web/PWA version automatically reconnects to your current device token after a refresh or update; you only need to re-enable it in Settings when the browser itself blocks notifications.\nCrypto notification preferences remain saved after leaving Settings and opening it again later.\nIn-app notifications: configurable separately from push. In-app shows alerts inside the app without sending a system notification.\nSecurity: change password, set up two-factor authentication and view active sessions.\nPer-system notification preference: fine tune so you do not get a notification storm from systems you are not actively playing.'**
  String get helpTopicSettingsHow;

  /// No description provided for @helpTopicSettingsTips.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications for Crypto Orders and Heist Events: these are time-critical systems where quick reaction matters.\nSet privacy to crew-only for location when you are active on the hitlist: other players can otherwise pinpoint you exactly.'**
  String get helpTopicSettingsTips;

  /// No description provided for @helpTopicPremiumCategory.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get helpTopicPremiumCategory;

  /// No description provided for @helpTopicPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium & Credits'**
  String get helpTopicPremiumTitle;

  /// No description provided for @helpTopicPremiumSummary.
  ///
  /// In en, this message translates to:
  /// **'Buy and manage Player VIP, Crew VIP and credit bundles here. This overview also shows your credit balance and all available credit items you can use directly or contextually.'**
  String get helpTopicPremiumSummary;

  /// No description provided for @helpTopicPremiumHow.
  ///
  /// In en, this message translates to:
  /// **'Open the separate `Premium & Credits` page from the side menu to view your VIP status, expiry dates, credit balance and purchase options.\nOn each purchase tile, tap/click the `i` icon at the top-left for full details and benefits; the tile itself intentionally shows only short core info and the buy button.\nPlayer VIP is personal. Crew VIP applies to your crew and only has value when you are already in a crew.\nPlayer VIP gives 10% shorter action timeouts (jail time remains unchanged), 100 weekly credits, a VIP one-click purchase button for missing materials in Drug Production (after cost confirmation), and a softer death reset: bank/crypto/education/achievements stay, while assets, inventory and drug stock are removed.\nVIP checkout opens the payment page and then returns to the in-game `Premium & Credits` section, so you immediately see whether the purchase succeeded and how long your VIP runs.\nCredit bundles are bought with real money. After a successful payment the credits appear in your wallet overview right away.\nEvent Pass (7 days, real money) is listed in the one-time offer grid: +10% score on live player events, plus a small credit bonus after purchase. It is a side-grade: not a direct combat or PvP boost; it mainly helps leaderboard results during running events.\nCredit items use wallet credits instead of euros. Think of hit protection, cooldown resets, event boosts or cash bundles, depending on what admin currently has enabled live.\nOn supported timeout screens (such as crimes, jobs, vehicle/boat theft and school) you also get a direct speed-up button for active cooldowns, so you do not need to go back to Premium & Credits first.\nSome credit items work directly from this screen. Context-bound items, such as certain vehicle actions, are used from the correct vehicle or garage screen instead (damaged vehicles show an instant-repair button directly on the card).\nFor contextual buttons such as repair speed-up, the current credit cost is shown directly on the button/tooltip.\nPrices and available items are managed live in admin. That means VIP prices, credit costs and the available offer can change without an app update.'**
  String get helpTopicPremiumHow;

  /// No description provided for @helpTopicPremiumTips.
  ///
  /// In en, this message translates to:
  /// **'Check your credit balance and expiry date before buying again; extending is often better than stacking blindly.\nUse credits mainly on time-critical boosts or protection, not automatically on every small shortcut.\nIf you are not in a crew yet, start with Player VIP or a credit bundle before Crew VIP.'**
  String get helpTopicPremiumTips;

  /// No description provided for @landingHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'The Mob State'**
  String get landingHeroTitle;

  /// No description provided for @landingHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A deep text-based crime strategy game in your browser. Build your empire, run crews, trade, fight for territory — and climb the ranks.'**
  String get landingHeroSubtitle;

  /// No description provided for @landingAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'What awaits you'**
  String get landingAboutTitle;

  /// No description provided for @landingAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Manage businesses, execute jobs and heists, develop your character through school certificates, compete in live events, and coordinate with your crew on the world map. Fair competitive rules, long-term progression, and regular content updates.'**
  String get landingAboutBody;

  /// No description provided for @landingTopPlayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Top players'**
  String get landingTopPlayersTitle;

  /// No description provided for @landingTopCrewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top crews (territory)'**
  String get landingTopCrewsTitle;

  /// No description provided for @landingRankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get landingRankLabel;

  /// No description provided for @landingRegionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get landingRegionsLabel;

  /// No description provided for @landingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load rankings right now.'**
  String get landingLoadError;

  /// No description provided for @landingEmptyLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get landingEmptyLeaderboard;

  /// No description provided for @landingCtaLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get landingCtaLogin;

  /// No description provided for @landingCtaRegister.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get landingCtaRegister;

  /// No description provided for @landingFooterPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get landingFooterPrivacy;

  /// No description provided for @landingFooterDigitalGoods.
  ///
  /// In en, this message translates to:
  /// **'Purchase of Digital Goods'**
  String get landingFooterDigitalGoods;

  /// No description provided for @landingFooterLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get landingFooterLanguage;

  /// Footer copyright; year is injected from the app clock.
  ///
  /// In en, this message translates to:
  /// **'© {year} The Mob State. All rights reserved.'**
  String landingCopyright(int year);

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: May 2026'**
  String get legalPrivacyLastUpdated;

  /// No description provided for @legalPrivacyIntro.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains how The Mob State (\"we\", \"us\") handles personal data when you use our website, web game and related services. By playing or browsing you agree to this policy where applicable law allows.'**
  String get legalPrivacyIntro;

  /// No description provided for @legalPrivacySection01Title.
  ///
  /// In en, this message translates to:
  /// **'Who we are'**
  String get legalPrivacySection01Title;

  /// No description provided for @legalPrivacySection01Body.
  ///
  /// In en, this message translates to:
  /// **'The Mob State is an online game operated as a digital service. For privacy requests you can contact us through the in-game support ticket system after registration, or via the official website contact channels if published.'**
  String get legalPrivacySection01Body;

  /// No description provided for @legalPrivacySection02Title.
  ///
  /// In en, this message translates to:
  /// **'Data we collect'**
  String get legalPrivacySection02Title;

  /// No description provided for @legalPrivacySection02Body.
  ///
  /// In en, this message translates to:
  /// **'We may process account data (username, email if provided, hashed password), gameplay and progression data, technical logs (IP address, device/browser type, timestamps), payment-related references from our payment providers (we do not store full card numbers), and communications you send to support.'**
  String get legalPrivacySection02Body;

  /// No description provided for @legalPrivacySection03Title.
  ///
  /// In en, this message translates to:
  /// **'Purposes'**
  String get legalPrivacySection03Title;

  /// No description provided for @legalPrivacySection03Body.
  ///
  /// In en, this message translates to:
  /// **'We use data to provide the game, secure accounts, prevent abuse and fraud, process purchases, improve performance, communicate service messages, and comply with legal obligations.'**
  String get legalPrivacySection03Body;

  /// No description provided for @legalPrivacySection04Title.
  ///
  /// In en, this message translates to:
  /// **'Legal bases (EEA/UK)'**
  String get legalPrivacySection04Title;

  /// No description provided for @legalPrivacySection04Body.
  ///
  /// In en, this message translates to:
  /// **'Where GDPR applies we rely on performance of a contract (providing the game), legitimate interests (security, analytics, product improvement balanced against your rights), consent where required (e.g. certain marketing cookies or optional communications), and legal obligations.'**
  String get legalPrivacySection04Body;

  /// No description provided for @legalPrivacySection05Title.
  ///
  /// In en, this message translates to:
  /// **'Cookies and local storage'**
  String get legalPrivacySection05Title;

  /// No description provided for @legalPrivacySection05Body.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to keep you signed in, remember preferences, measure basic usage, and deliver essential functionality. You can control many cookies through your browser settings.'**
  String get legalPrivacySection05Body;

  /// No description provided for @legalPrivacySection06Title.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get legalPrivacySection06Title;

  /// No description provided for @legalPrivacySection06Body.
  ///
  /// In en, this message translates to:
  /// **'We retain information as long as needed to operate the service and meet legal, tax, and accounting requirements. Some logs may be kept for a limited security window. When data is no longer needed we delete or anonymise it where feasible.'**
  String get legalPrivacySection06Body;

  /// No description provided for @legalPrivacySection07Title.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get legalPrivacySection07Title;

  /// No description provided for @legalPrivacySection07Body.
  ///
  /// In en, this message translates to:
  /// **'We share data with infrastructure and payment processors strictly as needed to run the service, under appropriate agreements. We do not sell your personal data. We may disclose information if required by law or to protect rights and safety.'**
  String get legalPrivacySection07Body;

  /// No description provided for @legalPrivacySection08Title.
  ///
  /// In en, this message translates to:
  /// **'International transfers'**
  String get legalPrivacySection08Title;

  /// No description provided for @legalPrivacySection08Body.
  ///
  /// In en, this message translates to:
  /// **'Your data may be processed in the European Economic Area and/or other regions where we or our providers operate. We use safeguards such as standard contractual clauses where required.'**
  String get legalPrivacySection08Body;

  /// No description provided for @legalPrivacySection09Title.
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get legalPrivacySection09Title;

  /// No description provided for @legalPrivacySection09Body.
  ///
  /// In en, this message translates to:
  /// **'Depending on your location you may have rights to access, rectify, erase, restrict or object to certain processing, and to data portability. You may lodge a complaint with a supervisory authority. Contact us via support to exercise rights; we may need to verify your identity.'**
  String get legalPrivacySection09Body;

  /// No description provided for @legalPrivacySection10Title.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get legalPrivacySection10Title;

  /// No description provided for @legalPrivacySection10Body.
  ///
  /// In en, this message translates to:
  /// **'The game is not directed to children under the age where parental consent is required for processing in your region. If you believe a child provided data improperly, contact us and we will take appropriate steps.'**
  String get legalPrivacySection10Body;

  /// No description provided for @legalDigitalGoodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase of Digital Goods'**
  String get legalDigitalGoodsTitle;

  /// No description provided for @legalDigitalGoodsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: May 2026'**
  String get legalDigitalGoodsLastUpdated;

  /// No description provided for @legalDigitalGoodsIntro.
  ///
  /// In en, this message translates to:
  /// **'This policy describes purchases of digital content and services in The Mob State (for example premium credits, VIP time, or other virtual items). By completing a purchase you agree to these terms together with any checkout terms shown at payment.'**
  String get legalDigitalGoodsIntro;

  /// No description provided for @legalDigitalGoodsSection01Title.
  ///
  /// In en, this message translates to:
  /// **'Nature of digital purchases'**
  String get legalDigitalGoodsSection01Title;

  /// No description provided for @legalDigitalGoodsSection01Body.
  ///
  /// In en, this message translates to:
  /// **'All purchases are payments for access to additional online features and virtual items within The Mob State. They are delivered digitally in-game and have no physical form.'**
  String get legalDigitalGoodsSection01Body;

  /// No description provided for @legalDigitalGoodsSection02Title.
  ///
  /// In en, this message translates to:
  /// **'Immediate delivery and withdrawal (UK/EU)'**
  String get legalDigitalGoodsSection02Title;

  /// No description provided for @legalDigitalGoodsSection02Body.
  ///
  /// In en, this message translates to:
  /// **'Where the Consumer Contracts Regulations 2013 (UK) or equivalent EU rules apply, you acknowledge that digital content is supplied immediately after purchase and, where the law permits, you may lose the statutory 14-day right of withdrawal once delivery has begun with your prior express consent.'**
  String get legalDigitalGoodsSection02Body;

  /// No description provided for @legalDigitalGoodsSection03Title.
  ///
  /// In en, this message translates to:
  /// **'Refunds and chargebacks'**
  String get legalDigitalGoodsSection03Title;

  /// No description provided for @legalDigitalGoodsSection03Body.
  ///
  /// In en, this message translates to:
  /// **'Digital goods are generally non-refundable once delivered except where mandatory consumer law requires otherwise. Chargebacks or payment disputes after delivery may lead to suspension or termination of related accounts; please contact support first so we can help resolve billing issues.'**
  String get legalDigitalGoodsSection03Body;

  /// No description provided for @legalDigitalGoodsSection04Title.
  ///
  /// In en, this message translates to:
  /// **'Permission and age'**
  String get legalDigitalGoodsSection04Title;

  /// No description provided for @legalDigitalGoodsSection04Body.
  ///
  /// In en, this message translates to:
  /// **'You must be authorised to use the chosen payment method. If you are under 18, you need permission from a parent or guardian to make purchases or use paid services.'**
  String get legalDigitalGoodsSection04Body;

  /// No description provided for @legalDigitalGoodsSection05Title.
  ///
  /// In en, this message translates to:
  /// **'Payment channels and fees'**
  String get legalDigitalGoodsSection05Title;

  /// No description provided for @legalDigitalGoodsSection05Body.
  ///
  /// In en, this message translates to:
  /// **'Prices may be shown in euros or your provider currency. Mobile carriers or payment platforms may add their own fees; check with your provider before confirming carrier or wallet payments.'**
  String get legalDigitalGoodsSection05Body;

  /// No description provided for @legalDigitalGoodsSection06Title.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get legalDigitalGoodsSection06Title;

  /// No description provided for @legalDigitalGoodsSection06Body.
  ///
  /// In en, this message translates to:
  /// **'Paid features are delivered virtually through our servers and may change over time. We may adjust, suspend or retire specific items, bundles, or pricing to balance the game or for technical reasons.'**
  String get legalDigitalGoodsSection06Body;

  /// No description provided for @legalDigitalGoodsSection07Title.
  ///
  /// In en, this message translates to:
  /// **'No real-world cash value'**
  String get legalDigitalGoodsSection07Title;

  /// No description provided for @legalDigitalGoodsSection07Body.
  ///
  /// In en, this message translates to:
  /// **'Virtual items and currencies have no monetary value outside the game, are non-transferable for real money, and may be altered or removed as part of updates, account enforcement, or service discontinuation except where law requires compensation.'**
  String get legalDigitalGoodsSection07Body;

  /// No description provided for @legalDigitalGoodsSection08Title.
  ///
  /// In en, this message translates to:
  /// **'Prohibited commercial use'**
  String get legalDigitalGoodsSection08Title;

  /// No description provided for @legalDigitalGoodsSection08Body.
  ///
  /// In en, this message translates to:
  /// **'You may not use The Mob State to operate unauthorised real-money trading, including buying or selling accounts, in-game currency, codes, or virtual assets for cash or external services outside our official payment flows.'**
  String get legalDigitalGoodsSection08Body;

  /// No description provided for @legalDigitalGoodsSection09Title.
  ///
  /// In en, this message translates to:
  /// **'Service changes'**
  String get legalDigitalGoodsSection09Title;

  /// No description provided for @legalDigitalGoodsSection09Body.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy and in-game purchase descriptions. Continued use after changes constitutes acceptance of the revised terms where permitted by law.'**
  String get legalDigitalGoodsSection09Body;

  /// No description provided for @legalDigitalGoodsSection10Title.
  ///
  /// In en, this message translates to:
  /// **'Governing law'**
  String get legalDigitalGoodsSection10Title;

  /// No description provided for @legalDigitalGoodsSection10Body.
  ///
  /// In en, this message translates to:
  /// **'Unless mandatory local law provides otherwise, this policy is governed by the laws of England and Wales and disputes shall be subject to the exclusive jurisdiction of the courts of England and Wales.'**
  String get legalDigitalGoodsSection10Body;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'nl',
    'pl',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
