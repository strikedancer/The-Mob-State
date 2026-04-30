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
  String get dashboardTimeoutVehicleTheft => 'robar auto';

  @override
  String get dashboardTimeoutBoatTheft => 'robar barco';

  @override
  String get dashboardTimeoutNightclubSeason => 'Temporada de discotecas';

  @override
  String get dashboardTimeoutAmmo => 'comprar balas';

  @override
  String get dashboardTimeoutShootingRange => 'Campo de tiro';

  @override
  String get dashboardTimeoutGym => 'Gimnasia';

  @override
  String get dashboardInfoDrugsGrams => 'Drogas (gramos)';

  @override
  String get dashboardInfoNightclubs => 'discotecas';

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
  String get travelDirect => 'Directa';

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
  String get quickActions => 'Acciones Rápidas';

  @override
  String get liveEvents => 'Eventos en vivo';

  @override
  String get support => 'Apoyo';

  @override
  String get events => 'Eventos';

  @override
  String get aviation => 'Aviación';

  @override
  String get premiumAndCredits => 'Primas y créditos';

  @override
  String get bank => 'Banco';

  @override
  String get tradeGoods => 'bienes comerciales';

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
  String get tuneShop => 'Tienda de melodías';

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
  String get vaultSubmitStake => 'Enviar apuesta';

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
  String get rankGodfather => 'Padrino';

  @override
  String get dailyGoalTitle_crime_3 => 'cometer 3 crímenes';

  @override
  String get dailyGoalTitle_job_2 => 'trabajar 2 veces';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Robar 1 vehículo';

  @override
  String get dailyGoalTitle_travel_1 => 'Completa 1 viaje';

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
  String get dashboardEconomy24h => 'Economía 24h';

  @override
  String get dashboardGrossIncome => 'Ingreso bruto';

  @override
  String get dashboardPropertySpend => 'Gasto en propiedad';

  @override
  String get dashboardNetCashflow => 'flujo de caja neto';

  @override
  String get dashboardTrendVsPrevious => 'Tendencia vs anterior';

  @override
  String get dashboardActivity7d => 'Actividad 7d';

  @override
  String get dashboardVehicleThefts => 'Robos de vehículos';

  @override
  String get dashboardOpsOverview => 'Descripción general de operaciones';

  @override
  String get dashboardActiveCooldowns => 'Enfriamientos activos';

  @override
  String get dashboardLongestTimer => 'Temporizador más largo';

  @override
  String get dashboardActiveProduction => 'Producción activa';

  @override
  String get dashboardProductionReadyIn => 'Producción lista en';

  @override
  String get dashboardNightclubEvents => 'Eventos de discotecas';

  @override
  String get dashboardNextEventStartsIn => 'El próximo evento comienza en';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Vehículos activos/listados/tránsito';

  @override
  String get dashboardLivePlayerEvents => 'Eventos de jugadores en vivo';

  @override
  String get dashboardOpenEvents => 'Eventos abiertos';

  @override
  String get dashboardNotificationsAndRisk => 'Notificaciones y riesgos';

  @override
  String get dashboardUnreadDm => 'DM no leído';

  @override
  String get dashboardSupportWaitingOnYou => 'Soporte esperando por ti';

  @override
  String get dashboardEventsLast24h => 'Eventos últimas 24h';

  @override
  String get dashboardRiskScore => 'Puntuación de riesgo';

  @override
  String get dashboardRecruitProstitute => 'reclutar prostituta';

  @override
  String get dashboardCrewWars => 'Guerras de tripulaciones';

  @override
  String get dashboardStatusLabel => 'Estado';

  @override
  String get dashboardCanDeclare => 'puede declarar';

  @override
  String get dashboardTypeLabel => 'Tipo';

  @override
  String get dashboardOpponent => 'Adversaria';

  @override
  String get dashboardCrewPoints => 'Puntos de Crew';

  @override
  String get dashboardWarRank => 'rango de guerra';

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
  String get dashboardCrewWarStatusPreparing => 'Preparante';

  @override
  String get dashboardCrewWarStatusActive => 'Activa';

  @override
  String get dashboardCrewWarStatusLockdown => 'Aislamiento';

  @override
  String get dashboardCrewWarStatusResolved => 'Resuelta';

  @override
  String get dashboardCrewWarStatusArchived => 'Archivada';

  @override
  String get dashboardCrewWarStatusCancelled => 'Cancelada';

  @override
  String get dashboardCrewWarStatusNone => 'Sin guerra activa';

  @override
  String get dashboardCrewWarTypeKill => 'matar guerra';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerra económica';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerra territorial';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerra total';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'No configurada';

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
    return 'cada $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Territorio de la Crew';

  @override
  String get dashboardRegions => 'Regiones';

  @override
  String get dashboardCountriesCaptured => 'Países capturados';

  @override
  String get dashboardPayout => 'Pago';

  @override
  String get dashboardEarningPerHour => 'Ganando ahora por hora';

  @override
  String get dashboardEarningPerDay => 'Ganar ahora por día';

  @override
  String get dashboardTotalEarned => 'Total ganado';

  @override
  String get dashboardVehicleOps => 'Operaciones de vehículos';

  @override
  String get dashboardKillProgress => 'Matar el progreso';

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
  String get friends => 'Amigas';

  @override
  String get friendActivity => 'Actividad de amigo';

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
  String get blackMarket => 'Mercado negro';

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
  String get appeal => 'Apelar';

  @override
  String get submitAppeal => 'Enviar apelación';

  @override
  String get bribeJudge => 'Juez de sobornos';

  @override
  String get bribe => 'Soborno';

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
  String get hospitalInfo1 => '• La salud disminuye al cometer delitos';

  @override
  String get hospitalInfo2 => '• Con 0 HP no puedes cometer crímenes';

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
      '• 💚 Curación pasiva: +5 HP cada 5 minutos (si HP > 0)';

  @override
  String get medicalTreatment => 'Tratamiento médico';

  @override
  String get restoreCritical => 'Restaurar +20 HP (condición crítica)';

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
      'Producción iniciada: activo durante 8 horas, reclamo cada 10 minutos';

  @override
  String get ammoFactoryTitle => 'Fábrica de municiones';

  @override
  String get ammoFactoryIntro =>
      'Produce en lotes; reclamas cada 10 minutos (hasta 8 horas de trabajo pendiente por sesión).';

  @override
  String get ammoFactoryWhatYouCanDo => 'Qué puedes hacer:';

  @override
  String get ammoFactoryActionBuy => 'Compra una fábrica en tu país actual';

  @override
  String get ammoFactoryActionProduce =>
      'Producción de reclamos (intervalo: 10 minutos, trabajo pendiente máximo: 8 horas por sesión)';

  @override
  String get ammoFactoryActionOutput =>
      'Actualice la producción al nivel 5 para obtener más rondas por reclamo';

  @override
  String get ammoFactoryActionQuality =>
      'Mejorar la calidad para obtener precios de mercado más fuertes';

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
  String get factoryProduceStatusLabel => 'Estado del producto';

  @override
  String get factoryProduceStatusReady => 'Listo';

  @override
  String get factoryProduceStatusCooldown => 'Enfriarse';

  @override
  String get factorySessionActive =>
      'Ventana de producción: activa (intervalo de 10 min)';

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
  String get shootingTrainSuccess => 'Entrenamiento completa';

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
  String get shootingTrain => 'Tren';

  @override
  String get gym => 'Gimnasia';

  @override
  String get gymTrainSuccess => 'Entrenamiento completa';

  @override
  String gymSessions(String count) {
    return 'Sesiones: $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bonificación de fuerza: $bonus%';
  }

  @override
  String gymCooldown(String time) {
    return 'Próxima sesión a las $time';
  }

  @override
  String get gymTrain => 'Tren';

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
  String get crimeOutcomeSuccess => '¡Crimen exitoso!';

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
  String get jailEscapeSuccess => '🎉 ¡Fuga conseguida! Estás libre.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'Fuga fallida. Condena ampliada $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Fuga fallida';

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
  String schoolTrackCooldownActive(int seconds) {
    return 'Enfriamiento activo: ${seconds}s restantes';
  }

  @override
  String get schoolTrackMaxLevelReached =>
      'La pista ya está en el nivel máximo.';

  @override
  String get schoolTrackStartFailed => 'No se pudo iniciar el entrenamiento';

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
      'Ingresa una ID de jugador para iniciar una rivalidad.';

  @override
  String get rivalryPlayerIdHint => 'ID del jugador';

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
      'Dirige a 3 miembros activos de la tripulación del club nocturno al mismo tiempo.';

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
  String get nightclubSelectCrewMember =>
      'Seleccionar miembro de la tripulación';

  @override
  String get nightclubAssignShift => 'Asignar turno de discoteca';

  @override
  String get nightclubTabActive => 'Activa';

  @override
  String get nightclubTabHistory => 'Historia';

  @override
  String get nightclubNoCrewAssigned => 'Aún no hay tripulación asignada';

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
  String get nightclubAssignCrewSuccess => 'Miembro de la tripulación asignado';

  @override
  String get nightclubRemoveCrewSuccess =>
      'Miembro de la tripulación eliminado';

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
  String get gameScreenUnknownPlayer => 'Desconocido';

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
  String get crimeCriminalRecordWipeDesc =>
      'Falsifica expedientes y borra tu historial criminal completo si la operación tiene éxito.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% de éxito';
  }

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
}
