// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Juego de mafia';

  @override
  String get login => 'Acceso';

  @override
  String get register => 'Registro';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get usernameLabel => 'NOMBRE DE USUARIO';

  @override
  String get passwordLabel => 'CONTRASEÑA';

  @override
  String get usernamePlaceholder => 'Nombre de usuario';

  @override
  String get passwordPlaceholder => 'Contraseña';

  @override
  String get loginButton => 'ACCESO';

  @override
  String get registerButton => 'REGISTRO';

  @override
  String get forgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get usernameRequired => 'Por favor ingrese un nombre de usuario';

  @override
  String get passwordRequired => 'Por favor ingrese una contraseña';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get invalidCredentials => 'Nombre de usuario o contraseña incorrectos';

  @override
  String get loginSuccessful => 'Inicio de sesión exitosa!';

  @override
  String get registrationSuccessful => '¡Registro exitoso!';

  @override
  String get registerGenderTitle => 'tu personaje';

  @override
  String get registerGenderSubtitle =>
      'Toca un retrato: esto establece tu apariencia inicial y se guarda en tu cuenta.';

  @override
  String get registerGenderMale => 'gángster masculino';

  @override
  String get registerGenderFemale => 'gángster femenino';

  @override
  String get genderRequired => 'Elija hombre o mujer para continuar.';

  @override
  String get loginFailed => 'error de inicio de sesion';

  @override
  String get emailLabel => 'CORREO ELECTRÓNICO';

  @override
  String get emailPlaceholder => 'Correo electrónico';

  @override
  String get emailRequired =>
      'Por favor ingrese una dirección de correo electrónico';

  @override
  String get emailInvalid =>
      'Por favor, introduce una dirección de correo electrónico válida';

  @override
  String get forgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get forgotPasswordDescription =>
      'Ingrese su dirección de correo electrónico y le enviaremos un enlace para restablecer su contraseña.';

  @override
  String get resetPasswordButton => 'ENVIAR ENLACE DE RESET';

  @override
  String get emailSent =>
      'Restablecer enlace enviado! Revisa tu correo electrónico.';

  @override
  String get backToLogin => 'Volver a iniciar sesión';

  @override
  String welcome(String username) {
    return '¡Bienvenido, $username!';
  }

  @override
  String get dashboardTimeouts => 'Tiempos de espera';

  @override
  String get dashboardTimeoutCrime => 'Delito';

  @override
  String get dashboardTimeoutJob => 'Trabajar';

  @override
  String get dashboardTimeoutTravel => 'Viajar';

  @override
  String get dashboardTimeoutVehicleTheft => 'Robar coche';

  @override
  String get dashboardTimeoutBoatTheft => 'Robar barco';

  @override
  String get dashboardTimeoutNightclubSeason => 'Temporada de discotecas';

  @override
  String get dashboardTimeoutAmmo => 'Comprar munición';

  @override
  String get dashboardTimeoutShootingRange => 'Campo de tiro';

  @override
  String get dashboardTimeoutGym => 'Gimnasia';

  @override
  String get dashboardTimeoutGymStrength => 'Gym: strength';

  @override
  String get dashboardTimeoutGymSpeed => 'Gym: speed';

  @override
  String get dashboardTimeoutGymStamina => 'Gym: stamina';

  @override
  String get dashboardInfoDrugsGrams => 'Drogas (gramos)';

  @override
  String get dashboardInfoNightclubs => 'Discotecas';

  @override
  String get dashboardInfoNightclubRevenue => 'Ingresos del club nocturno';

  @override
  String get dashboard => 'Panel';

  @override
  String get crimes => 'Crímenes';

  @override
  String get errorLoadingCrimes => 'No se pudieron cargar los delitos';

  @override
  String connectionError(String error) {
    return 'Error de conexión: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Paga: €$min - €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Requiere rango $rank';
  }

  @override
  String get requiresVehicle => 'Requiere vehículo';

  @override
  String get federalCrimeWarning => '⚠️ Crimen federal: calor del FBI';

  @override
  String get crimePickpocketName => 'carteristas';

  @override
  String get crimePickpocketDesc => 'Robar carteras a los transeúntes.';

  @override
  String get crimeShopliftName => 'Hurto';

  @override
  String get crimeShopliftDesc => 'Robar bienes de una tienda.';

  @override
  String get crimeStealBikeName => 'robar bicicleta';

  @override
  String get crimeStealBikeDesc => 'Robar una bicicleta de un portabicicletas';

  @override
  String get crimeCarTheftName => 'robo de autos';

  @override
  String get crimeCarTheftDesc => 'robar un auto estacionado';

  @override
  String get crimeBurglaryName => 'Robo con fractura';

  @override
  String get crimeBurglaryDesc => 'irrumpir en una casa';

  @override
  String get crimeRobStoreName => 'Robo de tienda';

  @override
  String get crimeRobStoreDesc => 'Robar una pequeña tienda';

  @override
  String get crimeMugPersonName => 'Asalto';

  @override
  String get crimeMugPersonDesc => 'Asaltar a alguien en la calle';

  @override
  String get crimeStealCarPartsName => 'Robar piezas de coche';

  @override
  String get crimeStealCarPartsDesc => 'Robar piezas de coches estacionados';

  @override
  String get crimeHijackTruckName => 'Camión secuestrador';

  @override
  String get crimeHijackTruckDesc =>
      'Secuestra un camión que transporta mercancías';

  @override
  String get crimeAtmTheftName => 'Robo de cajero automático';

  @override
  String get crimeAtmTheftDesc => 'Irrumpir en un cajero automático';

  @override
  String get crimeJewelryHeistName => 'Robo de joyas';

  @override
  String get crimeJewelryHeistDesc => 'robar un joyero';

  @override
  String get crimeVandalismName => 'Vandalismo';

  @override
  String get crimeVandalismDesc => 'Daño a la propiedad por dinero';

  @override
  String get crimeGraffitiName => 'Pintada';

  @override
  String get crimeGraffitiDesc => 'Rociar graffiti para pandillas locales';

  @override
  String get crimeDrugDealSmallName => 'Pequeño negocio de drogas';

  @override
  String get crimeDrugDealSmallDesc =>
      'Vender una pequeña cantidad de medicamentos.';

  @override
  String get crimeDrugDealLargeName => 'Gran negocio de drogas';

  @override
  String get crimeDrugDealLargeDesc => 'Vender una gran cantidad de drogas.';

  @override
  String get crimeExtortionName => 'Extorsión';

  @override
  String get crimeExtortionDesc => 'Extorsionar a empresas locales';

  @override
  String get crimeKidnappingName => 'Secuestro';

  @override
  String get crimeKidnappingDesc => 'Secuestrar a alguien para pedir rescate';

  @override
  String get crimeArsonName => 'Incendio provocado';

  @override
  String get crimeArsonDesc => 'Prender fuego a un edificio';

  @override
  String get crimeSmugglingName => 'Contrabando';

  @override
  String get crimeSmugglingDesc =>
      'Contrabandear mercancías a través de la frontera';

  @override
  String get crimeAssassinationName => 'Asesinato';

  @override
  String get crimeAssassinationDesc =>
      'Llevar a cabo un asesinato por contrato';

  @override
  String get crimeHackAccountName => 'Hackear cuenta';

  @override
  String get crimeHackAccountDesc => 'Hackear una cuenta bancaria';

  @override
  String get crimeCounterfeitMoneyName => 'Dinero falso';

  @override
  String get crimeCounterfeitMoneyDesc => 'hacer dinero falso';

  @override
  String get crimeIdentityTheftName => 'Robo de identidad';

  @override
  String get crimeIdentityTheftDesc =>
      'Robar la identidad de alguien por fraude';

  @override
  String get crimeRobArmoredTruckName => 'Atraco a un camión blindado';

  @override
  String get crimeRobArmoredTruckDesc => 'Robar un camión blindado';

  @override
  String get crimeArtTheftName => 'Robo de arte';

  @override
  String get crimeArtTheftDesc => 'Robar obras de arte valiosas';

  @override
  String get crimeProtectionRacketName => 'Raqueta de protección';

  @override
  String get crimeProtectionRacketDesc =>
      'Hacer que las empresas paguen dinero por protección';

  @override
  String get crimeCasinoHeistName => 'Atraco al casino';

  @override
  String get crimeCasinoHeistDesc => 'robar un casino';

  @override
  String get crimeBankRobberyName => 'Robo de banco';

  @override
  String get crimeBankRobberyDesc => 'robar un banco';

  @override
  String get crimeStealYachtName => 'robar yate';

  @override
  String get crimeStealYachtDesc => 'Robar un yate de lujo';

  @override
  String get crimeCorruptOfficialName => 'Oficial de soborno';

  @override
  String get crimeCorruptOfficialDesc =>
      'Sobornar a una funcionaria para favores';

  @override
  String get crimeEliminateWitnessName => 'Eliminar testigo';

  @override
  String get crimeEliminateWitnessDesc =>
      'Elimina a un testigo antes del juicio';

  @override
  String get crimeDiamondHeistName => 'Atraco al transporte de diamantes';

  @override
  String get crimeDiamondHeistDesc =>
      'Intercepta un transporte de diamantes en bruto';

  @override
  String get crimeEvidenceRoomHeistName => 'Asalto a la sala de pruebas';

  @override
  String get crimeEvidenceRoomHeistDesc => 'Roba pruebas de un almacén federal';

  @override
  String get crimeMuseumHeistName => 'Atraco al museo';

  @override
  String get crimeMuseumHeistDesc => 'Roba artefactos valiosos de un museo';

  @override
  String get crimeBossAssassinationName => 'Asesinato del jefe rival';

  @override
  String get crimeBossAssassinationDesc =>
      'Elimina al líder de una organización criminal rival';

  @override
  String get crimeCriminalRecordWipeName => 'Borrar antecedentes penales';

  @override
  String get tooltipCrimeRequiresTools => 'Herramientas necesarias';

  @override
  String get tooltipCrimeRequiresVehicle => 'Vehículo requerido';

  @override
  String get tooltipCrimeRequiresDrugs => 'Medicamentos requeridos';

  @override
  String get tooltipCrimeHighValue => 'Operación de alto valor';

  @override
  String get tooltipCrimeRequiresViolence => 'Se requiere violencia';

  @override
  String get tooltipCrimeRequiresWeapon => 'Arma requerida';

  @override
  String get tooltipCrimeRequirementsHeading => 'Requisitos:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Borra por completo tus antecedentes penales si ten éxito. Solo tiene sentido si ya tienes condenas.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Necesitas al menos ${quantity}g de: $drugs';
  }

  @override
  String get jobs => 'Empleos';

  @override
  String get errorLoadingJobs => 'No se pudieron cargar los trabajos';

  @override
  String get jobNewspaperDeliveryName => 'Entrega de periódicos';

  @override
  String get jobNewspaperDeliveryDesc =>
      'Entregar periódicos temprano en la mañana.';

  @override
  String get jobCarWashName => 'Lavado de autos';

  @override
  String get jobCarWashDesc => 'Lavar autos en el lavadero de autos.';

  @override
  String get jobGroceryBaggerName => 'Ensacadora de comestibles';

  @override
  String get jobGroceryBaggerDesc =>
      'Estantes de existencias en el supermercado.';

  @override
  String get jobDishwasherName => 'Lavavajillas';

  @override
  String get jobDishwasherDesc => 'Lavar platos en un restaurante.';

  @override
  String get jobStreetSweeperName => 'Barrendera';

  @override
  String get jobStreetSweeperDesc => 'Barrer las calles limpias';

  @override
  String get jobPizzaDeliveryName => 'Entrega de pizzas';

  @override
  String get jobPizzaDeliveryDesc => 'Repartir pizzas en la ciudad.';

  @override
  String get jobTaxiDriverName => 'Taxista';

  @override
  String get jobTaxiDriverDesc => 'Conducir un taxi por la ciudad.';

  @override
  String get jobWarehouseWorkerName => 'Trabajador de almacén';

  @override
  String get jobWarehouseWorkerDesc => 'trabajar en un almacen';

  @override
  String get jobConstructionWorkerName => 'Trabajadora de la construcción';

  @override
  String get jobConstructionWorkerDesc =>
      'Trabajar en un sitio de construcción';

  @override
  String get jobBartenderName => 'Barman';

  @override
  String get jobBartenderDesc => 'Vierta cerveza y mezcle cócteles.';

  @override
  String get jobSecurityGuardName => 'Guardia de seguridad';

  @override
  String get jobSecurityGuardDesc => 'vigilar un edificio';

  @override
  String get jobTruckDriverName => 'Conductor de camión';

  @override
  String get jobTruckDriverDesc => 'Conducir un camión a largas distancias.';

  @override
  String get jobMechanicName => 'Mecánica';

  @override
  String get jobMechanicDesc => 'Reparar coches en un garaje.';

  @override
  String get jobElectricianName => 'Electricista';

  @override
  String get jobElectricianDesc => 'Instalar y reparar sistemas eléctricos.';

  @override
  String get jobPlumberName => 'Plomero';

  @override
  String get jobPlumberDesc => 'Reparación de tuberías y fontanería.';

  @override
  String get jobChefName => 'Cocinera';

  @override
  String get jobChefDesc => 'cocinar en un restaurante';

  @override
  String get jobParamedicName => 'Paramédica';

  @override
  String get jobParamedicDesc => 'Ayudar a las personas necesitadas';

  @override
  String get jobProgrammerName => 'Programadora';

  @override
  String get jobProgrammerDesc => 'Escribir software para empresas.';

  @override
  String get jobAccountantName => 'Contadora';

  @override
  String get jobAccountantDesc => 'Gestionar las finanzas de las empresas.';

  @override
  String get jobLawyerName => 'Abogada';

  @override
  String get jobLawyerDesc => 'Defender a las clientas en los tribunales';

  @override
  String get jobRealEstateAgentName => 'Agente de Bienes Raíces';

  @override
  String get jobRealEstateAgentDesc => 'Vender casas y edificios.';

  @override
  String get jobStockbrokerName => 'Corredor de valores';

  @override
  String get jobStockbrokerDesc => 'Negociar acciones';

  @override
  String get jobDoctorName => 'Doctora';

  @override
  String get jobDoctorDesc => 'Tratar a las pacientes en el hospital';

  @override
  String get jobAirlinePilotName => 'Piloto';

  @override
  String get jobAirlinePilotDesc => 'Volar aviones de pasajeros';

  @override
  String jobSuccessChancePercent(String percent) {
    return '$percent% de probabilidad';
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
  String get travel => 'Viajar';

  @override
  String get errorLoadingCountries => 'No se pudieron cargar los países';

  @override
  String get currentLocation => 'Ubicación actual';

  @override
  String get current => 'Actual';

  @override
  String get travelTo => 'Viajar';

  @override
  String travelCost(String amount) {
    return 'Coste: €$amount';
  }

  @override
  String get travelJourneyTitle => '¿Iniciar viaje?';

  @override
  String get travelRouteLabel => 'Ruta:';

  @override
  String travelLegsLabel(String count) {
    return 'Piernas: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Coste por tramo: €$amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Coste total: €$amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Enfriamiento: $minutes min por pierna';
  }

  @override
  String get travelRiskPerLeg =>
      'Riesgo: por tramo (puede ser encarcelado y perder todos los bienes)';

  @override
  String get travelStart => 'Comenzar';

  @override
  String travelInTransitTo(String country) {
    return 'En tránsito a $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Pierna $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Próxima parada: $country';
  }

  @override
  String get travelContinue => 'Continuar';

  @override
  String get travelCancelJourney => 'Cancelar viaje';

  @override
  String get travelJourneyCanceled => 'Viaje cancelado';

  @override
  String get travelNotInTransit => 'No estás en un viaje.';

  @override
  String get travelDirect => 'Directa';

  @override
  String get travelHeroTitle => 'El camino';

  @override
  String get travelHeroSubtitle =>
      'Muévete entre países en busca de mercados, delitos y comercio. Cada tramo cuesta dinero en efectivo y puede hacer que te registren.';

  @override
  String get travelHereChip => 'Usted está aquí';

  @override
  String travelDestinationsChip(String count) {
    return '$count destinos';
  }

  @override
  String travelWantedChip(String level) {
    return 'Se busca $level';
  }

  @override
  String travelFbiChip(String level) {
    return 'FBI $level';
  }

  @override
  String get travelCannotAfford => 'No hay suficiente efectivo';

  @override
  String travelAircraftBonusChip(String percent) {
    return 'Avión propio: −$percent% tiempo de viaje';
  }

  @override
  String travelVia(String countries) {
    return 'vía $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count piernas';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Estás en la cárcel por $minutes minutos más';
  }

  @override
  String travelSuccessTo(String country) {
    return '¡Viajé a $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity artículos $item confiscados!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item dañado ($percent% de pérdida de valor)!';
  }

  @override
  String get countryNetherlands => 'Países Bajos';

  @override
  String get countryBelgium => 'Bélgica';

  @override
  String get countryGermany => 'Alemania';

  @override
  String get countryFrance => 'Francia';

  @override
  String get countrySpain => 'España';

  @override
  String get countryItaly => 'Italia';

  @override
  String get countryUk => 'Reino Unido';

  @override
  String get countrySwitzerland => 'Suiza';

  @override
  String get crew => 'Multitud';

  @override
  String get profile => 'Perfil';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logOut => 'Finalizar la sesión';

  @override
  String get menu => 'Menú';

  @override
  String get account => 'Cuenta';

  @override
  String get userAccountMenuTooltip => 'Menú de cuenta';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get messages => 'Mensajes';

  @override
  String get noDirectMessagesYet => 'Aún no hay mensajes';

  @override
  String get sendMessageToFriendsHint => '¡Envía un mensaje a tus amigos!';

  @override
  String errorLoadingConversations(String error) {
    return 'Error al cargar conversaciones: $error';
  }

  @override
  String get messageSystemBadge => 'SISTEMA';

  @override
  String get messageSystemInboxPreview => 'Logros y mensajes del sistema';

  @override
  String get messageSystemThreadSubtitle => 'Logros y mensajes del sistema';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Los logros y los mensajes del sistema aparecen aquí automáticamente.';

  @override
  String get messageSendFirst => '¡Envía el primer mensaje!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Rango $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Error al cargar mensajes: $error';
  }

  @override
  String get messageDeleteOwnOnly =>
      'Solo puedes eliminar tus propios mensajes';

  @override
  String get messageDeleteTitle => 'Eliminar mensaje';

  @override
  String get messageDeleteBody =>
      'Este mensaje se eliminará de forma permanente.';

  @override
  String get messageSendFailed => 'Error al enviar el mensaje';

  @override
  String get messageDeleteFailed => 'No se pudo eliminar el mensaje';

  @override
  String get investigationWindowExpired =>
      'Ventana de investigación expirada (24 horas).';

  @override
  String get investigationStartedInboxHint =>
      'Investigación iniciada. Revisa tu bandeja de entrada para el informe del detective.';

  @override
  String get investigationAlreadyInProgress =>
      'Esta investigación ya está en curso o completada.';

  @override
  String investigationStartFailed(String error) {
    return 'No se pudo iniciar la investigación: $error';
  }

  @override
  String get investigationExpired => 'Investigación expirada';

  @override
  String get investigationStarted => 'Investigación iniciada';

  @override
  String get investigationStarting => 'Iniciando...';

  @override
  String get startMurderInvestigation => 'Iniciar investigación de asesinato';

  @override
  String get systemMessagesReadOnlyHint =>
      'No se pueden responder los mensajes del sistema';

  @override
  String get helpAndGuide => 'Ayuda y guía';

  @override
  String get helpUiManualTitle => 'Manual de juego';

  @override
  String get helpUiSearchHint => 'Buscar por módulo, explicación o consejo';

  @override
  String get helpUiTopicLabel => 'Tema';

  @override
  String get helpUiAllChip => 'Toda';

  @override
  String get helpUiNoResultsTitle => 'No se encontraron temas';

  @override
  String get helpUiNoResultsBody =>
      'Cambie su búsqueda o categoría para ver los resultados nuevamente.';

  @override
  String get helpUiHowItWorks => 'Cómo funciona';

  @override
  String get helpUiTips => 'Consejos';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get mobileNavCrimes => 'Crímenes';

  @override
  String get mobileNavSteal => 'Robar';

  @override
  String get mobileNavWork => 'Trabajar';

  @override
  String get mobileNavBank => 'Banco';

  @override
  String get mobileNavCrew => 'Multitud';

  @override
  String get mobileNavReady => 'Listo';

  @override
  String get menuSearchHint => 'Buscar en el menú';

  @override
  String get menuSearchNoResults => 'No hay páginas coincidentes';

  @override
  String get menuNavCategoryActions => 'Comportamiento';

  @override
  String get menuNavCategoryWorld => 'Mundo';

  @override
  String get menuNavCategorySocial => 'Social';

  @override
  String get menuNavCategoryEconomy => 'Economía';

  @override
  String get menuNavCategoryEmpire => 'Imperio';

  @override
  String get menuNavCategoryAssets => 'Activos';

  @override
  String get menuNavCategoryMore => 'Más';

  @override
  String get liveEvents => 'Mi actividad';

  @override
  String get worldFeedHint => 'Solo tus acciones recientes.';

  @override
  String get support => 'Soporte';

  @override
  String get events => 'Eventos';

  @override
  String get liveEventRailOpenEvents => 'Open events';

  @override
  String seasonPassTitle(String season) {
    return 'Season Pass $season';
  }

  @override
  String get seasonPassSubtitle =>
      '56 objetivos mensuales: crímenes, vehículos, contrabando, drogas, dinero ganado, XP y reclutamiento de prostitución. Premio de evento gratis y bonus Event Pass (premium) por fila.';

  @override
  String seasonPassGoalProstitution(int count) {
    return 'Recluta $count trabajadoras';
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
  String get aviation => 'Aviación';

  @override
  String get premiumAndCredits => 'Primas y créditos';

  @override
  String get bank => 'Banco';

  @override
  String get tradeGoods => 'Bienes comerciales';

  @override
  String get drugs => 'Drogas';

  @override
  String get nightclub => 'Club nocturno';

  @override
  String get crypto => 'Cripto';

  @override
  String get smuggling => 'Contrabando';

  @override
  String get tools => 'herramientas';

  @override
  String get vehicleHeist => 'Atraco de vehículos';

  @override
  String get vehicleHeistTitle => 'Atraco de vehículos';

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
      'Roba autos por dinero en efectivo y repuestos.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Robar motocicletas por dinero en efectivo y repuestos.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Roba barcos por dinero en efectivo y piezas.';

  @override
  String get vehicleHeistReady => 'Listo';

  @override
  String get vehicleHeistMotorStorage => 'Almacenamiento de motocicletas';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'La capacidad del vehículo se comparte entre todos los atracos de vehículos.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'La capacidad de las motocicletas se comparte en todos los atracos de motocicletas.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'La capacidad del barco se comparte entre todos los atracos de barcos.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Rango requerido: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Almacenamiento: $stored/$total (nivel de carril $level)';
  }

  @override
  String get vehicleHeistStealCar => 'robar auto';

  @override
  String get vehicleHeistStealMotorcycle => 'robar moto';

  @override
  String get vehicleHeistStealBoat => 'robar barco';

  @override
  String get vehicleHeistGenericVehicle => 'vehículo';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Éxito: $vehicle robado.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Enfriamiento activo: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Te arrestaron ($minutes min de cárcel).';
  }

  @override
  String get vehicleHeistUntil => 'hasta';

  @override
  String get vehicleHeistRegionalLockActive => 'Bloqueo regional activo.';

  @override
  String get vehicleHeistStealFailed => 'La acción de robo falló.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Actualización completada.';

  @override
  String get vehicleHeistUpgradeFailed => 'La actualización falló.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Coches disponibles';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Motos disponibles';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Barcos disponibles';

  @override
  String get vehicleHeistCatalogEmpty => 'No hay vehículos en este catálogo.';

  @override
  String get vehicleHeistRarityCommon => 'Común';

  @override
  String get vehicleHeistRarityUncommon => 'Poco común';

  @override
  String get vehicleHeistRarityRare => 'Extraña';

  @override
  String get vehicleHeistRarityEpic => 'Épica';

  @override
  String get vehicleHeistRarityLegendary => 'Legendaria';

  @override
  String get vehicleHeistEventOnlyTag => 'Sólo evento';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Valor: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Rango: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Disponibilidad en el juego: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Más común en: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Países: $countries';
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
    return 'Actualizar ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Actualización bloqueada: rango $rank requerido';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Actualización bloqueada';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Acelera para obtener $credits créditos';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Acelerar (siguiente pantalla)';

  @override
  String get vehicleHeistExpand => 'Expandir';

  @override
  String get vehicleHeistCollapse => 'Colapsar';

  @override
  String get vehicleHeistActive => 'ACTIVA';

  @override
  String get vehicleHeistOff => 'apagada';

  @override
  String get catalog => 'Catalogar';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Ejecutar punto de acceso';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Ejecución de punto de acceso';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Ejecución del punto de acceso completada: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Enfriamiento del punto de acceso activo ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'El punto de acceso falló. El calor aumentó.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Operación de Crew';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Operación de Crew';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Operación de equipo completada: ganaste $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'Se requiere Crew.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Tiempo de reutilización de operaciones de Crew activo ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'La operación de la Crew falló.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Únete a un equipo para desbloquear acciones del equipo';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew requerida: sí';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew requerida: no (únete a una Crew primero)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Comprar piezas';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'comprar repuestos';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return '¿Comprar qué piezas? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Piezas compradas: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed =>
      'Error en la compra de piezas.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Contrato de Reclamación';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Contrato de reclamación';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contrato completado: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'No hay ningún vehículo elegible en el inventario para este contrato.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Reutilización del contrato activa ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'Reclamación del contrato fallida.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Seguro';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Seguro de contrabando';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Elija un nivel de cobertura para esta categoría de vehículo.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Básica';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pro';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Seguro activo ($tier) por $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'La compra del seguro falló.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Partido de Crew';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Partido de equipo ganado: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Partido de equipo perdido: +$reward consolación';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed =>
      'El emparejamiento de la Crew falló.';

  @override
  String get vehicleHeistOpsCounterButton => 'Contadora';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Éxito de contraintercepción: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Contraintercepción no disponible o fallida.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Contrato de operaciones';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Contrato de operaciones';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Contrato de operaciones completado: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'El contrato de operaciones falló o está en tiempo de reutilización.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Disputa de reclamación';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'No hay reclamaciones de seguro abiertas.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'No se encontró ningún reclamo válido.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Reclamo aprobado: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Reclamación rechazada: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'La resolución del reclamo falló.';

  @override
  String get vehicleHeistOpsIntelTitle =>
      'Inteligencia de operaciones de vehículos';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Actualizar la inteligencia';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Toque para expandir y ver todas las acciones.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Calor $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Policía: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Nivel de representación $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Mercado de repuestos: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Punto de acceso: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Recompensa: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Por qué obtienes efectivo: las acciones de operaciones exitosas se pagan directamente al efectivo de la billetera.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Efectivo: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Tú: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Efectivo: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contratos: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| desde $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Precios de piezas (coche/moto/barco): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Actualización del mercado de repuestos: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size miembros)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Recompensa del contrato de corte: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Ventana de intercepción: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Lista negra: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Lista negra: ninguna';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Seguro: $tier activa';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine => 'Seguro: inactivo';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Modificador de país: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Temporada de Crew: $season | puntos $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contratos: $count | enfriamiento $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Enfriamiento del contador: $cooldown | reclamos abiertos: $claims';
  }

  @override
  String get tuneShop => 'Tienda de melodías';

  @override
  String get tuneShopIntro =>
      'Desguaza vehículos para obtener piezas y mejora la velocidad, el sigilo y el blindaje. Las piezas se comparten por categoría (coche/moto/barco), por lo que puedes tunear cualquier vehículo dentro de la misma categoría.';

  @override
  String get tuneShopCarPartsLabel => 'Piezas de coche';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Piezas de motocicleta';

  @override
  String get tuneShopBoatPartsLabel => 'Piezas de barco';

  @override
  String get tuneShopEmptyTitle => 'No hay vehículos disponibles para tuning';

  @override
  String get tuneShopEmptyBody =>
      'Primero roba algunos vehículos y desecha algunos para obtener piezas.';

  @override
  String get tuneShopVehicleTypeCar => 'Auto';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motocicleta';

  @override
  String get tuneShopVehicleTypeBoat => 'Bote';

  @override
  String get tuneShopStatSpeed => 'Velocidad';

  @override
  String get tuneShopStatStealth => 'Sigilo';

  @override
  String get tuneShopStatArmor => 'Armadura';

  @override
  String get tuneShopValueMultiplierPrefix => 'Valor x';

  @override
  String get tuneShopUpgradeButton => 'Mejora';

  @override
  String get tuneShopMaxLabel => 'MÁXIMO';

  @override
  String get tuneShopPartsAbbrev => 'puntos';

  @override
  String get tuneShopUpgradeCompleted => 'Actualización completada';

  @override
  String get tuneShopUpgradeFailed => 'La actualización falló';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning bloqueado: vehículo en tránsito.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning bloqueado: vehículo en reparación.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tiempo de reutilización de ajuste activo: $duration restante.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Vehículo no encontrado';

  @override
  String get tuneShopErrorNotOwner => 'No eres propietario de este vehículo.';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning bloqueado: vehículo en tránsito.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning bloqueado: vehículo en reparación.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Hace falta dinero';

  @override
  String get tuneShopErrorInsufficientParts => 'No hay suficientes piezas';

  @override
  String get tuneShopErrorStatMaxed =>
      'Este nivel de sintonización está al máximo.';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tiempo de reutilización de ajuste activo: $duration restante.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Límite alcanzado: máximo $max ajuste simultáneo, actualmente $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Estadística de ajuste no válida';

  @override
  String get territory => 'Territorio';

  @override
  String get achievements => 'Logros';

  @override
  String get menuCrackVault => 'Romper la bóveda';

  @override
  String get vaultHeroTagline => 'Adivina el código y gana grandes premios.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Temporada: $range';
  }

  @override
  String get vaultYourCredits => 'Tus créditos';

  @override
  String get vaultChooseStake => 'Elige tu apuesta';

  @override
  String vaultStakeCredits(int stake) {
    String _temp0 = intl.Intl.pluralLogic(
      stake,
      locale: localeName,
      other: '$stake créditos',
      one: '$stake crédito',
    );
    return '$_temp0';
  }

  @override
  String vaultExpectedPrize(int reward) {
    return 'Premio esperado: +$reward créditos';
  }

  @override
  String get vaultCodeLabel => 'Código';

  @override
  String get vaultSubmitStake => 'Apostar';

  @override
  String get vaultWrongCodesTitle => 'Códigos erróneos (este mes)';

  @override
  String get vaultShowWrongCodes => 'Mostrar';

  @override
  String get vaultHideWrongCodes => 'Ocultar';

  @override
  String get vaultNoWrongCodesYet => 'Aún no hay códigos erróneos guardados.';

  @override
  String get couldNotLoadVaultStatus => 'No se pudo cargar el estado.';

  @override
  String get vaultEnterFourDigitCode => 'Introduce un código de 4 dígitos.';

  @override
  String get vaultAttemptSuccessGeneric => 'Hecho.';

  @override
  String get vaultAttemptFailedGeneric => 'Error.';

  @override
  String get vaultAttemptFailedRetry => 'Error. Inténtalo de nuevo.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count mensajes nuevos';
  }

  @override
  String get rankProgress => 'Progreso de rango';

  @override
  String get cash => 'Dinero';

  @override
  String get sessionRecap => 'Resumen de la sesión';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get countryLabel => 'País';

  @override
  String get wantedLevel => 'Nivel buscado';

  @override
  String get fbiHeat => 'Calor del FBI';

  @override
  String get properties => 'Propiedades';

  @override
  String get vehicles => 'Vehículos';

  @override
  String get netWorth => 'patrimonio neto';

  @override
  String get securityLabel => 'Seguridad';

  @override
  String get noSecurity => 'Sin seguridad';

  @override
  String get weaponLabel => 'Arma';

  @override
  String get vehicleLabel => 'Vehículo';

  @override
  String get none => 'Ninguna';

  @override
  String get statistics => 'Estadística';

  @override
  String get breakouts => 'Brotes';

  @override
  String get murders => 'Asesinatos';

  @override
  String get hitlistContracts => 'Contratos de lista de resultados';

  @override
  String get carsStolen => 'autos robados';

  @override
  String get boatsStolen => 'Barcos robados';

  @override
  String get crimeAttempts => 'Intentos de crimen';

  @override
  String get successful => 'Exitosa';

  @override
  String get jobAttempts => 'Intentos de trabajo';

  @override
  String get streetProstitutes => 'prostitutas callejeras';

  @override
  String get rldProstitutes => 'prostitutas rld';

  @override
  String get travels => 'Viajes';

  @override
  String get bullets => 'balas';

  @override
  String get moneyStatusLabel => 'Estado del dinero';

  @override
  String get moneyStatusPoor => 'Pobre';

  @override
  String get moneyStatusRising => 'Creciente';

  @override
  String get moneyStatusRich => 'Rica';

  @override
  String get moneyStatusMultimillionaire => 'Multimillonaria';

  @override
  String get rankBeginner => 'Principiante';

  @override
  String get rankCriminal => 'Criminal';

  @override
  String get rankGangster => 'Gángster';

  @override
  String get rankMafioso => 'Mafiosa';

  @override
  String get rankEmptySuit => 'Traje vacío';

  @override
  String get rankDeliveryBoy => 'Repartidor';

  @override
  String get rankPicciotto => 'Picciotto';

  @override
  String get rankShoplifter => 'Ratero de tiendas';

  @override
  String get rankPickpocket => 'Carterista';

  @override
  String get rankThief => 'Ladrón';

  @override
  String get rankAssociate => 'Asociado';

  @override
  String get rankCadet => 'Cadete';

  @override
  String get rankSoldier => 'Soldado';

  @override
  String get rankSwindler => 'Estafador';

  @override
  String get rankAssassin => 'Asesino';

  @override
  String get rankLocalChief => 'Jefe local';

  @override
  String get rankChief => 'Jefe';

  @override
  String get rankDrugLord => 'Señor de la droga';

  @override
  String get rankGodfather => 'Padrino';

  @override
  String get rankDon => 'Don';

  @override
  String get rankOverlord => 'Señor';

  @override
  String get rankLegend => 'Leyenda';

  @override
  String get rankUnknown => 'Desconocido';

  @override
  String get dailyGoalTitle_crime_3 => 'cometer 3 crímenes';

  @override
  String get dailyGoalTitle_job_2 => 'trabajar 2 veces';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Robar 1 vehículo';

  @override
  String get dailyGoalTitle_travel_1 => 'Completa 1 viaje';

  @override
  String get dailyGoalTitle_training_combo_1 =>
      'Train gym + shooting range (same day)';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Semanal: 20 crímenes';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Semanal: trabajar 10 veces';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Semanal: roba 5 vehículos';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Semanal: 3 viajes';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Recompensa: +$cash y +$xp XP';
  }

  @override
  String get justNow => 'En este momento';

  @override
  String secondsAgo(String seconds) {
    return 'Hace ${seconds}s';
  }

  @override
  String minutesAgo(String count) {
    return '$count hace minutos';
  }

  @override
  String hoursAgo(String count) {
    return '$count hace horas';
  }

  @override
  String get last10EventsLive => 'Últimos 10 eventos (en vivo).';

  @override
  String get noEventsYetSession => 'Aún no hay eventos en esta sesión.';

  @override
  String get clearRecap => 'Resumen claro';

  @override
  String get weeklyGoalClaimed => '¡Objetivo semanal reclamado!';

  @override
  String get dailyGoalClaimed => '¡Objetivo diario reclamado!';

  @override
  String get failed => 'Fallida.';

  @override
  String get failedPleaseTryAgain => 'Fallido. Por favor inténtalo de nuevo.';

  @override
  String get dailyGoals => 'Metas diarias';

  @override
  String get weeklyGoals => 'Metas semanales';

  @override
  String get claimed => 'Reclamada';

  @override
  String get ready => 'Listo';

  @override
  String get claim => 'Afirmar';

  @override
  String readyToClaim(String count) {
    return '$count listo para reclamar';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total completado';
  }

  @override
  String get noPlayerData => 'Sin datos del jugador';

  @override
  String get economy24h => 'Economía 24h';

  @override
  String get grossIncome => 'Ingreso bruto';

  @override
  String get propertySpend => 'Gasto en propiedad';

  @override
  String get netCashflow => 'flujo de caja neto';

  @override
  String get trendVsPrevious => 'Tendencia vs anterior';

  @override
  String get activity7d => 'Actividad 7d';

  @override
  String get vehicleThefts => 'Robos de vehículos';

  @override
  String get opsOverview => 'Descripción general de operaciones';

  @override
  String get activeCooldowns => 'Enfriamientos activos';

  @override
  String get longestTimer => 'Temporizador más largo';

  @override
  String get activeProduction => 'Producción activa';

  @override
  String get productionReadyIn => 'Producción lista en';

  @override
  String get nightclubEvents => 'Eventos de discotecas';

  @override
  String get nextEventStartsIn => 'El próximo evento comienza en';

  @override
  String get vehiclesActiveListedTransit =>
      'Vehículos activos/listados/tránsito';

  @override
  String get livePlayerEvents => 'Eventos de jugadores en vivo';

  @override
  String get openEvents => 'Eventos abiertos';

  @override
  String get notificationsAndRisk => 'Notificaciones y riesgos';

  @override
  String get unreadDm => 'DM no leído';

  @override
  String get supportWaitingOnYou => 'Soporte esperando por ti';

  @override
  String get eventsLast24h => 'Eventos últimas 24h';

  @override
  String get riskScore => 'Puntuación de riesgo';

  @override
  String get recruitProstitute => 'reclutar prostituta';

  @override
  String get free => 'GRATIS';

  @override
  String get crewWars => 'Guerras de tripulaciones';

  @override
  String get status => 'Estado';

  @override
  String get canDeclare => 'puede declarar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get type => 'Tipo';

  @override
  String get opponent => 'Adversaria';

  @override
  String get crewPoints => 'Puntos de Crew';

  @override
  String get warRank => 'rango de guerra';

  @override
  String get seasonRank => 'Rango de temporada';

  @override
  String get openTargets => 'Objetivos abiertos';

  @override
  String get phaseEndsIn => 'La fase termina en';

  @override
  String get crewTerritory => 'Territorio de la Crew';

  @override
  String get regions => 'Regiones';

  @override
  String get countriesCaptured => 'Países capturados';

  @override
  String get payout => 'Pago';

  @override
  String get earningPerHour => 'Ganando ahora por hora';

  @override
  String get earningPerDay => 'Ganar ahora por día';

  @override
  String get totalEarned => 'Total ganado';

  @override
  String get crewBank => 'banco de tripulacion';

  @override
  String get dashboardEconomy24h => 'Economía 24 h';

  @override
  String get dashboardGrossIncome => 'Ingreso bruto';

  @override
  String get dashboardPropertySpend => 'Gasto en propiedades';

  @override
  String get dashboardNetCashflow => 'Flujo de caja neto';

  @override
  String get dashboardTrendVsPrevious => 'Tendencia vs periodo anterior';

  @override
  String get dashboardActivity7d => 'Actividad (7 días)';

  @override
  String get dashboardVehicleThefts => 'Robos de vehículos';

  @override
  String get dashboardOpsOverview => 'Resumen de operaciones';

  @override
  String get dashboardActiveCooldowns => 'Tiempos de espera activos';

  @override
  String get dashboardLongestTimer => 'Temporizador más largo';

  @override
  String get dashboardActiveProduction => 'Producción activa';

  @override
  String get dashboardProductionReadyIn => 'Producción lista en';

  @override
  String get dashboardNightclubEvents => 'Eventos de discoteca';

  @override
  String get dashboardNextEventStartsIn => 'Próximo evento en';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Vehículos activos/en venta/en tránsito';

  @override
  String get dashboardLivePlayerEvents => 'Eventos de jugadores en vivo';

  @override
  String get dashboardOpenEvents => 'Eventos abiertos';

  @override
  String get dashboardNotificationsAndRisk => 'Notificaciones y riesgo';

  @override
  String get dashboardUnreadDm => 'MD no leídos';

  @override
  String get dashboardSupportWaitingOnYou => 'Soporte te está esperando';

  @override
  String get dashboardEventsLast24h => 'Eventos (últimas 24 h)';

  @override
  String get dashboardRiskScore => 'Puntuación de riesgo';

  @override
  String get dashboardRecruitProstitute => 'Reclutar prostituta';

  @override
  String get dashboardWarTheater => 'teatro de guerra';

  @override
  String get dashboardHotRegions => 'Regiones calientes';

  @override
  String get dashboardCrewWars => 'Guerras de crew';

  @override
  String get dashboardStatusLabel => 'Estado';

  @override
  String get dashboardCanDeclare => 'Puede declarar guerra';

  @override
  String get dashboardTypeLabel => 'Tipo';

  @override
  String get dashboardOpponent => 'Adversario';

  @override
  String get dashboardCrewPoints => 'Puntos de crew';

  @override
  String get dashboardWarRank => 'Rango de guerra';

  @override
  String get dashboardSeasonRank => 'Rango de temporada';

  @override
  String get dashboardOpenTargets => 'Objetivos abiertos';

  @override
  String get dashboardPhaseEndsIn => 'La fase termina en';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'En la cárcel ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'En preparación';

  @override
  String get dashboardCrewWarStatusActive => 'Activa';

  @override
  String get dashboardCrewWarStatusLockdown => 'Bloqueo';

  @override
  String get dashboardCrewWarStatusResolved => 'Resuelta';

  @override
  String get dashboardCrewWarStatusArchived => 'Archivada';

  @override
  String get dashboardCrewWarStatusCancelled => 'Cancelada';

  @override
  String get dashboardCrewWarStatusNone => 'Sin guerra activa';

  @override
  String get dashboardCrewWarTypeKill => 'Guerra de eliminación';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerra económica';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerra territorial';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerra total';

  @override
  String get dashboardClicks => 'Clics';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Oferta especial';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'No configurada';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'cada $hours horas',
      one: 'cada hora',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'cada $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Territorio crew';

  @override
  String get dashboardRegions => 'Regiones';

  @override
  String get dashboardCountriesCaptured => 'Países capturados';

  @override
  String get dashboardPayout => 'Pago';

  @override
  String get dashboardEarningPerHour => 'Ganancias actuales / hora';

  @override
  String get dashboardEarningPerDay => 'Ganancias actuales / día';

  @override
  String get dashboardTotalEarned => 'Total ganado';

  @override
  String get dashboardVehicleOps => 'Operaciones de vehículos';

  @override
  String get dashboardKillProgress => 'Progreso de eliminaciones';

  @override
  String get vehicleOpsHeat => 'Calor';

  @override
  String get vehicleOpsHeatLevelLow => 'Bajo';

  @override
  String get vehicleOpsHeatLevelMedium => 'Medio';

  @override
  String get vehicleOpsHeatLevelHigh => 'Alto';

  @override
  String get vehicleOpsReputation => 'Reps';

  @override
  String get vehicleOpsPartsTrendUp => 'mercado de repuestos en alza';

  @override
  String get vehicleOpsPartsTrendDown => 'caída del mercado de repuestos';

  @override
  String get vehicleOpsPartsTrendStable => 'mercado de repuestos estable';

  @override
  String get vehicleOpsBlacklistActive => 'Lista negra activa';

  @override
  String get vehicleOpsNoBlacklist => 'Sin lista negra';

  @override
  String get prisonTitle => 'Prisión';

  @override
  String get prisonLoadFailed => 'No pudo cargar prisioneras';

  @override
  String get prisonNoPrisonersFound => 'No se encontraron prisioneras';

  @override
  String prisonRankLine(String rank) {
    return 'Rango: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Rango: $rank · Tú';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Tiempo restante: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Fianza: €$amount';
  }

  @override
  String get prisonPayBailButton => 'pagar la fianza';

  @override
  String get prisonBuyOutButton => 'Comprar la parte';

  @override
  String get prisonAttemptEscapeButton => 'intento de escape';

  @override
  String get prisonJailbreakButton => 'Fuga';

  @override
  String get prisonActionFailed => '❌ La acción falló';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Comprado $username por ⟦1€⟧';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Pagaste fianza por $amount€ y estás libre';
  }

  @override
  String get prisonEscapeSuccess => '✅ ¡Escapada exitosa! Eres libre.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ La fuga falló. Sentencia ampliada por $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Enfriamiento activo: espera $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Error de escape';

  @override
  String get prisonErrorInsufficientFunds => '❌ No hay suficiente dinero';

  @override
  String get prisonErrorTargetNotJailed => '❌ Target ya no está en prisión';

  @override
  String get prisonErrorCannotBuyoutSelf =>
      '❌ No puedes comprar tu propia parte';

  @override
  String get prisonErrorPlayerNotFound => '❌ Jugadora no encontrada';

  @override
  String get prisonJailbreakSuccess =>
      '✅ ¡El jailbreak fue exitoso! El prisionero está libre.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 Jailbreak falló, te atraparon ($minutes min cárcel).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Jailbreak falló. El prisionero sigue encerrado.';

  @override
  String get prisonErrorRescuerJailed => '❌ Tú mismo estás en la cárcel';

  @override
  String get prisonJailbreakGenericFailure => '❌ Falló el jailbreak';

  @override
  String get crewJailbreakTitle => '🚔 Crew encarcelada';

  @override
  String get crewJailbreakLoadFailed =>
      'No se pudo cargar a las miembros encarceladas';

  @override
  String get crewJailbreakEmptyTitle => '🎉 ¡Nadie en la cárcel!';

  @override
  String get crewJailbreakEmptyBody =>
      'Todos los miembros de la Crew son libres.';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Intento de jailbreak para $username:';
  }

  @override
  String get crewJailbreakRiskSuccess => 'Si tiene éxito: ¡Jugador liberada!';

  @override
  String get crewJailbreakRiskFailChance =>
      'Si falla: 60% de posibilidades de ser atrapado';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Atrapado: 30-60 min de cárcel + buscado +10';

  @override
  String get crewJailbreakTip =>
      '¡Las posibilidades de éxito aumentan con el rango y la bonificación de Crew!';

  @override
  String get crewJailbreakAttemptButton => 'Intentar fugarse';

  @override
  String get crewJailbreakActionFailed => '❌ La acción falló';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minutos de cárcel';
  }

  @override
  String get crewJailbreakRescueButton => 'Rescate';

  @override
  String get crewRoleLeader => 'Líder';

  @override
  String get crewRoleCoLeader => 'Co-líder';

  @override
  String get crewRoleMember => 'Miembro';

  @override
  String get vehicleOpsHotspot => 'Punto de acceso';

  @override
  String get vehicleOpsCrew => 'Multitud';

  @override
  String get vehicleOpsCrewMatch => 'partido de Crew';

  @override
  String get vehicleOpsChop => 'Cortar';

  @override
  String get vehicleOpsContract => 'Contrato';

  @override
  String get vehicleOpsCounter => 'Contadora';

  @override
  String get vehicleOpsContracts => 'Contratos';

  @override
  String get vehicleOpsClaims => 'Reclamos';

  @override
  String get vehicleOpsSeason => 'Estación';

  @override
  String get dashboardCar => 'Auto';

  @override
  String get dashboardMotorcycle => 'Motocicleta';

  @override
  String get dashboardBoat => 'Bote';

  @override
  String get dashboardCrewAccess => 'Acceso a la Crew';

  @override
  String get dashboardCrewRole => 'Rol de la Crew';

  @override
  String get dashboardUnavailable => 'indisponible';

  @override
  String get vehicleOps => 'Operaciones de vehículos';

  @override
  String get car => 'Auto';

  @override
  String get motorcycle => 'Motocicleta';

  @override
  String get boat => 'Bote';

  @override
  String get crewAccess => 'Acceso a la Crew';

  @override
  String get crewRole => 'Rol de la Crew';

  @override
  String get unavailable => 'indisponible';

  @override
  String get quickActionsCrimesSubtitle => 'Cometer actos criminales';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Coche, moto y barco.';

  @override
  String get quickActionsTuneShopSubtitle => 'Piezas y actualizaciones';

  @override
  String get quickActionsEventsSubtitle => 'Eventos activos y próximos';

  @override
  String get quickActionsJobsSubtitle => 'Gana dinero legal';

  @override
  String get quickActionsCasinoSubtitle => 'Apuesta tu dinero';

  @override
  String get quickActionsBankSubtitle => 'Gestiona tu saldo global';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Salud';

  @override
  String get rank => 'Rango';

  @override
  String get xp => 'experiencia';

  @override
  String get settings => 'Ajustes';

  @override
  String get avatar => 'Avatar';

  @override
  String get avatarUpdated => '¡Avatar actualizado!';

  @override
  String get avatarChangeFailed => 'No se pudo cambiar la avatar';

  @override
  String get settingsMyPortraits => 'mis retratos';

  @override
  String get settingsPortraitFromSelfieTitle => 'Retrato de selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Convierte una selfie en un retrato estilo gángster. $credits créditos cada uno.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'Esto cuesta $credits créditos. ¿Continuar?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'Acepto que mi foto pueda procesarse y convertirse en un retrato estilizado en el juego (ver Términos). No tengo menos de 13 años.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'No hay suficientes créditos (necesitas $need, tienes $have).';
  }

  @override
  String get settingsPortraitCreated => '¡Retrato añadido a tu biblioteca!';

  @override
  String get settingsPortraitGenerationFailed =>
      'No se pudo crear el retrato. Prueba con otra foto.';

  @override
  String get settingsPortraitSelectActive => 'Usar como avatar';

  @override
  String get settingsPortraitDelete => 'Quitar retrato';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Se alcanzó el límite de retratos ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Retrato personalizado activo';

  @override
  String get settingsPresetAvatars => 'avatares preestablecidos';

  @override
  String get settingsPortraitDeleteConfirm =>
      '¿Eliminar este retrato de tu biblioteca?';

  @override
  String get settingsPortraitGenerating =>
      'Creando tu retrato… Esto puede tardar unos minutos. Espere por favor.';

  @override
  String get settingsPortraitDeleteHint =>
      'Tap a portrait to use it as your avatar. Tap the trash icon to remove it.';

  @override
  String get settingsPortraitDownloadFailed =>
      'No se pudo descargar el retrato. Comprueba tu conexión y vuelve a intentarlo.';

  @override
  String get settingsPortraitDownloadTooltip =>
      'Descarga este retrato como PNG';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Elimina este retrato de tu biblioteca';

  @override
  String get settingsPortraitStyleSection => 'Mirada de retrato';

  @override
  String get settingsPortraitStyleHint =>
      'Generation utiliza el género de su cuenta desde el registro. Todos los estilos siguen siendo apropiados para el juego.';

  @override
  String get settingsPortraitStyleClassicNoir => 'negro clásico';

  @override
  String get settingsPortraitStyleStreetCasual => 'Calle casual';

  @override
  String get settingsPortraitStyleSharpSuit => 'traje afilado';

  @override
  String get settingsPortraitStyleVelvetCharm => 'Glamour nocturno';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get changeLanguage => 'Idioma / Taal';

  @override
  String get languageChanged => 'Idioma cambiado a inglés.';

  @override
  String languageChangeFailed(String code) {
    return 'Error en el cambio de idioma ($code)';
  }

  @override
  String get chooseLanguage => 'Elija idioma / Taal Kiezen';

  @override
  String get dutch => 'Países Bajos';

  @override
  String get english => 'Inglesa';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeUsername => 'Cambiar nombre de usuario';

  @override
  String get usernameHint => '3-20 caracteres';

  @override
  String get change => 'Cambiar';

  @override
  String get minChars => 'Mínimo 3 caracteres';

  @override
  String get usernameUpdated => '¡Nombre de usuario actualizado!';

  @override
  String get usernameTaken => 'Nombre de usuario ya tomado';

  @override
  String get usernameChangeFailed => 'No se pudo cambiar el nombre de usuario';

  @override
  String get oncePerMonth => 'Cambiar una vez al mes';

  @override
  String get privacy => 'Privacidad';

  @override
  String get allowMessages => 'Permitir mensajes';

  @override
  String get allowMessagesDesc => 'Otras jugadoras pueden enviarte mensajes.';

  @override
  String get settingsSystemNotificationsTitle =>
      'Notificaciones del sistema para la aplicación.';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Permiso: permitido, dispositivo vinculado';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Permiso: permitido, el dispositivo se está volviendo a vincular';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Permiso: provisional, dispositivo vinculado';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Permiso: provisional, el dispositivo se está volviendo a vincular';

  @override
  String get settingsPushPermissionDenied => 'Permiso: denegado';

  @override
  String get settingsPushPermissionNotRequested => 'Permiso: aún no solicitado';

  @override
  String get settingsPushPermissionUnknown => 'Permiso: desconocida';

  @override
  String get settingsDeviceTokenRegistered =>
      'Token de dispositivo registrado en el servidor';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Aún no se ha registrado ningún token de dispositivo';

  @override
  String get settingsPushHelpText =>
      'Utilice este botón para solicitar permiso del navegador/iPhone nuevamente y registrar su token de inserción.';

  @override
  String get working => 'Laboral...';

  @override
  String get settingsEnablePush => 'Habilitar empuje';

  @override
  String get settingsPushEnabledToast =>
      'Notificaciones push habilitadas. Ahora se recibirán nuevas notificaciones.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push está deshabilitado en la configuración de su navegador/iPhone. Habilite las notificaciones para esta aplicación.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'No se pudieron habilitar las notificaciones automáticas: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Eventos de jugadores';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push: eventos de jugadores en vivo';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Inicio y fin de eventos de competencia recurrentes (por ejemplo, rondas de máxima puntuación).';

  @override
  String get settingsCryptoNotificationsTitle =>
      'Notificaciones criptográficas';

  @override
  String get settingsCryptoPushTradesTitle => 'Empujar: Comercios';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Notificación push para operaciones de compra/venta';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: Alertas de precios';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Notificación push para movimientos de precios relevantes';

  @override
  String get settingsCryptoPushOrdersTitle => 'Empujar: Órdenes';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Notificación automática cuando se activa o completa el pedido';

  @override
  String get settingsCryptoPushMissionsTitle => 'Empujar: Misiones';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Notificación automática cuando se completa una misión criptográfica';

  @override
  String get settingsCryptoPushLeaderboardTitle =>
      'Empujar: Tabla de clasificación';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Notificación push para recompensas de la tabla de clasificación criptográfica';

  @override
  String get settingsCryptoInAppTradesTitle => 'En la aplicación: Operaciones';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Muestra eventos comerciales en tu feed de eventos';

  @override
  String get settingsCryptoInAppPriceAlertsTitle =>
      'En la aplicación: alertas de precios';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Muestra eventos de alerta de precios en tu feed de eventos';

  @override
  String get settingsCryptoInAppOrdersTitle => 'En la aplicación: pedidos';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Mostrar eventos de pedido en su feed de eventos';

  @override
  String get settingsCryptoInAppMissionsTitle => 'En la aplicación: Misiones';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Muestra las misiones completadas en el feed de tu evento';

  @override
  String get settingsCryptoInAppLeaderboardTitle =>
      'En la aplicación: tabla de clasificación';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Muestra las recompensas de la tabla de clasificación en el feed de tu evento';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Sólo puedes cambiar tu avatar una vez por semana.';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Sólo puedes cambiar tu nombre de usuario una vez al mes.';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get vipStatus => 'Estado VIP';

  @override
  String activeUntil(String date) {
    return 'Activa hasta $date';
  }

  @override
  String get unknown => 'Desconocida';

  @override
  String get chooseAvatar => 'Elige un avatar';

  @override
  String get freeAvatars => 'Avatares gratis';

  @override
  String get vipAvatars => 'Avatares VIP';

  @override
  String get vip => 'personaje';

  @override
  String get notLoggedIn => 'No iniciado sesión';

  @override
  String get refresh => 'Refrescar';

  @override
  String get foodAndDrink => 'Comida y bebida';

  @override
  String get invalidItem => 'Este artículo no existe';

  @override
  String get foodBroodje => 'Sándwich';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Hamburguesa';

  @override
  String get foodSteak => 'Bife';

  @override
  String get drinkWater => 'Agua';

  @override
  String get drinkSoda => 'Soda';

  @override
  String get drinkCoffee => 'Café';

  @override
  String get drinkBeer => 'Cerveza';

  @override
  String get foodInfo3 =>
      '• Compra comida y bebida para mantener altas tus estadísticas';

  @override
  String get foodHunger => 'Hambre';

  @override
  String get foodThirst => 'Sed';

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
      'El hambre y la sed bajan despacio. Come y bebe a tiempo.';

  @override
  String get friends => 'Amigas';

  @override
  String get friendActivity => 'Actividad de amigo';

  @override
  String get friendsUiTabActivity => 'Actividad';

  @override
  String get friendsUiTabRequests => 'Solicitudes';

  @override
  String get friendsUiTabSearch => 'Buscar';

  @override
  String get friendsUiEmptyListTitle => 'Aún no hay amigos';

  @override
  String get friendsUiEmptyListSubtitle =>
      '¡Busca jugadores y agrégalos como amigos!';

  @override
  String get friendsUiNoRequests => 'Sin solicitudes';

  @override
  String friendsUiLineRank(String rank) {
    return 'Rango: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Ubicación: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Salud: $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Amigas desde: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Eliminar amiga';

  @override
  String get friendsUiRemoveDialogBody =>
      '¿Estás seguro de que quieres eliminar a este amigo?';

  @override
  String get friendsUiRemoveConfirm => 'Eliminar';

  @override
  String get friendsUiBlockDialogTitle => 'Jugadora de bloque';

  @override
  String friendsUiBlockDialogBody(String username) {
    return '¿Estás seguro de que quieres bloquear $username? No podrás enviar ni recibir mensajes.';
  }

  @override
  String get friendsUiBlockButton => 'Bloquear';

  @override
  String get friendsUiSnackRequestSent => 'Solicitud de amistad enviada';

  @override
  String get friendsUiSnackRequestAccepted => 'Solicitud de amistad aceptada';

  @override
  String get friendsUiSnackRequestRejected => 'Solicitud de amistad rechazada';

  @override
  String get friendsUiSnackFriendRemoved => 'Amiga eliminada';

  @override
  String get friendsUiSnackPlayerBlocked => 'Jugadora bloqueada';

  @override
  String friendsUiSnackError(String details) {
    return 'Error: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Buscar reproductor';

  @override
  String get friendsUiSearchHint => 'Escribe al menos 2 caracteres';

  @override
  String get friendsUiSearchMinChars =>
      'Escribe al menos 2 caracteres para buscar';

  @override
  String get friendsUiNoPlayersFound => 'No se encontraron jugadoras';

  @override
  String get friendsUiMenuBlock => 'Bloquear';

  @override
  String get friendsUiMenuRemove => 'Eliminar';

  @override
  String get friendsUiChipFriend => 'Amiga';

  @override
  String get friendsUiChipPending => 'Pendiente';

  @override
  String get friendsUiAccept => 'Aceptar';

  @override
  String get friendsUiReject => 'Rechazar';

  @override
  String get friendsUiActivityEmpty => 'Aún no hay actividad de amigos';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Nivel $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Tripulaciones';

  @override
  String get crewUiTabMyCrew => 'Descripción general';

  @override
  String get crewUiTabCrewHq => 'Sede y actualizaciones';

  @override
  String get crewUiTabStorageHub => 'Almacenamiento';

  @override
  String get crewUiTabMembers => 'Miembros';

  @override
  String get crewUiTabWarRoom => 'Sala de guerra';

  @override
  String get crewUiTabCrewMissions => 'Misiones de Crew';

  @override
  String get crewUiTabCarStorage => 'Almacenamiento de coches/motos';

  @override
  String get crewUiTabBoatStorage => 'Almacenamiento de barcos';

  @override
  String get crewUiTabWeaponStorage => 'Almacenamiento de armas';

  @override
  String get crewUiTabAmmoStorage => 'Almacenamiento de munición';

  @override
  String get crewUiTabDrugStorage => 'Almacenamiento de medicamentos';

  @override
  String get crewUiTabCashStorage => 'Almacenamiento de efectivo';

  @override
  String get crewUiTabAllCrews => 'Tripulaciones';

  @override
  String get crewUiTabChat => 'Charlar';

  @override
  String get crewUiActionCreateCrewShort => 'Crear Crew (50.000 €)';

  @override
  String get crewUiStateNotInCrewYet => 'Aún no estás en una Crew';

  @override
  String get crewUiActionCreateCrew => 'Crear Crew (50.000 €)';

  @override
  String get crewUiLabelCrewBank => 'Banco de Crew:';

  @override
  String get crewUiLabelDeposit => 'Depósito';

  @override
  String get crewUiLabelWithdraw => 'Retirar';

  @override
  String get crewUiLabelMyTrustScore => 'Mi puntuación de confianza:';

  @override
  String get crewUiActionDeleteCrew => 'Eliminar Crew';

  @override
  String get crewUiLabelCrewStats => 'Estadísticas de la Crew:';

  @override
  String get crewUiActionLeaveCrew => 'Dejar Crew';

  @override
  String get crewUiSectionBuildings => 'Sede y actualizaciones';

  @override
  String get crewUiHintBuildingsTabs =>
      'Abra HQ y actualizaciones para administrar el HQ y todos los edificios de la Crew desde un solo lugar.';

  @override
  String get crewUiSectionCrewStorage => 'Almacenamiento de la Crew';

  @override
  String get crewUiStateNoStorageData =>
      'No hay datos de almacenamiento cargados';

  @override
  String get crewUiActionAddCar => 'Añadir coche/moto';

  @override
  String get crewUiActionAddBoat => 'Añadir barco';

  @override
  String get crewUiActionAddWeapon => 'Agregar arma';

  @override
  String get crewUiActionAddAmmo => 'Agregar munición';

  @override
  String get crewUiActionAddDrugs => 'Agregar drogas';

  @override
  String get crewUiSectionMembersOverview => 'Resumen de miembros';

  @override
  String get crewUiHintMembersTab =>
      'Abra la pestaña Miembros arriba para ver la lista de miembros y solicitar unirse.';

  @override
  String get crewUiActionGoToMembers => 'Ir a Miembros';

  @override
  String get crewUiLabelCrewHq => 'Sede de la Crew';

  @override
  String get crewUiActionGoToCrewHq => 'Ir a la sede de la Crew';

  @override
  String get crewUiActionGoToStorage => 'Ir al almacenamiento';

  @override
  String get crewUiStateJoinCrewFirst => 'Crea o únete a un equipo primero';

  @override
  String get crewUiStateJoinRequests => 'Solicitudes de unión';

  @override
  String get crewUiStateNoJoinRequests => 'No hay solicitudes pendientes';

  @override
  String get crewUiStateNoCrewsFound => 'No se encontraron tripulaciones';

  @override
  String get crewUiLabelMemberCount => 'Miembros';

  @override
  String get crewUiBadgeMyCrew => 'mi Crew';

  @override
  String get crewUiActionJoin => 'Unirse';

  @override
  String get crewUiStateNotInCrew => 'No estás en una Crew';

  @override
  String get crewUiHintChatJoinCrew =>
      '¡Crea o únete a un equipo para chatear!';

  @override
  String get crewUiStatusNotOwned => 'No propiedad';

  @override
  String get crewUiLabelLevel => 'Nivel';

  @override
  String get crewUiLabelCapacity => 'Capacidad';

  @override
  String get crewUiLabelMemberCap => 'Límite de miembros';

  @override
  String get crewUiLabelParking => 'Aparcamiento';

  @override
  String get crewUiActionPurchase => 'Compra';

  @override
  String get crewUiActionUpgrade => 'Mejora';

  @override
  String get crewUiActionDetails => 'Detalles';

  @override
  String get crewUiHelpCapsTitle => 'Resumen de niveles';

  @override
  String get crewUiHelpLevel => 'Nivel';

  @override
  String get crewUiHelpCapacity => 'Tapa';

  @override
  String get crewUiHelpUpgradeCost => 'Costo';

  @override
  String get crewUiHelpClose => 'Cerca';

  @override
  String get crewUiHelpShowCaps => 'Mostrar gorras';

  @override
  String get crewUiSectionUpgradeHub => 'Sede y actualizaciones';

  @override
  String get crewUiSectionStorageHub => 'Centro de almacenamiento';

  @override
  String get crewUiHintStorageTab =>
      'Utilice la pestaña Almacenamiento para depósitos, saldos y acciones de almacenamiento rápido.';

  @override
  String get crewUiHintUpgradeHub =>
      'Administre el cuartel general y todas las actualizaciones de la Crew desde un solo lugar aquí.';

  @override
  String get crewUiSectionCrewMissions => 'Misiones de Crew';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Aún no hay misiones de Crew disponibles';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Únete o crea una Crew para iniciar misiones.';

  @override
  String get crewUiActionStartMission => 'Iniciar misión';

  @override
  String get crewUiActionConfigureAndStartMission => 'Configurar y comenzar';

  @override
  String get crewUiActionResolveMission => 'Resolver misión';

  @override
  String get crewUiActionClaimRewards => 'Reclamar recompensas';

  @override
  String get crewUiActionSpeedupCooldown =>
      'Acelerar el tiempo de reutilización';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Confirmar acelerar';

  @override
  String get crewUiLabelActiveMission => 'Misión activa';

  @override
  String get crewUiLabelRecentMissions => 'Misiones recientes';

  @override
  String get crewUiLabelMissionDuration => 'Duración';

  @override
  String get crewUiLabelMissionCooldown => 'Enfriarse';

  @override
  String get crewUiLabelMissionTier => 'Nivel';

  @override
  String get crewUiLabelMissionRewards => 'Recompensas';

  @override
  String get crewUiLabelMissionTradeCargo =>
      'Carga comercial (almacén de crew)';

  @override
  String get crewUiHintMissionTradeCargo =>
      'Deposita las mercancías indicadas en el almacén del crew antes de empezar.';

  @override
  String get crewUiErrorMissionTradeRequirementsNotMet =>
      'No hay suficientes mercancías en el almacén del crew para esta misión.';

  @override
  String get crewUiLabelCrewMissionProgress =>
      'Progresión de la misión de la Crew';

  @override
  String get crewUiLabelCrewMissionXp => 'XP de misión de Crew';

  @override
  String get crewUiLabelCrewMissionLevelBonus =>
      'Bono en efectivo para la Crew';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus =>
      'Bonificación del siguiente nivel';

  @override
  String get crewUiLabelMissionStatus => 'Estado';

  @override
  String get crewUiLabelCooldownActive => 'Enfriamiento activo';

  @override
  String get crewUiLabelRoleContributions => 'Contribuciones de roles';

  @override
  String get crewUiLabelContribution => 'contribución';

  @override
  String get crewUiLabelMultiplier => 'multiplicadora';

  @override
  String get crewUiStatusMissionLocked => 'Bloqueada';

  @override
  String get crewUiStatusInProgress => 'En curso';

  @override
  String get crewUiStatusCompleted => 'Terminada';

  @override
  String get crewUiStatusReady => 'Listo';

  @override
  String get crewUiStatusRewardsClaimed => 'Recompensas reclamadas';

  @override
  String get crewUiStateMissionActionBusy => 'La acción se está procesando...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Sólo el líder/colíder puede iniciar y resolver misiones.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Asignar roles';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Elija un rol de misión por miembro de la Crew.';

  @override
  String get crewUiLabelRoleNone => 'No asignado';

  @override
  String get crewUiLabelRolePlanner => 'Planificadora';

  @override
  String get crewUiLabelRoleEnforcer => 'ejecutor';

  @override
  String get crewUiLabelRoleLogistics => 'Logística';

  @override
  String get crewUiLabelRoleTech => 'tecnología';

  @override
  String get crewUiHintRoleBonus =>
      'Cada rol único: +3% de probabilidad de éxito, -2% de duración (máx. +12% / -8%).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'No se encontraron miembros de la Crew.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Seleccione al menos 1 rol.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'El nivel 2 requiere miembros HQ 5+ y 2+.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'El nivel 3 requiere miembros HQ 9+ y 3+.';

  @override
  String get crewUiHintMissionLockedDefault =>
      'La misión todavía está bloqueada.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'No se pudieron cargar las misiones de la Crew.';

  @override
  String get crewUiMessageMissionStarted => 'Misión iniciada';

  @override
  String get crewUiMessageMissionResolved => 'Misión resuelta';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Recompensas reclamadas';

  @override
  String get crewUiMessageMissionCooldownSpedUp => 'El enfriamiento se aceleró';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'No se pudo cargar el precio de aceleración.';

  @override
  String get crewUiDialogSpeedupTitle =>
      '¿Acelerar el tiempo de reutilización?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'La finalización instantánea cuesta $credits créditos (queda $minutes min).';
  }

  @override
  String get crewUiLabelCredits => 'créditos';

  @override
  String get crewUiStateLoadingPrice => 'Cargando precio...';

  @override
  String get crewUiActionCancel => 'Cancelar';

  @override
  String get crewUiHintMissionUnlockCta =>
      'Las misiones de nivel alto se abren cuando crecen el HQ y la crew. Mejora el HQ o recluta para Tier 2+.';

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
    return 'Primero mejora todos los edificios laterales al menos al nivel $level. \n\nFalta: \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 minuto';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get crewUiMissionNoHistory => 'Aún no hay antecedentes.';

  @override
  String get crewUiBuildingHq => 'Sede de la Crew';

  @override
  String get crewUiBuildingCarStorage => 'Almacenamiento de coches/motos';

  @override
  String get crewUiBuildingBoatStorage => 'Almacenamiento de barcos';

  @override
  String get crewUiBuildingWeaponStorage => 'Almacenamiento de armas';

  @override
  String get crewUiBuildingAmmoStorage => 'Almacenamiento de munición';

  @override
  String get crewUiBuildingDrugStorage => 'Almacenamiento de medicamentos';

  @override
  String get crewUiBuildingCashStorage => 'Almacenamiento de efectivo';

  @override
  String get crewUiWarActionKill => 'Matar';

  @override
  String get crewUiWarActionMug => 'Taza';

  @override
  String get crewUiWarActionSabotage => 'Sabotaje';

  @override
  String get crewUiWarActionIntel => 'Intel';

  @override
  String get crewUiWarActionRaid => 'RAID';

  @override
  String get crewUiWarActionShield => 'Blindaje';

  @override
  String get crewUiWarActionBoost => 'Aumentar';

  @override
  String get crewUiWarActionTerritory => 'Territorio';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count miembros)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Error al cargar mensajes: $error';
  }

  @override
  String get crewChatMessageTooLong =>
      'Mensaje demasiado largo (máximo 500 caracteres)';

  @override
  String crewChatErrorSending(String error) {
    return 'Error al enviar mensaje: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'No se pudo eliminar el mensaje: $error';
  }

  @override
  String get crewChatDeleteTitle => '¿Eliminar mensaje?';

  @override
  String get crewChatDeleteBody =>
      'Este mensaje será eliminado permanentemente.';

  @override
  String get crewChatCancel => 'Cancelar';

  @override
  String get crewChatDelete => 'Borrar';

  @override
  String get crewChatNoMessages => 'Aún no hay mensajes';

  @override
  String get crewChatEmptyHint => '¡Envía el primer mensaje a tu equipo!';

  @override
  String get aviationUiBuyConfirmTitle => '¿Comprar aviones?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return '¿Quieres comprar $name por $price?';
  }

  @override
  String get aviationUiPurchaseFailed => 'Compra fallida.';

  @override
  String get aviationUiPurchasedSuccess => 'Aviones comprados.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'Licencia activa ($type). Actualice para aviones más pesados ​​si es necesario. También se requiere formación de piloto completa (certificados de Aviación 5 +).';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'School Aviation 5/5 por sí solo no es suficiente: compre una licencia de aviación paga aquí antes de poder comprar aviones.';

  @override
  String get aviationUiLicensesTitle => 'Licencias de aviación';

  @override
  String get aviationUiLicenseBasic => 'Básico (ligero / turbohélice)';

  @override
  String get aviationUiLicenseCommercial =>
      'Comercial (jets de negocios/de lujo)';

  @override
  String get aviationUiLicenseCargo => 'Carga (carga y cargueros pesados)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Clasificación mínima $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Comprar licencia';

  @override
  String get aviationUiUpgradeLicense => 'Licencia de actualización';

  @override
  String get aviationUiLicenseBuyConfirmTitle =>
      '¿Comprar licencia de aviación?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return '¿Comprar $name por $price? Requiere escuela de aviación completa (nivel 5 + certificaciones).';
  }

  @override
  String get aviationUiLicensePurchaseFailed =>
      'Error en la compra de la licencia.';

  @override
  String get aviationUiLicensePurchasedSuccess =>
      'Licencia de aviación adquirida.';

  @override
  String get aviationUiYourAircraft => 'Tu avión';

  @override
  String get aviationUiNoOwnedAircraft => 'Aún no posee ningún avión.';

  @override
  String get aviationUiAvailableAircraft => 'Aviones disponibles';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Combustible: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Precio: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Rango mínimo: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Velocidad x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Carga: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Aeronave';

  @override
  String aviationUiLoadError(String error) {
    return 'No se pudieron cargar datos de aviación: $error';
  }

  @override
  String get aviationHeroTitle => 'El hangar';

  @override
  String get aviationHeroSubtitle =>
      'Termine la escuela de aviación, compre una licencia paga y luego compre un avión para viajar más rápido y contrabandear.';

  @override
  String aviationSchoolChip(String level) {
    return 'Escuela $level/5';
  }

  @override
  String aviationCertsChip(String count) {
    return 'Certificados de vuelo $count/2';
  }

  @override
  String get aviationNoLicenseChip => 'Sin licencia paga';

  @override
  String aviationOwnedCountChip(String count) {
    return '$count avión';
  }

  @override
  String get aviationOwnedBadge => 'Propiedad';

  @override
  String get aviationHangarEmptyHint =>
      'Primero compre una licencia paga y luego elija un avión a continuación.';

  @override
  String aviationRequiresLicense(String name) {
    return 'Necesidades $name';
  }

  @override
  String get aviationRankLocked => 'Clasificación demasiado baja';

  @override
  String get aviationRefuel => 'Repostar';

  @override
  String get aviationRefuelConfirmTitle => '¿Repostar aviones?';

  @override
  String aviationRefuelConfirmBody(String liters, String price) {
    return '¿Llenar el tanque con $liters L para $price?';
  }

  @override
  String get aviationRefuelSuccess => 'Aviones repostados.';

  @override
  String get aviationRefuelFailed => 'Falló el repostaje.';

  @override
  String get aviationRefuelFull => 'El tanque ya está lleno.';

  @override
  String get aviationFlyConfirmTitle => '¿Volar ahora?';

  @override
  String aviationFlyConfirmBody(String name, String country) {
    return '¿Volar $name a $country? Consume 100 L y llega al instante.';
  }

  @override
  String get aviationFlyPickDestination => 'Elige destino';

  @override
  String get aviationFlySuccess => 'Aterrizaste.';

  @override
  String get aviationFlyFailed => 'El vuelo falló.';

  @override
  String get aviationFlyNeedFuel =>
      'No hay suficiente combustible. Un vuelo consume 100 L.';

  @override
  String get aviationFlyBroken =>
      'Este avión está averiado y primero debe repararse.';

  @override
  String get aviationSellConfirmTitle => '¿Vender aviones?';

  @override
  String aviationSellConfirmBody(String name, String price) {
    return '¿Vender $name por $price? Obtienes el 50% del precio de compra.';
  }

  @override
  String get aviationSoldSuccess => 'Aviones vendidos.';

  @override
  String get aviationSellFailed => 'La venta fracasó.';

  @override
  String get aviationRepair => 'Reparar';

  @override
  String get aviationRepairConfirmTitle => '¿Reparar aviones?';

  @override
  String aviationRepairConfirmBody(String name, String price) {
    return '¿Reparar $name por $price?';
  }

  @override
  String get aviationRepairSuccess => 'Aviones reparados.';

  @override
  String get aviationRepairFailed => 'La reparación falló.';

  @override
  String get aviationBrokenBadge => 'Rota';

  @override
  String aviationTravelBonusChip(String percent) {
    return '−$percent% tiempo de viaje';
  }

  @override
  String get crewUiTr0 => 'Requisitos de actualización de la sede';

  @override
  String get crewUiTr1 =>
      'Mejora tu estilo HQ actual al nivel máximo para desbloquear el siguiente estilo';

  @override
  String get crewUiTr2 => 'Se alcanzó el estilo final del cuartel general';

  @override
  String get crewUiTr3 => 'Se requiere sede VIP para los niveles 11-15';

  @override
  String get crewUiTr4 =>
      'Primero mejora todos los edificios laterales al nivel requerido para este estilo de cuartel general.';

  @override
  String get crewUiTr5 => 'Edificio ya en propiedad';

  @override
  String get crewUiTr6 => 'Fondos insuficientes en el banco de la Crew';

  @override
  String get crewUiTr7 =>
      'La progresión del cuartel general es demasiado baja para esta actualización.';

  @override
  String get crewUiTr8 => 'Se requiere Crew VIP para el nivel 11+';

  @override
  String get crewUiTr9 =>
      'Se alcanzó el depósito inicial. Compra almacenamiento de efectivo primero para desbloquear más espacio en el banco de la Crew.';

  @override
  String get crewUiTr10 => 'La acción falló';

  @override
  String get crewUiTr11 => 'Ya hay una misión de Crew activa.';

  @override
  String get crewUiTr12 =>
      'Un tiempo de reutilización de la misión todavía está activo. Espera a que termine o acelera con créditos.';

  @override
  String get crewUiTr13 => 'Misión no encontrada.';

  @override
  String get crewUiTr14 => 'Este nivel todavía está bloqueado.';

  @override
  String get crewUiTr15 => 'No se encontró la ejecución de la misión.';

  @override
  String get crewUiTr16 => 'La misión ya está resuelta.';

  @override
  String get crewUiTr17 => 'La misión aún no está completada.';

  @override
  String get crewUiTr18 => 'Sin tiempo de reutilización activo.';

  @override
  String get crewUiTr19 => 'Créditos insuficientes.';

  @override
  String get crewUiTr20 => 'No se pudo iniciar la misión.';

  @override
  String get crewUiTr21 => 'No se pudo resolver la misión.';

  @override
  String get crewUiTr22 => 'No se pudieron reclamar recompensas.';

  @override
  String get crewUiTr23 => 'No se pudo acelerar el tiempo de reutilización.';

  @override
  String get crewUiTr24 => 'No estás en una Crew.';

  @override
  String get crewUiTr25 => 'Solo la líder de la Crew puede hacer esto.';

  @override
  String get crewUiTr26 => 'Crew objetivo no encontrada.';

  @override
  String get crewUiTr27 => 'Esta Crew ya está en una guerra.';

  @override
  String get crewUiTr28 => 'Se requieren al menos 3 miembros de Crew.';

  @override
  String get crewUiTr29 => 'Guerra no encontrada.';

  @override
  String get crewUiTr30 => 'Esta guerra no está activa.';

  @override
  String get crewUiTr31 => 'No puedes unirte a esta guerra ahora mismo.';

  @override
  String get crewUiTr32 => 'Esta acción requiere una jugadora objetivo.';

  @override
  String get crewUiTr33 => 'Bloqueo anti-granja: elige otro objetivo.';

  @override
  String get crewUiTr34 => 'Se requiere un jugador VIP para esta acción.';

  @override
  String get crewUiTr35 => 'Se requiere un equipo VIP para esta acción.';

  @override
  String get crewUiTr36 => 'Límite de acción alcanzado por ahora.';

  @override
  String crewUiTr37(String remaining) {
    return 'Enfriamiento activo: espera $remaining minutos más.';
  }

  @override
  String get crewUiTr38 => 'Territorio no válido seleccionado.';

  @override
  String get crewUiTr39 => 'La acción de guerra de la Crew fracasó.';

  @override
  String get crewUiTr40 => 'Jugadora objetivo';

  @override
  String get crewUiTr41 => 'mata';

  @override
  String get crewUiTr42 => 'Fallecidas';

  @override
  String get crewUiTr43 => 'Cancelar';

  @override
  String get crewUiTr44 => 'Confirmar';

  @override
  String get crewUiTr45 => 'Líder';

  @override
  String get crewUiTr46 => 'Co-líder';

  @override
  String get crewUiTr47 => 'Miembro';

  @override
  String get crewUiTr48 => 'Capital';

  @override
  String get crewUiTr49 => 'Puerto';

  @override
  String get crewUiTr50 => 'Industria';

  @override
  String get crewUiTr51 => 'Borde';

  @override
  String get crewUiTr52 => 'Logística';

  @override
  String get crewUiTr53 => 'Afirmar';

  @override
  String get crewUiTr54 => 'Garrapata';

  @override
  String get crewUiTr55 => 'Seleccionar territorio';

  @override
  String get crewUiTr56 => 'Primero selecciona un equipo objetivo.';

  @override
  String get crewUiTr57 => 'Se declara la guerra entre tripulaciones.';

  @override
  String get crewUiTr58 => 'No se pudo declarar la guerra a la Crew.';

  @override
  String get crewUiTr59 => 'Te uniste a la guerra.';

  @override
  String get crewUiTr60 => 'No pudo unirse a la guerra.';

  @override
  String get crewUiTr61 => 'Acción de guerra de tripulaciones completada.';

  @override
  String get crewUiTr62 => 'matar guerra';

  @override
  String get crewUiTr63 => 'Guerra económica';

  @override
  String get crewUiTr64 => 'Guerra territorial';

  @override
  String get crewUiTr65 => 'Guerra total';

  @override
  String get crewUiTr66 => 'Preparante';

  @override
  String get crewUiTr67 => 'Activa';

  @override
  String get crewUiTr68 => 'Aislamiento';

  @override
  String get crewUiTr69 => 'Resuelta';

  @override
  String get crewUiTr70 => 'Archivada';

  @override
  String get crewUiTr71 => 'Cancelada';

  @override
  String get crewUiTr72 => 'Crew VIP';

  @override
  String get crewUiTr73 => '9,99€/mes';

  @override
  String get crewUiTr74 => '4,99€/mes';

  @override
  String get crewUiTr75 => 'Compras únicas';

  @override
  String get crewUiTr76 => 'Sólo el líder puede comprar Crew VIP.';

  @override
  String get crewUiTr77 => 'Producto no válido';

  @override
  String get crewUiTr78 => 'Error al abrir la página de pago';

  @override
  String get crewUiTr79 => 'Estas segura';

  @override
  String get crewUiTr80 => 'dejar la Crew';

  @override
  String get crewUiTr81 => '¿Estás seguro de que quieres dejar la Crew?';

  @override
  String get crewUiTr82 => 'Dejar';

  @override
  String get crewUiTr83 => 'Crew izquierda';

  @override
  String get crewUiTr84 => 'Depósito al banco de la Crew';

  @override
  String get crewUiTr85 => 'Retirar del banco de Crew';

  @override
  String get crewUiTr86 => 'Cantidad';

  @override
  String get crewUiTr87 => 'Cantidad no válida';

  @override
  String get crewUiTr88 => 'No hay suficiente efectivo disponible';

  @override
  String get crewUiTr89 =>
      'Primero compre almacenamiento de efectivo para el banco de la Crew.';

  @override
  String get crewUiTr90 =>
      'El almacenamiento de efectivo de la Crew está lleno';

  @override
  String get crewUiTr91 => 'Eliminar Crew';

  @override
  String get crewUiTr92 =>
      '¿Estás seguro de que quieres eliminar este equipo? Esto no se puede deshacer.';

  @override
  String get crewUiTr93 => 'Borrar';

  @override
  String get crewUiTr94 => 'Siguiente nivel';

  @override
  String get crewUiTr95 => 'Costo';

  @override
  String get crewUiTr96 => 'Nivel máximo alcanzado';

  @override
  String get crewUiTr97 => 'Edificio sin propiedad';

  @override
  String get crewUiTr98 => 'Añadir coche/moto';

  @override
  String get crewUiTr99 => 'Añadir barco';

  @override
  String get crewUiTr100 => 'Motocicleta';

  @override
  String get crewUiTr101 => 'Bote';

  @override
  String get crewUiTr102 => 'Auto';

  @override
  String get crewUiTr103 => 'Seleccionar';

  @override
  String get crewUiTr104 => 'Agregar';

  @override
  String get crewUiTr105 => 'Agregar arma';

  @override
  String get crewUiTr106 => 'Arma';

  @override
  String get crewUiTr107 => 'Cantidad';

  @override
  String get crewUiTr108 => 'Agregar munición';

  @override
  String get crewUiTr109 => 'tipo de munición';

  @override
  String get crewUiTr110 => 'Añadir bienes';

  @override
  String get crewUiTr111 => 'tipo de bienes';

  @override
  String get crewUiTr112 => 'Únete a un equipo primero para usar Crew Wars.';

  @override
  String get crewUiTr113 =>
      'No hay miembros de la Crew oponente disponibles para apuntar.';

  @override
  String get crewUiTr114 => 'Seleccionar jugador objetivo';

  @override
  String get crewUiTr115 => 'Resumen de la temporada';

  @override
  String get crewUiTr116 => 'Temporada activa';

  @override
  String get crewUiTr117 => 'mi papel';

  @override
  String get crewUiTr118 => 'La Crew puede declarar';

  @override
  String get crewUiTr119 => 'Sí';

  @override
  String get crewUiTr120 => 'No';

  @override
  String get crewUiTr121 => 'Declarar nueva guerra';

  @override
  String get crewUiTr122 => 'Crew objetivo';

  @override
  String get crewUiTr123 => 'tipo de guerra';

  @override
  String get crewUiTr124 => 'Declarar la guerra';

  @override
  String get crewUiTr125 => 'Territorios de guerra';

  @override
  String get crewUiTr126 => 'Neutral';

  @override
  String get crewUiTr127 => 'Crew oponente';

  @override
  String get crewUiTr128 => 'Activa desde';

  @override
  String get crewUiTr129 => 'unirse a la guerra';

  @override
  String get crewUiTr130 => 'Clasificación';

  @override
  String get crewUiTr131 => 'Territorios';

  @override
  String get crewUiTr132 => 'Acciones recientes';

  @override
  String get crewUiTr133 => 'Aún no hay acciones de guerra.';

  @override
  String get crewUiTr134 => 'vs';

  @override
  String get crewUiTr135 => 'Tabla de clasificación de la temporada';

  @override
  String get crewUiTr136 => 'Aún no hay puntos de temporada.';

  @override
  String get crewUiTr137 => 'Botín';

  @override
  String get crewUiTr138 => 'Guerras recientes';

  @override
  String get crewUiTr139 => 'Aún no hay guerras recientes.';

  @override
  String get crewUiTr140 => 'Sólo el líder puede comprar o actualizar';

  @override
  String get crewUiTr141 =>
      'Actualización del cuartel general bloqueada: los edificios laterales primero en L\$requiredSideLevel';

  @override
  String get crewUiTr142 => 'La próxima actualización aún no está disponible';

  @override
  String get crewUiTr143 => 'Progresión del cuartel general demasiado baja';

  @override
  String get crewUiTr144 =>
      'Nivel de cuartel general demasiado bajo para la próxima actualización';

  @override
  String get premiumUiLoadError => 'No se pudieron cargar los datos premium.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Compra recibida. Actualización de sus créditos y descripción general de las primas.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Pago VIP de la Crew recibido. Actualizando su descripción general premium.';

  @override
  String get premiumUiRedirectPaidVip =>
      'Pago VIP recibido. Actualizando su descripción general premium.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Compra cancelada.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Pago cancelado.';

  @override
  String get premiumUiRedirectFailedOneTime => 'Compra fallida o caducada.';

  @override
  String get premiumUiRedirectFailedSubscription => 'El pago falló o expiró.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'No se pudo abrir la página de pago.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Este artículo requiere una selección de vehículo y se canjeará desde la pantalla del vehículo.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Créditos canjeados.';

  @override
  String get premiumUiRedeemFailed => 'No se pudieron canjear los créditos.';

  @override
  String get premiumUiPerMonthShort => 'mes';

  @override
  String get premiumUiCreditThemeCashBoost => 'Aumento de efectivo';

  @override
  String get premiumUiCreditThemeSecurity => 'Seguridad';

  @override
  String get premiumUiCreditThemeGarage => 'Cochera';

  @override
  String get premiumUiCreditThemeTuneShop => 'Tienda de melodías';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Enfriamiento: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset => 'Reinicio de enfriamiento';

  @override
  String get premiumUiCreditThemeEvents => 'Eventos';

  @override
  String get premiumUiCreditThemePremium => 'De primera calidad';

  @override
  String get premiumUiKpiPlayerVip => 'Jugadora VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew VIP';

  @override
  String get premiumUiCreditsLabel => 'Créditos';

  @override
  String get premiumUiStatusActive => 'Activa';

  @override
  String get premiumUiStatusInactive => 'Inactiva';

  @override
  String get premiumUiNoCrew => 'Sin Crew';

  @override
  String get premiumUiSectionVipTitle => 'Suscripciones VIP';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Mosaicos VIP profesionales con precios, estados y beneficios claros.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Beneficios de cuenta exclusivos, desbloqueos de avatar y calidad de vida premium.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Activa hasta $date';
  }

  @override
  String get premiumUiBadgeVip => 'personaje';

  @override
  String get premiumUiExtendVip => 'Ampliar VIP';

  @override
  String get premiumUiBuyVip => 'Comprar VIP';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'Beneficios VIP para jugadores';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Beneficios VIP para jugadores: \n- Tiempos de espera/enfriamiento de acción un 10% más cortos (el tiempo de cárcel permanece sin cambios). \n- En Drug Production, obtienes un botón de relámpago VIP en cada tarjeta de producción para comprar los materiales que faltan con un solo clic (después de la confirmación del costo). \n- Al fallecer, pierde efectivo disponible pero reinicia con 500.000 EUR en efectivo. \n- Tu rango se reduce a la mitad en lugar de reiniciarse por completo. \n- Se conservan el progreso educativo y los logros desbloqueados. \n- Se conservan el saldo bancario y las criptomonedas. \n- Se retiran propiedades, vehículos, prostitutas, inventario llevado y artículos almacenados. \n- Se restablecen el progreso y el stock de medicamentos. \n- Recibes 100 créditos premium semanalmente mientras VIP esté activo.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Debes estar en una Crew antes de poder activar Crew VIP.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Para mejoras de Crew, edificios secundarios de nivel 11-15 y ventajas compartidas.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Se necesita Crew';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Se requiere Crew';

  @override
  String get premiumUiExtendCrewVip => 'Ampliar Crew VIP';

  @override
  String get premiumUiBuyCrewVip => 'Comprar Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Beneficios VIP para la Crew';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Debes unirte a un equipo antes de comprar Crew VIP. Crew VIP desbloquea ventajas centradas en la Crew y una mayor progresión de mejoras.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'Crew VIP otorga acceso a mejoras adicionales para la Crew y ventajas premium compartidas para el flujo de tu Crew. Después de la compra, el estado activo y el vencimiento se actualizan inmediatamente.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Comprar créditos';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Elija un paquete a través de mosaicos visuales. La popular opción de 1.000 créditos recibe su propia atención.';

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
      'No hay paquetes de crédito activos en este momento.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Paquete de crédito';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Créditos instantáneos para tu billetera premium.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Comprar $amount créditos';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count créditos';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Ultra oferta';

  @override
  String get premiumUiBadgeTopDeal => 'Oferta superior';

  @override
  String get premiumUiBadgeCredits => 'Créditos';

  @override
  String premiumUiCreditOfferInfo(
    String buyLine,
    String price,
    String description,
  ) {
    return '$buyLine para $price. \n\n$description';
  }

  @override
  String get premiumUiSectionShopTitle => 'tienda de credito';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Cada artículo utiliza un mosaico temático según el efecto que estás comprando.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Artículo premium';

  @override
  String get premiumUiShopItemFallbackDescription =>
      'Beneficio premium directo.';

  @override
  String get premiumUiShopNoActiveCooldown =>
      'Sin tiempo de reutilización activo';

  @override
  String get premiumUiShopNotEnoughCredits => 'No hay suficientes créditos';

  @override
  String get premiumUiShopRedeem => 'Canjear';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nTema: $theme \nCosto: $cost créditos';
  }

  @override
  String get premiumUiBadgeShop => 'Comercio';

  @override
  String get premiumUiActiveEffectsTitle => 'Efectos premium activos';

  @override
  String get premiumUiIntroSubtitle =>
      'Los jugadores administran aquí suscripciones VIP, paquetes de crédito y artículos de la tienda de crédito.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

  @override
  String get propertiesAvailable => 'Disponible';

  @override
  String get myProperties => 'Mis propiedades';

  @override
  String get errorLoadingMyProperties => 'Error al cargar mis propiedades';

  @override
  String get errorBuyingProperty => 'Error al comprar propiedad';

  @override
  String get errorCollectingIncome => 'Error al cobrar ingresos';

  @override
  String get noAvailableProperties => 'No hay propiedades disponibles';

  @override
  String get noOwnedProperties => 'Aún no posees ninguna propiedad';

  @override
  String get buyFirstPropertyHint =>
      'Compra tu primera propiedad en la pestaña \"Disponible\"';

  @override
  String buyPropertyConfirm(String name, String price) {
    return '¿Quieres comprar $name por $price€?';
  }

  @override
  String get propertyPrice => 'Precio';

  @override
  String get propertyMinLevel => 'Nivel requerido';

  @override
  String get propertyIncomePerHour => 'Ingresos/hora';

  @override
  String get propertyMaxLevel => 'Nivel máximo';

  @override
  String get propertyUniquePerCountry => '⚠️ Único - 1 por país';

  @override
  String get propertyIncomeReady => '✅ ¡Ingresos listos para cobrar!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Próximo ingreso en $duration';
  }

  @override
  String get propertyBuyAction => 'Comprar Propiedad';

  @override
  String get propertyCollectAction => 'Recolectar';

  @override
  String get propertyUpgradeAction => 'Mejora';

  @override
  String get propertyMax => 'MÁXIMO';

  @override
  String propertyLevel(String level) {
    return 'Nivel $level';
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
  String get propertyTypeWarehouse => 'Depósito';

  @override
  String get propertyTypeCasino => 'Casino';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Fábrica';

  @override
  String get propertyTypeBusiness => 'Negocio';

  @override
  String get propertyCasinoName => 'Casino';

  @override
  String get propertyWarehouseName => 'Depósito';

  @override
  String get propertyNightclubName => 'Club nocturno';

  @override
  String get propertyHouseName => 'Casa';

  @override
  String get propertyApartmentName => 'Departamento';

  @override
  String get propertyShopName => 'Comercio';

  @override
  String get propertiesConfirmPurchaseTitle => 'Estas segura';

  @override
  String get propertyTypeApartment => 'Departamento';

  @override
  String get propertyTypeNightclub => 'Club nocturno';

  @override
  String get propertyTypeShop => 'Comercio';

  @override
  String get propertyStatStorageLabel => '📦 Almacenamiento';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to espacios';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Capacidad de vivienda';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to trabajadoras';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount ranuras';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current trabajadoras (máximo $max a nivel $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current trabajadores • máx.';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count espacios adicionales';
  }

  @override
  String get propertyManageNightclub => 'Administrar discoteca';

  @override
  String get blackMarket => 'Mercado negro';

  @override
  String get blackMarketShops => 'Tiendas';

  @override
  String get blackMarketPlayerMarket => 'Mercado de jugadores';

  @override
  String get blackMarketSubtitle =>
      'Compra al traficante o comercia con otros jugadores.';

  @override
  String get garage => 'Cochera';

  @override
  String get garageCapacity => 'Capacidad del garaje';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total vehículos';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Mejora (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Nivel máximo';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Nivel $level | $spots quedan plazas';
  }

  @override
  String get noCarsInGarage => 'No hay coches en tu garaje.';

  @override
  String get stealCarsToStart => '¡Roba algunos autos para comenzar!';

  @override
  String get stealFailed => 'Robo fallido';

  @override
  String get garageUpgradeFailed => 'No se pudo actualizar el garaje';

  @override
  String get saleFailed => 'Venta fallida';

  @override
  String get vehicleTransported => '¡Vehículo transportado con éxito!';

  @override
  String get vehicleTransportFailed => 'No se pudo transportar el vehículo';

  @override
  String get listOnMarket => 'Listar en el mercado';

  @override
  String marketValue(String amount) {
    return 'Valor de Mercado: €$amount';
  }

  @override
  String get askingPrice => 'Precio de venta (€)';

  @override
  String get enterPrice => 'Introduce el precio';

  @override
  String get list => 'Lista';

  @override
  String get invalidPrice => 'Precio no válido';

  @override
  String get vehicleListed => '¡Vehículo listado en el mercado!';

  @override
  String get listVehicleFailed => 'No se pudo enumerar el vehículo';

  @override
  String get marina => 'Puerto pequeño';

  @override
  String get hospital => 'Hospital';

  @override
  String get court => 'Corte';

  @override
  String get casino => 'Casino';

  @override
  String get errorLoadingCasinoStatus =>
      'No se pudo verificar el estado del casino';

  @override
  String get errorLoadingCasinoGames =>
      'No se pudieron cargar juegos de casino';

  @override
  String casinoPrice(String amount) {
    return 'Precio: €$amount';
  }

  @override
  String get startingCapital => 'Capital inicial';

  @override
  String get bankrollHelper => 'Este será el bankroll del casino';

  @override
  String get casinoOwnershipInfoTitle => 'Acerca de la propiedad del casino:';

  @override
  String get casinoClosedTitle => 'CASINO CERRADO';

  @override
  String get casinoOwnedByLabel => 'Este casino es propiedad de:';

  @override
  String get casinoNoOwner => 'Este casino aún no tiene dueño';

  @override
  String get casinoPurchasePriceLabel => 'Precio de compra:';

  @override
  String get casinoOwnerInfo =>
      '¡Como propietario, administras los fondos del casino y ganas dinero cuando los jugadores pierden!';

  @override
  String get casinoGameSlotsName => 'Tragaperras';

  @override
  String get casinoGameSlotsDesc =>
      '¡Gira los carretes y gana hasta 100 veces tu apuesta!';

  @override
  String get casinoGameBlackjackName => 'Veintiuna';

  @override
  String get casinoGameBlackjackDesc =>
      '¡Vence al crupier y gana hasta el doble de tu apuesta!';

  @override
  String get casinoGameRouletteName => 'Ruleta';

  @override
  String get casinoGameRouletteDesc =>
      '¡Elija su número y gane hasta 35 veces su apuesta!';

  @override
  String get casinoGameDiceName => 'Dados';

  @override
  String get casinoGameDiceDesc =>
      '¡Tira los dados y gana hasta 6 veces tu apuesta!';

  @override
  String get difficultyEasy => 'FÁCIL';

  @override
  String get difficultyMedium => 'MEDIO';

  @override
  String get difficultyHard => 'DURA';

  @override
  String get casinoDepositTitle => 'Depositar dinero';

  @override
  String get casinoWithdrawTitle => 'Retirar dinero';

  @override
  String get amount => 'Cantidad';

  @override
  String get deposit => 'Depósito';

  @override
  String get withdraw => 'Retirar';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount depositados en los fondos del casino';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount retirado de los fondos del casino';
  }

  @override
  String get casinoDepositError => 'Error al depositar';

  @override
  String get casinoWithdrawError => 'Error al retirar';

  @override
  String get casinoMinBankroll =>
      'Deben quedar al menos 10.000 € en el bankroll';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Máximo: €$amount';
  }

  @override
  String get casinoManagementTitle => 'Gestión de casinos';

  @override
  String casinoBankruptWarning(String amount) {
    return 'ADVERTENCIA: ¡Los fondos del casino son demasiado bajos! \nDeposita al menos$amount€ para evitar la quiebra.';
  }

  @override
  String get casinoBankroll => 'Fondos del casino';

  @override
  String get casinoStatsTitle => 'Estadística';

  @override
  String get casinoTotalReceived => 'Total recibida:';

  @override
  String get casinoTotalPaidOut => 'Total pagado:';

  @override
  String get casinoNetProfit => 'Beneficio neto:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Margen de beneficio: $percent%';
  }

  @override
  String get casinoManagementInfoTitle => 'Información de gestión del casino';

  @override
  String get casinoManagementInfo5 =>
      '• Puedes depositar o retirar dinero en cualquier momento';

  @override
  String get casinoHubChooseGameHint => 'Elige un juego y haz tu apuesta.';

  @override
  String get casinoPlayButton => 'Jugar';

  @override
  String get casinoGameBaccaratName => 'Bacará';

  @override
  String get casinoGameBaccaratDesc =>
      'Apueste al jugador, a la banca o empate con probabilidades estratégicas.';

  @override
  String get casinoGameVideoPokerName => 'Vídeo póquer';

  @override
  String get casinoGameVideoPokerDesc =>
      'Roba 5 cartas y haz combos hasta la Escalera Real.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Comprar casino (bloqueado)';

  @override
  String get casinoErrGenericPlay => 'algo salió mal';

  @override
  String get casinoErrSpinFailed => 'Error al girar';

  @override
  String get casinoErrBetFailed => 'Error al apostar';

  @override
  String get casinoErrGambleFailed => 'Error al jugar';

  @override
  String get casinoErrThrowFailed => 'Error al rodar';

  @override
  String get casinoErrCasinoNotFound =>
      'Casino no encontrado. Asegúrese de que el casino se haya comprado en este país.';

  @override
  String get casinoErrInsufficientFunds => 'Hace falta dinero';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Los fondos del casino son demasiado bajos para este pago';

  @override
  String casinoErrNetwork(String error) {
    return 'Error de red: $error';
  }

  @override
  String get casinoResultYouWon => '¡Ganaste!';

  @override
  String get casinoResultYouLost => 'Perdida';

  @override
  String get casinoResultYouWonCelebrate => '🎉 ¡Ganaste!';

  @override
  String casinoWonEuroAmount(String amount) {
    return '¡Ganaste €$amount!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Perdiste €$amount';
  }

  @override
  String get casinoYouLostPlain => 'perdiste';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return '¡Ganaste €$amount!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return '¡VEINTIUNA! €$amount';
  }

  @override
  String get casinoAgain => 'De nuevo';

  @override
  String get casinoBankruptTitle => '¡Casino en quiebra!';

  @override
  String get casinoBankruptBody =>
      '¡El casino quebró! \n\nEl propietario no tenía suficiente efectivo en sus fondos para cubrir todos los pagos. \n\nEl casino ya está cerrado y se puede volver a comprar.';

  @override
  String get casinoBackToCasino => 'Volver a Casino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Número: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'verde';

  @override
  String get casinoColorRed => 'roja';

  @override
  String get casinoColorBlack => 'negra';

  @override
  String get casinoRoulettePickBet => 'Elige tu apuesta';

  @override
  String get casinoRouletteBetRed => 'Roja';

  @override
  String get casinoRouletteBetBlack => 'Negra';

  @override
  String get casinoRouletteBetEven => 'Incluso';

  @override
  String get casinoRouletteBetOdd => 'Extraña';

  @override
  String get casinoRouletteSpinButton => '¡GIRAR!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Último resultado: $number';
  }

  @override
  String get casinoBetLabel => 'Apuesta';

  @override
  String get casinoBlackjackPlayButton => '¡JUGAR!';

  @override
  String get casinoSlotSpinButton => '¡GIRAR!';

  @override
  String get casinoDiceRollButton => '¡ROLLO!';

  @override
  String get casinoBlackjackYourCards => 'Tus cartas';

  @override
  String get casinoBlackjackDealerCards => 'Tarjetas de distribuidor';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Distribuidor: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Tú: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Total: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Predecir';

  @override
  String get casinoDiceLowLabel => 'Bajo (2-6)';

  @override
  String get casinoDiceHighLabel => 'Alto (8-12)';

  @override
  String get casinoDiceOddsHint =>
      'Bajo/Alto paga 2x • El total exacto paga 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'tabla de pagos';

  @override
  String get casinoBaccaratPlayer => 'Jugadora';

  @override
  String get casinoBaccaratBanker => 'Banquera';

  @override
  String get casinoBaccaratTieBet => 'Atar';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Ganadora: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Pago: €$amount';
  }

  @override
  String get casinoNoPayout => 'Sin pago';

  @override
  String casinoResultEuro(String amount) {
    return 'Resultado: €$amount';
  }

  @override
  String get casinoDealing => 'Relación comercial…';

  @override
  String get casinoDealCaps => 'TRATO';

  @override
  String get casinoVideoPokerDrawCards => 'TARJETAS PARA SACAR';

  @override
  String get casinoVideoPokerDrawHint => 'dibuja tu mano';

  @override
  String get casinoVideoPokerRoyalFlush => 'Escalera Real';

  @override
  String get casinoVideoPokerStraightFlush => 'Escalera de color';

  @override
  String get casinoVideoPokerFourKind => 'cuatro iguales';

  @override
  String get casinoVideoPokerFullHouse => 'Casa llena';

  @override
  String get casinoVideoPokerFlush => 'Enjuagar';

  @override
  String get casinoVideoPokerStraight => 'Derecha';

  @override
  String get casinoVideoPokerThreeKind => 'tres iguales';

  @override
  String get casinoVideoPokerTwoPair => 'dos pares';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Jotas o mejor';

  @override
  String get casinoVideoPokerNoWinningHand => 'No hay mano ganadora';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Tabla de pagos: Jotas+ 1x • Dos pares 2x • Trips 3x • Escalera de color 4x • Color 6x • Full 9x • Cuatro 25x • Escalera de color 50x • Royal 250x';

  @override
  String get bankScreenLoadFailed => 'No se pudo cargar el banco';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Error de red: $details';
  }

  @override
  String bankScreenCounterpartyTo(String username) {
    return 'Para: $username';
  }

  @override
  String bankScreenCounterpartyFrom(String username) {
    return 'De: $username';
  }

  @override
  String get bankScreenDepositSuccess => 'Depósito exitosa';

  @override
  String get bankScreenDepositFailed => 'El depósito falló';

  @override
  String bankScreenDailyDepositQuota(String remaining, String cap) {
    return 'Depósitos gratuitos restantes hoy: $remaining de $cap. Se deben lavar cantidades mayores.';
  }

  @override
  String get bankScreenDailyDepositCapReached =>
      'El límite de depósito gratuito de hoy está agotado. Lave el efectivo restante o espere el reinicio de UTC.';

  @override
  String bankScreenFillRemainingQuota(String amount) {
    return 'Usar resto ($amount)';
  }

  @override
  String bankScreenDailyDepositResetsIn(String time) {
    return 'Los depósitos gratuitos se restablecen a las 00:00 UTC ($time restante).';
  }

  @override
  String get bankScreenDailyDepositBelowLaunderMin =>
      'El efectivo por debajo del mínimo de lavado se puede depositar de forma gratuita después del reinicio de UTC.';

  @override
  String bankScreenDepositCapError(String remaining) {
    return 'Eso excede el depósito gratuito restante de hoy ($remaining). Deposite hasta esa cantidad o utilice el blanqueo de dinero.';
  }

  @override
  String get bankScreenWithdrawSuccess => 'Retiro exitoso';

  @override
  String get bankScreenWithdrawFailed => 'Retiro fallido';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '€$amount transferido a $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Transferencia fallida';

  @override
  String get bankScreenErrRecipientNotFound => 'Jugadora no encontrada';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'No puedes transferirte a ti mismo';

  @override
  String get bankScreenErrInsufficientBalance => 'Saldo bancario insuficiente';

  @override
  String get bankScreenErrInvalidAmount => 'Cantidad no válida';

  @override
  String get bankScreenTryAgain => 'Intentar otra vez';

  @override
  String get bankScreenWorldwideSubtitle =>
      'Banco (accesible en todo el mundo)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Efectivo en caja: €$amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Saldo bancario: €$amount';
  }

  @override
  String get bankScreenAmountLabel => 'Cantidad';

  @override
  String get bankScreenDescriptionOptional => 'Descripción (opcional)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Se almacenará con su depósito o retiro en las transacciones.';

  @override
  String get bankScreenDepositButton => 'Depósito';

  @override
  String get bankScreenWithdrawButton => 'Retirar';

  @override
  String get bankScreenTransferSectionTitle => 'Transferencia a la jugadora';

  @override
  String get bankScreenRecipientUsername =>
      'Nombre de usuario del destinatario';

  @override
  String get bankScreenRecentRecipients => 'Destinatarias recientes';

  @override
  String get bankScreenDescriptionTransferHint =>
      'El destinatario también verá esta descripción en las transacciones.';

  @override
  String get bankScreenTransferButton => 'Transferir';

  @override
  String get bankScreenTransactionsTitle => 'Actas';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count total';
  }

  @override
  String get bankScreenSummaryDeposits => 'Depósitos';

  @override
  String get bankScreenSummaryWithdrawals => 'Retiros';

  @override
  String get bankScreenSummarySent => 'Enviada';

  @override
  String get bankScreenSummaryReceived => 'Recibida';

  @override
  String get bankScreenNoTransactions => 'Aún no hay transacciones';

  @override
  String get bankScreenTxnDeposit => 'Depósito';

  @override
  String get bankScreenTxnWithdraw => 'Retiro';

  @override
  String get bankScreenTxnTransferSent => 'Transferencia enviada';

  @override
  String get bankScreenTxnTransferReceived => 'Transferencia recibida';

  @override
  String get bankScreenPrevious => 'Previa';

  @override
  String get bankScreenNext => 'Próxima';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Clasificación $rank';
  }

  @override
  String get retry => 'Rever';

  @override
  String get doAction => 'Hacer';

  @override
  String get pay => 'Pagar';

  @override
  String get success => 'Éxito';

  @override
  String get jail => 'Celda';

  @override
  String get cooldown => 'Enfriarse';

  @override
  String get requiredRank => 'Rango de jugador requerido';

  @override
  String get playerRankLabel => 'Rango de jugador';

  @override
  String get loading => 'Cargando...';

  @override
  String get trade => 'Comercio';

  @override
  String get buy => 'Comprar';

  @override
  String get sell => 'Vender';

  @override
  String get price => 'Precio';

  @override
  String get total => 'Total';

  @override
  String available(String count) {
    return 'Disponible: $count';
  }

  @override
  String get notEnoughMoney => '¡No tienes suficiente dinero!';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Cerca';

  @override
  String get viewOffer => 'Ver oferta';

  @override
  String get unexpectedResponse => 'Respuesta API inesperada';

  @override
  String get errorLoadingMenu => 'Error al cargar el menú';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get food => 'Alimento';

  @override
  String get drink => 'Beber';

  @override
  String get work => 'Trabajar';

  @override
  String cooldownMinutes(String minutes) {
    return 'Enfriamiento: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'XP: +$amount';
  }

  @override
  String get fly => 'Volar';

  @override
  String get purchased => '¡Comprado!';

  @override
  String get sold => '¡Vendida!';

  @override
  String get errorBuying => 'Error al comprar';

  @override
  String get errorSelling => 'Error al vender';

  @override
  String get goods => 'Bienes';

  @override
  String get marketplace => 'Mercado';

  @override
  String get myListings => 'Mis listados';

  @override
  String get inventory => 'Inventario';

  @override
  String get backpacks => 'Mochilas';

  @override
  String get materials => 'Materiales';

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
  String get production => 'Producción';

  @override
  String get stock => 'Existencias';

  @override
  String get retryAgain => 'Rever';

  @override
  String get noVehiclesAvailable => 'No hay vehículos disponibles';

  @override
  String get noListings => 'No hay listados';

  @override
  String get condition => 'Condición';

  @override
  String get yourHealth => 'Tu salud';

  @override
  String get criticalHealthWarning =>
      '⚠️¡CRÍTICO! ¡Debes ir al hospital inmediatamente!';

  @override
  String get lowHealthWarning => '⚠️¡Baja salud! Ten cuidado.';

  @override
  String get information => 'Información';

  @override
  String get contrabandFlowersName => 'flores';

  @override
  String get contrabandFlowersDesc =>
      'Tulipanes holandeses y otras flores para el comercio internacional';

  @override
  String get contrabandElectronicsName => 'Electrónica';

  @override
  String get contrabandElectronicsDesc =>
      'Electrónica avanzada y componentes informáticos.';

  @override
  String get contrabandDiamondsName => 'diamantes';

  @override
  String get contrabandDiamondsDesc => 'Diamantes en bruto y tallados.';

  @override
  String get contrabandWeaponsName => 'Armas';

  @override
  String get contrabandWeaponsDesc => 'Armas y municiones ilegales';

  @override
  String get contrabandPharmaceuticalsName => 'Productos farmacéuticos';

  @override
  String get contrabandPharmaceuticalsDesc => 'Productos farmacéuticos raros';

  @override
  String get contrabandSpiritsName => 'Licores de lujo';

  @override
  String get contrabandSpiritsDesc =>
      'Whisky, coñac y licores premium de contrabando';

  @override
  String get contrabandTobaccoName => 'Tabaco';

  @override
  String get contrabandTobaccoDesc => 'Cigarrillos y rapé sin impuestos';

  @override
  String get contrabandArtName => 'Arte y antigüedades';

  @override
  String get contrabandArtDesc =>
      'Cuadros, esculturas y antigüedades de contrabando';

  @override
  String get contrabandSpicesName => 'Especias';

  @override
  String get contrabandSpicesDesc => 'Hierbas y especias exóticas a granel';

  @override
  String get contrabandCoffeeName => 'Café';

  @override
  String get contrabandCoffeeDesc => 'Granos de café premium sin certificado';

  @override
  String get contrabandFurLeatherName => 'Pieles y cuero';

  @override
  String get contrabandFurLeatherDesc => 'Pieles ilegales y cuero exótico';

  @override
  String get contrabandPerfumeName => 'Perfume';

  @override
  String get contrabandPerfumeDesc => 'Perfumes de diseñador de contrabando';

  @override
  String get contrabandCounterfeitCashName => 'Dinero falso';

  @override
  String get contrabandCounterfeitCashDesc => 'Falsificaciones de alta calidad';

  @override
  String get contrabandRareWineName => 'Vino raro';

  @override
  String get contrabandRareWineDesc => 'Vinos vintage y colecciones exclusivas';

  @override
  String get contrabandLuxuryWatchesName => 'Relojes de lujo';

  @override
  String get contrabandLuxuryWatchesDesc => 'Relojes de prestigio sin papeles';

  @override
  String get contrabandGoldName => 'Oro';

  @override
  String get contrabandGoldDesc => 'Lingotes de oro fundido sin marcar';

  @override
  String get multiplier => 'Multiplicadora';

  @override
  String get sellPrice => 'precio de venta';

  @override
  String get boughtFor => 'Comprado por';

  @override
  String get profit => 'Ganancia';

  @override
  String get loss => 'Pérdida';

  @override
  String ownedQuantity(String quantity) {
    return 'Propiedad: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Se echa a perder en ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 estropeada - sin valor';

  @override
  String get vehicleBought => '¡Vehículo comprado con éxito!';

  @override
  String get purchaseFailed => 'Compra fallida';

  @override
  String get listingRemoved => 'Listado eliminado';

  @override
  String get noItemsInInventory => 'No hay artículos en el inventario';

  @override
  String get buyItemsInBuyTab => 'Comprar artículos en la pestaña Comprar';

  @override
  String errorLoadingMarketData(String error) {
    return 'Error al cargar datos de mercado: $error';
  }

  @override
  String get tradeLoadGoodsFailed =>
      'No se pudo cargar el catálogo de productos.';

  @override
  String get tradeLoadPricesFailed =>
      'No se pudieron cargar los precios actuales';

  @override
  String get tradeLoadInventoryFailed =>
      'No se pudo cargar su inventario comercial';

  @override
  String get tradePartialDataBanner =>
      'Algunos datos del mercado no se pudieron actualizar. Tire hacia abajo para volver a intentarlo.';

  @override
  String get tradeMarketLoadAllFailed =>
      'No se pudo cargar el mercado. Tire hacia abajo para volver a intentarlo.';

  @override
  String get tradeNoGoodsLoaded =>
      'No hay productos disponibles en este momento.';

  @override
  String get tradeRiskPanelTitle => 'Riesgos de viajes y mercado';

  @override
  String get tradeRiskPanelSubtitle =>
      'Cada bien muestra deterioro, oscilaciones de precios, daños por viaje o confiscación cuando corresponda.';

  @override
  String get tradeRiskInsightBody =>
      'FLORES: estropear después del cronómetro desde la compra - vender a tiempo. \nDIAMANTES: los precios de compra oscilan con la volatilidad; planifique dónde venderá en el extranjero. \nELECTRÓNICA: puede perder estado en cada viaje, lo que disminuye el valor de reventa. \nARMAS y PRODUCTOS FARMACÉUTICOS: puede ocurrir una incautación parcial durante el viaje; mantenga el nivel de búsqueda bajo y lea las reglas de contrabando. \nLos precios en esta pantalla ya incluyen el multiplicador de su país actual.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h ventana de estropeo';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% de oscilación del precio';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct% de riesgo de convulsiones por viaje';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct% de probabilidad de daño por viaje';
  }

  @override
  String tradeRiskHeavyWeight(String weight) {
    return 'Pesado ($weight peso)';
  }

  @override
  String get tradeGoodNotAvailableHere =>
      'Este producto no se vende en tu país actual. Viaja a un país fuente.';

  @override
  String get tradeNoBuyableGoodsInCountry =>
      'No hay mercancías a la venta en este país. Viaja a un país fuente.';

  @override
  String get tradeUnavailableGoodsTitle => 'No se vende aquí';

  @override
  String tradeUnavailableGoodsSubtitle(String count) {
    return '$count productos solo en países fuente';
  }

  @override
  String get tradeTravelToSourceHint =>
      'Solo en países fuente — viaja para comprar';

  @override
  String get tradeCategoryAll => 'Todo';

  @override
  String get tradeCategoryStarter => 'Inicial';

  @override
  String get tradeCategoryBulk => 'A granel';

  @override
  String get tradeCategoryLuxury => 'Lujo';

  @override
  String get tradeCategoryDangerous => 'Peligroso';

  @override
  String get tradeFilterAvailableHere => 'A la venta aquí';

  @override
  String tradeMarketCatalogSummary(String total, String here) {
    return '$total productos · $here a la venta aquí';
  }

  @override
  String get appeal => 'Apelar';

  @override
  String get submitAppeal => 'Enviar apelación';

  @override
  String get bribeJudge => 'Juez de sobornos';

  @override
  String get bribe => 'Soborno';

  @override
  String get courtLoadFailed =>
      'No se pudieron cargar los datos del tribunal. Por favor inténtalo de nuevo.';

  @override
  String get courtAppealDialogIntro =>
      '¿Quiere presentar un recurso de apelación por esta condena?';

  @override
  String courtCostLine(String amount) {
    return 'Costo: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Juez: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruptibilidad: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'En caso de éxito: aproximadamente entre un 20% y un 40% de reducción de la sentencia';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Recurso concedido. Nueva frase: $minutes minutos.';
  }

  @override
  String get courtAppealDenied => 'Apelación denegada.';

  @override
  String get courtBribeOfferIntro =>
      'Ofrezca una cantidad. El importe siempre se deduce, incluso en caso de fallo.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Monto del soborno: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€${thousands}k';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Probabilidad de éxito estimada: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Juez sobornado. Eres liberado inmediatamente.';

  @override
  String get courtBribeFailedDebited =>
      'El soborno fracasó. Aún se dedujo el importe.';

  @override
  String get courtRecordActive => 'Activa';

  @override
  String get courtRecordServed => 'Servida';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Recurso concedido: $fromMinutes → $toMinutes minutos';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Apelación denegada: quedaban $minutes minutos';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Soborno fallido: $amount pagado';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Condenada a $minutes minutos';
  }

  @override
  String get courtPartialLoadWarning =>
      'Aviso: no se pudo cargar parte de los datos de la cancha. Tira para actualizar y vuelve a intentarlo.';

  @override
  String get courtNoActiveSentence => 'Sin oración activa';

  @override
  String get courtNotJailedHint =>
      'Actualmente no estás encarcelado. Sus antecedentes penales permanecen visibles a continuación.';

  @override
  String get courtActiveSentenceTitle => 'oración activa';

  @override
  String get courtDelictLabel => 'Delito';

  @override
  String courtTotalSentenceMinutes(String minutes) {
    return 'Frase total: $minutes minutos';
  }

  @override
  String courtRemainingMinutes(String minutes) {
    return 'Restante: $minutes minutos';
  }

  @override
  String courtAppealCostCurrent(String amount) {
    return 'Costo de apelación actual: $amount';
  }

  @override
  String get courtButtonAppeal => 'Apelar';

  @override
  String get courtButtonBribeJudge => 'juez de sobornos';

  @override
  String get courtUnknownCrime => 'Desconocida';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Oración: $minutes minutos';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Oración: $original → $reduced minutos';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Fecha: $datetime';
  }

  @override
  String get courtHistoryHeading => 'Historia de la corte';

  @override
  String get courtAppealSubmitted => 'Apelación presentada';

  @override
  String get courtCriminalRecordTitle => 'antecedentes penales';

  @override
  String courtTotalConvictions(String count) {
    return 'Condenas totales: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'Las condenas pasadas siguen siendo visibles. Un soborno exitoso a un juez aclara sólo ese caso activo.';

  @override
  String get courtNoConvictionsYet => 'Aún no se han registrado condenas.';

  @override
  String get courtHeroTitle => 'La audiencia';

  @override
  String get courtHeroSubtitle =>
      'Apelar o sobornar al juez mientras cumple condena. Tus antecedentes penales permanecen después de que salgas libre.';

  @override
  String courtConvictionsChip(String count) {
    return '$count condenas';
  }

  @override
  String get courtActiveChip => 'Cumpliendo condena';

  @override
  String get courtFreeChip => 'Ningún caso activo';

  @override
  String get courtJudgeSpecialtyViolence => 'Crímenes violentos';

  @override
  String get courtJudgeSpecialtyFinancial => 'Delitos financieros';

  @override
  String get courtJudgeSpecialtyDrugs => 'Casos relacionados con las drogas';

  @override
  String get courtJudgeSpecialtyWhiteCollar => 'Crimen de cuello blanco';

  @override
  String get courtJudgeSpecialtyOrganized => 'Delincuencia organizada';

  @override
  String get courtOddsTitle => '¿Qué cambia sus posibilidades de apelación?';

  @override
  String courtLawBonus(String level, String percent) {
    return 'Educación jurídica $level/5: +$percent%';
  }

  @override
  String courtPriorBonus(String percent) {
    return 'Primera condena: +$percent%';
  }

  @override
  String courtPriorPenalty(String count, String percent) {
    return '$count condenas previas: $percent%';
  }

  @override
  String courtPriorNone(String count) {
    return '$count condenas previas: sin modificador adicional';
  }

  @override
  String courtWantedPenalty(String level, String percent) {
    return 'Se busca $level: -$percent% de apelación';
  }

  @override
  String courtWantedOk(String level) {
    return 'Se busca $level: sin sanción de apelación';
  }

  @override
  String courtFbiPenalty(String level, String percent) {
    return 'FBI heat $level: -$percent% de apelación';
  }

  @override
  String courtFbiOk(String level) {
    return 'FBI heat $level: sin sanción de apelación';
  }

  @override
  String courtAppealChance(String percent) {
    return 'Probabilidad de apelación: ~$percent%';
  }

  @override
  String get courtAppealUsed => 'Ya apeló esta condena.';

  @override
  String get courtBribeHeatNote =>
      'Wanted y FBI heat cambian las probabilidades de apelación, no este soborno.';

  @override
  String get treated => '¡Tratado!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP por €$cost';
  }

  @override
  String get treatmentOptions => 'Opciones de tratamiento';

  @override
  String get youAreDead => '¡Estás muerto! Juego terminado.';

  @override
  String get emergencyOnly =>
      'El tratamiento de emergencia solo está disponible por debajo de 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return '¡Tratamiento de emergencia! Gratis +$hp HP';
  }

  @override
  String get byValue => 'Por valor';

  @override
  String get byCondition => 'Por condición';

  @override
  String get byFuel => 'Por combustible';

  @override
  String get byName => 'Por nombre';

  @override
  String get stealCar => 'robar coche';

  @override
  String get stealBoat => 'robar barco';

  @override
  String get sellVehicle => 'Vender Vehículo';

  @override
  String get sellBoat => 'Vender Barco';

  @override
  String get confirmSellVehicle =>
      '¿Estás segura de que quieres vender este vehículo?';

  @override
  String get confirmSellBoat =>
      '¿Estás segura de que quieres vender este barco?';

  @override
  String get carStolen => '¡Coche robado con éxito!';

  @override
  String get boatStolen => '¡Barco robado con éxito!';

  @override
  String get vehicleTypeCar => 'Auto';

  @override
  String get vehicleTypeBoat => 'Bote';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType robada!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Desconocido $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Velocidad';

  @override
  String get vehicleStatFuel => 'Combustible';

  @override
  String get vehicleStatCargo => 'Carga';

  @override
  String get vehicleStatStealth => 'Sigilo';

  @override
  String get continueAction => 'Continuar';

  @override
  String get vehicleSold => '¡Vehículo vendido con éxito!';

  @override
  String get boatSold => '¡Barco vendido con éxito!';

  @override
  String get garageUpgraded => '¡Garaje renovado!';

  @override
  String get marinaUpgraded => 'Marina actualizada con éxito!';

  @override
  String get marinaCapacity => 'Capacidad del puerto deportivo';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total barcos';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Mejora (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Nivel máximo';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Nivel $level | $remaining quedan plazas';
  }

  @override
  String get noBoatsInMarina => 'No hay barcos en tu puerto deportivo';

  @override
  String get stealBoatsToStart => '¡Roba algunos barcos para empezar!';

  @override
  String get marinaUpgradeFailed =>
      'La actualización del puerto deportivo falló';

  @override
  String get boatShipped => '¡Barco enviado con éxito!';

  @override
  String get boatShipFailed => 'El envío del barco falló';

  @override
  String get buyProperty => 'Comprar Propiedad';

  @override
  String propertyBought(String name) {
    return '$name comprado!';
  }

  @override
  String propertyUpgraded(String level) {
    return '¡Propiedad mejorada al nivel $level!';
  }

  @override
  String get errorLoadingProperties => 'Error al cargar propiedades';

  @override
  String get errorUpgrading => 'Error al actualizar';

  @override
  String networkError(String error) {
    return 'Error de red: $error';
  }

  @override
  String get unknownResponse => 'Respuesta desconocida';

  @override
  String incomeCollected(String amount) {
    return '$amount€ recaudados!';
  }

  @override
  String get buyCasino => 'Comprar Casino';

  @override
  String get manageCasino => 'Administrar Casino';

  @override
  String get casinoBought => '¡Casino comprado con éxito! 🎰';

  @override
  String get errorBuyCasino => 'Se produjo un error al comprar el casino.';

  @override
  String minimumDeposit(String amount) {
    return 'El depósito mínimo es €$amount';
  }

  @override
  String get casinoInfo1 =>
      'Las jugadoras apuestan contra el bankroll del casino.';

  @override
  String get casinoInfo2 => 'Las ganancias se pagan con cargo a los fondos.';

  @override
  String get casinoInfo3 => 'Puedes depositar y retirar dinero.';

  @override
  String get casinoInfo4 => 'Se requiere un mínimo de 10.000 € en fondos';

  @override
  String get casinoInfo5 => 'Debajo de eso: quiebra';

  @override
  String get members => 'Miembros';

  @override
  String get location => 'Ubicación';

  @override
  String get level => 'Nivel';

  @override
  String get alreadyFullHealth => '¡Ya estás en plena salud!';

  @override
  String get errorTreatment => 'Error durante el tratamiento';

  @override
  String waitMinutes(String minutes) {
    return '¡Debes esperar $minutes minutos más para el siguiente tratamiento!';
  }

  @override
  String get emergencyHelp => 'Ayuda de emergencia';

  @override
  String onlyNeedHp(String hp) {
    return '(Solo necesitas $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 La ayuda de emergencia es GRATUITA por debajo de 10 HP (+20 HP)';

  @override
  String get hospitalInfo1 =>
      '• Los crímenes y hits cuestan HP (unos 5–15 por crimen; chaleco y guardaespaldas lo reducen).';

  @override
  String get hospitalInfo2 =>
      '• Por debajo de 70 HP baja el éxito (−4% / −8% / −12%). A 0 HP vas 3 horas a la UCI.';

  @override
  String hospitalInfo3(String cost) {
    return '• El tratamiento cuesta $cost€ por vez';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Puedes restaurar un máximo de $amount HP por tratamiento';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 hora de recuperación entre tratamientos';

  @override
  String get hospitalInfo6 =>
      '• Cura pasiva: +5 HP por tick de juego si sigues vivo. El hospital es el reset rápido de pago.';

  @override
  String get medicalTreatment => 'Tratamiento médico';

  @override
  String get restoreCritical => 'Restaurar +20 HP (condición crítica)';

  @override
  String get hospitalCooldownTitle => 'Tratamiento en periodo de recuperación.';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Próximo tratamiento disponible en: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Estado médico';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'UCI: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'PS $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle =>
      'Descripción general de la UCI y el triaje';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Paciente en UCI. Tiempo restante: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Estado crítico detectado. Se recomienda atención de emergencia.';

  @override
  String get hospitalStableStatus => 'Estable. Tratamiento regular disponible.';

  @override
  String get hospitalRefreshMedicalRecord => 'Actualizar expediente médico';

  @override
  String get hospitalStrategyTitle => '¿Por qué venir aquí?';

  @override
  String hospitalCrimePenaltyLine(String percent) {
    return 'Herido: −$percent% de éxito en crímenes hasta que te cures';
  }

  @override
  String get hospitalGoHeal => 'Ir al hospital';

  @override
  String get hospitalBandHealthy => 'En forma';

  @override
  String get hospitalBandWounded => 'Herido';

  @override
  String get hospitalBandHurt => 'Gravemente herido';

  @override
  String get hospitalBandCritical => 'Crítico';

  @override
  String crimesInjuredBanner(String percent) {
    return 'Herido (−$percent% de éxito). Cúrate en el hospital para recuperar tus chances.';
  }

  @override
  String get hospitalStandardTreatmentTitle => 'Tratamiento estándar';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Asequible • restaurar hasta $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'tratamiento intensivo';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Recuperación más rápida • hasta $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Tratamiento intensivo: $cost€ para hasta $amount recuperación de HP.';
  }

  @override
  String restoreUp(String amount) {
    return 'Restaurar hasta $amount HP';
  }

  @override
  String get cost => 'Costo';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Necesitas $tools para este delito';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️Tienes $tools, ¡pero está en casa! Ir a Inventario → Transferir';
  }

  @override
  String get crimeErrorVehicleRequired => '🚗 Este delito requiere un vehículo';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Vehículo no encontrado';

  @override
  String get crimeErrorNotVehicleOwner =>
      '🚗 No eres propietario de este vehículo';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Su vehículo está averiado y necesita reparación';

  @override
  String get crimeErrorNoFuel => '⛽ Tu vehículo no tiene combustible';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Tu nivel es demasiado bajo para este crimen';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Delito inválido';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Necesitas un arma para este crimen';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Tu arma está rota y necesita reparación';

  @override
  String get crimeErrorNoAmmo => '🔫 No tienes munición';

  @override
  String get crimeErrorGeneric => '❌ Algo salió mal con este crimen';

  @override
  String get inventoryFull =>
      '🎒 ¡Tu inventario está lleno! Almacenar herramientas en una propiedad.';

  @override
  String get storageFull => '📦 El almacenamiento de propiedades está lleno';

  @override
  String get inventoryCrimeWeaponTitle => 'Arma criminal seleccionada';

  @override
  String get inventoryCrimeWeaponHint => 'Seleccione un arma para los crímenes';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Elige tu arma criminal aquí. La pantalla de crímenes utiliza esta selección inmediatamente.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'No hay armas utilizables en el inventario. Primero compre o mueva un arma a los artículos que lleva.';

  @override
  String get inventoryPaperDoll => 'Equipo';

  @override
  String get inventoryBackpackGrid => 'Mochila';

  @override
  String get inventoryStorageGrid => 'Almacenamiento';

  @override
  String get inventoryMaterialsDepot => 'Depósito de materiales';

  @override
  String get inventoryEquipWeapon => 'Arma del crimen';

  @override
  String get inventoryEquipSecondary => 'Segunda arma';

  @override
  String get inventoryEquipArmor => 'Chaleco';

  @override
  String get inventoryEmptySlot => 'Ranura vacía';

  @override
  String inventorySelectHint(String name) {
    return 'Seleccionado: $name. Toque una ranura válida para moverla.';
  }

  @override
  String get inventoryOpenStorage => 'Almacenamiento abierto';

  @override
  String get inventoryTransferOk => 'Artículo movido';

  @override
  String get inventoryTransferFailed => 'Movimiento fallido';

  @override
  String get inventoryWrongDrop => 'Esa bajada no está permitida aquí.';

  @override
  String get inventoryMoveOne => 'Mover 1';

  @override
  String get inventoryMoveAll => 'mover todo';

  @override
  String inventorySlotUsage(int used, int max) {
    return 'Mochila $used/$max';
  }

  @override
  String get inventoryCarriedEmpty =>
      'No llevas herramientas, armas ni municiones.';

  @override
  String get inventorySectionTools => 'Herramientas';

  @override
  String get inventorySectionWeapons => 'Armas';

  @override
  String get inventorySectionAmmo => 'Munición';

  @override
  String get inventoryWeaponFallbackName => 'Arma';

  @override
  String get inventoryAmmoFallbackName => 'Munición';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Condición: $condition% • Cantidad: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Cantidad: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Cantidad: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Retirar del almacenamiento: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Máximo: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Cantidad no válida';

  @override
  String get inventorySnackWeaponStored => 'Arma almacenada';

  @override
  String get inventorySnackWeaponWithdrawn => 'Arma retirada';

  @override
  String get inventorySnackCashStored => 'Efectivo depositado';

  @override
  String get inventorySnackCashWithdrawn => 'Efectivo retirado';

  @override
  String get inventorySnackDrugsWithdrawn => 'drogas retiradas';

  @override
  String get inventoryActionFailed => 'La acción falló';

  @override
  String get inventoryStorageNoCategory => 'Sin tipo de almacenamiento';

  @override
  String get inventoryCountsWeapons => 'Armas';

  @override
  String get inventoryCountsDrugs => 'Drogas';

  @override
  String get inventoryCountsCash => 'Dinero';

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
      'Estás en otro país. No puede acceder a este almacenamiento aquí.';

  @override
  String get inventoryWeaponStorageTitle => 'Almacenamiento de armas';

  @override
  String get inventoryStoreWeapons => 'Almacenar';

  @override
  String get inventoryInStorage => 'En almacenamiento';

  @override
  String get inventoryUnknownWeapon => 'Arma desconocida';

  @override
  String get inventoryTakeOne => 'Toma 1';

  @override
  String get inventoryNoWeaponsInStorage => 'No hay armas en este almacén.';

  @override
  String get inventoryCashStorageTitle => 'Almacenamiento de efectivo';

  @override
  String get inventoryDepositCash => 'depositar efectivo';

  @override
  String get inventoryWithdrawCash => 'retirar efectivo';

  @override
  String get inventoryDrugStorageTitle => 'Almacenamiento de medicamentos';

  @override
  String get inventoryNoDrugsInStorage => 'No hay drogas almacenadas.';

  @override
  String get inventoryNotForTools =>
      'Esta propiedad no es para almacenamiento de herramientas. Utilice un almacén para herramientas.';

  @override
  String get inventoryCategoryTools => 'Herramientas';

  @override
  String get inventoryCategoryDrugs => 'Drogas';

  @override
  String get inventoryCategoryWeapons => 'Armas';

  @override
  String get inventoryCategoryCash => 'Dinero';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max espacios ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Accesible en el país actual';

  @override
  String get inventoryStorageNotAccessibleHere => 'No accesible en este país.';

  @override
  String get loadoutEquipFailed => 'No se pudo equipar el equipamiento';

  @override
  String get loadoutDeleteFailed => 'No se pudo eliminar el equipamiento';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool movido a $location';
  }

  @override
  String get carried => 'Transportada';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get property => 'Propiedad';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max ranuras';
  }

  @override
  String get loadouts => 'Equipamientos';

  @override
  String get createLoadout => 'Crear equipamiento';

  @override
  String get equipLoadout => 'Equipar';

  @override
  String get loadoutEquipped => '✅ Equipada equipada';

  @override
  String get loadoutMaxReached => '❌ Equipamiento máximo alcanzado (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Herramientas faltantes: $tools';
  }

  @override
  String get backpackUpgrade => 'Actualización de mochila';

  @override
  String get backpackBasic => 'Mochila Básica (+5 espacios)';

  @override
  String get backpackTactical => 'Chaleco táctico (+10 espacios)';

  @override
  String get backpackCargo => 'Pantalones cargo (+3 espacios)';

  @override
  String get upgradeInventory => 'Actualizar inventario';

  @override
  String get noToolsCarried => 'No se llevan herramientas';

  @override
  String get visitShopToBuyTools =>
      'Visita la tienda para comprar herramientas.';

  @override
  String get noProperties => 'Sin propiedades';

  @override
  String get buyPropertyForStorage =>
      'Comprar una propiedad para guardar herramientas.';

  @override
  String get noToolsInStorage => 'No hay herramientas almacenadas';

  @override
  String get selectProperty => 'Seleccionar propiedad';

  @override
  String get slotsRemaining => 'espacios restantes';

  @override
  String get noLoadouts => 'Sin equipamientos';

  @override
  String get createLoadoutToStart => 'Crea un equipamiento para comenzar';

  @override
  String get deleteLoadout => 'Eliminar equipamiento';

  @override
  String get confirmDeleteLoadout =>
      '¿Estás segura de que quieres eliminar este cargamento?';

  @override
  String get loadoutDeleted => 'Equipamiento eliminado';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Borrar';

  @override
  String get active => 'Activa';

  @override
  String get durability => 'Durabilidad';

  @override
  String get quantity => 'Cantidad';

  @override
  String get slotSize => 'Tamaño de ranura';

  @override
  String get repairCost => 'Costo de reparación';

  @override
  String get wearPerUse => 'Desgaste por uso';

  @override
  String get loseChance => 'oportunidad de perder';

  @override
  String get requiredFor => 'Requerido para';

  @override
  String get lowDurability => 'Baja durabilidad';

  @override
  String get transfer => 'Transferir';

  @override
  String get toolDetails => 'Detalles de la herramienta';

  @override
  String get transferTool => 'Herramienta de transferencia';

  @override
  String get selectQuantity => 'Selecciona cantidad';

  @override
  String get destination => 'Destino';

  @override
  String get from => 'De';

  @override
  String get to => 'A';

  @override
  String get editLoadout => 'Editar equipamiento';

  @override
  String get loadoutName => 'Nombre de equipamiento';

  @override
  String get description => 'Descripción';

  @override
  String get optional => 'opcional';

  @override
  String get selectedTools => 'Herramientas seleccionadas';

  @override
  String get noToolsAvailable => 'No hay herramientas disponibles';

  @override
  String get create => 'Crear';

  @override
  String get save => 'Ahorrar';

  @override
  String get pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get pleaseSelectTools => 'Por favor seleccione al menos 1 herramienta';

  @override
  String get loadoutCreated => 'Equipamiento creado';

  @override
  String get loadoutUpdated => 'Equipamiento actualizado';

  @override
  String get goToInventory => 'Ir al inventario';

  @override
  String get slots => 'tragamonedas';

  @override
  String get backpackShop => 'Tienda de mochilas';

  @override
  String get yourBackpack => 'tu mochila';

  @override
  String get availableUpgrades => 'Actualizaciones disponibles';

  @override
  String get otherBackpacks => 'Otras mochilas';

  @override
  String get youHaveBestBackpack => '¡Tienes la mejor mochila!';

  @override
  String get backpackPurchased => '¡Mochila comprada!';

  @override
  String get backpackUpgraded => '¡Mochila mejorada!';

  @override
  String get buyBackpack => 'Comprar';

  @override
  String get upgradeBackpack => 'Mejora';

  @override
  String get backpackPrice => 'Precio';

  @override
  String get extraSlots => 'Ranuras adicionales';

  @override
  String get totalSlots => 'Espacios totales';

  @override
  String get vipOnly => 'Sólo VIP';

  @override
  String get tradeInValue => 'Valor de intercambio';

  @override
  String get upgradeCost => 'Costo de actualización';

  @override
  String rankRequired(Object rank) {
    return 'Rango $rank requerido';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Necesitas $needed€. Tienes €$have';
  }

  @override
  String get alreadyHasBackpack => 'ya tienes una mochila';

  @override
  String get backpackNotFound => 'Mochila no encontrada';

  @override
  String get playerNotFound => 'Jugadora no encontrada';

  @override
  String get notAnUpgrade => 'Esto no es una mejora';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return '¡Compraste $name! +$slots espacios.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return '¡Actualizado a $newName! +$upgradeSlots espacios adicionales.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Mochila no encontrada';

  @override
  String get backpackPurchaseFailedAlready =>
      'Ya tienes una mochila. Sólo puedes usar uno a la vez.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Necesitas rango $required (eres rango $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Necesitas $needed€. Tienes €$have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Esta mochila es solo para miembros VIP.';

  @override
  String get backpackUpgradeFailedNo => 'No tienes mochila para actualizar.';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Esto no es una actualización. Elige una mochila más grande.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Necesitas rango $required (eres rango $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Necesitas $needed€. Tienes €$have';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'Esta mochila es solo para miembros VIP.';

  @override
  String get backpackPurchaseFailedGeneric => 'No se pudo completar la compra.';

  @override
  String get backpackUpgradeFailedGeneric =>
      'No se pudo completar la actualización.';

  @override
  String get backpackUnknownEvent => 'Acción desconocida';

  @override
  String get backpackLoadFailedGeneric => 'algo salió mal';

  @override
  String get backpackOwnedBadge => 'Propiedad';

  @override
  String get availableBackpacks => 'Mochilas disponibles';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Actual: $name (+$slots espacios)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Nuevo: $name (+$slots espacios)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Actualización: +$delta espacios';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Total: $totalSlots espacios';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(problema de almacenamiento; intenta iniciar sesión nuevamente)';

  @override
  String get blackMarketTabBackpacks => 'Mochilas';

  @override
  String get bmHubAdjustFiltersHint => 'Intenta ajustar tus filtros';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Vehículos desde Garaje/Marina, o herramientas llevadas con Vender objeto';

  @override
  String get bmHubSellerLabel => 'Vendedora';

  @override
  String get bmHubAskingPriceLabel => 'precio de venta';

  @override
  String get bmHubMarketValueShort => 'Valor comercial';

  @override
  String get bmHubBuyNow => 'Comprar ahora';

  @override
  String get bmHubListedFor => 'Listado para';

  @override
  String get bmHubEditPrice => 'Editar precio';

  @override
  String get bmHubDelist => 'Eliminar de la lista';

  @override
  String get bmHubFilterListingsTitle => 'Filtrar listados';

  @override
  String get bmHubLabelCountry => 'País';

  @override
  String get bmHubAllCountries => 'Todos los paises';

  @override
  String get bmHubLabelVehicleType => 'tipo de vehículo';

  @override
  String get bmHubAllTypes => 'Todos los tipos';

  @override
  String get bmHubCars => 'Coches';

  @override
  String get bmHubBoats => 'Barcos';

  @override
  String get bmHubPriceRange => 'Gama de precios';

  @override
  String get bmHubClearFilters => 'Limpiar filtros';

  @override
  String get bmHubApply => 'Aplicar';

  @override
  String get bmHubBuyVehicleTitle => 'Comprar vehículo';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return '¿Comprar $name por $price?';
  }

  @override
  String get bmHubVehiclePurchased => '¡Vehículo comprado exitosamente!';

  @override
  String get bmHubVehiclePurchaseFailed => 'No se pudo comprar el vehículo';

  @override
  String get bmHubNewPriceEuro => 'Nuevo precio (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Introduzca nuevo precio';

  @override
  String get bmHubCurrentPrice => 'Precio actual';

  @override
  String get bmHubPriceUpdated => '¡Precio actualizado exitosamente!';

  @override
  String get bmHubPriceUpdateFailed => 'No se pudo actualizar el precio';

  @override
  String get bmHubUpdateButton => 'Actualizar';

  @override
  String get bmHubDelistVehicleTitle => 'Eliminar vehículo de la lista';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return '¿Quitar $name del mercado?';
  }

  @override
  String get bmHubVehicleDelisted =>
      '¡Vehículo eliminado de la lista con éxito!';

  @override
  String get bmHubDelistFailed =>
      'No se ha podido eliminar el vehículo de la lista';

  @override
  String get bmHubLocationUnknown => 'DESCONOCIDA';

  @override
  String get bmHubNoMarketListingsTitle => 'Sin anuncios';

  @override
  String get bmHubNoMarketListingsBody =>
      'Nada coincide con tus filtros. Puedes listar herramientas llevadas con Vender objeto.';

  @override
  String get bmHubSellKindTool => 'Herramienta';

  @override
  String get bmHubSellKindDrug => 'Drogas';

  @override
  String get bmHubSellKindCrypto => 'Cripto';

  @override
  String get bmHubSellKindTrade => 'bienes comerciales';

  @override
  String get bmHubQuantityEvent => 'Cantidad';

  @override
  String get bmHubListEventItemTitle => 'Vender artículo del evento';

  @override
  String get bmHubNoEventItemsToSell =>
      'No hay artículos del evento para vender.';

  @override
  String get bmHubSellKindEvent => 'Artículos de evento';

  @override
  String get bmHubNoDrugsToSell => 'No hay drogas para vender';

  @override
  String get bmHubNoCryptoToSell => 'No hay criptomonedas para vender';

  @override
  String get bmHubNoTradeGoodsToSell =>
      'No hay bienes comerciales para vender.';

  @override
  String get bmHubListDrugTitle => 'Lista de medicamentos';

  @override
  String get bmHubListDrugSelectLabel => 'Pila de drogas';

  @override
  String get bmHubListCryptoTitle => 'Lista de criptomonedas';

  @override
  String get bmHubListCryptoSelectLabel => 'Activo';

  @override
  String get bmHubListTradeTitle => 'Listar bienes comerciales';

  @override
  String get bmHubListTradeSelectLabel => 'Buena';

  @override
  String get bmHubQuantityGrams => 'Cantidad (gramos)';

  @override
  String get bmHubQuantityCrypto => 'Cantidad';

  @override
  String get bmHubQuantityUnits => 'Cantidad';

  @override
  String get bmHubSellCarriedItem => 'Vender objeto';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Cant.: $qty • $pct% estado';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Guía €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Comprar objeto';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return '¿Comprar $name por $price?';
  }

  @override
  String get bmHubToolPurchased => 'Objeto comprado';

  @override
  String get bmHubToolPurchaseFailed => 'No se pudo comprar';

  @override
  String get bmHubDelistToolTitle => 'Quitar anuncio';

  @override
  String bmHubDelistToolConfirm(String name) {
    return '¿Quitar $name del mercado?';
  }

  @override
  String get bmHubToolDelisted => 'Anuncio quitado';

  @override
  String get bmHubListToolTitle => 'Publicar objeto en el mercado';

  @override
  String get bmHubListToolSelectLabel => 'Objeto llevado';

  @override
  String get bmHubListToolSubmit => 'Publicar';

  @override
  String get bmHubToolListedMessage => 'Objeto publicado';

  @override
  String get bmHubListToolFailed => 'No se pudo publicar';

  @override
  String get bmHubLoadCarriedToolsFailed => 'No se pudo cargar el inventario';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'Sin objetos para vender (o ya listados)';

  @override
  String get bmHubInvalidToolPrice => 'Introduce un precio válido';

  @override
  String get arrested => '¡Detenida!';

  @override
  String get jailMessage =>
      '¡Fuiste arrestado durante tu viaje y todos tus bienes fueron confiscados!';

  @override
  String get confirmAction => 'Estas segura';

  @override
  String get ok => 'DE ACUERDO';

  @override
  String get travelContinueConfirmTitle => '¿Continuar con el siguiente tramo?';

  @override
  String get travelContinueConfirmBody =>
      'Los controles fronterizos están activos. ¿Continuar tu viaje?';

  @override
  String get travelJourneyCompleteTitle => 'Viaje completo';

  @override
  String get travelJourneyCompleteBody => 'Llegaste sano y salvo a tu destino.';

  @override
  String get hitlist => 'Lista de resultados';

  @override
  String hitlistLoadError(String error) {
    return 'Error al cargar la lista de resultados: $error';
  }

  @override
  String get noActiveHits => 'No se han realizado visitas activas';

  @override
  String get hitlistHeroTitle => 'Contratos abiertos';

  @override
  String get hitlistHeroSubtitle =>
      'Coloque una recompensa o acepte un contrato abierto. Se aplican información de detectives, armas y país.';

  @override
  String hitlistOpenCount(String count) {
    return '$count abierta';
  }

  @override
  String get hitlistEmptyBody =>
      'No hay contratos públicos en este momento. Ofrezca una recompensa de al menos 50.000 € para iniciar una cacería.';

  @override
  String get selectTarget => 'Seleccionar destino';

  @override
  String get searchPlayer => 'Buscar reproductor...';

  @override
  String get placeHitTitle => 'Colocar golpe';

  @override
  String get minimumBounty => 'Recompensa mínima: 50.000€';

  @override
  String get bountyAmount => 'Monto de la recompensa';

  @override
  String get place => 'Lugar';

  @override
  String hitPlaced(String amount) {
    return 'Golpe colocado por €$amount';
  }

  @override
  String hitError(String error) {
    return 'Error: $error';
  }

  @override
  String get hitDifferentCountry =>
      'Debes estar en el mismo país que el objetivo.';

  @override
  String get hitlistErrMissingBounty => 'Se requiere el monto de la recompensa';

  @override
  String get hitlistErrBountyTooLow => 'La recompensa mínima es de 50.000 €.';

  @override
  String get hitlistErrCannotHitYourself =>
      'No puedes darte un golpe a ti mismo';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Ya tienes un hit activo en este jugador.';

  @override
  String get hitlistErrInsufficientMoney => 'No tienes suficiente dinero';

  @override
  String get hitlistErrMissingCounterBounty =>
      'Se requiere el monto de la contrarecompensa';

  @override
  String get hitlistErrHitNotFound => 'Golpe no encontrado';

  @override
  String get hitlistErrNotTarget =>
      'Sólo el objetivo puede realizar una contraoferta.';

  @override
  String get hitlistErrHitNotActive => 'Golpe no está activa';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'La contrarecompensa debe ser mayor que la recompensa original.';

  @override
  String get hitlistErrMissingWeapon => 'Se requiere arma';

  @override
  String get hitlistErrWeaponNotFound => 'Arma no encontrada';

  @override
  String get hitlistErrWeaponNotOwned =>
      'No eres dueño de esta arma o está rota.';

  @override
  String get hitlistErrWeaponBroken =>
      'Tu arma seleccionada está rota. Repárelo primero.';

  @override
  String get hitlistErrInsufficientAmmo => 'No tienes suficiente munición';

  @override
  String get hitlistErrInvalidAmmoHit => 'Cantidad de munición no válida';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'El objetivo tiene protección activa contra impactos.';

  @override
  String get hitlistErrInvalidInvestigationTier =>
      'Tipo de investigación no válido';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Ya hay una investigación pendiente por este golpe. Espere su mensaje de detective.';

  @override
  String get hitlistErrInvalidCaseId => 'Número de expediente no válido';

  @override
  String get hitlistErrMurderCaseNotFound => 'Expediente no encontrado';

  @override
  String get hitlistErrMurderCaseExpired =>
      'La ventana de investigación expiró (24 horas)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'Ya se inició la investigación por este caso';

  @override
  String get hitlistErrNotPlacer => 'Solo la placer puede cancelar el golpe.';

  @override
  String get hitlistInvestigationOptions => 'Opciones de investigación';

  @override
  String get hitlistInvestigationChooseSpeedPrice =>
      'Elige velocidad y precio:';

  @override
  String get hitlistInvestigationQuick =>
      'Investigación rápida (1.000.000€ • 1 hora)';

  @override
  String get hitlistInvestigationStandard =>
      'Investigación estándar (500.000€ • 6 horas)';

  @override
  String get hitlistInvestigationSlow =>
      'Investigación lenta (250.000€ • 24 horas)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'La investigación está en cola. Costo $cost. ETA: $etaMinutes min. El informe llegará a través de mensajes de la Oficina de Detectives (alrededor de las $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'La investigación falló';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'La investigación no pudo completarse';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return '¡Golpea con éxito! Recompensa y botín recibido: efectivo $cash, artículos llevados $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'Se agotó el tiempo de intento de golpe. Por favor inténtalo de nuevo.';

  @override
  String get hitlistNoUsableWeapons =>
      'No tienes armas utilizables en tu inventario. Compra o repara un arma primero.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Error al cargar armas: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Error al cargar jugadores: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => 'Hace 1 día';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count hace días';
  }

  @override
  String get counterBountyTitle => 'Colocar contrarrecompensa';

  @override
  String minimumAmount(String amount) {
    return 'Importe mínimo: €$amount';
  }

  @override
  String get counterBountyAmount => 'Monto de la contrarecompensa';

  @override
  String counterBountyPlaced(String amount) {
    return 'Contrarecompensa de €$amount colocada';
  }

  @override
  String get cancelHitConfirmTitle => '¿Cancelar golpe?';

  @override
  String get cancelHitConfirmBody => 'Su recompensa será reembolsada.';

  @override
  String get hitCancelled => 'Golpe cancelado';

  @override
  String get target => 'Objetivo';

  @override
  String get placer => 'Placer';

  @override
  String get bounty => 'Generosidad';

  @override
  String get counterBid => 'CONTRAOFERTA';

  @override
  String get counterBidPlaced =>
      '¡Contraoferta colocada! El contrato ha sido revertido.';

  @override
  String get attemptHit => 'Intento de golpe';

  @override
  String get selectWeapon => 'Seleccionar arma y munición';

  @override
  String get youAreTargeted => 'Estás en la lista de objetivos';

  @override
  String get security => 'Seguridad';

  @override
  String get currentDefense => 'Defensa actual';

  @override
  String get totalDefense => 'Defensa total';

  @override
  String get currentArmor => 'Armadura actual';

  @override
  String get bodyguards => 'guardaespaldas';

  @override
  String get buyBodyguards => 'comprar guardaespaldas';

  @override
  String get bodyguardPrice => 'Precio por guardaespaldas';

  @override
  String get armor => 'Armadura';

  @override
  String get protectorsFollow => 'Protectores que te siguen';

  @override
  String get eachGivesDefense => 'Cada uno da +10 de defensa.';

  @override
  String eachGivesDefenseAmount(String defense) {
    return '+$defense defensa';
  }

  @override
  String get repairArmor => 'Reparar';

  @override
  String get armorRepaired => 'Chaleco reparado';

  @override
  String get couldNotRepairArmor => 'No se pudo reparar el chaleco';

  @override
  String get couldNotDismissBodyguard =>
      'No se pudo despedir al guardaespaldas.';

  @override
  String vestTradeInCredit(String amount) {
    return 'Intercambio $amount';
  }

  @override
  String get vestTradeInHint =>
      'La compra de otro chaleco acredita parte de su chaleco actual, según el estado. Reparar un chaleco desgastado es más económico que reemplazarlo.';

  @override
  String get upgradeArmor => 'Mejora';

  @override
  String get vestWeakVsStab => 'Débil vs puñalada';

  @override
  String get vestWeakVsBullets => 'Débiles vs balas';

  @override
  String get vestWeakVsAp => 'Débil vs AP';

  @override
  String get bodyguardStreet => 'Músculo callejero';

  @override
  String get bodyguardStreetDesc =>
      'Ojos extra baratos. Menor defensa, menor salario diario.';

  @override
  String get bodyguardStandard => 'Guardaespaldas';

  @override
  String get bodyguardStandardDesc =>
      'Protección estándar. +10 defensa y 10.000€ de jornal.';

  @override
  String get bodyguardElite => 'guardaespaldas de élite';

  @override
  String get bodyguardEliteDesc =>
      'Más cerca endurecido. Mayor defensa y un salario diario más elevado.';

  @override
  String get bodyguardDismiss => 'Despedir';

  @override
  String bodyguardCapLine(String used, String cap) {
    return '$used / $cap guardaespaldas';
  }

  @override
  String get bodyguardCapReached => 'Se alcanzó el límite de guardaespaldas';

  @override
  String bodyguardHired(String name) {
    return 'Contratada $name';
  }

  @override
  String bodyguardDismissed(String name) {
    return 'Descartado $name';
  }

  @override
  String armorConditionPercent(String percent) {
    return 'Condición $percent%';
  }

  @override
  String get securityErrorNoArmor => 'No llevas chaleco';

  @override
  String get securityErrorArmorNotDamaged =>
      'Este chaleco ya está en perfectas condiciones.';

  @override
  String get securityErrorBodyguardCap =>
      'Ya tienes el número máximo de guardaespaldas.';

  @override
  String get securityErrorInvalidBodyguardType =>
      'Tipo de guardaespaldas no válido';

  @override
  String get securityErrorNotEnoughBodyguards =>
      'No tienes tantos guardaespaldas de este tipo.';

  @override
  String get lightArmor => 'Armadura ligera';

  @override
  String get basicProtection => 'Protección básica';

  @override
  String get heavyArmor => 'Armadura pesada';

  @override
  String get strongProtection => 'Fuerte protección';

  @override
  String get bulletproofVest => 'Chaleco antibalas';

  @override
  String get veryStrongProtection => 'Protección muy fuerte';

  @override
  String get stabVest => 'Chaleco antiapuñaladas';

  @override
  String get stabVestDesc => 'Protege contra cuchillos. Débil contra balas.';

  @override
  String get bulletproofVestDesc =>
      'Protección estándar contra munición ordinaria.';

  @override
  String get bulletproofVestPremium => 'Chaleco antibalas premium';

  @override
  String get bulletproofVestPremiumDesc =>
      'Placas más pesadas contra disparos normales.';

  @override
  String get ceramicApVest => 'Chaleco placas AP';

  @override
  String get ceramicApVestDesc =>
      'Placas cerámicas contra munición perforante.';

  @override
  String get vestProtectsStab => 'Puñalada';

  @override
  String get vestProtectsBullets => 'Balas';

  @override
  String get vestProtectsAp => 'Perforante';

  @override
  String get tacticalSuit => 'Equipo táctico';

  @override
  String get premiumProtection => 'Protección premium';

  @override
  String get defense => 'Defensa';

  @override
  String defenseIncrease(String armor, String defense) {
    return '¡Compraste $armor! +$defense defensa';
  }

  @override
  String get worn => 'Gastada';

  @override
  String get replaceArmor => 'Reemplazar';

  @override
  String get bodyguardProductName => 'Guardaespaldas';

  @override
  String securityLoadError(String error) {
    return 'Error al cargar seguridad: $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'No se pudo cargar el estado de seguridad.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Condición $percent% · base $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Salario diario $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Costo diario del sistema: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Próxima nómina: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Si no puedes pagar el salario diario, todos los guardaespaldas se van.';

  @override
  String get armorOneAtATimeHint =>
      'Sólo puedes usar 1 chaleco a la vez. Repare un chaleco dañado o compre otro y obtenga un intercambio basado en el estado del chaleco que reemplaza.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Ahora +$defense al $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'No se pudo comprar guardaespaldas';

  @override
  String get couldNotBuyArmor => 'No se pudo comprar armadura';

  @override
  String get armorAlreadyEquippedLong =>
      'Ya llevas esta armadura. Sólo puedes usar 1 armadura a la vez.';

  @override
  String get securityErrorArmorNotFound => 'Armadura no encontrada';

  @override
  String get securityErrorMinQuantity => 'La cantidad debe ser al menos 1';

  @override
  String get hit => 'GOLPEAR';

  @override
  String get counterBidLabel => 'CONTRAOFERTA';

  @override
  String daysAgo(String count, String plural) {
    return 'Hace $count día$plural';
  }

  @override
  String get justPlaced => 'Recién colocado';

  @override
  String get youAreTheTarget => 'tu eres el objetivo';

  @override
  String get youAreThePlacer => 'Eres la placer';

  @override
  String get onlyTargetCanCounterBid =>
      'Sólo el objetivo puede realizar una contraoferta.';

  @override
  String get executeHit => 'Ejecutar golpe';

  @override
  String get moneyNotEnough => 'No tienes suficiente dinero';

  @override
  String get securityScreen => 'Seguridad';

  @override
  String get currentDefenseStatus => 'Estado de defensa actual';

  @override
  String get noWeapons => 'No tienes armas en tu inventario.';

  @override
  String get ammoQuantity => 'Cantidad de munición';

  @override
  String get noAmmoRequired => 'No se requiere munición para esta arma.';

  @override
  String get weaponStats => 'Estadísticas de armas';

  @override
  String get damage => 'Daño';

  @override
  String get intimidation => 'Intimidación';

  @override
  String get execute => 'Ejecutar';

  @override
  String get hitExecuted => '¡El golpe se ejecutó con éxito!';

  @override
  String get hitDefendedBySecurity =>
      'El objetivo sobrevivió: el contrato sigue abierto. Los guardaespaldas y HP fueron alcanzados; Inténtalo de nuevo después del tiempo de reutilización.';

  @override
  String hitDefendedAttrition(String guards, String health) {
    return '$guards guardaespaldas caídos, objetivo -$health HP. Próximo intento en 10 minutos.';
  }

  @override
  String hitCombatAttackerAttrition(String guards, String health) {
    return 'Perdiste $guards guardaespaldas y $health HP.';
  }

  @override
  String hitlistErrCombatCooldown(String minutes) {
    return 'El objetivo todavía está bajo fuego. Inténtalo de nuevo en $minutes minutos.';
  }

  @override
  String hitCombatBreakdown(String armor, String guards, String chance) {
    return 'Chaleco +$armor · guardaespaldas +$guards · tu probabilidad $chance%';
  }

  @override
  String get invalidAmmo => 'Por favor ingresa una cantidad de munición válida';

  @override
  String get weaponsMarket => 'Mercado de armas';

  @override
  String get ammoMarket => 'Mercado de munición';

  @override
  String get shootingRange => 'Campo de tiro';

  @override
  String get ammoFactory => 'Fábrica de municiones';

  @override
  String get weaponShop => 'Tienda de armas';

  @override
  String get myWeapons => 'mis armas';

  @override
  String get weaponPurchased => 'Arma comprada';

  @override
  String weaponRankRequired(String rank) {
    return 'Rango requerido: $rank';
  }

  @override
  String get buyWeapon => 'Comprar';

  @override
  String get ammoShop => 'Mercado de munición';

  @override
  String get myAmmo => 'mi munición';

  @override
  String get ammoPurchased => 'Munición comprada';

  @override
  String get purchaseCooldown => 'Debes esperar antes de la próxima compra.';

  @override
  String get insufficientStock => 'No hay suficiente stock disponible';

  @override
  String get maxInventoryReached => 'Capacidad máxima de inventario alcanzada';

  @override
  String get invalidQuantity => 'Cantidad no válida';

  @override
  String get nextAmmoPurchase => 'Próxima compra disponible en';

  @override
  String get ammoBoxes => 'Cajas';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds rondas por caja';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Recibirás: $rounds rondas';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Coste total: €$cost';
  }

  @override
  String get ammoRounds => 'rondas';

  @override
  String get ammoGeneric => 'Munición';

  @override
  String get ammoPerCrimeSuffix => 'por delito';

  @override
  String get ammoBoxesUnit => 'cajas';

  @override
  String get ammoStock => 'Existencias';

  @override
  String get ammoQuality => 'Calidad';

  @override
  String get factoryBought => 'Comprado de fábrica';

  @override
  String get factoryProduced => 'Producción actualizada';

  @override
  String get factorySessionStarted =>
      'Producción iniciada: activo durante 8 horas, reclamo cada 20 minutos';

  @override
  String get ammoFactoryTitle => 'Fábrica de municiones';

  @override
  String get ammoFactoryIntro =>
      'Produce en lotes; reclamas cada 20 minutos (hasta 8 horas de trabajo pendiente por sesión).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Qué puedes hacer:';

  @override
  String get ammoFactoryActionBuy => 'Compra una fábrica en tu país actual';

  @override
  String get ammoFactoryActionProduce =>
      'Producción de reclamos (intervalo: 20 minutos, trabajo pendiente máximo: 8 horas por sesión)';

  @override
  String get ammoFactoryActionOutput =>
      'Actualice la producción al nivel 5 para obtener más rondas por reclamo';

  @override
  String get ammoFactoryActionQuality =>
      'Mejorar la calidad para obtener precios de mercado más fuertes';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munición a la venta';

  @override
  String get ammoFactoryBlackMarketBody =>
      'La fábrica de munición no vende balas directamente desde esta pantalla. Utilice el mercado negro para comprar y vender munición.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Compra y vende munición a través del Mercado Negro, no directamente desde la fábrica.';

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
  String get ammoFactoryErrCountryRequired => 'Se requiere país';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Jugadora no encontrada';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Debes estar en el mismo país para comprar esta fábrica.';

  @override
  String get ammoFactoryErrCouldNotPurchase => 'No se pudo comprar la fábrica';

  @override
  String get ammoFactoryErrAlreadyOwned => 'La fábrica ya es propiedad';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'No hay suficiente dinero para comprar una fábrica.';

  @override
  String get ammoFactoryErrCouldNotProduce => 'No se pudo producir munición';

  @override
  String get ammoFactoryErrNotOwned => 'No eres dueño de una fábrica.';

  @override
  String get ammoFactoryErrOnCooldown => 'La fábrica está en enfriamiento.';

  @override
  String get ammoFactoryErrInactive =>
      'Propiedad de la fábrica perdida debido a la inactividad';

  @override
  String get ammoFactoryErrCouldNotUpgrade =>
      'No se pudo actualizar la fábrica';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'No hay suficiente dinero para mejorar la fábrica';

  @override
  String get ammoFactoryErrMaxLevel => 'La fábrica ya está en el nivel máximo.';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'El tipo de actualización debe ser salida o calidad.';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Requisitos educativos no cumplidos.';

  @override
  String get factoryUpgradeOutputSuccess => 'Salida mejorada';

  @override
  String get factoryUpgradeQualitySuccess => 'Calidad mejorada';

  @override
  String get myFactory => 'mi fabrica';

  @override
  String get noFactoryOwned => 'No eres dueño de una fábrica.';

  @override
  String get factoryCountry => 'País';

  @override
  String get factoryOutputLevel => 'Nivel de salida';

  @override
  String get factoryQualityLevel => 'Nivel de calidad';

  @override
  String get factoryLastProduced => 'último producido';

  @override
  String get factoryProduceStatusLabel => 'Estado de producción';

  @override
  String get factoryProduceStatusReady => 'Listo';

  @override
  String get factoryProduceStatusCooldown => 'En espera';

  @override
  String get factorySessionActive =>
      'Ventana de producción: activa (intervalo de 20 min)';

  @override
  String get factorySessionStopped =>
      'Ventana de producción: detenida (haga clic en Producir para iniciar una nueva ventana de 8 horas)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'La ventana termina en: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Próxima producción: disponible ahora (presione Producir para reclamar)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Próxima producción en: $duration';
  }

  @override
  String get factoryProduce => 'Producir';

  @override
  String get factoryUpgradeOutput => 'Salida de actualización';

  @override
  String get factoryUpgradeQuality => 'Calidad de actualización';

  @override
  String get factoryList => 'Fábricas por país';

  @override
  String get factoryUnowned => 'Disponible';

  @override
  String factoryOwnedBy(String owner) {
    return 'Propietario: $owner';
  }

  @override
  String get factoryBuy => 'Comprar';

  @override
  String get shootingIntro =>
      'Mejore su precisión y aumente su tasa de éxito en delitos';

  @override
  String get shootingTrainSuccess => 'Entrenamiento completa';

  @override
  String get shootingMaxSessionsReached =>
      'Se alcanzó el máximo de sesiones de entrenamiento';

  @override
  String get shootingTrainingProgressTitle => 'Progreso del entrenamiento';

  @override
  String get shootingSessionsCompletedLabel => 'Sesiones completadas:';

  @override
  String get shootingProgressCompleteSuffix => 'completa';

  @override
  String get shootingCurrentBonusTitle => 'Bono actual';

  @override
  String get shootingAccuracyBonusLabel => 'Bonificación de precisión';

  @override
  String get shootingMaximumLabel => 'Máxima';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Este bono se aplica a todos tus intentos de delito.';

  @override
  String get shootingReadyToTrain => 'Listo para entrenar';

  @override
  String get shootingTrainingCooldownTitle => 'Enfriamiento de entrenamiento';

  @override
  String shootingCooldownLabel(String time) {
    return 'Próxima sesión a las: $time';
  }

  @override
  String get shootingCooldownHint =>
      'Debes esperar 1 hora entre entrenamientos.';

  @override
  String get shootingTrainingInProgress => 'Capacitación...';

  @override
  String get shootingHowItWorksTitle => '¿Cómo funciona?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Entrena cada hora para aumentar la precisión';

  @override
  String get shootingHowItWorksBullet2 =>
      '• Cada sesión otorga un bono de +0,1%';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Máximo de 100 sesiones (+10% total)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Aumenta su tasa de éxito en el crimen';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Bono permanente, cada sesión cuenta';

  @override
  String shootingSessions(String count) {
    return 'Sesiones: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Bonificación de precisión: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Próxima sesión a las $time';
  }

  @override
  String get shootingTrain => 'Entrenar';

  @override
  String get trainingHubMenuLabel => 'Capacitación';

  @override
  String get trainingHubTitle => 'Centro de formación';

  @override
  String get trainingHubSubtitle =>
      'Desarrolla fuerza en el gimnasio y precisión en el campo. Cada pista acumula hasta 100 sesiones con un tiempo de reutilización de 1 hora y aumenta tus posibilidades de éxito en el crimen.';

  @override
  String get trainingHubSectionGym => 'Gimnasia';

  @override
  String get trainingHubSectionShooting => 'Campo de tiro';

  @override
  String get trainingHubRefreshStatus => 'Actualizar';

  @override
  String get trainingHubRefreshTooltip =>
      'Volver a cargar el estado desde el servidor';

  @override
  String get trainingHubOpenCrimes => 'Abrir delitos';

  @override
  String get trainingHubOpenCrimesHint =>
      'Los bonos activos se muestran en la pantalla de Delitos.';

  @override
  String get trainingHubMoreInfoTitle => 'Más información y opciones';

  @override
  String get trainingHubMoreInfoCombo =>
      'Mismo día UTC: completa al menos una sesión de gimnasio y una de campo de tiro para un pequeño extra de éxito en delitos (+0,5%).';

  @override
  String get trainingHubMoreInfoSeparate =>
      'Gimnasio y campo de tiro tienen cada uno su propia espera de 1 hora y tope de 100 sesiones.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'El progreso en el campo de tiro también entra en los cálculos de la lista negra en el servidor.';

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
    return 'Combo activo: +$pct% en delitos';
  }

  @override
  String get gym => 'Gimnasia';

  @override
  String get gymIntro =>
      'Entrena tu fuerza y ​​aumenta tu tasa de éxito en el crimen';

  @override
  String get gymTrainSuccess => 'Entrenamiento completa';

  @override
  String get gymMaxSessionsReached => 'Sesiones máximas alcanzadas';

  @override
  String get gymTrainingProgressTitle => 'Progreso del entrenamiento';

  @override
  String get gymSessionsCompletedLabel => 'Sesiones completadas:';

  @override
  String get gymProgressCompleteSuffix => 'completa';

  @override
  String get gymCurrentBonusTitle => 'Bono actual';

  @override
  String gymSessions(String count) {
    return 'Sesiones: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Bonificación de fuerza';

  @override
  String get gymMaximumLabel => 'Máxima';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonificación de fuerza: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Este bono se aplica a todos tus intentos de delito.';

  @override
  String get gymReadyToTrain => 'Listo para entrenar';

  @override
  String get gymTrainingCooldownTitle => 'Enfriamiento de entrenamiento';

  @override
  String gymCooldown(String time) {
    return 'Próxima sesión a las $time';
  }

  @override
  String get gymCooldownHint => 'Debes esperar 1 hora entre entrenamientos.';

  @override
  String get gymTrain => 'Tren';

  @override
  String get gymTrainingInProgress => 'Capacitación...';

  @override
  String get gymHowItWorksTitle => '¿Cómo funciona?';

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
      '• Entrena cada hora para aumentar tu fuerza';

  @override
  String get gymHowItWorksBullet2 => '• Cada sesión otorga un bono de +0,08%';

  @override
  String get gymHowItWorksBullet3 => '• Máximo de 100 sesiones (+8% total)';

  @override
  String get gymHowItWorksBullet4 => '• Aumenta su tasa de éxito en el crimen';

  @override
  String get gymHowItWorksBullet5 => '• Bono permanente, cada sesión cuenta';

  @override
  String get buyAmmo => 'Comprar munición';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Coste de compra: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Salida por ciclo: $amount unidades';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Multiplicador de calidad: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Salida de actualización - Coste: €$cost, Próxima salida: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Calidad de actualización - Coste: €$cost, Siguiente calidad: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Costo';

  @override
  String get factoryCurrentOutput => 'Salida actual';

  @override
  String get factoryNextOutput => 'Siguiente salida';

  @override
  String get factoryCurrentQuality => 'Calidad actual';

  @override
  String get factoryNextQuality => 'Siguiente calidad';

  @override
  String get factoryUnitsPerCycle => 'unidades/8h máx.';

  @override
  String get factoryUnitsPerHour => 'unidades/hora';

  @override
  String get factoryUpgradeMaxLevel => 'La fábrica está al nivel máximo.';

  @override
  String get countryUsa => 'EE.UU';

  @override
  String get countryMexico => 'México';

  @override
  String get countryColombia => 'Colombia';

  @override
  String get countryBrazil => 'Brasil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryJapan => 'Japona';

  @override
  String get countryChina => 'Porcelana';

  @override
  String get countryRussia => 'Rusia';

  @override
  String get countryIndia => 'India';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countrySouthAfrica => 'Sudáfrica';

  @override
  String get countryCanada => 'Canadá';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Irlanda';

  @override
  String get countryLuxembourg => 'Luxemburgo';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryDenmark => 'Dinamarca';

  @override
  String get countrySweden => 'Suecia';

  @override
  String get countryNorway => 'Noruega';

  @override
  String get countryFinland => 'Finlandia';

  @override
  String get countryPoland => 'Polonia';

  @override
  String get countryCzechia => 'Chequia';

  @override
  String get countryGreece => 'Grecia';

  @override
  String get countryTurkey => 'Pava';

  @override
  String get countryUae => 'Emiratos Árabes Unidos';

  @override
  String get countryDubai => 'Dubái';

  @override
  String get toolBoltCutter => 'Cortador de pernos';

  @override
  String get toolCarTheftTools => 'Herramientas de robo de autos';

  @override
  String get toolBurglaryKit => 'Kit de robo';

  @override
  String get toolToolbox => 'Caja de instrumento';

  @override
  String get toolCrowbar => 'Palanca';

  @override
  String get toolGlassCutter => 'Cortador de vidrio';

  @override
  String get toolSprayPaint => 'pintura en aerosol';

  @override
  String get toolJerryCan => 'Jerry puede';

  @override
  String get toolFakeDocuments => 'Documentos falsos';

  @override
  String get toolHackingLaptop => 'Hackear una computadora portátil';

  @override
  String get toolCounterfeitingKit => 'Kit de falsificación';

  @override
  String get toolRope => 'Soga';

  @override
  String get toolSilencer => 'Silenciador';

  @override
  String get toolNightVision => 'Visión nocturna';

  @override
  String get toolGpsJammer => 'Bloqueador GPS';

  @override
  String get toolBurnerPhone => 'Teléfono quemador';

  @override
  String get toolThermalDrill => 'Taladro térmico';

  @override
  String get toolCategoryBoltCutter => 'Cortadoras de pernos';

  @override
  String get toolCategoryBurglaryKit => 'kit de robo';

  @override
  String get toolCategoryCarTools => 'Herramientas para robo de autos';

  @override
  String get toolCategoryJerryCan => 'bidón';

  @override
  String get toolCategorySprayPaint => 'pintura en aerosol';

  @override
  String get toolCategoryCrowbar => 'Palanca';

  @override
  String get toolCategoryGlassCutter => 'cortador de vidrio';

  @override
  String get toolCategoryLaptop => 'Computadora portátil';

  @override
  String get toolCategoryCounterfeiting => 'falsificación';

  @override
  String get toolCategoryToolbox => 'Caja de instrumento';

  @override
  String get toolCategoryRope => 'Soga';

  @override
  String get toolCategorySilencer => 'Silenciador';

  @override
  String get toolCategoryFakeDocs => 'Documentos falsos';

  @override
  String get toolCategoryNightVision => 'Visión nocturna';

  @override
  String get toolCategoryBurnerPhone => 'teléfono quemador';

  @override
  String get toolCategoryGpsJammer => 'bloqueador de GPS';

  @override
  String get toolCategoryThermalDrill => 'taladro termico';

  @override
  String get toolsScreenTitle => 'Mercado negro – Herramientas';

  @override
  String get toolsTabBuy => 'Comprar';

  @override
  String get toolsTabMyTools => 'mis herramientas';

  @override
  String get toolsNoToolsAvailable => 'No hay herramientas disponibles';

  @override
  String get toolsEmptyInventoryTitle => 'Aún no tienes herramientas';

  @override
  String get toolsEmptyInventoryHint => 'Comprar herramientas en la tienda.';

  @override
  String get toolsNotEnoughMoney => '¡No tienes suficiente dinero!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      '¡No tienes suficiente dinero para la reparación!';

  @override
  String get toolsBuyError => 'Error al comprar';

  @override
  String get toolsRepairError => 'Error al reparar';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName comprado!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName reparado por ⟦1€⟧';
  }

  @override
  String get toolsBadgeInventoryFull => 'LLENA';

  @override
  String get toolsBadgeBroken => 'ROTA';

  @override
  String get toolsBadgeRepair => 'REPARAR';

  @override
  String toolsLoadError(String error) {
    return 'No se pudieron cargar herramientas: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Herramienta no encontrada.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Tu inventario está lleno. Almacene algunas herramientas o actualice la capacidad.';

  @override
  String get toolsErrPurchaseServer =>
      'La compra de herramientas falló debido a un problema con el servidor.';

  @override
  String get toolsErrToolNotOwned => 'No eres dueño de esta herramienta.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'La herramienta ya tiene su máxima durabilidad.';

  @override
  String get toolsErrRepairServer =>
      'La reparación de la herramienta falló debido a un problema del servidor.';

  @override
  String toolsNetworkError(String error) {
    return 'Error de red: $error';
  }

  @override
  String get crimeOutcomeSuccess => '¡Crimen exitoso!';

  @override
  String get crimeOutcomeFailed => 'Crimen fallido';

  @override
  String get jobOutcomeSuccess => '¡Trabajo completado!';

  @override
  String get crimeOutcomeCaught => 'Atrapado por la policía';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Su vehículo se averió antes de llegar a la escena del crimen.';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'El vehículo se averió durante la fuga; la mayor parte del botín se abandonó';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Se quedó sin combustible durante la fuga: huyó a pie, perdió el botín y el vehículo';

  @override
  String get crimeOutcomeToolBroke =>
      'Su herramienta se rompió durante el crimen, dejando evidencia';

  @override
  String get crimeOutcomeFledNoLoot => 'Huyó de la escena sin botín.';

  @override
  String get crimeResultMoneyLabel => 'Dinero';

  @override
  String get crimeResultXpLabel => 'experiencia';

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
  String get crimeOutcomeRowReward => 'Recompensa:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Herramientas:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% de durabilidad';
  }

  @override
  String get icuIntensiveCareTitle => 'UCI';

  @override
  String get icuInjuredLine =>
      'Resultaste gravemente herido en tus actividades delictivas.';

  @override
  String get icuUnconsciousLine =>
      'Estás en cuidados intensivos e inconsciente.';

  @override
  String get icuRecoveryTimeLabel => 'Tiempo de recuperación:';

  @override
  String get icuWakeHp => 'Despiertas con 10 HP';

  @override
  String get icuNoActionsHint =>
      'No puedes realizar acciones durante este tiempo.\n¡Cuida más tu salud!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 ¡Libre! Fianza pagada: €$amount';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Dinero insuficiente para la fianza (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Espera: ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => '¡La fuga tuvo éxito! Eres libre.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'La fuga falló. Sentencia ampliada por $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Escape fallido';

  @override
  String jailErrorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get jailTimeLeft => 'Tiempo restante';

  @override
  String jailPayBail(int amount) {
    return 'Pagar fianza (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'No puedes cometer crímenes, trabajar o viajar mientras cumples condena.';

  @override
  String get jailAttemptEscape => 'Intentar fuga';

  @override
  String jailEscapeAttemptsLeft(String remaining, String max) {
    return 'Intento de fuga ($remaining/$max)';
  }

  @override
  String jailEscapeCooldown(String time) {
    return 'Próximo escape en $time';
  }

  @override
  String get jailEscapeAttemptsExhausted =>
      'Ningún intento de fuga dejó esta frase.';

  @override
  String get jailYouAreInJail => 'Estás en prisión';

  @override
  String get vehicleCondition => 'Condición';

  @override
  String get vehicleFuel => 'Combustible';

  @override
  String get vehicleSpeed => 'Velocidad';

  @override
  String get vehicleArmor => 'Armadura';

  @override
  String get vehicleStealth => 'Sigilo';

  @override
  String get vehicleCargo => 'Carga';

  @override
  String get vehicleRepair => 'Reparar';

  @override
  String get vehicleRefuel => 'Repostar';

  @override
  String get selectCrimeVehicle => 'Seleccionar vehículo para delitos';

  @override
  String get noVehicleSelected => 'Ningún vehículo seleccionado';

  @override
  String get selectedVehicle => 'Vehículo del crimen';

  @override
  String get changeVehicle => 'Cambiar vehículo';

  @override
  String get selectVehicle => 'Seleccionar vehículo';

  @override
  String get vehicleConditionLow => 'Condición del vehículo baja';

  @override
  String get vehicleFuelLow => 'Combustible bajo del vehículo';

  @override
  String get vehicleSelectedForCrimes => '¡Vehículo seleccionado para delitos!';

  @override
  String get vehicleDeselectedForCrimes =>
      '¡Vehículo no seleccionado por delitos!';

  @override
  String get vehicleWrongCountry =>
      'El vehículo debe estar en el mismo país que usted.';

  @override
  String get failedSelectVehicle => 'No se pudo seleccionar el vehículo';

  @override
  String get failedDeselectVehicle =>
      'No se pudo anular la selección del vehículo';

  @override
  String get selectedForCrimesBadge => 'Seleccionado por crímenes';

  @override
  String get selectedButton => 'Seleccionada';

  @override
  String get selectButton => 'Seleccionar';

  @override
  String get deselectButton => 'Deseleccionar';

  @override
  String get prostitutionTitle => 'Prostitución';

  @override
  String get prostitutionTotal => 'Total';

  @override
  String get prostitutionStreet => 'En la calle';

  @override
  String get prostitutionRedLight => 'Luz roja';

  @override
  String get prostitutionPotentialEarnings => 'Ganancias';

  @override
  String get prostitutionCollect => 'Recolectar';

  @override
  String get prostitutionRecruit => 'Recluta';

  @override
  String get prostitutionMyProstitutes => 'mis prostitutas';

  @override
  String get prostitutionRedLightDistricts => 'Barrios rojos';

  @override
  String get prostitutionNoProstitutes => 'Aún no se han reclutado prostitutas';

  @override
  String get prostitutionLocation => 'Ubicación';

  @override
  String get prostitutionMoveToRedLight => 'Ir al barrio rojo';

  @override
  String get prostitutionMoveToRldShort => 'A RLD';

  @override
  String get prostitutionMoveToStreet => 'Mover a la calle';

  @override
  String get prostitutionViewDistricts => 'Ver distritos';

  @override
  String get prostitutionAvailable => 'Disponible';

  @override
  String get prostitutionMyDistricts => 'Mis distritos';

  @override
  String get prostitutionCurrentRLD => 'RLD actual';

  @override
  String get prostitutionMyRLDs => 'Mis RLD';

  @override
  String get prostitutionNoAvailableDistricts => 'No hay distritos disponibles';

  @override
  String get prostitutionNoOwnedDistricts =>
      'Aún no eres propietario de ningún distrito';

  @override
  String get prostitutionRooms => 'alojamiento';

  @override
  String get prostitutionOccupancy => 'Ocupación';

  @override
  String get prostitutionIncome => 'Ingreso';

  @override
  String get prostitutionTenants => 'Inquilinas';

  @override
  String get prostitutionBuy => 'Comprar';

  @override
  String get prostitutionManage => 'Administrar';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Comprar Distrito';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return '¿Estás seguro de que quieres comprar el Barrio Rojo en $country por $price€?';
  }

  @override
  String get prostitutionPurchase => 'Comprar';

  @override
  String get prostitutionPurchaseSuccess => '¡Distrito comprado con éxito!';

  @override
  String get prostitutionPurchaseFailed => 'Compra fallida';

  @override
  String get prostitutionDistrictManagement => 'Gestión Distrital';

  @override
  String get prostitutionDistrictNotFound => 'Distrito no encontrado';

  @override
  String get prostitutionDistrictOwnedBadge => 'Propiedad';

  @override
  String get prostitutionOwnerLabel => 'Dueña:';

  @override
  String get prostitutionForSale => 'En venta';

  @override
  String get prostitutionRoomsLabel => 'Alojamiento:';

  @override
  String get prostitutionRoomsRented => 'alquilada';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Barrio Rojo ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Ocupada';

  @override
  String get prostitutionNotApplicable => 'N / A';

  @override
  String get back => 'Atrás';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return '¿Estás seguro de que quieres mudarte $name del Barrio Rojo a la calle?';
  }

  @override
  String get prostitutionMoveSuccess => 'movido con éxito';

  @override
  String get prostitutionMoveFailed => 'Movimiento fallido';

  @override
  String get prostitutionNoStreetProstitutes =>
      'No hay prostitutas disponibles en la calle.';

  @override
  String get prostitutionSelectProstitute => 'Seleccionar prostituta';

  @override
  String get prostitutionOnStreet => 'en la calle';

  @override
  String get prostitutionRoom => 'Habitación';

  @override
  String get prostitutionInRedLight => 'En el Barrio Rojo';

  @override
  String get prostitutionEarnings => 'Ganancias';

  @override
  String get prostitutionRent => 'Alquilar';

  @override
  String get prostitutionNetIncome => 'Lngresos netos';

  @override
  String get prostitutionLevel => 'Nivel';

  @override
  String get prostitutionXpToNext => 'XP al siguiente nivel';

  @override
  String get prostitutionBusted => 'ARRESTADA';

  @override
  String get prostitutionBustedCount => 'Tiempos reventados';

  @override
  String get prostitutionLevelBonus => 'Bonificación de nivel';

  @override
  String get prostitutionVipBonus => 'Bono VIP: +50% de ganancias';

  @override
  String get prostitutionUpgradeTier => 'Nivel de actualización';

  @override
  String get prostitutionUpgradeSecurity => 'Actualizar seguridad';

  @override
  String get prostitutionTier => 'Nivel';

  @override
  String get prostitutionSecurity => 'Seguridad';

  @override
  String get prostitutionTierBasic => 'Básica';

  @override
  String get prostitutionTierLuxury => 'Lujo';

  @override
  String get prostitutionTierVip => 'personaje';

  @override
  String get prostitutionSecurityLevel => 'Nivel de seguridad';

  @override
  String get prostitutionRaidChance => 'Probabilidad de incursión';

  @override
  String get prostitutionMaxTier => 'Nivel máximo alcanzado';

  @override
  String get prostitutionMaxSecurity => 'Seguridad máxima alcanzada';

  @override
  String get prostitutionUpgradeSuccess => '¡Actualización exitosa!';

  @override
  String get prostitutionUpgradeFailed => 'La actualización falló';

  @override
  String get prostitutionTabWorkers => 'Trabajadores';

  @override
  String get prostitutionTabRld => 'RLD';

  @override
  String get prostitutionTabEvents => 'Eventos';

  @override
  String get prostitutionTabSocial => 'Social';

  @override
  String get prostitutionRecruitCeremonyTitle => 'Nuevo recluta';

  @override
  String prostitutionCollectConfirm(String amount) {
    return '¿Cobrar$amount€ en ganancias pendientes?';
  }

  @override
  String get prostitutionCollectEmpty =>
      'No hay ganancias para cobrar en este momento.';

  @override
  String prostitutionCollectSuccess(String amount) {
    return 'Recaudado$amount€.';
  }

  @override
  String get prostitutionCollectFailed =>
      'No se pudieron cobrar las ganancias.';

  @override
  String get prostitutionWorkersKpi => 'Trabajadores (S/RLD/NC)';

  @override
  String get prostitutionHourlyKpi => '€/hora';

  @override
  String get prostitutionRecruitReady => 'Listo';

  @override
  String get prostitutionRetry => 'Rever';

  @override
  String get prostitutionMove => 'Mover';

  @override
  String get prostitutionFbiHeat => 'Calor del FBI';

  @override
  String get prostitutionRaidStatsTitle => 'Riesgo de incursión';

  @override
  String get prostitutionRaidStatsDistricts => 'Distritos';

  @override
  String get prostitutionRaidStatsBusted => 'Actualmente arrestado';

  @override
  String prostitutionUpgradeTierConfirm(String tier, String cost) {
    return '¿Actualizar de nivel a $tier por €$cost?';
  }

  @override
  String prostitutionUpgradeSecurityConfirm(String level, String cost) {
    return '¿Actualizar la seguridad al nivel $level por $cost€?';
  }

  @override
  String prostitutionRoomsOccupied(String occupied, String total) {
    return '$occupied/$total habitaciones';
  }

  @override
  String prostitutionNextEarnings(String net) {
    return 'Siguiente: €$net/h neto';
  }

  @override
  String prostitutionCurrentEarningsNet(String net) {
    return 'Ahora: €$net/h neto';
  }

  @override
  String prostitutionRaidReduction(String pct) {
    return 'Reducción de incursiones: $pct';
  }

  @override
  String get vipEventsTitle => 'Eventos VIP';

  @override
  String get vipEventsTabTitle => 'Eventos VIP';

  @override
  String get vipEventsDescription =>
      '¡Asigna prostitutas a eventos VIP para obtener ganancias adicionales!';

  @override
  String get vipEventsActive => 'Eventos activos';

  @override
  String get vipEventsUpcoming => 'Próximos eventos';

  @override
  String get vipEventsMyParticipations => 'Mis Participaciones Activas';

  @override
  String get vipEventTypeTitle => 'Evento VIP';

  @override
  String get vipEventCelebrity => 'Visita de celebridades';

  @override
  String get vipEventBachelor => 'despedida de soltero';

  @override
  String get vipEventConvention => 'Convención';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'PRIMA';

  @override
  String get vipEventSpots => 'manchas';

  @override
  String get vipEventParticipants => 'Las participantes';

  @override
  String get vipEventFull => 'EVENTO COMPLETO';

  @override
  String get vipEventRequires => 'Requiere';

  @override
  String get vipEventLevel => 'Nivel';

  @override
  String get vipEventLocation => 'Ubicación';

  @override
  String get vipEventEndsIn => 'termina en';

  @override
  String get vipEventStartsIn => 'Comienza en';

  @override
  String get vipEventNoActive => 'No hay eventos activos en este momento.';

  @override
  String get vipEventNoUpcoming => 'No hay eventos próximos';

  @override
  String get vipEventAssignProstitute => 'Asignar prostituta';

  @override
  String get vipEventAssignDialogTitle => 'Asignar a';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'No hay prostitutas elegibles. Necesita nivel $level+ en $country';
  }

  @override
  String get vipEventJoinSuccess => '¡Evento unido!';

  @override
  String get vipEventJoinFailed => 'No se pudo unir al evento';

  @override
  String get vipEventLeave => 'Dejar evento';

  @override
  String get vipEventLeaveSuccess => 'Evento izquierdo';

  @override
  String get vipEventLeaveFailed => 'No se pudo abandonar el evento';

  @override
  String get vipEventAssigned => 'Asignado';

  @override
  String get vipEventPerHour => '/hora';

  @override
  String get vipEventEarnings => 'Ganancias';

  @override
  String get prostitutionLeaderboardTitle => 'Clasificación de prostitución';

  @override
  String get prostitutionLeaderboardWeekly => 'Semanalmente';

  @override
  String get prostitutionLeaderboardMonthly => 'Mensual';

  @override
  String get prostitutionLeaderboardAllTime => 'Todos los tiempos';

  @override
  String get prostitutionLeaderboardYourRank => 'Tu rango semanal';

  @override
  String get prostitutionLeaderboardUnranked => 'Sin clasificar';

  @override
  String get prostitutionLeaderboardNoData =>
      'Aún no hay datos de clasificación';

  @override
  String get prostitutionLeaderboardButton => 'Tabla de clasificación';

  @override
  String get prostitutionRivalryButton => 'Rivalidad';

  @override
  String get prostitutionLeaderboardAchievements => 'Logros';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'No se pudo cargar la tabla de clasificación';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked de $total desbloqueado';
  }

  @override
  String get achievementsCategoryAll => 'Toda';

  @override
  String get achievementsCategoryProgression => 'Progresión';

  @override
  String get achievementsCategoryWealth => 'Poder';

  @override
  String get achievementsCategoryPower => 'Fuerza';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMastery => 'Maestría';

  @override
  String get achievementLocked => 'Bloqueada';

  @override
  String get achievementReward => 'Premio';

  @override
  String get achievementUnlocked => 'Desbloqueada';

  @override
  String get achievementNoData => 'No se encontraron logros';

  @override
  String get achievementLoadFailed => 'No se pudieron cargar los logros';

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
    return 'Desbloqueado el $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Progreso: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Aún no se ha configurado ninguna recompensa';

  @override
  String get achievementsRewardOnUnlock =>
      'Recibirás esta recompensa una vez que se desbloquee el logro.';

  @override
  String get achievementsDateToday => 'Hoy';

  @override
  String get achievementsDateYesterday => 'Ayer';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days hace días';
  }

  @override
  String get achievementsDetails => 'Detalles';

  @override
  String get achievementsCategory => 'Categoría';

  @override
  String get achievementsSectionProgress => 'Progreso';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent % completado';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostitución';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Delitos';

  @override
  String get achievementsCategoryNameJobs => 'Trabajos';

  @override
  String get achievementsCategoryNameSchool => 'Escuela';

  @override
  String get achievementsCategoryNameVehicles => 'Vehículos';

  @override
  String get achievementsCategoryNameTravel => 'Viajes';

  @override
  String get achievementsCategoryNameDrugs => 'Drogas';

  @override
  String get achievementsCategoryNameTrade => 'Comercio';

  @override
  String get achievementsCategoryNameGeneral => 'General';

  @override
  String get achievementJobItSpecialistTitle => 'Especialista en TI';

  @override
  String get achievementJobItSpecialistDescription =>
      'Completa tu primer turno como programadora';

  @override
  String get achievementJobLawyerTitle => 'Abogado callejero';

  @override
  String get achievementJobLawyerDescription =>
      'Completa tu primer turno como Abogado';

  @override
  String get achievementJobDoctorTitle => 'Doctora subterránea';

  @override
  String get achievementJobDoctorDescription =>
      'Completa tu primer turno como doctora';

  @override
  String get achievementSchoolCertifiedTitle => 'Estudiante certificada';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Obtén 3 certificaciones escolares';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multicertificado';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Obtén 6 certificaciones escolares';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Especialista en pista';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Maximiza 3 pistas escolares';

  @override
  String get schoolMenuLabel => 'Escuela';

  @override
  String get schoolMenuSubtitle => 'Nivela tu educación y certificaciones';

  @override
  String get schoolTitle => 'Escuela y educación';

  @override
  String get schoolIntro =>
      'Desbloquee trabajos y activos a través de niveles y certificaciones.';

  @override
  String get schoolTracksTitle => 'Educaciones disponibles';

  @override
  String get schoolUnlockableContentTitle => 'Educaciones bloqueadas';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Nivel escolar: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'No se pudieron cargar los datos de la escuela: $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Nivel $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'XP: $xp';
  }

  @override
  String schoolTrainBonusLevels(int count) {
    return '+$count niv.';
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
    return '$name (Nivel $level)';
  }

  @override
  String get schoolGateStatusOpen => 'ABIERTA';

  @override
  String get schoolGateStatusLocked => 'BLOQUEADA';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Rango de jugador: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track nivel: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Trabajo: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Activo: compra de casino';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Activo: Compra de fábrica de munición';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Activo: mejora de la producción de munición';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Activo: mejora de la calidad de la munición';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Activo: Actualización de espacio para instalaciones farmacéuticas I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Activo: Actualización de espacio para instalaciones farmacéuticas II';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Activo: Actualización de espacio para instalaciones farmacéuticas III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Activo: Actualización de espacio para instalaciones farmacéuticas IV';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Activo: Actualización del equipo de las instalaciones farmacéuticas I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Activo: Actualización del equipo de las instalaciones farmacéuticas II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Activo: Actualización del equipo de las instalaciones farmacéuticas III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Activo: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Se requiere educación';

  @override
  String get educationDialogFallbackMessage =>
      'Requisitos no cumplidos. Completar los requisitos educativos para continuar.';

  @override
  String get educationDialogClose => 'Cerca';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Trabajos bloqueados (se requiere educación)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Actualización de salida bloqueada';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Actualización de calidad bloqueada';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Compra de fábrica bloqueada';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Necesita rango de jugador $requiredRank · Rango de jugador actual $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Nivel educativo';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName nivel $requiredLevel requerido · Actual $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle =>
      'Certificación requerida';

  @override
  String get educationRequirementGenericTitle => 'Requisito';

  @override
  String get educationRequirementUnknown => 'Requisito desconocido';

  @override
  String get educationTrackNameAviation => 'Aviación';

  @override
  String get educationTrackNameLaw => 'Ley';

  @override
  String get educationTrackNameMedicine => 'Medicamento';

  @override
  String get educationTrackNameFinance => 'Finanzas';

  @override
  String get educationTrackNameEngineering => 'Ingeniería';

  @override
  String get educationTrackNameIt => 'ÉL';

  @override
  String get educationTrackNameNarcotics => 'Ingeniería de Narcóticos';

  @override
  String get schoolTrackDescriptionAviation =>
      'Teoría de vuelo, navegación y operación de aeronaves.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Derecho penal, procedimiento y práctica judicial.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Respuesta a emergencias, diagnóstico y práctica médica.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Contabilidad, inversiones y operaciones comerciales.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Sistemas mecánicos, seguridad industrial y fabricación.';

  @override
  String get schoolTrackDescriptionIt =>
      'Desarrollo de software, sistemas y operaciones de redes.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Cultivo controlado, proceso eléctrico y producción química avanzada.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Enfriamiento activo: ${seconds}s restantes';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'La pista ya está en el nivel máximo.';

  @override
  String get schoolTrackStartFailed => 'No se pudo iniciar el entrenamiento';

  @override
  String get educationCertHydroponicSpecialist =>
      'Certificación de especialista en hidroponía';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Certificación de Especialista en Electricidad de Procesos';

  @override
  String get educationCertClandestineChemist =>
      'Certificación de Químico Clandestino';

  @override
  String get educationCertNarcoGridArchitect =>
      'Certificación de arquitecto Narco Grid';

  @override
  String get educationCertSoftwareEngineer =>
      'Certificación de ingeniero de software';

  @override
  String get educationCertBarExam => 'Examen de la barra';

  @override
  String get educationCertMedicalLicense => 'Licencia Médica';

  @override
  String get educationCertFlightCommercial => 'Licencia de vuelo comercial';

  @override
  String get educationCertFlightBasic => 'Licencia de vuelo básica';

  @override
  String get educationCertIndustrialSafety =>
      'Certificación de Seguridad Industrial';

  @override
  String get educationCertFinancialAnalyst =>
      'Certificación de analista financiero';

  @override
  String get educationCertCasinoManagement =>
      'Certificación de gestión de casinos';

  @override
  String get educationCertParamedic => 'Certificación de paramédico';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostitutas';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'distritos';

  @override
  String get rivalryTitle => 'Rivalidad';

  @override
  String get rivalryChallengeTitle => 'Jugador de desafío';

  @override
  String get rivalryChallengeHint =>
      'Introduce un nombre de jugador (o ID) para iniciar una rivalidad.';

  @override
  String get rivalryPlayerIdHint => 'Nombre o ID del jugador';

  @override
  String get rivalryStartButton => 'Comenzar';

  @override
  String get rivalryNoActive => 'Aún no hay rivalidades activas.';

  @override
  String get rivalryActiveTitle => 'Rivales activos';

  @override
  String get rivalryScoreLabel => 'Puntuación de rivalidad';

  @override
  String get rivalryRecentActivity => 'Actividad reciente';

  @override
  String get rivalryNoActivity => 'Aún no hay actividad de sabotaje';

  @override
  String get rivalryCooldownReady => 'Sabotaje listo';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Enfriamiento: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Propina Policía (5k€)';

  @override
  String get rivalryActionStealCustomer => 'Robar Cliente (3k€)';

  @override
  String get rivalryActionDamageReputation => 'Reputación de daños (10.000 €)';

  @override
  String get rivalryActionBribeEmployee => 'Soborno a empleado (8k€)';

  @override
  String get rivalryUpdateMessage => 'Rivalidad actualizada';

  @override
  String get rivalrySabotageExecuted => 'Sabotaje ejecutado';

  @override
  String get rivalryConfirmTitle => 'Confirmar sabotaje';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Objetivo: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Acción: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Coste: €$amount';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Efecto: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'El éxito no está garantizado y puedes perder dinero.';

  @override
  String get rivalryExecuteButton => 'Ejecutar';

  @override
  String get rivalryEffectTipPolice => 'Aumentar la presión policial rival';

  @override
  String get rivalryEffectStealCustomer =>
      'Robar parte del flujo de caja rival';

  @override
  String get rivalryEffectDamageReputation =>
      'Menor progreso de las prostitutas rivales';

  @override
  String get rivalryEffectBribeEmployee =>
      'Obligar a una prostituta rival a ir a un estado arrestado';

  @override
  String get prostitutionUnderAttackTitle => 'Tu imperio está bajo ataque';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker usó $action contra ti en las últimas 24 horas.';
  }

  @override
  String get prostitutionUnderAttackAction => 'rivalidad abierta';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      '¡Traición! Tu club nocturno sufrió una filtración de información.';

  @override
  String get prostitutionLoadError => 'Error al cargar los datos';

  @override
  String get prostitutionNoDistrictInCountry =>
      'No hay distrito rojo en este país';

  @override
  String get prostitutionMovedToStreet => 'Trasladada a la calle';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Esta prostituta está arrestada y no puede asignarse.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Aún no tienes un local de club nocturno para asignar personal.';

  @override
  String get prostitutionNightclubVenueName => 'Club nocturno';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Club nocturno #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Asignada al club nocturno';

  @override
  String get prostitutionArrestedCannotWork =>
      'Esta prostituta está arrestada y no puede trabajar.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Aún $duration de descanso antes del siguiente turno.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Turno completado';

  @override
  String get prostitutionNoWorkersToAssign =>
      'No hay prostitutas disponibles para mandar a trabajar.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostitutas enviadas a trabajar.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success enviadas a trabajar, $failed fallaron.';
  }

  @override
  String get prostitutionRecruitedDefault => '¡Reclutada!';

  @override
  String get prostitutionRecruitFailed => 'Reclutamiento fallido';

  @override
  String get prostitutionRecruitConnectionError =>
      'Reclutamiento fallido por error de conexión';

  @override
  String get prostitutionEventUpdate => 'Evento actualizado';

  @override
  String get prostitutionBuyPropertyFirst => 'Compra primero una casa o piso';

  @override
  String prostitutionWorkAll(int count) {
    return 'Mandar a todas a trabajar ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'No hay plaza de alojamiento libre. Compra o mejora una casa o piso antes de reclutar más prostitutas.';

  @override
  String get prostitutionHousingTitle => 'Alojamiento';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Cada prostituta debe trabajar al menos un turno cada $days días para pagar el alquiler.';
  }

  @override
  String get prostitutionHousingSlots => 'Plazas';

  @override
  String get prostitutionHousingFree => 'Libre';

  @override
  String get prostitutionHousingHomes => 'Viviendas';

  @override
  String get prostitutionHousingAvgUpgrade => 'Mejora media';

  @override
  String get prostitutionHousingHappinessBonus => 'Bonificación de felicidad';

  @override
  String get prostitutionHousingWeeklyRent => 'Alquiler semanal';

  @override
  String get prostitutionHousingAtRisk => 'En riesgo';

  @override
  String get prostitutionHousingSafe => 'A salvo';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Traición activada: $grams g de droga incautada(s), $licenses licencia(s) de club nocturno revocada(s).';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Resumen de ingresos (prostitutas activas)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Calle: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'Barrio rojo: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Club nocturno: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Total: €$euros/h';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Extático';

  @override
  String get prostitutionHappinessHappy => 'Feliz';

  @override
  String get prostitutionHappinessStable => 'Estable';

  @override
  String get prostitutionHappinessStressed => 'Estresado';

  @override
  String get prostitutionHappinessMiserable => 'Miserable';

  @override
  String get prostitutionHousingExpired => 'Caducado';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'quedan $days d.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Menos de 1 día';

  @override
  String get prostitutionNightclubShort => 'Club';

  @override
  String get prostitutionMoveToStreetButton => 'A la calle';

  @override
  String get prostitutionMoveToNightclubButton => 'Al club';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/h';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Felicidad $label ($score%) • Rendimiento $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Alojamiento: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Alquiler semanal €$amount';
  }

  @override
  String get prostitutionWork8h => 'Trabajar 8 h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Descansar $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Próximo turno en $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get rivalryProtectionTitle => 'Seguro de protección';

  @override
  String get rivalryProtectionDescription =>
      'Reduce el impacto del sabotaje entrante en un 30% durante 7 días.';

  @override
  String get rivalryProtectionInactive => 'Sin protección activa';

  @override
  String rivalryProtectionActive(String date) {
    return 'Activa hasta: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Compra de protección (25k€/semana)';

  @override
  String get rivalryProtectionActivated => 'Seguro de protección activado';

  @override
  String get achievementTitle_first_steps => 'Pinitos';

  @override
  String get achievementDescription_first_steps =>
      'Recluta a tu primera prostituta';

  @override
  String get achievementTitle_growing_empire => 'Imperio en crecimiento';

  @override
  String get achievementDescription_growing_empire => 'Recluta a 5 prostitutas';

  @override
  String get achievementTitle_first_district => 'Primer Distrito';

  @override
  String get achievementDescription_first_district =>
      'Compra tu primer barrio rojo';

  @override
  String get achievementTitle_empire_builder => 'Constructor de imperios';

  @override
  String get achievementDescription_empire_builder =>
      'Poseer 5 distritos de luz roja';

  @override
  String get achievementTitle_district_master => 'Maestro de distrito';

  @override
  String get achievementDescription_district_master => 'Poseer 10 zonas rojas';

  @override
  String get achievementTitle_leveling_master => 'Maestro de nivelación';

  @override
  String get achievementDescription_leveling_master =>
      'Lleva al máximo a una prostituta al nivel 10.';

  @override
  String get achievementTitle_untouchable => 'Intocable';

  @override
  String get achievementDescription_untouchable =>
      'Nunca te arresten durante 7 días consecutivos.';

  @override
  String get achievementTitle_millionaire => 'Millonaria';

  @override
  String get achievementDescription_millionaire =>
      'Acumular 1.000.000€ de ganancias totales';

  @override
  String get achievementTitle_high_roller => 'Gran apostador';

  @override
  String get achievementDescription_high_roller =>
      'Acumular 5.000.000€ de ganancias totales';

  @override
  String get achievementTitle_vip_service => 'Servicio VIP';

  @override
  String get achievementDescription_vip_service => 'Completa 10 eventos VIP';

  @override
  String get achievementTitle_event_enthusiast => 'Entusiasta de eventos';

  @override
  String get achievementDescription_event_enthusiast =>
      'Completa 25 eventos VIP.';

  @override
  String get achievementTitle_security_expert => 'Experto en seguridad';

  @override
  String get achievementDescription_security_expert =>
      'Maximizar el nivel de seguridad en todos los distritos de propiedad';

  @override
  String get achievementTitle_luxury_provider => 'Proveedor de lujo';

  @override
  String get achievementDescription_luxury_provider =>
      'Mejora 3 distritos al nivel VIP';

  @override
  String get achievementTitle_rivalry_victor => 'Vencedor de la rivalidad';

  @override
  String get achievementDescription_rivalry_victor =>
      'Sabotea con éxito a tus rivales 10 veces.';

  @override
  String get achievementTitle_untouchable_rival => 'Rival intocable';

  @override
  String get achievementDescription_untouchable_rival =>
      'Defiéndete de 20 intentos de sabotaje.';

  @override
  String get achievementTitle_crime_first_blood => 'Crimen primera sangre';

  @override
  String get achievementDescription_crime_first_blood =>
      'Completa con éxito tu primer crimen.';

  @override
  String get achievementTitle_crime_hustler => 'Estafador del crimen';

  @override
  String get achievementDescription_crime_hustler =>
      'Completa con éxito 5 crímenes.';

  @override
  String get achievementTitle_crime_novice => 'Novato en crimen';

  @override
  String get achievementDescription_crime_novice =>
      'Completa con éxito 10 crímenes.';

  @override
  String get achievementTitle_crime_operator => 'Operadora de delitos';

  @override
  String get achievementDescription_crime_operator =>
      'Completa con éxito 25 crímenes.';

  @override
  String get achievementTitle_crime_wave => 'Ola de crimen';

  @override
  String get achievementDescription_crime_wave =>
      'Completa con éxito 50 crímenes.';

  @override
  String get achievementTitle_crime_mastermind => 'Cerebro del crimen';

  @override
  String get achievementDescription_crime_mastermind =>
      'Completa con éxito 100 crímenes.';

  @override
  String get achievementTitle_the_godfather => 'el padrino';

  @override
  String get achievementDescription_the_godfather =>
      'Completa con éxito 250 crímenes.';

  @override
  String get achievementTitle_crime_emperor => 'Emperador del crimen';

  @override
  String get achievementDescription_crime_emperor =>
      'Completa con éxito 500 crímenes.';

  @override
  String get achievementTitle_crime_legend => 'Leyenda del crimen';

  @override
  String get achievementDescription_crime_legend =>
      'Completa con éxito 1000 crímenes.';

  @override
  String get achievementTitle_crime_getaway_driver => 'Conductora de escapada';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Completa con éxito tu primer delito con un vehículo.';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Armado y listo';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Completa con éxito tu primer crimen que requiere un arma.';

  @override
  String get achievementTitle_crime_full_loadout => 'Equipamiento completo';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Completa con éxito un delito que requiere vehículo, arma y herramientas.';

  @override
  String get achievementTitle_crime_completionist => 'Completista del crimen';

  @override
  String get achievementDescription_crime_completionist =>
      'Completa con éxito cada tipo de delito al menos una vez.';

  @override
  String get achievementTitle_job_first_shift => 'Primer turno';

  @override
  String get achievementDescription_job_first_shift =>
      'Completa con éxito tu primer trabajo';

  @override
  String get achievementTitle_job_hustler => 'Estafador de empleo';

  @override
  String get achievementDescription_job_hustler =>
      'Completa con éxito 5 trabajos.';

  @override
  String get achievementTitle_job_starter => 'Iniciador de trabajo';

  @override
  String get achievementDescription_job_starter =>
      'Completa con éxito 10 trabajos.';

  @override
  String get achievementTitle_job_operator => 'Operadora de trabajo';

  @override
  String get achievementDescription_job_operator =>
      'Completa con éxito 25 trabajos.';

  @override
  String get achievementTitle_job_grinder => 'Molinillo de trabajo';

  @override
  String get achievementDescription_job_grinder =>
      'Completa con éxito 50 trabajos.';

  @override
  String get achievementTitle_job_master => 'maestro de trabajo';

  @override
  String get achievementDescription_job_master =>
      'Completa con éxito 100 trabajos.';

  @override
  String get achievementTitle_job_expert => 'Experto en Trabajo';

  @override
  String get achievementDescription_job_expert =>
      'Completa con éxito 250 trabajos.';

  @override
  String get achievementTitle_job_elite => 'Élite laboral';

  @override
  String get achievementDescription_job_elite =>
      'Completa con éxito 500 trabajos.';

  @override
  String get achievementTitle_job_legend => 'Leyenda del trabajo';

  @override
  String get achievementDescription_job_legend =>
      'Completa con éxito 1000 trabajos.';

  @override
  String get achievementTitle_job_completionist => 'Completador de Trabajo';

  @override
  String get achievementDescription_job_completionist =>
      'Completa con éxito cada tipo de trabajo al menos una vez.';

  @override
  String get achievementTitle_job_educated_worker => 'Trabajadora educada';

  @override
  String get achievementDescription_job_educated_worker =>
      'Completar 1 trabajo que tenga requisitos educativos.';

  @override
  String get achievementTitle_job_certified_hustler => 'Estafador certificado';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Completa 25 trabajos con requisitos educativos.';

  @override
  String get achievementTitle_job_education_completionist =>
      'Completista de trabajos educativos';

  @override
  String get achievementDescription_job_education_completionist =>
      'Completa cada tipo de trabajo relacionado con la educación al menos una vez.';

  @override
  String get achievementTitle_job_it_specialist => 'Especialista en TI';

  @override
  String get achievementDescription_job_it_specialist =>
      'Completa tu primer turno como programadora';

  @override
  String get achievementTitle_job_lawyer => 'Abogado callejero';

  @override
  String get achievementDescription_job_lawyer =>
      'Completa tu primer turno como Abogado';

  @override
  String get achievementTitle_job_doctor => 'Doctora subterránea';

  @override
  String get achievementDescription_job_doctor =>
      'Completa tu primer turno como doctora';

  @override
  String get achievementTitle_school_certified => 'Estudiante certificada';

  @override
  String get achievementDescription_school_certified =>
      'Obtén 3 certificaciones escolares';

  @override
  String get achievementTitle_school_multi_certified => 'Multicertificado';

  @override
  String get achievementDescription_school_multi_certified =>
      'Obtén 6 certificaciones escolares';

  @override
  String get achievementTitle_school_track_specialist =>
      'Especialista en pista';

  @override
  String get achievementDescription_school_track_specialist =>
      'Maximiza 3 pistas escolares';

  @override
  String get achievementTitle_school_freshman =>
      'estudiante de primer año de escuela';

  @override
  String get achievementDescription_school_freshman =>
      'Alcanzar el nivel educativo 1';

  @override
  String get achievementTitle_school_scholar => 'Académico de la escuela';

  @override
  String get achievementDescription_school_scholar =>
      'Alcanzar el nivel educativo 3';

  @override
  String get achievementTitle_school_graduate => 'Graduado de la escuela';

  @override
  String get achievementDescription_school_graduate =>
      'Alcanzar el nivel educativo 5';

  @override
  String get achievementTitle_school_mastermind => 'Mente maestra académica';

  @override
  String get achievementDescription_school_mastermind =>
      'Alcanzar el nivel educativo 10';

  @override
  String get achievementTitle_school_doctorate => 'Doctorado en la calle';

  @override
  String get achievementDescription_school_doctorate =>
      'Alcanzar el nivel educativo 20';

  @override
  String get achievementTitle_road_bandit => 'Bandido del camino';

  @override
  String get achievementDescription_road_bandit => 'roba 5 autos';

  @override
  String get achievementTitle_grand_theft_fleet => 'Flota de gran robo';

  @override
  String get achievementDescription_grand_theft_fleet => 'roba 25 autos';

  @override
  String get achievementTitle_sea_raider => 'asaltante del mar';

  @override
  String get achievementDescription_sea_raider => 'Roba 3 barcos';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Capitán de contrabandistas';

  @override
  String get achievementDescription_captain_of_smugglers => 'Roba 12 barcos';

  @override
  String get achievementTitle_globe_trotter => 'Trotamundos';

  @override
  String get achievementDescription_globe_trotter => 'Completa 5 viajes';

  @override
  String get achievementTitle_jet_setter => 'Jet Setter';

  @override
  String get achievementDescription_jet_setter => 'Completa 25 viajes.';

  @override
  String get achievementTitle_chemist_apprentice => 'Aprendiz de Químico';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Completa 10 producciones de drogas.';

  @override
  String get achievementTitle_narco_chemist => 'Narcoquímico';

  @override
  String get achievementDescription_narco_chemist =>
      'Completa 100 producciones de drogas.';

  @override
  String get achievementTitle_street_merchant => 'Comerciante callejera';

  @override
  String get achievementDescription_street_merchant =>
      'Completa 25 intercambios';

  @override
  String get achievementTitle_trade_tycoon => 'Magnate del comercio';

  @override
  String get achievementDescription_trade_tycoon => 'Completa 150 operaciones';

  @override
  String get achievementTitle_prostitute_lineup => 'Alineación construida';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Recluta a 10 prostitutas.';

  @override
  String get achievementTitle_prostitute_network => 'Red de calles';

  @override
  String get achievementDescription_prostitute_network =>
      'Recluta a 25 prostitutas.';

  @override
  String get achievementTitle_prostitute_syndicate => 'Sindicato';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Recluta a 50 prostitutas.';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dinastía';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Recluta 100 prostitutas';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Imperio 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recluta 250 prostitutas.';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Cartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recluta 500 prostitutas';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Leyenda 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recluta 1000 prostitutas';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'Principiante VIP';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Alcanza el nivel 3 con una prostituta VIP.';

  @override
  String get achievementTitle_vip_prostitute_level_25 => 'Cabeza de cartel VIP';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Alcanza el nivel 5 con una prostituta VIP.';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'Icono VIP';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Alcanza el nivel 7 con una prostituta VIP.';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'Leyenda VIP';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Alcanza el nivel 10 con una prostituta VIP.';

  @override
  String get achievementTitle_nightclub_opening_night => 'Noche inaugural';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Abre tu primera discoteca';

  @override
  String get achievementTitle_nightclub_headliner => 'Booker cabeza de cartel';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Reserva 10 turnos de DJ para tu imperio de discotecas';

  @override
  String get achievementTitle_nightclub_full_house => 'Casa llena';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Lleve la multitud de un club nocturno al 90% de su capacidad';

  @override
  String get achievementTitle_nightclub_cash_machine => 'cajero automático';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Gana 250.000 € en ingresos totales en discotecas';

  @override
  String get achievementTitle_nightclub_empire => 'Imperio de la vida nocturna';

  @override
  String get achievementDescription_nightclub_empire =>
      'Gana 1.000.000€ de ingresos totales en discotecas';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Jefa de personal';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Dirige a 3 miembros activos de la Crew del Nightclub al mismo tiempo.';

  @override
  String get achievementTitle_nightclub_vip_room => 'Sala VIP';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Asigna 2 miembros del equipo VIP a tu club nocturno';

  @override
  String get achievementTitle_nightclub_head_of_security => 'Jefa de Seguridad';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Contrata seguridad de discoteca por 10 turnos.';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Final del podio';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Termina entre los 3 primeros de una temporada semanal de discotecas.';

  @override
  String get achievementTitle_nightclub_season_champion =>
      'Campeona de la temporada';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Gana una temporada de discoteca semanal';

  @override
  String get nightclubManagementTitle => 'Gestión de discotecas';

  @override
  String get nightclubRealtimeStatus => 'Estado en tiempo real activa';

  @override
  String get nightclubRefresh => 'Refrescar';

  @override
  String get nightclubEmptyTitle => 'Aún no se ha encontrado ninguna discoteca';

  @override
  String get nightclubEmptyBody =>
      'Primero compre una discoteca en Propiedades para activar este sistema.';

  @override
  String get nightclubLocationTitle => 'Ubicación del club nocturno';

  @override
  String get nightclubSelectVenue => 'Seleccionar lugar';

  @override
  String get nightclubLiveStatistics => 'Estadísticas en vivo';

  @override
  String get nightclubKpiCrowd => 'Multitud';

  @override
  String get nightclubKpiVibe => 'Onda';

  @override
  String get nightclubKpiToday => 'Hoy';

  @override
  String get nightclubKpiAllTime => 'Todos los tiempos';

  @override
  String get nightclubKpiStock => 'Existencias';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Robos';

  @override
  String get nightclubKpiStaff => 'Personal';

  @override
  String get nightclubKpiSalesBoost => 'Impulso de ventas';

  @override
  String get nightclubKpiPriceBoost => 'Aumento de precio';

  @override
  String get nightclubKpiVipBonus => 'bono vip';

  @override
  String get nightclubStatusActive => 'Activa';

  @override
  String get nightclubStatusOff => 'Apagada';

  @override
  String get nightclubStatusActiveLower => 'activa';

  @override
  String get nightclubRevenueTrend => 'Tendencia de ingresos (en vivo)';

  @override
  String get nightclubLeaderboardTitle => 'Mejores discotecas';

  @override
  String get nightclubLeaderboardCountry => 'País';

  @override
  String get nightclubLeaderboardGlobal => 'Global';

  @override
  String get nightclubLeaderboardEmpty => 'Aún no hay datos de clasificación';

  @override
  String get nightclubLeaderboardRevenue24h => 'ingresos 24h';

  @override
  String get nightclubSeasonProcessing => 'tratamiento...';

  @override
  String get nightclubSeasonTitle => 'Clasificación de temporada semanal';

  @override
  String get nightclubSeasonResetIn => 'Reiniciar en';

  @override
  String get nightclubSeasonYourRewards => 'Tus recompensas de temporada';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 de la semana actual';

  @override
  String get nightclubSeasonEmpty => 'Aún no hay datos de temporada';

  @override
  String get nightclubSeasonWeekRevenue => 'Ingresos semanales';

  @override
  String get nightclubSeasonScore => 'Puntaje';

  @override
  String get nightclubSeasonRecentPayouts => 'Pagos recientes';

  @override
  String get nightclubSeasonNoPayouts => 'Aún no hay pagos';

  @override
  String get nightclubSalesTitle => 'Ventas recientes';

  @override
  String get nightclubSalesEmpty => 'Aún no hay datos de ventas';

  @override
  String get nightclubTheftTitle => 'Registro de robo';

  @override
  String get nightclubTheftEmpty => 'No se registraron robos';

  @override
  String get nightclubTheftLoss => 'Pérdida';

  @override
  String get nightclubStaffTitle => 'Equipo de proxenetas en el club';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 activa)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capacidad: $assigned/$cap$vipSuffix';
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
    return 'Combinación de impulso: ventas x$sales | precio x$price | ambiente x$vibe | seguridad x$security | jugador vip x$vipPlayer | personal vip x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Seleccionar miembro de la Crew';

  @override
  String get nightclubAssignShift => 'Asignar turno de discoteca';

  @override
  String get nightclubTabActive => 'Activa';

  @override
  String get nightclubTabHistory => 'Historia';

  @override
  String get nightclubNoCrewAssigned => 'Aún no hay Crew asignada';

  @override
  String get nightclubCrewBoostDescription =>
      'Aumenta la demanda y el margen en tu club';

  @override
  String get nightclubRemove => 'Eliminar';

  @override
  String get nightclubNoStaffHistory => 'Aún no hay historial de personal';

  @override
  String get nightclubFrom => 'De';

  @override
  String get nightclubTo => 'A';

  @override
  String get nightclubRevenueImpact => 'Impacto en los ingresos';

  @override
  String get nightclubSalesCountLabel => 'ventas';

  @override
  String get nightclubDjTitle => 'Contratar DJ';

  @override
  String get nightclubChooseDj => 'Elige DJ';

  @override
  String get nightclubShiftLength => 'Duración del turno';

  @override
  String get nightclubHireDj => 'Contratar DJ';

  @override
  String get nightclubSecurityTitle => 'Seguridad';

  @override
  String get nightclubChooseSecurity => 'Elige seguridad';

  @override
  String get nightclubHireSecurity => 'Contratar seguridad';

  @override
  String get nightclubStoreTitle => 'almacenar medicamentos';

  @override
  String get nightclubChooseStock => 'Elige acciones';

  @override
  String get nightclubAmountGrams => 'cantidad en gramos';

  @override
  String get nightclubStoreButton => 'Tienda en discoteca';

  @override
  String get nightclubHireDjSuccess => 'DJ contratada';

  @override
  String get nightclubHireSecuritySuccess => 'Seguridad contratada';

  @override
  String get nightclubAssignCrewSuccess => 'Miembro de la Crew asignado';

  @override
  String get nightclubRemoveCrewSuccess => 'Miembro de la Crew eliminado';

  @override
  String get nightclubStoreDrugsSuccess => 'Drogas almacenadas';

  @override
  String get nightclubSeasonPayoutDialogTitle => 'Pago de temporada recibido';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Tu club nocturno terminó en el puesto #$rank esta semana.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Recompensa: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Ingresos semanales: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Pérdida por robo: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Cerca';

  @override
  String get nightclubVibeChill => 'Enfriar';

  @override
  String get nightclubVibeNormal => 'Normal';

  @override
  String get nightclubVibeWild => 'Salvaje';

  @override
  String get nightclubVibeRaging => 'Furiosa';

  @override
  String get nightclubTheftTypeCustomer => 'Robo de clientes';

  @override
  String get nightclubTheftTypeEmployee => 'atraco a empleados';

  @override
  String get nightclubTheftTypeRival => 'Sabotaje rival';

  @override
  String nightclubErrorLoading(String error) {
    return 'Error al cargar discoteca: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'No se pudieron cargar las estadísticas del Nightclub';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'No se pudo cargar la tabla de clasificación';

  @override
  String get nightclubServiceErrorSeason =>
      'No se pudo cargar la clasificación de la temporada';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Contrato de DJ residente fallido';

  @override
  String get nightclubScheduleEventFailed => 'No se pudo programar el evento';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'Error en la actualización de marketing';

  @override
  String get nightclubUpgradeFailed => 'La actualización falló';

  @override
  String get nightclubIncidentResponseFailed =>
      'La respuesta al incidente falló';

  @override
  String get nightclubRivalActionFailed => 'La acción rival falló';

  @override
  String get nightclubSupplierContractFailed => 'Contrato de proveedor fallido';

  @override
  String get nightclubPromoterFailed => 'Promotora fallida';

  @override
  String get nightclubHeatCooldownFailed => 'Falló el enfriamiento del calor';

  @override
  String get nightclubSmugglingFailed => 'El contrabando fracasó';

  @override
  String get nightclubCounterIntelFailed => 'La contrainteligencia falló';

  @override
  String get nightclubHospitalityStockFailed =>
      'El stock de hostelería fracasó';

  @override
  String get nightclubHospitalityPricingFailed =>
      'El precio de la hostelería falló';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Visitantes actuales: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Cubierta de mando del Nightclub';

  @override
  String get nightclubOpsDeckRevenueToday => 'Ingresos hoy';

  @override
  String get nightclubStockValueLabel => 'Valor de las acciones';

  @override
  String get nightclubCrewOccupancy => 'Ocupación de la Crew';

  @override
  String get nightclubOperationalRisk => 'Riesgo operacional';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidencias (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Turnos de Crew activos';

  @override
  String get nightclubRecentCrewHistory => 'Historia reciente de la Crew';

  @override
  String get nightclubBadgeVip => 'personaje';

  @override
  String get nightclubBadgeStandard => 'ESTÁNDAR';

  @override
  String get nightclubActiveDj => 'DJ activa';

  @override
  String get nightclubActiveDjNone => 'DJ activa: ninguna';

  @override
  String nightclubUntilTime(String time) {
    return 'hasta $time';
  }

  @override
  String get nightclubActiveSecurity => 'Seguridad activa';

  @override
  String get nightclubActiveSecurityNone => 'Seguridad activa: ninguna';

  @override
  String get nightclubNoDjsLoaded =>
      'No hay DJ cargados. Actualiza la pantalla.';

  @override
  String get nightclubNoSecurityLoaded =>
      'No hay seguridad cargada. Actualiza la pantalla.';

  @override
  String get nightclubCrowdBoost => 'aumento de multitud';

  @override
  String get nightclubCostPerHour => 'Costo';

  @override
  String get nightclubReputationLabel => 'Reputación';

  @override
  String get nightclubSpecialtyLabel => 'Especialidad';

  @override
  String get nightclubTheftReduction => 'Reducción de robo';

  @override
  String get nightclubShiftCost => 'Costo de turno';

  @override
  String get nightclubSelectedStock => 'Seleccionada';

  @override
  String get nightclubAvailableGrams => 'Disponible';

  @override
  String get nightclubMaxChip => 'MÁXIMO';

  @override
  String get nightclubStoredInNightclub => 'Guardado en discoteca';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Existencias actuales: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Aún no hay medicamentos almacenados.';

  @override
  String get nightclubStockZeroSoldOut =>
      'El stock actual es de 0g (se ha vendido todo).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Calidad: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g de caldo';
  }

  @override
  String get nightclubOperationsLabTitle =>
      'Laboratorio de Operaciones (11 sistemas)';

  @override
  String get nightclubSectionResidentDjContract =>
      '1) Contrato de DJ residente';

  @override
  String get nightclubContractDiscount => 'Descuento de contrato';

  @override
  String get nightclubContractDuration => 'Duración del contrato';

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
  String get nightclubStartResidentContract => 'Iniciar contrato de residente';

  @override
  String get nightclubSectionEventCalendar =>
      '2) Calendario de eventos dinámico';

  @override
  String get nightclubRecommendedToday => 'Recomendada hoy';

  @override
  String get nightclubEventTemplate => 'Plantilla de evento';

  @override
  String get nightclubScheduleEventFiveMin => 'Agendar evento (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Próximos eventos';

  @override
  String get nightclubSectionUpgradeTree => '3) Árbol de actualización';

  @override
  String get nightclubUpgradeSoundRig => 'equipo de sonido';

  @override
  String get nightclubUpgradeVipLounge => 'salón vip';

  @override
  String get nightclubUpgradeSurveillance => 'Vigilancia';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Elija actualizar';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Esta actualización ya es de nivel máximo.';

  @override
  String get nightclubUpgradeAlreadyMaxed => 'Actualización ya al máximo';

  @override
  String get nightclubUpgradeNow => 'Actualiza ahora';

  @override
  String get nightclubMarketingInvestment => 'Inversión en marketing';

  @override
  String get nightclubInvestMarketing => 'Invierte en marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Calor policial e incidentes';

  @override
  String get nightclubHeatLabel => 'Calor';

  @override
  String get nightclubRaidRisk => 'Riesgo de incursión';

  @override
  String get nightclubCooldownLabel => 'Enfriarse';

  @override
  String get nightclubStartHeatCooldown => 'Iniciar enfriamiento de calor';

  @override
  String get nightclubBribe => 'Soborno';

  @override
  String get nightclubLockdown => 'Aislamiento';

  @override
  String get nightclubCounterIntelShort => 'Contrainteligencia';

  @override
  String get nightclubSectionStaffMorale => '5) Fatiga y moral del personal';

  @override
  String get nightclubMorale => 'Moral';

  @override
  String get nightclubFatigue => 'Fatiga';

  @override
  String get nightclubStaffing => 'Dotación de personal';

  @override
  String get nightclubSectionSupplierPromoter => '6) Proveedor y promotora';

  @override
  String get nightclubSupplierContract => 'Contrato de proveedor';

  @override
  String get nightclubActivateSupplier => 'Activar proveedor';

  @override
  String get nightclubPromoterProfile => 'Perfil del promotor';

  @override
  String get nightclubHirePromoter => 'Contratar promotora';

  @override
  String get nightclubSectionVipClientele =>
      '7) Clientela VIP y características del personal.';

  @override
  String get nightclubVipShare => 'compartir vip';

  @override
  String get nightclubSpendMultiplier => 'Gastar x';

  @override
  String get nightclubTier => 'Nivel';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Rutas de contrabando';

  @override
  String get nightclubReady => 'Listo';

  @override
  String get nightclubRoute => 'Ruta';

  @override
  String get nightclubStartRoute => 'Iniciar ruta';

  @override
  String get nightclubLastRoute => 'Última ruta';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Bloqueo de ruta activo hasta $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Gestión de bar y cocina';

  @override
  String get nightclubServiceLevel => 'Nivel de servicio';

  @override
  String get nightclubStockStatus => 'Estado del stock';

  @override
  String get nightclubSpoilageRisk => 'Riesgo de deterioro';

  @override
  String get nightclubDrinksFoodStock => 'Bebidas/Caldo de comida';

  @override
  String get nightclubBuyStock => 'comprar acciones';

  @override
  String get nightclubMenuPricingMode => 'Modo de precios de menú';

  @override
  String get nightclubApplyPricing => 'Aplicar precios';

  @override
  String get nightclubSectionRivals =>
      '10) Clubes rivales + contrainteligencia';

  @override
  String get nightclubSearchPlayerName => 'Buscar nombre del jugador';

  @override
  String get nightclubTargetName => 'Objetivo (nombre)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • multitud $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotaje';

  @override
  String get nightclubPromoWar => 'Guerra promocional';

  @override
  String get nightclubCounterIntelSweep => 'Barrido de contrainteligencia';

  @override
  String get nightclubMitigation => 'Mitigación';

  @override
  String get nightclubSectionTimeline => '11) Cronograma de operaciones';

  @override
  String get nightclubNoTimelineEvents => 'Sin eventos en la línea de tiempo.';

  @override
  String get nightclubOperationsAlerts => 'Alertas de operaciones';

  @override
  String get nightclubNoCriticalAlerts => 'Sin alertas críticas.';

  @override
  String get nightclubQuickAction => 'acción rápida';

  @override
  String get nightclubMgmtCrewTitle => 'Crew y turnos';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Dotación de personal, desempeño y historial de turnos.';

  @override
  String get nightclubMgmtDrugsTitle => 'Almacenamiento de medicamentos';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Administrar y transferir inventario en gramos.';

  @override
  String get nightclubMgmtDjTitle => 'comando de DJ';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Elija DJ, duración del turno y aumento de público en vivo.';

  @override
  String get nightclubMgmtSecurityTitle => 'unidad de seguridad';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Reducción de robos, costes y seguridad activa.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Laboratorio de operaciones';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Alertas en vivo: $alerts | Contrabando: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 sistemas para eventos, mejoras, rutas y rivales.';

  @override
  String get nightclubManagementPanelTitle => 'Gestión de discotecas';

  @override
  String get nightclubChooseZoneHint =>
      'Elija una zona de gestión y controle todo sin desplazamiento interno anidado.';

  @override
  String get nightclubChipCrew => 'Multitud';

  @override
  String get nightclubChipStorage => 'Almacenamiento';

  @override
  String get nightclubChipDjShift => 'turno de DJ';

  @override
  String get nightclubChipSecurity => 'Seguridad';

  @override
  String get nightclubChipOpsAlerts => 'Alertas de operaciones';

  @override
  String get nightclubNone => 'Ninguna';

  @override
  String get nightclubIntelligenceCardTitle => 'Inteligencia de discotecas';

  @override
  String get nightclubSeasonStatus => 'Estado de la temporada';

  @override
  String nightclubSeasonCountdown(String days, String hours, String minutes) {
    return '${days}d ${hours}h ${minutes}m';
  }

  @override
  String nightclubShiftHours(String hours) {
    return '${hours}h';
  }

  @override
  String nightclubTimeMinutes(String minutes) {
    return '$minutes minutos';
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
      '¿Saltar el tiempo de reutilización por robo?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return '¿Gastar $cost créditos para eliminar el tiempo de reutilización por robo de vehículos ahora? Tu saldo: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'No volver a mostrar esta confirmación';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Utilice $credits créditos';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'La aceleración de crédito no está disponible para este tiempo de reutilización en este momento.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'No hay tiempo de reutilización de robo activo para restablecer.';

  @override
  String get theftCooldownRedeemInsufficientCredits =>
      'No hay suficientes créditos.';

  @override
  String get theftCooldownRedeemFailed =>
      'No se pudieron aplicar créditos al tiempo de reutilización.';

  @override
  String get theftCooldownRedeemSuccess =>
      'Se ha completado el tiempo de reutilización.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Tiempo de reutilización por robo (créditos)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Solicite confirmación antes de gastar créditos para omitir el tiempo de reutilización por robo de vehículos. Desactívalo para canjearlo con un solo toque (icono de un rayo al lado del temporizador).';

  @override
  String get supportTicketsScreenTitle => 'Tickets de soporte';

  @override
  String get supportLoadTicketsFailed => 'No se pudieron cargar los tickets';

  @override
  String get supportLoadTicketFailed => 'No se pudo cargar el ticket';

  @override
  String get supportPickImageFailed => 'No se pudo seleccionar la imagen';

  @override
  String get supportSubjectMessageMinLength =>
      'Rellena el asunto y el mensaje (mín. 3 caracteres).';

  @override
  String get supportTicketCreated => 'Ticket creado.';

  @override
  String get supportCreateTicketFailed => 'No se pudo crear el ticket';

  @override
  String get supportReplySent => 'Respuesta enviada.';

  @override
  String get supportReplySendFailed => 'No se pudo enviar la respuesta';

  @override
  String get supportDeleteTicketTitle => 'Eliminar ticket';

  @override
  String get supportDeleteTicketBody =>
      '¿Seguro que quieres eliminar este ticket? Esta acción no se puede deshacer.';

  @override
  String get supportTicketDeleted => 'Ticket eliminado.';

  @override
  String get supportDeleteTicketFailed => 'No se pudo eliminar el ticket';

  @override
  String get supportUnknownError => 'Error desconocido';

  @override
  String get supportStatusNew => 'Nuevo';

  @override
  String get supportStatusTriage => 'Triaje';

  @override
  String get supportStatusInProgress => 'En curso';

  @override
  String get supportStatusWaitingPlayer => 'Esperando al jugador';

  @override
  String get supportStatusBlocked => 'Bloqueado';

  @override
  String get supportStatusResolved => 'Resuelto';

  @override
  String get supportStatusClosed => 'Cerrado';

  @override
  String get supportStatusArchived => 'Archivado';

  @override
  String get supportCategoryBug => 'Error';

  @override
  String get supportCategoryQuestion => 'Pregunta';

  @override
  String get supportCategoryFeedback => 'Comentarios';

  @override
  String get supportCategoryOther => 'Otro';

  @override
  String get supportPriorityLow => 'Baja';

  @override
  String get supportPriorityHigh => 'Alta';

  @override
  String get supportPriorityUrgent => 'Urgente';

  @override
  String get supportPriorityNormal => 'Normal';

  @override
  String supportTimeDaysAgo(int count) {
    return 'hace $count d';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String get supportTimeJustNow => 'ahora mismo';

  @override
  String get supportSenderSupport => 'Soporte';

  @override
  String get supportSenderYou => 'Tú';

  @override
  String get supportImageLoadFailed => 'No se pudo cargar la imagen.';

  @override
  String get supportMyTickets => 'Mis tickets';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'El soporte responde ahora directamente en esta pantalla. Opcionalmente puedes seguir recibiendo una notificación push cuando tu ticket se actualice.';

  @override
  String get supportNoTicketsYet =>
      'Aún no tienes tickets. Crea un nuevo informe abajo.';

  @override
  String get supportSelectTicketPrompt =>
      'Selecciona un ticket para abrir la conversación.';

  @override
  String get supportConversation => 'Conversación';

  @override
  String get supportNoMessagesYet => 'Aún no hay mensajes.';

  @override
  String get supportAttachments => 'Adjuntos';

  @override
  String get supportReplyToTicket => 'Responder a este ticket';

  @override
  String get supportReplyFieldHint =>
      'Usa este campo cuando el soporte pida más información o quieras enviar una actualización. La bandeja de entrada y las push siguen avisando de nuevas respuestas del soporte.';

  @override
  String get supportYourReply => 'Tu respuesta';

  @override
  String get supportSendReply => 'Enviar respuesta';

  @override
  String get supportNewTicket => 'Nuevo ticket';

  @override
  String get supportNewTicketIntro =>
      'Crea un nuevo informe aquí. El soporte puede responder por bandeja/push y en esta pantalla, para seguir la conversación en un solo lugar.';

  @override
  String get supportTicketReceivedBanner => 'Ticket recibido';

  @override
  String supportTicketNumberLine(int id) {
    return 'Número de ticket: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'El ticket aparece ahora arriba en tu lista. Las nuevas respuestas del soporte también llegan como mensaje en la bandeja y como notificación push.';

  @override
  String get supportFieldCategory => 'Categoría';

  @override
  String get supportFieldModule => 'Módulo';

  @override
  String get supportFieldSubject => 'Asunto';

  @override
  String get supportFieldMessage => 'Mensaje';

  @override
  String get supportReferenceOptional => 'Referencia (opcional)';

  @override
  String get supportReferenceHint =>
      'Por ejemplo id de pedido, nombre de pantalla, país o contexto breve';

  @override
  String get supportAddScreenshot => 'Añadir captura';

  @override
  String get supportSubmit => 'Enviar';

  @override
  String get supportLastMessagePrefix => 'Último: ';

  @override
  String get supportReferenceLabel => 'Referencia';

  @override
  String get supportMod_support => 'Soporte general';

  @override
  String get supportMod_dashboard => 'Panel';

  @override
  String get supportMod_messages => 'Mensajes / bandeja';

  @override
  String get supportMod_notifications => 'Notificaciones / push';

  @override
  String get supportMod_payments => 'Pagos / premium';

  @override
  String get supportMod_bank => 'Banco';

  @override
  String get supportMod_crypto => 'Cripto';

  @override
  String get supportMod_travel => 'Viajes';

  @override
  String get supportMod_properties => 'Propiedades';

  @override
  String get supportMod_inventory => 'Inventario / almacén';

  @override
  String get supportMod_loadouts => 'Equipamientos / equipo';

  @override
  String get supportMod_crimes => 'Crimen';

  @override
  String get supportMod_jobs => 'Trabajo / empleos';

  @override
  String get supportMod_vehicles => 'Robo de coche / moto / barco';

  @override
  String get supportMod_garage => 'Garaje';

  @override
  String get supportMod_marina => 'Puerto pequeño';

  @override
  String get supportMod_aviation => 'Aviación';

  @override
  String get supportMod_smuggling => 'Contrabando';

  @override
  String get supportMod_drugs => 'Drogas';

  @override
  String get supportMod_nightclub => 'Club nocturno';

  @override
  String get supportMod_prostitution => 'Prostitución';

  @override
  String get supportMod_crew => 'Multitud';

  @override
  String get supportMod_friends => 'Amigos / jugadores';

  @override
  String get supportMod_hitlist => 'Lista negra';

  @override
  String get supportMod_security => 'Seguridad / FBI';

  @override
  String get supportMod_prison => 'Prisión / juzgado';

  @override
  String get supportMod_casino => 'Casino';

  @override
  String get supportMod_school => 'Escuela / formación';

  @override
  String get supportMod_achievements => 'Logros';

  @override
  String get supportMod_profile => 'Perfil';

  @override
  String get supportMod_settings => 'Ajustes';

  @override
  String get supportMod_events => 'Eventos / clasificación';

  @override
  String get supportMod_other => 'Otro';

  @override
  String get gameEventDefaultTitle => 'Evento';

  @override
  String get gameEventStatusActive => 'Activo';

  @override
  String get gameEventStatusScheduled => 'Programado';

  @override
  String get gameEventStatusCompleted => 'Finalizado';

  @override
  String get gameEventStatusDraft => 'Borrador';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Caza de robos semanal';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Roba tantos vehículos como puedas durante la ventana del evento.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Oleada de contrabando';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Mueve el mayor volumen de contrabando en esta ronda.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Desafío de producción del laboratorio';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produce la mayor cantidad mientras el evento esté activo.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle =>
      'Racha de crímenes callejeros';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Completa tantos crímenes como puedas mientras el evento esté en curso.';

  @override
  String get gameEventTmplContrabandRushTitle => 'Fiebre del contrabando';

  @override
  String get gameEventTmplContrabandRushDesc =>
      'Vende contrabando con beneficio o reclama envíos comerciales — gana quien más puntos sume.';

  @override
  String get gameEventTmplMonthlyEmpireShowdownTitle =>
      'Monthly Empire Showdown';

  @override
  String get gameEventTmplMonthlyEmpireShowdownDesc =>
      'All-round monthly challenge: score via crimes, vehicles, drugs, smuggling and trade. Top ranks win rare vehicles, weapons, ammo and parts.';

  @override
  String get gameScreenLoadError => 'No se pudieron cargar los eventos.';

  @override
  String get gameScreenDetailsLoadError =>
      'No se pudieron cargar los detalles del evento.';

  @override
  String get gameScreenSectionLive => 'Eventos en vivo';

  @override
  String get gameScreenNoActive => 'No hay eventos activos ahora.';

  @override
  String get gameScreenSectionUpcoming => 'Próximos eventos';

  @override
  String get gameScreenNoUpcoming => 'No hay eventos programados.';

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
    return 'Estado: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Inicio: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Fin: $date';
  }

  @override
  String get gameScreenYourProgress => 'Tu progreso';

  @override
  String gameScreenScore(String value) {
    return 'Puntuación: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Posición: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Clasificación (top 10)';

  @override
  String get gameScreenNoLeaderboard => 'Aún no hay datos de clasificación.';

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
  String get gameScreenUnknownPlayer => 'Desconocido';

  @override
  String get gameScreenDash => '—';

  @override
  String get gameCardActive => 'Activo';

  @override
  String get gameCardScheduled => 'Programado';

  @override
  String gameCardYourScore(String value) {
    return 'Tu puntuación: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Tu posición: $value';
  }

  @override
  String get gameCardTapDetails => 'Toca para ver detalles y la clasificación';

  @override
  String get eventFeedDisconnected => 'Sin conexión al flujo de eventos';

  @override
  String get eventFeedReconnecting => 'Reconectando…';

  @override
  String get eventFeedConnectedWaiting => 'Conectado: esperando eventos…';

  @override
  String get eventFeedConnecting => 'Conectando al flujo de eventos…';

  @override
  String get evStreamConnectionEstablished => 'Conectado al flujo de eventos';

  @override
  String get evStreamAuthRegistered => 'Cuenta creada correctamente.';

  @override
  String get evStreamAuthLogin => 'Bienvenido de nuevo.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return '¡Completaste con éxito $crimeName! +EUR $reward, +$xpGained XP';
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
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return '¡Completaste con éxito $crimeName! +EUR $reward, +$xpGained XP — ¡pero te pillaron! Encarcelado durante $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle => ' La policía incautó tu vehículo.';

  @override
  String get evStreamCrimeSeizedWeapon => ' La policía confiscó tu arma.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condenas',
      one: '1 condena',
    );
    return '¡Completaste con éxito $crimeName! Antecedentes borrados: $_temp0. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return '¡Detenido por $authority durante un intento de $crimeName!';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return '¡Te pillaron en $crimeName! Encarcelado durante $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'No se pudo completar $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return ' Tu vehículo sufrió un $pct% de daño en la persecución.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return '¡Te pillaron en $crimeName! Encarcelado durante $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return '¡Trabajo como $jobName completado! +€$earnings, +$xpGained XP';
  }

  @override
  String evStreamActorPrefix(String username, String message) {
    return '$username: $message';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return ' (Bonificación de formación +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'No completaste el trabajo como $jobName. −$xpLost XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'No completaste el trabajo como $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Trabajo no válido';

  @override
  String get evStreamJobErrorLevel =>
      'Tu rango es demasiado bajo para este trabajo';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos más',
      one: '1 minuto más',
    );
    return 'Este trabajo tiene tiempo de espera. Espera $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Error de trabajo: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Volando a $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return '¡Llegaste a $country!';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Ingresaste €$amount en el banco';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Retiraste €$amount del banco';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Compraste $quantity $symbol por €$total';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Vendiste $quantity $symbol por €$total (PyG €$pnl)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return 'Alerta $symbol: €$price ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side ejecutada: $quantity $symbol a €$price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig activada para $symbol a €$price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Régimen de mercado: $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return 'Noticias $sentiment: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Misión diaria completada: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Misión semanal completada: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Recompensa del ranking crypto: n.º $rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'alcista';

  @override
  String get evStreamRegimeBear => 'bajista';

  @override
  String get evStreamRegimeSideways => 'lateral';

  @override
  String get evStreamImpactBull => 'Alcista';

  @override
  String get evStreamImpactBear => 'Bajista';

  @override
  String get evStreamImpactNeutral => 'Neutral';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Compraste $name por €$cost';
  }

  @override
  String evStreamPropertyClaimed(String name, String country, String cost) {
    return 'Claimed property $name in $country for €$cost';
  }

  @override
  String evStreamDrugsProductionStarted(String drugName, String minutes) {
    return 'Producción iniciada $drugName - lista en $minutes min';
  }

  @override
  String evStreamDrugsProductionCollected(
    String quantity,
    String drugName,
    String quality,
  ) {
    return 'Recogido ${quantity}g $drugName ($quality)';
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
    return '${quantity}g $drugType vendido en $destination (€$payout)';
  }

  @override
  String evStreamDrugsWholesaleSeized(
    String quantity,
    String drugType,
    String destination,
  ) {
    return '${quantity}g $drugType hacia $destination incautado';
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
    return 'Banda creada: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Te uniste a la banda: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Guerra de bandas declarada: #$a vs #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'Guerra de bandas iniciada: #$a vs #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'La guerra de bandas #$id está en confinamiento';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Guerra de bandas #$id resuelta. Ganador: banda #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Acción de guerra: $action (+$points pt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Atraco “$name” conseguido. +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'Atraco “$name” fallido.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return '¡Curado en el hospital! +$hp de salud, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return '¡Detenido! $mins minutos de cárcel';
  }

  @override
  String get evStreamPoliceEscaped => 'Escapaste de la policía.';

  @override
  String get evStreamFbiRaid =>
      '¡Redada del FBI! Perdiste propiedades y dinero.';

  @override
  String get evStreamErrInsufficientFunds => 'Dinero insuficiente';

  @override
  String get evStreamErrInsufficientHealth =>
      'Salud insuficiente para esta acción';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Requiere rango $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos más',
      one: '1 minuto más',
    );
    return 'Sigues en la cárcel $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault => 'Descansa y recupera salud';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds segundos',
      one: '1 segundo',
    );
    return 'Espera $_temp0 antes de volver a intentarlo';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'No puedes rescatar a otros mientras estás en la cárcel';

  @override
  String get evStreamErrTargetNotJailed => 'Ese jugador no está en la cárcel';

  @override
  String get evStreamErrCannotRescueSelf => 'No puedes rescatarte a ti mismo';

  @override
  String get evStreamJailbreakOk => '¡Fuga conseguida! El jugador está libre.';

  @override
  String get evStreamJailbreakFail =>
      '¡Fuga fallida! El jugador sigue en la cárcel.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return '¡Fuga fallida! Te pillaron: $mins minutos de cárcel.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Fianza pagada: €$amount. ¡Estás libre!';
  }

  @override
  String get evStreamErrInternal => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String evStreamTest(String msg) {
    return 'Prueba: $msg';
  }

  @override
  String get evStreamNoCriminalRecord => 'No tienes antecedentes que borrar';

  @override
  String get evStreamWeaponSelectRequired =>
      'Selecciona un arma para el crimen antes de cometerlo';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Necesitas un arma adecuada: $types';
  }

  @override
  String get evStreamJobFallbackName => 'trabajo';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Error de conexión';

  @override
  String get crimeWeaponSectionTitle => 'Arma para crímenes';

  @override
  String get crimeWeaponInstruction =>
      'Elige qué arma llevada usas por defecto en crímenes que requieren una.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Compra o mueve primero un arma utilizable a tu inventario portátil.';

  @override
  String get crimeWeaponSelectHint => 'Selecciona un arma para crímenes';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Sin selección, los crímenes con arma no se pueden iniciar.';

  @override
  String get crimeWeaponSlotEmpty => 'vacío';

  @override
  String crimeWeaponEquippedStatus(String slotOne, String slotTwo) {
    return 'Ranura 1: $slotOne. Ranura 2: $slotTwo.';
  }

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Seleccionado: $weaponLine. Algunos crímenes exigen además un tipo de arma compatible.';
  }

  @override
  String get crimeSetWeaponFailed =>
      'No se pudo guardar el arma para crímenes.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Elige primero un arma arriba o desde el inventario.';

  @override
  String get crimeWeaponFooterNote =>
      'Los crímenes con arma usan el arma seleccionada arriba.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Bonos de entrenamiento en la probabilidad de éxito: +$strengthPct% fuerza, +$accuracyPct% precisión.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Combo del mismo día (gimnasio + campo de tiro, calendario UTC): +$pct% extra de probabilidad de éxito en delitos.';
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
      'Falsifica expedientes y borra tu historial criminal completo si la operación tiene éxito.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% de éxito';
  }

  @override
  String crimeRequirementDrugsFull(
    String drugsRequired,
    String quantity,
    String names,
  ) {
    return '💊 $drugsRequired (mín. ${quantity}g): $names';
  }

  @override
  String get crimeCommitUnexpectedError =>
      'Algo salió mal. Por favor inténtalo de nuevo.';

  @override
  String get cooldownTimeLeft => 'Tiempo restante';

  @override
  String get cooldownMustWaitExplanation =>
      'Debes esperar antes de volver a realizar esta acción.';

  @override
  String get cooldownAlreadyFinished => 'El tiempo de espera ya terminó.';

  @override
  String get cooldownNotEnoughCredits => 'Créditos insuficientes.';

  @override
  String get cooldownNoActiveToReset =>
      'No hay tiempo de espera activo que reiniciar.';

  @override
  String get cooldownNotAvailableNow => 'No disponible ahora.';

  @override
  String get cooldownRedeemFailed => 'No se pudo acelerar con créditos.';

  @override
  String get cooldownFinishedInstantly =>
      'Tiempo de espera terminado al instante.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Acelerar ahora (-$cost créditos)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Saldo: $balance créditos';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Cargando opciones de créditos…';

  @override
  String get cooldownWaitCrime => 'La policía está muy alerta…';

  @override
  String get cooldownWaitJob => 'Descansando antes de volver a trabajar';

  @override
  String get cooldownWaitTravel => 'El próximo vuelo sale en';

  @override
  String get cooldownWaitHeist => 'Preparando el golpe…';

  @override
  String get cooldownWaitAppeal => 'El tribunal está ocupado…';

  @override
  String get cooldownWaitSchool =>
      'Recupera el aliento antes de la próxima lección...';

  @override
  String get cooldownWaitDefault => 'Un momento…';

  @override
  String get weaponLabelKnife => 'Cuchillo';

  @override
  String get weaponLabelHandgun9mm => 'Pistola (9 mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Pistola pesada (.45)';

  @override
  String get weaponLabelSmgCompact => 'Subfusil compacto';

  @override
  String get weaponLabelShotgunPump => 'Escopeta (bomba)';

  @override
  String get weaponLabelMolotov => 'Cóctel molotov';

  @override
  String get weaponLabelSmgSuppressed => 'Subfusil con silenciador';

  @override
  String get weaponLabelShotgunTactical => 'Escopeta táctica';

  @override
  String get weaponLabelAssaultRifle => 'Fusil de asalto (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Granada aturdidora';

  @override
  String get weaponLabelGrenadeFrag => 'Granada de fragmentación';

  @override
  String get weaponLabelSniperStandard => 'Rifle de francotirador';

  @override
  String get weaponLabelAssaultRifleVip => 'Fusil de asalto de élite';

  @override
  String get weaponLabelSniperVip => 'Francotirador de élite';

  @override
  String get cooldownTitleCrime => 'Tiempo de espera: crímenes';

  @override
  String get cooldownTitleJob => 'Tiempo de espera: trabajo';

  @override
  String get cooldownTitleTravel => 'Tiempo de espera: viaje';

  @override
  String get cooldownTitleHeist => 'Tiempo de espera: golpe';

  @override
  String get cooldownTitleAppeal => 'Tiempo de espera: apelación';

  @override
  String get cooldownTitleSchool => 'Tiempo de espera: escuela';

  @override
  String get cooldownTitleGeneric => 'Tiempo de espera';

  @override
  String get crimeOutcomeDefaultTitle => 'Resultado del crimen';

  @override
  String get territoryContestStatusPreparing => 'Preparación';

  @override
  String get territoryContestStatusActive => 'Activa';

  @override
  String get territoryContestStatusLockdown => 'Aislamiento';

  @override
  String get territoryContestStatusResolved => 'Resuelta';

  @override
  String get territoryContestStatusCancelled => 'Cancelada';

  @override
  String get territoryContestHintPreparing =>
      'Este concurso se encuentra actualmente en preparación. Una vez que finaliza el tiempo de preparación, la región se activa automáticamente y las acciones se desbloquean.';

  @override
  String get territoryContestHintLockdown =>
      'Este concurso está bloqueado. No se pueden tomar nuevas acciones ahora; el resultado se resuelve automáticamente.';

  @override
  String get territoryNow => 'Ahora';

  @override
  String get territoryRoleAttacker => 'Agresora';

  @override
  String get territoryRoleDefender => 'Defensora';

  @override
  String get territoryValueLow => 'Bajo';

  @override
  String get territoryValueAverage => 'Promedio';

  @override
  String get territoryValueHigh => 'Alta';

  @override
  String get territoryValueTop => 'Arriba';

  @override
  String get territoryTagCapital => 'Centro administrativo';

  @override
  String get territoryTagHarbor => 'Puerto';

  @override
  String get territoryTagIndustry => 'Industria';

  @override
  String get territoryTagBorder => 'Región fronteriza';

  @override
  String get territoryTagLogistics => 'Centro logístico';

  @override
  String get territoryActionPatrol => 'Patrulla';

  @override
  String get territoryActionIntelScan => 'escaneo intel';

  @override
  String get territoryActionSabotage => 'Sabotaje';

  @override
  String get territoryActionSupplyRun => 'Ejecución de suministro';

  @override
  String get territoryActionRaid => 'RAID';

  @override
  String get territoryActionDefense => 'Defensa';

  @override
  String get territoryBonusStrategicRegion => 'Región estratégica';

  @override
  String get territoryBonusAdjacentSupport => 'Soporte adyacente';

  @override
  String get territoryBonusWarPressure => 'Presión de guerra';

  @override
  String get territoryBonusHqLevel => 'nivel de sede';

  @override
  String get territoryBonusCrewMissionLevel => 'Nivel de misión de la Crew';

  @override
  String get territoryBonusCrewBuildings => 'Edificios del lado de la Crew';

  @override
  String get territoryBonusOther => 'Otra';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'base $basePoints + bonificación $bonusPoints = $totalPoints puntos del concurso';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Debes unirte a una Crew antes de poder atacar territorio.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Ya hay un concurso en marcha para esta región. Actualizando el mapa al estado más reciente.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Tu equipo ya alcanzó el límite del concurso simultáneo.';

  @override
  String get territoryErrorRegionsCap =>
      'Tu Crew ya posee la cantidad máxima de regiones.';

  @override
  String get territoryErrorContestNotActive =>
      'Este concurso aún no está activo. Espere a que termine la fase de preparación.';

  @override
  String get territoryErrorActionCooldown =>
      'Debes esperar antes de realizar otra acción territorial.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Esta acción pertenece al otro lado de la contienda.';

  @override
  String get territoryErrorHqLevelRequired =>
      'Tu nivel de HQ es demasiado bajo para esta acción territorial.';

  @override
  String get territoryErrorDailyCap =>
      'Has alcanzado tu límite diario de acciones territoriales.';

  @override
  String get territoryErrorWrongCountry =>
      'Puede ver todos los países, pero las acciones territoriales solo funcionan en el país donde se encuentra actualmente.';

  @override
  String get territoryErrorGarrisonNotOwner =>
      'Sólo la Crew que controla esta región puede desplegar una guarnición.';

  @override
  String get territoryErrorGarrisonAlreadyActive =>
      'Esta región ya cuenta con una guarnición activa.';

  @override
  String get territoryErrorGarrisonCrewLimit =>
      'Tu Crew ya tiene el número máximo de guarniciones activas.';

  @override
  String get territoryErrorGarrisonHq =>
      'Tu nivel de cuartel general es demasiado bajo para desplegar una guarnición.';

  @override
  String get territoryErrorGarrisonFunds =>
      'No hay suficiente dinero en el banco de la Crew para desplegar esta guarnición.';

  @override
  String get territoryErrorRegionEncircled =>
      'Esta región está rodeada por otras regiones de la misma Crew. Capture primero una región vecina.';

  @override
  String get territoryNoticeEncircled =>
      'Esta región interior está rodeada por otras regiones de la misma Crew, por lo que no puede ser atacada directamente. Tome primero una región vecina para abrir el frente.';

  @override
  String get territoryGarrisonTitle => 'Guarnición / defensa aérea';

  @override
  String get territoryGarrisonDesc =>
      'Contrata tanques y defensa aérea por unas horas. La región sigue siendo atacable, pero las acciones defensivas golpean con más fuerza y ​​los atacantes necesitan una mayor ventaja para capturarla.';

  @override
  String get territoryGarrisonDeploy => 'Desplegar guarnición';

  @override
  String territoryGarrisonActiveUntil(String time) {
    return 'Guarnición activa hasta $time';
  }

  @override
  String territoryGarrisonCostHours(String cost, int hours) {
    return '$cost del banco de Crew · ${hours}h';
  }

  @override
  String get territoryGarrisonDialogTitle => '¿Desplegar guarnición?';

  @override
  String territoryGarrisonDialogBody(String cost, int hours) {
    return 'Paga $cost del banco de Crew para estacionar tanques y defensa aérea aquí durante $hours horas. La región todavía puede ser atacada, pero es más difícil de tomar.';
  }

  @override
  String get territorySnackGarrisonDeployed => 'Guarnición desplegada.';

  @override
  String get territoryErrorUnknown => 'Error de territorio desconocido.';

  @override
  String get territoryLegendUnderContest => 'En concurso';

  @override
  String get territoryLegendNeutral => 'Neutral';

  @override
  String get territoryTabMap => 'Mapa';

  @override
  String get territoryTabLeaderboard => 'Tabla de clasificación';

  @override
  String get territoryTabSeason => 'Estación';

  @override
  String get territorySelectCountryTooltip => 'Seleccionar país';

  @override
  String get territoryUnavailableMessage =>
      'El territorio no está disponible actualmente.';

  @override
  String get territoryMapHintTapMain =>
      'Toque una región en el mapa para abrir la información del territorio y el botón de ataque en un modal.';

  @override
  String get territoryMapHintTapPanel =>
      'Toca una región para abrir directamente el modal con información del territorio y acciones de ataque.';

  @override
  String get territoryMapHintMobile =>
      'En dispositivos móviles, puedes acercar y alejar con dos dedos y arrastrar el mapa ampliado directamente para regiones más pequeñas.';

  @override
  String get territoryMapHintColors =>
      'Los colores de la región muestran propiedad; naranja = concurso activo.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country mapa (control de Crew)';
  }

  @override
  String get territoryLegendTitle => 'Leyenda';

  @override
  String territoryYourCrewLine(String name) {
    return 'Tu Crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Vista previa de la región';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Sólo la región seleccionada, sin el resto del mapa.';

  @override
  String get territoryNeutralTerritory => 'territorio neutral';

  @override
  String get territoryDetailOwner => 'Dueña';

  @override
  String get territoryDetailNeutral => 'Neutral';

  @override
  String get territoryDetailStability => 'Estabilidad';

  @override
  String get territoryDetailEffectiveStability => 'Estabilidad efectiva';

  @override
  String get territoryDetailControl => 'Control';

  @override
  String get territoryDetailValueTier => 'Nivel de valor';

  @override
  String get territoryDetailPayout => 'Pago';

  @override
  String get territoryDetailStrategicRole => 'Rol estratégico';

  @override
  String get territoryDetailAdjacentOwned => 'Regiones de propiedad adyacentes';

  @override
  String get territoryDetailActionBonuses => 'Bonos de acción';

  @override
  String get territoryDetailBonusInfo => 'Información de bonificación';

  @override
  String get territoryDetailBonusInfoBody =>
      'Estos bonos sólo aumentan tus puntos de concurso por acción. El pago en € de la región sigue siendo el mismo.';

  @override
  String get territoryDetailWarPressure => 'Presión de guerra';

  @override
  String get territoryDetailAttackPressure => 'presión de ataque';

  @override
  String get territoryDetailStabilityWord => 'estabilidad';

  @override
  String get territoryWarRoleTheater => 'región del teatro';

  @override
  String get territoryWarRoleAdjacent => 'región adyacente';

  @override
  String get territoryWarRoleTarget => 'región objetivo';

  @override
  String get territoryWarPressureEndsIn => 'La presión de la guerra termina en';

  @override
  String get territoryDetailIncomeHour => 'Ingreso por hora';

  @override
  String get territoryDetailIncomeDay => 'Ingresos por día';

  @override
  String get territoryDetailYourCrew => 'tu Crew';

  @override
  String get territoryDetailContestStatus => 'Estado del concurso';

  @override
  String get territoryDetailYourRole => 'Tu papel';

  @override
  String get territoryDetailYourHqLevel => 'Tu nivel de sede';

  @override
  String get territoryDetailActionsUnlockIn => 'Las acciones se desbloquean en';

  @override
  String get territoryDetailActionsCloseIn => 'Las acciones se cierran';

  @override
  String get territoryDetailContestEndsIn => 'El concurso termina en';

  @override
  String get territoryDetailCooldownPerAction => 'Enfriamiento por acción';

  @override
  String get territoryDetailYourCooldown => 'Tu tiempo de reutilización';

  @override
  String get territoryNoticeCrewOnly =>
      'El territorio solo es jugable para los miembros de la Crew. Primero crea o únete a una Crew, luego podrás atacar regiones neutrales.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Estás viendo $viewingCountry, pero actualmente estás en $playerCountry. Puedes explorar este mapa, pero los ataques y las acciones del concurso solo se desbloquean después de viajar a este país.';
  }

  @override
  String get territoryNoticeOwnRegion => 'Tu Crew ya controla esta región.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Tu Crew está defendiendo esta región. Una vez que comience la fase activa, solo verás acciones defensivas.';

  @override
  String get territoryConfirmDefense => 'Confirmar defensa';

  @override
  String get territoryAttack => 'Ataque';

  @override
  String get territoryAttackerActions => 'Acciones del atacante';

  @override
  String get territoryDefenderActions => 'Acciones del defensor';

  @override
  String get territoryContestActions => 'Acciones del concurso';

  @override
  String get territoryIntelShort => 'escaneo intel';

  @override
  String get territoryRequiresHqShort => 'requiere sede';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Se requiere un nivel de HQ más alto para: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'No eres parte de este concurso, por lo que no puedes realizar acciones aquí.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Este concurso se lleva a cabo en otro país. Puedes seguirlo, pero solo podrás unirte una vez que estés físicamente en $country.';
  }

  @override
  String get territoryLeaderboardEmpty =>
      'Ningún territorio controlado todavía.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regiones';
  }

  @override
  String get territorySeasonNone => 'No se encontró ninguna temporada activa.';

  @override
  String get territorySeasonCurrent => 'Temporada actual';

  @override
  String get territorySeasonKey => 'Llave';

  @override
  String get territorySeasonStatus => 'Estado';

  @override
  String get territorySeasonStart => 'Comenzar';

  @override
  String get territorySeasonEnd => 'Fin';

  @override
  String get territoryDialogAttackTitle => '¿Ataque?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return '¿Iniciar un concurso para $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Únete a un equipo primero para atacar el territorio.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Comenzó el concurso. Estado: $status. Espere a que finalice la fase de preparación antes de tomar medidas.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'El concurso ya comenzó y el mapa se actualizó. Estado: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points puntos!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Defensa confirmada. Una vez que comienza la fase activa, puedes realizar acciones defensivas.';

  @override
  String get territorySnackContestRefreshed =>
      'El estado del concurso ha sido actualizado. Ahora puedes ver inmediatamente la fase de defensa actual.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Requiere nivel HQ $required. Nivel actual del cuartel general: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (requiere HQ $level)';
  }

  @override
  String get smugglingHubTitle => 'Centro de contrabando';

  @override
  String get smugglingHubSubtitle =>
      'Un sistema para drogas, bienes comerciales, vehículos, armas y municiones. Viaje vacío y reclame de forma segura desde el depósito.';

  @override
  String get smugglingClaimPersonal => 'Reclamo personal';

  @override
  String get smugglingClaimCrew => 'Reclamar Crew';

  @override
  String get smugglingNewShipment => 'Nuevo envío';

  @override
  String get smugglingCategoryDrug => 'Drogas';

  @override
  String get smugglingCategoryTrade => 'bienes comerciales';

  @override
  String get smugglingCategoryVehicle => 'Vehículos';

  @override
  String get smugglingCategoryWeapon => 'Armas';

  @override
  String get smugglingCategoryAmmo => 'Munición';

  @override
  String get smugglingNoItemsInCategory =>
      'No hay artículos disponibles en esta categoría.';

  @override
  String get smugglingFieldItem => 'Artículo';

  @override
  String get smugglingFieldDestination => 'Destino';

  @override
  String get smugglingTransport => 'Transporte';

  @override
  String get smugglingCommercialChannel => 'Canal comercial';

  @override
  String get smugglingOwnedVehicleAircraft => 'Vehículo/avión propio';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'No tienes un vehículo o aeronave propia disponible para el contrabando en este país.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Transporte propio';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capacidad: $slots slots • Confiscación en caso de fallo: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots espacios • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Red';

  @override
  String get smugglingPersonal => 'Personal';

  @override
  String get smugglingCrew => 'Multitud';

  @override
  String get smugglingChannelField => 'canal de contrabando';

  @override
  String get smugglingQuantity => 'Cantidad';

  @override
  String get smugglingVehiclesOneByOne =>
      'Los vehículos se envían uno por uno.';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Máximo: $max';
  }

  @override
  String get smugglingStartSmuggling => 'empezar a contrabandear';

  @override
  String get smugglingSelectItemDestination => 'Seleccionar artículo y destino';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'El contrabando de tripulaciones para bienes comerciales aún no está disponible';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Seleccione primero un vehículo o avión propio';

  @override
  String get smugglingInvalidQuantity => 'Cantidad no válida';

  @override
  String get smugglingActionProcessed => 'Acción procesada';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes mín. • $risk% riesgo';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% riesgo';
  }

  @override
  String get smugglingQuotePrompt =>
      'Seleccione el artículo y el destino para obtener una cotización en vivo.';

  @override
  String get smugglingQuoteLiveTitle => 'cotización en vivo';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Transporte propio: $label';
  }

  @override
  String get smugglingHarborBonus =>
      'Bonus de puerto: ruta más rápida y menos decomiso (puerto de crew en este país).';

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Ranuras de carga: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Enfriamiento activo: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Canal recomendado: $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Efectivo insuficiente para este envío';

  @override
  String get smugglingDepotsTitle => 'Depósitos de países';

  @override
  String get smugglingDepotsEmpty => 'No hay paquetes listos en los depósitos.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages paquetes • $totalQuantity unidades';
  }

  @override
  String get smugglingClaimHere => 'Reclama aquí';

  @override
  String get smugglingStatusTitle => 'Estado de contrabando';

  @override
  String get smugglingNoShipmentsYet => 'Aún no hay envíos.';

  @override
  String get smugglingStatusInTransit => 'En tránsito';

  @override
  String get smugglingStatusReady => 'Listo';

  @override
  String get smugglingStatusSeized => 'incautado';

  @override
  String get smugglingStatusClaimed => 'Reclamada';

  @override
  String get smugglingStatusUnknown => 'Desconocida';

  @override
  String get smugglingChannelPackage => 'Paquete';

  @override
  String get smugglingChannelCourier => 'Mensajera';

  @override
  String get smugglingChannelContainer => 'Recipiente';

  @override
  String get smugglingChannelOwned => 'Transporte propio';

  @override
  String get smugglingHintOwnedTransport =>
      'El transporte propio reduce los costos y los riesgos, pero puede ser confiscado en caso de un intento fallido.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Consejo: los vehículos funcionan mejor con Courier o Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Consejo: las cargas de armas más grandes son mejores a través del contenedor.';

  @override
  String get smugglingHintAmmoChannel =>
      'Consejo: munición a granel a través de un contenedor para reducir el riesgo.';

  @override
  String get smugglingHintDrugsChannel =>
      'Consejo: lotes pequeños por paquete, a granel por contenedor.';

  @override
  String get smugglingHintCompareChannels =>
      'Consejo: compare canales con la cotización en vivo.';

  @override
  String get smugglingQuoteBoatCannotFit => 'Un barco no cabe en un avión.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'La capacidad de carga de transporte que posee es demasiado pequeña.';

  @override
  String get smugglingQuoteUnavailable => 'Cotización no disponible';

  @override
  String get smugglingApiInvalidChannel => 'Canal de contrabando no válido';

  @override
  String get smugglingApiInvalidNetwork => 'Elección de red no válida';

  @override
  String get smugglingApiInvalidQuantity => 'Cantidad no válida';

  @override
  String get smugglingApiInvalidDestination => 'El país de destino no existe';

  @override
  String get smugglingApiPlayerNotFound => 'Jugadora no encontrada';

  @override
  String get smugglingApiSameCountryInventory =>
      'Usar inventario local para el mismo país';

  @override
  String get smugglingApiNotInCrew => 'No estás en una Crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'El contrabando de tripulaciones para bienes comerciales aún no está disponible';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Los vehículos propios sólo sirven para el contrabando de personas.';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Elija un vehículo o avión propio';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'El vehículo de propiedad seleccionado no está disponible';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'No se puede utilizar el mismo vehículo como carga y transporte.';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Un coche o moto no puede llevar otro vehículo';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Los vehículos no pueden utilizar el canal de paquetes.';

  @override
  String get smugglingApiBoatCannotFit => 'Un barco no cabe en un avión.';

  @override
  String get smugglingApiCargoOverflow =>
      'La capacidad de carga de transporte que posee es demasiado pequeña.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Espere ${seconds}s antes de otro envío de $channel';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'No hay suficiente dinero para pagar las tarifas de contrabando';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'No hay suficientes medicamentos en el inventario de la Crew';

  @override
  String get smugglingApiInsufficientDrugs =>
      'No hay suficientes medicamentos en el inventario';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'No hay suficientes bienes comerciales en el inventario';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'No hay suficientes armas en el inventario de la Crew.';

  @override
  String get smugglingApiInsufficientWeapons =>
      'No hay suficientes armas en el inventario';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'No hay suficiente munición en el inventario de la Crew.';

  @override
  String get smugglingApiInsufficientAmmo =>
      'No hay suficiente munición en el inventario.';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Vehículo de Crew no válido';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Barco de Crew no disponible para contrabando';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'La motocicleta de la Crew no está disponible para el contrabando.';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'El coche de la Crew no está disponible para el contrabando.';

  @override
  String get smugglingApiInvalidVehicleKey => 'Vehículo inválido';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Vehículo no disponible para contrabando';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Stock insuficiente para este envío';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'No hay envíos listos en el depósito de este país';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Cantidad demasiado alta para $channel. Máximo: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Envío de contrabando ($channel) a $destination iniciado';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Recogido $count envío(s) en $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Recogido $count envío(s) de Crew en $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Envío fallido';

  @override
  String get smugglingClientQuoteFailed => 'Cotización fallida';

  @override
  String get smugglingClientClaimFailed => 'Reclamación fallida';

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
  String get cryptoMarketNoData =>
      'No hay datos del mercado criptográfico disponibles';

  @override
  String get cryptoMarketTitle => 'Mercado criptográfico';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Pedidos abiertos: $count';
  }

  @override
  String get cryptoRegimeBull => 'Mercado alcista';

  @override
  String get cryptoRegimeBear => 'mercado bajista';

  @override
  String get cryptoRegimeSideways => 'Oblicua';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Propiedad: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Cartera';

  @override
  String get cryptoLabelValue => 'Valor';

  @override
  String get cryptoLabelCostBasis => 'base de costo';

  @override
  String get cryptoLabelUnrealized => 'No realizado';

  @override
  String get cryptoLabelRealized => 'Comprendió';

  @override
  String get cryptoNoPositionsYet => 'Aún no hay puestos';

  @override
  String get cryptoChartDataUnavailable => 'Datos del gráfico no disponibles';

  @override
  String get cryptoUnknownTime => 'Desconocida';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop Loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Tomar ganancias';

  @override
  String get cryptoOrderTypeLimit => 'Límite';

  @override
  String get cryptoSideBuy => 'Comprar';

  @override
  String get cryptoSideSell => 'Vender';

  @override
  String get cryptoInvalidQuantity => 'Cantidad no válida';

  @override
  String get cryptoPurchaseCompleted => 'Compra completada';

  @override
  String get cryptoSaleCompleted => 'Venta completada';

  @override
  String get cryptoActionProcessed => 'Acción procesada';

  @override
  String get cryptoInvalidTargetPrice => 'Precio objetivo no válido';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'No puedes vender más de lo que posees.';

  @override
  String get cryptoOpenOrderPlaced => 'Orden abierta realizada';

  @override
  String get cryptoOpenOrderFailed => 'No se pudo realizar el pedido';

  @override
  String get cryptoOrderCancelled => 'Orden cancelada';

  @override
  String get cryptoCancelOrderFailed => 'No se pudo cancelar el pedido';

  @override
  String get cryptoDirectTradeTitle => 'Comercio directo';

  @override
  String get cryptoLabelQuantity => 'Cantidad';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Precio actual: €$currentPrice • Compra media: €$avgBuy \nUtilice TODO para vender su posición completa al instante.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Precio actual: €$currentPrice • Compra media: €$avgBuy';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Precio actual: €$currentPrice \nUtilice TODO para vender su posición completa al instante.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Precio actual: €$currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Tu historial para $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Compra promedio';

  @override
  String get cryptoLabelLastBuy => 'Última compra';

  @override
  String get cryptoLabelBuyVolume => 'Comprar volumen';

  @override
  String get cryptoLabelSellVolume => 'Volumen de venta';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Última compra a las $when';
  }

  @override
  String get cryptoNoTradesForCoinYet => 'Aún no hay cambios para esta moneda.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Pedidos abiertos para $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Los pedidos abiertos utilizan su propia cantidad a continuación. Complete tanto la cantidad como el precio objetivo en esta sección.';

  @override
  String get cryptoLabelOrderType => 'Tipo de orden';

  @override
  String get cryptoLabelSide => 'Lado';

  @override
  String get cryptoLabelOrderQuantity => 'Cantidad de pedido';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Esta orden se vende desde su posición actual. Propiedad: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Esta cantidad está separada del comercio directo anterior.';

  @override
  String get cryptoLabelTargetPrice => 'Precio objetivo';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limitar la compra por debajo del precio, limitar la venta por encima del precio';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Se ejecuta cuando el precio cae a este nivel.';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Se ejecuta cuando el precio sube a este nivel.';

  @override
  String get cryptoPlaceOpenOrder => 'Realizar pedido abierto';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Aún no tienes ninguna orden abierta para esta moneda.';

  @override
  String get cryptoLabelCancel => 'Cancelar';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Detalles criptográficos • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Acuñar';

  @override
  String get cryptoLabelPrice => 'Precio';

  @override
  String get cryptoLabelOwned => 'Propiedad';

  @override
  String get cryptoLabelOpenOrders => 'Órdenes abiertas';

  @override
  String get cryptoNotEnoughHistory => 'Aún no hay suficiente historia';

  @override
  String get cryptoChartPointsWord => 'agujas';

  @override
  String get cryptoChartHourAbbrev => 'h';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • historial completo';
  }

  @override
  String cryptoChartDataCaptionHours(int count, String points, String hours) {
    return '$count $points • $hours';
  }

  @override
  String get cryptoChartRange1h => '1 hora';

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
  String get cryptoChartRangeAll => 'Toda';

  @override
  String get cryptoChartLive1h => 'En vivo • última 1 h';

  @override
  String get cryptoChartLive4h => 'En vivo • últimas 4 h';

  @override
  String get cryptoChartLive8h => 'En vivo • últimas 8h';

  @override
  String get cryptoChartLive24h => 'En vivo • últimas 24h';

  @override
  String get cryptoChartLive7d => 'En vivo • últimos 7 días';

  @override
  String get cryptoChartLive30d => 'En vivo • últimos 30 días';

  @override
  String get cryptoChartLiveAll => 'En vivo • historia completa';

  @override
  String get cryptoLabelTotal => 'Total';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'No se pudo cargar el mercado criptográfico.';

  @override
  String get cryptoApiAssetNotFound => 'Cripto no encontrado.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'No se pudieron cargar los datos del gráfico criptográfico.';

  @override
  String get cryptoApiNotLoggedIn => 'No iniciado sesión.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'No se pudo cargar el portafolio.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'No se pudo cargar el historial de transacciones criptográficas.';

  @override
  String get cryptoApiInvalidQuantity => 'Cantidad no válida.';

  @override
  String get cryptoApiInsufficientFunds => 'Hace falta dinero.';

  @override
  String get cryptoApiPurchaseFailed => 'Compra fallida.';

  @override
  String get cryptoApiNotEnoughCrypto =>
      'No se tienen suficientes criptomonedas.';

  @override
  String get cryptoApiSellFailed => 'La venta fracasó.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'No se pudieron cargar pedidos criptográficos.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Precio objetivo no válido.';

  @override
  String get cryptoApiInvalidOrderType => 'Tipo de orden no válido.';

  @override
  String get cryptoApiInvalidOrderSide => 'Lado del pedido no válido.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Este tipo de orden y combinación de lados no están permitidos.';

  @override
  String get cryptoApiPlaceOrderFailed => 'No se pudo realizar el pedido.';

  @override
  String get cryptoApiPlayerNotFound => 'Jugadora no encontrada';

  @override
  String get cryptoApiInvalidOrderId => 'ID de pedido no válido.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Pedido no encontrado o ya no está activo.';

  @override
  String get cryptoApiCancelOrderFailed => 'No se pudo cancelar el pedido.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Compraste $quantity $symbol por $total€.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Vendiste $quantity $symbol por $total€.';
  }

  @override
  String cryptoApiOrderPlaced(
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return 'Pedido realizado: $side $quantity $symbol @ $price.';
  }

  @override
  String cryptoApiOrderCancelledDetail(int orderId) {
    return 'Pedido $orderId cancelado.';
  }

  @override
  String cryptoClientErrorPrefix(String detail) {
    return 'Error: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Error al cargar instalaciones: $error';
  }

  @override
  String get drugsInvTitle => 'Inventario de medicamentos';

  @override
  String get drugsInvKpiGramsLabel => 'inventario';

  @override
  String get drugsCutQualityDCannotCut =>
      'La calidad D no se puede reducir más.';

  @override
  String get drugsCutFailed => 'El corte falló';

  @override
  String get drugsSellFailed => 'Venta fallida';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Vender $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Disponible: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Calidad: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Precio actual: $price€ el gramo';
  }

  @override
  String get drugsPricesByCountry => 'Precios por país:';

  @override
  String get drugsQuantityGramsField => 'Cantidad (gramos)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsInvalidQuantity => 'Cantidad no válida';

  @override
  String get drugsSellAction => 'Vender';

  @override
  String get drugsExportAction => 'Exportar';

  @override
  String drugsExportDialogTitle(String name) {
    return 'Export $name';
  }

  @override
  String get drugsExportDestLabel => 'Destino';

  @override
  String drugsExportQuoteStreet(String amount) {
    return 'Precio calle dest.: €$amount/g';
  }

  @override
  String drugsExportQuoteB2b(String amount) {
    return 'Mayorista: €$amount/g';
  }

  @override
  String drugsExportPayout(String amount) {
    return 'Pago al llegar: €$amount';
  }

  @override
  String drugsExportFee(String amount) {
    return 'Flete: €$amount';
  }

  @override
  String drugsExportEta(String minutes) {
    return 'ETA: $minutes min';
  }

  @override
  String drugsExportSeizure(String pct) {
    return 'Incautación: $pct%';
  }

  @override
  String drugsExportHeat(String heat, String fbi) {
    return 'Heat +$heat · FBI +$fbi';
  }

  @override
  String get drugsExportHarbor => 'Bonus de puerto activo';

  @override
  String get drugsExportConfirm => 'Enviar';

  @override
  String drugsExportMinHint(String grams) {
    return 'Mínimo ${grams}g';
  }

  @override
  String get drugsExportFailed => 'Exportación fallida';

  @override
  String get drugsExportStarted => 'Carga en tránsito. Efectivo al llegar.';

  @override
  String get drugsExportCannotAfford =>
      'No hay suficiente efectivo para el flete';

  @override
  String get drugsExportCrewFeeHint => 'El banco del crew paga el flete';

  @override
  String drugsExportCrewPayout(String crew, String runner) {
    return 'Pago: crew €$crew · corredor €$runner';
  }

  @override
  String get drugsExportCannotAffordCrew =>
      'El banco del crew no cubre el flete';

  @override
  String get drugsHubExportCrewPrefix => 'Crew';

  @override
  String get drugsCrewLotsTitle => 'Lotes de calidad del crew';

  @override
  String get drugsCrewExportStarted =>
      'Carga del crew en tránsito. Efectivo al llegar al banco del crew.';

  @override
  String get drugsHubExportsTitle => 'Envíos mayoristas';

  @override
  String get drugsHubExportInTransit => 'En tránsito';

  @override
  String get drugsHubExportSold => 'Vendido';

  @override
  String get drugsHubExportSeized => 'Incautado';

  @override
  String get drugsHubExportEmpty => 'Sin exportaciones abiertas';

  @override
  String drugsHubExportLine(String qty, String dest, String status) {
    return '${qty}g → $dest · $status';
  }

  @override
  String get drugsInvEmptyTitle => 'No hay medicamentos en el inventario.';

  @override
  String get drugsInvEmptySubtitle =>
      'Iniciar la producción para crear medicamentos.';

  @override
  String get drugsInvSectionHeader => 'Inventario y distribución';

  @override
  String get drugsInvSectionBody =>
      'Vende en local o exporta un lote mayorista a otro país. Venta callejera, nightclub, darkweb y Marketplace siguen siendo minorista.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Ubicación actual: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventario: $qty g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Valor actual: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Mercado: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Cortar las drogas';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Calidad $fromQ → $toQ: +$pct% más unidades';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Resultado: $qty g $qFrom → $result g $qTo';
  }

  @override
  String get drugsCutAction => 'Cortar';

  @override
  String get drugsSlotsLabel => 'tragamonedas';

  @override
  String get drugsFacilitiesTitle => 'Instalaciones de drogas';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Administre sus instalaciones farmacéuticas';

  @override
  String get drugsFacilitiesHeroBody =>
      'Instalaciones como un invernadero, una granja de hongos, un laboratorio de drogas, una cocina de crack y una tienda en la web oscura determinan qué medicamentos puedes producir, cuántos espacios tienes y qué tan fuertes son tu calidad, rendimiento y velocidad.';

  @override
  String get drugsFacCurrentProductions => 'Producciones actuales';

  @override
  String get drugsFacUnknownFacility => 'Instalación desconocida';

  @override
  String get drugsFacUnknownMessage => 'Mensaje desconocido';

  @override
  String get drugsFacUpgradeLockedTitle =>
      'Upgrade Actualización de drogas bloqueada';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Primero necesita las certificaciones y los niveles de educación sobre narcóticos adecuados.';

  @override
  String get drugsFacEquipLockedTitle => '🔒 Actualización de equipo bloqueada';

  @override
  String get drugsFacEquipLockedBody =>
      'Entrena tu pista de Narcóticos primero para desbloquear el siguiente nivel de actualización.';

  @override
  String get drugsFacBuy => 'Comprar';

  @override
  String get drugsFacOwned => 'Propiedad';

  @override
  String get drugsFacPrice => 'Precio';

  @override
  String get drugsFacRank => 'Rango';

  @override
  String get drugsFacDrugTypes => 'Drogas';

  @override
  String get drugsFacSlots => 'Tragamonedas';

  @override
  String get drugsFacQuality => 'Calidad';

  @override
  String get drugsFacYield => 'Producir';

  @override
  String get drugsFacSpeed => 'Velocidad';

  @override
  String get drugsFacMaxSlots => 'Ranuras máximas';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Espacios de mejora (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Actualizaciones de equipos';

  @override
  String get drugsFacMax => 'máx.';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Nivel $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Entorno de drogas';

  @override
  String get drugsSubviewProduction => 'Producción de drogas';

  @override
  String get drugsSubviewFacilities => 'Instalaciones de drogas';

  @override
  String get drugsSubviewInventory => 'Inventario de medicamentos';

  @override
  String get drugsTagUndergroundOps => 'Operaciones subterráneas';

  @override
  String get drugsTagMobileOptimized => 'Optimizado para dispositivos móviles';

  @override
  String get drugsTagQualityDriven => 'Impulsado por la calidad';

  @override
  String get drugsEmpireTitle => 'Imperio de las drogas';

  @override
  String get drugsHubIntro =>
      'Administre la producción, las instalaciones y el inventario aquí. Compra materiales en el mercado negro mientras el resto corre en tu propio entorno de drogas.';

  @override
  String get drugsStatMaterialFlow => 'Flujo de materiales';

  @override
  String get drugsStatBlackMarket => 'Mercado negro';

  @override
  String get drugsStatProductionChain => 'Cadena de producción';

  @override
  String get drugsStatProductionChainValue =>
      'Invernadero + Laboratorio + Cocina + Darkweb';

  @override
  String get drugsStatSalesModel => 'Modelo de ventas';

  @override
  String get drugsStatPerQuality => 'Por calidad';

  @override
  String get drugsMetricActiveBatches => 'Lotes activos';

  @override
  String get drugsMetricSlotUsage => 'Uso de ranuras';

  @override
  String get drugsMetricInventoryValue => 'Valor de inventario';

  @override
  String get drugsMetricInventoryGrams => 'gramos de inventario';

  @override
  String get drugsMetricEfficiency => 'Eficiencia';

  @override
  String get drugsMetricPoliceHeat => 'Calor policial';

  @override
  String get drugsSectionOperations => 'Operaciones';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Elige una rama de tu imperio narco';

  @override
  String get drugsCardOpenAction => 'Open';

  @override
  String drugsCardStepLabel(int step) {
    return 'Step $step';
  }

  @override
  String get drugsCardFacilitiesEyebrow => 'Infraestructura';

  @override
  String get drugsCardFacilitiesTitle => 'Instalaciones';

  @override
  String get drugsCardFacilitiesBody =>
      'Compre y actualice el invernadero, el laboratorio de drogas, la cocina de crack y el escaparate de la web oscura para obtener más espacios, velocidad y calidad.';

  @override
  String get drugsCardProductionEyebrow => 'Tubería';

  @override
  String get drugsCardProductionTitle => 'Producción';

  @override
  String get drugsCardProductionBody =>
      'Inicie lotes, realice un seguimiento de los temporizadores y recopile resultados con rollos de calidad.';

  @override
  String get drugsCardInventoryEyebrow => 'Distribución';

  @override
  String get drugsCardInventoryTitle => 'Inventario';

  @override
  String get drugsCardInventoryBody =>
      'Vea pilas por calidad y venda al mejor valor del mercado.';

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
  String get drugsQualityDistribution => 'Distribución de calidad';

  @override
  String get drugsQualityGradeSuperior => 'Superiora';

  @override
  String get drugsQualityGradeHigh => 'Alta';

  @override
  String get drugsQualityGradeStandardPlus => 'Estándar+';

  @override
  String get drugsQualityGradeStandard => 'Estándar';

  @override
  String get drugsQualityGradeLow => 'Bajo';

  @override
  String get drugsHeatLevelLow => 'Bajo';

  @override
  String get drugsHeatLevelMedium => 'Medio';

  @override
  String get drugsHeatLevelHigh => 'Alta';

  @override
  String get drugsHeatLevelCritical => 'Crítica';

  @override
  String get drugsProdTitle => 'Producción de drogas';

  @override
  String get drugsProdLineTitle => 'Línea de montaje';

  @override
  String get drugsProdLineSubtitle =>
      'Inicie lotes, supervise la capacidad de las ranuras y ajuste la calidad mediante actualizaciones de invernaderos y laboratorios.';

  @override
  String get drugsProdActiveProductions => 'Producciones Activas';

  @override
  String get drugsProdIncidentLegend => 'Leyenda del incidente';

  @override
  String get drugsProdHide => 'Esconder';

  @override
  String get drugsProdShow => 'Espectáculo';

  @override
  String get drugsProdLegendDelay => 'Demora';

  @override
  String get drugsProdLegendContamination => 'Contaminación';

  @override
  String get drugsProdLegendYieldLoss => 'Pérdida de rendimiento';

  @override
  String get drugsProdLegendInstability => 'Inestabilidad';

  @override
  String get drugsProdLegendCombined => 'Problema combinado';

  @override
  String get drugsProdCollect => 'Recolectar';

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
  String get drugsProdAvailableDrugs => 'Medicamentos disponibles';

  @override
  String get drugsProdNoDrugs => 'No hay medicamentos disponibles';

  @override
  String get drugsProdAutoCollectOn => 'Recogida automática en (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Retiro automático desactivado (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Todos los materiales disponibles';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: compra materiales faltantes en un clic';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Hora: $time | Rendimiento: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total ranuras utilizadas';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility requerido';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Rango $rank requerido';
  }

  @override
  String get drugsProdNoFreeSlot =>
      'No hay espacio de producción libre disponible';

  @override
  String get drugsProdOpenFacilities => 'Instalaciones abiertas';

  @override
  String get drugsProdStartProduction => 'Iniciar producción';

  @override
  String get drugsProdAutoCollectUpdated =>
      'Recopilación automática actualizada';

  @override
  String get drugsProdKpiActive => 'activa';

  @override
  String get drugsProdKpiReady => 'lista';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Rendimiento: $qty gramos';
  }

  @override
  String get drugsTimeMinSuffix => 'mín.';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes minutos';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours hora';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '$hours hora $minutes minuto';
  }

  @override
  String get drugsTimeHourEn => 'hora';

  @override
  String get drugsProdConfirmTitle => 'Estas segura';

  @override
  String drugsProdConfirmBody(String drugName) {
    return '¿Iniciar $drugName producción?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Hora: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Rendimiento: $yield gramos';
  }

  @override
  String get drugsProdRiskNote =>
      'En ocasiones, la producción puede sufrir contratiempos. Mejores actualizaciones reducen el riesgo, el alto calor de los medicamentos lo aumenta.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Materiales necesarios:';

  @override
  String get drugsProdStartProductionButton => 'Iniciar producción';

  @override
  String get drugsProdFailed => 'La producción falló';

  @override
  String get drugsProdCollectFailed => 'Recolección fallida';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Necesitas rango $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Desaparecida';

  @override
  String get drugsFacilityGreenhouse => 'Invernadero';

  @override
  String get drugsFacilityCrackKitchen => 'Cocina grieta';

  @override
  String get drugsFacilityDarkweb => 'Escaparate de Darkweb';

  @override
  String get drugsFacilityMushroomFarm => 'Granja de hongos';

  @override
  String get drugsFacilityDrugLab => 'laboratorio de drogas';

  @override
  String get drugsVipQuickBuyTitle => 'Compra rápida VIP';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Ya tienes suficientes materiales para $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return '¿Comprar todos los materiales que faltan por $name con un solo clic?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsPurchaseCompleted => 'Compra completada';

  @override
  String get drugsPurchaseFailed => 'Compra fallida';

  @override
  String get drugsServiceErrorGeneric => 'Error';

  @override
  String get drugsApiFailedBuyMaterial => 'No se pudo comprar material';

  @override
  String get drugsApiFailedStartProduction =>
      'No se pudo iniciar la producción';

  @override
  String get drugsApiFailedCollect => 'No se pudo recolectar la producción.';

  @override
  String get drugsApiFailedSell => 'No se pudo vender drogas';

  @override
  String get drugsApiFailedCut => 'No se pudo cortar las drogas';

  @override
  String get drugsApiFailedShipment => 'No se pudo enviar el envío';

  @override
  String get drugsApiFailedClaim =>
      'No se pudieron reclamar los envíos del depósito';

  @override
  String get helpTopicDashboardCategory => 'Centro';

  @override
  String get helpTopicDashboardTitle => 'Panel';

  @override
  String get helpTopicDashboardSummary =>
      'Tu descripción general central con todas tus estadísticas, tiempos de reutilización activos, eventos en vivo y accesos directos a cada parte del juego.';

  @override
  String get helpTopicDashboardHow =>
      'La barra superior muestra: efectivo, rango, salud (0-100 HP), nivel de búsqueda (0-100) y FBI Heat (0-100). \nLos títulos de rango siguen la misma escala que tu perfil público: por ejemplo, Soldado alrededor del rango 25 y Padrino solo a partir del rango 60. \nCada 5 minutos se activa un tic automático: el hambre cae -2, la sed -3, te curas pasivamente +5 HP (si HP > 0), se agrega interés bancario (0,5%) y el nivel de búsqueda cae ligeramente cuando es inferior a 10. \nSi el hambre o la sed llega a 0, mueres y pasas 3 horas en la UCI. ¡Come y bebe a tiempo! \nEn dispositivos móviles, un pie de página adhesivo mantiene los delitos, el robo de vehículos, el trabajo, el banco y la Crew a un toque de distancia. Un punto dorado en Crímenes, Robo o Trabajo significa que el tiempo de reutilización está listo. Todo lo demás está en el menú de hamburguesas o en la barra lateral izquierda; ese menú está agrupado (Acciones, Mundo, Social, Economía, Imperio, Activos) y se puede buscar. \nLos temporizadores de recuperación por sección muestran cuánto tiempo falta para que tu próxima acción esté disponible. El cronómetro se adapta para mostrar la unidad más relevante: minutos, horas o días. \nLa tarjeta de estadísticas ahora utiliza contadores reales para fugas, asesinatos, contratos de listas de éxito, viajes y balas en lugar de marcadores de posición fijos de cero. \nEl panel ahora también tiene una sección económica ampliada con efectivo, banco, criptografía, valor del vehículo, valor de la propiedad, patrimonio neto y una tendencia del flujo de caja de 24 horas. \nEl bloque de operaciones ahora muestra la producción activa, el tiempo de reutilización más largo, el estado del vehículo (activo/listado/en tránsito) y los temporizadores de próxima producción/evento. \nCuando los eventos de los jugadores están en vivo (por ejemplo, competencia semanal), el mismo panel de la derecha enumera brevemente sus títulos y enlaces a la página de Eventos. Puede activar o desactivar la opción push para el inicio/finalización de la ronda en Configuración → Eventos del jugador (además de los permisos del dispositivo y otras categorías push). \nNotificaciones y riesgo ahora incluye mensajes directos no leídos, tickets de soporte en espera de respuesta, eventos de las últimas 24 horas y una puntuación de riesgo compacta (se busca + FBI). \nCuando tu Crew participa en Crew Wars, el panel también muestra un resumen de Crew Wars con estado, oponente, puntos de Crew, rango de temporada y el tiempo restante en la fase actual. \nEl tablero ahora también incluye una descripción general de las operaciones del vehículo por auto/moto/barco con chips de enfriamiento en vivo (punto de acceso, Crew, partida de Crew, corte, contrato y contador), además de calor/reputación, conteos de contratos y reclamos, y puntos de temporada. \nLos eventos en vivo aparecen cuando otros jugadores realizan acciones importantes, cuando eres atacado o cuando ocurren movimientos en el mercado global. \nLa insignia de mensaje muestra mensajes del sistema no leídos y mensajes personales. \nEl menú de avatar en la parte superior derecha abre Mi perfil, mensajes, ayuda, configuración y cerrar sesión. \nEl menú de navegación izquierdo otorga acceso a todas las secciones del juego agrupadas por categoría: Acciones, Mundo, Social, Economía, Imperio y Activos.';

  @override
  String get helpTopicDashboardTips =>
      'Abra el panel primero después de cada inicio de sesión para ver qué cambió mientras estuvo ausente. \nMantenga el nivel de búsqueda por debajo de 10 para que la decadencia automática funcione y las posibilidades de arresto se mantengan bajas. \nVerifique los mensajes no leídos antes de iniciar acciones riesgosas: las recompensas, los pedidos completados y los eventos del sistema aparecen en su bandeja de entrada.';

  @override
  String get helpTopicCrimesCategory => 'Comportamiento';

  @override
  String get helpTopicCrimesTitle => 'Crímenes';

  @override
  String get helpTopicCrimesSummary =>
      'Comete acciones ilegales por dinero en efectivo y XP, pero cada intento corre el riesgo de sufrir daños, arresto o nivel de búsqueda adicional. El delito de eliminación de antecedentes penales del último juego elimina todos sus antecedentes penales si tiene éxito, pero necesita herramientas pesadas y conlleva un alto riesgo federal.';

  @override
  String get helpTopicCrimesHow =>
      'Los tiempos de reutilización de los delitos ahora aumentan con los posibles beneficios: los delitos de bajo rendimiento se mantienen rápidos, mientras que los delitos de alto rendimiento tienen tiempos de reutilización claramente más prolongados. \nPauta por nivel de recompensa: hasta 500 € ≈ 1,5 min, hasta 2000 € ≈ 5 min, hasta 10 000 € ≈ 15 min, hasta 30 000 € ≈ 30 min, por encima de eso ≈ 60 min. \nNo existe un límite diario estricto para los delitos; Los jugadores activos pueden seguir jugando siempre que administren los tiempos de reutilización, el riesgo y los recursos. \nLos delitos con \"arma requerida\" miran ambas ranuras para armas desgastadas y automáticamente utilizan la mejor combinación para ese delito. Use las armas en el Inventario; una pistola de mochila no cuenta. \nTus bonificaciones activas de gimnasio y campo de tiro (hasta +8 % cada una) se muestran en la pantalla de Crímenes; aumentan las posibilidades de éxito a medida que el servidor calcula (entrene más a través del centro de entrenamiento/gimnasio + gama). \nSi completa al menos una sesión de gimnasio y una sesión de campo de tiro en el mismo día calendario UTC, el servidor agrega una pequeña probabilidad adicional de éxito en el crimen (+0,5%). La pantalla de Delitos muestra cuando este combo está activo. \nLos delitos que requieren un vehículo utilizan el vehículo criminal seleccionado en Garage o Marina. Solo cuenta un vehículo que se encuentra realmente en su país actual y que no está en tránsito ni listado para la venta. \nLos requisitos de drogas en delitos se muestran en gramos y siguen las mismas cantidades que su inventario y almacenamiento de drogas. \nSi un delito no puede comenzar debido a la falta de un vehículo, el arma equivocada o la falta de munición, el mensaje de error ahora debería mostrar la causa real en lugar de un reintento genérico. \nCada intento de crimen: recibes entre 5 y 15 HP de daño, reducido por un chaleco desgastado y guardaespaldas (hasta aproximadamente la mitad de descuento). El nivel de búsqueda sigue aumentando entre 1 y 4 puntos dependiendo del éxito o el fracaso. \nLa probabilidad de arresto aumenta rápidamente con el nivel de búsqueda: se busca 5 = 25 %, se busca 10 = 50 %, se busca 18+ = máximo 90 %. \nAl ser arrestado vas a prisión. Oración = máximo (nivel buscado × 10, 5) minutos. Fianza = nivel de búsqueda × 1.000 €. Incluso si el delito parece exitoso al principio pero te atrapan inmediatamente después, el resultado final cuenta como un arresto: se confiscan las herramientas necesarias, se pierde el arma utilizada en el crimen y también se pueden confiscar los vehículos. \nAlgunos delitos requieren un vehículo, herramienta o rango mínimo. Omitirlos evitará que comience el delito. \nLa XP obtenida aumenta tu rango, desbloqueando mejores crímenes y mayores recompensas. \nEl calor del FBI aumenta con crímenes más graves. Por encima de 50, el FBI se activa con posibilidades de arresto aún mayores. \nCuando se habilita la presión policial del país, un medidor de calefacción compartido por país suaviza el éxito del crimen y aumenta las posibilidades de arresto en el lugar donde se encuentre. Los viajes muestran insignias de bandas; Las operaciones de interrupción raras (Crew/rango cerrado) pueden enfriar temporalmente las calles.';

  @override
  String get helpTopicCrimesTips =>
      'Utilice crímenes rápidos para principiantes para generar XP mientras espera grandes tiempos de reutilización. \nSiempre sal de apuros si tu nivel de búsqueda es alto: estar en la cárcel bloquea todos tus bucles. \nUse un chaleco en caso de crimen: reduce el impacto de 5 a 15 HP y lo mantiene fuera de la UCI por más tiempo. Mantenga HP por encima de 30 antes de comenzar una carrera.';

  @override
  String get helpTopicJobsCategory => 'Comportamiento';

  @override
  String get helpTopicJobsTitle => 'Empleos';

  @override
  String get helpTopicJobsSummary =>
      'Gana dinero legal sin riesgo de nivel buscado. Los trabajos son más seguros que los delitos, pero los pagos son más bajos.';

  @override
  String get helpTopicJobsHow =>
      'Los trabajos disponibles aumentan con el rango y la educación: los mejores trabajos pagan más, pero también tienen tiempos de reutilización más prolongados. \nLos tiempos de reutilización de los trabajos aumentan según el pago máximo: trabajos de nivel bajo alrededor de 3 a 5 minutos, de nivel medio alrededor de 8 a 12 minutos, de nivel superior alrededor de 17 a 22 minutos. \nLos trabajos tienen una tasa de éxito alta, pero no perfecta; Si falla, no pierde dinero ni HP, pero sí pierde algo de XP. \nRequisitos por puesto: mínimo 10 HP, hambre > 20, sed > 20, no en la cárcel, no en la UCI. \nNo existe un límite diario estricto para los empleos; La progresión se rige por el tiempo de reutilización, la probabilidad y el pago en lugar de un bloqueo diario. \nEl salario laboral varía según el tipo de trabajo y el rango. La educación (la escuela) puede desbloquear posiciones más altas. \nTambién gana XP por trabajo, aunque menos que por delitos comparables. \nUtilice los empleos como una base confiable de flujo de efectivo, especialmente cuando su nivel de búsqueda es demasiado alto para cometer delitos seguros.';

  @override
  String get helpTopicJobsTips =>
      'Combinar empleo y escuela: la educación desbloquea mejores empleos con mayores remuneraciones. \nCuando el nivel de búsqueda sea superior a 8 o se esté recuperando de la UCI, utilice trabajos en lugar de delitos. \nEvite que el hambre y la sed bajen demasiado: un trabajo con estadísticas inferiores a 20 simplemente no comenzará.';

  @override
  String get helpTopicTravelCategory => 'Mundo';

  @override
  String get helpTopicTravelTitle => 'Viajar';

  @override
  String get helpTopicTravelSummary =>
      'Muévase entre países para obtener mejores precios de mercado, oportunidades únicas y acceso a sistemas internacionales.';

  @override
  String get helpTopicTravelHow =>
      'Países disponibles: Países Bajos (inicio), Bélgica, Alemania, Francia, Reino Unido, España, Italia, Suiza, Estados Unidos, México, Colombia, Brasil. \nGastos de viaje: país vecino 500-2000 €, Europa → América 5000-10 000 €, larga distancia 10 000-20 000 €. \nRequisitos de viaje: no en la cárcel, no en la UCI, mínimo 20 HP, fondos de viaje disponibles. \nLas cantidades de medicamentos en su inventario cuentan como gramos reales para los controles de peso de transporte y de viaje; 500 significa 500 g, no 50 kg. \nCada país tiene diferentes precios de mercado (hasta un 300% de diferencia de precio), diferentes pagos por delitos y artículos comerciales únicos. \nRiesgo de transporte: la policía puede confiscar mercancías según el nivel de búsqueda (posibilidad = buscada × 2%, máximo 80%). El FBI puede confiscar todo a nivel internacional si la presión es alta. \nLa inspección aduanera tiene una probabilidad base del 10%. Puedes sobornar (1.000€-5.000€) o quedar atrapado perdiendo el 50% de los bienes. \nDespués de su llegada, todas las acciones estarán disponibles inmediatamente en el nuevo país. Los mercados y la velocidad del crimen varían según la ubicación.';

  @override
  String get helpTopicTravelTips =>
      'Combine siempre los viajes con el comercio, las drogas o el contrabando: los viajes vacíos desperdician dinero. \nReduzca su nivel de búsqueda antes de la salida: un nivel alto de búsqueda aumenta considerablemente el riesgo de confiscación en el camino. \nPlanifique su viaje de regreso con anticipación para saber qué traer a su llegada.';

  @override
  String get helpTopicAviationCategory => 'Mundo';

  @override
  String get helpTopicAviationTitle => 'Aviación';

  @override
  String get helpTopicAviationSummary =>
      'Termine la escuela de aviación, compre una licencia paga, luego compre un avión para volar instantáneamente, reduzca el tiempo de viaje comercial y venda o repare su flota de hangares.';

  @override
  String get helpTopicAviationHow =>
      'Complete la escuela de aviación hasta el nivel 5 y obtenga ambos certificados de vuelo antes de poder comprar una licencia paga. \nCompra una licencia paga en la pantalla de Aviación: básica, comercial o de carga. Los niveles más altos desbloquean aviones más pesados. \nCompra un avión del catálogo de hangares. Los nuevos aviones comienzan con el tanque vacío. \nRepostar desde el hangar a 50€ el litro. Un vuelo privado consume 100 L y te traslada a otro país al instante. \nCommercial Travel todavía utiliza billetes y tramos. Ser propietario de un avión acorta esa espera: Cessna −15%, King Air −25%, Citation −30%, Gulfstream −35%, aviones de carga −30%. Sólo el mejor avión cuenta. \nVender un avión en propiedad por el 50% del precio de compra. Repara un avión averiado antes de poder repostar o volarlo.';

  @override
  String get helpTopicAviationTips =>
      'School 5/5 no es suficiente: aún necesita la licencia paga antes de cualquier compra. \nTanque suficiente para 100 L antes de volar. Un avión vacío no puede salir del hangar. \nUn avión también acelera los viajes normales, incluso si se toma la ruta comercial. \nVender aviones no utilizados si necesita dinero en efectivo; solo obtienes la mitad de lo que pagaste.';

  @override
  String get helpTopicCrewCategory => 'Social';

  @override
  String get helpTopicCrewTitle => 'Multitud';

  @override
  String get helpTopicCrewSummary =>
      'Forma un equipo o únete a jugadores existentes para realizar atracos juntos, compartir almacenamiento y fortalecerte como unidad.';

  @override
  String get helpTopicCrewHow =>
      'Crear una Crew cuesta 10.000 €. El cuartel general de la Crew determina cuántos miembros puede albergar tu Crew y aumenta hasta 150 miembros. El líder puede invitar, patear e iniciar atracos. \nBeneficios de la Crew: acceso a grandes atracos, almacenamiento compartido, bonificación de trabajo en equipo (+10% de éxito por miembro adicional, máximo +30%) y chat grupal. \nLas nuevas tripulaciones ahora comienzan con el nivel 1 del cuartel general de la Crew y todos los edificios de almacenamiento en el nivel 1, incluido el almacenamiento de efectivo, por lo que el banco de Crew y el almacenamiento compartido funcionan de inmediato. \nEl almacenamiento de vehículos de la Crew ahora también acepta motocicletas, por lo que los vehículos terrestres se pueden administrar juntos desde el mismo almacenamiento compartido de la Crew. \nCuando un miembro de la Crew es arrestado, los miembros de la Crew ahora reciben una notificación automática de que el jugador está encerrado y esperando ayuda. \nLa pantalla de la Crew ahora está agrupada en Descripción general, Sede y mejoras, Almacenamiento, Miembros, Sala de guerra, Misiones de la Crew, Tripulaciones y Chat para que la administración se sienta más tranquila y profesional. \nCrew Missions muestra plantillas de niveles, una tarjeta de carrera activa y carreras recientes. Los líderes/colíderes pueden comenzar y resolver; La reclamación de recompensas y la aceleración del tiempo de reutilización se manejan en la misma pestaña. \nHay misiones de Crew adicionales con operaciones con temática bancaria (depósito nocturno, red de desnatado, ruta blindada, bóveda subsidiaria, bóveda de reserva y cámara de compensación). No hay una segunda misión para el equipo del casino además de Casino Ledger Raid. \nLas recompensas de las misiones de la Crew provienen de la economía de las misiones del lado del servidor; Los saldos bancarios de otros jugadores no se cargan para estos pagos. \nAl comenzar una misión, ahora puedes asignar un rol por miembro de la Crew (planificador, ejecutor, logística, técnico) para obtener bonificaciones de equipo. \nLas tarjetas de misión activas y recientes ahora también muestran contribuciones de rol por jugador con puntuación y cualquier multiplicador de pago. \nLos miembros de la Crew ahora también reciben alertas push/en la aplicación sobre el inicio de la misión, el resultado de la misión y cuando el tiempo de reutilización de la misión vuelve a estar listo. \nMientras el tiempo de reutilización de una misión esté activo, no podrás iniciar una nueva misión; Primero espera el tiempo de reutilización restante o acelera con créditos. \nPara acelerar el tiempo de recuperación, primero verá el costo exacto del crédito y los minutos restantes antes de confirmar. \nCrew Wars tiene su propia pestaña War Room dentro de la pantalla de la Crew. Solo los líderes pueden declarar una guerra y se requiere que participen al menos 3 miembros de la Crew. \nTipos de guerra: Kill War, Economy War, Territory War y Total War. Cada guerra pasa por la preparación, la fase activa, el bloqueo y la resolución. \nDurante una guerra activa, los participantes pueden realizar acciones como asesinatos, asaltos, sabotaje, información, incursiones, escudos, mejoras y reclamos de territorio. Las acciones dirigidas ahora te permiten elegir directamente de una lista de miembros de la Crew oponente en lugar de escribir una identificación de jugador a mano. \nLos puntos de temporada se agregan a la tabla de clasificación de Crew Wars. La Sala de Guerra también muestra clasificaciones, acciones recientes y guerras recientes de tu Crew. \nEn Territory War y Total War, ahora reclamas regiones territoriales reales del sistema de territorios en lugar de objetivos de marcador de posición genéricos. \nEsas regiones de guerra ahora también muestran su valor estratégico en la Sala de Guerra: bonificación de reclamo, puntos de marca y etiquetas como puerto, capital o logística. Esto deja inmediatamente claro qué regiones valen más que un simple intercambio de propiedad. \nCrew Wars ya no elige objetivos territoriales solo según el nivel de valor, sino también según las etiquetas estratégicas y la presión adyacente del territorio atacante o defensor. Eso hace que Territory War y Total War se sientan más como una línea de frente real que como tres reclamos aleatorios. \nAtracos: Banco pequeño (2 jugadores, 40%, 10.000 €-30.000 €, 30 min de tiempo de reutilización), Joyería (3 jugadores, 35%, 20.000 €-50.000 €, 45 min), Atraco al casino (4 jugadores, 25%, 50.000 €-150.000 €, 2 horas), Reserva Federal (5 jugadores, 15%, 100.000-500.000€, 6 h, +20 FBI Heat). \nPara un atraco, todos los miembros deben estar en línea al inicio. Si alguien está ausente, el atraco fracasa. \nAtraco fallido: cárcel para todos, nivel de búsqueda +5, sin recompensa. \nLa recompensa del atraco se divide en partes iguales entre todos los miembros participantes. \nEl chat de la Crew está disponible para una rápida coordinación. \nProgresión del cuartel general de la Crew: cuanto más larga y activa sea la Crew, más mejoras y beneficios compartidos se desbloquearán.';

  @override
  String get helpTopicCrewTips =>
      'Los nuevos equipos pueden depositar dinero y utilizar el almacenamiento compartido de inmediato; después de eso, concéntrese en actualizaciones para obtener más capacidad en lugar de realizar una compra inicial por separado. \nPrimero revisa la Sala de Guerra para ver si tu Crew todavía está en tiempo de reutilización antes de intentar declarar una nueva guerra. \nCoordina las llamadas de objetivos en el chat de la Crew para no seguir cultivando al mismo oponente y hacer tropezar al guardia anti-granja. \nCoordine las horas de inicio del atraco en el chat del equipo para que todos estén en línea y nadie esté en la cárcel. \nElija un equipo en la misma zona horaria o patrón de actividad para obtener mejores tasas de éxito en los atracos. \nUtilice el almacenamiento compartido de la Crew para separar los bienes riesgosos de su inventario personal.';

  @override
  String get helpTopicFriendsCategory => 'Social';

  @override
  String get helpTopicFriendsTitle => 'Amigas';

  @override
  String get helpTopicFriendsSummary =>
      'Administre su lista de amigos para una coordinación, exploración de perfiles y comentarios sociales más rápidos.';

  @override
  String get helpTopicFriendsHow =>
      'La página de amigos muestra tres listas: amigos actuales, solicitudes enviadas y solicitudes recibidas. \nDe un amigo puedes enviarle un mensaje directamente, ver su perfil o iniciar una colaboración. \nPuedes ver cuándo tus amigos están activos en el juego, lo que ayuda a planificar atracos o intercambios. \nLas solicitudes de amistad no caducan automáticamente; Mantenga la lista ordenada para que las solicitudes pendientes no lo distraigan. \nLos amigos ajenos a tu Crew son valiosos para escapar de la cárcel (un amigo puede ayudarte a escapar) y compartir información. \nCuando arrestan a un amigo, los amigos aceptados ahora también reciben una notificación automática de que el jugador está esperando ayuda en prisión.';

  @override
  String get helpTopicFriendsTips =>
      'Añade amigos que compartan tu estilo de juego: compañeros de atracos, redes de comerciantes o apoyo contra el crimen. \nUn amigo que escapa de la cárcel gana entre 500 y 2.000 euros de recompensa si lo logra. Organice esto para emergencias.';

  @override
  String get helpTopicMessagesCategory => 'Social';

  @override
  String get helpTopicMessagesTitle => 'Mensajes';

  @override
  String get helpTopicMessagesSummary =>
      'Tu bandeja de entrada con mensajes personales del jugador y mensajes del sistema sobre recompensas, pedidos y eventos del juego.';

  @override
  String get helpTopicMessagesHow =>
      'Los mensajes se dividen en conversaciones personales y el hilo del sistema The Mob State. \nLos mensajes del sistema se envían automáticamente para: intercambios de criptomonedas, cumplimiento de pedidos, pagos de tablas de clasificación, resultados de atracos, fugas de cárcel e insignias de logros. \nPuedes enviar mensajes a otros jugadores siempre que su configuración de privacidad lo permita. \nLos mensajes no leídos aparecen como una insignia en el ícono de mensaje y son visibles desde el tablero. \nLos mensajes no caducan y se mantienen como un registro histórico de los eventos de la cuenta. \nUtilice el registro de la bandeja de entrada cuando tenga dudas sobre un pago, un pedido perdido o un cambio de saldo inesperado.';

  @override
  String get helpTopicMessagesTips =>
      'Revise su bandeja de entrada después de largos períodos sin conexión: allí se registran las recompensas, los pedidos completados y los eventos. \nConfigure las preferencias de notificación a través de Configuración para que solo reciba alertas automáticas de eventos verdaderamente importantes.';

  @override
  String get helpTopicInventoryCategory => 'Gestión';

  @override
  String get helpTopicInventoryTitle => 'Inventario';

  @override
  String get helpTopicInventorySummary =>
      'Gestiona todo lo que llevas, almacenas y equipas: armas, herramientas, vehículos, drogas y bienes comerciales.';

  @override
  String get helpTopicInventoryHow =>
      'El inventario se abre como una vista de muñeca de papel: tu avatar en el centro, una ranura para armas criminales y una ranura para chaleco, además de ranuras cuadradas para mochila.\nArrastre un elemento (o tóquelo y luego toque un objetivo válido) para moverlo. En los teléfonos, tocar para seleccionar es más confiable que arrastrar.\nSi una pila tiene más de una unidad (munición, materiales, armas o herramientas apiladas), eliges cuántas mover: 1, todas o una cantidad personalizada.\nLa cuadrícula de la derecha es el contexto actual: una casa o almacén en este país, o el depósito de materiales. Abrir almacenamiento en una propiedad salta aquí con ese edificio seleccionado.\nLas casas almacenan armas, municiones, chalecos y dinero en efectivo. Los almacenes almacenan herramientas. Los materiales permanecen en el depósito del campo, no en una casa. El efectivo usa botones, no arrastre.\nSolo puedes usar un chaleco. Colocar un chaleco sobre el avatar lo equipa; almacenarlo en una casa lo desequipa. Se rechaza un segundo chaleco usado.\nLa ranura de armas criminales permanece sincronizada con la pantalla Crímenes. Sólo cuentan las armas transportadas y utilizables.\nLa capacidad de la mochila cubre herramientas, armas y materiales transportados. La munición y el chaleco desgastado no utilizan ranuras para mochila. El servidor rechaza paquetes completos, países incorrectos y tipos de propiedad incorrectos.\nLos equipamientos siguen siendo una segunda pestaña para crímenes guardados o conjuntos de viajes.\nLos medicamentos se almacenan y se muestran en gramos; 351 significa 351 g. El almacenamiento de la Crew sigue siendo un escondite seguro separado.\nAl ser arrestado, la policía puede confiscar artículos. Las drogas en inventario aumentan el riesgo del FBI en viajes internacionales.';

  @override
  String get helpTopicInventoryTips =>
      'Mantenga su carga liviana cuando viaje o participe en una ola de crímenes con alto riesgo de arresto. \nUtilice equipamientos para tener siempre el equipo adecuado equipado para cada escenario. \nVerifique el estado del artículo con regularidad: las herramientas rotas bloquean silenciosamente los delitos sin un mensaje de error claro.';

  @override
  String get helpTopicPropertiesCategory => 'Economía';

  @override
  String get helpTopicPropertiesTitle => 'Propiedades';

  @override
  String get helpTopicPropertiesSummary =>
      'Comprar propiedades para ampliar almacenamiento, capacidad de vivienda y acceso a determinados sistemas como la discoteca.';

  @override
  String get helpTopicPropertiesHow =>
      'Cada inmueble tiene su propio rol: espacio de almacenamiento, capacidad de vivienda o acceso a un módulo posterior como la discoteca.\nLas actualizaciones de almacén aumentan su capacidad de almacenamiento de artículos y otras existencias.\nLas casas almacenan armas, municiones, chalecos y dinero en efectivo; almacenes almacenan herramientas. Abrir almacenamiento en una casa o almacén abre la muñeca de papel del Inventario con ese edificio seleccionado. Debes estar en el mismo país.\nCasas y departamentos aumentan la capacidad habitacional; Los jugadores VIP reciben además espacios adicionales.\nAlgunas propiedades son únicas o están bloqueadas por país: debes estar en el país correcto para comprarlas o administrarlas.\nLa venta rinde el 70% del precio de compra. No hay tiempo de reutilización para vender, es instantáneo.\nUn Nightclub comprado abre la pantalla separada de administración del Nightclub; ese módulo maneja la administración y los ingresos, no la descripción general de las propiedades.\nDesarrollar gasta dinero del banco: cada nivel aumenta permanentemente los ingresos pasivos de esa propiedad (el nivel máximo y el tiempo de reutilización están ajustados por el servidor).';

  @override
  String get helpTopicPropertiesTips =>
      'Invierta en un almacén con anticipación si necesita más espacio de almacenamiento para sus otros sistemas. \nElija casas y apartamentos cuando desee construir más capacidad de vivienda para sistemas de juego relacionados. \nNo venda demasiado rápido: el 70% representa una importante rebaja sobre el precio de compra.';

  @override
  String get helpTopicBankCategory => 'Economía';

  @override
  String get helpTopicBankTitle => 'Banco';

  @override
  String get helpTopicBankSummary =>
      'Deposite dinero en efectivo de forma gratuita hasta un límite diario. El dinero en efectivo de mayor tamaño debe lavarse con una tarifa, demora y riesgo de incautación por parte del FBI.';

  @override
  String get helpTopicBankHow =>
      'Los depósitos gratuitos son instantáneos y no tienen tarifa, pero solo hasta un límite diario que aumenta con su rango (día UTC). Los retiros siguen siendo gratuitos e ilimitados. Utilice Llenar restante para ingresar la cuota sobrante de hoy; cuando se agota el límite, la pantalla muestra la cuenta regresiva hasta las 00:00 UTC.\nEl interés bancario pasivo está actualmente deshabilitado.\nEl dinero en el banco está protegido de confiscaciones policiales. Sólo el efectivo disponible se puede perder en el momento del arresto.\nEl historial de transacciones muestra todos los flujos entrantes y salientes con marca de tiempo, monto, contraparte de la transferencia y descripciones opcionales.\nLavado de dinero: lave efectivo por encima del límite diario gratuito en su banco con una comisión y un retraso. Cada lavado tiene un mínimo y un máximo, mostrados en la pantalla del banco. Mayor presión del FBI aumenta la oportunidad de aprovechar; el éxito reduce ligeramente el calor.\nCrimen de robo a un banco: tiene éxito en un 30% y roba entre un 10 y un 30% del saldo bancario de otro jugador al azar. Riesgo de alto nivel de búsqueda.\nEs posible transferir dinero a otros jugadores. Opcionalmente, puedes agregar una descripción y el destinatario también la verá en las transacciones. Verifique nuevamente tanto el monto como el destinatario antes de confirmar.';

  @override
  String get helpTopicBankTips =>
      'Utilice el depósito diario gratuito para pequeñas cantidades de dinero en efectivo para que esté a salvo de confiscación.\nLave dinero en efectivo en la calle cuando acepte la tarifa y aproveche el riesgo; un calor más bajo es más seguro.\nMantenga un pequeño capital de trabajo como efectivo para gastos directos (fianza, viajes, herramientas).';

  @override
  String get helpTopicCasinoCategory => 'Economía';

  @override
  String get helpTopicCasinoTitle => 'Casino';

  @override
  String get helpTopicCasinoSummary =>
      'Apuesta efectivo en tragamonedas, blackjack, ruleta, dados, baccarat y video póquer. La casa tiene tres plantas (público/VIP/privado) con rake visible y apuesta máxima. Alta varianza.';

  @override
  String get helpTopicCasinoHow =>
      'Juegos: tragamonedas, blackjack, ruleta, dados, baccarat y video póquer.\nCada mesa usa la apuesta máxima de la planta y un rake visible que se queda en el bankroll del dueño.\nPúblico / VIP / Privado suben apuesta máxima y rake. El dueño contrata un crupier, seguridad y promotor. El crupier sube un poco el rake; el promotor sube la apuesta máxima y el calor; la seguridad baja el drenaje de casino_ledger_raid.\nLos sueldos salen del bankroll en cada tick. Si falta dinero, se despide al más barato.\nUn casino_ledger_raid exitoso drena un % del bankroll en el país de inicio. La recompensa de crew se mantiene; es presión extra, no un segundo print.\nSolo efectivo. Las apuestas perdidas desaparecen.';

  @override
  String get helpTopicCasinoTips =>
      'Pon un límite de sesión: nunca más del 10% de tu efectivo.\nEl blackjack tiene las mejores cuotas para un jugador hábil.\nDueños: mantén más de 10.000 € y contrata seguridad antes de las redadas de ledger.\nEl casino es entretenimiento: la ventaja de la casa gana.';

  @override
  String get helpTopicBlackMarketCategory => 'Economía';

  @override
  String get helpTopicBlackMarketTitle => 'Mercado negro';

  @override
  String get helpTopicBlackMarketSummary =>
      'Un centro: primero bienes comerciales de contrabando (flores, productos electrónicos, diamantes, armas, productos farmacéuticos), luego la pestaña Mercado para vehículos de jugador a jugador, herramientas transportadas, lotes de drogas, lotes de criptomonedas, pilas de bienes comerciales y artículos de eventos transferibles, además de mochilas, materiales, mercado de armas y municiones.';

  @override
  String get helpTopicBlackMarketHow =>
      'Pestaña de bienes comerciales: un desplazamiento continuo: primero las cinco líneas de contrabando (precios, límites, fichas de riesgo: deterioro, volatilidad, daños por viaje, incautación), luego su inventario para vender. Comprar/vender utiliza la API /trade; Las fallas de carga parcial muestran un cartel de advertencia. \nEl mercado negro se divide en submercados: Materiales (materias primas), Armas (armas de fuego y cuchillos), Munición (munición por calibre), Vehículos (vehículos ilegales). \nLos precios y la disponibilidad varían mucho según el país y la época. Un anuncio puede agotarse rápidamente. \nLas transacciones del mercado negro no dejan rastro oficial pero aumentan el interés del FBI por compras grandes. \nLas armas compradas aquí se pueden usar en crímenes, PvP y seguridad. Mejores armas dan mayor daño y posibilidades de éxito. \nLos filtros por categoría (tipo, país, precio, disponibilidad) lo ayudan a encontrar rápidamente el listado correcto. \nPuedes publicar tus propios anuncios como vendedor, incluidos el precio y la cantidad. Otros jugadores te compran. \nLos listados caducan después de cierto tiempo si no se venden. Supervise sus propias ofertas a través de su perfil. \nPestaña Mercado: intercambios en efectivo entre jugadores. Una fuente muestra vehículos más listados de jugadores para herramientas transportadas, pilas de drogas (gramos + calidad), tenencias de criptomonedas e inventario de bienes comerciales. Utilice Vender para elegir un tipo, establecer cantidad y precio. Mis listados cubren sus anuncios activos. No puedes comprar tu propio anuncio. El depósito en garantía elimina las existencias hasta su compra o eliminación de la lista.';

  @override
  String get helpTopicBlackMarketTips =>
      'Pestaña Comercio: tire para actualizar si falla un segmento; Mire las fichas de riesgo y se busca antes de correr riesgos de contrabando. \nCompra armas y municiones al por mayor cuando los precios sean bajos: la disponibilidad es temporal. \nEvite grandes compras en el mercado negro cuando el FBI Heat ya esté por encima de 30. \nMercado: actualizar después del listado; Enumere solo lo que posee: las herramientas deben llevarse, las drogas, las criptomonedas y los bienes comerciales provienen de su inventario o existencias. Delist restaura el depósito en garantía.';

  @override
  String get helpTopicDrugsCategory => 'Imperio';

  @override
  String get helpTopicDrugsTitle => 'Drogas';

  @override
  String get helpTopicDrugsSummary =>
      'Construya una operación farmacéutica completa desde la materia prima hasta el producto terminado. Dirija cadenas de producción, administre el almacenamiento y venda con altos márgenes pero con serios riesgos.';

  @override
  String get helpTopicDrugsHow =>
      'El sistema de medicamentos consta de: Centro (descripción general y estadísticas), Instalaciones (mejora de la capacidad de producción), Producción (líneas de producción activas con temporizador) e Inventario (productos terminados y materias primas). \nCompre materias primas a través del mercado negro o del comercio. Combínalos en una instalación para producir drogas. \nLos temporizadores de producción se ejecutan mientras estás desconectado. No es necesario hacer clic activo: vuelva a consultar cuando finalice el cronómetro. \nEl resultado terminado permanece visible en Producción y mantiene ese espacio de instalación ocupado hasta que lo recojas; La recolección automática VIP procesa la salida lista automáticamente en segundo plano. \nLa capacidad de almacenamiento es limitada por instalación. Cuando el almacenamiento está lleno, la producción se detiene automáticamente. \nUna tienda en la web oscura u otra instalación no vende automáticamente la producción terminada: la venta aún se realiza manualmente a través del flujo de venta previsto. \nVenda drogas a través del mercado negro, Colombia u otros lugares de venta especiales para obtener el mayor margen. \nFBI Heat aumenta en cada ciclo de producción y más en las grandes ventas. Las altas temperaturas provocan ataques que pueden cerrar su operación. \nLas actualizaciones de las instalaciones reducen el tiempo de producción, aumentan la producción y amplían la capacidad de almacenamiento. \nLos jugadores VIP obtienen un botón relámpago en las tarjetas de producción: después de un modo de confirmación, pueden comprar todos los materiales del lote que faltan con un solo clic. \nLas actualizaciones avanzadas de espacios y equipos están vinculadas a la nueva modalidad educativa sobre narcóticos (especialista en hidroponía, especialista en electricidad de procesos, químico clandestino). Sin el nivel/certificación requerido no podrá avanzar al siguiente nivel de actualización. \nLas drogas en el inventario aumentan el riesgo de confiscación durante los viajes y los controles policiales.\nDesde Inventario puedes exportar un lote mayorista a otro país: te quedas, pagas el flete y recibes el efectivo B2B de destino al llegar. Si lo incautan, no hay pago. Venta callejera, nightclub, darkweb y Marketplace siguen siendo minorista.';

  @override
  String get helpTopicDrugsTips =>
      'Actualice el almacenamiento antes de la producción: el almacenamiento completo detiene la producción y usted pierde ese tiempo de producción. \nMantenga FBI Heat por debajo de 50: por encima de ese umbral, será perseguido activamente con grandes posibilidades de incursiones que cerrarán todo. \nCombine la venta de drogas con el contrabando para obtener mayores márgenes y riesgo distribuido.\nExporta solo si aceptas flete e incautación; viajar y vender en la calle sigue pagando más por gramo.';

  @override
  String get helpTopicNightclubCategory => 'Imperio';

  @override
  String get helpTopicNightclubTitle => 'Club nocturno';

  @override
  String get helpTopicNightclubSummary =>
      'Dirige un Nightclub como parte de tu imperio criminal. Administre el personal, la seguridad y el suministro para obtener ingresos pasivos y activos con una tabla de clasificación de temporada dedicada.';

  @override
  String get helpTopicNightclubHow =>
      'En la parte inferior, ahora utilizas un Centro de Comando de Gestión de Nightclub con zonas para Crew, Almacenamiento de Drogas, Comando de DJ, Unidad de Seguridad y Laboratorio de Operaciones; Todas las zonas se ejecutan en un flujo de página continuo sin desplazamiento interno adicional. \nLa pantalla del Nightclub ahora incluye una sección central de Inteligencia que combina descripción general, tendencias de ingresos y registros de riesgos sin cambiar de pestaña. \nOps Lab ahora incluye 11 sistemas: DJ residente, calendario de eventos dinámico, árbol de mejoras, respuesta policial/incidente, contratos de proveedores, perfiles de promotores, clientela VIP + características del personal, rutas de contrabando, gestión de bar y cocina (bebidas/comida) con precios, sabotaje rival + contrainteligencia y un cronograma de operaciones. \nLas rutas de contrabando ahora tienen un tiempo de reutilización (Puerto 60 min, Pista de aterrizaje 90 min, Límite 120 min), lo que obliga a planificar el riesgo y el tiempo en lugar de spam infinito. \nEl árbol de actualización es interactivo: elija explícitamente Sound Rig, VIP Lounge o Surveillance y compre el siguiente nivel directamente con costos de actualización visibles. \nLos ingresos se generan por tick en función de la calidad, la ocupación y la disponibilidad de suministros del DJ. La falta de oferta reduce directamente los ingresos. \nLos contratos de DJ finalizan automáticamente a la hora de finalización configurada; después de eso debes reservar nuevamente para obtener nuevos impulsos. \nPueden producirse incidentes (peleas, robos) cuando la seguridad es insuficiente. Esto perjudica la puntuación y los ingresos de los visitantes. \nCada temporada tiene una tabla de clasificación. Los jugadores con los ingresos totales más altos del Nightclub ganan recompensas de temporada. \nSinergia con las drogas: la producción propia de drogas puede servir como suministro, elevando los márgenes. \nEl almacenamiento de medicamentos se basa en gramos: cada selección muestra los gramos disponibles antes de pasar el stock al inventario del Nightclub. \nLas acciones rivales se basan en nombres: buscas clubes rivales por nombre de jugador antes de seleccionar una acción (no se requiere identificación de jugador). \nSinergia con la prostitución: los eventos combinados en lugares generan visitantes adicionales y mayores ingresos. \nLas actualizaciones mejoran la capacidad, el almacenamiento de suministros y la cantidad máxima de DJ y guardias que puedes implementar.';

  @override
  String get helpTopicNightclubTips =>
      'Mantenga siempre el suministro abastecido: un tic sin suministro puede provocar una caída de visitantes de la que sea difícil recuperarse. \nContrata al mejor DJ que puedas pagar: la calidad del DJ tiene el mayor impacto directo en los ingresos por tick. \nConsulta la tabla de clasificación de la temporada diariamente y aumenta la oferta y los DJ si quieres terminar entre los 10 primeros.';

  @override
  String get helpTopicCryptoCategory => 'Economía';

  @override
  String get helpTopicCryptoTitle => 'Cripto';

  @override
  String get helpTopicCryptoSummary =>
      'Opere con 30 criptomonedas reales. Compre y venda directamente o automatice mediante órdenes de límite, stop-loss y take-profit. Los precios ahora siguen los anclajes del mercado en vivo con regímenes y noticias adicionales en el juego, y la ventana emergente de monedas utiliza campos separados para operaciones directas y órdenes abiertas.';

  @override
  String get helpTopicCryptoHow =>
      'La lista de criptomonedas muestra 30 monedas con el precio actual, el porcentaje de 24 horas y su tenencia actual por moneda. La base de precios sigue los datos del mercado en vivo, pero aún está influenciada por los regímenes y las noticias del juego. \nHaga clic en una moneda para abrir la ventana emergente con: gráfico en vivo (filtros de tiempo 1h, 4h, 8h, 24h, 7d, 30d, Todos), historial de compras, precio promedio de compra y forma de compra/venta. \nComercio directo: ingrese la cantidad y haga clic en Comprar o Vender. Al vender, puede presionar \"TODO\" para cubrir instantáneamente su puesto completo. La ejecución es inmediata al precio actual de mercado. \nÓrdenes abiertas: Límite (compra/venta a un precio objetivo exacto), Stop-loss (venta automática cuando el precio cae hasta un umbral), Take-profit (venta automática cuando el precio sube hasta un umbral). Esta sección ahora tiene su propio campo de cantidad y su propio campo de precio objetivo. \nEl backend ejecuta automáticamente las órdenes abiertas tan pronto como el precio de mercado alcanza el objetivo. No es necesario estar en línea. \nLos regímenes de mercado (alcista/bajista/lateral) y las noticias influyen en los movimientos de precios. Recibe notificaciones de régimen mediante push cuando está habilitado. \nTabla de clasificación criptográfica semanal: el jugador con la mayor ganancia obtenida esa semana gana una recompensa en efectivo. \nLas misiones diarias y semanales (por ejemplo, 3 operaciones rentables, diversificar en 5 monedas) otorgan recompensas adicionales al completarlas. \nLa descripción general de la cartera muestra: valor total, monto invertido, ganancias/pérdidas no realizadas y realizadas.';

  @override
  String get helpTopicCryptoTips =>
      'Verifique su historial de compras antes de realizar una orden de venta: la ventana emergente muestra su precio de compra promedio para que no venda accidentalmente con pérdidas. \nUtilice órdenes de stop-loss en cada posición que no esté observando activamente: le protegen automáticamente cuando no está conectado. \nCambie los filtros de tiempo en el gráfico: 1 h y 4 h muestran la tendencia a corto plazo, 7 días y 30 días muestran el panorama más amplio.';

  @override
  String get helpTopicSmugglingCategory => 'Imperio';

  @override
  String get helpTopicSmugglingTitle => 'Contrabando';

  @override
  String get helpTopicSmugglingSummary =>
      'Mueva mercancías y vehículos ilegales entre países. Elija un canal comercial o utilice su propio vehículo o avión para reducir los costos y aumentar el riesgo de confiscación.';

  @override
  String get helpTopicSmugglingHow =>
      'Elige una categoría, el artículo concreto, el destino y luego decide entre un canal comercial o tu propio transporte. \nLos automóviles, motocicletas, barcos y aviones de propiedad ahora muestran una cotización en vivo con espacios de carga, menores costos y reducción de riesgos. \nUn barco puede transportar coches y motos; un avión no puede transportar un barco y devolverá un error inmediato. \nLas posibilidades de éxito dependen del canal seleccionado o del transporte propio, su nivel de búsqueda actual y el tamaño del envío. \nEn caso de falla, perderá todo el envío. Sin reembolso. Los costos de carga y transporte han desaparecido. \nCuando utiliza transporte propio y el recorrido falla, el propio medio de transporte también puede ser confiscado. \nLos envíos activos se rastrean en vivo en una descripción general. Después de su llegada, la carga aparece en un depósito lista para su recogida. \nLa red de Crew sigue estando disponible para envíos comerciales de Crew, pero el transporte propio es únicamente personal.';

  @override
  String get helpTopicSmugglingTips =>
      'Nunca envíe todo su stock en un solo envío: divídalo en varias cargas más pequeñas para limitar pérdidas catastróficas. \nReduzca el nivel de búsqueda y el calor del FBI al mínimo antes de iniciar una gran carrera de contrabando. \nUtilice su mejor avión o barco para recorridos costosos: un menor costo ayuda, pero los espacios de carga y la posibilidad de confiscación aún deciden el riesgo. \nRecoja siempre los depósitos activos lo más rápido posible: el contenido caducado del depósito se pierde permanentemente.';

  @override
  String get helpTopicToolsCategory => 'Gestión';

  @override
  String get helpTopicToolsTitle => 'Herramientas';

  @override
  String get helpTopicToolsSummary =>
      'Compre y administre herramientas necesarias para delitos específicos. Las buenas herramientas aumentan las posibilidades de éxito, las desgastadas las reducen.';

  @override
  String get helpTopicToolsHow =>
      'La tienda de herramientas muestra todos los artículos disponibles con precio, clasificación de condición y el tipo de delito para el que se necesitan. \nCada categoría de delito tiene herramientas preferidas: el robo requiere palanca o picos, el robo de automóviles requiere un kit de conexión directa, el robo requiere un arma de fuego. \nLas herramientas tienen una clasificación de condición (0-100%). Cada delito exitoso o fallido reduce la condición en un pequeño porcentaje. \nPor debajo de la condición del 20%, la bonificación de probabilidad de éxito de la herramienta cae drásticamente. Por debajo del 5% la herramienta casi no tiene efecto. \nLas herramientas reparadas en el taller cuestan una fracción del precio de compra. A veces, el reemplazo es más económico que la reparación de herramientas muy desgastadas. \nLas herramientas están visibles en la pestaña de su inventario. Puede conservar varias copias del mismo tipo como copia de seguridad.';

  @override
  String get helpTopicToolsTips =>
      'Compra herramientas al por mayor cuando son baratas en el mercado negro: ahorras en comparación con la tienda. \nEstablezca un umbral personal: reemplace siempre las herramientas cuando el estado caiga por debajo del 25% para mantener estables las posibilidades de éxito.';

  @override
  String get helpTopicCourtCategory => 'Riesgo';

  @override
  String get helpTopicCourtTitle => 'Corte';

  @override
  String get helpTopicCourtSummary =>
      'Durante tu sentencia puedes presentar una apelación o intentar sobornar al juez para que te liberen antes.';

  @override
  String get helpTopicCourtHow =>
      'Cuando está encarcelado, la pantalla del tribunal muestra su condena activa con el tiempo restante, el delito y el perfil del juez. \nUna apelación cuesta dinero según la duración actual de su sentencia. Si se concede, su sentencia generalmente se reduce entre un 20% y un 40%. \nPuede apelar solo una vez por condena y se aplica un tiempo de reutilización a los reintentos rápidos. \nEl soborno utiliza una cantidad seleccionada por el jugador. Esa cantidad siempre se descuenta, incluso cuando el intento fracasa. \nUna cantidad mayor de soborno aumenta las posibilidades de éxito. Si tiene éxito, será liberado inmediatamente. \nSus antecedentes penales mantienen condenas anteriores con fechas y detalles del historial judicial incluso cuando ya no esté encarcelado. \nUn soborno a un juez exitoso elimina sólo esa condena actual de sus antecedentes penales. \nSi desea borrar todos sus antecedentes penales, debe hacerlo fuera del tribunal mediante el delito de eliminación de antecedentes penales del último juego.';

  @override
  String get helpTopicCourtTips =>
      'Utilice primero las apelaciones para sentencias largas: el tiempo esperado ahorrado es mayor allí. \nUtilice el soborno sólo con suficiente reserva de efectivo, porque el pago siempre se deduce.';

  @override
  String get helpTopicHitlistCategory => 'Riesgo';

  @override
  String get helpTopicHitlistTitle => 'Lista de resultados';

  @override
  String get helpTopicHitlistSummary =>
      'Ofrece una recompensa por un enemigo o acepta un contrato de ataque. Elimina tu objetivo en el mismo país para obtener el pago completo.';

  @override
  String get helpTopicHitlistHow =>
      'A través de la lista de resultados, agregas un jugador estableciendo una recompensa. La recompensa mínima es de 5.000 €. El pagador pierde este dinero inmediatamente. \nSi se le otorga una recompensa, recibirá inmediatamente una notificación automática y un mensaje en la bandeja de entrada de Hitlist Bureau. \nLos golpes activos son visibles para todos los jugadores. Cuanto mayor es la recompensa, más atención atrae el contrato. \nLas investigaciones de detectives ya no proporcionan información instantánea: los informes llegan más tarde a través de un mensaje de Detective Bureau (Rápido 1 hora 1.000.000 €, Estándar 6 horas 500.000 €, Lento 24 horas 250.000 €). Los guardaespaldas objetivo pueden nublar o bloquear ese informe: Quick es fácil de detener. La lentitud siempre gotea al país, incluso contra un equipo de élite. Después de 48 horas sin conexión la cubierta se debilita; después de 7 días el informe está completo. Después de un asesinato, los guardaespaldas del asesino también reducen la posibilidad de que un detective del caso de asesinato los identifique, hasta que permanecen desconectados por mucho tiempo. \nSi lo matan a través de la lista de objetivos, recibirá un mensaje de Hitlist Bureau con un botón para iniciar una investigación del asesino dentro de las 24 horas. \nSi solicita esta investigación rápidamente después del asesinato, el informe detective llegará más rápido. Esperar más significa una demora mayor en el informe. \nPara ejecutar un golpe debes estar en el mismo país que tu objetivo. Atacas a través del perfil del jugador. \nEl combate se calcula automáticamente en función de: armas, armaduras, estadísticas (fuerza, reflejos), bonificaciones de Crew y nivel activo. \nSi lo eliminas con éxito, recibirás la recompensa completa, pero aún puedes perder HP, guardaespaldas y estado del chaleco. Si el ataque falla, el contrato permanece abierto: ambos bandos pierden guardaespaldas y HP, y puedes volver a intentarlo después de 10 minutos. \nTras un impacto exitoso, el objetivo recibe un reinicio completo del progreso de la cuenta: los activos y el progreso se restablecen al estado inicial, mientras que el saldo bancario y el liderazgo de la Crew se conservan. Recibes una parte del botín disponible además de la recompensa. \nDespués de una muerte exitosa, recibirás inmediatamente un mensaje en la bandeja de entrada de Hitlist Bureau con un desglose de la recompensa y el botín (efectivo + artículos). \nLos objetivos con un guardaespaldas activo o protección de seguridad son más difíciles de alcanzar. \nPuede eliminar su propio nombre de la lista de resultados pagando al colocador o comprando la recompensa usted mismo.';

  @override
  String get helpTopicHitlistTips =>
      'Consulta la lista de resultados a diario: las altas recompensas por jugadores débiles generan ganancias rápidas si estás en el mismo país. \nSolo otorga una recompensa a un jugador cuando tengas motivos para creer que está desconectado o con pocos HP. \nOmita la información rápida barata si el objetivo tiene guardaespaldas de élite y ha estado jugando recientemente; Un informe lento siempre muestra el país. Un tanque máximo rara vez cae de un solo disparo: un golpe fallido aún corta a los guardias y HP en ambos lados, y puedes volver a intentarlo después de 10 minutos.';

  @override
  String get helpTopicSecurityCategory => 'Riesgo';

  @override
  String get helpTopicSecurityTitle => 'Seguridad';

  @override
  String get helpTopicSecuritySummary =>
      'Protege tu personaje y tu imperio con armaduras, guardaespaldas y seguridad de instalación. Una mayor seguridad significa menos daños sufridos durante los ataques.';

  @override
  String get helpTopicSecurityHow =>
      'Comprar chalecos en el Mercado Negro → Seguridad: Chaleco antipuñaladas (7.500 €) → Chaleco antibalas (50.000 €) → Chaleco antibalas premium (125.000 €) → Chaleco con placas AP (280.000 €). Los calibres de rifle 5.56, 7.62 y .308 perforan chalecos normales a menos que use el chaleco con placa AP. \nSólo puedes usar 1 chaleco a la vez. Un chaleco dañado se puede reparar por la mitad del valor en mal estado. La compra de otro chaleco reemplaza el actual y acredita el 40% del precio del chaleco anterior, escalado por condición. \nCada tipo de chaleco reduce el daño recibido cuando coincide con el ataque: los chalecos antipuñaladas detienen los cuchillos, los chalecos antibalas detienen las balas normales y el chaleco con placas AP también detiene las balas perforantes. Un desajuste mantiene sólo una fracción de la defensa del chaleco. \nLa armadura se daña después de un ataque y pierde efectividad. Cuanto menor sea la condición, menos protección proporcionará tu armadura actual. \nEn una condición del 0%, tu armadura se destruye y desaparece por completo; necesitas comprar un juego nuevo para recuperar la protección. \nLos guardaespaldas tienen un límite de 10 en total en tres calidades: músculo callejero (+8 defensa, 6.000 € de alquiler, 4.000 €/día), estándar (+10, 10.000 € de alquiler, 10.000 €/día) y élite (+22, 35.000 € de alquiler, 18.000 €/día). Puedes descartarlos en cualquier momento. \nSi no puedes pagar el salario diario combinado, todos los guardaespaldas se marchan y pierdes su protección inmediatamente. \nLos chalecos y los guardaespaldas también reducen la pérdida de HP del crimen (cada intento, hasta aproximadamente la mitad). Un intento fallido de asesinato deja sin guardaespaldas y tu HP, y usa tu chaleco; el contrato permanece abierto. En los informes de detectives, los guardaespaldas pueden ocultar la ubicación y la fuerza mientras juegas recientemente; El país siempre se filtra lentamente, y después de una semana fuera de línea, la portada cae. No reemplazan la seguridad de discotecas, semáforos o territorios. \nLa seguridad de la instalación (para discotecas, instalaciones de drogas, etc.) reduce las posibilidades de redadas e incidentes en esa ubicación específica. \nCuanto mayor sea tu nivel de búsqueda, más a menudo serás atacado o asaltado. Una mayor seguridad compensa esto directamente. \nLos miembros de la Crew pueden dividir los roles de seguridad para cubrir múltiples ubicaciones simultáneamente.';

  @override
  String get helpTopicSecurityTips =>
      'Utilice siempre al menos un chaleco antipuñaladas cuando el nivel de búsqueda sea 2 o superior: los ahorros en las facturas del hospital compensan rápidamente el precio de compra. \nReparar un chaleco dañado en lugar de volver a comprar el mismo; Verifique el estado después de cada ataque. \nLa munición de rifle (5.56, 7.62, .308) atraviesa chalecos normales; compre el chaleco con placa AP si esos calibres aparecen en su contra. \nMantén sólo tantos guardaespaldas como puedas permitirte mañana; Los guardias de élite son los más afectados, pero su salario diario aumenta rápidamente. \nLos guardaespaldas no ocultan tu país si permaneces desconectado durante una semana; De todos modos, el país gotea lentamente.';

  @override
  String get helpTopicHospitalCategory => 'Recuperación';

  @override
  String get helpTopicHospitalTitle => 'Hospital';

  @override
  String get helpTopicHospitalSummary =>
      'El hospital es el reset rápido cuando crímenes o hits bajan tu HP. Si sigues herido cae el éxito; a 0 HP pierdes 3 horas en la UCI.';

  @override
  String get helpTopicHospitalHow =>
      'Cada intento de crimen cuesta unos 5–15 HP (chaleco y guardaespaldas pueden recortar hasta ~55%). Los hits también quitan HP.\nDesde 70 HP estás en forma. Por debajo baja el éxito: −4% bajo 70, −8% bajo 40, −12% bajo 20. Las chances de la carta ya lo incluyen.\nEl tratamiento estándar cuesta 10.000 € y recupera hasta +30 HP. El intensivo cuesta 20.000 € y hasta +75 HP. Ambos comparten 60 minutos de espera (VIP 10% menos).\nLa ayuda de emergencia es un botón que pulsas tú, solo bajo 10 HP: +20 HP gratis, sin espera.\nA 0 HP vas 3 horas a la UCI: sin crímenes ni trabajos. Vuelves con 10 HP.\nEsperar cura +5 HP por tick si sigues vivo. Es gratis pero lento, y la penalización dura hasta 70+.\nNo hay urgencias automáticas, ni descuento escolar de Medicina, ni médico de crew fuera de esta pantalla.';

  @override
  String get helpTopicHospitalTips =>
      'Cúrate antes de una racha de crímenes si estás bajo 70 HP: la penalización ya está en el % de cada carta.\nUsa la emergencia solo como último paro antes de la UCI; el tratamiento de pago quita rápido la penalización.\nChaleco y guardaespaldas reducen la pérdida de HP, así que vas menos al hospital.';

  @override
  String get helpTopicPrisonCategory => 'Recuperación';

  @override
  String get helpTopicPrisonTitle => 'Prisión';

  @override
  String get helpTopicPrisonSummary =>
      'Cumpla su sentencia de prisión, pague la fianza o intente escapar. Cuanto mayor sea su nivel de búsqueda, más larga y costosa será su sentencia.';

  @override
  String get helpTopicPrisonHow =>
      'Después del arresto, se inicia un cronómetro basado en el nivel de búsqueda. Nivel de búsqueda 1 = sentencia corta (minutos), Nivel de búsqueda 5+ = horas de prisión. \nLa fianza aumenta con la sentencia restante y nunca cae por debajo del nivel de búsqueda × 1000 €. Por lo tanto, las sentencias más largas cuestan más si se compran inmediatamente. \nEscape: obtienes como máximo 2 intentos de escape por frase, con 15 minutos entre ellos. Las posibilidades de éxito son bajas. El fallo añade 15 minutos. Después de eso: paga la fianza, espera o deja que tus amigos/Crew te saquen. \nEn la lista de prisiones y en la superposición de cárcel, siempre puedes pagar tu propia fianza y también intentar escapar mientras estás encarcelado. \nLos miembros de la Crew pueden visitarte y brindarte pequeños beneficios (estadísticas, moral) mientras estás encerrado. \nAl ser arrestado, tus amigos y miembros de la Crew ahora reciben una notificación automática de que fuiste capturado y estás esperando ayuda. \nLas armas y armaduras se confiscan al momento del arresto si no se tiene protección legal para ellas. \nOpción judicial: acudir al tribunal para obtener una reducción de la pena a través de un abogado (ver Tribunal). \nMientras los temporizadores de producción bloqueados (drogas, fábrica de municiones) siguen funcionando. Tu imperio funciona sin ti. \nNo puedes visitar el hospital mientras estés encerrado. La recuperación de HP espera hasta que esté libre.';

  @override
  String get helpTopicPrisonTips =>
      'Verifique la fianza inmediatamente después del arresto: el botón debe permanecer visible mientras esté encarcelado, incluso si su nivel de búsqueda ya ha bajado. \nInicie los cronómetros de producción justo antes de cometer un crimen de alto riesgo: si lo atrapan, la producción continúa ejecutándose de todos modos.';

  @override
  String get helpTopicVaultCategory => 'Eventos';

  @override
  String get helpTopicVaultTitle => 'Romper la bóveda';

  @override
  String get helpTopicVaultSummary =>
      'Temporada de bóveda mensual: ingrese un código de 4 dígitos y apueste créditos para tener la oportunidad de ganar grandes premios.';

  @override
  String get helpTopicVaultHow =>
      'Cada mes una nueva temporada comienza el día 1 y finaliza el último día del mes. \nElija una apuesta (por ejemplo, 1/3/5 créditos) e ingrese un código de 4 dígitos. \nTambién puede ingresar el código usando el teclado en pantalla (botones de dígitos). \nCada intento cuesta créditos. Si adivinas correctamente, ganas un premio. \nLas apuestas más altas significan premios mayores; a veces puede caer una recompensa VIP. \nSi ya eres VIP, una recompensa VIP se convierte en créditos. \nPuedes ver tus códigos incorrectos para este mes. La lista se reinicia automáticamente con el nuevo mes.';

  @override
  String get helpTopicVaultTips =>
      'Elija una apuesta que coincida con su saldo de crédito: puede intentarlo un número ilimitado de veces, pero cada intento cuesta créditos. \nUtilice la lista de códigos incorrectos para evitar volver a intentar el mismo código.';

  @override
  String get helpTopicGarageCategory => 'Activos';

  @override
  String get helpTopicGarageTitle => 'Cochera';

  @override
  String get helpTopicGarageSummary =>
      'Robar y gestionar coches y motos para delitos y contrabando. Garage se encarga de la propiedad, las reparaciones programadas, la venta y el desguace; el transporte pasa por Smuggling Hub.';

  @override
  String get helpTopicGarageHow =>
      'Su garaje muestra automóviles y motocicletas con estado (0-100%), combustible, valor de mercado, rareza y estado de capitalización mundial. \nEl almacenamiento de automóviles y el almacenamiento de motocicletas ahora están separados: los automóviles utilizan la capacidad de garaje y las motocicletas utilizan la capacidad de almacenamiento de motocicletas. \nLas mejoras en el almacenamiento de automóviles y motocicletas son independientes según el país: mejorar los automóviles no aumenta la capacidad de las motocicletas (y viceversa). Las actualizaciones están reguladas por rango; cuando tu rango es demasiado bajo, verás un candado/información sobre herramientas. En el nivel 5, el botón de actualización está oculto. \nUsando el botón de catálogo puedes ver todos los autos y motocicletas robables, incluido el país más común y la lista completa de países de generación. \nEl robo es por vehículo con requisitos de rango y tiempos de reutilización. Cuanto más caro y raro, menores serán sus posibilidades de éxito. \nSi el límite mundial de un modelo está lleno, no puedes robar ese modelo temporalmente. Cuando una copia se vende o se desecha, se vuelve a abrir 1 espacio inmediatamente. \nEl robo fallido aumenta el nivel de búsqueda y puede provocar un arresto. Si la policía lo atrapa durante la fuga, irá a la cárcel y el vehículo recién robado será confiscado inmediatamente. \nLas reparaciones están programadas: usted paga por adelantado, el vehículo entra en reparación y solo regresa después de que finaliza el cronómetro. \nLas reparaciones simultáneas están limitadas en automóviles, motocicletas y embarcaciones juntas: sin VIP max 1 activo, con VIP max 2 activo. \nEl desguace es una alternativa a la venta: recibe un valor residual (35 % del valor base), escalado según el estado y una bonificación por mejora del garaje. \nVehicle Ops Intelligence agrega 6 opciones adicionales. En resumen: \n1) Ejecución del punto de acceso: una acción rápida para obtener dinero directo, con su propio tiempo de reutilización y riesgo adicional. \n2) Mercado de repuestos: precios de repuestos activos por tipo (coche/moto/barco) para tuning; Los precios se actualizan periódicamente. \n3) Operación de Crew: una acción cooperativa con tu Crew para obtener ganancias/ventajas adicionales (solo si estás en una Crew). \n4) Calor: por tipo (coche/moto/barco) un contador de “atención”; Un calor más alto hace que las acciones sean más riesgosas y reduce las posibilidades de éxito. El calor decae lentamente. \n5) Contrato de corte: entregue un vehículo elegible de su inventario para obtener un pago de contrato fijo. \n6) Patrón policial: los patrones horarios pueden aumentar los controles; esto afecta el riesgo (por ejemplo, huelga portuaria/bloqueo de embarcaciones). \nEn Vehicle Heist, Auto/Motocicleta/Barco ahora usa una capa de comando: seleccione la categoría a través de las tres tarjetas de carril en la parte superior, sin una segunda fila de pestañas adicional. \nCada tarjeta de carril incluye acciones rápidas directas para robar y mejorar el almacenamiento, por lo que no es necesario desplazarse primero a los subbotones separados. \nMientras se ejecuta un tiempo de reutilización de robo, aparece un ícono de relámpago al lado del temporizador: tócalo para gastar créditos y borrar el tiempo de reutilización. Puede desactivar el cuadro de diálogo de confirmación; Vuelva a activarlo en Configuración en tiempo de reutilización por robo (créditos). \nLas tarjetas de carril ahora también muestran la capacidad por tipo directamente (usado/total + nivel de mejora). \nLos vehículos robados ahora se muestran como tarjetas responsivas: el móvil muestra una por fila, la tableta/escritorio muestra varias tarjetas una al lado de la otra. \nNueva capa de operaciones: ventanas de interceptación PvP para puntos de acceso, bonificaciones por rol de Crew en operaciones de Crew, desbloqueo de reputación por tipo de vehículo, eventos de lista negra regional y contratos de seguro de contrabando. \nNuevas expansiones de operaciones de vehículos: misiones de contraintercepción, emparejamiento de tripulaciones con escala estacional, modificadores de país (inflación/corrupción/huelga portuaria) y un tablero de contratos con contratos legendarios semanales. \nOperaciones ahora muestra tiempos de reutilización en vivo por acción. Los temporizadores cuentan visiblemente y se actualizan automáticamente. \nLas acciones de la Crew (Crew Op y Crew Match) solo están disponibles cuando estás en una Crew; sin Crew, obtienes una pista de desbloqueo clara. \nLas acciones de operaciones exitosas pagan en efectivo directamente a su billetera. La descripción general de la acción muestra el tipo de pago esperado por botón. \nLas reclamaciones de seguros ahora entran primero en revisión; El uso de disputas de reclamos le permite disputar un pago adicional con riesgo de rechazo. \nEl calor de categoría superior reduce las posibilidades de éxito del robo y aumenta el riesgo de puntos críticos. El calor decae gradualmente cada hora. \nLos contratos Chop-Shop requieren un vehículo elegible de su inventario; el reclamo consume ese vehículo y paga el contrato en efectivo. \nEl transporte de vehículos ya no se realiza en el garaje; Utilice el flujo del Centro de Contrabando. \nReventa y desguace gratuito de capacidad ya sea de coche o de moto y podrá reabrir plazas de tope mundial para ese modelo. \nLos vehículos exclusivos para eventos, como los interceptores de la policía, permanecen cerrados fuera de las ventanas del evento.';

  @override
  String get helpTopicGarageTips =>
      'Roba vehículos activamente cuando el nivel de búsqueda es bajo: mayor búsqueda = mayor probabilidad de falla al robar. \nMantenga siempre al menos un vehículo confiable en buenas condiciones para el contrabando: un vehículo averiado reduce a la mitad sus posibilidades de éxito. \nUtilice el desguace de vehículos muy dañados como un rápido restablecimiento de la capacidad; La venta suele ser mejor en buenas condiciones.';

  @override
  String get helpTopicMarinaCategory => 'Activos';

  @override
  String get helpTopicMarinaTitle => 'Puerto pequeño';

  @override
  String get helpTopicMarinaSummary =>
      'Gestiona barcos con rarezas, límites mundiales y temporizadores de reparación para rutas marítimas de contrabando. Marina se centra en la propiedad, el mantenimiento, la venta y el desguace; el transporte pasa por Smuggling Hub.';

  @override
  String get helpTopicMarinaHow =>
      'La marina muestra sus barcos con condición, combustible, valor de mercado, rareza y estatus de capitalización mundial por modelo. \nUsando el botón de catálogo puedes ver todos los barcos robables, incluido el país más común y la lista completa de países de generación. \nEl robo de barcos tiene sus propias puertas de rango y tiempos de reutilización. Los barcos más caros son más difíciles de robar, pero pueden resultar más rentables. \nSi un modelo de barco con límite mundial está lleno, desaparece temporalmente de la lista disponible. Vender/desguazar vuelve a abrir espacios. \nLas reparaciones están programadas: usted paga por adelantado y el barco no estará disponible hasta que se complete el cronómetro. \nLas reparaciones simultáneas están limitadas en automóviles, motocicletas y embarcaciones juntas: sin VIP max 1 activo, con VIP max 2 activo. \nEl desguace otorga valor de rescate (35% del valor base), escalado con condición y bonificación de mejora del puerto deportivo. \nMarina gestiona la propiedad y el mantenimiento únicamente; La ruta de transporte real ocurre en Smuggling Hub. \nLos barcos policiales exclusivos para eventos son para eventos temporales y permanecen cerrados fuera de las ventanas del evento.';

  @override
  String get helpTopicMarinaTips =>
      'Invierta en el puerto deportivo si sus rutas de contrabando pasan regularmente por el agua: un menor interés policial puede aumentar significativamente las posibilidades de éxito. \nMantenga una lancha rápida en buenas condiciones como alternativa rápida cuando las rutas de escape terrestres estén bloqueadas. \nDeseche los barcos muy dañados con bajo valor de reventa para liberar más rápido el espacio de capital mundial y la capacidad del puerto deportivo.';

  @override
  String get helpTopicTuneshopCategory => 'Activos';

  @override
  String get helpTopicTuneshopTitle => 'Tienda de melodías';

  @override
  String get helpTopicTuneshopSummary =>
      'Utilice piezas recuperadas para mejorar vehículos por categoría. Mejore la velocidad, el sigilo y la armadura con costos de niveles progresivos y tiempos de reutilización de categorías.';

  @override
  String get helpTopicTuneshopHow =>
      'Obtienes piezas desguazando vehículos: piezas de automóviles, piezas de motocicletas y piezas de barcos. \nLas piezas se agrupan por categorías: cualquier vehículo de la misma categoría utiliza el mismo stock de piezas. \nCada actualización cuesta piezas y dinero. Los costos monetarios se basan en categorías y aumentan según el nivel de ajuste. \nPuedes mejorar tres estadísticas: velocidad, sigilo y armadura. \nEl ajuste es por vehículo en su inventario. Los vehículos nuevos comienzan nuevamente en el nivel 0. \nDespués de cada melodía hay un tiempo de reutilización por vehículo: coche 180, motocicleta 120 y barco 240. \nEl ajuste simultáneo es limitado: sin VIP, máximo 1 vehículo activo en tiempo de reutilización de ajuste, con VIP máximo 5. \nLos vehículos tuneados generan un mayor valor de venta y de rescate. \nLa sintonización se bloquea mientras un vehículo está en reparación o transporte.';

  @override
  String get helpTopicTuneshopTips =>
      'Primero deseche los vehículos muy dañados para construir piezas rápidamente. \nInvierta en sigilo desde el principio para reducir el riesgo de captura en corridas de alto riesgo. \nUtilice mejoras de armadura en vehículos que despliega repetidamente en bucles peligrosos.';

  @override
  String get helpTopicShootingRangeCategory => 'Capacitación';

  @override
  String get helpTopicShootingRangeTitle => 'Campo de tiro';

  @override
  String get helpTopicShootingRangeSummary =>
      'Mejore su precisión y habilidad con las armas mediante ejercicios de tiro estructurados. Las estadísticas más altas aumentan el daño y la probabilidad de acertar en PvP y crímenes.';

  @override
  String get helpTopicShootingRangeHow =>
      'El campo de tiro ofrece múltiples disciplinas: pistola, rifle, escopeta y fuego automático. Cada uno entrena una habilidad de arma separada. \nCada sesión de entrenamiento tiene un tiempo de reutilización de 30 minutos. No puedes entrenar sin cesar por día. \nUna mayor precisión aumenta tus posibilidades de acertar en las peleas PvP y reduce las posibilidades de que te golpeen a ti mismo. \nLa habilidad con las armas también determina qué armas puedes usar de manera efectiva: un rifle de francotirador requiere cierta habilidad antes de obtener su bonificación completa. \nLos resultados del entrenamiento se acumulan de forma acumulativa. No hay reinicio a menos que reciba una fuerte penalización a través de la cancha. \nCertificado escolar de Entrenamiento Militar otorga una bonificación permanente a cada sesión de campo de tiro.';

  @override
  String get helpTopicShootingRangeTips =>
      'Entrena el campo de tiro todos los días: pequeñas bonificaciones acumulativas se notan en los resultados de PvP en una semana. \nEntrena el tipo de arma que más utilizas en crímenes y PvP para obtener el máximo retorno de la inversión.';

  @override
  String get helpTopicGymCategory => 'Capacitación';

  @override
  String get helpTopicGymTitle => 'Gimnasia';

  @override
  String get helpTopicGymSummary =>
      'Entrena fuerza, velocidad y resistencia para obtener mejores estadísticas en PvP, crímenes y reserva de HP. El entrenamiento diario es clave para un rápido crecimiento de las estadísticas.';

  @override
  String get helpTopicGymHow =>
      'El gimnasio ofrece tres categorías de entrenamiento: Fuerza (más daño por ataque), Velocidad (mayores reflejos, menos golpes recibidos), Resistencia (mayor HP máximo). \nCada entrenamiento tiene un tiempo de reutilización de 1 hora. Máximo 6-8 sesiones por día dependiendo de tu certificado escolar. \nLa fuerza aumenta el daño directo tanto en PvP como en ciertos tipos de delitos (robo, pelea). \nLa velocidad aumenta las posibilidades de esquivar un ataque y reduce las posibilidades de quedar atrapado en un crimen. \nLa resistencia aumenta tu reserva máxima de HP. Más HP = sobrevivir más tiempo en PvP y más espacio para crímenes arriesgados. \nCertificado escolar de Entrenamiento Físico otorga +15% de bonificación a todas las sesiones de gimnasio.';

  @override
  String get helpTopicGymTips =>
      'Prioriza el entrenamiento de resistencia: una reserva de HP más alta mejora todos tus demás sistemas porque permaneces activo por más tiempo. \nCombina gimnasio con campo de tiro: Fuerza + Precisión es la combinación PvP más fuerte.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Imperio';

  @override
  String get helpTopicAmmoFactoryTitle => 'Fábrica de municiones';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produzca municiones para uso personal y administre su producción desde la fábrica. La compra y venta de munición se realiza a través del Mercado Negro, no directamente desde la pantalla de fábrica.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'La fábrica de munición tiene niveles de producción (Nivel 1 al 5). Nivel más alto = más rondas por reclamo y mejor calidad. \nDurante una sesión activa, usted reclama producción aproximadamente cada 20 minutos (hasta 8 horas de trabajo pendiente dentro de esa sesión). \nLa producción sigue acumulándose mientras estás fuera de línea: cuando regreses, puedes reclamar varias veces hasta que se ponga al día el trabajo pendiente. \nEl simple hecho de ver la fábrica de municiones o viajar de ida y vuelta no debe cambiar de propietario; una fábrica no debería cambiar a \"en venta\" sólo porque se abrió la pantalla. \nLa munición producida se usa personalmente en crímenes y PvP. Para comprar y vender munición, pasa por el Mercado Negro; La pantalla de fábrica en sí no vende balas directamente. \nLas mejoras de producción aumentan las rondas por reclamo; las mejoras de calidad mejoran el valor de mercado. \nEl precio del mercado de municiones fluctúa con la demanda. Abastecerse cuando los precios sean bajos y vender cuando los precios sean altos. \nDurante un asalto a una fábrica, se pierde parte de la producción almacenada. La seguridad reduce este riesgo.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Actualice su fábrica al nivel 3 lo antes posible: la producción duplicada en comparación con el nivel 1 la hace autosuficiente en munición. \nMantenga siempre 2 o 3 rondas de producción en reserva como reserva para que nunca se quede sin munición durante PvP.';

  @override
  String get helpTopicSchoolCategory => 'Capacitación';

  @override
  String get helpTopicSchoolTitle => 'Escuela';

  @override
  String get helpTopicSchoolSummary =>
      'Siga cursos en múltiples pistas para desbloquear bonificaciones, reducir costos y abrir nuevos sistemas. La escuela es un multiplicador de todo lo que haces.';

  @override
  String get helpTopicSchoolHow =>
      'La escuela ofrece pistas por dominio: Penal (mejores estadísticas de delitos), Economía (menores costos comerciales y bancarios), Militar (bonificaciones de combate), Medicina (menores costos hospitalarios), Derecho (menores costos de abogados), Técnico (mejores fábricas y producción de medicamentos). \nCada lección tiene un tiempo de estudio de 15 a 60 minutos según el nivel. Los niveles más altos tardan más. \nDespués de completar una lección, recibirá un certificado para ese nivel de pista. Este certificado es permanente y otorga el bono de forma inmediata. \nSólo puedes seguir una lección a la vez. Planifica tus estudios cuidadosamente cuando necesites urgentemente un certificado específico. \nLos costos escolares aumentan por nivel. La educación superior requiere completar niveles anteriores en el mismo itinerario. \nAlgunas funciones avanzadas del juego están bloqueadas tras un certificado escolar: p. acceso a ciertos trabajos, niveles de fábrica más altos, eventos de clubes nocturnos VIP y niveles más altos de mejora de instalaciones farmacéuticas. \nLos certificados nunca se restablecen a menos que su cuenta reciba una fuerte penalización.';

  @override
  String get helpTopicSchoolTips =>
      'Comience siempre con la vía criminal: las bonificaciones por las posibilidades de éxito en el crimen amortizan los costos del estudio en unas pocas sesiones. \nPrograma estudios largos (60 min+) antes de irte a dormir: te despiertas con un nuevo certificado sin perder tiempo activo.';

  @override
  String get helpTopicTerritoryCategory => 'Imperio';

  @override
  String get helpTopicTerritoryTitle => 'Territorio';

  @override
  String get helpTopicTerritorySummary =>
      'Reclama y controla regiones geográficas para obtener ingresos pasivos, prestigio de Crew y bonificaciones regionales estratégicas. Territory combina el control del mapa con concursos y recompensas estacionales.';

  @override
  String get helpTopicTerritoryHow =>
      'La descripción general del territorio muestra todos los países y regiones disponibles por país. Haga clic en un país para ver el mapa interactivo. \nTodos los países admitidos ahora se pueden navegar completamente a través del mismo flujo de mapas interactivos que los Países Bajos. \nToque una región en el mapa interactivo para abrir un modal con información del territorio y el botón de ataque. Las tarjetas de regiones separadas debajo del mapa ya no son necesarias. \nLa visualización está permitida en todas partes, pero los ataques, las uniones de defensa y las acciones de competencia solo funcionan en el país donde se encuentra actualmente tu personaje. \nEn dispositivos móviles ahora puedes acercar y alejar con dos dedos y arrastrar el mapa ampliado directamente, lo que hace que sea más fácil tocar regiones más pequeñas sin botones adicionales en el mapa. \nEl territorio se basa en la Crew: debes crear o unirte a una Crew antes de que el botón de ataque esté disponible para regiones neutrales u hostiles. \nCada región puede ser controlada como máximo por un equipo a la vez. La propiedad otorga ingresos pasivos por hora, pero el Territorio deja de pagar al banco de la Crew una vez que se alcanza el límite de almacenamiento de efectivo. \nInicie un concurso en una región no reclamada usando el botón de concurso. El concurso avanza automáticamente a través de la preparación (tiempo de preparación), la actividad (acciones) y el bloqueo (resolución). \nCuando finaliza la preparación, los miembros de la Crew atacantes y defensores reciben una notificación automática y un mensaje en la bandeja de entrada para que sepas que puedes atacar o defender. Esa alerta se envía cada minuto cron incluso si nadie tiene la pantalla Territorio abierta. \nDurante un concurso activo, el modal de región ahora también muestra cuándo se desbloquean las acciones, cuándo termina el concurso, cuál es el tiempo de reutilización por acción y la cantidad real en efectivo que la región paga por pago, por hora y por día. \nLas regiones ahora también desempeñan funciones estratégicas, como puertos, industrias, capitales, regiones fronterizas o centros logísticos. Ese rol determina qué acciones pueden ganar puntos extra allí. \nLas regiones adyacentes que ya pertenecen a tu Crew ahora brindan apoyo adicional durante las acciones del concurso. El modal de región muestra qué bonificaciones estratégicas están activas y cuánto apoyo adyacente tiene tu Crew en esa área. \nLas bonificaciones de acción ahora también pueden provenir del progreso de la Crew: nivel del cuartel general, nivel de misión de la Crew y edificios secundarios relevantes (armas/munición/coche/barco/almacenamiento de drogas). Estos bonos sólo aumentan los puntos del concurso, no el dinero pasivo de la región. \nAlgunas acciones avanzadas del concurso están controladas por HQ: si tu nivel de HQ es demasiado bajo, el botón de acción muestra \"requiere nivel de HQ X\" inmediatamente. \nEl territorio ya no utiliza un límite estricto de acción diaria de forma predeterminada (límite de tiempo de ejecución 0 = deshabilitado). El equilibrio se mantiene controlado mediante tiempos de reutilización, opciones de acción estratégica y anti-granja. \nGanar una Guerra Territorial o una Guerra Total ahora puede dejar una presión bélica temporal en las regiones del Territorio real alrededor de esa línea del frente. El modal de región muestra qué Crew mantiene la presión, cuánto se reduce la estabilidad efectiva y cuándo expiran las consecuencias. \nCuando un concurso acaba de comenzar o a un concurso anterior aún le faltaban campos de tiempo, la pantalla ahora llena esos temporizadores inmediatamente y actualiza el modal al último estado del concurso sin necesidad de que usted navegue primero. \nLos atacantes solo ven las acciones del atacante (inteligencia, sabotaje, incursión) y los defensores solo ven las acciones del defensor (patrulla, suministro de suministros, defensa), por lo que el modal ya no muestra botones mixtos confusos. \nUna región ahora también muestra el rendimiento real del Territorio. Los líderes de equipo también ven cuántas regiones y países controla su equipo en el tablero, cuánto gana actualmente el equipo y cuánto ha ganado Territorio en total hasta el momento. \nLos concursos dan como resultado la transferencia de propiedad y recompensas (efectivo, XP, prestigio). Los perdedores también obtienen XP parcial por participar. \nLas regiones grandes (puertos, capitales) generan más ingresos pasivos pero también generan más oponentes e intentos de incursión. \nLos eventos de temporada ofrecen recompensas adicionales y desafíos especiales por grupo de regiones. \nEvita puntos muertos: tu Crew no puede atacar inmediatamente al mismo oponente después de una derrota; espere el tiempo de reutilización. \nLos controles anti-abuso evitan que una Crew ataque al mismo objetivo repetidamente en períodos de tiempo cortos.';

  @override
  String get helpTopicTerritoryTips =>
      'Comience en un país equilibrado con regiones de tamaño mediano: menos competencia que los países grandes pero ingresos pasivos razonables. \nConcéntrese primero en un país donde su Crew sea fuerte: un mejor conocimiento conduce a una mejor estrategia de competencia que un control superficial en muchos países. \nUtilice las estaciones como reinicios estratégicos: si pierde en una estación seca, siempre le seguirá una temporada mejor para remontar.';

  @override
  String get helpTopicProstitutionCategory => 'Imperio';

  @override
  String get helpTopicProstitutionTitle => 'Prostitución';

  @override
  String get helpTopicProstitutionSummary =>
      'Construye una red de prostitución con reclutas, eventos y clientes VIP. Una red bien administrada genera ingresos pasivos pero requiere una gestión activa para controlar la rivalidad y la atención policial.';

  @override
  String get helpTopicProstitutionHow =>
      'El centro Prostitution Empire tiene cuatro pestañas: Trabajadores, RLD, Eventos y Social.\nGestionas reclutas, cada uno con sus propias estadísticas (experiencia, popularidad, disponibilidad). Más reclutas = mayores ingresos pasivos.\nUtilice Cobrar para liquidar las ganancias pendientes que se muestran en la franja de KPI.\nLos turnos de trabajo duran 8 horas por recluta: después de un turno, ese recluta necesita tiempo de descanso antes de poder comenzar de nuevo.\nLa gestión de la ubicación es flexible: mueva los reclutas entre la calle, el Barrio Rojo y el Nightclub a través del menú Mover en cada tarjeta de trabajador.\nLos eventos son impulsores temporales: espectáculos especiales, noches VIP y fiestas aumentan los ingresos por tick durante la duración del evento.\nRivalidad: otros jugadores o competidores NPC pueden robar a tus reclutas o sabotear eventos. Una mayor seguridad reduce este riesgo.\nLos clientes VIP pagan considerablemente más, pero requieren reclutas con gran popularidad (más de 80) y una ubicación segura.\nLa atención policial (calor) aumenta con grandes transacciones y redadas. Las altas temperaturas conducen a la confiscación de ingresos o al cierre temporal.\nCombinación con discoteca: una discoteca proporciona cobertura legal para actividades que hacen que el calor suba más lentamente.\nUtilice el panel de información de ganancias en la parte superior para comparar rápidamente la producción por hora de calle, RLD y Nightclub.\nTabla de clasificación: la facturación semanal total más alta gana una recompensa en efectivo semanal y una insignia.';

  @override
  String get helpTopicProstitutionTips =>
      'Invierta temprano en seguridad: un ataque de rivalidad que robe a su mejor recluta cuesta más que la inversión en seguridad. \nSolo organice eventos VIP cuando los reclutas tengan más de 80 de popularidad: por debajo de ese umbral, los clientes VIP simplemente pagan la tarifa estándar.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Imperio';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Barrios rojos';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Reclamar y gestionar distritos territoriales por país. Ser propietario de un distrito proporciona ingresos pasivos y control sobre las actividades de prostitución en esa región.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'Cada país tiene uno o más Barrios Rojos que se pueden reclamar. Reclama un distrito pagando un monto de compra fijo.\nComo propietario de un distrito, recibes un porcentaje de todos los ingresos por prostitución en ese país, incluidos los de otros jugadores que operan allí.\nOtros jugadores pueden atacar tu distrito para hacerse cargo de la propiedad. Una mayor seguridad reduce la posibilidad de ataque.\nEn los detalles del distrito, puede actualizar el nivel (ganancias) y la seguridad (riesgo de incursión) y ver estadísticas de incursiones en vivo (calor del FBI, probabilidad de incursiones). Una mayor seguridad reduce las posibilidades de incursión.\nPuedes poseer hasta 3 distritos simultáneamente. La elección estratégica del país es esencial.\nLos países más ocupados (Colombia, Dubai, Japón) generan los ingresos pasivos más altos, pero también son los más controvertidos.\nPerder un distrito no reembolsa el precio de compra: se pierde permanentemente si un enemigo lo reclama con éxito.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Comience con un país menos popular para su primer distrito: una menor presión de ataque le dará tiempo para mejorar la seguridad antes que la competencia real. \nActualice la seguridad de cada distrito inmediatamente después de la compra: las primeras 24 horas son las más vulnerables a una adquisición.';

  @override
  String get helpTopicAchievementsCategory => 'Meta';

  @override
  String get helpTopicAchievementsTitle => 'Logros';

  @override
  String get helpTopicAchievementsSummary =>
      'Gana insignias al alcanzar hitos en todos los sistemas de juego. Los logros otorgan recompensas, mejoran su perfil de estado y muestran su progreso por categoría.';

  @override
  String get helpTopicAchievementsHow =>
      'Los logros se agrupan en categorías: Crímenes, Imperio, PvP, Economía, Entrenamiento, Social y Meta. \nCada logro tiene varios niveles (Bronce, Plata, Oro, Platino). Cada nivel ofrece una recompensa mayor y una insignia más impresionante. \nLas recompensas por logro incluyen: dinero en efectivo, XP, artículos especiales, bonos permanentes o títulos únicos para tu perfil. \nEl progreso se rastrea automáticamente. No es necesario activar nada: alcanza el umbral y la insignia se otorga inmediatamente. \nAlgunos logros están ocultos hasta que los completas parcialmente; luego aparecen con su nombre real y sus requisitos. \nLas insignias de logros son visibles en su perfil público. Muestran a otros jugadores tus especializaciones y experiencia. \nLogros en cadena: algunas insignias están unidas en una cadena. El oro requiere que ya se haya obtenido la plata. Planifique con anticipación para niveles más altos.';

  @override
  String get helpTopicAchievementsTips =>
      'Verifique diariamente sus logros casi completados: un pequeño esfuerzo adicional puede ganar una insignia y una recompensa en efectivo que de otro modo se retrasaría durante meses. \nConcéntrate desde el principio en las categorías de Economía y Crimen: tienen la mayor cantidad de recompensas en efectivo y son más fáciles de combinar con tu juego normal.';

  @override
  String get helpTopicSupportTicketsCategory => 'Soporte';

  @override
  String get helpTopicSupportTicketsTitle => 'Informes y entradas';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Informe errores, preguntas o comentarios a través del sistema de tickets. El soporte y los administradores pueden responder, gestionar el seguimiento interno y enviar actualizaciones a través de la propia conversación de soporte y notificaciones automáticas opcionales.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Abra el elemento de menú separado \"Soporte\" para revisar sus tickets o crear uno nuevo. \nElija una categoría (error, pregunta, comentario u otro), seleccione el módulo relacionado si es necesario y describa su problema lo más específicamente posible. \nOpcionalmente, puede agregar una referencia, como una identificación de pedido, un nombre de pantalla o un contexto breve, además de una captura de pantalla si eso ayuda. \nDespués del envío, recibirá inmediatamente un número de ticket y su ticket aparecerá en su descripción general de soporte, donde el soporte puede responder y crear tareas pendientes internas. \nCuando el soporte responde o el estado del ticket cambia, lo verá directamente dentro de la misma conversación de soporte y, opcionalmente, puede recibir una notificación automática (si las notificaciones están habilitadas). \nEl elemento del menú Soporte muestra una insignia tan pronto como un ticket recibe una nueva respuesta de soporte o una actualización de estado desde su última visita a la descripción general de soporte. \nEl soporte utiliza estados como nuevo, clasificación, en progreso, en espera de jugador, bloqueado y resuelto para realizar un seguimiento interno de su informe.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Incluya siempre su país, acción y mensaje de error exacto; esto acelera las correcciones para los desarrolladores. \nUtilice un ticket por tipo de problema para que la lista de tareas pendientes y el seguimiento queden claros.';

  @override
  String get helpTopicSettingsCategory => 'Centro';

  @override
  String get helpTopicSettingsTitle => 'Ajustes';

  @override
  String get helpTopicSettingsSummary =>
      'Administre todas las configuraciones de la cuenta: idioma, avatar, privacidad, preferencias de notificación por sistema y opciones de seguridad. La configuración afecta directamente tu experiencia de juego.';

  @override
  String get helpTopicSettingsHow =>
      'Idioma: cambia entre holandés e inglés. Todos los textos de la interfaz de usuario, mensajes del sistema y notificaciones se actualizan inmediatamente. \nAvatar: sube o selecciona una imagen de perfil visible para otros jugadores en tu perfil público y en las listas de Crew. \nPrivacidad: establece quién puede ver tu estado en línea, ubicación (país actual) y estadísticas: solo tú, tu equipo, tus amigos o todos. \nNotificaciones push: alternar por sistema. Categorías: Delitos, Comercio de criptomonedas, Alertas de precios, Órdenes, eventos de jugadores en vivo (competición), Régimen de mercado, Atraco, Nightclub, mensajes generales. \nSi ya se permitía la inserción, la versión web/PWA se vuelve a conectar automáticamente al token de su dispositivo actual después de una actualización o actualización; solo necesita volver a habilitarlo en Configuración cuando el navegador bloquee las notificaciones. \nLas preferencias de notificación criptográfica permanecen guardadas después de salir de Configuración y abrirla nuevamente más tarde. \nNotificaciones dentro de la aplicación: configurables por separado del push. La aplicación muestra alertas dentro de la aplicación sin enviar una notificación del sistema. \nSeguridad: cambie la contraseña, configure la autenticación de dos factores y vea las sesiones activas. \nPreferencia de notificación por sistema: ajuste para no recibir una tormenta de notificaciones de sistemas en los que no está jugando activamente.';

  @override
  String get helpTopicSettingsTips =>
      'Habilite las notificaciones automáticas para órdenes criptográficas y eventos de atracos: estos son sistemas en los que el tiempo es crítico y donde es importante reaccionar rápidamente. \nEstablece la privacidad solo para el equipo para la ubicación cuando estés activo en la lista de objetivos: de lo contrario, otros jugadores pueden identificarte exactamente.';

  @override
  String get helpTopicPremiumCategory => 'Centro';

  @override
  String get helpTopicPremiumTitle => 'Primas y créditos';

  @override
  String get helpTopicPremiumSummary =>
      'Compra y gestiona paquetes de jugadores VIP, Crew VIP y créditos aquí. Esta descripción general también muestra su saldo de crédito y todos los elementos de crédito disponibles que puede usar directa o contextualmente.';

  @override
  String get helpTopicPremiumHow =>
      'Abra la página separada \"Premium y Créditos\" desde el menú lateral para ver su estado VIP, fechas de vencimiento, saldo de crédito y opciones de compra. \nEn cada mosaico de compra, toque o haga clic en el ícono \"i\" en la parte superior izquierda para obtener todos los detalles y beneficios; el mosaico en sí muestra intencionalmente solo información básica breve y el botón de compra. \nEl jugador VIP es personal. Crew VIP se aplica a tu Crew y solo tiene valor cuando ya estás en una Crew. \nEl jugador VIP ofrece tiempos de espera de acción un 10% más cortos (el tiempo de cárcel permanece sin cambios), 100 créditos semanales, un botón de compra VIP con un solo clic para materiales faltantes en la producción de drogas (después de la confirmación del costo) y un reinicio de muerte más suave: el banco/cripto/educación/logros permanecen, mientras que los activos, el inventario y las existencias de medicamentos se eliminan. \nEl pago VIP abre la página de pago y luego regresa a la sección \"Premium y créditos\" del juego, para que puedas ver inmediatamente si la compra se realizó correctamente y cuánto tiempo estará activa tu VIP. \nLos paquetes de crédito se compran con dinero real. Después de un pago exitoso, los créditos aparecen inmediatamente en la descripción general de su billetera. \nEl Pase de eventos (7 días, dinero real) figura en la tabla de ofertas únicas: +10 % de puntuación en eventos de jugadores en vivo, además de un pequeño bono de crédito después de la compra. Es un grado secundario: no un combate directo o un impulso PvP; principalmente ayuda a los resultados de la clasificación durante los eventos de carrera. \nLos artículos de crédito utilizan créditos de billetera en lugar de euros. Piense en protección contra golpes, restablecimientos de tiempo de reutilización, mejoras de eventos o paquetes de efectivo, dependiendo de qué administrador haya habilitado actualmente el modo activo. \nEn las pantallas de tiempo de espera admitidas (como crímenes, trabajos, robo de vehículos/barcos y escuela) también obtienes un botón de aceleración directa para tiempos de reutilización activos, por lo que no necesitas volver primero a Premium y Créditos. \nAlgunas partidas de crédito funcionan directamente desde esta pantalla. Los elementos vinculados al contexto, como ciertas acciones del vehículo, se utilizan desde la pantalla del vehículo o del garaje correcto (los vehículos dañados muestran un botón de reparación instantánea directamente en la tarjeta). \nPara botones contextuales como acelerar la reparación, el costo del crédito actual se muestra directamente en el botón/información sobre herramientas. \nLos precios y los artículos disponibles se gestionan en vivo en el administrador. Eso significa que los precios VIP, los costos de crédito y la oferta disponible pueden cambiar sin una actualización de la aplicación.';

  @override
  String get helpTopicPremiumTips =>
      'Verifique su saldo de crédito y fecha de vencimiento antes de volver a comprar; extender es a menudo mejor que apilar a ciegas. \nUtilice créditos principalmente en mejoras o protección en las que el tiempo es crítico, no automáticamente en cada pequeño atajo. \nSi aún no estás en un equipo, comienza con Player VIP o un paquete de crédito antes de Crew VIP.';

  @override
  String get landingHeroTitle => 'El estado mafioso';

  @override
  String get landingHeroSubtitle =>
      'Un profundo juego de estrategia criminal basado en texto en tu navegador. Construye tu imperio, dirige equipos, comercia, lucha por territorio y sube de rango.';

  @override
  String get landingAboutTitle => 'que te espera';

  @override
  String get landingAboutBody =>
      'Gestiona negocios, ejecuta trabajos y atracos, desarrolla tu personaje a través de certificados escolares, compite en eventos en vivo y coordina con tu Crew en el mapa mundial. Reglas competitivas justas, progresión a largo plazo y actualizaciones periódicas de contenido.';

  @override
  String get landingTopPlayersTitle => 'Mejores jugadoras';

  @override
  String get landingTopCrewsTitle => 'Mejores tripulaciones (territorio)';

  @override
  String get landingRankLabel => 'Rango';

  @override
  String get landingRegionsLabel => 'Regiones';

  @override
  String get landingLoadError =>
      'No se pudieron cargar las clasificaciones en este momento.';

  @override
  String get landingEmptyLeaderboard => 'Aún no hay entradas.';

  @override
  String get landingCtaLogin => 'Acceso';

  @override
  String get landingCtaRegister => 'Crear una cuenta';

  @override
  String get landingFooterPrivacy => 'política de privacidad';

  @override
  String get landingFooterTerms => 'Términos del servicio';

  @override
  String get landingFooterDigitalGoods => 'Compra de bienes digitales';

  @override
  String get landingFooterLanguage => 'Idioma';

  @override
  String landingCopyright(int year) {
    return '© $year El Estado mafioso. Reservados todos los derechos.';
  }

  @override
  String get legalPrivacyTitle => 'política de privacidad';

  @override
  String get legalPrivacyLastUpdated => 'Última actualización: mayo de 2026';

  @override
  String get legalPrivacyIntro =>
      'Esta Política de Privacidad explica cómo The Mob State (\"nosotros\", \"nos\") maneja los datos personales cuando utiliza nuestro sitio web, juego web y servicios relacionados. Al jugar o navegar, aceptas esta política cuando la ley aplicable lo permita.';

  @override
  String get legalPrivacySection01Title => 'Quienes somos';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State es un juego en línea que funciona como un servicio digital. Para solicitudes de privacidad, puedes contactarnos a través del sistema de tickets de soporte del juego después del registro, o a través de los canales de contacto del sitio web oficial, si están publicados.';

  @override
  String get legalPrivacySection02Title => 'Datos que recopilamos';

  @override
  String get legalPrivacySection02Body =>
      'Podemos procesar datos de la cuenta (nombre de usuario, correo electrónico si se proporciona, contraseña hash), datos de juego y progresión, registros técnicos (dirección IP, tipo de dispositivo/navegador, marcas de tiempo), referencias relacionadas con pagos de nuestros proveedores de pagos (no almacenamos números completos de tarjetas) y comunicaciones que usted envía al soporte.';

  @override
  String get legalPrivacySection03Title => 'Propósitos';

  @override
  String get legalPrivacySection03Body =>
      'Usamos datos para proporcionar el juego, proteger cuentas, prevenir abusos y fraudes, procesar compras, mejorar el rendimiento, comunicar mensajes de servicio y cumplir con obligaciones legales.';

  @override
  String get legalPrivacySection04Title => 'Bases jurídicas (EEE/Reino Unido)';

  @override
  String get legalPrivacySection04Body =>
      'Cuando se aplica el RGPD, nos basamos en la ejecución de un contrato (proporcionar el juego), intereses legítimos (seguridad, análisis, mejora del producto en relación con sus derechos), consentimiento cuando sea necesario (por ejemplo, ciertas cookies de marketing o comunicaciones opcionales) y obligaciones legales.';

  @override
  String get legalPrivacySection05Title => 'Cookies y almacenamiento local';

  @override
  String get legalPrivacySection05Body =>
      'Utilizamos cookies y tecnologías similares para mantener su sesión iniciada, recordar preferencias, medir el uso básico y brindarle funciones esenciales. Puede controlar muchas cookies a través de la configuración de su navegador.';

  @override
  String get legalPrivacySection06Title => 'Retención';

  @override
  String get legalPrivacySection06Body =>
      'Conservamos información durante el tiempo necesario para operar el servicio y cumplir con los requisitos legales, fiscales y contables. Es posible que algunos registros se mantengan durante un período de seguridad limitado. Cuando los datos ya no son necesarios, los eliminamos o los anonimizamos cuando sea posible.';

  @override
  String get legalPrivacySection07Title => 'Intercambio';

  @override
  String get legalPrivacySection07Body =>
      'Compartimos datos con infraestructura y procesadores de pagos estrictamente según sea necesario para ejecutar el servicio, según los acuerdos adecuados. No vendemos sus datos personales. Podemos divulgar información si lo exige la ley o para proteger los derechos y la seguridad.';

  @override
  String get legalPrivacySection08Title => 'Transferencias internacionales';

  @override
  String get legalPrivacySection08Body =>
      'Sus datos pueden ser procesados ​​en el Espacio Económico Europeo y/u otras regiones donde operamos nosotros o nuestros proveedores. Utilizamos salvaguardias como cláusulas contractuales estándar cuando es necesario.';

  @override
  String get legalPrivacySection09Title => 'Tus derechos';

  @override
  String get legalPrivacySection09Body =>
      'Dependiendo de tu ubicación podrás tener derechos de acceso, rectificación, supresión, restricción u oposición a determinados tratamientos y a la portabilidad de los datos. Puede presentar una reclamación ante una autoridad de control. Contáctenos a través de soporte para ejercer derechos; Es posible que necesitemos verificar su identidad.';

  @override
  String get legalPrivacySection10Title => 'Niñas';

  @override
  String get legalPrivacySection10Body =>
      'El juego no está dirigido a niños menores de edad en los que se requiere el consentimiento de los padres para el procesamiento en su región. Si cree que un niño proporcionó datos de manera incorrecta, contáctenos y tomaremos las medidas adecuadas.';

  @override
  String get legalDigitalGoodsTitle => 'Compra de bienes digitales';

  @override
  String get legalDigitalGoodsLastUpdated =>
      'Última actualización: mayo de 2026';

  @override
  String get legalDigitalGoodsIntro =>
      'Esta política describe las compras de contenido y servicios digitales en The Mob State (por ejemplo, créditos premium, tiempo VIP u otros artículos virtuales). Al completar una compra, acepta estos términos junto con los términos de pago que se muestran en el momento del pago.';

  @override
  String get legalDigitalGoodsSection01Title =>
      'Naturaleza de las compras digitales';

  @override
  String get legalDigitalGoodsSection01Body =>
      'Todas las compras son pagos por el acceso a funciones adicionales en línea y artículos virtuales dentro de The Mob State. Se entregan digitalmente en el juego y no tienen forma física.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Entrega y retiro inmediatos (Reino Unido/UE)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Cuando se apliquen las Regulaciones de Contratos con el Consumidor de 2013 (Reino Unido) o normas equivalentes de la UE, usted reconoce que el contenido digital se suministra inmediatamente después de la compra y, cuando la ley lo permita, puede perder el derecho legal de desistimiento de 14 días una vez que la entrega haya comenzado con su previo consentimiento expreso.';

  @override
  String get legalDigitalGoodsSection03Title => 'Reembolsos y contracargos';

  @override
  String get legalDigitalGoodsSection03Body =>
      'Los productos digitales generalmente no son reembolsables una vez entregados, excepto cuando la ley obligatoria del consumidor exija lo contrario. Las devoluciones de cargo o disputas de pago después de la entrega pueden dar lugar a la suspensión o cancelación de cuentas relacionadas; Comuníquese primero con el soporte para que podamos ayudarlo a resolver los problemas de facturación.';

  @override
  String get legalDigitalGoodsSection04Title => 'Permiso y edad';

  @override
  String get legalDigitalGoodsSection04Body =>
      'Debes estar autorizado para utilizar el método de pago elegido. Si es menor de 18 años, necesita el permiso de uno de sus padres o tutor para realizar compras o utilizar servicios pagos.';

  @override
  String get legalDigitalGoodsSection05Title => 'Canales de pago y tarifas';

  @override
  String get legalDigitalGoodsSection05Body =>
      'Los precios pueden mostrarse en euros o en la moneda de su proveedor. Los operadores de telefonía móvil o las plataformas de pago pueden agregar sus propias tarifas; consulte con su proveedor antes de confirmar los pagos con el operador o la billetera.';

  @override
  String get legalDigitalGoodsSection06Title => 'Disponibilidad';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Las funciones pagas se entregan virtualmente a través de nuestros servidores y pueden cambiar con el tiempo. Podemos ajustar, suspender o retirar artículos, paquetes o precios específicos para equilibrar el juego o por razones técnicas.';

  @override
  String get legalDigitalGoodsSection07Title =>
      'Sin valor en efectivo en el mundo real';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Los artículos y monedas virtuales no tienen valor monetario fuera del juego, no son transferibles por dinero real y pueden modificarse o eliminarse como parte de actualizaciones, aplicación de la cuenta o interrupción del servicio, excepto cuando la ley requiera una compensación.';

  @override
  String get legalDigitalGoodsSection08Title => 'Uso comercial prohibido';

  @override
  String get legalDigitalGoodsSection08Body =>
      'No puede utilizar The Mob State para operar transacciones no autorizadas con dinero real, incluida la compra o venta de cuentas, moneda del juego, códigos o activos virtuales por dinero en efectivo o servicios externos fuera de nuestros flujos de pago oficiales.';

  @override
  String get legalDigitalGoodsSection09Title => 'Cambios de servicio';

  @override
  String get legalDigitalGoodsSection09Body =>
      'Es posible que actualicemos esta política y las descripciones de compras en el juego. El uso continuado después de los cambios constituye la aceptación de los términos revisados ​​cuando lo permita la ley.';

  @override
  String get legalDigitalGoodsSection10Title => 'Ley aplicable';

  @override
  String get legalDigitalGoodsSection10Body =>
      'A menos que la ley local obligatoria disponga lo contrario, esta política se rige por las leyes de Inglaterra y Gales y las disputas estarán sujetas a la jurisdicción exclusiva de los tribunales de Inglaterra y Gales.';

  @override
  String get registerTermsRequired =>
      'Debe aceptar los Términos de servicio para registrarse.';

  @override
  String get registerTermsPrefix => 'Estoy de acuerdo con el';

  @override
  String get registerTermsLink => 'Términos de servicio';

  @override
  String get registerTermsSuffix => '.';

  @override
  String get legalTermsTitle => 'Términos de servicio';

  @override
  String get legalTermsLastUpdated => 'Última actualización: mayo de 2026';

  @override
  String get legalTermsIntro =>
      'Estos Términos de servicio (\"Términos\") rigen su acceso y uso del sitio web, el juego web y los servicios relacionados de The Mob State (\"Servicio\"). Al crear una cuenta o utilizar el Servicio, acepta estos Términos junto con nuestra Política de Privacidad y, cuando corresponda, nuestra política de compra de productos digitales.';

  @override
  String get legalTermsSection01Title => 'Elegibilidad y cuenta';

  @override
  String get legalTermsSection01Body =>
      'Debe cumplir con la edad mínima que se muestra al registrarse para su región. Usted es responsable de proporcionar información de registro precisa y de mantener la confidencialidad de sus credenciales. Usted es responsable de la actividad de su cuenta a menos que nos notifique de inmediato a través del soporte si sospecha de un acceso no autorizado.';

  @override
  String get legalTermsSection02Title => 'Licencia para utilizar el Servicio';

  @override
  String get legalTermsSection02Body =>
      'Le otorgamos una licencia personal, no exclusiva, intransferible y revocable para acceder y utilizar el Servicio con fines de entretenimiento de acuerdo con estos Términos. Todos los derechos no otorgados expresamente están reservados.';

  @override
  String get legalTermsSection03Title => 'Uso aceptable';

  @override
  String get legalTermsSection03Body =>
      'Usted acepta no hacer trampa, explotar errores para obtener ventajas injustas, acosar a otros, distribuir malware, raspar o sobrecargar nuestros sistemas sin permiso, hacerse pasar por personal ni utilizar el Servicio con fines ilegales. Podemos investigar informes y aplicar sanciones que incluyen advertencias, suspensiones o despidos.';

  @override
  String get legalTermsSection04Title => 'Artículos y pagos virtuales';

  @override
  String get legalTermsSection04Body =>
      'Es posible que haya compras opcionales disponibles para bienes o funciones virtuales. Dichas compras están sujetas a nuestra política de compra de productos digitales y a nuestros términos de pago. Los artículos virtuales no tienen valor en efectivo en el mundo real fuera del Servicio, excepto cuando la ley obligatoria indique lo contrario.';

  @override
  String get legalTermsSection05Title => 'Contenido del usuario';

  @override
  String get legalTermsSection05Body =>
      'Cuando el Servicio le permite enviar texto, imágenes u otro material, usted conserva la propiedad que ya posee, pero nos otorga una licencia para alojar, mostrar y moderar ese contenido según sea necesario para operar el Servicio. Debe tener derechos sobre todo lo que envíe y no debe cargar material ilegal o infractor.';

  @override
  String get legalTermsSection06Title => 'Disponibilidad y cambios';

  @override
  String get legalTermsSection06Body =>
      'Nos esforzamos por mantener el Servicio disponible pero no garantizamos el acceso ininterrumpido. Podemos modificar, suspender o descontinuar funciones por razones de mantenimiento, equilibrio, legales o de seguridad. Podemos actualizar estos Términos; El uso continuado después del aviso cuando lo permita la ley constituye la aceptación de cambios materiales.';

  @override
  String get legalTermsSection07Title =>
      'Descargo de responsabilidad y responsabilidad';

  @override
  String get legalTermsSection07Body =>
      'El Servicio se proporciona \"tal cual\" en la máxima medida permitida por la ley. Excluimos la responsabilidad por pérdidas indirectas o consecuentes cuando esté permitido. Nada en estos Términos limita la responsabilidad que no pueda limitarse según la ley de consumo obligatoria aplicable.';

  @override
  String get legalTermsSection08Title => 'Terminación';

  @override
  String get legalTermsSection08Body =>
      'Puede dejar de utilizar el Servicio en cualquier momento. Podemos suspender o cancelar el acceso si usted incumple estos Términos, si así lo exige la ley, o para proteger el Servicio o a otros usuarios. Las disposiciones que por naturaleza deberían sobrevivir sobrevivirán a la terminación.';

  @override
  String get legalTermsSection09Title => 'Ley aplicable';

  @override
  String get legalTermsSection09Body =>
      'A menos que la ley local obligatoria disponga lo contrario, estos Términos se rigen por las leyes de Inglaterra y Gales y las disputas estarán sujetas a la jurisdicción exclusiva de los tribunales de Inglaterra y Gales.';

  @override
  String get legalTermsSection10Title => 'Contacto';

  @override
  String get legalTermsSection10Body =>
      'Si tiene preguntas sobre estos Términos, contáctenos a través del sistema de tickets de soporte del juego después del registro, o a través de los canales de contacto del sitio web oficial, si están publicados.';

  @override
  String get helpTopicTrainingHubCategory => 'Capacitación';

  @override
  String get helpTopicTrainingHubTitle => 'Centro de formación';

  @override
  String get helpTopicTrainingHubSummary =>
      'Gimnasio (fuerza) y campo de tiro (precisión) en un solo lugar. Ambos bonos aumentan tus posibilidades de éxito en el crimen; La precisión de los disparos también se utiliza en las acciones de la lista de objetivos. Cada pista tiene su propio tiempo de reutilización y un límite de 100 sesiones.';

  @override
  String get helpTopicTrainingHubHow =>
      'Gimnasio: cada sesión aumenta tu bonificación de fuerza permanente hasta un +8% total (100 sesiones). El tiempo de recuperación entre sesiones es de 1 hora (VIP puede acortarlo).\nRango de tiro: cada sesión aumenta tu bonificación de precisión permanente hasta +10% en total (100 sesiones). El tiempo de recuperación entre sesiones es de 1 hora (VIP puede acortarlo).\nEl servidor suma ambas bonificaciones a los cálculos de éxito del crimen.\nEntrenas cada pista por separado: dos cronómetros y dos botones de tren, una pantalla.\nEl progreso no se reinicia a menos que el personal aplique una fuerte penalización.';

  @override
  String get helpTopicTrainingHubTips =>
      'Programe ambas pistas diariamente: los pequeños pasos se acumulan para lograr una ventaja clara sobre los delitos.\nRevise los delitos en los que más falla: la fuerza y ​​la precisión se complementan; no son la misma estadística.';

  @override
  String territoryCapsLine(
    int owned,
    int maxRegions,
    int active,
    int maxContests,
  ) {
    return 'Regiones $owned/$maxRegions · Concursos $active/$maxContests';
  }

  @override
  String territoryCapsRegionsChip(int owned, int max) {
    return 'Regiones $owned/$max';
  }

  @override
  String territoryCapsContestsChip(int active, int max) {
    return 'Concursos $active/$max';
  }

  @override
  String get territoryDetailProject => 'Proyecto de región';

  @override
  String get territoryProjectSafehouse => 'Red de casas seguras';

  @override
  String get territoryProjectStatusBuilding => 'Edificio';

  @override
  String get territoryProjectStatusActive => 'Activa';

  @override
  String get territoryProjectStatusDamaged => 'Dañada';

  @override
  String get territoryProjectStatusDestroyed => 'Destruido';

  @override
  String get territoryProjectProgress => 'Progreso';

  @override
  String get territoryProjectHp => 'Integridad';

  @override
  String territoryProjectIncomeBonusPct(int percent) {
    return '+$percent% de ingresos pasivos';
  }

  @override
  String get territoryProjectStart => 'Start safehouse project';

  @override
  String get territoryProjectContribute => 'Proyecto de suministro';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Requiere nivel HQ $level';
  }

  @override
  String get territoryProjectHint =>
      'A safehouse network boosts passive income. Sabotage damages it in contests; supply runs repair or advance it.';

  @override
  String get territorySnackProjectStarted =>
      'Se inició el proyecto de refugio.';

  @override
  String get territorySnackProjectContributed => 'Proyecto actualizado.';

  @override
  String get territoryErrorProjectHq =>
      'Se requiere un nivel de sede más alto para iniciar este proyecto.';

  @override
  String get territoryErrorProjectNotOwner =>
      'Sólo el equipo de control puede gestionar este proyecto.';

  @override
  String get territoryErrorProjectExists => 'Esta región ya tiene un proyecto.';

  @override
  String get territoryErrorProjectNotFound =>
      'No se encontró ningún proyecto para esta región.';

  @override
  String get territoryErrorProjectDestroyed =>
      'Proyecto destruido: comience uno nuevo.';

  @override
  String get territoryErrorProjectActive => 'El proyecto ya está activo.';

  @override
  String get territoryErrorProjectCooldown =>
      'El suministro del proyecto está en enfriamiento.';

  @override
  String get territoryDramaTitle => 'Drama territorial';

  @override
  String get territoryDramaHotContests => 'concursos calientes';

  @override
  String get territoryDramaRecentCaptures => 'Capturas recientes';

  @override
  String get territoryDramaRisingCrews => 'Tripulaciones en ascenso';

  @override
  String get territoryDramaWarTheaters => 'Teatros de guerra';

  @override
  String get territoryDramaRegionEvents => 'Eventos regionales';

  @override
  String get territoryDramaEmpty =>
      'No hay drama territorial en vivo en este momento.';

  @override
  String get territoryDetailRegionEvent => 'Evento de región';

  @override
  String get territoryEventPoliceOffensive => 'Ofensiva policial';

  @override
  String get territoryEventHarborStrike => 'huelga portuaria';

  @override
  String get territoryEventBlackoutRumor => 'Rumor de apagón';

  @override
  String get launderSectionTitle => 'Lavado de dinero';

  @override
  String launderSectionHint(int feePercent, int durationMinutes) {
    return 'Lave efectivo en su banco con una tarifa del $feePercent%. Tarda aproximadamente $durationMinutes minutos. Una mayor presión del FBI significa un mayor riesgo de incautación.';
  }

  @override
  String get launderSectionCapHint =>
      'Úselo para obtener efectivo en la calle por encima del límite de depósito gratuito actual.';

  @override
  String launderSeizeChance(String chance) {
    return 'Probabilidad estimada de incautación: $chance%';
  }

  @override
  String launderActiveJob(String amount) {
    return 'Lavado en curso. Pago bancario si tiene éxito: €$amount';
  }

  @override
  String launderJobCountdown(String time) {
    return 'Se completa en $time';
  }

  @override
  String launderCooldownCountdown(String time) {
    return 'Disponible nuevamente en $time';
  }

  @override
  String launderPreviewFee(int feePercent, String fee) {
    return 'Tarifa ($feePercent%): €$fee';
  }

  @override
  String launderPreviewPayout(String payout) {
    return 'Pago bancario si tiene éxito: €$payout';
  }

  @override
  String get launderAmountLabel => 'cantidad a lavar';

  @override
  String launderAmountRange(String min, String max) {
    return 'Mín $min · Máx $max por lavado.';
  }

  @override
  String get launderStartButton => 'Iniciar lavado';

  @override
  String get launderStartedSuccess => 'Comenzó el lavado.';

  @override
  String get launderErrorCooldown =>
      'El lavado está en tiempo de reutilización.';

  @override
  String get launderErrorActive =>
      'Ya se está realizando un trabajo de lavado.';

  @override
  String launderErrorTooLow(String min) {
    return 'El monto está por debajo del mínimo ($min).';
  }

  @override
  String launderErrorTooHigh(String max) {
    return 'El monto está por encima del máximo ($max).';
  }

  @override
  String get launderErrorInsufficientCash =>
      'No hay suficiente efectivo disponible.';

  @override
  String get launderErrorDisabled =>
      'El blanqueo de capitales está inhabilitado.';

  @override
  String get launderErrorUnknown => 'No se pudo iniciar el lavado.';

  @override
  String get stockMarketTitle => 'mercado de valores';

  @override
  String get stockMarketHint =>
      'Opere con dinero bancario. Los precios se mueven lentamente, separados de las criptomonedas.';

  @override
  String get stockBankBalance => 'Saldo bancario';

  @override
  String get stockPortfolioValue => 'Valor de la cartera';

  @override
  String get stockQuantity => 'Cantidad';

  @override
  String get stockPrice => 'Precio';

  @override
  String get stockHolding => 'Tenencia';

  @override
  String get stockValue => 'Valor';

  @override
  String get stockBuy => 'Comprar';

  @override
  String get stockSell => 'Vender';

  @override
  String get stockTradeSuccess => 'Comercio completado.';

  @override
  String get stockErrorInsufficientBalance => 'Saldo bancario insuficiente.';

  @override
  String get stockErrorInsufficientShares => 'No hay suficientes acciones.';

  @override
  String get stockErrorPositionLimit => 'Límite de posición alcanzado.';

  @override
  String get stockErrorDisabled => 'El mercado de valores está inhabilitado.';

  @override
  String get stockErrorUnknown => 'El comercio fracasó.';

  @override
  String get stockMarketLoadError => 'No se pudo cargar el mercado de valores.';

  @override
  String get stockMarketEmpty => 'No hay tickers disponibles en este momento.';

  @override
  String get stockMarketRetry => 'Rever';

  @override
  String stockPositionsOpen(int count) {
    return 'Posiciones abiertas: $count';
  }

  @override
  String stockCashAvailable(String amount) {
    return 'Disponible para invertir: €$amount';
  }

  @override
  String get propertyDevelopAction => 'Desarrollar';

  @override
  String get propertyDevelopedSuccess => 'Desarrollo inmobiliario completo.';

  @override
  String propertyDevelopedSuccessLevel(int level) {
    return 'Desarrollo completo - nivel $level.';
  }

  @override
  String get propertyDevelopConfirmTitle => '¿Desarrollar propiedad?';

  @override
  String propertyDevelopConfirmBody(String cost, int level, int bonusPercent) {
    return 'Gasta $cost€ de tu banco para elevar el desarrollo al nivel $level. Cada nivel agrega +$bonusPercent% de ingresos pasivos.';
  }

  @override
  String get propertyDevelopLevel => 'Desarrollo';

  @override
  String get propertyDevelopIncomeBonusLabel =>
      'Bonificación de ingresos para desarrolladores';

  @override
  String propertyDevelopIncomeBonus(int percent) {
    return '+$percent%';
  }

  @override
  String get propertyDevelopIncomeLabel => 'Ingresos pasivos';

  @override
  String propertyDevelopActionCost(String cost, int level) {
    return 'Desarrollar · €$cost → L$level';
  }

  @override
  String propertyDevelopCooldown(String duration) {
    return 'Desarrollar disponible en $duration';
  }

  @override
  String propertyDevelopErrorCooldown(String duration) {
    return 'Enfriamiento de desarrollo: $duration';
  }

  @override
  String get propertyDevelopErrorCooldownGeneric =>
      'El desarrollo está en tiempo de reutilización.';

  @override
  String get propertyDevelopErrorMaxLevel =>
      'Esta propiedad ya se encuentra en máximo desarrollo.';

  @override
  String get propertyDevelopErrorDisabled =>
      'La promoción inmobiliaria está inhabilitada.';

  @override
  String get propertyDevelopInsufficientBalance =>
      'Saldo bancario insuficiente.';

  @override
  String get propertyDevelopErrorUnknown =>
      'No se pudo desarrollar esta propiedad.';

  @override
  String get helpTopicStockMarketCategory => 'Economía';

  @override
  String get helpTopicStockMarketTitle => 'mercado de valores';

  @override
  String get helpTopicStockMarketSummary =>
      'Opere acciones de lento movimiento con dinero bancario. Sistema separado de criptografía.';

  @override
  String get helpTopicStockMarketHow =>
      'Abra el mercado de valores desde el tablero. Ve los tickers, el precio actual, sus tenencias y el saldo bancario. \nCompre y venda, ejecútelo inmediatamente al precio del servidor y debite/crédito en su banco, no en efectivo. \nLos precios avanzan lentamente (aproximadamente cada minuto) con una ligera deriva aleatoria y una reversión a la media; no hay transmisión en vivo externa. \nHay un número máximo de puestos vacantes. Las órdenes, regímenes y tablas de clasificación de criptomonedas no forman parte de este módulo.';

  @override
  String get helpTopicStockMarketTips =>
      'Mantenga una reserva bancaria para delitos/viajes; las acciones no son efectivo de emergencia. \nNo diversifique a ciegas en cada ticker: el límite de posición es ajustado.';

  @override
  String get premiumUiAutoRenewActive =>
      'Se renueva automáticamente mensualmente';

  @override
  String get premiumUiAutoRenewOff => 'Sin renovación automática';

  @override
  String get premiumUiCancelRenewal => 'Cancelar renovación';

  @override
  String premiumUiCancelRenewalConfirm(String date) {
    return '¿Detener futuros cargos VIP? Tu VIP actual permanece activo hasta el $date.';
  }

  @override
  String get premiumUiCancelRenewalSuccess =>
      'Renovación automática cancelada.';

  @override
  String get premiumUiCancelRenewalFailed =>
      'No se pudo cancelar la renovación automática.';

  @override
  String get premiumUiGiftVip => 'Regalo VIP';

  @override
  String get premiumUiGiftVipHint =>
      'Compra 30 días de Jugador VIP para otra jugadora.';

  @override
  String premiumUiGiftVipPrice(String price) {
    return 'Precio único: $price (30 días, sin renovación automática).';
  }

  @override
  String get premiumUiGiftVipUsername => 'Nombre de usuario del destinatario';

  @override
  String get premiumUiGiftVipConfirm => 'Continuar pagando';

  @override
  String get premiumUiGiftVipFailed =>
      'No se pudo iniciar el pago de regalos VIP.';

  @override
  String get premiumUiPrestigeLabel => 'prestigio vip';

  @override
  String get premiumUiPrestigeNone => 'Ninguna';

  @override
  String get premiumUiPrestigeBronze => 'Bronce';

  @override
  String get premiumUiPrestigeSilver => 'Plata';

  @override
  String get premiumUiPrestigeGold => 'Oro';

  @override
  String premiumUiPrestigeDays(int days) {
    return '$days días de por vida';
  }

  @override
  String premiumUiPrestigeNext(int days, String tier) {
    return '$days días a $tier';
  }

  @override
  String get premiumUiPrestigeMax => 'Prestigio máximo alcanzado';

  @override
  String get premiumUiGiftCrewVip => 'Crew VIP de regalo';

  @override
  String get premiumUiGiftCrewVipHint =>
      'Compra 30 días de Crew VIP para cualquier Crew por nombre. Regalo único: no hay renovación automática para ese equipo.';

  @override
  String get premiumUiGiftCrewVipName => 'Nombre de la Crew';

  @override
  String get premiumUiGiftCrewVipFailed =>
      'No se pudo iniciar el pago de regalos Crew VIP.';

  @override
  String get territoryOverlayContest => 'Puntuaciones del concurso';

  @override
  String get territoryOverlayProject => 'Proyectos';

  @override
  String get territoryOverlayEvent => 'Eventos regionales';

  @override
  String get territoryLegendPocket => 'Bolsillo (borde fino)';

  @override
  String get territoryLegendCluster => 'Grupo (borde grueso)';

  @override
  String get territoryContestHudTitle => 'Concurso';

  @override
  String territoryContestHudScore(int attacker, int defender) {
    return 'Puntuación $attacker:$defender';
  }

  @override
  String get territoryProjectSurveillance => 'Cuadrícula de vigilancia';

  @override
  String get territoryProjectArmsCache => 'caché de armas';

  @override
  String get territoryProjectPickTitle => 'Elija un proyecto de región';

  @override
  String get territoryProjectPickSubtitle =>
      'Un proyecto por región. El tipo depende de las etiquetas estratégicas y del nivel de sede.';

  @override
  String get territoryProjectStartGeneric => 'Iniciar proyecto';

  @override
  String get territoryProjectLockedTags =>
      'Necesita una etiqueta estratégica coincidente';

  @override
  String territoryProjectLockedHq(int level) {
    return 'Requiere sede $level';
  }

  @override
  String get territoryProjectSafehouseDesc =>
      'Bonificación de ingresos pasivos en esta región.';

  @override
  String get territoryProjectSurveillanceDesc =>
      'Puntos intel_scan adicionales y tiempo de reutilización de información más corto (puerto/airhub/capital).';

  @override
  String get territoryProjectArmsCacheDesc =>
      'Puntos extra de incursión y defensa (industria/frontera).';

  @override
  String get territoryBonusRegionProject => 'Proyecto de región';

  @override
  String get territoryBonusGarrison => 'Guarnición / defensa aérea';

  @override
  String get territoryErrorProjectInvalidType =>
      'Tipo de proyecto desconocido.';

  @override
  String get territoryErrorProjectTagMismatch =>
      'Este tipo de proyecto no se ajusta a las etiquetas estratégicas de esta región.';

  @override
  String get territoryStatsTitle => 'Estadísticas del territorio de tu Crew';

  @override
  String get territoryStatsAllTime => 'Todos los tiempos';

  @override
  String get territoryStatsSeason => 'esta temporada';

  @override
  String get territoryStatsWon => 'Ganado';

  @override
  String get territoryStatsDefended => 'Defendida';

  @override
  String get territoryStatsLost => 'Perdida';

  @override
  String get territoryStatsContests => 'Concursos';

  @override
  String get territoryStatsHoldTotal => 'Tiempo total de espera';

  @override
  String get territoryStatsHoldCurrent => 'Retención actual';

  @override
  String get territoryStatsOwnedNow => 'Propiedad ahora';

  @override
  String get territoryLeaderboardScopeAllTime => 'Todos los tiempos';

  @override
  String get territoryLeaderboardScopeSeason => 'Estación';

  @override
  String territoryLeaderboardStatsLine(
    int won,
    int defended,
    int lost,
    String hold,
  ) {
    return 'W $won · D $defended · L $lost · mantener $hold';
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
  String get countryPoliceStripTitle => 'Policía nacional';

  @override
  String get countryPoliceBandCalm => 'Calma';

  @override
  String get countryPoliceBandWatchful => 'Vigilante';

  @override
  String get countryPoliceBandHot => 'Caliente';

  @override
  String get countryPoliceBandLockdown => 'Cierre';

  @override
  String countryPolicePressureValue(int pressure) {
    return '$pressure/100';
  }

  @override
  String countryPoliceEffectLine(int successPenalty, int arrestBonus) {
    return 'Éxito de crimen −$successPenalty pp · Arresto +$arrestBonus pp';
  }

  @override
  String get countryPoliceDisruptTitle => 'Alterar la presión policial';

  @override
  String get countryPoliceDisruptHint =>
      'Ops raras que enfrían el calor local. Fallar sube Wanted y el calor FBI.';

  @override
  String get countryPoliceDisruptButton => 'Alterar';

  @override
  String get countryPoliceDisruptCorruption => 'Corrupción';

  @override
  String get countryPoliceDisruptCorruptionDesc =>
      'Unta palmas para bajar la presión.';

  @override
  String get countryPoliceDisruptDistract => 'Distraer';

  @override
  String get countryPoliceDisruptDistractDesc =>
      'Crea una distracción en la ciudad.';

  @override
  String get countryPoliceDisruptRaid => 'Contra-redada';

  @override
  String get countryPoliceDisruptRaidDesc =>
      'Golpea un depósito para desordenar su respuesta.';

  @override
  String countryPoliceDisruptCost(String cost) {
    return 'Coste €$cost';
  }

  @override
  String countryPoliceDisruptDropHint(int drop, int minutes) {
    return 'Presión −$drop · Cool ~${minutes}m';
  }

  @override
  String countryPoliceDisruptFailHint(int wanted, int fbi) {
    return 'Fallo: +$wanted Wanted, +$fbi FBI';
  }

  @override
  String get countryPoliceDisruptSuccess =>
      'La presión bajó. Las calles se enfrían un rato.';

  @override
  String get countryPoliceDisruptFailed => 'La op falló. Subió el calor.';

  @override
  String get countryPoliceCoolActive => 'Enfriamiento activo';

  @override
  String get countryPoliceDisabled =>
      'La presión de policía nacional está apagada.';

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
    return 'Apuesta máxima: €$amount';
  }

  @override
  String get casinoFloorPublic => 'Público';

  @override
  String get casinoFloorVip => 'VIP';

  @override
  String get casinoFloorPrivate => 'Privado';

  @override
  String casinoHouseRulesLine(String floor, String maxBet, String rake) {
    return '$floor · apuesta máx. €$maxBet · rake $rake%';
  }

  @override
  String get casinoUpgradeFloor => 'Mejorar planta';

  @override
  String casinoUpgradeFloorTo(String floor, String cost) {
    return 'Mejorar a $floor (€$cost)';
  }

  @override
  String get casinoUpgradeSuccess => 'Planta mejorada';

  @override
  String get casinoUpgradeFailed => 'Mejora fallida';

  @override
  String get casinoStaffTitle => 'Personal';

  @override
  String get casinoStaffHire => 'Contratar';

  @override
  String get casinoStaffFire => 'Despedir';

  @override
  String get casinoStaffDealer => 'Crupier';

  @override
  String get casinoStaffSecurity => 'Seguridad';

  @override
  String get casinoStaffPromoter => 'Promotor';

  @override
  String casinoStaffSalaryPerTick(String amount) {
    return 'Salario €$amount/tick';
  }

  @override
  String get casinoStaffHireSuccess => 'Personal contratado';

  @override
  String get casinoStaffFireSuccess => 'Personal despedido';

  @override
  String get casinoStaffHireFailed => 'Contratación fallida';

  @override
  String get casinoStaffFireFailed => 'Despido fallido';

  @override
  String get casinoTotalRake => 'Rake total:';

  @override
  String casinoLastRaid(String when) {
    return 'Última redada: $when';
  }

  @override
  String casinoRaidDrain(String percent) {
    return 'Drenaje de redada $percent%';
  }

  @override
  String casinoRaidDefense(String percent) {
    return 'Defensa de redada $percent%';
  }

  @override
  String get casinoNoStaffHired => 'Sin personal';
}
