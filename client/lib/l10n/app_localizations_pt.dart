// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Jogo da Máfia';

  @override
  String get login => 'Conecte-se';

  @override
  String get register => 'Cadastre-se';

  @override
  String get username => 'Nome de usuário';

  @override
  String get password => 'Senha';

  @override
  String get usernameLabel => 'NOME DE USUÁRIO';

  @override
  String get passwordLabel => 'SENHA';

  @override
  String get usernamePlaceholder => 'Nome de usuário';

  @override
  String get passwordPlaceholder => 'Senha';

  @override
  String get loginButton => 'CONECTE-SE';

  @override
  String get registerButton => 'CADASTRE-SE';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get usernameRequired => 'Por favor insira um nome de usuário';

  @override
  String get passwordRequired => 'Por favor insira uma senha';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get invalidCredentials => 'Nome de usuário ou senha incorretos';

  @override
  String get loginSuccessful => 'Login bem-sucedido!';

  @override
  String get registrationSuccessful => 'Cadastro realizado com sucesso!';

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
  String get loginFailed => 'falha no login';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get emailRequired => 'Por favor insira um endereço de e-mail';

  @override
  String get emailInvalid => 'Por favor insira um endereço de e-mail válido';

  @override
  String get forgotPasswordTitle => 'Redefinir senha';

  @override
  String get forgotPasswordDescription =>
      'Digite seu endereço de e-mail e enviaremos um link para redefinir sua senha.';

  @override
  String get resetPasswordButton => 'ENVIAR LINK DE REINICIALIZAÇÃO';

  @override
  String get emailSent => 'Link de redefinição enviado! Verifique seu e-mail.';

  @override
  String get backToLogin => 'Voltar ao Login';

  @override
  String welcome(String username) {
    return 'Bem-vindo, $username!';
  }

  @override
  String get dashboardTimeouts => 'Tempos limite';

  @override
  String get dashboardTimeoutCrime => 'Crime';

  @override
  String get dashboardTimeoutJob => 'Trabalhar';

  @override
  String get dashboardTimeoutTravel => 'Viagem';

  @override
  String get dashboardTimeoutVehicleTheft => 'Roubar carro';

  @override
  String get dashboardTimeoutBoatTheft => 'Roubar barco';

  @override
  String get dashboardTimeoutNightclubSeason => 'Temporada de boates';

  @override
  String get dashboardTimeoutAmmo => 'Comprar munição';

  @override
  String get dashboardTimeoutShootingRange => 'Campo de tiro';

  @override
  String get dashboardTimeoutGym => 'Academia';

  @override
  String get dashboardInfoDrugsGrams => 'Drogas (gramas)';

  @override
  String get dashboardInfoNightclubs => 'Discotecas';

  @override
  String get dashboardInfoNightclubRevenue => 'Receita de boate';

  @override
  String get dashboard => 'Painel';

  @override
  String get crimes => 'Crimes';

  @override
  String get errorLoadingCrimes => 'Falha ao carregar crimes';

  @override
  String connectionError(String error) {
    return 'Erro de conexão: $error';
  }

  @override
  String payRange(String min, String max) {
    return 'Pagamento: €$min - €$max';
  }

  @override
  String requiresRank(String rank) {
    return 'Requer Classificação $rank';
  }

  @override
  String get requiresVehicle => 'Requer veículo';

  @override
  String get federalCrimeWarning => '⚠️ Crime Federal - FBI Heat';

  @override
  String get crimePickpocketName => 'Furtos';

  @override
  String get crimePickpocketDesc => 'Roubar carteiras de transeuntes';

  @override
  String get crimeShopliftName => 'Furto em lojas';

  @override
  String get crimeShopliftDesc => 'Roubar mercadorias de uma loja';

  @override
  String get crimeStealBikeName => 'Roubar bicicleta';

  @override
  String get crimeStealBikeDesc => 'Roube uma bicicleta de um rack';

  @override
  String get crimeCarTheftName => 'Roubo de carro';

  @override
  String get crimeCarTheftDesc => 'Roubar um carro estacionado';

  @override
  String get crimeBurglaryName => 'Roubo';

  @override
  String get crimeBurglaryDesc => 'Invadir uma casa';

  @override
  String get crimeRobStoreName => 'Roubo de loja';

  @override
  String get crimeRobStoreDesc => 'Roube uma pequena loja';

  @override
  String get crimeMugPersonName => 'Assalto';

  @override
  String get crimeMugPersonDesc => 'Assaltar alguém na rua';

  @override
  String get crimeStealCarPartsName => 'Roubar peças de carro';

  @override
  String get crimeStealCarPartsDesc => 'Roube peças de carros estacionados';

  @override
  String get crimeHijackTruckName => 'Seqüestrar caminhão';

  @override
  String get crimeHijackTruckDesc =>
      'Sequestrar um caminhão que transportava mercadorias';

  @override
  String get crimeAtmTheftName => 'Roubo de caixa eletrônico';

  @override
  String get crimeAtmTheftDesc => 'Invadir um caixa eletrônico';

  @override
  String get crimeJewelryHeistName => 'Roubo de joias';

  @override
  String get crimeJewelryHeistDesc => 'Roube um joalheiro';

  @override
  String get crimeVandalismName => 'Vandalismo';

  @override
  String get crimeVandalismDesc => 'Danos à propriedade por dinheiro';

  @override
  String get crimeGraffitiName => 'Grafite';

  @override
  String get crimeGraffitiDesc => 'Pulverize grafites para gangues locais';

  @override
  String get crimeDrugDealSmallName => 'Pequeno negócio de drogas';

  @override
  String get crimeDrugDealSmallDesc => 'Venda uma pequena quantidade de drogas';

  @override
  String get crimeDrugDealLargeName => 'Grande negócio de drogas';

  @override
  String get crimeDrugDealLargeDesc => 'Vender uma grande quantidade de drogas';

  @override
  String get crimeExtortionName => 'Extorsão';

  @override
  String get crimeExtortionDesc => 'Extorquir dinheiro de empresas locais';

  @override
  String get crimeKidnappingName => 'Sequestro';

  @override
  String get crimeKidnappingDesc => 'Sequestrar alguém para obter resgate';

  @override
  String get crimeArsonName => 'Incêndio criminoso';

  @override
  String get crimeArsonDesc => 'Colocar fogo em um prédio';

  @override
  String get crimeSmugglingName => 'Contrabando';

  @override
  String get crimeSmugglingDesc =>
      'Contrabandear mercadorias através da fronteira';

  @override
  String get crimeAssassinationName => 'Assassinato';

  @override
  String get crimeAssassinationDesc => 'Realizar um assassinato por encomenda';

  @override
  String get crimeHackAccountName => 'Hackear conta';

  @override
  String get crimeHackAccountDesc => 'Hackear uma conta bancária';

  @override
  String get crimeCounterfeitMoneyName => 'Dinheiro Falsificado';

  @override
  String get crimeCounterfeitMoneyDesc => 'Ganhe dinheiro falso';

  @override
  String get crimeIdentityTheftName => 'Roubo de identidade';

  @override
  String get crimeIdentityTheftDesc =>
      'Roubar a identidade de alguém por fraude';

  @override
  String get crimeRobArmoredTruckName => 'Assalto a caminhão blindado';

  @override
  String get crimeRobArmoredTruckDesc => 'Roube um caminhão blindado';

  @override
  String get crimeArtTheftName => 'Roubo de arte';

  @override
  String get crimeArtTheftDesc => 'Roube obras de arte valiosas';

  @override
  String get crimeProtectionRacketName => 'Raquete de Proteção';

  @override
  String get crimeProtectionRacketDesc =>
      'Faça as empresas pagarem dinheiro de proteção';

  @override
  String get crimeCasinoHeistName => 'Assalto ao Cassino';

  @override
  String get crimeCasinoHeistDesc => 'Roubar um cassino';

  @override
  String get crimeBankRobberyName => 'Assalto a banco';

  @override
  String get crimeBankRobberyDesc => 'Roubar um banco';

  @override
  String get crimeStealYachtName => 'Roubar iate';

  @override
  String get crimeStealYachtDesc => 'Roube um iate de luxo';

  @override
  String get crimeCorruptOfficialName => 'Oficial de suborno';

  @override
  String get crimeCorruptOfficialDesc =>
      'Suborne um funcionário para obter favores';

  @override
  String get crimeEliminateWitnessName => 'Eliminar Testemunha';

  @override
  String get crimeEliminateWitnessDesc =>
      'Eliminar uma testemunha antes do julgamento';

  @override
  String get crimeDiamondHeistName => 'Assalto ao transporte de diamantes';

  @override
  String get crimeDiamondHeistDesc =>
      'Sequestrar um transporte de diamantes brutos';

  @override
  String get crimeEvidenceRoomHeistName => 'Assalto à Sala de Evidências';

  @override
  String get crimeEvidenceRoomHeistDesc =>
      'Roubar evidências de um depósito federal';

  @override
  String get crimeMuseumHeistName => 'Assalto ao Museu';

  @override
  String get crimeMuseumHeistDesc => 'Roube artefatos valiosos de um museu';

  @override
  String get crimeBossAssassinationName => 'Assassinato de chefe rival';

  @override
  String get crimeBossAssassinationDesc =>
      'Elimine o líder de uma organização rival';

  @override
  String get crimeCriminalRecordWipeName => 'Limpar registro criminal';

  @override
  String get tooltipCrimeRequiresTools => 'Ferramentas necessárias';

  @override
  String get tooltipCrimeRequiresVehicle => 'Veículo necessário';

  @override
  String get tooltipCrimeRequiresDrugs => 'Medicamentos necessários';

  @override
  String get tooltipCrimeHighValue => 'Operação de alto valor';

  @override
  String get tooltipCrimeRequiresViolence => 'Violência necessária';

  @override
  String get tooltipCrimeRequiresWeapon => 'Arma necessária';

  @override
  String get tooltipCrimeRequirementsHeading => 'Obrigatória:';

  @override
  String get crimeCriminalRecordWipeTooltip =>
      'Limpa todo o seu registo criminal em caso de sucesso. Disponível apenas se você já tiver convicções.';

  @override
  String crimeErrorDrugsRequired(String quantity, String drugs) {
    return 'Você precisa de pelo menos ${quantity}g de: $drugs';
  }

  @override
  String get jobs => 'Empregos';

  @override
  String get errorLoadingJobs => 'Falha ao carregar trabalhos';

  @override
  String get jobNewspaperDeliveryName => 'Entrega de jornais';

  @override
  String get jobNewspaperDeliveryDesc => 'Entregar jornais de manhã cedo';

  @override
  String get jobCarWashName => 'Lavagem de carro';

  @override
  String get jobCarWashDesc => 'Lave carros no lava-rápido';

  @override
  String get jobGroceryBaggerName => 'Ensacador de supermercado';

  @override
  String get jobGroceryBaggerDesc => 'Prateleiras de estoque no supermercado';

  @override
  String get jobDishwasherName => 'Máquina de lavar louça';

  @override
  String get jobDishwasherDesc => 'Lave pratos em um restaurante';

  @override
  String get jobStreetSweeperName => 'Varredor de rua';

  @override
  String get jobStreetSweeperDesc => 'Varrer as ruas limpas';

  @override
  String get jobPizzaDeliveryName => 'Entrega de pizza';

  @override
  String get jobPizzaDeliveryDesc => 'Entregue pizzas na cidade';

  @override
  String get jobTaxiDriverName => 'Taxista';

  @override
  String get jobTaxiDriverDesc => 'Dirija um táxi pela cidade';

  @override
  String get jobWarehouseWorkerName => 'Trabalhador de armazém';

  @override
  String get jobWarehouseWorkerDesc => 'Trabalhar em um armazém';

  @override
  String get jobConstructionWorkerName => 'Trabalhador da Construção Civil';

  @override
  String get jobConstructionWorkerDesc => 'Trabalhar em um canteiro de obras';

  @override
  String get jobBartenderName => 'Barwoman';

  @override
  String get jobBartenderDesc => 'Despeje cerveja e misture coquetéis';

  @override
  String get jobSecurityGuardName => 'Guarda de segurança';

  @override
  String get jobSecurityGuardDesc => 'Guardar um prédio';

  @override
  String get jobTruckDriverName => 'Motorista de caminhão';

  @override
  String get jobTruckDriverDesc => 'Dirija um caminhão por longas distâncias';

  @override
  String get jobMechanicName => 'Mecânica';

  @override
  String get jobMechanicDesc => 'Reparar carros em uma garagem';

  @override
  String get jobElectricianName => 'Eletricista';

  @override
  String get jobElectricianDesc => 'Instalar e reparar sistemas elétricos';

  @override
  String get jobPlumberName => 'Encanadora';

  @override
  String get jobPlumberDesc => 'Reparar canos e encanamentos';

  @override
  String get jobChefName => 'Cozinheira';

  @override
  String get jobChefDesc => 'Cozinhe em um restaurante';

  @override
  String get jobParamedicName => 'Paramédica';

  @override
  String get jobParamedicDesc => 'Ajude as pessoas necessitadas';

  @override
  String get jobProgrammerName => 'Programadora';

  @override
  String get jobProgrammerDesc => 'Escreva software para empresas';

  @override
  String get jobAccountantName => 'Contadora';

  @override
  String get jobAccountantDesc => 'Gerenciar finanças para empresas';

  @override
  String get jobLawyerName => 'Advogada';

  @override
  String get jobLawyerDesc => 'Defender clientes em tribunal';

  @override
  String get jobRealEstateAgentName => 'Agente Imobiliário';

  @override
  String get jobRealEstateAgentDesc => 'Vender casas e edifícios';

  @override
  String get jobStockbrokerName => 'Corretor de bolsa';

  @override
  String get jobStockbrokerDesc => 'Ações comerciais';

  @override
  String get jobDoctorName => 'Doutor';

  @override
  String get jobDoctorDesc => 'Tratar pacientes no hospital';

  @override
  String get jobAirlinePilotName => 'Pilota';

  @override
  String get jobAirlinePilotDesc => 'Voe em aviões de passageiros';

  @override
  String jobSuccessChancePercent(String percent) {
    return '$percent% de chance';
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
  String get travel => 'Viagem';

  @override
  String get errorLoadingCountries => 'Falha ao carregar países';

  @override
  String get currentLocation => 'Localização atual';

  @override
  String get current => 'Atual';

  @override
  String get travelTo => 'Viagem';

  @override
  String travelCost(String amount) {
    return 'Custo: €$amount';
  }

  @override
  String get travelJourneyTitle => 'Iniciar jornada?';

  @override
  String get travelRouteLabel => 'Rota:';

  @override
  String travelLegsLabel(String count) {
    return 'Pernas: $count';
  }

  @override
  String travelCostPerLeg(String amount) {
    return 'Custo por percurso: €$amount';
  }

  @override
  String travelTotalCost(String amount) {
    return 'Custo total: €$amount';
  }

  @override
  String travelCooldownPerLeg(String minutes) {
    return 'Tempo de espera: $minutes min por perna';
  }

  @override
  String get travelRiskPerLeg =>
      'Risco: por perna (pode ser preso e perder todos os bens)';

  @override
  String get travelStart => 'Começar';

  @override
  String travelInTransitTo(String country) {
    return 'Em trânsito para $country';
  }

  @override
  String travelLegProgress(String current, String total) {
    return 'Perna $current/$total';
  }

  @override
  String travelNextStop(String country) {
    return 'Próxima parada: $country';
  }

  @override
  String get travelContinue => 'Continuar';

  @override
  String get travelCancelJourney => 'Cancelar viagem';

  @override
  String get travelJourneyCanceled => 'Viagem cancelada';

  @override
  String get travelNotInTransit => 'Você não está em uma jornada.';

  @override
  String get travelDirect => 'Direta';

  @override
  String travelVia(String countries) {
    return 'através de $countries';
  }

  @override
  String travelLegsCount(String count) {
    return '$count pernas';
  }

  @override
  String jailRemainingMinutes(String minutes) {
    return 'Você está na prisão por mais $minutes minutos';
  }

  @override
  String travelSuccessTo(String country) {
    return 'Viajei para $country!';
  }

  @override
  String travelConfiscated(String quantity, String item) {
    return '🚨 $quantity itens $item confiscados!';
  }

  @override
  String travelDamaged(String item, String percent) {
    return '⚠️ $item danificado ($percent% perda de valor)!';
  }

  @override
  String get countryNetherlands => 'Holanda';

  @override
  String get countryBelgium => 'Bélgica';

  @override
  String get countryGermany => 'Alemanha';

  @override
  String get countryFrance => 'França';

  @override
  String get countrySpain => 'Espanha';

  @override
  String get countryItaly => 'Itália';

  @override
  String get countryUk => 'Reino Unido';

  @override
  String get countrySwitzerland => 'Suíça';

  @override
  String get crew => 'Crew';

  @override
  String get profile => 'Perfil';

  @override
  String get logout => 'Sair';

  @override
  String get logOut => 'Sair';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Conta';

  @override
  String get userAccountMenuTooltip => 'Menu da conta';

  @override
  String get messages => 'Mensagens';

  @override
  String get noDirectMessagesYet => 'Nenhuma mensagem ainda';

  @override
  String get sendMessageToFriendsHint => 'Envie uma mensagem para seus amigos!';

  @override
  String errorLoadingConversations(String error) {
    return 'Erro ao carregar conversas: $error';
  }

  @override
  String get messageSystemBadge => 'SISTEMA';

  @override
  String get messageSystemInboxPreview => 'Conquistas e mensagens do sistema';

  @override
  String get messageSystemThreadSubtitle => 'Conquistas e mensagens do sistema';

  @override
  String get messageSystemThreadEmptyDetail =>
      'Conquistas e mensagens do sistema aparecem aqui automaticamente.';

  @override
  String get messageSendFirst => 'Envie a primeira mensagem!';

  @override
  String chatFriendRankLine(int rank) {
    return '★ Classificação $rank';
  }

  @override
  String errorLoadingMessages(String error) {
    return 'Erro ao carregar mensagens: $error';
  }

  @override
  String get messageDeleteOwnOnly =>
      'Você só pode excluir suas próprias mensagens';

  @override
  String get messageDeleteTitle => 'Excluir mensagem';

  @override
  String get messageDeleteBody =>
      'Esta mensagem será excluída permanentemente.';

  @override
  String get messageSendFailed => 'Falha ao enviar mensagem';

  @override
  String get messageDeleteFailed => 'Falha ao excluir mensagem';

  @override
  String get investigationWindowExpired =>
      'A janela de investigação expirou (24 horas).';

  @override
  String get investigationStartedInboxHint =>
      'A investigação começou. Verifique sua caixa de entrada para o relatório do detetive.';

  @override
  String get investigationAlreadyInProgress =>
      'Esta investigação já está em andamento ou concluída.';

  @override
  String investigationStartFailed(String error) {
    return 'Falha ao iniciar a investigação: $error';
  }

  @override
  String get investigationExpired => 'A investigação expirou';

  @override
  String get investigationStarted => 'Investigação iniciada';

  @override
  String get investigationStarting => 'Começando...';

  @override
  String get startMurderInvestigation => 'Iniciar investigação de assassinato';

  @override
  String get systemMessagesReadOnlyHint =>
      'As mensagens do sistema não podem ser respondidas';

  @override
  String get helpAndGuide => 'Ajuda e Guia';

  @override
  String get helpUiManualTitle => 'Manual do jogo';

  @override
  String get helpUiSearchHint => 'Pesquise por módulo, explicação ou dica';

  @override
  String get helpUiTopicLabel => 'Tópico';

  @override
  String get helpUiAllChip => 'Todos';

  @override
  String get helpUiNoResultsTitle => 'Nenhum tópico encontrado';

  @override
  String get helpUiNoResultsBody =>
      'Altere sua pesquisa ou categoria para ver os resultados novamente.';

  @override
  String get helpUiHowItWorks => 'Como funciona';

  @override
  String get helpUiTips => 'Dicas';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get liveEvents => 'Eventos ao vivo';

  @override
  String get support => 'Suporte';

  @override
  String get events => 'Eventos';

  @override
  String get aviation => 'Aviação';

  @override
  String get premiumAndCredits => 'Prêmio e Créditos';

  @override
  String get bank => 'Banco';

  @override
  String get tradeGoods => 'Mercadorias comerciais';

  @override
  String get drugs => 'Drogas';

  @override
  String get nightclub => 'Boate';

  @override
  String get crypto => 'Criptografia';

  @override
  String get smuggling => 'Contrabando';

  @override
  String get tools => 'ferramentas';

  @override
  String get vehicleHeist => 'Assalto a veículos';

  @override
  String get vehicleHeistTitle => 'Assalto a veículos';

  @override
  String get vehicleHeistTabSubtitleCar => 'Roube carros por dinheiro e peças.';

  @override
  String get vehicleHeistTabSubtitleMotorcycle =>
      'Roube motocicletas em troca de dinheiro e peças.';

  @override
  String get vehicleHeistTabSubtitleBoat =>
      'Roube barcos em troca de dinheiro e peças.';

  @override
  String get vehicleHeistReady => 'Preparar';

  @override
  String get vehicleHeistMotorStorage => 'Armazenamento de motocicleta';

  @override
  String get vehicleHeistCapacityPolicyCar =>
      'A capacidade dos carros é compartilhada entre todos os assaltos a carros.';

  @override
  String get vehicleHeistCapacityPolicyMotorcycle =>
      'A capacidade das motocicletas é compartilhada em todos os assaltos a motocicletas.';

  @override
  String get vehicleHeistCapacityPolicyBoat =>
      'A capacidade do barco é compartilhada entre todos os assaltos a barcos.';

  @override
  String vehicleHeistRankRequired(String rank) {
    return 'Classificação necessária: $rank';
  }

  @override
  String vehicleHeistCapacityLine(String stored, String total, String level) {
    return 'Armazenamento: $stored/$total (nível da pista $level)';
  }

  @override
  String get vehicleHeistStealCar => 'Roubar carro';

  @override
  String get vehicleHeistStealMotorcycle => 'Roubar motocicleta';

  @override
  String get vehicleHeistStealBoat => 'Roubar barco';

  @override
  String get vehicleHeistGenericVehicle => 'veículo';

  @override
  String vehicleHeistSuccessStolen(String vehicle) {
    return 'Sucesso: $vehicle roubado.';
  }

  @override
  String vehicleHeistCooldownActive(String duration) {
    return 'Tempo de espera ativo: $duration';
  }

  @override
  String vehicleHeistArrested(String minutes) {
    return 'Você foi preso ($minutes min de prisão).';
  }

  @override
  String get vehicleHeistUntil => 'até';

  @override
  String get vehicleHeistRegionalLockActive => 'Bloqueio regional ativo.';

  @override
  String get vehicleHeistStealFailed => 'Falha na ação de roubo.';

  @override
  String get vehicleHeistUpgradeCompleted => 'Atualização concluída.';

  @override
  String get vehicleHeistUpgradeFailed => 'Falha na atualização.';

  @override
  String get vehicleHeistCatalogTitleCars => 'Carros disponíveis';

  @override
  String get vehicleHeistCatalogTitleMotorcycles => 'Motocicletas disponíveis';

  @override
  String get vehicleHeistCatalogTitleBoats => 'Barcos disponíveis';

  @override
  String get vehicleHeistCatalogEmpty => 'Nenhum veículo neste catálogo.';

  @override
  String get vehicleHeistRarityCommon => 'Comum';

  @override
  String get vehicleHeistRarityUncommon => 'Incomum';

  @override
  String get vehicleHeistRarityRare => 'Crua';

  @override
  String get vehicleHeistRarityEpic => 'Épica';

  @override
  String get vehicleHeistRarityLegendary => 'Lendária';

  @override
  String get vehicleHeistEventOnlyTag => 'Somente evento';

  @override
  String vehicleHeistCatalogValue(String value) {
    return 'Valor: $value';
  }

  @override
  String vehicleHeistCatalogRank(String rank) {
    return 'Classificação: $rank';
  }

  @override
  String vehicleHeistCatalogInGameAvailability(String label) {
    return 'Disponibilidade no jogo: $label';
  }

  @override
  String vehicleHeistCatalogMostCommonIn(String country) {
    return 'Mais comum em: $country';
  }

  @override
  String vehicleHeistCatalogCountries(String countries) {
    return 'Países: $countries';
  }

  @override
  String vehicleHeistUpgradeCost(String cost) {
    return 'Atualizar ($cost)';
  }

  @override
  String vehicleHeistUpgradeRankRequired(String rank) {
    return 'Atualização bloqueada: classificação $rank necessária';
  }

  @override
  String get vehicleHeistUpgradeLocked => 'Atualização bloqueada';

  @override
  String vehicleHeistSpeedUpWithCredits(String credits) {
    return 'Acelere para $credits créditos';
  }

  @override
  String get vehicleHeistSpeedUpWithCreditsNextScreen =>
      'Acelerar (próxima tela)';

  @override
  String get vehicleHeistExpand => 'Expandir';

  @override
  String get vehicleHeistCollapse => 'Colapso';

  @override
  String get vehicleHeistActive => 'ATIVA';

  @override
  String get vehicleHeistOff => 'desligada';

  @override
  String get catalog => 'Catálogo';

  @override
  String get vehicleHeistOpsHotspotRunButton => 'Executar ponto de acesso';

  @override
  String get vehicleHeistOpsHotspotRunTitle => 'Execução de ponto de acesso';

  @override
  String vehicleHeistOpsHotspotSuccess(String reward) {
    return 'Execução do hotspot concluída: +$reward';
  }

  @override
  String vehicleHeistOpsHotspotCooldownActive(String duration) {
    return 'Recarga do ponto de acesso ativo ($duration)';
  }

  @override
  String get vehicleHeistOpsHotspotFailedHeatIncreased =>
      'O ponto de acesso falhou. O calor aumentou.';

  @override
  String get vehicleHeistOpsCrewOpButton => 'Operação da Crew';

  @override
  String get vehicleHeistOpsCrewOpTitle => 'Operação da Crew';

  @override
  String vehicleHeistOpsCrewSuccess(String reward) {
    return 'Operação da Crew concluída: você ganhou $reward';
  }

  @override
  String get vehicleHeistOpsCrewRequired => 'É necessária Crew.';

  @override
  String vehicleHeistOpsCrewCooldownActive(String duration) {
    return 'Tempo de espera da operação da Crew ativo ($duration)';
  }

  @override
  String get vehicleHeistOpsCrewFailed => 'A operação da Crew falhou.';

  @override
  String get vehicleHeistOpsCrewJoinToUnlock =>
      'Junte-se a uma Crew para desbloquear ações da Crew';

  @override
  String get vehicleHeistOpsCrewRequiredYes => 'Crew necessária: sim';

  @override
  String get vehicleHeistOpsCrewRequiredNoJoinFirst =>
      'Crew necessária: não (junte-se a uma Crew primeiro)';

  @override
  String get vehicleHeistOpsBuyPartsButton => 'Comprar peças';

  @override
  String get vehicleHeistOpsBuyPartsTitle => 'Compre peças';

  @override
  String vehicleHeistOpsBuyPartsPrompt(String type) {
    return 'Comprar quais peças? ($type)';
  }

  @override
  String vehicleHeistOpsPartsPurchased(String cost) {
    return 'Peças compradas: -$cost';
  }

  @override
  String get vehicleHeistOpsPartsPurchaseFailed => 'Falha na compra de peças.';

  @override
  String get vehicleHeistOpsClaimContractButton => 'Contrato de reivindicação';

  @override
  String get vehicleHeistOpsClaimContractTitle => 'Contrato de reivindicação';

  @override
  String vehicleHeistOpsChopContractCompleted(String reward) {
    return 'Contrato concluído: +$reward';
  }

  @override
  String get vehicleHeistOpsChopNoEligibleVehicle =>
      'Nenhum veículo elegível em estoque para este contrato.';

  @override
  String vehicleHeistOpsChopContractCooldownActive(String duration) {
    return 'Recarga do contrato ativa ($duration)';
  }

  @override
  String get vehicleHeistOpsChopContractClaimFailed =>
      'A reivindicação do contrato falhou.';

  @override
  String get vehicleHeistOpsInsuranceButton => 'Seguro';

  @override
  String get vehicleHeistOpsInsuranceTitle => 'Seguro contrabando';

  @override
  String get vehicleHeistOpsInsuranceBody =>
      'Escolha um nível de cobertura para esta categoria de veículo.';

  @override
  String get vehicleHeistOpsInsuranceTierBasic => 'Básica';

  @override
  String get vehicleHeistOpsInsuranceTierPro => 'Pró';

  @override
  String vehicleHeistOpsInsuranceActive(String tier, String price) {
    return 'Seguro ativo ($tier) por $price.';
  }

  @override
  String get vehicleHeistOpsInsurancePurchaseFailed =>
      'Falha na compra do seguro.';

  @override
  String get vehicleHeistOpsCrewMatchButton => 'Partida da Crew';

  @override
  String vehicleHeistOpsCrewMatchWon(String reward) {
    return 'Partida da Crew vencida: +$reward';
  }

  @override
  String vehicleHeistOpsCrewMatchLost(String reward) {
    return 'Partida da Crew perdida: +$reward consolação';
  }

  @override
  String get vehicleHeistOpsCrewMatchFailed => 'A combinação da Crew falhou.';

  @override
  String get vehicleHeistOpsCounterButton => 'Contadora';

  @override
  String vehicleHeistOpsCounterSuccess(String reward) {
    return 'Sucesso na contra-interceptação: +$reward';
  }

  @override
  String get vehicleHeistOpsCounterFailed =>
      'Contra-interceptação indisponível ou com falha.';

  @override
  String get vehicleHeistOpsOpsContractButton => 'Contrato de operações';

  @override
  String get vehicleHeistOpsOpsContractTitle => 'Contrato de operações';

  @override
  String vehicleHeistOpsContractCompleted(String reward) {
    return 'Contrato de operações concluído: +$reward';
  }

  @override
  String get vehicleHeistOpsContractFailedOrCooldown =>
      'O contrato de operações falhou ou está em espera.';

  @override
  String get vehicleHeistOpsClaimDisputeButton => 'Disputa de reivindicação';

  @override
  String get vehicleHeistOpsNoOpenClaims =>
      'Nenhuma reclamação de seguro aberta.';

  @override
  String get vehicleHeistOpsNoValidClaimFound =>
      'Nenhuma reivindicação válida encontrada.';

  @override
  String vehicleHeistOpsClaimApproved(String amount) {
    return 'Reivindicação aprovada: +$amount';
  }

  @override
  String vehicleHeistOpsClaimRejected(String amount) {
    return 'Reivindicação rejeitada: -$amount';
  }

  @override
  String get vehicleHeistOpsClaimResolutionFailed =>
      'Falha na resolução da reivindicação.';

  @override
  String get vehicleHeistOpsIntelTitle =>
      'Inteligência de operações de veículos';

  @override
  String get vehicleHeistOpsIntelRefreshTooltip => 'Atualizar inteligência';

  @override
  String get vehicleHeistOpsIntelTapToExpand =>
      'Toque para expandir e visualizar todas as ações.';

  @override
  String vehicleHeistOpsIntelHeatPill(String current, String level) {
    return 'Calor $current ($level)';
  }

  @override
  String vehicleHeistOpsIntelPolicePill(String name) {
    return 'Polícia: $name';
  }

  @override
  String vehicleHeistOpsIntelRepPill(String level) {
    return 'Nível de representante $level';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketPill(String trend) {
    return 'Mercado de peças: $trend';
  }

  @override
  String vehicleHeistOpsIntelHotspotLine(String name) {
    return 'Ponto de acesso: $name';
  }

  @override
  String vehicleHeistOpsIntelHotspotRewardLine(String min, String max) {
    return 'Recompensa: $min - $max';
  }

  @override
  String get vehicleHeistOpsIntelWhyCashLine =>
      'Por que você recebe dinheiro: ações operacionais bem-sucedidas são pagas diretamente no dinheiro da carteira.';

  @override
  String vehicleHeistOpsIntelCashRangePayout(String min, String max) {
    return 'Dinheiro: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelYouCashRangePayout(String min, String max) {
    return 'Você: $min - $max';
  }

  @override
  String vehicleHeistOpsIntelCashPayout(String amount) {
    return 'Dinheiro: $amount';
  }

  @override
  String vehicleHeistOpsIntelContractsPayout(String count, String fromPart) {
    return 'Contratos: $count$fromPart';
  }

  @override
  String vehicleHeistOpsIntelContractsFrom(String amount) {
    return '| de $amount';
  }

  @override
  String vehicleHeistOpsIntelPartsPricesLine(
    String car,
    String motorcycle,
    String boat,
  ) {
    return 'Preços das peças (carro/moto/barco): $car / $motorcycle / $boat';
  }

  @override
  String vehicleHeistOpsIntelPartsMarketRefreshLine(String cooldown) {
    return 'Atualização do mercado de peças: $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCrewLine(String name, String size) {
    return 'Crew: $name ($size membros)';
  }

  @override
  String vehicleHeistOpsIntelChopRewardLine(String reward) {
    return 'Corte a recompensa do contrato: $reward';
  }

  @override
  String vehicleHeistOpsIntelInterceptWindowLine(String status) {
    return 'Janela de interceptação: $status';
  }

  @override
  String vehicleHeistOpsIntelBlacklistLine(String reason) {
    return 'Lista negra: $reason';
  }

  @override
  String get vehicleHeistOpsIntelBlacklistNoneLine => 'Lista negra: nenhuma';

  @override
  String vehicleHeistOpsIntelInsuranceActiveLine(String tier) {
    return 'Seguro: $tier ativo';
  }

  @override
  String get vehicleHeistOpsIntelInsuranceInactiveLine => 'Seguro: inativo';

  @override
  String vehicleHeistOpsIntelCountryModifierLine(
    String name,
    String multiplier,
  ) {
    return 'Modificador de país: $name (${multiplier}x)';
  }

  @override
  String vehicleHeistOpsIntelCrewSeasonLine(String season, String points) {
    return 'Temporada da Crew: $season | pontos $points';
  }

  @override
  String vehicleHeistOpsIntelContractsCooldownLine(
    String count,
    String cooldown,
  ) {
    return 'Contratos: $count | tempo de espera $cooldown';
  }

  @override
  String vehicleHeistOpsIntelCounterCooldownLine(
    String cooldown,
    String claims,
  ) {
    return 'Tempo de espera do contador: $cooldown | reivindicações abertas: $claims';
  }

  @override
  String get tuneShop => 'Loja de músicas';

  @override
  String get tuneShopIntro =>
      'Sucateie veículos em busca de peças e atualize velocidade, furtividade e armadura. As peças são compartilhadas por categoria (carro/moto/barco), para que você possa tunar qualquer veículo dentro da mesma categoria.';

  @override
  String get tuneShopCarPartsLabel => 'Peças de carro';

  @override
  String get tuneShopMotorcyclePartsLabel => 'Peças de motocicleta';

  @override
  String get tuneShopBoatPartsLabel => 'Peças de barco';

  @override
  String get tuneShopEmptyTitle => 'Nenhum veículo disponível para ajuste';

  @override
  String get tuneShopEmptyBody =>
      'Roube alguns veículos primeiro e desfaça alguns para obter peças.';

  @override
  String get tuneShopVehicleTypeCar => 'Carro';

  @override
  String get tuneShopVehicleTypeMotorcycle => 'Motocicleta';

  @override
  String get tuneShopVehicleTypeBoat => 'Barco';

  @override
  String get tuneShopStatSpeed => 'Velocidade';

  @override
  String get tuneShopStatStealth => 'Furtiva';

  @override
  String get tuneShopStatArmor => 'Armadura';

  @override
  String get tuneShopValueMultiplierPrefix => 'Valor x';

  @override
  String get tuneShopUpgradeButton => 'Atualizar';

  @override
  String get tuneShopMaxLabel => 'MÁX.';

  @override
  String get tuneShopPartsAbbrev => 'pontos';

  @override
  String get tuneShopUpgradeCompleted => 'Atualização concluída';

  @override
  String get tuneShopUpgradeFailed => 'Falha na atualização';

  @override
  String get tuneShopLockedVehicleInTransit =>
      'Tuning bloqueado: o veículo está em trânsito.';

  @override
  String get tuneShopLockedVehicleInRepair =>
      'Tuning bloqueado: o veículo está em reparo.';

  @override
  String tuneShopLockedCooldownActive(String duration) {
    return 'Tempo de espera do ajuste ativo: $duration restantes.';
  }

  @override
  String get tuneShopErrorVehicleNotFound => 'Veículo não encontrado';

  @override
  String get tuneShopErrorNotOwner => 'Você não possui este veículo';

  @override
  String get tuneShopErrorVehicleInTransit =>
      'Tuning bloqueado: o veículo está em trânsito.';

  @override
  String get tuneShopErrorVehicleInRepair =>
      'Tuning bloqueado: o veículo está em reparo.';

  @override
  String get tuneShopErrorInsufficientFunds => 'Não há dinheiro suficiente';

  @override
  String get tuneShopErrorInsufficientParts => 'Peças insuficientes';

  @override
  String get tuneShopErrorStatMaxed => 'Este nível de ajuste está no máximo';

  @override
  String tuneShopErrorCooldownActive(String duration) {
    return 'Tempo de espera do ajuste ativo: $duration restantes.';
  }

  @override
  String tuneShopErrorConcurrencyLimit(String max, String active) {
    return 'Limite atingido: máximo de $max ajuste simultâneo, atualmente $active.';
  }

  @override
  String get tuneShopErrorInvalidStat => 'Estatística de ajuste inválida';

  @override
  String get territory => 'Território';

  @override
  String get achievements => 'Conquistas';

  @override
  String get menuCrackVault => 'Quebrar o cofre';

  @override
  String get vaultHeroTagline => 'Adivinhe o código e ganhe grandes prêmios.';

  @override
  String vaultSeasonLabel(String range) {
    return 'Temporada: $range';
  }

  @override
  String get vaultYourCredits => 'Seus créditos';

  @override
  String get vaultChooseStake => 'Escolha sua aposta';

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
    return 'Prêmio esperado: +$reward créditos';
  }

  @override
  String get vaultCodeLabel => 'Código';

  @override
  String get vaultSubmitStake => 'Apostar';

  @override
  String get vaultWrongCodesTitle => 'Códigos errados (este mês)';

  @override
  String get vaultShowWrongCodes => 'Mostrar';

  @override
  String get vaultHideWrongCodes => 'Ocultar';

  @override
  String get vaultNoWrongCodesYet => 'Nenhum código errado salvo ainda.';

  @override
  String get couldNotLoadVaultStatus => 'Não foi possível carregar o status.';

  @override
  String get vaultEnterFourDigitCode => 'Digite um código de 4 dígitos.';

  @override
  String get vaultAttemptSuccessGeneric => 'Sucesso.';

  @override
  String get vaultAttemptFailedGeneric => 'Falhou.';

  @override
  String get vaultAttemptFailedRetry => 'Falhou. Tente novamente.';

  @override
  String dashboardNewMessagesCount(int count) {
    return '$count novas mensagens';
  }

  @override
  String get rankProgress => 'Progresso de classificação';

  @override
  String get cash => 'Dinheiro';

  @override
  String get sessionRecap => 'Recapitulação da sessão';

  @override
  String get nameLabel => 'Nome';

  @override
  String get countryLabel => 'País';

  @override
  String get wantedLevel => 'Nível de procurado';

  @override
  String get fbiHeat => 'Calor do FBI';

  @override
  String get properties => 'Propriedades';

  @override
  String get vehicles => 'Veículos';

  @override
  String get netWorth => 'Patrimônio líquido';

  @override
  String get securityLabel => 'Segurança';

  @override
  String get noSecurity => 'Sem segurança';

  @override
  String get weaponLabel => 'Arma';

  @override
  String get vehicleLabel => 'Veículo';

  @override
  String get none => 'Nenhum';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get breakouts => 'Detalhamentos';

  @override
  String get murders => 'Assassinatos';

  @override
  String get hitlistContracts => 'Contratos de lista de sucessos';

  @override
  String get carsStolen => 'Carros roubados';

  @override
  String get boatsStolen => 'Barcos roubados';

  @override
  String get crimeAttempts => 'Tentativas de crime';

  @override
  String get successful => 'Bem-sucedida';

  @override
  String get jobAttempts => 'Tentativas de trabalho';

  @override
  String get streetProstitutes => 'Prostitutas de rua';

  @override
  String get rldProstitutes => 'Prostitutas RLD';

  @override
  String get travels => 'Viagens';

  @override
  String get bullets => 'Marcadores';

  @override
  String get moneyStatusLabel => 'Status do dinheiro';

  @override
  String get moneyStatusPoor => 'Pobre';

  @override
  String get moneyStatusRising => 'Ascendente';

  @override
  String get moneyStatusRich => 'Rica';

  @override
  String get moneyStatusMultimillionaire => 'Multimilionária';

  @override
  String get rankBeginner => 'Novata';

  @override
  String get rankCriminal => 'Criminosa';

  @override
  String get rankGangster => 'Gângster';

  @override
  String get rankMafioso => 'Mafioso';

  @override
  String get rankGodfather => 'Padrinho';

  @override
  String get dailyGoalTitle_crime_3 => 'Faça 3 crimes';

  @override
  String get dailyGoalTitle_job_2 => 'Trabalhe 2 vezes';

  @override
  String get dailyGoalTitle_vehicle_theft_1 => 'Roube 1 veículo';

  @override
  String get dailyGoalTitle_travel_1 => 'Conclua 1 viagem';

  @override
  String get dailyGoalTitle_weekly_crime_20 => 'Semanal: 20 crimes';

  @override
  String get dailyGoalTitle_weekly_job_10 => 'Semanalmente: trabalhe 10 vezes';

  @override
  String get dailyGoalTitle_weekly_vehicle_theft_5 =>
      'Semanalmente: roube 5 veículos';

  @override
  String get dailyGoalTitle_weekly_travel_3 => 'Semanalmente: 3 viagens';

  @override
  String dailyGoalReward(String cash, String xp) {
    return 'Recompensa: +$cash e +$xp XP';
  }

  @override
  String get justNow => 'Agora mesmo';

  @override
  String secondsAgo(String seconds) {
    return '${seconds}s atrás';
  }

  @override
  String minutesAgo(String count) {
    return '$count minutos atrás';
  }

  @override
  String hoursAgo(String count) {
    return '$count horas atrás';
  }

  @override
  String get last10EventsLive => 'Últimos 10 eventos (ao vivo).';

  @override
  String get noEventsYetSession => 'Ainda não há eventos nesta sessão.';

  @override
  String get clearRecap => 'Recapitulação clara';

  @override
  String get weeklyGoalClaimed => 'Meta semanal reivindicada!';

  @override
  String get dailyGoalClaimed => 'Meta diária reivindicada!';

  @override
  String get failed => 'Fracassada.';

  @override
  String get failedPleaseTryAgain => 'Fracassado. Por favor, tente novamente.';

  @override
  String get dailyGoals => 'Metas diárias';

  @override
  String get weeklyGoals => 'Metas semanais';

  @override
  String get claimed => 'Reivindicada';

  @override
  String get ready => 'Preparar';

  @override
  String get claim => 'Alegar';

  @override
  String readyToClaim(String count) {
    return '$count pronto para reivindicar';
  }

  @override
  String completedOutOfTotal(String completed, String total) {
    return '$completed/$total concluído';
  }

  @override
  String get noPlayerData => 'Nenhum dado do jogador';

  @override
  String get economy24h => 'Economia 24h';

  @override
  String get grossIncome => 'Renda bruta';

  @override
  String get propertySpend => 'Gastos com propriedade';

  @override
  String get netCashflow => 'Fluxo de caixa líquido';

  @override
  String get trendVsPrevious => 'Tendência vs anterior';

  @override
  String get activity7d => 'Atividade 7d';

  @override
  String get vehicleThefts => 'Roubos de veículos';

  @override
  String get opsOverview => 'Visão geral das operações';

  @override
  String get activeCooldowns => 'Recargas ativas';

  @override
  String get longestTimer => 'Temporizador mais longo';

  @override
  String get activeProduction => 'Produção ativa';

  @override
  String get productionReadyIn => 'Produção pronta em';

  @override
  String get nightclubEvents => 'Eventos de boate';

  @override
  String get nextEventStartsIn => 'Próximo evento começa em';

  @override
  String get vehiclesActiveListedTransit =>
      'Veículos ativos/listados/em trânsito';

  @override
  String get livePlayerEvents => 'Eventos de jogadores ao vivo';

  @override
  String get openEvents => 'Eventos abertos';

  @override
  String get notificationsAndRisk => 'Notificações e Risco';

  @override
  String get unreadDm => 'Mensagem direta não lida';

  @override
  String get supportWaitingOnYou => 'Suporte esperando por você';

  @override
  String get eventsLast24h => 'Eventos duram 24h';

  @override
  String get riskScore => 'Pontuação de risco';

  @override
  String get recruitProstitute => 'Recrutar prostituta';

  @override
  String get free => 'LIVRE';

  @override
  String get crewWars => 'Guerras de Crew';

  @override
  String get status => 'Status';

  @override
  String get canDeclare => 'Pode declarar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get type => 'Tipo';

  @override
  String get opponent => 'Adversária';

  @override
  String get crewPoints => 'Pontos de Crew';

  @override
  String get warRank => 'Classificação de guerra';

  @override
  String get seasonRank => 'Classificação da temporada';

  @override
  String get openTargets => 'Alvos abertos';

  @override
  String get phaseEndsIn => 'Fase termina em';

  @override
  String get crewTerritory => 'Território da Crew';

  @override
  String get regions => 'Regiões';

  @override
  String get countriesCaptured => 'Países capturados';

  @override
  String get payout => 'Pagamento';

  @override
  String get earningPerHour => 'Ganhando agora por hora';

  @override
  String get earningPerDay => 'Ganhando agora por dia';

  @override
  String get totalEarned => 'Total ganho';

  @override
  String get crewBank => 'Banco de Crew';

  @override
  String get dashboardEconomy24h => 'Economia 24h';

  @override
  String get dashboardGrossIncome => 'Renda bruta';

  @override
  String get dashboardPropertySpend => 'Gastos com propriedade';

  @override
  String get dashboardNetCashflow => 'Fluxo de caixa líquido';

  @override
  String get dashboardTrendVsPrevious => 'Tendência vs anterior';

  @override
  String get dashboardActivity7d => 'Atividade 7d';

  @override
  String get dashboardVehicleThefts => 'Roubos de veículos';

  @override
  String get dashboardOpsOverview => 'Visão geral das operações';

  @override
  String get dashboardActiveCooldowns => 'Recargas ativas';

  @override
  String get dashboardLongestTimer => 'Temporizador mais longo';

  @override
  String get dashboardActiveProduction => 'Produção ativa';

  @override
  String get dashboardProductionReadyIn => 'Produção pronta em';

  @override
  String get dashboardNightclubEvents => 'Eventos de boate';

  @override
  String get dashboardNextEventStartsIn => 'Próximo evento começa em';

  @override
  String get dashboardVehiclesActiveListedTransit =>
      'Veículos ativos/listados/em trânsito';

  @override
  String get dashboardLivePlayerEvents => 'Eventos de jogadores ao vivo';

  @override
  String get dashboardOpenEvents => 'Eventos abertos';

  @override
  String get dashboardNotificationsAndRisk => 'Notificações e Risco';

  @override
  String get dashboardUnreadDm => 'Mensagem direta não lida';

  @override
  String get dashboardSupportWaitingOnYou => 'Suporte esperando por você';

  @override
  String get dashboardEventsLast24h => 'Eventos duram 24h';

  @override
  String get dashboardRiskScore => 'Pontuação de risco';

  @override
  String get dashboardRecruitProstitute => 'Recrutar prostituta';

  @override
  String get dashboardWarTheater => 'War theater';

  @override
  String get dashboardHotRegions => 'Hot regions';

  @override
  String get dashboardCrewWars => 'Guerras de Crew';

  @override
  String get dashboardStatusLabel => 'Status';

  @override
  String get dashboardCanDeclare => 'Pode declarar';

  @override
  String get dashboardTypeLabel => 'Tipo';

  @override
  String get dashboardOpponent => 'Adversária';

  @override
  String get dashboardCrewPoints => 'Pontos de Crew';

  @override
  String get dashboardWarRank => 'Classificação de guerra';

  @override
  String get dashboardSeasonRank => 'Classificação da temporada';

  @override
  String get dashboardOpenTargets => 'Alvos abertos';

  @override
  String get dashboardPhaseEndsIn => 'Fase termina em';

  @override
  String dashboardJailStatusIn(String duration) {
    return 'Na prisão ($duration)';
  }

  @override
  String get dashboardCrewWarStatusPreparing => 'Em preparação';

  @override
  String get dashboardCrewWarStatusActive => 'Ativa';

  @override
  String get dashboardCrewWarStatusLockdown => 'Lockdown';

  @override
  String get dashboardCrewWarStatusResolved => 'Encerrada';

  @override
  String get dashboardCrewWarStatusArchived => 'Arquivada';

  @override
  String get dashboardCrewWarStatusCancelled => 'Cancelada';

  @override
  String get dashboardCrewWarStatusNone => 'Nenhuma guerra ativa';

  @override
  String get dashboardCrewWarTypeKill => 'Guerra de eliminação';

  @override
  String get dashboardCrewWarTypeEconomy => 'Guerra econômica';

  @override
  String get dashboardCrewWarTypeTerritory => 'Guerra territorial';

  @override
  String get dashboardCrewWarTypeTotal => 'Guerra total';

  @override
  String get dashboardClicks => 'Cliques';

  @override
  String get dashboardValueNotAvailable => '—';

  @override
  String get dashboardPremiumOfferDefaultTitle => 'Oferta especial';

  @override
  String get dashboardCrewWarTypeUnknown => '—';

  @override
  String get dashboardTerritoryIncomeNotConfigured => 'não configurado';

  @override
  String dashboardTerritoryIncomeEveryHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'a cada $hours horas',
      one: 'a cada hora',
    );
    return '$_temp0';
  }

  @override
  String dashboardTerritoryIncomeEveryMinutes(int minutes) {
    return 'a cada $minutes min';
  }

  @override
  String get dashboardCrewTerritory => 'Território da Crew';

  @override
  String get dashboardRegions => 'Regiões';

  @override
  String get dashboardCountriesCaptured => 'Países capturados';

  @override
  String get dashboardPayout => 'Pagamento';

  @override
  String get dashboardEarningPerHour => 'Ganhando agora por hora';

  @override
  String get dashboardEarningPerDay => 'Ganhando agora por dia';

  @override
  String get dashboardTotalEarned => 'Total ganho';

  @override
  String get dashboardVehicleOps => 'Operações de veículos';

  @override
  String get dashboardKillProgress => 'Mate o progresso';

  @override
  String get vehicleOpsHeat => 'Aquecer';

  @override
  String get vehicleOpsHeatLevelLow => 'Baixo';

  @override
  String get vehicleOpsHeatLevelMedium => 'Médio';

  @override
  String get vehicleOpsHeatLevelHigh => 'Alto';

  @override
  String get vehicleOpsReputation => 'Representante';

  @override
  String get vehicleOpsPartsTrendUp => 'mercado de peças em alta';

  @override
  String get vehicleOpsPartsTrendDown => 'mercado de peças em queda';

  @override
  String get vehicleOpsPartsTrendStable => 'mercado de peças estável';

  @override
  String get vehicleOpsBlacklistActive => 'Lista negra ativa';

  @override
  String get vehicleOpsNoBlacklist => 'Sem lista negra';

  @override
  String get prisonTitle => 'Prisão';

  @override
  String get prisonLoadFailed => 'Falha ao carregar prisioneiros';

  @override
  String get prisonNoPrisonersFound => 'Nenhum prisioneiro encontrado';

  @override
  String prisonRankLine(String rank) {
    return 'Classificação: $rank';
  }

  @override
  String prisonRankYouLine(String rank) {
    return 'Classificação: $rank · Você';
  }

  @override
  String prisonRemainingTimeLine(String duration) {
    return 'Tempo restante: $duration';
  }

  @override
  String prisonBailLine(String amount) {
    return 'Fiança: €$amount';
  }

  @override
  String get prisonPayBailButton => 'Pagar fiança';

  @override
  String get prisonBuyOutButton => 'Compre';

  @override
  String get prisonAttemptEscapeButton => 'Tentativa de fuga';

  @override
  String get prisonJailbreakButton => 'Fuga de presos';

  @override
  String get prisonActionFailed => '❌ Ação falhou';

  @override
  String prisonBuyoutSuccess(String username, String amount) {
    return '✅ Comprei $username por €$amount';
  }

  @override
  String prisonPaidBailSuccess(String amount) {
    return '✅ Você pagou fiança de €$amount e está livre';
  }

  @override
  String get prisonEscapeSuccess => '✅ Fuga com sucesso! Você está livre.';

  @override
  String prisonEscapeFailed(String penalty) {
    return '❌ A fuga falhou. Sentença estendida por $penalty.';
  }

  @override
  String prisonCooldownActive(String duration) {
    return '⏱️ Cooldown ativo: espere $duration';
  }

  @override
  String get prisonEscapeGenericFailure => '❌ Falha na fuga';

  @override
  String get prisonErrorInsufficientFunds => '❌ Não há dinheiro suficiente';

  @override
  String get prisonErrorTargetNotJailed => '❌ O alvo não está mais na prisão';

  @override
  String get prisonErrorCannotBuyoutSelf =>
      '❌ Você não pode comprar a sua parte';

  @override
  String get prisonErrorPlayerNotFound => '❌ Jogador não encontrado';

  @override
  String get prisonJailbreakSuccess =>
      '✅ Jailbreak bem-sucedido! O prisioneiro está livre.';

  @override
  String prisonJailbreakCaught(String minutes) {
    return '🚔 O jailbreak falhou, você foi pego ($minutes min de prisão).';
  }

  @override
  String get prisonJailbreakFailed =>
      '❌ Falha no jailbreak. O prisioneiro ainda está preso.';

  @override
  String get prisonErrorRescuerJailed => '❌ Você mesmo está na prisão';

  @override
  String get prisonJailbreakGenericFailure => '❌ Falha no jailbreak';

  @override
  String get crewJailbreakTitle => '🚔 Crew presa';

  @override
  String get crewJailbreakLoadFailed => 'Falha ao carregar membros presos';

  @override
  String get crewJailbreakEmptyTitle => '🎉Ninguém na prisão!';

  @override
  String get crewJailbreakEmptyBody => 'Todos os membros da Crew são gratuitos';

  @override
  String crewJailbreakAttemptFor(String username) {
    return 'Tentativa de jailbreak para $username:';
  }

  @override
  String get crewJailbreakRiskSuccess => 'Se bem sucedido: Jogador libertado!';

  @override
  String get crewJailbreakRiskFailChance =>
      'Se falhar: 60% de chance de ser pego';

  @override
  String get crewJailbreakRiskCaughtPenalty =>
      'Pego: 30-60 min de prisão + procurado +10';

  @override
  String get crewJailbreakTip =>
      'A chance de sucesso aumenta com o bônus de classificação e Crew!';

  @override
  String get crewJailbreakAttemptButton => 'Tentativa de jailbreak';

  @override
  String get crewJailbreakActionFailed => '❌ Ação falhou';

  @override
  String crewJailbreakMemberJailTimeLine(String minutes) {
    return '⏱️ $minutes minutos de prisão';
  }

  @override
  String get crewJailbreakRescueButton => 'Resgatar';

  @override
  String get crewRoleLeader => 'Líder';

  @override
  String get crewRoleCoLeader => 'Co-líder';

  @override
  String get crewRoleMember => 'Membro';

  @override
  String get vehicleOpsHotspot => 'Ponto de acesso';

  @override
  String get vehicleOpsCrew => 'Crew';

  @override
  String get vehicleOpsCrewMatch => 'Partida de Crew';

  @override
  String get vehicleOpsChop => 'Cortar';

  @override
  String get vehicleOpsContract => 'Contrato';

  @override
  String get vehicleOpsCounter => 'Contadora';

  @override
  String get vehicleOpsContracts => 'Contratos';

  @override
  String get vehicleOpsClaims => 'Reivindicações';

  @override
  String get vehicleOpsSeason => 'Temporada';

  @override
  String get dashboardCar => 'Carro';

  @override
  String get dashboardMotorcycle => 'Motocicleta';

  @override
  String get dashboardBoat => 'Barco';

  @override
  String get dashboardCrewAccess => 'Acesso da Crew';

  @override
  String get dashboardCrewRole => 'Função da Crew';

  @override
  String get dashboardUnavailable => 'indisponível';

  @override
  String get vehicleOps => 'Operações de veículos';

  @override
  String get car => 'Carro';

  @override
  String get motorcycle => 'Motocicleta';

  @override
  String get boat => 'Barco';

  @override
  String get crewAccess => 'Acesso da Crew';

  @override
  String get crewRole => 'Função da Crew';

  @override
  String get unavailable => 'indisponível';

  @override
  String get quickActionsCrimesSubtitle => 'Cometer atos criminosos';

  @override
  String get quickActionsVehicleHeistSubtitle => 'Carro, moto e barco';

  @override
  String get quickActionsTuneShopSubtitle => 'Peças e atualizações';

  @override
  String get quickActionsEventsSubtitle => 'Eventos ativos e futuros';

  @override
  String get quickActionsJobsSubtitle => 'Ganhe dinheiro legal';

  @override
  String get quickActionsCasinoSubtitle => 'Aposte seu dinheiro';

  @override
  String get quickActionsBankSubtitle => 'Gerencie seu saldo global';

  @override
  String money(String amount) {
    return '€$amount';
  }

  @override
  String get health => 'Saúde';

  @override
  String get rank => 'Classificação';

  @override
  String get xp => 'XP';

  @override
  String get settings => 'Configurações';

  @override
  String get avatar => 'avatar';

  @override
  String get avatarUpdated => 'Avatar atualizado!';

  @override
  String get avatarChangeFailed => 'Falha ao alterar o avatar';

  @override
  String get settingsMyPortraits => 'My portraits';

  @override
  String get settingsPortraitFromSelfieTitle => 'Retrato de selfie';

  @override
  String settingsPortraitFromSelfieSubtitle(int credits) {
    return 'Transforme uma selfie em um retrato estilo gangster. $credits créditos cada.';
  }

  @override
  String settingsPortraitUploadConfirm(int credits) {
    return 'Isso custa $credits créditos. Continuar?';
  }

  @override
  String get settingsPortraitConsentLabel =>
      'Concordo que minha foto possa ser processada em um retrato estilizado no jogo (consulte os Termos). Eu não tenho menos de 13 anos.';

  @override
  String settingsPortraitInsufficientCredits(int need, int have) {
    return 'Créditos insuficientes (precisa de $need, você tem $have).';
  }

  @override
  String get settingsPortraitCreated => 'Retrato adicionado à sua biblioteca!';

  @override
  String get settingsPortraitGenerationFailed =>
      'Não foi possível criar o retrato. Tente outra foto.';

  @override
  String get settingsPortraitSelectActive => 'Usar como avatar';

  @override
  String get settingsPortraitDelete => 'Remover retrato';

  @override
  String settingsPortraitLimitReached(int max) {
    return 'Limite de retrato atingido ($max).';
  }

  @override
  String get settingsPortraitUsingCustom => 'Retrato personalizado ativo';

  @override
  String get settingsPresetAvatars => 'Avatares predefinidos';

  @override
  String get settingsPortraitDeleteConfirm =>
      'Remover este retrato da sua biblioteca?';

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
  String get settingsPortraitDownloadTooltip => 'Baixe este retrato como PNG';

  @override
  String get settingsPortraitDeleteTooltip =>
      'Remova este retrato da sua biblioteca';

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
    return 'Erro: $error';
  }

  @override
  String get changeLanguage => 'Idioma / Taal';

  @override
  String get languageChanged => 'Idioma alterado para inglês';

  @override
  String languageChangeFailed(String code) {
    return 'Falha na mudança de idioma ($code)';
  }

  @override
  String get chooseLanguage => 'Escolha o idioma / Taal Kiezen';

  @override
  String get dutch => 'Holanda';

  @override
  String get english => 'Inglês';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeUsername => 'Alterar nome de usuário';

  @override
  String get usernameHint => '3-20 caracteres';

  @override
  String get change => 'Mudar';

  @override
  String get minChars => 'Mínimo 3 caracteres';

  @override
  String get usernameUpdated => 'Nome de usuário atualizado!';

  @override
  String get usernameTaken => 'Nome de usuário já utilizado';

  @override
  String get usernameChangeFailed => 'Falha ao alterar o nome de usuário';

  @override
  String get oncePerMonth => 'Mude uma vez por mês';

  @override
  String get privacy => 'Privacidade';

  @override
  String get allowMessages => 'Permitir mensagens';

  @override
  String get allowMessagesDesc =>
      'Outros jogadores podem enviar mensagens para você';

  @override
  String get settingsSystemNotificationsTitle =>
      'Notificações do sistema para aplicativo';

  @override
  String get settingsPushPermissionAllowedLinked =>
      'Permissão: permitida, dispositivo vinculado';

  @override
  String get settingsPushPermissionAllowedRelinking =>
      'Permissão: permitida, o dispositivo está sendo vinculado novamente';

  @override
  String get settingsPushPermissionProvisionalLinked =>
      'Permissão: provisória, vinculada ao dispositivo';

  @override
  String get settingsPushPermissionProvisionalRelinking =>
      'Permissão: provisória, o dispositivo está sendo vinculado novamente';

  @override
  String get settingsPushPermissionDenied => 'Permissão: negada';

  @override
  String get settingsPushPermissionNotRequested =>
      'Permissão: ainda não solicitada';

  @override
  String get settingsPushPermissionUnknown => 'Permissão: desconhecida';

  @override
  String get settingsDeviceTokenRegistered =>
      'Token do dispositivo registrado no servidor';

  @override
  String get settingsDeviceTokenNotRegistered =>
      'Nenhum token de dispositivo registrado ainda';

  @override
  String get settingsPushHelpText =>
      'Use este botão para solicitar permissão do navegador/iPhone novamente e registrar seu push token.';

  @override
  String get working => 'Trabalhando...';

  @override
  String get settingsEnablePush => 'Habilitar envio';

  @override
  String get settingsPushEnabledToast =>
      'Notificações push ativadas. Novas notificações serão recebidas agora.';

  @override
  String get settingsPushDisabledInSystem =>
      'Push está desativado nas configurações do seu navegador/iPhone. Ative notificações para este aplicativo.';

  @override
  String settingsEnablePushFailed(String error) {
    return 'Falha ao ativar notificações push: $error';
  }

  @override
  String get settingsPlayerEventsTitle => 'Eventos de jogadores';

  @override
  String get settingsPushLivePlayerEventsTitle =>
      'Push: eventos de jogadores ao vivo';

  @override
  String get settingsPushLivePlayerEventsSubtitle =>
      'Início e fim de eventos de competição recorrentes (por exemplo, rodadas com pontuação máxima).';

  @override
  String get settingsCryptoNotificationsTitle => 'Notificações criptográficas';

  @override
  String get settingsCryptoPushTradesTitle => 'Empurrar: negociações';

  @override
  String get settingsCryptoPushTradesSubtitle =>
      'Notificação push para negociações de compra/venda';

  @override
  String get settingsCryptoPushPriceAlertsTitle => 'Push: alertas de preços';

  @override
  String get settingsCryptoPushPriceAlertsSubtitle =>
      'Notificação push para movimentos de preços relevantes';

  @override
  String get settingsCryptoPushOrdersTitle => 'Empurrar: Pedidos';

  @override
  String get settingsCryptoPushOrdersSubtitle =>
      'Notificação push quando o pedido é acionado ou preenchido';

  @override
  String get settingsCryptoPushMissionsTitle => 'Empurrar: Missões';

  @override
  String get settingsCryptoPushMissionsSubtitle =>
      'Notificação push quando uma missão criptográfica é concluída';

  @override
  String get settingsCryptoPushLeaderboardTitle =>
      'Empurrar: Tabela de classificação';

  @override
  String get settingsCryptoPushLeaderboardSubtitle =>
      'Notificação push para recompensas criptográficas da tabela de classificação';

  @override
  String get settingsCryptoInAppTradesTitle => 'No aplicativo: negociações';

  @override
  String get settingsCryptoInAppTradesSubtitle =>
      'Mostre eventos comerciais em seu feed de eventos';

  @override
  String get settingsCryptoInAppPriceAlertsTitle =>
      'No aplicativo: alertas de preços';

  @override
  String get settingsCryptoInAppPriceAlertsSubtitle =>
      'Mostre eventos de alerta de preço no seu feed de eventos';

  @override
  String get settingsCryptoInAppOrdersTitle => 'No aplicativo: pedidos';

  @override
  String get settingsCryptoInAppOrdersSubtitle =>
      'Mostrar eventos de pedidos em seu feed de eventos';

  @override
  String get settingsCryptoInAppMissionsTitle => 'No aplicativo: Missões';

  @override
  String get settingsCryptoInAppMissionsSubtitle =>
      'Mostre missões concluídas no feed do seu evento';

  @override
  String get settingsCryptoInAppLeaderboardTitle => 'No aplicativo: placar';

  @override
  String get settingsCryptoInAppLeaderboardSubtitle =>
      'Mostre as recompensas da tabela de classificação no feed do seu evento';

  @override
  String get settingsAvatarChangeWeeklyLimit =>
      'Você só pode alterar seu avatar uma vez por semana';

  @override
  String get settingsUsernameChangeMonthlyLimit =>
      'Você só pode alterar seu nome de usuário uma vez por mês';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get vipStatus => 'Status VIP';

  @override
  String activeUntil(String date) {
    return 'Ativo até $date';
  }

  @override
  String get unknown => 'Desconhecida';

  @override
  String get chooseAvatar => 'Escolha um avatar';

  @override
  String get freeAvatars => 'Avatares grátis';

  @override
  String get vipAvatars => 'Avatares VIP';

  @override
  String get vip => 'VIP';

  @override
  String get notLoggedIn => 'Não logado';

  @override
  String get refresh => 'Atualizar';

  @override
  String get foodAndDrink => 'Comida e bebida';

  @override
  String get invalidItem => 'Este item não existe';

  @override
  String get foodBroodje => 'Sanduíche';

  @override
  String get foodPizza => 'Pizza';

  @override
  String get foodBurger => 'Hambúrguer';

  @override
  String get foodSteak => 'Bife';

  @override
  String get drinkWater => 'Água';

  @override
  String get drinkSoda => 'Refrigerante';

  @override
  String get drinkCoffee => 'Café';

  @override
  String get drinkBeer => 'Cerveja';

  @override
  String get foodInfo3 =>
      '• Compre comida e bebida para manter suas estatísticas altas';

  @override
  String get friends => 'Amigas';

  @override
  String get friendActivity => 'Atividade de amigo';

  @override
  String get friendsUiTabActivity => 'Atividade';

  @override
  String get friendsUiTabRequests => 'Solicitações';

  @override
  String get friendsUiTabSearch => 'Procurar';

  @override
  String get friendsUiEmptyListTitle => 'Ainda não há amigos';

  @override
  String get friendsUiEmptyListSubtitle =>
      'Procure jogadores e adicione-os como amigos!';

  @override
  String get friendsUiNoRequests => 'Nenhuma solicitação';

  @override
  String friendsUiLineRank(String rank) {
    return 'Classificação: $rank';
  }

  @override
  String friendsUiLineLocation(String location) {
    return 'Localização: $location';
  }

  @override
  String friendsUiLineHealth(String percent) {
    return 'Saúde: $percent%';
  }

  @override
  String friendsUiLineFriendsSince(String date) {
    return 'Amigos desde: $date';
  }

  @override
  String get friendsUiRemoveDialogTitle => 'Remover amigo';

  @override
  String get friendsUiRemoveDialogBody =>
      'Tem certeza de que deseja remover este amigo?';

  @override
  String get friendsUiRemoveConfirm => 'Remover';

  @override
  String get friendsUiBlockDialogTitle => 'Bloquear jogador';

  @override
  String friendsUiBlockDialogBody(String username) {
    return 'Tem certeza de que deseja bloquear $username? Você não poderá enviar ou receber mensagens.';
  }

  @override
  String get friendsUiBlockButton => 'Bloquear';

  @override
  String get friendsUiSnackRequestSent => 'Pedido de amizade enviado';

  @override
  String get friendsUiSnackRequestAccepted => 'Pedido de amizade aceito';

  @override
  String get friendsUiSnackRequestRejected => 'Pedido de amizade rejeitado';

  @override
  String get friendsUiSnackFriendRemoved => 'Amigo removido';

  @override
  String get friendsUiSnackPlayerBlocked => 'Jogador bloqueado';

  @override
  String friendsUiSnackError(String details) {
    return 'Erro: $details';
  }

  @override
  String get friendsUiSearchLabel => 'Pesquisar jogador';

  @override
  String get friendsUiSearchHint => 'Digite pelo menos 2 caracteres';

  @override
  String get friendsUiSearchMinChars =>
      'Digite pelo menos 2 caracteres para pesquisar';

  @override
  String get friendsUiNoPlayersFound => 'Nenhum jogador encontrado';

  @override
  String get friendsUiMenuBlock => 'Bloquear';

  @override
  String get friendsUiMenuRemove => 'Remover';

  @override
  String get friendsUiChipFriend => 'Amiga';

  @override
  String get friendsUiChipPending => 'Pendente';

  @override
  String get friendsUiAccept => 'Aceitar';

  @override
  String get friendsUiReject => 'Rejeitar';

  @override
  String get friendsUiActivityEmpty => 'Nenhuma atividade de amigo ainda';

  @override
  String friendsUiActivityLevel(String level) {
    return 'Nível $level';
  }

  @override
  String friendsUiLineCrew(String name) {
    return 'Crew: $name';
  }

  @override
  String get crewUiAppCrews => 'Tripulações';

  @override
  String get crewUiTabMyCrew => 'Visão geral';

  @override
  String get crewUiTabCrewHq => 'Sede e atualizações';

  @override
  String get crewUiTabStorageHub => 'Armazenar';

  @override
  String get crewUiTabMembers => 'Membros';

  @override
  String get crewUiTabWarRoom => 'Sala de Guerra';

  @override
  String get crewUiTabCrewMissions => 'Missões de Crew';

  @override
  String get crewUiTabCarStorage => 'Armazenamento de carro/motocicleta';

  @override
  String get crewUiTabBoatStorage => 'Armazenamento de barco';

  @override
  String get crewUiTabWeaponStorage => 'Armazenamento de armas';

  @override
  String get crewUiTabAmmoStorage => 'Armazenamento de munição';

  @override
  String get crewUiTabDrugStorage => 'Armazenamento de medicamentos';

  @override
  String get crewUiTabCashStorage => 'Armazenamento de dinheiro';

  @override
  String get crewUiTabAllCrews => 'Tripulações';

  @override
  String get crewUiTabChat => 'Bater papo';

  @override
  String get crewUiActionCreateCrewShort => 'Criar Crew (50 mil euros)';

  @override
  String get crewUiStateNotInCrewYet => 'Você ainda não está em uma equipe';

  @override
  String get crewUiActionCreateCrew => 'Criar Crew (€50.000)';

  @override
  String get crewUiLabelCrewBank => 'Banco de Crew:';

  @override
  String get crewUiLabelDeposit => 'Depósito';

  @override
  String get crewUiLabelWithdraw => 'Retirar';

  @override
  String get crewUiLabelMyTrustScore => 'Minha pontuação de confiança:';

  @override
  String get crewUiActionDeleteCrew => 'Excluir Crew';

  @override
  String get crewUiLabelCrewStats => 'Estatísticas da Crew:';

  @override
  String get crewUiActionLeaveCrew => 'Sair da Crew';

  @override
  String get crewUiSectionBuildings => 'Sede e atualizações';

  @override
  String get crewUiHintBuildingsTabs =>
      'Abra o QG e atualizações para gerenciar o QG e todos os edifícios da Crew em um só lugar.';

  @override
  String get crewUiSectionCrewStorage => 'Armazenamento da Crew';

  @override
  String get crewUiStateNoStorageData =>
      'Nenhum dado de armazenamento carregado';

  @override
  String get crewUiActionAddCar => 'Adicionar carro/moto';

  @override
  String get crewUiActionAddBoat => 'Adicionar barco';

  @override
  String get crewUiActionAddWeapon => 'Adicionar arma';

  @override
  String get crewUiActionAddAmmo => 'Adicionar munição';

  @override
  String get crewUiActionAddDrugs => 'Adicionar drogas';

  @override
  String get crewUiSectionMembersOverview => 'Visão geral dos membros';

  @override
  String get crewUiHintMembersTab =>
      'Abra a guia Membros acima para ver a lista de membros e solicitações de adesão.';

  @override
  String get crewUiActionGoToMembers => 'Ir para Membros';

  @override
  String get crewUiLabelCrewHq => 'QG da Crew';

  @override
  String get crewUiActionGoToCrewHq => 'Vá para o QG da Crew';

  @override
  String get crewUiActionGoToStorage => 'Vá para armazenamento';

  @override
  String get crewUiStateJoinCrewFirst =>
      'Crie ou junte-se a uma equipe primeiro';

  @override
  String get crewUiStateJoinRequests => 'Solicitações de adesão';

  @override
  String get crewUiStateNoJoinRequests => 'Nenhuma solicitação pendente';

  @override
  String get crewUiStateNoCrewsFound => 'Nenhuma equipe encontrada';

  @override
  String get crewUiLabelMemberCount => 'Membros';

  @override
  String get crewUiBadgeMyCrew => 'Minha Crew';

  @override
  String get crewUiActionJoin => 'Juntar';

  @override
  String get crewUiStateNotInCrew => 'Você não está em uma Crew';

  @override
  String get crewUiHintChatJoinCrew =>
      'Crie ou junte-se a uma equipe para conversar!';

  @override
  String get crewUiStatusNotOwned => 'Não pertencente';

  @override
  String get crewUiLabelLevel => 'Nível';

  @override
  String get crewUiLabelCapacity => 'Capacidade';

  @override
  String get crewUiLabelMemberCap => 'Limite de membros';

  @override
  String get crewUiLabelParking => 'Estacionamento';

  @override
  String get crewUiActionPurchase => 'Comprar';

  @override
  String get crewUiActionUpgrade => 'Atualizar';

  @override
  String get crewUiActionDetails => 'Detalhes';

  @override
  String get crewUiHelpCapsTitle => 'Visão geral do nível';

  @override
  String get crewUiHelpLevel => 'Nível';

  @override
  String get crewUiHelpCapacity => 'Boné';

  @override
  String get crewUiHelpUpgradeCost => 'Custo';

  @override
  String get crewUiHelpClose => 'Fechar';

  @override
  String get crewUiHelpShowCaps => 'Mostrar bonés';

  @override
  String get crewUiSectionUpgradeHub => 'Sede e atualizações';

  @override
  String get crewUiSectionStorageHub => 'Centro de armazenamento';

  @override
  String get crewUiHintStorageTab =>
      'Use a guia Armazenamento para depósitos, saldos e ações rápidas de armazenamento.';

  @override
  String get crewUiHintUpgradeHub =>
      'Gerencie o QG e todas as atualizações da Crew em um só lugar aqui.';

  @override
  String get crewUiSectionCrewMissions => 'Missões de Crew';

  @override
  String get crewUiStateCrewMissionsEmpty =>
      'Nenhuma missão de Crew disponível ainda';

  @override
  String get crewUiStateCrewMissionNoCrew =>
      'Junte-se ou crie uma Crew para iniciar missões.';

  @override
  String get crewUiActionStartMission => 'Iniciar missão';

  @override
  String get crewUiActionConfigureAndStartMission => 'Configurar e iniciar';

  @override
  String get crewUiActionResolveMission => 'Resolver missão';

  @override
  String get crewUiActionClaimRewards => 'Reivindique recompensas';

  @override
  String get crewUiActionSpeedupCooldown => 'Acelerar o resfriamento';

  @override
  String get crewUiActionConfirmSpeedupCooldown => 'Confirme a aceleração';

  @override
  String get crewUiLabelActiveMission => 'Missão ativa';

  @override
  String get crewUiLabelRecentMissions => 'Missões recentes';

  @override
  String get crewUiLabelMissionDuration => 'Duração';

  @override
  String get crewUiLabelMissionCooldown => 'Esfriar';

  @override
  String get crewUiLabelMissionTier => 'Nível';

  @override
  String get crewUiLabelMissionRewards => 'Recompensas';

  @override
  String get crewUiLabelCrewMissionProgress => 'Progressão da missão da Crew';

  @override
  String get crewUiLabelCrewMissionXp => 'Missão de Crew XP';

  @override
  String get crewUiLabelCrewMissionLevelBonus => 'Bônus em dinheiro da Crew';

  @override
  String get crewUiLabelCrewMissionNextLevelBonus => 'Bônus de próximo nível';

  @override
  String get crewUiLabelMissionStatus => 'Status';

  @override
  String get crewUiLabelCooldownActive => 'Recarga ativa';

  @override
  String get crewUiLabelRoleContributions => 'Contribuições de função';

  @override
  String get crewUiLabelContribution => 'contribuição';

  @override
  String get crewUiLabelMultiplier => 'multiplicador';

  @override
  String get crewUiStatusMissionLocked => 'Bloqueado';

  @override
  String get crewUiStatusInProgress => 'Em andamento';

  @override
  String get crewUiStatusCompleted => 'Concluída';

  @override
  String get crewUiStatusReady => 'Preparar';

  @override
  String get crewUiStatusRewardsClaimed => 'Recompensas reivindicadas';

  @override
  String get crewUiStateMissionActionBusy => 'A ação está sendo processada...';

  @override
  String get crewUiHintMissionLeaderOnly =>
      'Somente o líder/co-líder pode iniciar e resolver missões.';

  @override
  String get crewUiDialogRoleAssignTitle => 'Atribuir funções';

  @override
  String get crewUiDialogRoleAssignSubtitle =>
      'Escolha uma função de missão por membro da Crew.';

  @override
  String get crewUiLabelRoleNone => 'Não atribuído';

  @override
  String get crewUiLabelRolePlanner => 'Planejadora';

  @override
  String get crewUiLabelRoleEnforcer => 'Executor';

  @override
  String get crewUiLabelRoleLogistics => 'Logística';

  @override
  String get crewUiLabelRoleTech => 'Tecnologia';

  @override
  String get crewUiHintRoleBonus =>
      'Cada função única: +3% de chance de sucesso, -2% de duração (máx. +12% / -8%).';

  @override
  String get crewUiStateRoleAssignNoMembers =>
      'Nenhum membro da Crew encontrado.';

  @override
  String get crewUiStateRoleAssignPickOne => 'Selecione pelo menos uma função.';

  @override
  String get crewUiHintMissionLockedTier2 =>
      'O nível 2 requer membros do QG 5+ e 2+.';

  @override
  String get crewUiHintMissionLockedTier3 =>
      'O nível 3 requer membros HQ 9+ e 3+.';

  @override
  String get crewUiHintMissionLockedDefault => 'A missão ainda está bloqueada.';

  @override
  String get crewUiMessageMissionOverviewLoadFailed =>
      'Falha ao carregar missões da Crew.';

  @override
  String get crewUiMessageMissionStarted => 'Missão iniciada';

  @override
  String get crewUiMessageMissionResolved => 'Missão resolvida';

  @override
  String get crewUiMessageMissionRewardsClaimed => 'Recompensas reivindicadas';

  @override
  String get crewUiMessageMissionCooldownSpedUp => 'Cooldown acelerado';

  @override
  String get crewUiMessageMissionSpeedupQuoteFailed =>
      'Não foi possível carregar o preço de aceleração.';

  @override
  String get crewUiDialogSpeedupTitle => 'Acelerar o resfriamento?';

  @override
  String crewUiDialogSpeedupBody(String credits, String minutes) {
    return 'O acabamento instantâneo custa $credits créditos ($minutes min restantes).';
  }

  @override
  String get crewUiLabelCredits => 'créditos';

  @override
  String get crewUiStateLoadingPrice => 'Carregando preço...';

  @override
  String get crewUiActionCancel => 'Cancelar';

  @override
  String crewUiHqUpgradeSideBuildingsMessage(String level, String missing) {
    return 'Atualize todos os edifícios laterais para pelo menos o nível $level primeiro. \n\nFaltando: \n$missing';
  }

  @override
  String get crewUiFormatRemainingUnderOneMinute => '<1 minuto';

  @override
  String crewUiFormatRemainingMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get crewUiMissionNoHistory => 'Ainda não há história.';

  @override
  String get crewUiBuildingHq => 'QG da Crew';

  @override
  String get crewUiBuildingCarStorage => 'Armazenamento de carro/motocicleta';

  @override
  String get crewUiBuildingBoatStorage => 'Armazenamento de barco';

  @override
  String get crewUiBuildingWeaponStorage => 'Armazenamento de armas';

  @override
  String get crewUiBuildingAmmoStorage => 'Armazenamento de munição';

  @override
  String get crewUiBuildingDrugStorage => 'Armazenamento de medicamentos';

  @override
  String get crewUiBuildingCashStorage => 'Armazenamento de dinheiro';

  @override
  String get crewUiWarActionKill => 'Matar';

  @override
  String get crewUiWarActionMug => 'Caneca';

  @override
  String get crewUiWarActionSabotage => 'Sabotar';

  @override
  String get crewUiWarActionIntel => 'Informações';

  @override
  String get crewUiWarActionRaid => 'Ataque';

  @override
  String get crewUiWarActionShield => 'Escudo';

  @override
  String get crewUiWarActionBoost => 'Impulsionar';

  @override
  String get crewUiWarActionTerritory => 'Território';

  @override
  String crewUiWarTargetCrewSubtitle(String name, int count) {
    return '$name ($count membros)';
  }

  @override
  String crewChatErrorLoadingMessages(String error) {
    return 'Erro ao carregar mensagens: $error';
  }

  @override
  String get crewChatMessageTooLong =>
      'Mensagem muito longa (máximo de 500 caracteres)';

  @override
  String crewChatErrorSending(String error) {
    return 'Erro ao enviar mensagem: $error';
  }

  @override
  String crewChatErrorDelete(String error) {
    return 'Não foi possível excluir a mensagem: $error';
  }

  @override
  String get crewChatDeleteTitle => 'Excluir mensagem?';

  @override
  String get crewChatDeleteBody =>
      'Esta mensagem será excluída permanentemente.';

  @override
  String get crewChatCancel => 'Cancelar';

  @override
  String get crewChatDelete => 'Excluir';

  @override
  String get crewChatNoMessages => 'Nenhuma mensagem ainda';

  @override
  String get crewChatEmptyHint => 'Envie a primeira mensagem para sua Crew!';

  @override
  String get aviationUiBuyConfirmTitle => 'Comprar aeronaves?';

  @override
  String aviationUiBuyConfirmBody(String name, String price) {
    return 'Você quer comprar $name por $price?';
  }

  @override
  String get aviationUiPurchaseFailed => 'A compra falhou.';

  @override
  String get aviationUiPurchasedSuccess => 'Aeronave comprada.';

  @override
  String aviationUiLicenseActiveBlurb(String type) {
    return 'Licença ativa ($type). Atualize para aeronaves mais pesadas, se necessário. Também é necessário treinamento completo de piloto (certificados de Aviação 5 +).';
  }

  @override
  String get aviationUiLicenseMissingBlurb =>
      'A Aviação Escolar 5/5 por si só não é suficiente: compre uma licença de aviação paga aqui antes de comprar uma aeronave.';

  @override
  String get aviationUiLicensesTitle => 'Licenças de aviação';

  @override
  String get aviationUiLicenseBasic => 'Básico (leve/turboélice)';

  @override
  String get aviationUiLicenseCommercial =>
      'Comercial (jatos executivos/de luxo)';

  @override
  String get aviationUiLicenseCargo => 'Carga (carga e cargueiros pesados)';

  @override
  String aviationUiLicenseMinRank(int rank) {
    return 'Classificação mínima $rank';
  }

  @override
  String get aviationUiBuyLicense => 'Comprar licença';

  @override
  String get aviationUiUpgradeLicense => 'Licença de atualização';

  @override
  String get aviationUiLicenseBuyConfirmTitle => 'Comprar licença de aviação?';

  @override
  String aviationUiLicenseBuyConfirmBody(String name, String price) {
    return 'Comprar $name por $price? Requer escola de Aviação concluída (nível 5 + certificações).';
  }

  @override
  String get aviationUiLicensePurchaseFailed => 'Falha na compra da licença.';

  @override
  String get aviationUiLicensePurchasedSuccess =>
      'Licença de aviação adquirida.';

  @override
  String get aviationUiYourAircraft => 'Sua aeronave';

  @override
  String get aviationUiNoOwnedAircraft =>
      'Você ainda não possui nenhuma aeronave.';

  @override
  String get aviationUiAvailableAircraft => 'Aeronaves disponíveis';

  @override
  String aviationUiFuelLabel(int fuel, int max) {
    return 'Combustível: $fuel / $max';
  }

  @override
  String aviationUiPriceLabel(String price) {
    return 'Preço: $price';
  }

  @override
  String aviationUiMinRank(int rank) {
    return 'Classificação mínima: $rank';
  }

  @override
  String aviationUiSpeedMultiplier(String value) {
    return 'Velocidade x$value';
  }

  @override
  String aviationUiCargoCapacity(int amount) {
    return 'Carga: $amount';
  }

  @override
  String get aviationUiDefaultAircraftName => 'Aeronave';

  @override
  String aviationUiLoadError(String error) {
    return 'Não foi possível carregar dados de aviação: $error';
  }

  @override
  String get crewUiTr0 => 'Requisitos de atualização do QG';

  @override
  String get crewUiTr1 =>
      'Atualize seu estilo HQ atual para o nível máximo para desbloquear o próximo estilo';

  @override
  String get crewUiTr2 => 'Estilo final de HQ alcançado';

  @override
  String get crewUiTr3 => 'QG VIP necessário para o nível 11-15';

  @override
  String get crewUiTr4 =>
      'Atualize todos os edifícios laterais para o nível exigido para este estilo de QG primeiro';

  @override
  String get crewUiTr5 => 'Prédio já possuído';

  @override
  String get crewUiTr6 => 'Fundos insuficientes do banco da Crew';

  @override
  String get crewUiTr7 =>
      'A progressão do QG é muito baixa para esta atualização';

  @override
  String get crewUiTr8 => 'Crew VIP necessária para nível 11+';

  @override
  String get crewUiTr9 =>
      'Depósito inicial alcançado. Compre armazenamento de dinheiro primeiro para desbloquear mais espaço no banco da Crew.';

  @override
  String get crewUiTr10 => 'Falha na ação';

  @override
  String get crewUiTr11 => 'Já existe uma missão de Crew ativa.';

  @override
  String get crewUiTr12 =>
      'O tempo de espera da missão ainda está ativo. Espere terminar ou acelere com créditos.';

  @override
  String get crewUiTr13 => 'Missão não encontrada.';

  @override
  String get crewUiTr14 => 'Esta camada ainda está bloqueada.';

  @override
  String get crewUiTr15 => 'Execução da missão não encontrada.';

  @override
  String get crewUiTr16 => 'A missão já está resolvida.';

  @override
  String get crewUiTr17 => 'A missão ainda não foi concluída.';

  @override
  String get crewUiTr18 => 'Sem resfriamento ativo.';

  @override
  String get crewUiTr19 => 'Créditos insuficientes.';

  @override
  String get crewUiTr20 => 'Falha ao iniciar a missão.';

  @override
  String get crewUiTr21 => 'Falha ao resolver a missão.';

  @override
  String get crewUiTr22 => 'Falha ao reivindicar recompensas.';

  @override
  String get crewUiTr23 => 'Falha ao acelerar o resfriamento.';

  @override
  String get crewUiTr24 => 'Você não está em uma Crew.';

  @override
  String get crewUiTr25 => 'Somente o líder da Crew pode fazer isso.';

  @override
  String get crewUiTr26 => 'Crew alvo não encontrada.';

  @override
  String get crewUiTr27 => 'Esta Crew já está em guerra.';

  @override
  String get crewUiTr28 => 'São necessários pelo menos 3 membros da Crew.';

  @override
  String get crewUiTr29 => 'Guerra não encontrada.';

  @override
  String get crewUiTr30 => 'Esta guerra não está ativa.';

  @override
  String get crewUiTr31 => 'Você não pode entrar nesta guerra agora.';

  @override
  String get crewUiTr32 => 'Esta ação requer um jogador alvo.';

  @override
  String get crewUiTr33 => 'Bloqueio anti-fazenda: escolha outro alvo.';

  @override
  String get crewUiTr34 => 'Um jogador VIP é necessário para esta ação.';

  @override
  String get crewUiTr35 => 'Uma Crew VIP é necessária para esta ação.';

  @override
  String get crewUiTr36 => 'Limite de ação atingido por enquanto.';

  @override
  String crewUiTr37(String remaining) {
    return 'Cooldown ativo: espere mais $remaining minutos.';
  }

  @override
  String get crewUiTr38 => 'Território inválido selecionado.';

  @override
  String get crewUiTr39 => 'A ação de guerra da Crew falhou.';

  @override
  String get crewUiTr40 => 'Jogador alvo';

  @override
  String get crewUiTr41 => 'Mata';

  @override
  String get crewUiTr42 => 'Mortes';

  @override
  String get crewUiTr43 => 'Cancelar';

  @override
  String get crewUiTr44 => 'Confirmar';

  @override
  String get crewUiTr45 => 'Líder';

  @override
  String get crewUiTr46 => 'Co-líder';

  @override
  String get crewUiTr47 => 'Membro';

  @override
  String get crewUiTr48 => 'Capital';

  @override
  String get crewUiTr49 => 'Porto';

  @override
  String get crewUiTr50 => 'Indústria';

  @override
  String get crewUiTr51 => 'Fronteira';

  @override
  String get crewUiTr52 => 'Logística';

  @override
  String get crewUiTr53 => 'Alegar';

  @override
  String get crewUiTr54 => 'Marcação';

  @override
  String get crewUiTr55 => 'Selecione o território';

  @override
  String get crewUiTr56 => 'Selecione uma Crew alvo primeiro.';

  @override
  String get crewUiTr57 => 'Guerra da Crew declarada.';

  @override
  String get crewUiTr58 => 'Falha ao declarar guerra da Crew.';

  @override
  String get crewUiTr59 => 'Você se juntou à guerra.';

  @override
  String get crewUiTr60 => 'Não conseguiu entrar na guerra.';

  @override
  String get crewUiTr61 => 'Ação de guerra da Crew concluída.';

  @override
  String get crewUiTr62 => 'Matar a guerra';

  @override
  String get crewUiTr63 => 'Guerra Econômica';

  @override
  String get crewUiTr64 => 'Guerra Territorial';

  @override
  String get crewUiTr65 => 'Guerra total';

  @override
  String get crewUiTr66 => 'Preparando';

  @override
  String get crewUiTr67 => 'Ativa';

  @override
  String get crewUiTr68 => 'Confinamento';

  @override
  String get crewUiTr69 => 'Resolvida';

  @override
  String get crewUiTr70 => 'Arquivada';

  @override
  String get crewUiTr71 => 'Cancelada';

  @override
  String get crewUiTr72 => 'Crew VIP';

  @override
  String get crewUiTr73 => '9,99€/mês';

  @override
  String get crewUiTr74 => '4,99€/mês';

  @override
  String get crewUiTr75 => 'Compras únicas';

  @override
  String get crewUiTr76 => 'Somente o líder pode comprar VIP da Crew';

  @override
  String get crewUiTr77 => 'Produto inválido';

  @override
  String get crewUiTr78 => 'Erro ao abrir página de pagamento';

  @override
  String get crewUiTr79 => 'Tem certeza?';

  @override
  String get crewUiTr80 => 'Sair da Crew';

  @override
  String get crewUiTr81 => 'Tem certeza de que deseja sair da Crew?';

  @override
  String get crewUiTr82 => 'Deixar';

  @override
  String get crewUiTr83 => 'Crew esquerda';

  @override
  String get crewUiTr84 => 'Depósito no banco da Crew';

  @override
  String get crewUiTr85 => 'Retirar do banco da Crew';

  @override
  String get crewUiTr86 => 'Quantia';

  @override
  String get crewUiTr87 => 'Valor inválido';

  @override
  String get crewUiTr88 => 'Não há dinheiro suficiente em mãos';

  @override
  String get crewUiTr89 =>
      'Compre primeiro o armazenamento de dinheiro para o banco da Crew';

  @override
  String get crewUiTr90 => 'O armazenamento de dinheiro da Crew está cheio';

  @override
  String get crewUiTr91 => 'Excluir Crew';

  @override
  String get crewUiTr92 =>
      'Tem certeza de que deseja excluir esta Crew? Isto não pode ser desfeito.';

  @override
  String get crewUiTr93 => 'Excluir';

  @override
  String get crewUiTr94 => 'Próximo nível';

  @override
  String get crewUiTr95 => 'Custo';

  @override
  String get crewUiTr96 => 'Nível máximo alcançado';

  @override
  String get crewUiTr97 => 'Edifício não pertencente';

  @override
  String get crewUiTr98 => 'Adicionar carro/moto';

  @override
  String get crewUiTr99 => 'Adicionar barco';

  @override
  String get crewUiTr100 => 'Motocicleta';

  @override
  String get crewUiTr101 => 'Barco';

  @override
  String get crewUiTr102 => 'Carro';

  @override
  String get crewUiTr103 => 'Selecione';

  @override
  String get crewUiTr104 => 'Adicionar';

  @override
  String get crewUiTr105 => 'Adicionar arma';

  @override
  String get crewUiTr106 => 'Arma';

  @override
  String get crewUiTr107 => 'Quantidade';

  @override
  String get crewUiTr108 => 'Adicionar munição';

  @override
  String get crewUiTr109 => 'Tipo de munição';

  @override
  String get crewUiTr110 => 'Adicionar mercadorias';

  @override
  String get crewUiTr111 => 'Tipo de mercadoria';

  @override
  String get crewUiTr112 =>
      'Junte-se a uma Crew primeiro para usar o Crew Wars.';

  @override
  String get crewUiTr113 =>
      'Nenhum membro da Crew adversária está disponível para atacar.';

  @override
  String get crewUiTr114 => 'Selecione o jogador alvo';

  @override
  String get crewUiTr115 => 'Visão geral da temporada';

  @override
  String get crewUiTr116 => 'Temporada ativa';

  @override
  String get crewUiTr117 => 'Meu papel';

  @override
  String get crewUiTr118 => 'A Crew pode declarar';

  @override
  String get crewUiTr119 => 'Sim';

  @override
  String get crewUiTr120 => 'Não';

  @override
  String get crewUiTr121 => 'Declarar nova guerra';

  @override
  String get crewUiTr122 => 'Crew alvo';

  @override
  String get crewUiTr123 => 'Tipo de guerra';

  @override
  String get crewUiTr124 => 'Declarar guerra';

  @override
  String get crewUiTr125 => 'Territórios de guerra';

  @override
  String get crewUiTr126 => 'Neutra';

  @override
  String get crewUiTr127 => 'Crew oponente';

  @override
  String get crewUiTr128 => 'Ativo de';

  @override
  String get crewUiTr129 => 'Junte-se à guerra';

  @override
  String get crewUiTr130 => 'Classificação';

  @override
  String get crewUiTr131 => 'Territórios';

  @override
  String get crewUiTr132 => 'Ações recentes';

  @override
  String get crewUiTr133 => 'Nenhuma ação de guerra ainda.';

  @override
  String get crewUiTr134 => 'contra';

  @override
  String get crewUiTr135 => 'Tabela de classificação da temporada';

  @override
  String get crewUiTr136 => 'Ainda não há pontos na temporada.';

  @override
  String get crewUiTr137 => 'Saque';

  @override
  String get crewUiTr138 => 'Guerras recentes';

  @override
  String get crewUiTr139 => 'Nenhuma guerra recente ainda.';

  @override
  String get crewUiTr140 => 'Somente o líder pode comprar ou atualizar';

  @override
  String get crewUiTr141 =>
      'Atualização do QG bloqueada: edifícios laterais primeiro para L\$requiredSideLevel';

  @override
  String get crewUiTr142 => 'Próxima atualização ainda não disponível';

  @override
  String get crewUiTr143 => 'Progressão do QG muito baixa';

  @override
  String get crewUiTr144 => 'Nível de QG muito baixo para próxima atualização';

  @override
  String get premiumUiLoadError =>
      'Não foi possível carregar os dados premium.';

  @override
  String get premiumUiRedirectPaidOneTime =>
      'Compra recebida. Atualizando seus créditos e visão geral premium.';

  @override
  String get premiumUiRedirectPaidCrewVip =>
      'Pagamento VIP da Crew recebido. Atualizando sua visão geral premium.';

  @override
  String get premiumUiRedirectPaidVip =>
      'Pagamento VIP recebido. Atualizando sua visão geral premium.';

  @override
  String get premiumUiRedirectCancelledOneTime => 'Compra cancelada.';

  @override
  String get premiumUiRedirectCancelledSubscription => 'Pagamento cancelado.';

  @override
  String get premiumUiRedirectFailedOneTime => 'A compra falhou ou expirou.';

  @override
  String get premiumUiRedirectFailedSubscription =>
      'O pagamento falhou ou expirou.';

  @override
  String get premiumUiCheckoutOpenFailed =>
      'Falha ao abrir a página de pagamento.';

  @override
  String get premiumUiRedeemNeedsVehicle =>
      'Este item requer uma seleção de veículo e será resgatado na tela do veículo.';

  @override
  String get premiumUiRedeemSuccessDefault => 'Créditos resgatados.';

  @override
  String get premiumUiRedeemFailed => 'Falha ao resgatar créditos.';

  @override
  String get premiumUiPerMonthShort => 'mo';

  @override
  String get premiumUiCreditThemeCashBoost => 'Aumento de dinheiro';

  @override
  String get premiumUiCreditThemeSecurity => 'Segurança';

  @override
  String get premiumUiCreditThemeGarage => 'Garagem';

  @override
  String get premiumUiCreditThemeTuneShop => 'Loja de músicas';

  @override
  String premiumUiCreditThemeCooldown(String actionType) {
    return 'Tempo de espera: $actionType';
  }

  @override
  String get premiumUiCreditThemeCooldownReset =>
      'Reinicialização do tempo de espera';

  @override
  String get premiumUiCreditThemeEvents => 'Eventos';

  @override
  String get premiumUiCreditThemePremium => 'Prêmio';

  @override
  String get premiumUiKpiPlayerVip => 'Jogador VIP';

  @override
  String get premiumUiKpiCrewVip => 'Crew VIP';

  @override
  String get premiumUiCreditsLabel => 'Créditos';

  @override
  String get premiumUiStatusActive => 'Ativa';

  @override
  String get premiumUiStatusInactive => 'Inativa';

  @override
  String get premiumUiNoCrew => 'Sem Crew';

  @override
  String get premiumUiSectionVipTitle => 'Assinaturas VIP';

  @override
  String get premiumUiSectionVipSubtitle =>
      'Blocos VIP profissionais com preços, status e benefícios claros.';

  @override
  String get premiumUiPlayerVipSubtitle =>
      'Vantagens de conta exclusivas, desbloqueio de avatar e qualidade de vida premium.';

  @override
  String premiumUiActiveUntil(String date) {
    return 'Ativo até $date';
  }

  @override
  String get premiumUiBadgeVip => 'VIP';

  @override
  String get premiumUiExtendVip => 'Estender VIP';

  @override
  String get premiumUiBuyVip => 'Comprar VIP';

  @override
  String get premiumUiPlayerVipBenefitsTitle => 'Benefícios VIP do jogador';

  @override
  String get premiumUiPlayerVipBenefitsBody =>
      'Benefícios VIP do jogador: \n- Tempos limite/tempo de espera de ação 10% mais curtos (o tempo de prisão permanece inalterado). \n- Na Produção de Medicamentos, você recebe um botão relâmpago VIP em cada cartão de produção para comprar materiais faltantes com um clique (após confirmação do custo). \n- Ao morrer, você perde o dinheiro disponível, mas reinicia com 500.000 euros em dinheiro. \n- Sua classificação é reduzida pela metade em vez de uma redefinição completa. \n- O progresso educacional e as conquistas desbloqueadas são preservadas. \n- O saldo bancário e a criptografia são preservados. \n- Propriedades, veículos, prostitutas, estoques transportados e itens armazenados são removidos. \n- O progresso e o estoque de medicamentos são reiniciados. \n- Você recebe 100 créditos premium semanalmente enquanto o VIP estiver ativo.';

  @override
  String get premiumUiCrewVipSubtitleNoCrew =>
      'Você deve fazer parte de uma Crew antes de poder ativar o Crew VIP.';

  @override
  String get premiumUiCrewVipSubtitleInCrew =>
      'Para atualizações de Crew, edifícios laterais de nível 11 a 15 e vantagens compartilhadas.';

  @override
  String get premiumUiBadgeCrewNeeded => 'Crew necessária';

  @override
  String get premiumUiBadgeCrewVipLabel => 'Crew VIP';

  @override
  String get premiumUiCtaCrewRequired => 'Crew necessária';

  @override
  String get premiumUiExtendCrewVip => 'Estender o VIP da Crew';

  @override
  String get premiumUiBuyCrewVip => 'Comprar Crew VIP';

  @override
  String get premiumUiCrewVipBenefitsTitle => 'Benefícios VIP da Crew';

  @override
  String get premiumUiCrewVipBenefitsNoCrewBody =>
      'Você deve ingressar em uma Crew antes de comprar a Crew VIP. Crew VIP desbloqueia vantagens focadas na Crew e maior progressão de atualização.';

  @override
  String get premiumUiCrewVipBenefitsInCrewBody =>
      'O Crew VIP concede acesso a upgrades extras de Crew e vantagens premium compartilhadas para o fluxo de sua Crew. Após a compra, o status ativo e a expiração são atualizados imediatamente.';

  @override
  String get premiumUiSectionBuyCreditsTitle => 'Comprar créditos';

  @override
  String get premiumUiSectionBuyCreditsSubtitle =>
      'Escolha um pacote por meio de blocos visuais. A opção popular de 1.000 créditos ganha destaque.';

  @override
  String get premiumUiNoCreditBundles =>
      'Não há pacotes de crédito ativos no momento.';

  @override
  String get premiumUiCreditBundleFallbackTitle => 'Pacote de crédito';

  @override
  String get premiumUiCreditBundleFallbackDescription =>
      'Créditos instantâneos para sua carteira premium.';

  @override
  String premiumUiBuyCredits(int amount) {
    return 'Compre $amount créditos';
  }

  @override
  String premiumUiCreditsCount(int count) {
    return '$count créditos';
  }

  @override
  String get premiumUiBadgeUltraDeal => 'Oferta ultra';

  @override
  String get premiumUiBadgeTopDeal => 'Melhor oferta';

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
  String get premiumUiSectionShopTitle => 'Loja de crédito';

  @override
  String get premiumUiSectionShopSubtitle =>
      'Cada item usa um bloco temático baseado no efeito que você está comprando.';

  @override
  String get premiumUiShopItemFallbackTitle => 'Artigo premium';

  @override
  String get premiumUiShopItemFallbackDescription =>
      'Benefício premium direto.';

  @override
  String get premiumUiShopNoActiveCooldown => 'Sem resfriamento ativo';

  @override
  String get premiumUiShopNotEnoughCredits => 'Créditos insuficientes';

  @override
  String get premiumUiShopRedeem => 'Resgatar';

  @override
  String premiumUiShopItemInfo(String description, String theme, int cost) {
    return '$description \n\nTema: $theme \nCusto: $cost créditos';
  }

  @override
  String get premiumUiBadgeShop => 'Comprar';

  @override
  String get premiumUiActiveEffectsTitle => 'Efeitos premium ativos';

  @override
  String get premiumUiIntroSubtitle =>
      'Os jogadores gerenciam assinaturas VIP, pacotes de créditos e itens da loja de créditos aqui.';

  @override
  String premiumUiEntitlementChip(String key, String date) {
    return '$key - $date';
  }

  @override
  String get propertiesAvailable => 'Disponível';

  @override
  String get myProperties => 'Minhas propriedades';

  @override
  String get errorLoadingMyProperties => 'Erro ao carregar minhas propriedades';

  @override
  String get errorBuyingProperty => 'Erro ao comprar imóvel';

  @override
  String get errorCollectingIncome => 'Erro ao coletar renda';

  @override
  String get noAvailableProperties => 'Não há propriedades disponíveis';

  @override
  String get noOwnedProperties => 'Você ainda não possui nenhuma propriedade';

  @override
  String get buyFirstPropertyHint =>
      'Compre seu primeiro imóvel na aba “Disponíveis”';

  @override
  String buyPropertyConfirm(String name, String price) {
    return 'Quer comprar $name por €$price?';
  }

  @override
  String get propertyPrice => 'Preço';

  @override
  String get propertyMinLevel => 'Nível necessário';

  @override
  String get propertyIncomePerHour => 'Renda/hora';

  @override
  String get propertyMaxLevel => 'Nível máximo';

  @override
  String get propertyUniquePerCountry => '⚠️ Único - 1 por país';

  @override
  String get propertyIncomeReady => '✅ Renda pronta para receber!';

  @override
  String propertyNextIncome(String duration) {
    return '⏱️ Próxima renda em $duration';
  }

  @override
  String get propertyBuyAction => 'Comprar propriedade';

  @override
  String get propertyCollectAction => 'Coletar';

  @override
  String get propertyUpgradeAction => 'Atualizar';

  @override
  String get propertyMax => 'MÁX.';

  @override
  String propertyLevel(String level) {
    return 'Nível $level';
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
  String get propertyTypeWarehouse => 'Armazém';

  @override
  String get propertyTypeCasino => 'Cassino';

  @override
  String get propertyTypeHotel => 'Hotel';

  @override
  String get propertyTypeFactory => 'Fábrica';

  @override
  String get propertyTypeBusiness => 'Negócios';

  @override
  String get propertyCasinoName => 'Cassino';

  @override
  String get propertyWarehouseName => 'Armazém';

  @override
  String get propertyNightclubName => 'Boate';

  @override
  String get propertyHouseName => 'Casa';

  @override
  String get propertyApartmentName => 'Apartamento';

  @override
  String get propertyShopName => 'Comprar';

  @override
  String get propertiesConfirmPurchaseTitle => 'Tem certeza?';

  @override
  String get propertyTypeApartment => 'Apartamento';

  @override
  String get propertyTypeNightclub => 'Boate';

  @override
  String get propertyTypeShop => 'Comprar';

  @override
  String get propertyStatStorageLabel => '📦 Armazenamento';

  @override
  String propertyStatStorageSlotsRange(int from, int to) {
    return '$from → $to vagas';
  }

  @override
  String get propertyStatHousingCapacityLabel => '👩 Capacidade habitacional';

  @override
  String propertyStatHousingWorkersRange(int from, int to) {
    return '$from → $to trabalhadores';
  }

  @override
  String propertyStatStorageAmountSlots(int amount) {
    return '$amount vagas';
  }

  @override
  String propertyHousingCapacityWithMax(int current, int max, int level) {
    return '$current trabalhadores (máximo $max no nível $level)';
  }

  @override
  String propertyHousingCapacityMaxReached(int current) {
    return '$current trabalhadores • máx.';
  }

  @override
  String propertyVipExtraSlots(int count) {
    return 'VIP +$count slots extras';
  }

  @override
  String get propertyManageNightclub => 'Gerenciar boate';

  @override
  String get blackMarket => 'Mercado negro';

  @override
  String get garage => 'Garagem';

  @override
  String get garageCapacity => 'Capacidade da Garagem';

  @override
  String garageVehiclesCount(String current, String total) {
    return '$current / $total veículos';
  }

  @override
  String garageUpgradeWithCost(String cost) {
    return 'Atualização (€$cost)';
  }

  @override
  String get garageMaxLevel => 'Nível máximo';

  @override
  String garageLevelRemaining(String level, String spots) {
    return 'Nível $level | $spots vagas restantes';
  }

  @override
  String get noCarsInGarage => 'Não há carros na sua garagem';

  @override
  String get stealCarsToStart => 'Roube alguns carros para começar!';

  @override
  String get stealFailed => 'Roubo falhou';

  @override
  String get garageUpgradeFailed => 'Falha ao atualizar a garagem';

  @override
  String get saleFailed => 'Falha na venda';

  @override
  String get vehicleTransported => 'Veículo transportado com sucesso!';

  @override
  String get vehicleTransportFailed => 'Falha ao transportar veículo';

  @override
  String get listOnMarket => 'Lista no mercado';

  @override
  String marketValue(String amount) {
    return 'Valor de Mercado: €$amount';
  }

  @override
  String get askingPrice => 'Preço pedido (€)';

  @override
  String get enterPrice => 'Insira o preço';

  @override
  String get list => 'Lista';

  @override
  String get invalidPrice => 'Preço inválido';

  @override
  String get vehicleListed => 'Veículo listado no mercado!';

  @override
  String get listVehicleFailed => 'Falha ao listar o veículo';

  @override
  String get marina => 'Marina';

  @override
  String get hospital => 'Hospital';

  @override
  String get court => 'Tribunal';

  @override
  String get casino => 'Cassino';

  @override
  String get errorLoadingCasinoStatus =>
      'Não foi possível verificar o status do cassino';

  @override
  String get errorLoadingCasinoGames =>
      'Não foi possível carregar os jogos de cassino';

  @override
  String casinoPrice(String amount) {
    return 'Preço: €$amount';
  }

  @override
  String get startingCapital => 'Capital inicial';

  @override
  String get bankrollHelper => 'Este será o saldo do cassino';

  @override
  String get casinoOwnershipInfoTitle => 'Sobre a propriedade do cassino:';

  @override
  String get casinoClosedTitle => 'CASSINO FECHADO';

  @override
  String get casinoOwnedByLabel => 'Este cassino é propriedade de:';

  @override
  String get casinoNoOwner => 'Este cassino ainda não tem dono';

  @override
  String get casinoPurchasePriceLabel => 'Preço de compra:';

  @override
  String get casinoOwnerInfo =>
      'Como proprietário, você gerencia o saldo do cassino e ganha dinheiro quando os jogadores perdem!';

  @override
  String get casinoGameSlotsName => 'Máquina caça-níqueis';

  @override
  String get casinoGameSlotsDesc =>
      'Gire os rolos e ganhe até 100x a sua aposta!';

  @override
  String get casinoGameBlackjackName => 'Blackjack';

  @override
  String get casinoGameBlackjackDesc =>
      'Vença o dealer e ganhe até 2x a sua aposta!';

  @override
  String get casinoGameRouletteName => 'Roleta';

  @override
  String get casinoGameRouletteDesc =>
      'Escolha o seu número e ganhe até 35x a sua aposta!';

  @override
  String get casinoGameDiceName => 'Dadas';

  @override
  String get casinoGameDiceDesc =>
      'Jogue os dados e ganhe até 6x a sua aposta!';

  @override
  String get difficultyEasy => 'FÁCIL';

  @override
  String get difficultyMedium => 'MÉDIA';

  @override
  String get difficultyHard => 'DURA';

  @override
  String get casinoDepositTitle => 'Depositar dinheiro';

  @override
  String get casinoWithdrawTitle => 'Retirar dinheiro';

  @override
  String get amount => 'Quantia';

  @override
  String get deposit => 'Depósito';

  @override
  String get withdraw => 'Retirar';

  @override
  String casinoDepositSuccess(String amount) {
    return '€$amount depositados na banca do cassino';
  }

  @override
  String casinoWithdrawSuccess(String amount) {
    return '€$amount retirados da banca do cassino';
  }

  @override
  String get casinoDepositError => 'Erro ao depositar';

  @override
  String get casinoWithdrawError => 'Erro ao retirar';

  @override
  String get casinoMinBankroll =>
      'Pelo menos €10.000 devem permanecer na banca';

  @override
  String casinoMaxWithdraw(String amount) {
    return 'Máximo: €$amount';
  }

  @override
  String get casinoManagementTitle => 'Gestão de Cassino';

  @override
  String casinoBankruptWarning(String amount) {
    return 'AVISO: Bankroll do cassino muito baixo! \nDeposite pelo menos €$amount para evitar a falência.';
  }

  @override
  String get casinoBankroll => 'Banca do Cassino';

  @override
  String get casinoStatsTitle => 'Estatísticas';

  @override
  String get casinoTotalReceived => 'Total Recebido:';

  @override
  String get casinoTotalPaidOut => 'Total pago:';

  @override
  String get casinoNetProfit => 'Lucro líquido:';

  @override
  String casinoProfitMargin(String percent) {
    return 'Margem de lucro: $percent%';
  }

  @override
  String get casinoManagementInfoTitle =>
      'Informações de gerenciamento do cassino';

  @override
  String get casinoManagementInfo5 =>
      '• Você pode depositar ou sacar dinheiro a qualquer momento';

  @override
  String get casinoHubChooseGameHint => 'Escolha um jogo e faça sua aposta';

  @override
  String get casinoPlayButton => 'Jogar';

  @override
  String get casinoGameBaccaratName => 'Bacará';

  @override
  String get casinoGameBaccaratDesc =>
      'Aposte no jogador, na banca ou empata com probabilidades estratégicas.';

  @override
  String get casinoGameVideoPokerName => 'Vídeo pôquer';

  @override
  String get casinoGameVideoPokerDesc =>
      'Compre 5 cartas e acerte combos até Royal Flush.';

  @override
  String get casinoBuyCasinoLockedTitle => 'Comprar cassino (bloqueado)';

  @override
  String get casinoErrGenericPlay => 'Algo deu errado';

  @override
  String get casinoErrSpinFailed => 'Erro ao girar';

  @override
  String get casinoErrBetFailed => 'Erro ao apostar';

  @override
  String get casinoErrGambleFailed => 'Erro ao jogar';

  @override
  String get casinoErrThrowFailed => 'Erro ao rolar';

  @override
  String get casinoErrCasinoNotFound =>
      'Cassino não encontrado. Certifique-se de que o cassino foi comprado neste país.';

  @override
  String get casinoErrInsufficientFunds => 'Não há dinheiro suficiente';

  @override
  String get casinoErrInsufficientBankrollPayout =>
      'Bankroll do cassino muito baixo para este pagamento';

  @override
  String casinoErrNetwork(String error) {
    return 'Erro de rede: $error';
  }

  @override
  String get casinoResultYouWon => 'Você venceu!';

  @override
  String get casinoResultYouLost => 'Perdida';

  @override
  String get casinoResultYouWonCelebrate => '🎉 Você venceu!';

  @override
  String casinoWonEuroAmount(String amount) {
    return 'Você ganhou €$amount!';
  }

  @override
  String casinoLostEuroAmount(String amount) {
    return 'Você perdeu €$amount';
  }

  @override
  String get casinoYouLostPlain => 'Você perdeu';

  @override
  String casinoBlackjackWinAmount(String amount) {
    return 'Você ganhou €$amount!';
  }

  @override
  String casinoBlackjackCelebrate(String amount) {
    return 'BLACKJACK! €$amount';
  }

  @override
  String get casinoAgain => 'De novo';

  @override
  String get casinoBankruptTitle => 'Cassino falido!';

  @override
  String get casinoBankruptBody =>
      'O cassino faliu! \n\nO proprietário não tinha dinheiro suficiente na banca para cobrir todos os pagamentos. \n\nO cassino está fechado e pode ser comprado novamente.';

  @override
  String get casinoBackToCasino => 'Voltar ao Cassino';

  @override
  String casinoRouletteNumberColor(String number, String color) {
    return 'Número: $number ($color)';
  }

  @override
  String get casinoColorGreen => 'verde';

  @override
  String get casinoColorRed => 'vermelha';

  @override
  String get casinoColorBlack => 'preta';

  @override
  String get casinoRoulettePickBet => 'Escolha sua aposta';

  @override
  String get casinoRouletteBetRed => 'Vermelha';

  @override
  String get casinoRouletteBetBlack => 'Preta';

  @override
  String get casinoRouletteBetEven => 'Até';

  @override
  String get casinoRouletteBetOdd => 'Chance';

  @override
  String get casinoRouletteSpinButton => 'RODAR!';

  @override
  String casinoRouletteLastResult(String number) {
    return 'Último resultado: $number';
  }

  @override
  String get casinoBetLabel => 'Aposta';

  @override
  String get casinoBlackjackPlayButton => 'JOGAR!';

  @override
  String get casinoSlotSpinButton => 'RODAR!';

  @override
  String get casinoDiceRollButton => 'ROLAR!';

  @override
  String get casinoBlackjackYourCards => 'Suas cartas';

  @override
  String get casinoBlackjackDealerCards => 'Cartas de dealer';

  @override
  String casinoBlackjackDealerTotal(String total) {
    return 'Revendedor: $total';
  }

  @override
  String casinoBlackjackYouTotal(String total) {
    return 'Você: $total';
  }

  @override
  String casinoDiceTotalShowing(String total) {
    return 'Total: $total';
  }

  @override
  String get casinoDicePredictTitle => 'Prever';

  @override
  String get casinoDiceLowLabel => 'Baixo (2-6)';

  @override
  String get casinoDiceHighLabel => 'Alto (8-12)';

  @override
  String get casinoDiceOddsHint => 'Baixo/Alto paga 2x • O total exato paga 6x';

  @override
  String get casinoSlotPayoutTableTitle => 'Tabela de pagamentos';

  @override
  String get casinoBaccaratPlayer => 'Jogadora';

  @override
  String get casinoBaccaratBanker => 'Banqueira';

  @override
  String get casinoBaccaratTieBet => 'Gravata';

  @override
  String casinoWinnerPrefix(String who) {
    return 'Vencedor: $who';
  }

  @override
  String casinoPayoutEuro(String amount) {
    return 'Pagamento: €$amount';
  }

  @override
  String get casinoNoPayout => 'Sem pagamento';

  @override
  String casinoResultEuro(String amount) {
    return 'Resultado: €$amount';
  }

  @override
  String get casinoDealing => 'Tratativa…';

  @override
  String get casinoDealCaps => 'NEGÓCIO';

  @override
  String get casinoVideoPokerDrawCards => 'COMPRAR CARTAS';

  @override
  String get casinoVideoPokerDrawHint => 'Desenhe sua mão';

  @override
  String get casinoVideoPokerRoyalFlush => 'Rubor Real';

  @override
  String get casinoVideoPokerStraightFlush => 'Flush direto';

  @override
  String get casinoVideoPokerFourKind => 'Quatro do mesmo tipo';

  @override
  String get casinoVideoPokerFullHouse => 'Casa cheia';

  @override
  String get casinoVideoPokerFlush => 'Lavar';

  @override
  String get casinoVideoPokerStraight => 'Direta';

  @override
  String get casinoVideoPokerThreeKind => 'Três iguais';

  @override
  String get casinoVideoPokerTwoPair => 'Dois pares';

  @override
  String get casinoVideoPokerJacksOrBetter => 'Valetes ou melhor';

  @override
  String get casinoVideoPokerNoWinningHand => 'Nenhuma mão vencedora';

  @override
  String get casinoVideoPokerPayoutTableLong =>
      'Tabela de pagamentos: Valetes+ 1x • Dois pares 2x • Trincas 3x • Straight 4x • Flush 6x • Full House 9x • Quatro 25x • Straight Flush 50x • Royal 250x';

  @override
  String get bankScreenLoadFailed => 'Falha ao carregar banco';

  @override
  String bankScreenErrNetwork(String details) {
    return 'Erro de rede: $details';
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
  String get bankScreenDepositSuccess => 'Depósito bem sucedido';

  @override
  String get bankScreenDepositFailed => 'Falha no depósito';

  @override
  String get bankScreenWithdrawSuccess => 'Retirada bem-sucedida';

  @override
  String get bankScreenWithdrawFailed => 'Falha na retirada';

  @override
  String bankScreenTransferSuccess(String amount, String recipient) {
    return '€$amount transferidos para $recipient';
  }

  @override
  String get bankScreenTransferFailed => 'Falha na transferência';

  @override
  String get bankScreenErrRecipientNotFound => 'Jogador não encontrado';

  @override
  String get bankScreenErrCannotTransferToSelf =>
      'Você não pode transferir para si mesmo';

  @override
  String get bankScreenErrInsufficientBalance => 'Saldo bancário insuficiente';

  @override
  String get bankScreenErrInvalidAmount => 'Valor inválido';

  @override
  String get bankScreenTryAgain => 'Tente novamente';

  @override
  String get bankScreenWorldwideSubtitle => 'Banco (acessível em todo o mundo)';

  @override
  String bankScreenCashOnHand(int amount) {
    return 'Dinheiro disponível: €$amount';
  }

  @override
  String bankScreenBalanceLine(int amount) {
    return 'Saldo bancário: €$amount';
  }

  @override
  String get bankScreenAmountLabel => 'Quantia';

  @override
  String get bankScreenDescriptionOptional => 'Descrição (opcional)';

  @override
  String get bankScreenDescriptionDepositHint =>
      'Será armazenado com seu depósito ou retirada nas transações.';

  @override
  String get bankScreenDepositButton => 'Depósito';

  @override
  String get bankScreenWithdrawButton => 'Retirar';

  @override
  String get bankScreenTransferSectionTitle => 'Transferir para o jogador';

  @override
  String get bankScreenRecipientUsername => 'Nome de usuário do destinatário';

  @override
  String get bankScreenRecentRecipients => 'Destinatários recentes';

  @override
  String get bankScreenDescriptionTransferHint =>
      'O destinatário também verá esta descrição nas transações.';

  @override
  String get bankScreenTransferButton => 'Transferir';

  @override
  String get bankScreenTransactionsTitle => 'Transações';

  @override
  String bankScreenTransactionsTotal(int count) {
    return '$count total';
  }

  @override
  String get bankScreenSummaryDeposits => 'Depósitos';

  @override
  String get bankScreenSummaryWithdrawals => 'Retiradas';

  @override
  String get bankScreenSummarySent => 'Enviado';

  @override
  String get bankScreenSummaryReceived => 'Recebida';

  @override
  String get bankScreenNoTransactions => 'Nenhuma transação ainda';

  @override
  String get bankScreenTxnDeposit => 'Depósito';

  @override
  String get bankScreenTxnWithdraw => 'Cancelamento';

  @override
  String get bankScreenTxnTransferSent => 'Transferência enviada';

  @override
  String get bankScreenTxnTransferReceived => 'Transferência recebida';

  @override
  String get bankScreenPrevious => 'Anterior';

  @override
  String get bankScreenNext => 'Próxima';

  @override
  String bankScreenPageOf(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String bankScreenRankLabel(String rank) {
    return 'Classificação $rank';
  }

  @override
  String get retry => 'Tentar novamente';

  @override
  String get doAction => 'Fazer';

  @override
  String get pay => 'Pagar';

  @override
  String get success => 'Sucesso';

  @override
  String get jail => 'Cadeia';

  @override
  String get cooldown => 'Esfriar';

  @override
  String get requiredRank => 'Classificação de jogador necessária';

  @override
  String get playerRankLabel => 'Classificação do jogador';

  @override
  String get loading => 'Carregando...';

  @override
  String get trade => 'Troca';

  @override
  String get buy => 'Comprar';

  @override
  String get sell => 'Vender';

  @override
  String get price => 'Preço';

  @override
  String get total => 'Total';

  @override
  String available(String count) {
    return 'Disponível: $count';
  }

  @override
  String get notEnoughMoney => 'Você não tem dinheiro suficiente!';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Fechar';

  @override
  String get viewOffer => 'Ver oferta';

  @override
  String get unexpectedResponse => 'Resposta inesperada da API';

  @override
  String get errorLoadingMenu => 'Erro ao carregar o menu';

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get food => 'Comida';

  @override
  String get drink => 'Bebida';

  @override
  String get work => 'Trabalhar';

  @override
  String cooldownMinutes(String minutes) {
    return 'Tempo de espera: $minutes min';
  }

  @override
  String xpReward(String amount) {
    return 'EXP: +$amount';
  }

  @override
  String get fly => 'Voar';

  @override
  String get purchased => 'Comprada!';

  @override
  String get sold => 'Vendida!';

  @override
  String get errorBuying => 'Erro ao comprar';

  @override
  String get errorSelling => 'Erro ao vender';

  @override
  String get goods => 'Bens';

  @override
  String get marketplace => 'Mercado';

  @override
  String get myListings => 'Minhas listagens';

  @override
  String get inventory => 'Inventário';

  @override
  String get backpacks => 'Mochilas';

  @override
  String get materials => 'Materiais';

  @override
  String get production => 'Produção';

  @override
  String get stock => 'Estoque';

  @override
  String get retryAgain => 'Tentar novamente';

  @override
  String get noVehiclesAvailable => 'Não há veículos disponíveis';

  @override
  String get noListings => 'Nenhuma listagem';

  @override
  String get condition => 'Doença';

  @override
  String get yourHealth => 'Sua saúde';

  @override
  String get criticalHealthWarning =>
      '⚠️CRÍTICO! Você deve ir ao hospital imediatamente!';

  @override
  String get lowHealthWarning => '⚠️Saúde baixa! Tome cuidado.';

  @override
  String get information => 'Informação';

  @override
  String get contrabandFlowersName => 'Flores';

  @override
  String get contrabandFlowersDesc =>
      'Tulipas holandesas e outras flores para comércio internacional';

  @override
  String get contrabandElectronicsName => 'Eletrônica';

  @override
  String get contrabandElectronicsDesc =>
      'Eletrônica avançada e componentes de computador';

  @override
  String get contrabandDiamondsName => 'Diamantes';

  @override
  String get contrabandDiamondsDesc => 'Diamantes brutos e lapidados';

  @override
  String get contrabandWeaponsName => 'Armas';

  @override
  String get contrabandWeaponsDesc => 'Armas e munições ilegais';

  @override
  String get contrabandPharmaceuticalsName => 'Produtos farmacêuticos';

  @override
  String get contrabandPharmaceuticalsDesc => 'Produtos farmacêuticos raros';

  @override
  String get multiplier => 'Multiplicador';

  @override
  String get sellPrice => 'Preço de venda';

  @override
  String get boughtFor => 'Comprei por';

  @override
  String get profit => 'Lucro';

  @override
  String get loss => 'Perda';

  @override
  String ownedQuantity(String quantity) {
    return 'Propriedade: $quantity';
  }

  @override
  String spoilsInHours(String hours) {
    return '⚠️ Estragos em ${hours}h';
  }

  @override
  String get spoiledWorthless => '💀 ESTRAGADO - Inútil';

  @override
  String get vehicleBought => 'Veículo adquirido com sucesso!';

  @override
  String get purchaseFailed => 'Falha na compra';

  @override
  String get listingRemoved => 'Listagem removida';

  @override
  String get noItemsInInventory => 'Nenhum item no inventário';

  @override
  String get buyItemsInBuyTab => 'Compre itens na guia Comprar';

  @override
  String errorLoadingMarketData(String error) {
    return 'Erro ao carregar dados de mercado: $error';
  }

  @override
  String get tradeLoadGoodsFailed =>
      'Não foi possível carregar o catálogo de mercadorias';

  @override
  String get tradeLoadPricesFailed =>
      'Não foi possível carregar os preços atuais';

  @override
  String get tradeLoadInventoryFailed =>
      'Não foi possível carregar seu inventário comercial';

  @override
  String get tradePartialDataBanner =>
      'Alguns dados de mercado não puderam ser atualizados. Puxe para baixo para tentar novamente.';

  @override
  String get tradeMarketLoadAllFailed =>
      'O mercado não pôde ser carregado. Puxe para baixo para tentar novamente.';

  @override
  String get tradeNoGoodsLoaded => 'Nenhum produto está disponível no momento.';

  @override
  String get tradeRiskPanelTitle => 'Riscos de viagens e de mercado';

  @override
  String get tradeRiskPanelSubtitle =>
      'Cada bem apresenta deterioração, oscilações de preços, danos causados ​​por viagem ou confisco quando aplicável.';

  @override
  String get tradeRiskInsightBody =>
      'FLORES: estragam após o tempo de compra - vendem a tempo. \nDIAMANTES: os preços de compra oscilam com a volatilidade; planeje onde você vende no exterior. \nELETRÔNICOS: podem perder o estado a cada viagem, o que diminui o valor de revenda. \nARMAS e PRODUTOS FARMACÊUTICOS: a apreensão parcial pode acontecer durante viagens – mantenha o número de procurados baixo e leia as regras de contrabando. \nOs preços nesta tela já incluem o multiplicador atual do seu país.';

  @override
  String tradeRiskSpoilageHours(String hours) {
    return '${hours}h janela de estragar';
  }

  @override
  String tradeRiskVolatilityPct(String pct) {
    return '±$pct% oscilação de preço';
  }

  @override
  String tradeRiskConfiscationPct(String pct) {
    return '$pct% de risco de convulsão por viagem';
  }

  @override
  String tradeRiskDamageTripPct(String pct) {
    return '$pct% de chance de dano por viagem';
  }

  @override
  String get appeal => 'Apelo';

  @override
  String get submitAppeal => 'Enviar recurso';

  @override
  String get bribeJudge => 'Juiz de suborno';

  @override
  String get bribe => 'Suborno';

  @override
  String get courtLoadFailed =>
      'Não foi possível carregar os dados do tribunal. Por favor, tente novamente.';

  @override
  String get courtAppealDialogIntro =>
      'Deseja apresentar recurso desta condenação?';

  @override
  String courtCostLine(String amount) {
    return 'Custo: $amount';
  }

  @override
  String courtJudgeNamed(String name) {
    return 'Juiz: $name';
  }

  @override
  String courtCorruptibilityPercent(String percent) {
    return 'Corruptibilidade: $percent%';
  }

  @override
  String get courtAppealSuccessHint =>
      'Em caso de sucesso: cerca de 20-40% de redução de sentença';

  @override
  String courtAppealGrantedMinutes(String minutes) {
    return 'Recurso concedido. Nova frase: $minutes minutos.';
  }

  @override
  String get courtAppealDenied => 'Recurso negado.';

  @override
  String get courtBribeOfferIntro =>
      'Ofereça uma quantia. O valor é sempre descontado, mesmo em caso de falha.';

  @override
  String courtBribeAmountFormatted(String amount) {
    return 'Valor do suborno: $amount';
  }

  @override
  String courtBribeSliderLabel(String thousands) {
    return '€${thousands}k';
  }

  @override
  String courtEstimatedSuccessChance(String percent) {
    return 'Chance de sucesso estimada: ~$percent%';
  }

  @override
  String get courtBribeSuccessReleased =>
      'Juiz subornado. Você é liberado imediatamente.';

  @override
  String get courtBribeFailedDebited =>
      'O suborno falhou. O valor ainda foi deduzido.';

  @override
  String get courtRecordActive => 'Ativa';

  @override
  String get courtRecordServed => 'Servida';

  @override
  String courtHistoryAppealGranted(String fromMinutes, String toMinutes) {
    return 'Recurso deferido: $fromMinutes → $toMinutes minutos';
  }

  @override
  String courtHistoryAppealDenied(String minutes) {
    return 'Recurso negado: $minutes minutos restantes';
  }

  @override
  String courtHistoryBribeFailedPaid(String amount) {
    return 'Suborno falhou: $amount pago';
  }

  @override
  String courtHistoryConvictedMinutes(String minutes) {
    return 'Condenado a $minutes minutos';
  }

  @override
  String get courtPartialLoadWarning =>
      'Atenção: não foi possível carregar parte dos dados do tribunal. Puxe para atualizar para tentar novamente.';

  @override
  String get courtNoActiveSentence => 'Nenhuma sentença ativa';

  @override
  String get courtNotJailedHint =>
      'Você não está preso no momento. Seu registro criminal permanece visível abaixo.';

  @override
  String get courtActiveSentenceTitle => 'Sentença ativa';

  @override
  String get courtDelictLabel => 'Crime';

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
    return 'Custo atual do recurso: $amount';
  }

  @override
  String get courtButtonAppeal => 'Apelo';

  @override
  String get courtButtonBribeJudge => 'Juiz de suborno';

  @override
  String get courtUnknownCrime => 'Desconhecida';

  @override
  String courtSentenceMinutesOnly(String minutes) {
    return 'Sentença: $minutes minutos';
  }

  @override
  String courtSentenceReducedMinutes(String original, String reduced) {
    return 'Frase: $original → $reduced minutos';
  }

  @override
  String courtDateLabeled(String datetime) {
    return 'Data: $datetime';
  }

  @override
  String get courtHistoryHeading => 'História do tribunal';

  @override
  String get courtAppealSubmitted => 'Recurso submetido';

  @override
  String get courtCriminalRecordTitle => 'Registo criminal';

  @override
  String courtTotalConvictions(String count) {
    return 'Total de condenações: $count';
  }

  @override
  String get courtRecordBribeNote =>
      'As convicções passadas permanecem visíveis. Um suborno de juiz bem-sucedido resolve apenas aquele caso ativo.';

  @override
  String get courtNoConvictionsYet => 'Nenhuma condenação registrada ainda.';

  @override
  String get treated => 'Tratada!';

  @override
  String healthRestored(String hp, String cost) {
    return '+$hp HP por €$cost';
  }

  @override
  String get treatmentOptions => 'Opções de tratamento';

  @override
  String get youAreDead => 'Você está morto! Game Over.';

  @override
  String get emergencyOnly =>
      'Tratamento de emergência disponível apenas abaixo de 10 HP';

  @override
  String emergencyTreatment(String hp) {
    return 'Tratamento de emergência! Grátis +$hp HP';
  }

  @override
  String get byValue => 'Por valor';

  @override
  String get byCondition => 'Por condição';

  @override
  String get byFuel => 'Por Combustível';

  @override
  String get byName => 'Por nome';

  @override
  String get stealCar => 'Roubar carro';

  @override
  String get stealBoat => 'Roubar Barco';

  @override
  String get sellVehicle => 'Vender Veículo';

  @override
  String get sellBoat => 'Vender Barco';

  @override
  String get confirmSellVehicle =>
      'Tem certeza de que deseja vender este veículo?';

  @override
  String get confirmSellBoat => 'Tem certeza de que deseja vender este barco?';

  @override
  String get carStolen => 'Carro roubado com sucesso!';

  @override
  String get boatStolen => 'Barco roubado com sucesso!';

  @override
  String get vehicleTypeCar => 'Carro';

  @override
  String get vehicleTypeBoat => 'Barco';

  @override
  String stolenVehicleTitle(String vehicleType) {
    return '$vehicleType roubado!';
  }

  @override
  String unknownVehicleType(String vehicleType) {
    return 'Desconhecido $vehicleType';
  }

  @override
  String get vehicleStatSpeed => 'Velocidade';

  @override
  String get vehicleStatFuel => 'Combustível';

  @override
  String get vehicleStatCargo => 'Carga';

  @override
  String get vehicleStatStealth => 'Furtiva';

  @override
  String get continueAction => 'Continuar';

  @override
  String get vehicleSold => 'Veículo vendido com sucesso!';

  @override
  String get boatSold => 'Barco vendido com sucesso!';

  @override
  String get garageUpgraded => 'Garagem atualizada!';

  @override
  String get marinaUpgraded => 'Marina atualizada com sucesso!';

  @override
  String get marinaCapacity => 'Capacidade da Marina';

  @override
  String marinaBoatsCount(String current, String total) {
    return '$current / $total barcos';
  }

  @override
  String marinaUpgradeWithCost(String cost) {
    return 'Atualização (€$cost)';
  }

  @override
  String get marinaMaxLevel => 'Nível máximo';

  @override
  String marinaLevelRemaining(String level, String remaining) {
    return 'Nível $level | $remaining vagas restantes';
  }

  @override
  String get noBoatsInMarina => 'Não há barcos na sua marina';

  @override
  String get stealBoatsToStart => 'Roube alguns barcos para começar!';

  @override
  String get marinaUpgradeFailed => 'Falha na atualização da Marina';

  @override
  String get boatShipped => 'Barco enviado com sucesso!';

  @override
  String get boatShipFailed => 'O envio do barco falhou';

  @override
  String get buyProperty => 'Comprar propriedade';

  @override
  String propertyBought(String name) {
    return '$name comprado!';
  }

  @override
  String propertyUpgraded(String level) {
    return 'Propriedade atualizada para nível $level!';
  }

  @override
  String get errorLoadingProperties => 'Erro ao carregar propriedades';

  @override
  String get errorUpgrading => 'Erro ao atualizar';

  @override
  String networkError(String error) {
    return 'Erro de rede: $error';
  }

  @override
  String get unknownResponse => 'Resposta desconhecida';

  @override
  String incomeCollected(String amount) {
    return '€$amount arrecadados!';
  }

  @override
  String get buyCasino => 'Comprar Cassino';

  @override
  String get manageCasino => 'Gerenciar Cassino';

  @override
  String get casinoBought => 'Cassino comprado com sucesso! 🎰';

  @override
  String get errorBuyCasino => 'Ocorreu um erro ao comprar o cassino';

  @override
  String minimumDeposit(String amount) {
    return 'O depósito mínimo é de €$amount';
  }

  @override
  String get casinoInfo1 => 'Os jogadores apostam contra a banca do casino';

  @override
  String get casinoInfo2 => 'Os ganhos são pagos a partir da banca';

  @override
  String get casinoInfo3 => 'Você pode depositar e sacar dinheiro';

  @override
  String get casinoInfo4 => 'Mínimo de € 10.000 em saldo necessário';

  @override
  String get casinoInfo5 => 'Abaixo disso: falência';

  @override
  String get members => 'Membros';

  @override
  String get location => 'Localização';

  @override
  String get level => 'Nível';

  @override
  String get alreadyFullHealth => 'Você já está com plena saúde!';

  @override
  String get errorTreatment => 'Erro durante o tratamento';

  @override
  String waitMinutes(String minutes) {
    return 'Você deve esperar mais $minutes minutos para o próximo tratamento!';
  }

  @override
  String get emergencyHelp => 'Ajuda de emergência';

  @override
  String onlyNeedHp(String hp) {
    return '(Você só precisa de $hp HP)';
  }

  @override
  String get emergencyInfo =>
      '• 🊘 A Ajuda de Emergência é GRATUITA abaixo de 10 HP (+20 HP)';

  @override
  String get hospitalInfo1 => '• A saúde diminui ao cometer crimes';

  @override
  String get hospitalInfo2 => '• Com 0 HP você não pode cometer crimes';

  @override
  String hospitalInfo3(String cost) {
    return '• O tratamento custa €$cost por vez';
  }

  @override
  String hospitalInfo4(String amount) {
    return '• Você pode restaurar no máximo $amount HP por tratamento';
  }

  @override
  String get hospitalInfo5 => '• ⏱️ 1 hora de espera entre tratamentos';

  @override
  String get hospitalInfo6 =>
      '• 💚 Cura passiva: +5 HP por 5 minutos (se HP > 0)';

  @override
  String get medicalTreatment => 'Tratamento Médico';

  @override
  String get restoreCritical => 'Restaurar +20 HP (condição crítica)';

  @override
  String get hospitalCooldownTitle => 'Tratamento em período de recuperação';

  @override
  String hospitalCooldownNextAvailable(String duration) {
    return 'Próximo tratamento disponível em: $duration';
  }

  @override
  String get hospitalMedicalStatusTitle => 'Estado Médico';

  @override
  String hospitalIcuRemaining(String duration) {
    return 'UTI: $duration';
  }

  @override
  String hospitalHpLine(String hp) {
    return 'PV $hp/100';
  }

  @override
  String get hospitalIcuTriageTitle => 'Visão geral da UTI e da triagem';

  @override
  String hospitalIcuPatientRemaining(String duration) {
    return 'Paciente na UTI. Tempo restante: $duration';
  }

  @override
  String get hospitalCriticalStatusDetected =>
      'Status crítico detectado. Atendimento de emergência recomendado.';

  @override
  String get hospitalStableStatus => 'Estável. Tratamento regular disponível.';

  @override
  String get hospitalRefreshMedicalRecord => 'Atualizar prontuário médico';

  @override
  String get hospitalStandardTreatmentTitle => 'Tratamento padrão';

  @override
  String hospitalStandardTreatmentSubtitle(String amount) {
    return 'Acessível • restaura até $amount HP';
  }

  @override
  String get hospitalIntensiveTreatmentTitle => 'Tratamento intensivo';

  @override
  String hospitalIntensiveTreatmentSubtitle(String amount) {
    return 'Recuperação mais rápida • até $amount HP';
  }

  @override
  String hospitalIntensiveTreatmentInfoLine(String cost, String amount) {
    return '• Tratamento intensivo: €$cost para recuperação de até $amount HP.';
  }

  @override
  String restoreUp(String amount) {
    return 'Restaure até $amount HP';
  }

  @override
  String get cost => 'Custo';

  @override
  String crimeErrorToolRequired(String tools) {
    return '⚒️ Você precisa de $tools para este crime';
  }

  @override
  String crimeErrorToolInStorage(String tools) {
    return '⚒️ Você tem $tools, mas está em casa! Vá para Inventário → Transferir';
  }

  @override
  String get crimeErrorVehicleRequired => '🚗 Este crime requer veículo';

  @override
  String get crimeErrorVehicleNotFound => '🚗 Veículo não encontrado';

  @override
  String get crimeErrorNotVehicleOwner => '🚗 Você não possui este veículo';

  @override
  String get crimeErrorVehicleBroken =>
      '🚗 Seu veículo está quebrado e precisa de conserto';

  @override
  String get crimeErrorNoFuel => '⛽ Seu veículo não tem combustível';

  @override
  String get crimeErrorLevelTooLow =>
      '⭐ Seu nível é muito baixo para este crime';

  @override
  String get crimeErrorInvalidCrimeId => '❌ Crime inválido';

  @override
  String get crimeErrorWeaponRequired =>
      '🔫 Você precisa de uma arma para este crime';

  @override
  String get crimeErrorWeaponBroken =>
      '🔫 Sua arma está quebrada e precisa de conserto';

  @override
  String get crimeErrorNoAmmo => '🔫 Você não tem munição';

  @override
  String get crimeErrorGeneric => '❌ Algo deu errado com este crime';

  @override
  String get inventoryFull =>
      '🎒 Seu inventário está cheio! Armazene ferramentas em uma propriedade';

  @override
  String get storageFull => '📦 A arrecadação do imóvel está cheia';

  @override
  String get inventoryCrimeWeaponTitle => 'Arma do crime selecionada';

  @override
  String get inventoryCrimeWeaponHint => 'Selecione uma arma para crimes';

  @override
  String get inventoryCrimeWeaponHelp =>
      'Escolha sua arma do crime aqui. A tela de crimes utiliza esta seleção imediatamente.';

  @override
  String get inventoryCrimeWeaponEmpty =>
      'Nenhuma arma utilizável no inventário. Compre ou mova uma arma para os itens carregados primeiro.';

  @override
  String get inventoryCarriedEmpty =>
      'Você não está carregando nenhuma ferramenta, arma ou munição.';

  @override
  String get inventorySectionTools => 'Ferramentas';

  @override
  String get inventorySectionWeapons => 'Armas';

  @override
  String get inventorySectionAmmo => 'Munição';

  @override
  String get inventoryWeaponFallbackName => 'Arma';

  @override
  String get inventoryAmmoFallbackName => 'Munição';

  @override
  String inventoryWeaponSubtitle(String condition, String qty) {
    return 'Condição: $condition% • Quantidade: $qty';
  }

  @override
  String inventoryAmmoQuantity(String qty) {
    return 'Quantidade: $qty';
  }

  @override
  String inventoryQuantityValue(int qty) {
    return 'Quantidade: $qty';
  }

  @override
  String inventoryWithdrawDialogTitle(String itemName) {
    return 'Retirar do armazenamento: $itemName';
  }

  @override
  String inventoryMaxShort(int max) {
    return 'Máx.: $max';
  }

  @override
  String get inventoryInvalidQuantity => 'Quantidade inválida';

  @override
  String get inventorySnackWeaponStored => 'Arma armazenada';

  @override
  String get inventorySnackWeaponWithdrawn => 'Arma retirada';

  @override
  String get inventorySnackCashStored => 'Dinheiro depositado';

  @override
  String get inventorySnackCashWithdrawn => 'Dinheiro retirado';

  @override
  String get inventorySnackDrugsWithdrawn => 'Drogas retiradas';

  @override
  String get inventoryActionFailed => 'Falha na ação';

  @override
  String get inventoryStorageNoCategory => 'Nenhum tipo de armazenamento';

  @override
  String get inventoryCountsWeapons => 'Armas';

  @override
  String get inventoryCountsDrugs => 'Drogas';

  @override
  String get inventoryCountsCash => 'Dinheiro';

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
      'Você está em outro país. Você não pode acessar este armazenamento aqui.';

  @override
  String get inventoryWeaponStorageTitle => 'Armazenamento de armas';

  @override
  String get inventoryStoreWeapons => 'Loja';

  @override
  String get inventoryInStorage => 'Em armazenamento';

  @override
  String get inventoryUnknownWeapon => 'Arma desconhecida';

  @override
  String get inventoryTakeOne => 'Pegue 1';

  @override
  String get inventoryNoWeaponsInStorage => 'Não há armas neste depósito.';

  @override
  String get inventoryCashStorageTitle => 'Armazenamento de dinheiro';

  @override
  String get inventoryDepositCash => 'Depositar dinheiro';

  @override
  String get inventoryWithdrawCash => 'Sacar dinheiro';

  @override
  String get inventoryDrugStorageTitle => 'Armazenamento de medicamentos';

  @override
  String get inventoryNoDrugsInStorage => 'Não há drogas armazenadas.';

  @override
  String get inventoryNotForTools =>
      'Esta propriedade não é para armazenamento de ferramentas. Use um depósito para ferramentas.';

  @override
  String get inventoryCategoryTools => 'Ferramentas';

  @override
  String get inventoryCategoryDrugs => 'Drogas';

  @override
  String get inventoryCategoryWeapons => 'Armas';

  @override
  String get inventoryCategoryCash => 'Dinheiro';

  @override
  String inventoryStorageSlotsDetail(int used, int max, String percent) {
    return '$used/$max slots ($percent%)';
  }

  @override
  String get inventoryStorageAccessibleHere => 'Acessível no país atual';

  @override
  String get inventoryStorageNotAccessibleHere => 'Não acessível neste país';

  @override
  String get loadoutEquipFailed => 'Falha ao equipar o carregamento';

  @override
  String get loadoutDeleteFailed => 'Falha ao excluir carregamento';

  @override
  String transferSuccess(String tool, String location) {
    return '✅ $tool mudou para $location';
  }

  @override
  String get carried => 'Carregou';

  @override
  String get storage => 'Armazenar';

  @override
  String get property => 'Propriedade';

  @override
  String inventorySlots(int used, int max) {
    return '$used / $max slots';
  }

  @override
  String get loadouts => 'Carregamentos';

  @override
  String get createLoadout => 'Criar carregamento';

  @override
  String get equipLoadout => 'Equipar';

  @override
  String get loadoutEquipped => '✅ Carregamento equipado';

  @override
  String get loadoutMaxReached => '❌ Cargas máximas atingidas (5)';

  @override
  String loadoutMissingTools(String tools) {
    return '❌ Ferramentas ausentes: $tools';
  }

  @override
  String get backpackUpgrade => 'Atualização de mochila';

  @override
  String get backpackBasic => 'Mochila Básica (+5 espaços)';

  @override
  String get backpackTactical => 'Colete Tático (+10 espaços)';

  @override
  String get backpackCargo => 'Calças Cargo (+3 espaços)';

  @override
  String get upgradeInventory => 'Atualizar inventário';

  @override
  String get noToolsCarried => 'Nenhuma ferramenta transportada';

  @override
  String get visitShopToBuyTools => 'Visite a loja para comprar ferramentas';

  @override
  String get noProperties => 'Nenhuma propriedade';

  @override
  String get buyPropertyForStorage =>
      'Compre um imóvel para guardar ferramentas';

  @override
  String get noToolsInStorage => 'Nenhuma ferramenta no armazenamento';

  @override
  String get selectProperty => 'Selecione a propriedade';

  @override
  String get slotsRemaining => 'vagas restantes';

  @override
  String get noLoadouts => 'Sem carregamentos';

  @override
  String get createLoadoutToStart => 'Crie um carregamento para começar';

  @override
  String get deleteLoadout => 'Excluir carregamento';

  @override
  String get confirmDeleteLoadout =>
      'Tem certeza de que deseja excluir este carregamento?';

  @override
  String get loadoutDeleted => 'Equipamento excluído';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get active => 'Ativa';

  @override
  String get durability => 'Durabilidade';

  @override
  String get quantity => 'Quantidade';

  @override
  String get slotSize => 'Tamanho do slot';

  @override
  String get repairCost => 'Custo de reparo';

  @override
  String get wearPerUse => 'Desgaste por uso';

  @override
  String get loseChance => 'Chance de perder';

  @override
  String get requiredFor => 'Obrigatório para';

  @override
  String get lowDurability => 'Baixa durabilidade';

  @override
  String get transfer => 'Transferir';

  @override
  String get toolDetails => 'Detalhes da ferramenta';

  @override
  String get transferTool => 'Ferramenta de transferência';

  @override
  String get selectQuantity => 'Selecione a quantidade';

  @override
  String get destination => 'Destino';

  @override
  String get from => 'De';

  @override
  String get to => 'Para';

  @override
  String get editLoadout => 'Editar carregamento';

  @override
  String get loadoutName => 'Nome do carregamento';

  @override
  String get description => 'Descrição';

  @override
  String get optional => 'opcional';

  @override
  String get selectedTools => 'Ferramentas selecionadas';

  @override
  String get noToolsAvailable => 'Nenhuma ferramenta disponível';

  @override
  String get create => 'Criar';

  @override
  String get save => 'Salvar';

  @override
  String get pleaseEnterName => 'Por favor insira um nome';

  @override
  String get pleaseSelectTools => 'Selecione pelo menos uma ferramenta';

  @override
  String get loadoutCreated => 'Carregamento criado';

  @override
  String get loadoutUpdated => 'Equipamento atualizado';

  @override
  String get goToInventory => 'Vá para o inventário';

  @override
  String get slots => 'slots';

  @override
  String get backpackShop => 'Loja de mochilas';

  @override
  String get yourBackpack => 'Sua mochila';

  @override
  String get availableUpgrades => 'Atualizações disponíveis';

  @override
  String get otherBackpacks => 'Outras mochilas';

  @override
  String get youHaveBestBackpack => 'Você tem a melhor mochila!';

  @override
  String get backpackPurchased => 'Mochila comprada!';

  @override
  String get backpackUpgraded => 'Mochila atualizada!';

  @override
  String get buyBackpack => 'Comprar';

  @override
  String get upgradeBackpack => 'Atualizar';

  @override
  String get backpackPrice => 'Preço';

  @override
  String get extraSlots => 'Slots extras';

  @override
  String get totalSlots => 'Total de slots';

  @override
  String get vipOnly => 'Apenas VIP';

  @override
  String get tradeInValue => 'Valor de troca';

  @override
  String get upgradeCost => 'Custo de atualização';

  @override
  String rankRequired(Object rank) {
    return 'Classificação $rank necessária';
  }

  @override
  String insufficientFunds(String needed, String have) {
    return 'Você precisa de €$needed. Você tem €$have';
  }

  @override
  String get alreadyHasBackpack => 'Você já tem uma mochila';

  @override
  String get backpackNotFound => 'Mochila não encontrada';

  @override
  String get playerNotFound => 'Jogador não encontrado';

  @override
  String get notAnUpgrade => 'Isto não é uma atualização';

  @override
  String backpackPurchasedEvent(Object name, Object slots) {
    return 'Você comprou $name! +$slots slots.';
  }

  @override
  String backpackUpgradedEvent(Object newName, Object upgradeSlots) {
    return 'Atualizado para $newName! +$upgradeSlots slots extras.';
  }

  @override
  String get backpackPurchaseFailedNotFound => 'Mochila não encontrada';

  @override
  String get backpackPurchaseFailedAlready =>
      'Você já tem uma mochila. Você só pode usar um de cada vez.';

  @override
  String backpackPurchaseFailedRank(Object current, Object required) {
    return 'Você precisa de classificação $required (você tem classificação $current)';
  }

  @override
  String backpackPurchaseFailedFunds(Object have, Object needed) {
    return 'Você precisa de €$needed. Você tem €$have';
  }

  @override
  String get backpackPurchaseFailedVip =>
      'Esta mochila é apenas para membros VIP';

  @override
  String get backpackUpgradeFailedNo => 'Você não tem mochila para atualizar';

  @override
  String get backpackUpgradeFailedNotUpgrade =>
      'Isto não é uma atualização. Escolha uma mochila maior.';

  @override
  String backpackUpgradeFailedRank(Object current, Object required) {
    return 'Você precisa de classificação $required (você tem classificação $current)';
  }

  @override
  String backpackUpgradeFailedFunds(Object have, Object needed) {
    return 'Você precisa de €$needed. Você tem €$have';
  }

  @override
  String get backpackUpgradeFailedVip =>
      'Esta mochila é apenas para membros VIP';

  @override
  String get backpackPurchaseFailedGeneric =>
      'Não foi possível concluir a compra.';

  @override
  String get backpackUpgradeFailedGeneric =>
      'Não foi possível concluir a atualização.';

  @override
  String get backpackUnknownEvent => 'Ação desconhecida';

  @override
  String get backpackLoadFailedGeneric => 'Algo deu errado';

  @override
  String get backpackOwnedBadge => 'Controlada';

  @override
  String get availableBackpacks => 'Mochilas disponíveis';

  @override
  String backpackDialogCurrentLine(String name, int slots) {
    return 'Atual: $name (+$slots slots)';
  }

  @override
  String backpackDialogNewLine(String name, int slots) {
    return 'Novo: $name (+$slots slots)';
  }

  @override
  String backpackDialogUpgradeDelta(int delta) {
    return 'Atualização: +$delta slots';
  }

  @override
  String backpackDialogTotalCapacity(int totalSlots) {
    return 'Total: $totalSlots vagas';
  }

  @override
  String get notLoggedInTokenStorageHint =>
      '(problema de armazenamento – tente fazer login novamente)';

  @override
  String get blackMarketTabBackpacks => 'Mochilas';

  @override
  String get bmHubAdjustFiltersHint => 'Tente ajustar seus filtros';

  @override
  String get bmHubEmptyMyListingsHint =>
      'Veículos na Garagem/Marina, ou ferramentas carregadas em Vender item';

  @override
  String get bmHubSellerLabel => 'Vendedora';

  @override
  String get bmHubAskingPriceLabel => 'Perguntando preço';

  @override
  String get bmHubMarketValueShort => 'Valor de mercado';

  @override
  String get bmHubBuyNow => 'Comprar agora';

  @override
  String get bmHubListedFor => 'Listado para';

  @override
  String get bmHubEditPrice => 'Editar preço';

  @override
  String get bmHubDelist => 'Remover lista';

  @override
  String get bmHubFilterListingsTitle => 'Filtrar listagens';

  @override
  String get bmHubLabelCountry => 'País';

  @override
  String get bmHubAllCountries => 'Todos os países';

  @override
  String get bmHubLabelVehicleType => 'Tipo de veículo';

  @override
  String get bmHubAllTypes => 'Todos os tipos';

  @override
  String get bmHubCars => 'Carros';

  @override
  String get bmHubBoats => 'Barcos';

  @override
  String get bmHubPriceRange => 'Faixa de preço';

  @override
  String get bmHubClearFilters => 'Limpar filtros';

  @override
  String get bmHubApply => 'Aplicar';

  @override
  String get bmHubBuyVehicleTitle => 'Comprar veículo';

  @override
  String bmHubBuyVehicleForConfirm(String name, String price) {
    return 'Comprar $name por $price?';
  }

  @override
  String get bmHubVehiclePurchased => 'Veículo adquirido com sucesso!';

  @override
  String get bmHubVehiclePurchaseFailed => 'Falha ao comprar veículo';

  @override
  String get bmHubNewPriceEuro => 'Novo preço (€)';

  @override
  String get bmHubEnterNewPriceHint => 'Insira o novo preço';

  @override
  String get bmHubCurrentPrice => 'Preço atual';

  @override
  String get bmHubPriceUpdated => 'Preço atualizado com sucesso!';

  @override
  String get bmHubPriceUpdateFailed => 'Falha ao atualizar o preço';

  @override
  String get bmHubUpdateButton => 'Atualizar';

  @override
  String get bmHubDelistVehicleTitle => 'Remover veículo';

  @override
  String bmHubRemoveFromMarketConfirm(String name) {
    return 'Remover $name do mercado?';
  }

  @override
  String get bmHubVehicleDelisted => 'Veículo removido da lista com sucesso!';

  @override
  String get bmHubDelistFailed => 'Falha ao remover veículo';

  @override
  String get bmHubLocationUnknown => 'DESCONHECIDA';

  @override
  String get bmHubNoMarketListingsTitle => 'Sem anúncios';

  @override
  String get bmHubNoMarketListingsBody =>
      'Nada corresponde aos filtros. Liste ferramentas carregadas com Vender item.';

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
  String get bmHubSellCarriedItem => 'Vender item';

  @override
  String bmHubToolQtyDurability(int qty, int pct) {
    return 'Qtd $qty • $pct% estado';
  }

  @override
  String bmHubToolBaseValue(int price) {
    return 'Guia €$price';
  }

  @override
  String get bmHubBuyToolTitle => 'Comprar item';

  @override
  String bmHubBuyToolConfirm(String name, String price) {
    return 'Comprar $name por $price?';
  }

  @override
  String get bmHubToolPurchased => 'Item comprado';

  @override
  String get bmHubToolPurchaseFailed => 'Não foi possível comprar';

  @override
  String get bmHubDelistToolTitle => 'Remover anúncio';

  @override
  String bmHubDelistToolConfirm(String name) {
    return 'Remover $name do mercado?';
  }

  @override
  String get bmHubToolDelisted => 'Anúncio removido';

  @override
  String get bmHubListToolTitle => 'Anunciar item no mercado';

  @override
  String get bmHubListToolSelectLabel => 'Item carregado';

  @override
  String get bmHubListToolSubmit => 'Publicar';

  @override
  String get bmHubToolListedMessage => 'Item publicado';

  @override
  String get bmHubListToolFailed => 'Não foi possível publicar';

  @override
  String get bmHubLoadCarriedToolsFailed =>
      'Não foi possível carregar o inventário';

  @override
  String get bmHubNoCarriedToolsToSell =>
      'Sem itens para vender (ou já anunciados)';

  @override
  String get bmHubInvalidToolPrice => 'Introduza um preço válido';

  @override
  String get arrested => 'Presa!';

  @override
  String get jailMessage =>
      'Você foi preso durante sua viagem e todos os bens foram confiscados!';

  @override
  String get confirmAction => 'Tem certeza?';

  @override
  String get ok => 'OK';

  @override
  String get travelContinueConfirmTitle => 'Prosseguir para a próxima etapa?';

  @override
  String get travelContinueConfirmBody =>
      'As verificações de fronteira estão ativas. Continuar sua jornada?';

  @override
  String get travelJourneyCompleteTitle => 'Jornada concluída';

  @override
  String get travelJourneyCompleteBody =>
      'Você chegou com segurança ao seu destino.';

  @override
  String get hitlist => 'Lista de ocorrências';

  @override
  String hitlistLoadError(String error) {
    return 'Erro ao carregar a lista de ocorrências: $error';
  }

  @override
  String get noActiveHits => 'Nenhum hit ativo colocado';

  @override
  String get selectTarget => 'Selecione o alvo';

  @override
  String get searchPlayer => 'Pesquisar jogador...';

  @override
  String get placeHitTitle => 'Lugar atingido';

  @override
  String get minimumBounty => 'Recompensa mínima: €50.000';

  @override
  String get bountyAmount => 'Valor da recompensa';

  @override
  String get place => 'Lugar';

  @override
  String hitPlaced(String amount) {
    return 'Hit colocado por €$amount';
  }

  @override
  String hitError(String error) {
    return 'Erro: $error';
  }

  @override
  String get hitDifferentCountry => 'Você deve estar no mesmo país que o alvo';

  @override
  String get hitlistErrMissingBounty => 'O valor da recompensa é obrigatório';

  @override
  String get hitlistErrBountyTooLow => 'A recompensa mínima é de € 50.000';

  @override
  String get hitlistErrCannotHitYourself => 'Você não pode acertar em si mesmo';

  @override
  String get hitlistErrHitAlreadyExists =>
      'Você já tem um golpe ativo neste jogador';

  @override
  String get hitlistErrInsufficientMoney => 'Você não tem dinheiro suficiente';

  @override
  String get hitlistErrMissingCounterBounty =>
      'O valor da contra-recompensa é necessário';

  @override
  String get hitlistErrHitNotFound => 'Gol não encontrado';

  @override
  String get hitlistErrNotTarget =>
      'Somente o alvo pode fazer uma contra-oferta';

  @override
  String get hitlistErrHitNotActive => 'O hit não está ativo';

  @override
  String get hitlistErrCounterBountyMustBeHigher =>
      'A contra-recompensa deve ser maior que a recompensa original';

  @override
  String get hitlistErrMissingWeapon => 'Arma é necessária';

  @override
  String get hitlistErrWeaponNotFound => 'Arma não encontrada';

  @override
  String get hitlistErrWeaponNotOwned =>
      'Você não possui esta arma ou ela está quebrada';

  @override
  String get hitlistErrWeaponBroken =>
      'Sua arma selecionada está quebrada. Repare-o primeiro.';

  @override
  String get hitlistErrInsufficientAmmo => 'Você não tem munição suficiente';

  @override
  String get hitlistErrInvalidAmmoHit => 'Quantidade de munição inválida';

  @override
  String get hitlistErrTargetUnderHitProtection =>
      'O alvo tem proteção ativa contra golpes';

  @override
  String get hitlistErrInvalidInvestigationTier =>
      'Tipo de investigação inválido';

  @override
  String get hitlistErrInvestigationAlreadyPending =>
      'Uma investigação já está pendente para este hit. Aguarde sua mensagem de detetive.';

  @override
  String get hitlistErrInvalidCaseId => 'Número de arquivo de caso inválido';

  @override
  String get hitlistErrMurderCaseNotFound => 'Arquivo do caso não encontrado';

  @override
  String get hitlistErrMurderCaseExpired =>
      'A janela de investigação expirou (24 horas)';

  @override
  String get hitlistErrMurderCaseAlreadyRequested =>
      'A investigação deste caso já foi iniciada';

  @override
  String get hitlistErrNotPlacer => 'Somente o placer pode cancelar o acerto';

  @override
  String get hitlistInvestigationOptions => 'Opções de investigação';

  @override
  String get hitlistInvestigationChooseSpeedPrice =>
      'Escolha velocidade e preço:';

  @override
  String get hitlistInvestigationQuick =>
      'Investigação rápida (1.000.000€ • 1 hora)';

  @override
  String get hitlistInvestigationStandard =>
      'Investigação padrão (500.000€ • 6 horas)';

  @override
  String get hitlistInvestigationSlow =>
      'Investigação lenta (€250.000 • 24 horas)';

  @override
  String hitlistInvestigationQueued(
    String cost,
    String etaMinutes,
    String resolveAt,
  ) {
    return 'Investigação na fila. Custo $cost. Hora prevista de chegada: $etaMinutes min. O relatório chegará através de mensagens do Detective Bureau (cerca de $resolveAt).';
  }

  @override
  String get hitlistInvestigationFailedGeneric => 'A investigação falhou';

  @override
  String get hitlistInvestigationCouldNotComplete =>
      'A investigação não pôde ser concluída';

  @override
  String hitlistHitSuccessWithLoot(String cash, String items) {
    return 'Acertou com sucesso! Recompensa e saque recebidos: dinheiro $cash, itens transportados $items.';
  }

  @override
  String get hitlistAttemptTimeout =>
      'A tentativa de acerto expirou. Por favor, tente novamente.';

  @override
  String get hitlistNoUsableWeapons =>
      'Você não tem armas utilizáveis ​​em seu inventário. Compre ou conserte uma arma primeiro.';

  @override
  String hitlistWeaponsInventoryLoadError(String error) {
    return 'Erro ao carregar armas: $error';
  }

  @override
  String hitlistPlayersLoadError(String error) {
    return 'Erro ao carregar jogadores: $error';
  }

  @override
  String get hitlistRelativeOneDayAgo => '1 dia atrás';

  @override
  String hitlistRelativeDaysAgo(String count) {
    return '$count dias atrás';
  }

  @override
  String get counterBountyTitle => 'Coloque contra-recompensa';

  @override
  String minimumAmount(String amount) {
    return 'Valor mínimo: €$amount';
  }

  @override
  String get counterBountyAmount => 'Valor da contra-recompensa';

  @override
  String counterBountyPlaced(String amount) {
    return 'Contra-recompensa de €$amount colocada';
  }

  @override
  String get cancelHitConfirmTitle => 'Cancelar acerto?';

  @override
  String get cancelHitConfirmBody => 'Sua recompensa será reembolsada.';

  @override
  String get hitCancelled => 'Hit cancelado';

  @override
  String get target => 'Alvo';

  @override
  String get placer => 'Colocador';

  @override
  String get bounty => 'Recompensa';

  @override
  String get counterBid => 'CONTRA-OFERTA';

  @override
  String get counterBidPlaced =>
      'Contra-oferta colocada! O contrato foi revertido.';

  @override
  String get attemptHit => 'Tentativa de acertar';

  @override
  String get selectWeapon => 'Selecione Arma e Munição';

  @override
  String get youAreTargeted => 'Você está na lista de alvos';

  @override
  String get security => 'Segurança';

  @override
  String get currentDefense => 'Defesa Atual';

  @override
  String get totalDefense => 'Defesa Total';

  @override
  String get currentArmor => 'Armadura Atual';

  @override
  String get bodyguards => 'Guarda-costas';

  @override
  String get buyBodyguards => 'Compre guarda-costas';

  @override
  String get bodyguardPrice => 'Preço por guarda-costas';

  @override
  String get armor => 'Armadura';

  @override
  String get protectorsFollow => 'Protetores que te seguem';

  @override
  String get eachGivesDefense => 'Cada um dá +10 de defesa';

  @override
  String get lightArmor => 'Armadura Leve';

  @override
  String get basicProtection => 'Proteção básica';

  @override
  String get heavyArmor => 'Armadura Pesada';

  @override
  String get strongProtection => 'Proteção forte';

  @override
  String get bulletproofVest => 'Colete à prova de balas';

  @override
  String get veryStrongProtection => 'Proteção muito forte';

  @override
  String get tacticalSuit => 'Roupa Tática';

  @override
  String get premiumProtection => 'Proteção premium';

  @override
  String get defense => 'Defesa';

  @override
  String defenseIncrease(String armor, String defense) {
    return 'Você comprou $armor! +$defense defesa';
  }

  @override
  String get worn => 'Desgastada';

  @override
  String get replaceArmor => 'Substituir';

  @override
  String get bodyguardProductName => 'Escolta';

  @override
  String securityLoadError(String error) {
    return 'Erro ao carregar segurança: $error';
  }

  @override
  String get securityStatusLoadFailed =>
      'Não foi possível carregar o status de segurança.';

  @override
  String armorConditionLine(String percent, String base) {
    return 'Condição $percent% · base $base';
  }

  @override
  String dailyWageAmount(String amount) {
    return 'Salário diário $amount';
  }

  @override
  String dailySystemCostLine(String amount) {
    return 'Custo diário do sistema: $amount';
  }

  @override
  String nextPayrollAt(String datetime) {
    return 'Próxima folha de pagamento: $datetime';
  }

  @override
  String get bodyguardsLeaveIfUnpaid =>
      'Se você não puder pagar o salário diário, todos os guarda-costas vão embora.';

  @override
  String get armorOneAtATimeHint =>
      'Você só pode usar 1 armadura por vez. Uma nova armadura sempre substitui a atual.';

  @override
  String armorDefenseNowAtCondition(String defense, String percent) {
    return 'Agora +$defense em $percent%';
  }

  @override
  String get couldNotBuyBodyguard => 'Não foi possível comprar guarda-costas';

  @override
  String get couldNotBuyArmor => 'Não foi possível comprar armadura';

  @override
  String get armorAlreadyEquippedLong =>
      'Você já usa essa armadura. Você só pode usar 1 armadura por vez.';

  @override
  String get securityErrorArmorNotFound => 'Armadura não encontrada';

  @override
  String get securityErrorMinQuantity => 'A quantidade deve ser pelo menos 1';

  @override
  String get hit => 'BATER';

  @override
  String get counterBidLabel => 'CONTRA-OFERTA';

  @override
  String daysAgo(String count, String plural) {
    return '$count dia$plural atrás';
  }

  @override
  String get justPlaced => 'Acabei de colocar';

  @override
  String get youAreTheTarget => 'Você é o alvo';

  @override
  String get youAreThePlacer => 'Você é o colocador';

  @override
  String get onlyTargetCanCounterBid =>
      'Somente o alvo pode fazer uma contra-oferta';

  @override
  String get executeHit => 'Executar golpe';

  @override
  String get moneyNotEnough => 'Você não tem dinheiro suficiente';

  @override
  String get securityScreen => 'Segurança';

  @override
  String get currentDefenseStatus => 'Status atual da defesa';

  @override
  String get noWeapons => 'Você não tem armas em seu inventário';

  @override
  String get ammoQuantity => 'Quantidade de munição';

  @override
  String get noAmmoRequired => 'Nenhuma munição necessária para esta arma';

  @override
  String get weaponStats => 'Estatísticas de armas';

  @override
  String get damage => 'Dano';

  @override
  String get intimidation => 'Intimidação';

  @override
  String get execute => 'Executar';

  @override
  String get hitExecuted => 'Hit executado com sucesso!';

  @override
  String get invalidAmmo => 'Insira uma quantidade de munição válida';

  @override
  String get weaponsMarket => 'Mercado de Armas';

  @override
  String get ammoMarket => 'Mercado de Munições';

  @override
  String get shootingRange => 'Campo de tiro';

  @override
  String get ammoFactory => 'Fábrica de munição';

  @override
  String get weaponShop => 'Loja de armas';

  @override
  String get myWeapons => 'Minhas armas';

  @override
  String get weaponPurchased => 'Arma comprada';

  @override
  String weaponRankRequired(String rank) {
    return 'Classificação necessária: $rank';
  }

  @override
  String get buyWeapon => 'Comprar';

  @override
  String get ammoShop => 'Mercado de Munições';

  @override
  String get myAmmo => 'Minha munição';

  @override
  String get ammoPurchased => 'Munição comprada';

  @override
  String get purchaseCooldown => 'Você deve esperar antes da próxima compra';

  @override
  String get insufficientStock => 'Não há estoque suficiente disponível';

  @override
  String get maxInventoryReached => 'Capacidade máxima de estoque atingida';

  @override
  String get invalidQuantity => 'Quantidade inválida';

  @override
  String get nextAmmoPurchase => 'Próxima compra disponível em';

  @override
  String get ammoBoxes => 'Caixas';

  @override
  String ammoRoundsPerBox(String rounds) {
    return '$rounds rodadas por caixa';
  }

  @override
  String ammoYouWillReceive(String rounds) {
    return 'Você receberá: $rounds rodadas';
  }

  @override
  String ammoTotalCost(String cost) {
    return 'Custo total: €$cost';
  }

  @override
  String get ammoRounds => 'rodadas';

  @override
  String get ammoGeneric => 'Munição';

  @override
  String get ammoPerCrimeSuffix => 'por crime';

  @override
  String get ammoBoxesUnit => 'caixas';

  @override
  String get ammoStock => 'Estoque';

  @override
  String get ammoQuality => 'Qualidade';

  @override
  String get factoryBought => 'Comprada de fábrica';

  @override
  String get factoryProduced => 'Produção atualizada';

  @override
  String get factorySessionStarted =>
      'Produção iniciada: ativa por 8 horas, reivindicação a cada 20 minutos';

  @override
  String get ammoFactoryTitle => 'Fábrica de munição';

  @override
  String get ammoFactoryIntro =>
      'Produz em lotes; você reivindica a cada 20 minutos (até 8 horas de pendências por sessão).';

  @override
  String get ammoFactoryWhatYouCanDo => 'O que você pode fazer:';

  @override
  String get ammoFactoryActionBuy => 'Compre uma fábrica em seu país atual';

  @override
  String get ammoFactoryActionProduce =>
      'Produção de reclamações (intervalo: 20 minutos, backlog máximo: 8 horas por sessão)';

  @override
  String get ammoFactoryActionOutput =>
      'Atualize a produção para o nível 5 para mais rodadas por reivindicação';

  @override
  String get ammoFactoryActionQuality =>
      'Atualize a qualidade para preços de mercado mais fortes';

  @override
  String get ammoFactoryBlackMarketTitle => 'Munição à venda';

  @override
  String get ammoFactoryBlackMarketBody =>
      'A fábrica de munição não vende balas diretamente nesta tela. Use o Mercado Negro para comprar e vender munição.';

  @override
  String get ammoFactoryActionBlackMarket =>
      'Compre e venda munição no Mercado Negro, não diretamente da fábrica.';

  @override
  String get ammoFactoryErrCountryRequired => 'O país é obrigatório';

  @override
  String get ammoFactoryErrPlayerNotFound => 'Jogador não encontrado';

  @override
  String get ammoFactoryErrWrongCountry =>
      'Você deve estar no mesmo país para comprar esta fábrica';

  @override
  String get ammoFactoryErrCouldNotPurchase =>
      'Não foi possível comprar a fábrica';

  @override
  String get ammoFactoryErrAlreadyOwned => 'A fábrica já é propriedade';

  @override
  String get ammoFactoryErrInsufficientMoneyBuy =>
      'Não há dinheiro suficiente para comprar fábrica';

  @override
  String get ammoFactoryErrCouldNotProduce =>
      'Não foi possível produzir munição';

  @override
  String get ammoFactoryErrNotOwned => 'Você não possui uma fábrica';

  @override
  String get ammoFactoryErrOnCooldown => 'A fábrica está em espera';

  @override
  String get ammoFactoryErrInactive =>
      'Propriedade da fábrica perdida devido à inatividade';

  @override
  String get ammoFactoryErrCouldNotUpgrade =>
      'Não foi possível atualizar a fábrica';

  @override
  String get ammoFactoryErrInsufficientMoneyUpgrade =>
      'Não há dinheiro suficiente para atualizar a fábrica';

  @override
  String get ammoFactoryErrMaxLevel => 'A fábrica já está no nível máximo';

  @override
  String get ammoFactoryErrInvalidUpgradeType =>
      'O tipo de atualização precisa ser saída ou qualidade';

  @override
  String get ammoFactoryErrEducationNotMet =>
      'Requisitos educacionais não atendidos';

  @override
  String get factoryUpgradeOutputSuccess => 'Saída atualizada';

  @override
  String get factoryUpgradeQualitySuccess => 'Qualidade atualizada';

  @override
  String get myFactory => 'Minha fábrica';

  @override
  String get noFactoryOwned => 'Você não possui uma fábrica';

  @override
  String get factoryCountry => 'País';

  @override
  String get factoryOutputLevel => 'Nível de saída';

  @override
  String get factoryQualityLevel => 'Nível de qualidade';

  @override
  String get factoryLastProduced => 'Última produção';

  @override
  String get factoryProduceStatusLabel => 'Estado da produção';

  @override
  String get factoryProduceStatusReady => 'Pronto';

  @override
  String get factoryProduceStatusCooldown => 'Em espera';

  @override
  String get factorySessionActive =>
      'Janela de produção: ativa (intervalo de 20 minutos)';

  @override
  String get factorySessionStopped =>
      'Janela de produção: interrompida (clique em Produzir para iniciar uma nova janela de 8 horas)';

  @override
  String factorySessionEndsIn(String duration) {
    return 'A janela termina em: $duration';
  }

  @override
  String get factoryNextProductionReady =>
      'Próxima produção: disponível agora (pressione Produzir para reivindicar)';

  @override
  String factoryNextProductionIn(String duration) {
    return 'Próxima produção em: $duration';
  }

  @override
  String get factoryProduce => 'Produzir';

  @override
  String get factoryUpgradeOutput => 'Saída de atualização';

  @override
  String get factoryUpgradeQuality => 'Atualizar qualidade';

  @override
  String get factoryList => 'Fábricas por país';

  @override
  String get factoryUnowned => 'Disponível';

  @override
  String factoryOwnedBy(String owner) {
    return 'Proprietário: $owner';
  }

  @override
  String get factoryBuy => 'Comprar';

  @override
  String get shootingIntro =>
      'Melhore sua precisão e aumente sua taxa de sucesso em crimes';

  @override
  String get shootingTrainSuccess => 'Treinamento concluído';

  @override
  String get shootingMaxSessionsReached =>
      'Máximo de sessões de treinamento atingidas';

  @override
  String get shootingTrainingProgressTitle => 'Progresso do treinamento';

  @override
  String get shootingSessionsCompletedLabel => 'Sessões concluídas:';

  @override
  String get shootingProgressCompleteSuffix => 'completa';

  @override
  String get shootingCurrentBonusTitle => 'Bônus Atual';

  @override
  String get shootingAccuracyBonusLabel => 'Bônus de Precisão';

  @override
  String get shootingMaximumLabel => 'Máxima';

  @override
  String get shootingBonusAppliedToCrimes =>
      'Este bônus é aplicado a todas as suas tentativas de crime';

  @override
  String get shootingReadyToTrain => 'Pronto para treinar';

  @override
  String get shootingTrainingCooldownTitle => 'Tempo de espera do treinamento';

  @override
  String shootingCooldownLabel(String time) {
    return 'Próxima sessão em: $time';
  }

  @override
  String get shootingCooldownHint =>
      'Você deve esperar 1 hora entre as sessões de treinamento';

  @override
  String get shootingTrainingInProgress => 'Treinamento...';

  @override
  String get shootingHowItWorksTitle => 'Como funciona?';

  @override
  String get shootingHowItWorksBullet1 =>
      '• Treine a cada hora para aumentar a precisão';

  @override
  String get shootingHowItWorksBullet2 =>
      '• Cada sessão oferece bônus de +0,1%';

  @override
  String get shootingHowItWorksBullet3 =>
      '• Máximo de 100 sessões (+10% do total)';

  @override
  String get shootingHowItWorksBullet4 =>
      '• Aumenta sua taxa de sucesso criminal';

  @override
  String get shootingHowItWorksBullet5 =>
      '• Bônus permanente, cada sessão conta';

  @override
  String shootingSessions(String count) {
    return 'Sessões: $count/100';
  }

  @override
  String shootingAccuracyBonus(String bonus) {
    return 'Bônus de precisão: $bonus%';
  }

  @override
  String shootingCooldown(String time) {
    return 'Próxima sessão às $time';
  }

  @override
  String get shootingTrain => 'Treinar';

  @override
  String get trainingHubMenuLabel => 'Treinamento';

  @override
  String get trainingHubTitle => 'Centro de treinamento';

  @override
  String get trainingHubSubtitle =>
      'Aumente a força na academia e a precisão no alcance. Cada faixa acumula até 100 sessões com um tempo de espera de 1 hora e aumenta sua chance de sucesso no crime.';

  @override
  String get trainingHubSectionGym => 'Academia';

  @override
  String get trainingHubSectionShooting => 'Campo de tiro';

  @override
  String get trainingHubRefreshStatus => 'Atualizar';

  @override
  String get trainingHubRefreshTooltip => 'Recarregar status do servidor';

  @override
  String get trainingHubOpenCrimes => 'Crimes abertos';

  @override
  String get trainingHubOpenCrimesHint =>
      'Os bônus ativos são exibidos na tela Crimes.';

  @override
  String get trainingHubMoreInfoTitle => 'Mais informações e opções';

  @override
  String get trainingHubMoreInfoCombo =>
      'Mesmo dia UTC: complete pelo menos uma sessão de ginástica e uma sessão de treino para obter um pequeno bônus extra de sucesso no crime (+0,5%).';

  @override
  String get trainingHubMoreInfoSeparate =>
      'A academia e o alcance mantêm seu próprio tempo de espera de 1 hora e limite de 100 sessões.';

  @override
  String get trainingHubMoreInfoHitlist =>
      'O progresso do campo de tiro também alimenta os cálculos da lista de acertos no servidor.';

  @override
  String trainingHubComboChip(String pct) {
    return 'Combo ativo: +$pct% em crimes';
  }

  @override
  String get gym => 'Academia';

  @override
  String get gymIntro =>
      'Treine sua força e aumente sua taxa de sucesso no crime';

  @override
  String get gymTrainSuccess => 'Treinamento concluído';

  @override
  String get gymMaxSessionsReached => 'Máximo de sessões atingido';

  @override
  String get gymTrainingProgressTitle => 'Progresso do treinamento';

  @override
  String get gymSessionsCompletedLabel => 'Sessões concluídas:';

  @override
  String get gymProgressCompleteSuffix => 'completa';

  @override
  String get gymCurrentBonusTitle => 'Bônus Atual';

  @override
  String gymSessions(String count) {
    return 'Sessões: $count/100';
  }

  @override
  String get gymStrengthBonusLabel => 'Bônus de Força';

  @override
  String get gymMaximumLabel => 'Máxima';

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bônus de força: $bonus%';
  }

  @override
  String get gymBonusAppliedToCrimes =>
      'Este bônus é aplicado a todas as suas tentativas de crime';

  @override
  String get gymReadyToTrain => 'Pronto para treinar';

  @override
  String get gymTrainingCooldownTitle => 'Tempo de espera do treinamento';

  @override
  String gymCooldown(String time) {
    return 'Próxima sessão às $time';
  }

  @override
  String get gymCooldownHint =>
      'Você deve esperar 1 hora entre as sessões de treinamento';

  @override
  String get gymTrain => 'Trem';

  @override
  String get gymTrainingInProgress => 'Treinamento...';

  @override
  String get gymHowItWorksTitle => 'Como funciona?';

  @override
  String get gymHowItWorksBullet1 =>
      '• Treine a cada hora para aumentar a força';

  @override
  String get gymHowItWorksBullet2 => '• Cada sessão oferece bônus de +0,08%';

  @override
  String get gymHowItWorksBullet3 => '• Máximo de 100 sessões (+8% do total)';

  @override
  String get gymHowItWorksBullet4 => '• Aumenta sua taxa de sucesso criminal';

  @override
  String get gymHowItWorksBullet5 => '• Bônus permanente, cada sessão conta';

  @override
  String get buyAmmo => 'Comprar munição';

  @override
  String factoryPurchaseCost(String cost) {
    return 'Custo de compra: €$cost';
  }

  @override
  String factoryProductionOutput(String amount) {
    return 'Saída por ciclo: $amount unidades';
  }

  @override
  String factoryQualityMultiplier(String multiplier) {
    return 'Multiplicador de qualidade: ${multiplier}x';
  }

  @override
  String upgradeOutputCost(String cost, String nextAmount) {
    return 'Saída de atualização - Custo: €$cost, Próxima saída: $nextAmount';
  }

  @override
  String upgradeQualityCost(String cost, String nextQuality) {
    return 'Qualidade de atualização - Custo: €$cost, Próxima qualidade: ${nextQuality}x';
  }

  @override
  String get factoryCostLabel => 'Custo';

  @override
  String get factoryCurrentOutput => 'Saída atual';

  @override
  String get factoryNextOutput => 'Próxima saída';

  @override
  String get factoryCurrentQuality => 'Qualidade Atual';

  @override
  String get factoryNextQuality => 'Próxima qualidade';

  @override
  String get factoryUnitsPerCycle => 'unidades/8h máx.';

  @override
  String get factoryUnitsPerHour => 'unidades/hora';

  @override
  String get factoryUpgradeMaxLevel => 'A fábrica está no nível máximo';

  @override
  String get countryUsa => 'EUA';

  @override
  String get countryMexico => 'México';

  @override
  String get countryColombia => 'Colômbia';

  @override
  String get countryBrazil => 'Brasil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryJapan => 'Japão';

  @override
  String get countryChina => 'China';

  @override
  String get countryRussia => 'Rússia';

  @override
  String get countryIndia => 'Índia';

  @override
  String get countryAustralia => 'Austrália';

  @override
  String get countrySouthAfrica => 'África do Sul';

  @override
  String get countryCanada => 'Canadá';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get countryIreland => 'Irlanda';

  @override
  String get countryLuxembourg => 'Luxemburgo';

  @override
  String get countryAustria => 'Áustria';

  @override
  String get countryDenmark => 'Dinamarca';

  @override
  String get countrySweden => 'Suécia';

  @override
  String get countryNorway => 'Noruega';

  @override
  String get countryFinland => 'Finlândia';

  @override
  String get countryPoland => 'Polônia';

  @override
  String get countryCzechia => 'Tcheca';

  @override
  String get countryGreece => 'Grécia';

  @override
  String get countryTurkey => 'Peru';

  @override
  String get countryUae => 'Emirados Árabes Unidos';

  @override
  String get countryDubai => 'Dubai';

  @override
  String get toolBoltCutter => 'Cortador de parafuso';

  @override
  String get toolCarTheftTools => 'Ferramentas para roubo de carro';

  @override
  String get toolBurglaryKit => 'Kit de roubo';

  @override
  String get toolToolbox => 'Caixa de ferramentas';

  @override
  String get toolCrowbar => 'Pé de cabra';

  @override
  String get toolGlassCutter => 'Cortador de vidro';

  @override
  String get toolSprayPaint => 'Tinta spray';

  @override
  String get toolJerryCan => 'Jerry pode';

  @override
  String get toolFakeDocuments => 'Documentos falsos';

  @override
  String get toolHackingLaptop => 'Hackeando laptop';

  @override
  String get toolCounterfeitingKit => 'Kit de falsificação';

  @override
  String get toolRope => 'Corda';

  @override
  String get toolSilencer => 'Silenciadora';

  @override
  String get toolNightVision => 'Visão Noturna';

  @override
  String get toolGpsJammer => 'Bloqueador GPS';

  @override
  String get toolBurnerPhone => 'Telefone queimador';

  @override
  String get toolThermalDrill => 'Broca Térmica';

  @override
  String get toolCategoryBoltCutter => 'Cortadores de parafuso';

  @override
  String get toolCategoryBurglaryKit => 'Kit de roubo';

  @override
  String get toolCategoryCarTools => 'Ferramentas para roubo de carro';

  @override
  String get toolCategoryJerryCan => 'Jerry pode';

  @override
  String get toolCategorySprayPaint => 'Tinta spray';

  @override
  String get toolCategoryCrowbar => 'Pé de cabra';

  @override
  String get toolCategoryGlassCutter => 'Cortador de vidro';

  @override
  String get toolCategoryLaptop => 'Portátil';

  @override
  String get toolCategoryCounterfeiting => 'Falsificação';

  @override
  String get toolCategoryToolbox => 'Caixa de ferramentas';

  @override
  String get toolCategoryRope => 'Corda';

  @override
  String get toolCategorySilencer => 'Silenciadora';

  @override
  String get toolCategoryFakeDocs => 'Documentos falsos';

  @override
  String get toolCategoryNightVision => 'Visão noturna';

  @override
  String get toolCategoryBurnerPhone => 'Telefone queimador';

  @override
  String get toolCategoryGpsJammer => 'Bloqueador de GPS';

  @override
  String get toolCategoryThermalDrill => 'Broca térmica';

  @override
  String get toolsScreenTitle => 'Mercado Negro – Ferramentas';

  @override
  String get toolsTabBuy => 'Comprar';

  @override
  String get toolsTabMyTools => 'Minhas ferramentas';

  @override
  String get toolsNoToolsAvailable => 'Nenhuma ferramenta disponível';

  @override
  String get toolsEmptyInventoryTitle =>
      'Você ainda não tem nenhuma ferramenta';

  @override
  String get toolsEmptyInventoryHint => 'Compre ferramentas na loja';

  @override
  String get toolsNotEnoughMoney => 'Você não tem dinheiro suficiente!';

  @override
  String get toolsNotEnoughMoneyRepair =>
      'Você não tem dinheiro suficiente para consertar!';

  @override
  String get toolsBuyError => 'Erro ao comprar';

  @override
  String get toolsRepairError => 'Erro ao reparar';

  @override
  String toolsPurchased(String toolName) {
    return '$toolName comprado!';
  }

  @override
  String toolsRepaired(String toolName, String cost) {
    return '$toolName reparado por €$cost';
  }

  @override
  String get toolsBadgeInventoryFull => 'COMPLETA';

  @override
  String get toolsBadgeBroken => 'QUEBRADA';

  @override
  String get toolsBadgeRepair => 'REPARAR';

  @override
  String toolsLoadError(String error) {
    return 'Não foi possível carregar as ferramentas: $error';
  }

  @override
  String get toolsErrToolNotFound => 'Ferramenta não encontrada.';

  @override
  String get toolsErrInventoryFullBuy =>
      'Seu inventário está cheio. Armazene algumas ferramentas ou atualize a capacidade.';

  @override
  String get toolsErrPurchaseServer =>
      'A compra da ferramenta falhou devido a um problema no servidor.';

  @override
  String get toolsErrToolNotOwned => 'Você não possui esta ferramenta.';

  @override
  String get toolsErrAlreadyMaxDurability =>
      'A ferramenta já está com durabilidade máxima.';

  @override
  String get toolsErrRepairServer =>
      'O reparo da ferramenta falhou devido a um problema no servidor.';

  @override
  String toolsNetworkError(String error) {
    return 'Erro de rede: $error';
  }

  @override
  String get crimeOutcomeSuccess => 'Crime bem sucedido!';

  @override
  String get crimeOutcomeCaught => 'Pego pela polícia';

  @override
  String get crimeOutcomeVehicleBreakdownBefore =>
      'Seu veículo quebrou antes de chegar à cena do crime';

  @override
  String get crimeOutcomeVehicleBreakdownDuring =>
      'Veículo quebrou durante a fuga - abandonou a maior parte do saque';

  @override
  String get crimeOutcomeOutOfFuel =>
      'Ficou sem combustível durante a fuga - fugiu a pé, perdeu o saque e o veículo';

  @override
  String get crimeOutcomeToolBroke =>
      'Sua ferramenta quebrou durante o crime, deixando evidências';

  @override
  String get crimeOutcomeFledNoLoot => 'Fugiu do local sem saque';

  @override
  String get crimeResultMoneyLabel => 'Dinheiro';

  @override
  String get crimeResultXpLabel => 'XP';

  @override
  String get crimeOutcomeRowReward => 'Recompensa:';

  @override
  String get crimeOutcomeRowXp => 'XP:';

  @override
  String get crimeOutcomeRowTools => 'Ferramentas:';

  @override
  String crimeOutcomeToolDurabilityValue(int percent) {
    return '-$percent% durabilidade';
  }

  @override
  String get icuIntensiveCareTitle => 'Cuidados intensivos';

  @override
  String get icuInjuredLine =>
      'Você ficou gravemente ferido durante suas atividades criminosas.';

  @override
  String get icuUnconsciousLine => 'Você está agora na UTI e inconsciente.';

  @override
  String get icuRecoveryTimeLabel => 'Tempo de recuperação:';

  @override
  String get icuWakeHp => 'Você acorda com 10 HP';

  @override
  String get icuNoActionsHint =>
      'Você não pode realizar ações durante esse período. \nTenha mais cuidado com sua saúde!';

  @override
  String jailBailPaidSnackbar(int amount) {
    return '🎉 Você está livre! Fiança paga: €$amount';
  }

  @override
  String jailInsufficientBail(int amount) {
    return 'Não há dinheiro suficiente para fiança (€$amount)';
  }

  @override
  String jailCooldownWait(int seconds) {
    return 'Aguarde: ${seconds}s';
  }

  @override
  String get jailEscapeSuccess => 'Fuga bem sucedida! Você está livre.';

  @override
  String jailEscapeFailed(String penalty) {
    return 'A fuga falhou. Sentença estendida por $penalty.';
  }

  @override
  String get jailEscapeGenericFailure => 'Falha na fuga';

  @override
  String jailErrorPrefix(String message) {
    return 'Erro: $message';
  }

  @override
  String get jailTimeLeft => 'Tempo restante';

  @override
  String jailPayBail(int amount) {
    return 'Pagar fiança (€$amount)';
  }

  @override
  String get jailCannotActWhileIn =>
      'Você não pode cometer crimes, trabalhar ou viajar enquanto cumpre sua pena.';

  @override
  String get jailAttemptEscape => 'Tentativa de fuga';

  @override
  String get jailYouAreInJail => 'Você está na prisão';

  @override
  String get vehicleCondition => 'Doença';

  @override
  String get vehicleFuel => 'Combustível';

  @override
  String get vehicleSpeed => 'Velocidade';

  @override
  String get vehicleArmor => 'Armadura';

  @override
  String get vehicleStealth => 'Furtiva';

  @override
  String get vehicleCargo => 'Carga';

  @override
  String get vehicleRepair => 'Reparar';

  @override
  String get vehicleRefuel => 'Reabastecer';

  @override
  String get selectCrimeVehicle => 'Selecione Veículo para Crimes';

  @override
  String get noVehicleSelected => 'Nenhum veículo selecionado';

  @override
  String get selectedVehicle => 'Veículo do crime';

  @override
  String get changeVehicle => 'Alterar veículo';

  @override
  String get selectVehicle => 'Selecione o veículo';

  @override
  String get vehicleConditionLow => 'Condição do veículo baixa';

  @override
  String get vehicleFuelLow => 'Combustível do veículo baixo';

  @override
  String get vehicleSelectedForCrimes => 'Veículo selecionado por crimes!';

  @override
  String get vehicleDeselectedForCrimes => 'Veículo desmarcado por crimes!';

  @override
  String get vehicleWrongCountry =>
      'O veículo deve estar no mesmo país que você';

  @override
  String get failedSelectVehicle => 'Falha ao selecionar veículo';

  @override
  String get failedDeselectVehicle => 'Falha ao desmarcar veículo';

  @override
  String get selectedForCrimesBadge => 'Selecionado por crimes';

  @override
  String get selectedButton => 'Selecionada';

  @override
  String get selectButton => 'Selecione';

  @override
  String get deselectButton => 'Desmarcar';

  @override
  String get prostitutionTitle => 'Prostituição';

  @override
  String get prostitutionTotal => 'Total';

  @override
  String get prostitutionStreet => 'Na rua';

  @override
  String get prostitutionRedLight => 'Luz Vermelha';

  @override
  String get prostitutionPotentialEarnings => 'Ganhos';

  @override
  String get prostitutionCollect => 'Coletar';

  @override
  String get prostitutionRecruit => 'Recrutar';

  @override
  String get prostitutionMyProstitutes => 'Minhas prostitutas';

  @override
  String get prostitutionRedLightDistricts => 'Distritos da Luz Vermelha';

  @override
  String get prostitutionNoProstitutes => 'Nenhuma prostituta recrutada ainda';

  @override
  String get prostitutionLocation => 'Localização';

  @override
  String get prostitutionMoveToRedLight => 'Ir para o distrito da luz vermelha';

  @override
  String get prostitutionMoveToRldShort => 'Para RLD';

  @override
  String get prostitutionMoveToStreet => 'Mude para a rua';

  @override
  String get prostitutionViewDistricts => 'Ver Distritos';

  @override
  String get prostitutionAvailable => 'Disponível';

  @override
  String get prostitutionMyDistricts => 'Meus distritos';

  @override
  String get prostitutionCurrentRLD => 'RLD atual';

  @override
  String get prostitutionMyRLDs => 'Meus RLDs';

  @override
  String get prostitutionNoAvailableDistricts => 'Nenhum distrito disponível';

  @override
  String get prostitutionNoOwnedDistricts =>
      'Você ainda não possui nenhum distrito';

  @override
  String get prostitutionRooms => 'quartas';

  @override
  String get prostitutionOccupancy => 'Ocupação';

  @override
  String get prostitutionIncome => 'Renda';

  @override
  String get prostitutionTenants => 'Inquilinos';

  @override
  String get prostitutionBuy => 'Comprar';

  @override
  String get prostitutionManage => 'Gerenciar';

  @override
  String get prostitutionPurchaseConfirmTitle => 'Comprar Distrito';

  @override
  String prostitutionPurchaseConfirmMessage(String country, int price) {
    return 'Tem certeza de que deseja comprar o Red Light District em $country por €$price?';
  }

  @override
  String get prostitutionPurchase => 'Comprar';

  @override
  String get prostitutionPurchaseSuccess => 'Distrito adquirido com sucesso!';

  @override
  String get prostitutionPurchaseFailed => 'Falha na compra';

  @override
  String get prostitutionDistrictManagement => 'Gestão Distrital';

  @override
  String get prostitutionDistrictNotFound => 'Distrito não encontrado';

  @override
  String get prostitutionDistrictOwnedBadge => 'Controlada';

  @override
  String get prostitutionOwnerLabel => 'Proprietária:';

  @override
  String get prostitutionForSale => 'À venda';

  @override
  String get prostitutionRoomsLabel => 'Quartas:';

  @override
  String get prostitutionRoomsRented => 'alugada';

  @override
  String prostitutionRldAppBarTitle(String country) {
    return 'Distrito da Luz Vermelha ($country)';
  }

  @override
  String get prostitutionOccupiedShort => 'Ocupada';

  @override
  String get prostitutionNotApplicable => 'N / D';

  @override
  String get back => 'Voltar';

  @override
  String prostitutionMoveToStreetConfirm(String name) {
    return 'Tem certeza de que deseja mudar $name do Red Light District para a rua?';
  }

  @override
  String get prostitutionMoveSuccess => 'Movido com sucesso';

  @override
  String get prostitutionMoveFailed => 'Falha na movimentação';

  @override
  String get prostitutionNoStreetProstitutes =>
      'Não há prostitutas disponíveis na rua';

  @override
  String get prostitutionSelectProstitute => 'Selecione Prostituta';

  @override
  String get prostitutionOnStreet => 'Na rua';

  @override
  String get prostitutionRoom => 'Sala';

  @override
  String get prostitutionInRedLight => 'No Distrito da Luz Vermelha';

  @override
  String get prostitutionEarnings => 'Ganhos';

  @override
  String get prostitutionRent => 'Aluguel';

  @override
  String get prostitutionNetIncome => 'Resultado líquido';

  @override
  String get prostitutionLevel => 'Nível';

  @override
  String get prostitutionXpToNext => 'XP para o próximo nível';

  @override
  String get prostitutionBusted => 'PEGO';

  @override
  String get prostitutionBustedCount => 'Tempos quebrados';

  @override
  String get prostitutionLevelBonus => 'Bônus de nível';

  @override
  String get prostitutionVipBonus => 'Bônus VIP: +50% de ganhos';

  @override
  String get prostitutionUpgradeTier => 'Nível de atualização';

  @override
  String get prostitutionUpgradeSecurity => 'Atualizar segurança';

  @override
  String get prostitutionTier => 'Nível';

  @override
  String get prostitutionSecurity => 'Segurança';

  @override
  String get prostitutionTierBasic => 'Básica';

  @override
  String get prostitutionTierLuxury => 'Luxo';

  @override
  String get prostitutionTierVip => 'VIP';

  @override
  String get prostitutionSecurityLevel => 'Nível de segurança';

  @override
  String get prostitutionRaidChance => 'Chance de ataque';

  @override
  String get prostitutionMaxTier => 'Nível máximo alcançado';

  @override
  String get prostitutionMaxSecurity => 'Segurança máxima alcançada';

  @override
  String get prostitutionUpgradeSuccess => 'Atualização bem-sucedida!';

  @override
  String get prostitutionUpgradeFailed => 'Falha na atualização';

  @override
  String get vipEventsTitle => 'Eventos VIP';

  @override
  String get vipEventsTabTitle => 'Eventos VIP';

  @override
  String get vipEventsDescription =>
      'Designe prostitutas para eventos VIP para ganhar bônus!';

  @override
  String get vipEventsActive => 'Eventos ativos';

  @override
  String get vipEventsUpcoming => 'Próximos eventos';

  @override
  String get vipEventsMyParticipations => 'Minhas participações ativas';

  @override
  String get vipEventTypeTitle => 'Evento VIP';

  @override
  String get vipEventCelebrity => 'Visita de celebridade';

  @override
  String get vipEventBachelor => 'Despedida de solteiro';

  @override
  String get vipEventConvention => 'Convenção';

  @override
  String get vipEventFestival => 'Festival';

  @override
  String get vipEventBonus => 'BÔNUS';

  @override
  String get vipEventSpots => 'manchas';

  @override
  String get vipEventParticipants => 'Participantes';

  @override
  String get vipEventFull => 'EVENTO COMPLETO';

  @override
  String get vipEventRequires => 'Requer';

  @override
  String get vipEventLevel => 'Nível';

  @override
  String get vipEventLocation => 'Localização';

  @override
  String get vipEventEndsIn => 'Termina em';

  @override
  String get vipEventStartsIn => 'Começa em';

  @override
  String get vipEventNoActive => 'Nenhum evento ativo no momento';

  @override
  String get vipEventNoUpcoming => 'Não há eventos futuros';

  @override
  String get vipEventAssignProstitute => 'Atribuir Prostituta';

  @override
  String get vipEventAssignDialogTitle => 'Atribuir a';

  @override
  String vipEventNoEligible(int level, String country) {
    return 'Nenhuma prostituta elegível. Precisa de nível $level+ em $country';
  }

  @override
  String get vipEventJoinSuccess => 'Participou do evento!';

  @override
  String get vipEventJoinFailed => 'Falha ao participar do evento';

  @override
  String get vipEventLeave => 'Sair do Evento';

  @override
  String get vipEventLeaveSuccess => 'Evento esquerdo';

  @override
  String get vipEventLeaveFailed => 'Não foi possível sair do evento';

  @override
  String get vipEventAssigned => 'Atribuída';

  @override
  String get vipEventPerHour => '/hora';

  @override
  String get vipEventEarnings => 'Ganhos';

  @override
  String get prostitutionLeaderboardTitle =>
      'Tabela de classificação de prostituição';

  @override
  String get prostitutionLeaderboardWeekly => 'Semanalmente';

  @override
  String get prostitutionLeaderboardMonthly => 'Mensal';

  @override
  String get prostitutionLeaderboardAllTime => 'De todos os tempos';

  @override
  String get prostitutionLeaderboardYourRank => 'Sua classificação semanal';

  @override
  String get prostitutionLeaderboardUnranked => 'Sem classificação';

  @override
  String get prostitutionLeaderboardNoData =>
      'Ainda não há dados da tabela de classificação';

  @override
  String get prostitutionLeaderboardButton => 'Tabela de classificação';

  @override
  String get prostitutionRivalryButton => 'Rivalidade';

  @override
  String get prostitutionLeaderboardAchievements => 'Conquistas';

  @override
  String get prostitutionLeaderboardLoadFailed =>
      'Não foi possível carregar o placar';

  @override
  String get achievementsTitle => 'Conquistas';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked de $total desbloqueado';
  }

  @override
  String get achievementsCategoryAll => 'Todos';

  @override
  String get achievementsCategoryProgression => 'Progressão';

  @override
  String get achievementsCategoryWealth => 'Fortuna';

  @override
  String get achievementsCategoryPower => 'Poder';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMastery => 'Domínio';

  @override
  String get achievementLocked => 'Bloqueado';

  @override
  String get achievementReward => 'Recompensa';

  @override
  String get achievementUnlocked => 'Desbloqueada';

  @override
  String get achievementNoData => 'Nenhuma conquista encontrada';

  @override
  String get achievementLoadFailed => 'Não foi possível carregar as conquistas';

  @override
  String achievementsMoney(String amount) {
    return '€$amount';
  }

  @override
  String achievementsXp(String xp) {
    return '${xp}XP';
  }

  @override
  String achievementsUnlockedDate(String date) {
    return 'Desbloqueado em $date';
  }

  @override
  String achievementsDetailProgress(int current, int required) {
    return 'Progresso: $current/$required';
  }

  @override
  String get achievementsNoRewardConfigured =>
      'Nenhuma recompensa configurada ainda';

  @override
  String get achievementsRewardOnUnlock =>
      'Você recebe esta recompensa assim que a conquista for desbloqueada.';

  @override
  String get achievementsDateToday => 'Hoje';

  @override
  String get achievementsDateYesterday => 'Ontem';

  @override
  String achievementsDateDaysAgo(int days) {
    return '$days dias atrás';
  }

  @override
  String get achievementsDetails => 'Detalhes';

  @override
  String get achievementsCategory => 'Categoria';

  @override
  String get achievementsSectionProgress => 'Progresso';

  @override
  String achievementsPercentComplete(int percent) {
    return '$percent% concluído';
  }

  @override
  String get achievementsCategoryNameProstitution => 'Prostituição';

  @override
  String get achievementsCategoryNameRld => 'RLD';

  @override
  String get achievementsCategoryNameCrimes => 'Crimes';

  @override
  String get achievementsCategoryNameJobs => 'Trabalhos';

  @override
  String get achievementsCategoryNameSchool => 'Escola';

  @override
  String get achievementsCategoryNameVehicles => 'Veículos';

  @override
  String get achievementsCategoryNameTravel => 'Viagens';

  @override
  String get achievementsCategoryNameDrugs => 'Drogas';

  @override
  String get achievementsCategoryNameTrade => 'Comércio';

  @override
  String get achievementsCategoryNameGeneral => 'Geral';

  @override
  String get achievementJobItSpecialistTitle => 'Especialista em TI';

  @override
  String get achievementJobItSpecialistDescription =>
      'Conclua seu primeiro turno como programador';

  @override
  String get achievementJobLawyerTitle => 'Advogado de rua';

  @override
  String get achievementJobLawyerDescription =>
      'Conclua seu primeiro turno como advogado';

  @override
  String get achievementJobDoctorTitle => 'Médico Subterrâneo';

  @override
  String get achievementJobDoctorDescription =>
      'Complete seu primeiro turno como médico';

  @override
  String get achievementSchoolCertifiedTitle => 'Aluno Certificado';

  @override
  String get achievementSchoolCertifiedDescription =>
      'Ganhe 3 certificações escolares';

  @override
  String get achievementSchoolMultiCertifiedTitle => 'Multicertificado';

  @override
  String get achievementSchoolMultiCertifiedDescription =>
      'Ganhe 6 certificações escolares';

  @override
  String get achievementSchoolTrackSpecialistTitle => 'Especialista em pista';

  @override
  String get achievementSchoolTrackSpecialistDescription =>
      'Máximo de 3 trilhas escolares';

  @override
  String get schoolMenuLabel => 'Escola';

  @override
  String get schoolMenuSubtitle => 'Nivele sua educação e certificações';

  @override
  String get schoolTitle => 'Escola e Educação';

  @override
  String get schoolIntro =>
      'Desbloqueie empregos e ativos por meio de níveis e certificações.';

  @override
  String get schoolTracksTitle => 'Educação disponível';

  @override
  String get schoolUnlockableContentTitle => 'Educação bloqueada';

  @override
  String schoolOverallLevelLabel(int level) {
    return 'Nível escolar: $level';
  }

  @override
  String schoolLoadError(String error) {
    return 'Não foi possível carregar os dados da escola: $error';
  }

  @override
  String schoolTrackLevelLabel(int current, int max) {
    return 'Nível $current/$max';
  }

  @override
  String schoolXpLabel(int xp) {
    return 'EXP: $xp';
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
    return '$name (Nível $level)';
  }

  @override
  String get schoolGateStatusOpen => 'ABRIR';

  @override
  String get schoolGateStatusLocked => 'BLOQUEADO';

  @override
  String schoolGateRankProgress(int current, int required) {
    return 'Classificação do jogador: $current/$required';
  }

  @override
  String schoolGateTrackLevelProgress(String track, int current, int required) {
    return '$track nível: $current/$required';
  }

  @override
  String schoolGateJobTarget(String target) {
    return 'Trabalho: $target';
  }

  @override
  String get schoolGateAssetCasinoPurchase => 'Ativo: compra de cassino';

  @override
  String get schoolGateAssetAmmoFactoryPurchase =>
      'Ativo: compra de fábrica de munição';

  @override
  String get schoolGateAssetAmmoOutputUpgrade =>
      'Ativo: atualização de saída de munição';

  @override
  String get schoolGateAssetAmmoQualityUpgrade =>
      'Ativo: atualização de qualidade de munição';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier1 =>
      'Ativo: Atualização de slot de instalação de medicamentos I';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier2 =>
      'Ativo: Atualização II do slot da instalação de medicamentos';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier3 =>
      'Ativo: Atualização de slot de instalação de medicamentos III';

  @override
  String get schoolGateAssetDrugFacilitySlotsTier4 =>
      'Ativo: Atualização IV do slot da instalação de medicamentos';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier1 =>
      'Ativo: Atualização de equipamento de instalação de medicamentos I';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier2 =>
      'Ativo: Atualização de equipamento de instalação de medicamentos II';

  @override
  String get schoolGateAssetDrugFacilityEquipmentTier3 =>
      'Ativo: Atualização de equipamento de instalação de medicamentos III';

  @override
  String schoolGateAssetGeneric(String target) {
    return 'Ativo: $target';
  }

  @override
  String schoolGateSystemGeneric(String type, String target) {
    return '$type: $target';
  }

  @override
  String get educationDialogDefaultTitle => '🔒 Educação necessária';

  @override
  String get educationDialogFallbackMessage =>
      'Requisitos não atendidos. Complete os requisitos de educação para continuar.';

  @override
  String get educationDialogClose => 'Fechar';

  @override
  String get educationLockedJobsSectionTitle =>
      '🔒 Empregos bloqueados (é necessária educação)';

  @override
  String get educationAmmoOutputUpgradeLockedTitle =>
      '🔒 Atualização de saída bloqueada';

  @override
  String get educationAmmoQualityUpgradeLockedTitle =>
      '🔒 Atualização de qualidade bloqueada';

  @override
  String get educationAmmoFactoryPurchaseLockedTitle =>
      '🔒 Compra de fábrica bloqueada';

  @override
  String educationRequirementRankProgress(int requiredRank, int currentRank) {
    return 'Precisa de classificação do jogador $requiredRank · Classificação atual do jogador $currentRank';
  }

  @override
  String get educationRequirementTrackLevelTitle => 'Nível de escolaridade';

  @override
  String educationRequirementTrackLevelProgress(
    String trackName,
    int requiredLevel,
    int currentLevel,
  ) {
    return '$trackName nível $requiredLevel obrigatório · Atual $currentLevel';
  }

  @override
  String get educationRequirementCertificationTitle =>
      'Certificação necessária';

  @override
  String get educationRequirementGenericTitle => 'Exigência';

  @override
  String get educationRequirementUnknown => 'Requisito desconhecido';

  @override
  String get educationTrackNameAviation => 'Aviação';

  @override
  String get educationTrackNameLaw => 'Lei';

  @override
  String get educationTrackNameMedicine => 'Medicamento';

  @override
  String get educationTrackNameFinance => 'Financiar';

  @override
  String get educationTrackNameEngineering => 'Engenharia';

  @override
  String get educationTrackNameIt => 'IT';

  @override
  String get educationTrackNameNarcotics => 'Engenharia de Narcóticos';

  @override
  String get schoolTrackDescriptionAviation =>
      'Teoria de vôo, navegação e operação de aeronaves.';

  @override
  String get schoolTrackDescriptionLaw =>
      'Direito penal, procedimento e prática judicial.';

  @override
  String get schoolTrackDescriptionMedicine =>
      'Resposta a emergências, diagnóstico e prática médica.';

  @override
  String get schoolTrackDescriptionFinance =>
      'Contabilidade, investimentos e operações comerciais.';

  @override
  String get schoolTrackDescriptionEngineering =>
      'Sistemas mecânicos, segurança industrial e fabricação.';

  @override
  String get schoolTrackDescriptionIt =>
      'Desenvolvimento de software, sistemas e operações de rede.';

  @override
  String get schoolTrackDescriptionNarcotics =>
      'Cultivo controlado, processos elétricos e produção química avançada.';

  @override
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown ativo: ${seconds}s restantes';
  }

  @override
  String get schoolTrackMaxLevelReached => 'A trilha já está no nível máximo';

  @override
  String get schoolTrackStartFailed => 'Falha ao iniciar o treinamento';

  @override
  String get educationCertHydroponicSpecialist =>
      'Certificação de Especialista em Hidroponia';

  @override
  String get educationCertProcessElectricsSpecialist =>
      'Certificação de Especialista em Elétrica de Processo';

  @override
  String get educationCertClandestineChemist =>
      'Certificação de Químico Clandestino';

  @override
  String get educationCertNarcoGridArchitect =>
      'Certificação Narco Grid Architect';

  @override
  String get educationCertSoftwareEngineer =>
      'Certificação de Engenheiro de Software';

  @override
  String get educationCertBarExam => 'Exame da Ordem';

  @override
  String get educationCertMedicalLicense => 'Licença Médica';

  @override
  String get educationCertFlightCommercial => 'Licença de voo comercial';

  @override
  String get educationCertFlightBasic => 'Licença Básica de Voo';

  @override
  String get educationCertIndustrialSafety =>
      'Certificação de Segurança Industrial';

  @override
  String get educationCertFinancialAnalyst =>
      'Certificação de Analista Financeiro';

  @override
  String get educationCertCasinoManagement =>
      'Certificação de gerenciamento de cassino';

  @override
  String get educationCertParamedic => 'Certificação Paramédica';

  @override
  String get prostitutionLeaderboardProstitutesUnit => 'prostitutas';

  @override
  String get prostitutionLeaderboardDistrictsUnit => 'distritos';

  @override
  String get rivalryTitle => 'Rivalidade';

  @override
  String get rivalryChallengeTitle => 'Jogador de Desafio';

  @override
  String get rivalryChallengeHint =>
      'Introduz um nome de jogador (ou ID) para iniciar uma rivalidade.';

  @override
  String get rivalryPlayerIdHint => 'Nome ou ID do jogador';

  @override
  String get rivalryStartButton => 'Começar';

  @override
  String get rivalryNoActive => 'Nenhuma rivalidade ativa ainda.';

  @override
  String get rivalryActiveTitle => 'Rivais Ativos';

  @override
  String get rivalryScoreLabel => 'Pontuação de rivalidade';

  @override
  String get rivalryRecentActivity => 'Atividade recente';

  @override
  String get rivalryNoActivity => 'Nenhuma atividade de sabotagem ainda';

  @override
  String get rivalryCooldownReady => 'Sabotagem pronta';

  @override
  String rivalryCooldownIn(String duration) {
    return 'Tempo de espera: $duration';
  }

  @override
  String get rivalryActionTipPolice => 'Gorjeta Polícia (5 mil euros)';

  @override
  String get rivalryActionStealCustomer => 'Roubar cliente (3 mil euros)';

  @override
  String get rivalryActionDamageReputation => 'Reputação de danos (€ 10k)';

  @override
  String get rivalryActionBribeEmployee =>
      'Funcionário subornado (8 mil euros)';

  @override
  String get rivalryUpdateMessage => 'Rivalidade atualizada';

  @override
  String get rivalrySabotageExecuted => 'Sabotagem executada';

  @override
  String get rivalryConfirmTitle => 'Confirmar sabotagem';

  @override
  String rivalryConfirmTarget(String username) {
    return 'Alvo: $username';
  }

  @override
  String rivalryConfirmAction(String action) {
    return 'Ação: $action';
  }

  @override
  String rivalryConfirmCost(int amount) {
    return 'Custo: €$amount';
  }

  @override
  String rivalryConfirmEffect(String effect) {
    return 'Efeito: $effect';
  }

  @override
  String get rivalryConfirmWarning =>
      'O sucesso não é garantido e você pode perder dinheiro.';

  @override
  String get rivalryExecuteButton => 'Executar';

  @override
  String get rivalryEffectTipPolice => 'Aumentar a pressão policial rival';

  @override
  String get rivalryEffectStealCustomer =>
      'Roube parte do fluxo de caixa rival';

  @override
  String get rivalryEffectDamageReputation =>
      'Menor progresso da prostituta rival';

  @override
  String get rivalryEffectBribeEmployee =>
      'Forçar uma prostituta rival a ser presa';

  @override
  String get prostitutionUnderAttackTitle => 'Seu império está sob ataque';

  @override
  String prostitutionUnderAttackBody(String attacker, String action) {
    return '$attacker usou $action contra você nas últimas 24h.';
  }

  @override
  String get prostitutionUnderAttackAction => 'Rivalidade aberta';

  @override
  String get prostitutionBetrayalDefaultMessage =>
      'Traição! Seu Nightclub foi atingido por um vazamento de informações.';

  @override
  String get prostitutionLoadError => 'Erro ao carregar os dados';

  @override
  String get prostitutionNoDistrictInCountry =>
      'Não há distrito da luz vermelha neste país';

  @override
  String get prostitutionMovedToStreet => 'Movida para a rua';

  @override
  String get prostitutionArrestedCannotAssign =>
      'Esta prostituta está presa e não pode ser designada.';

  @override
  String get prostitutionNoNightclubVenue =>
      'Você ainda não tem um local de Nightclub para designar equipe.';

  @override
  String get prostitutionNightclubVenueName => 'Boate';

  @override
  String prostitutionNightclubVenueNumbered(int id) {
    return 'Boate #$id';
  }

  @override
  String get prostitutionAssignedNightclub => 'Designada ao Nightclub';

  @override
  String get prostitutionArrestedCannotWork =>
      'Esta prostituta está presa e não pode trabalhar.';

  @override
  String prostitutionShiftRestNeeded(String duration) {
    return 'Ainda $duration de descanso antes do próximo turno.';
  }

  @override
  String get prostitutionWorkShiftCompleted => 'Turno concluído';

  @override
  String get prostitutionNoWorkersToAssign =>
      'Não há prostitutas disponíveis para mandar trabalhar.';

  @override
  String prostitutionWorkAllSentCount(int count) {
    return '$count prostitutas enviadas para trabalhar.';
  }

  @override
  String prostitutionWorkAllPartial(int success, int failed) {
    return '$success enviadas para trabalhar, $failed falharam.';
  }

  @override
  String get prostitutionRecruitedDefault => 'Recrutada!';

  @override
  String get prostitutionRecruitFailed => 'Recrutamento falhou';

  @override
  String get prostitutionRecruitConnectionError =>
      'Recrutamento falhou por erro de conexão';

  @override
  String get prostitutionEventUpdate => 'Evento atualizado';

  @override
  String get prostitutionBuyPropertyFirst =>
      'Compre primeiro uma casa ou apartamento';

  @override
  String prostitutionWorkAll(int count) {
    return 'Mandar todas trabalhar ($count)';
  }

  @override
  String get prostitutionNoHousingForRecruit =>
      'Sem vaga de moradia. Compre ou melhore uma casa ou apartamento antes de recrutar mais prostitutas.';

  @override
  String get prostitutionHousingTitle => 'Moradia';

  @override
  String prostitutionHousingRentRule(int days) {
    return 'Cada prostituta deve cumprir pelo menos um turno a cada $days dias para pagar o aluguel.';
  }

  @override
  String get prostitutionHousingSlots => 'Vagas';

  @override
  String get prostitutionHousingFree => 'Livre';

  @override
  String get prostitutionHousingHomes => 'Imóveis';

  @override
  String get prostitutionHousingAvgUpgrade => 'Melhoria méd.';

  @override
  String get prostitutionHousingHappinessBonus => 'Bônus de felicidade';

  @override
  String get prostitutionHousingWeeklyRent => 'Aluguel semanal';

  @override
  String get prostitutionHousingAtRisk => 'Em risco';

  @override
  String get prostitutionHousingSafe => 'Seguro';

  @override
  String prostitutionBetrayalActiveDetail(int grams, int licenses) {
    return 'Traição ativada: $grams g de drogas apreendidas, $licenses licença(s) de Nightclub revogada(s).';
  }

  @override
  String get prostitutionEarningsInsightTitle =>
      'Visão de ganhos (prostitutas ativas)';

  @override
  String prostitutionEarningsStreetDetail(int count, int euros) {
    return 'Rua: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsRldDetail(int count, int euros) {
    return 'Distrito da luz vermelha: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsNightclubDetail(int count, int euros) {
    return 'Nightclub: $count • €$euros/h';
  }

  @override
  String prostitutionEarningsTotalDetail(int euros) {
    return 'Total: €$euros/h';
  }

  @override
  String get prostitutionHappinessEcstatic => 'Extática';

  @override
  String get prostitutionHappinessHappy => 'Feliz';

  @override
  String get prostitutionHappinessStable => 'Estável';

  @override
  String get prostitutionHappinessStressed => 'Estressada';

  @override
  String get prostitutionHappinessMiserable => 'Miserável';

  @override
  String get prostitutionHousingExpired => 'Expirado';

  @override
  String prostitutionHousingDaysLeft(int days) {
    return 'faltam $days d.';
  }

  @override
  String get prostitutionHousingLessThanOneDay => 'Menos de 1 dia';

  @override
  String get prostitutionNightclubShort => 'Boate';

  @override
  String get prostitutionMoveToStreetButton => 'Para a rua';

  @override
  String get prostitutionMoveToNightclubButton => 'Para o Nightclub';

  @override
  String prostitutionEuroPerHour(String amount) {
    return '€$amount/h';
  }

  @override
  String prostitutionHappinessDetail(String label, int score, String bonus) {
    return 'Felicidade $label ($score%) • Rendimento $bonus';
  }

  @override
  String prostitutionHousingStatus(String status) {
    return 'Moradia: $status';
  }

  @override
  String prostitutionWeeklyRentEuro(int amount) {
    return 'Aluguel semanal €$amount';
  }

  @override
  String get prostitutionWork8h => 'Trabalhar 8 h';

  @override
  String prostitutionRestFor(String duration) {
    return 'Descansar $duration';
  }

  @override
  String prostitutionNextShiftIn(String duration) {
    return 'Próximo turno em $duration';
  }

  @override
  String prostitutionTimeHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get rivalryProtectionTitle => 'Seguro de Proteção';

  @override
  String get rivalryProtectionDescription =>
      'Reduz o impacto da sabotagem recebida em 30% por 7 dias.';

  @override
  String get rivalryProtectionInactive => 'Sem proteção ativa';

  @override
  String rivalryProtectionActive(String date) {
    return 'Ativo até: $date';
  }

  @override
  String get rivalryProtectionBuy => 'Compre proteção (25 mil euros/semana)';

  @override
  String get rivalryProtectionActivated => 'Seguro de proteção ativado';

  @override
  String get achievementTitle_first_steps => 'Primeiros passos';

  @override
  String get achievementDescription_first_steps =>
      'Recrute sua primeira prostituta';

  @override
  String get achievementTitle_growing_empire => 'Império Crescente';

  @override
  String get achievementDescription_growing_empire => 'Recrute 5 prostitutas';

  @override
  String get achievementTitle_first_district => 'Primeiro Distrito';

  @override
  String get achievementDescription_first_district =>
      'Compre seu primeiro distrito da luz vermelha';

  @override
  String get achievementTitle_empire_builder => 'Construtor de Império';

  @override
  String get achievementDescription_empire_builder =>
      'Possui 5 distritos da luz vermelha';

  @override
  String get achievementTitle_district_master => 'Mestre Distrital';

  @override
  String get achievementDescription_district_master =>
      'Possui 10 distritos da luz vermelha';

  @override
  String get achievementTitle_leveling_master => 'Mestre de nivelamento';

  @override
  String get achievementDescription_leveling_master =>
      'Maximize uma prostituta até o nível 10';

  @override
  String get achievementTitle_untouchable => 'Intocável';

  @override
  String get achievementDescription_untouchable =>
      'Nunca seja preso por 7 dias consecutivos';

  @override
  String get achievementTitle_millionaire => 'Milionário';

  @override
  String get achievementDescription_millionaire =>
      'Acumule ganhos totais de € 1.000.000';

  @override
  String get achievementTitle_high_roller => 'Grande apostador';

  @override
  String get achievementDescription_high_roller =>
      'Acumule ganhos totais de € 5.000.000';

  @override
  String get achievementTitle_vip_service => 'Serviço VIP';

  @override
  String get achievementDescription_vip_service => 'Conclua 10 eventos VIP';

  @override
  String get achievementTitle_event_enthusiast => 'Entusiasta de Eventos';

  @override
  String get achievementDescription_event_enthusiast =>
      'Conclua 25 eventos VIP';

  @override
  String get achievementTitle_security_expert => 'Especialista em segurança';

  @override
  String get achievementDescription_security_expert =>
      'Maximize o nível de segurança em todos os distritos próprios';

  @override
  String get achievementTitle_luxury_provider => 'Provedor de luxo';

  @override
  String get achievementDescription_luxury_provider =>
      'Atualize 3 distritos para o nível VIP';

  @override
  String get achievementTitle_rivalry_victor => 'Rivalidade Victor';

  @override
  String get achievementDescription_rivalry_victor =>
      'Sabotar rivais com sucesso 10 vezes';

  @override
  String get achievementTitle_untouchable_rival => 'Rival Intocável';

  @override
  String get achievementDescription_untouchable_rival =>
      'Defenda-se contra 20 tentativas de sabotagem';

  @override
  String get achievementTitle_crime_first_blood => 'Crime primeiro sangue';

  @override
  String get achievementDescription_crime_first_blood =>
      'Complete com sucesso seu primeiro crime';

  @override
  String get achievementTitle_crime_hustler => 'Traficante do crime';

  @override
  String get achievementDescription_crime_hustler =>
      'Complete com sucesso 5 crimes';

  @override
  String get achievementTitle_crime_novice => 'Novato em Crime';

  @override
  String get achievementDescription_crime_novice =>
      'Complete com sucesso 10 crimes';

  @override
  String get achievementTitle_crime_operator => 'Operador de Crime';

  @override
  String get achievementDescription_crime_operator =>
      'Complete com sucesso 25 crimes';

  @override
  String get achievementTitle_crime_wave => 'Onda de crimes';

  @override
  String get achievementDescription_crime_wave =>
      'Complete com sucesso 50 crimes';

  @override
  String get achievementTitle_crime_mastermind => 'Mentor do crime';

  @override
  String get achievementDescription_crime_mastermind =>
      'Complete com sucesso 100 crimes';

  @override
  String get achievementTitle_the_godfather => 'O padrinho';

  @override
  String get achievementDescription_the_godfather =>
      'Complete com sucesso 250 crimes';

  @override
  String get achievementTitle_crime_emperor => 'Imperador do Crime';

  @override
  String get achievementDescription_crime_emperor =>
      'Complete com sucesso 500 crimes';

  @override
  String get achievementTitle_crime_legend => 'Lenda do Crime';

  @override
  String get achievementDescription_crime_legend =>
      'Complete com sucesso 1000 crimes';

  @override
  String get achievementTitle_crime_getaway_driver => 'Motorista de fuga';

  @override
  String get achievementDescription_crime_getaway_driver =>
      'Complete com sucesso seu primeiro crime com um veículo';

  @override
  String get achievementTitle_crime_armed_and_ready => 'Armado e pronto';

  @override
  String get achievementDescription_crime_armed_and_ready =>
      'Complete com sucesso seu primeiro crime que requer uma arma';

  @override
  String get achievementTitle_crime_full_loadout => 'Carregamento completo';

  @override
  String get achievementDescription_crime_full_loadout =>
      'Conclua com sucesso um crime que requer veículo, arma e ferramentas';

  @override
  String get achievementTitle_crime_completionist => 'Completista do Crime';

  @override
  String get achievementDescription_crime_completionist =>
      'Complete com sucesso todos os tipos de crime pelo menos uma vez';

  @override
  String get achievementTitle_job_first_shift => 'Primeiro turno';

  @override
  String get achievementDescription_job_first_shift =>
      'Conclua com sucesso seu primeiro trabalho';

  @override
  String get achievementTitle_job_hustler => 'Traficante de empregos';

  @override
  String get achievementDescription_job_hustler =>
      'Conclua com sucesso 5 trabalhos';

  @override
  String get achievementTitle_job_starter => 'Iniciador de trabalho';

  @override
  String get achievementDescription_job_starter =>
      'Conclua com sucesso 10 trabalhos';

  @override
  String get achievementTitle_job_operator => 'Operador de trabalho';

  @override
  String get achievementDescription_job_operator =>
      'Conclua com sucesso 25 trabalhos';

  @override
  String get achievementTitle_job_grinder => 'Moedor de trabalho';

  @override
  String get achievementDescription_job_grinder =>
      'Conclua com sucesso 50 trabalhos';

  @override
  String get achievementTitle_job_master => 'Mestre de trabalho';

  @override
  String get achievementDescription_job_master =>
      'Conclua com sucesso 100 trabalhos';

  @override
  String get achievementTitle_job_expert => 'Especialista em trabalho';

  @override
  String get achievementDescription_job_expert =>
      'Conclua com sucesso 250 trabalhos';

  @override
  String get achievementTitle_job_elite => 'Elite de trabalho';

  @override
  String get achievementDescription_job_elite =>
      'Conclua com sucesso 500 trabalhos';

  @override
  String get achievementTitle_job_legend => 'Legenda do trabalho';

  @override
  String get achievementDescription_job_legend =>
      'Conclua com sucesso 1.000 trabalhos';

  @override
  String get achievementTitle_job_completionist => 'Completista de Trabalho';

  @override
  String get achievementDescription_job_completionist =>
      'Conclua com sucesso todos os tipos de trabalho pelo menos uma vez';

  @override
  String get achievementTitle_job_educated_worker => 'Trabalhador Educado';

  @override
  String get achievementDescription_job_educated_worker =>
      'Conclua 1 trabalho que tenha requisitos de educação';

  @override
  String get achievementTitle_job_certified_hustler => 'Traficante certificado';

  @override
  String get achievementDescription_job_certified_hustler =>
      'Conclua 25 trabalhos com requisitos de educação';

  @override
  String get achievementTitle_job_education_completionist =>
      'Completista de Trabalho Educacional';

  @override
  String get achievementDescription_job_education_completionist =>
      'Conclua todos os tipos de trabalho restritos à educação pelo menos uma vez';

  @override
  String get achievementTitle_job_it_specialist => 'Especialista em TI';

  @override
  String get achievementDescription_job_it_specialist =>
      'Conclua seu primeiro turno como programador';

  @override
  String get achievementTitle_job_lawyer => 'Advogado de rua';

  @override
  String get achievementDescription_job_lawyer =>
      'Conclua seu primeiro turno como advogado';

  @override
  String get achievementTitle_job_doctor => 'Médico Subterrâneo';

  @override
  String get achievementDescription_job_doctor =>
      'Complete seu primeiro turno como médico';

  @override
  String get achievementTitle_school_certified => 'Aluno Certificado';

  @override
  String get achievementDescription_school_certified =>
      'Ganhe 3 certificações escolares';

  @override
  String get achievementTitle_school_multi_certified => 'Multicertificado';

  @override
  String get achievementDescription_school_multi_certified =>
      'Ganhe 6 certificações escolares';

  @override
  String get achievementTitle_school_track_specialist =>
      'Especialista em pista';

  @override
  String get achievementDescription_school_track_specialist =>
      'Máximo de 3 trilhas escolares';

  @override
  String get achievementTitle_school_freshman => 'Calouro escolar';

  @override
  String get achievementDescription_school_freshman =>
      'Alcance o nível de educação 1';

  @override
  String get achievementTitle_school_scholar => 'Acadêmico da escola';

  @override
  String get achievementDescription_school_scholar =>
      'Alcance o nível de educação 3';

  @override
  String get achievementTitle_school_graduate => 'Graduado da Escola';

  @override
  String get achievementDescription_school_graduate =>
      'Alcance o nível de escolaridade 5';

  @override
  String get achievementTitle_school_mastermind => 'Mentor Acadêmico';

  @override
  String get achievementDescription_school_mastermind =>
      'Alcance o nível de escolaridade 10';

  @override
  String get achievementTitle_school_doctorate => 'Doutorado de Rua';

  @override
  String get achievementDescription_school_doctorate =>
      'Alcance o nível de educação 20';

  @override
  String get achievementTitle_road_bandit => 'Bandido da estrada';

  @override
  String get achievementDescription_road_bandit => 'Roube 5 carros';

  @override
  String get achievementTitle_grand_theft_fleet => 'Frota de Grande Roubo';

  @override
  String get achievementDescription_grand_theft_fleet => 'Roube 25 carros';

  @override
  String get achievementTitle_sea_raider => 'Invasor do Mar';

  @override
  String get achievementDescription_sea_raider => 'Roube 3 barcos';

  @override
  String get achievementTitle_captain_of_smugglers =>
      'Capitão dos contrabandistas';

  @override
  String get achievementDescription_captain_of_smugglers => 'Roube 12 barcos';

  @override
  String get achievementTitle_globe_trotter => 'Globo Trotador';

  @override
  String get achievementDescription_globe_trotter => 'Complete 5 jornadas';

  @override
  String get achievementTitle_jet_setter => 'Jet Setter';

  @override
  String get achievementDescription_jet_setter => 'Complete 25 jornadas';

  @override
  String get achievementTitle_chemist_apprentice => 'Aprendiz de Químico';

  @override
  String get achievementDescription_chemist_apprentice =>
      'Complete 10 produções de drogas';

  @override
  String get achievementTitle_narco_chemist => 'Químico de narcóticos';

  @override
  String get achievementDescription_narco_chemist =>
      'Complete 100 produções de drogas';

  @override
  String get achievementTitle_street_merchant => 'Comerciante de rua';

  @override
  String get achievementDescription_street_merchant =>
      'Complete 25 negociações';

  @override
  String get achievementTitle_trade_tycoon => 'Magnata do comércio';

  @override
  String get achievementDescription_trade_tycoon => 'Conclua 150 negociações';

  @override
  String get achievementTitle_prostitute_lineup => 'Escalação construída';

  @override
  String get achievementDescription_prostitute_lineup =>
      'Recrute 10 prostitutas';

  @override
  String get achievementTitle_prostitute_network => 'Rede de ruas';

  @override
  String get achievementDescription_prostitute_network =>
      'Recrute 25 prostitutas';

  @override
  String get achievementTitle_prostitute_syndicate => 'Sindicato';

  @override
  String get achievementDescription_prostitute_syndicate =>
      'Recrute 50 prostitutas';

  @override
  String get achievementTitle_prostitute_dynasty => 'Dinastia';

  @override
  String get achievementDescription_prostitute_dynasty =>
      'Recrute 100 prostitutas';

  @override
  String get achievementTitle_prostitute_empire_250 => 'Império 250';

  @override
  String get achievementDescription_prostitute_empire_250 =>
      'Recrute 250 prostitutas';

  @override
  String get achievementTitle_prostitute_cartel_500 => 'Cartel 500';

  @override
  String get achievementDescription_prostitute_cartel_500 =>
      'Recrute 500 prostitutas';

  @override
  String get achievementTitle_prostitute_legend_1000 => 'Lenda 1000';

  @override
  String get achievementDescription_prostitute_legend_1000 =>
      'Recrute 1000 prostitutas';

  @override
  String get achievementTitle_vip_prostitute_level_10 => 'VIP Iniciante';

  @override
  String get achievementDescription_vip_prostitute_level_10 =>
      'Alcance o nível 3 com uma prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_25 =>
      'atração principal VIP';

  @override
  String get achievementDescription_vip_prostitute_level_25 =>
      'Alcance o nível 5 com uma prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_50 => 'Ícone VIP';

  @override
  String get achievementDescription_vip_prostitute_level_50 =>
      'Alcance o nível 7 com uma prostituta VIP';

  @override
  String get achievementTitle_vip_prostitute_level_100 => 'Lenda VIP';

  @override
  String get achievementDescription_vip_prostitute_level_100 =>
      'Alcance o nível 10 com uma prostituta VIP';

  @override
  String get achievementTitle_nightclub_opening_night => 'Noite de abertura';

  @override
  String get achievementDescription_nightclub_opening_night =>
      'Abra sua primeira boate';

  @override
  String get achievementTitle_nightclub_headliner =>
      'Reservador de atração principal';

  @override
  String get achievementDescription_nightclub_headliner =>
      'Reserve 10 turnos de DJ para o seu império de casas noturnas';

  @override
  String get achievementTitle_nightclub_full_house => 'Casa cheia';

  @override
  String get achievementDescription_nightclub_full_house =>
      'Empurre a multidão de uma boate para 90% da capacidade';

  @override
  String get achievementTitle_nightclub_cash_machine => 'Caixa eletrônico';

  @override
  String get achievementDescription_nightclub_cash_machine =>
      'Ganhe € 250.000 de receita total em casas noturnas';

  @override
  String get achievementTitle_nightclub_empire => 'Império da Vida Noturna';

  @override
  String get achievementDescription_nightclub_empire =>
      'Ganhe € 1.000.000 de receita total em casas noturnas';

  @override
  String get achievementTitle_nightclub_staffing_boss => 'Chefe de pessoal';

  @override
  String get achievementDescription_nightclub_staffing_boss =>
      'Administre 3 tripulantes ativos de boate ao mesmo tempo';

  @override
  String get achievementTitle_nightclub_vip_room => 'Sala VIP';

  @override
  String get achievementDescription_nightclub_vip_room =>
      'Designe 2 tripulantes VIP para sua boate';

  @override
  String get achievementTitle_nightclub_head_of_security =>
      'Chefe de Segurança';

  @override
  String get achievementDescription_nightclub_head_of_security =>
      'Contrate segurança de boate para 10 turnos';

  @override
  String get achievementTitle_nightclub_podium_finish => 'Pódio';

  @override
  String get achievementDescription_nightclub_podium_finish =>
      'Termine entre os 3 primeiros de uma temporada semanal de casas noturnas';

  @override
  String get achievementTitle_nightclub_season_champion =>
      'Campeão da temporada';

  @override
  String get achievementDescription_nightclub_season_champion =>
      'Ganhe uma temporada semanal em casas noturnas';

  @override
  String get nightclubManagementTitle => 'Gestão de boate';

  @override
  String get nightclubRealtimeStatus => 'Status em tempo real ativo';

  @override
  String get nightclubRefresh => 'Atualizar';

  @override
  String get nightclubEmptyTitle => 'Nenhuma boate encontrada ainda';

  @override
  String get nightclubEmptyBody =>
      'Compre primeiro uma boate em Propriedades para ativar este sistema.';

  @override
  String get nightclubLocationTitle => 'Localização da boate';

  @override
  String get nightclubSelectVenue => 'Selecione o local';

  @override
  String get nightclubLiveStatistics => 'Estatísticas ao vivo';

  @override
  String get nightclubKpiCrowd => 'Multidão';

  @override
  String get nightclubKpiVibe => 'Vibração';

  @override
  String get nightclubKpiToday => 'Hoje';

  @override
  String get nightclubKpiAllTime => 'De todos os tempos';

  @override
  String get nightclubKpiStock => 'Estoque';

  @override
  String get nightclubKpiDj => 'DJ';

  @override
  String get nightclubKpiThefts => 'Roubos';

  @override
  String get nightclubKpiStaff => 'Funcionárias';

  @override
  String get nightclubKpiSalesBoost => 'Aumento de vendas';

  @override
  String get nightclubKpiPriceBoost => 'Aumento de preço';

  @override
  String get nightclubKpiVipBonus => 'Bônus VIP';

  @override
  String get nightclubStatusActive => 'Ativa';

  @override
  String get nightclubStatusOff => 'Desligada';

  @override
  String get nightclubStatusActiveLower => 'ativa';

  @override
  String get nightclubRevenueTrend => 'Tendência da receita (ao vivo)';

  @override
  String get nightclubLeaderboardTitle => 'Melhores casas noturnas';

  @override
  String get nightclubLeaderboardCountry => 'País';

  @override
  String get nightclubLeaderboardGlobal => 'Global';

  @override
  String get nightclubLeaderboardEmpty =>
      'Ainda não há dados da tabela de classificação';

  @override
  String get nightclubLeaderboardRevenue24h => 'Receita 24h';

  @override
  String get nightclubSeasonProcessing => 'processamento...';

  @override
  String get nightclubSeasonTitle => 'Classificação semanal da temporada';

  @override
  String get nightclubSeasonResetIn => 'Redefinir em';

  @override
  String get nightclubSeasonYourRewards => 'Suas recompensas da temporada';

  @override
  String get nightclubSeasonCurrentTop5 => 'Top 5 da semana atual';

  @override
  String get nightclubSeasonEmpty => 'Ainda não há dados da temporada';

  @override
  String get nightclubSeasonWeekRevenue => 'Receita da semana';

  @override
  String get nightclubSeasonScore => 'Pontuação';

  @override
  String get nightclubSeasonRecentPayouts => 'Pagamentos recentes';

  @override
  String get nightclubSeasonNoPayouts => 'Ainda não há pagamentos';

  @override
  String get nightclubSalesTitle => 'Vendas recentes';

  @override
  String get nightclubSalesEmpty => 'Ainda não há dados de vendas';

  @override
  String get nightclubTheftTitle => 'Registro de roubo';

  @override
  String get nightclubTheftEmpty => 'Nenhum roubo registrado';

  @override
  String get nightclubTheftLoss => 'Perda';

  @override
  String get nightclubStaffTitle => 'Pimp Tripulação no Clube';

  @override
  String get nightclubStaffVipExtraActive => '(VIP +2 ativo)';

  @override
  String nightclubStaffCapacity(String assigned, String cap, String vipSuffix) {
    return 'Capacidade: $assigned/$cap$vipSuffix';
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
    return 'Mix de reforço: vendas x$sales | preço x$price | vibração x$vibe | segurança x$security | jogador vip x$vipPlayer | equipe vip x$vipStaff ($vipAssigned)';
  }

  @override
  String get nightclubSelectCrewMember => 'Selecionar membro da Crew';

  @override
  String get nightclubAssignShift => 'Atribuir ao turno da boate';

  @override
  String get nightclubTabActive => 'Ativa';

  @override
  String get nightclubTabHistory => 'História';

  @override
  String get nightclubNoCrewAssigned => 'Ainda sem Crew atribuída';

  @override
  String get nightclubCrewBoostDescription =>
      'Aumenta a demanda e a margem do seu clube';

  @override
  String get nightclubRemove => 'Remover';

  @override
  String get nightclubNoStaffHistory => 'Ainda não há histórico de pessoal';

  @override
  String get nightclubFrom => 'De';

  @override
  String get nightclubTo => 'Para';

  @override
  String get nightclubRevenueImpact => 'Impacto na receita';

  @override
  String get nightclubSalesCountLabel => 'vendas';

  @override
  String get nightclubDjTitle => 'Contratar DJ';

  @override
  String get nightclubChooseDj => 'Escolha DJ';

  @override
  String get nightclubShiftLength => 'Duração do turno';

  @override
  String get nightclubHireDj => 'Contratar DJ';

  @override
  String get nightclubSecurityTitle => 'Segurança';

  @override
  String get nightclubChooseSecurity => 'Escolha a segurança';

  @override
  String get nightclubHireSecurity => 'Contrate segurança';

  @override
  String get nightclubStoreTitle => 'Armazenar medicamentos';

  @override
  String get nightclubChooseStock => 'Escolha o estoque';

  @override
  String get nightclubAmountGrams => 'Quantidade em gramas';

  @override
  String get nightclubStoreButton => 'Loja em boate';

  @override
  String get nightclubHireDjSuccess => 'DJ contratado';

  @override
  String get nightclubHireSecuritySuccess => 'Segurança contratada';

  @override
  String get nightclubAssignCrewSuccess => 'Membro da Crew atribuído';

  @override
  String get nightclubRemoveCrewSuccess => 'Membro da Crew removido';

  @override
  String get nightclubStoreDrugsSuccess => 'Drogas armazenadas';

  @override
  String get nightclubSeasonPayoutDialogTitle =>
      'Pagamento da temporada recebido';

  @override
  String nightclubSeasonPayoutDialogBody(String rank) {
    return 'Sua boate terminou na posição #$rank esta semana.';
  }

  @override
  String nightclubSeasonPayoutDialogReward(String amount) {
    return 'Recompensa: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogRevenue(String amount) {
    return 'Receita semanal: $amount';
  }

  @override
  String nightclubSeasonPayoutDialogLoss(String amount) {
    return 'Perda por roubo: $amount';
  }

  @override
  String get nightclubSeasonPayoutDialogAction => 'Fechar';

  @override
  String get nightclubVibeChill => 'Fria';

  @override
  String get nightclubVibeNormal => 'Normal';

  @override
  String get nightclubVibeWild => 'Selvagem';

  @override
  String get nightclubVibeRaging => 'Furiosa';

  @override
  String get nightclubTheftTypeCustomer => 'Roubo de cliente';

  @override
  String get nightclubTheftTypeEmployee => 'Assalto a funcionários';

  @override
  String get nightclubTheftTypeRival => 'Sabotagem rival';

  @override
  String nightclubErrorLoading(String error) {
    return 'Erro ao carregar boate: $error';
  }

  @override
  String get nightclubServiceErrorStats =>
      'Não foi possível carregar as estatísticas da boate';

  @override
  String get nightclubServiceErrorLeaderboard =>
      'Não foi possível carregar o placar';

  @override
  String get nightclubServiceErrorSeason =>
      'Não foi possível carregar a classificação da temporada';

  @override
  String nightclubErrorWithDetail(String detail) {
    return 'Erro: $detail';
  }

  @override
  String get nightclubResidentDjContractFailed =>
      'Contrato de DJ residente falhou';

  @override
  String get nightclubScheduleEventFailed => 'Falha ao agendar evento';

  @override
  String get nightclubMarketingUpgradeFailed =>
      'Falha na atualização de marketing';

  @override
  String get nightclubUpgradeFailed => 'Falha na atualização';

  @override
  String get nightclubIncidentResponseFailed =>
      'Falha na resposta ao incidente';

  @override
  String get nightclubRivalActionFailed => 'Ação rival falhou';

  @override
  String get nightclubSupplierContractFailed => 'Contrato do fornecedor falhou';

  @override
  String get nightclubPromoterFailed => 'Falha no promotor';

  @override
  String get nightclubHeatCooldownFailed => 'Falha no resfriamento do calor';

  @override
  String get nightclubSmugglingFailed => 'Contrabando falhou';

  @override
  String get nightclubCounterIntelFailed => 'Contra-inteligência falhou';

  @override
  String get nightclubHospitalityStockFailed =>
      'O estoque de hospitalidade falhou';

  @override
  String get nightclubHospitalityPricingFailed =>
      'Falha no preço de hospitalidade';

  @override
  String nightclubCurrentVisitorsPct(String pct) {
    return 'Visitantes atuais: $pct%';
  }

  @override
  String get nightclubCommandDeckTitle => 'Deck de comando da boate';

  @override
  String get nightclubOpsDeckRevenueToday => 'Receita hoje';

  @override
  String get nightclubStockValueLabel => 'Valor das ações';

  @override
  String get nightclubCrewOccupancy => 'Ocupação da Crew';

  @override
  String get nightclubOperationalRisk => 'Risco operacional';

  @override
  String nightclubIncidents24h(String count) {
    return '$count incidentes (24h)';
  }

  @override
  String get nightclubActiveCrewShifts => 'Turnos ativos da Crew';

  @override
  String get nightclubRecentCrewHistory => 'História recente da Crew';

  @override
  String get nightclubBadgeVip => 'VIP';

  @override
  String get nightclubBadgeStandard => 'PADRÃO';

  @override
  String get nightclubActiveDj => 'DJ ativo';

  @override
  String get nightclubActiveDjNone => 'DJ ativo: nenhum';

  @override
  String nightclubUntilTime(String time) {
    return 'até $time';
  }

  @override
  String get nightclubActiveSecurity => 'Segurança ativa';

  @override
  String get nightclubActiveSecurityNone => 'Segurança ativa: nenhuma';

  @override
  String get nightclubNoDjsLoaded => 'Nenhum DJ carregado. Atualize a tela.';

  @override
  String get nightclubNoSecurityLoaded =>
      'Nenhuma segurança carregada. Atualize a tela.';

  @override
  String get nightclubCrowdBoost => 'Aumento de multidão';

  @override
  String get nightclubCostPerHour => 'Custo';

  @override
  String get nightclubReputationLabel => 'Reputação';

  @override
  String get nightclubSpecialtyLabel => 'Especialidade';

  @override
  String get nightclubTheftReduction => 'Redução de roubo';

  @override
  String get nightclubShiftCost => 'Custo de turno';

  @override
  String get nightclubSelectedStock => 'Selecionada';

  @override
  String get nightclubAvailableGrams => 'Disponível';

  @override
  String get nightclubMaxChip => 'MÁX.';

  @override
  String get nightclubStoredInNightclub => 'Armazenado em boate';

  @override
  String nightclubCurrentStockGrams(String grams) {
    return 'Estoque atual: ${grams}g';
  }

  @override
  String get nightclubNoStoredDrugs => 'Ainda não há medicamentos armazenados.';

  @override
  String get nightclubStockZeroSoldOut =>
      'O estoque atual é de 0g (tudo foi vendido).';

  @override
  String nightclubQualityWithValue(String value) {
    return 'Qualidade: $value';
  }

  @override
  String nightclubGramsStock(String grams) {
    return '${grams}g estoque';
  }

  @override
  String get nightclubOperationsLabTitle =>
      'Laboratório de Operações (11 sistemas)';

  @override
  String get nightclubSectionResidentDjContract =>
      '1) Contrato de DJ residente';

  @override
  String get nightclubContractDiscount => 'Desconto de contrato';

  @override
  String get nightclubContractDuration => 'Duração do contrato';

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
      '2) Calendário de eventos dinâmico';

  @override
  String get nightclubRecommendedToday => 'Recomendado hoje';

  @override
  String get nightclubEventTemplate => 'Modelo de evento';

  @override
  String get nightclubScheduleEventFiveMin => 'Agendar evento (+5 min)';

  @override
  String get nightclubUpcomingEvents => 'Próximos eventos';

  @override
  String get nightclubSectionUpgradeTree => '3) Árvore de atualização';

  @override
  String get nightclubUpgradeSoundRig => 'Equipamento de som';

  @override
  String get nightclubUpgradeVipLounge => 'Sala VIP';

  @override
  String get nightclubUpgradeSurveillance => 'Vigilância';

  @override
  String nightclubUpgradeWithCost(String name, String cost) {
    return '$name ($cost)';
  }

  @override
  String get nightclubChooseUpgrade => 'Escolha a atualização';

  @override
  String get nightclubUpgradeAlreadyMaxMessage =>
      'Esta atualização já está no nível máximo.';

  @override
  String get nightclubUpgradeAlreadyMaxed =>
      'A atualização já atingiu o limite máximo';

  @override
  String get nightclubUpgradeNow => 'Atualize agora';

  @override
  String get nightclubMarketingInvestment => 'Investimento em marketing';

  @override
  String get nightclubInvestMarketing => 'Invista em marketing';

  @override
  String get nightclubSectionPoliceHeat => '4) Calor e incidentes policiais';

  @override
  String get nightclubHeatLabel => 'Aquecer';

  @override
  String get nightclubRaidRisk => 'Risco de ataque';

  @override
  String get nightclubCooldownLabel => 'Esfriar';

  @override
  String get nightclubStartHeatCooldown => 'Iniciar o resfriamento do calor';

  @override
  String get nightclubBribe => 'Suborno';

  @override
  String get nightclubLockdown => 'Confinamento';

  @override
  String get nightclubCounterIntelShort => 'Contra-inteligência';

  @override
  String get nightclubSectionStaffMorale => '5) Fadiga e moral da equipe';

  @override
  String get nightclubMorale => 'Moral';

  @override
  String get nightclubFatigue => 'Fadiga';

  @override
  String get nightclubStaffing => 'Pessoal';

  @override
  String get nightclubSectionSupplierPromoter => '6) Fornecedor e promotor';

  @override
  String get nightclubSupplierContract => 'Contrato do fornecedor';

  @override
  String get nightclubActivateSupplier => 'Ativar fornecedor';

  @override
  String get nightclubPromoterProfile => 'Perfil do promotor';

  @override
  String get nightclubHirePromoter => 'Contratar promotor';

  @override
  String get nightclubSectionVipClientele =>
      '7) Clientela VIP e características da equipe';

  @override
  String get nightclubVipShare => 'Compartilhamento VIP';

  @override
  String get nightclubSpendMultiplier => 'Gaste x';

  @override
  String get nightclubTier => 'Nível';

  @override
  String get nightclubSectionSmugglingRoutes => '8) Rotas de contrabando';

  @override
  String get nightclubReady => 'Preparar';

  @override
  String get nightclubRoute => 'Rota';

  @override
  String get nightclubStartRoute => 'Iniciar rota';

  @override
  String get nightclubLastRoute => 'Última rota';

  @override
  String nightclubRouteLockUntil(String date) {
    return 'Bloqueio de rota ativo até $date';
  }

  @override
  String get nightclubSectionBarKitchen => '9) Gestão de bar e cozinha';

  @override
  String get nightclubServiceLevel => 'Nível de serviço';

  @override
  String get nightclubStockStatus => 'Status do estoque';

  @override
  String get nightclubSpoilageRisk => 'Risco de deterioração';

  @override
  String get nightclubDrinksFoodStock => 'Bebidas/estoque de alimentos';

  @override
  String get nightclubBuyStock => 'Comprar ações';

  @override
  String get nightclubMenuPricingMode => 'Modo de preço do menu';

  @override
  String get nightclubApplyPricing => 'Aplicar preços';

  @override
  String get nightclubSectionRivals =>
      '10) Clubes rivais + contra-inteligência';

  @override
  String get nightclubSearchPlayerName => 'Pesquisar nome do jogador';

  @override
  String get nightclubTargetName => 'Alvo (nome)';

  @override
  String nightclubRivalCrowdLine(String name, String country, String pct) {
    return '$name • $country • multidão $pct%';
  }

  @override
  String get nightclubSabotage => 'Sabotar';

  @override
  String get nightclubPromoWar => 'Guerra promocional';

  @override
  String get nightclubCounterIntelSweep => 'Varredura contra-inteligência';

  @override
  String get nightclubMitigation => 'Mitigação';

  @override
  String get nightclubSectionTimeline => '11) Cronograma de operações';

  @override
  String get nightclubNoTimelineEvents => 'Nenhum evento na linha do tempo.';

  @override
  String get nightclubOperationsAlerts => 'Alertas de operações';

  @override
  String get nightclubNoCriticalAlerts => 'Sem alertas críticos.';

  @override
  String get nightclubQuickAction => 'Ação rápida';

  @override
  String get nightclubMgmtCrewTitle => 'Crew e turnos';

  @override
  String get nightclubMgmtCrewSubtitle =>
      'Pessoal, desempenho e histórico de turnos.';

  @override
  String get nightclubMgmtDrugsTitle => 'Armazenamento de medicamentos';

  @override
  String get nightclubMgmtDrugsSubtitle =>
      'Gerencie e transfira estoque em gramas.';

  @override
  String get nightclubMgmtDjTitle => 'Comando DJ';

  @override
  String get nightclubMgmtDjSubtitle =>
      'Escolha o DJ, a duração do turno e o aumento da multidão ao vivo.';

  @override
  String get nightclubMgmtSecurityTitle => 'Unidade de segurança';

  @override
  String get nightclubMgmtSecuritySubtitle =>
      'Redução de roubos, custos e segurança ativa.';

  @override
  String get nightclubMgmtOpsLabTitle => 'Laboratório de operações';

  @override
  String nightclubMgmtOpsLabSubtitleAlert(String alerts, String smuggling) {
    return 'Alertas ao vivo: $alerts | Contrabando: $smuggling';
  }

  @override
  String get nightclubMgmtOpsLabSubtitleDefault =>
      '11 sistemas para eventos, atualizações, rotas e rivais.';

  @override
  String get nightclubManagementPanelTitle => 'Gestão de boate';

  @override
  String get nightclubChooseZoneHint =>
      'Escolha uma zona de gerenciamento e controle tudo sem rolagem interna aninhada.';

  @override
  String get nightclubChipCrew => 'Crew';

  @override
  String get nightclubChipStorage => 'Armazenar';

  @override
  String get nightclubChipDjShift => 'Mudança de DJ';

  @override
  String get nightclubChipSecurity => 'Segurança';

  @override
  String get nightclubChipOpsAlerts => 'Alertas de operações';

  @override
  String get nightclubNone => 'Nenhum';

  @override
  String get nightclubIntelligenceCardTitle => 'Inteligência de boate';

  @override
  String get nightclubSeasonStatus => 'Situação da temporada';

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
      'Ignorar o tempo de espera para roubo?';

  @override
  String theftCooldownRedeemMessage(int cost, int balance) {
    return 'Gastar $cost créditos para limpar o tempo de espera de roubo de veículo agora? Seu saldo: $balance.';
  }

  @override
  String get theftCooldownRedeemDontShowAgain =>
      'Não mostrar esta confirmação novamente';

  @override
  String theftCooldownRedeemConfirmAction(int credits) {
    return 'Use $credits créditos';
  }

  @override
  String get theftCooldownRedeemNotAvailable =>
      'A aceleração de crédito não está disponível para este tempo de espera no momento.';

  @override
  String get theftCooldownRedeemNoActiveCooldown =>
      'Nenhum tempo de espera de roubo ativo para redefinir.';

  @override
  String get theftCooldownRedeemInsufficientCredits =>
      'Créditos insuficientes.';

  @override
  String get theftCooldownRedeemFailed =>
      'Não foi possível aplicar créditos ao tempo de espera.';

  @override
  String get theftCooldownRedeemSuccess => 'Tempo de espera apagado.';

  @override
  String get settingsTheftCooldownConfirmTitle =>
      'Tempo de espera para roubo (créditos)';

  @override
  String get settingsTheftCooldownConfirmSubtitle =>
      'Peça confirmação antes de gastar créditos para pular o tempo de espera de roubo de veículo. Desligue para resgatar com um toque (ícone de relâmpago ao lado do cronômetro).';

  @override
  String get supportTicketsScreenTitle => 'Tíquetes de suporte';

  @override
  String get supportLoadTicketsFailed => 'Falha ao carregar tickets';

  @override
  String get supportLoadTicketFailed => 'Falha ao carregar o ticket';

  @override
  String get supportPickImageFailed => 'Falha ao selecionar a imagem';

  @override
  String get supportSubjectMessageMinLength =>
      'Preencha o assunto e a mensagem (mín. 3 caracteres).';

  @override
  String get supportTicketCreated => 'Bilhete criado.';

  @override
  String get supportCreateTicketFailed => 'Falha ao criar ticket';

  @override
  String get supportReplySent => 'Resposta enviada.';

  @override
  String get supportReplySendFailed => 'Falha ao enviar resposta';

  @override
  String get supportDeleteTicketTitle => 'Excluir tíquete';

  @override
  String get supportDeleteTicketBody =>
      'Tem certeza de que deseja excluir este ticket? Esta ação não pode ser desfeita.';

  @override
  String get supportTicketDeleted => 'Bilhete excluído.';

  @override
  String get supportDeleteTicketFailed => 'Falha ao excluir o ticket';

  @override
  String get supportUnknownError => 'Erro desconhecido';

  @override
  String get supportStatusNew => 'Nova';

  @override
  String get supportStatusTriage => 'Triagem';

  @override
  String get supportStatusInProgress => 'Em andamento';

  @override
  String get supportStatusWaitingPlayer => 'Esperando pelo jogador';

  @override
  String get supportStatusBlocked => 'Bloqueado';

  @override
  String get supportStatusResolved => 'Resolvida';

  @override
  String get supportStatusClosed => 'Fechada';

  @override
  String get supportStatusArchived => 'Arquivada';

  @override
  String get supportCategoryBug => 'Erro';

  @override
  String get supportCategoryQuestion => 'Pergunta';

  @override
  String get supportCategoryFeedback => 'Opinião';

  @override
  String get supportCategoryOther => 'Outra';

  @override
  String get supportPriorityLow => 'Baixo';

  @override
  String get supportPriorityHigh => 'Alta';

  @override
  String get supportPriorityUrgent => 'Urgente';

  @override
  String get supportPriorityNormal => 'Normal';

  @override
  String supportTimeDaysAgo(int count) {
    return '${count}d atrás';
  }

  @override
  String supportTimeHoursAgo(int count) {
    return '${count}h atrás';
  }

  @override
  String supportTimeMinutesAgo(int count) {
    return '${count}m atrás';
  }

  @override
  String get supportTimeJustNow => 'agora mesmo';

  @override
  String get supportSenderSupport => 'Suporte';

  @override
  String get supportSenderYou => 'Você';

  @override
  String get supportImageLoadFailed => 'Falha ao carregar a imagem.';

  @override
  String get supportMyTickets => 'Meus ingressos';

  @override
  String supportTicketsCountInList(String count) {
    return '$count';
  }

  @override
  String get supportMyTicketsIntro =>
      'O suporte agora responde diretamente nesta tela. Opcionalmente, você ainda pode receber uma notificação push quando seu ticket for atualizado.';

  @override
  String get supportNoTicketsYet =>
      'Você ainda não tem ingressos. Crie um novo relatório abaixo.';

  @override
  String get supportSelectTicketPrompt =>
      'Selecione um ticket para abrir a conversa.';

  @override
  String get supportConversation => 'Conversa';

  @override
  String get supportNoMessagesYet => 'Nenhuma mensagem ainda.';

  @override
  String get supportAttachments => 'Anexos';

  @override
  String get supportReplyToTicket => 'Responder a este ticket';

  @override
  String get supportReplyFieldHint =>
      'Use este campo quando o suporte solicitar mais informações ou quando você quiser fornecer uma atualização. Caixa de entrada e push permanecem canais de notificação para novas respostas de suporte.';

  @override
  String get supportYourReply => 'Sua resposta';

  @override
  String get supportSendReply => 'Enviar resposta';

  @override
  String get supportNewTicket => 'Novo ingresso';

  @override
  String get supportNewTicketIntro =>
      'Crie um novo relatório aqui. O suporte pode então responder através da caixa de entrada/push e nesta tela, para que você possa continuar a conversa em um só lugar.';

  @override
  String get supportTicketReceivedBanner => 'Bilhete recebido';

  @override
  String supportTicketNumberLine(int id) {
    return 'Número do bilhete: #$id';
  }

  @override
  String get supportTicketReceivedDetail =>
      'O ticket agora aparece diretamente na sua lista acima. Novas respostas de suporte também chegam como mensagens na caixa de entrada e notificações push.';

  @override
  String get supportFieldCategory => 'Categoria';

  @override
  String get supportFieldModule => 'Módulo';

  @override
  String get supportFieldSubject => 'Assunto';

  @override
  String get supportFieldMessage => 'Mensagem';

  @override
  String get supportReferenceOptional => 'Referência (opcional)';

  @override
  String get supportReferenceHint =>
      'Por exemplo, ID do pedido, nome de tela, país ou contexto curto';

  @override
  String get supportAddScreenshot => 'Adicionar captura de tela';

  @override
  String get supportSubmit => 'Enviar';

  @override
  String get supportLastMessagePrefix => 'Durar:';

  @override
  String get supportReferenceLabel => 'Referência';

  @override
  String get supportMod_support => 'Suporte geral';

  @override
  String get supportMod_dashboard => 'Painel';

  @override
  String get supportMod_messages => 'Mensagens / caixa de entrada';

  @override
  String get supportMod_notifications => 'Notificações/push';

  @override
  String get supportMod_payments => 'Pagamentos / prêmio';

  @override
  String get supportMod_bank => 'Banco';

  @override
  String get supportMod_crypto => 'Criptografia';

  @override
  String get supportMod_travel => 'Viagem';

  @override
  String get supportMod_properties => 'Propriedades';

  @override
  String get supportMod_inventory => 'Inventário/armazenamento';

  @override
  String get supportMod_loadouts => 'Carregamentos / equipamentos';

  @override
  String get supportMod_crimes => 'Crimes';

  @override
  String get supportMod_jobs => 'Trabalho / empregos';

  @override
  String get supportMod_vehicles => 'Roubo de carro/bicicleta/barco';

  @override
  String get supportMod_garage => 'Garagem';

  @override
  String get supportMod_marina => 'Marina';

  @override
  String get supportMod_aviation => 'Aviação';

  @override
  String get supportMod_smuggling => 'Contrabando';

  @override
  String get supportMod_drugs => 'Drogas';

  @override
  String get supportMod_nightclub => 'Boate';

  @override
  String get supportMod_prostitution => 'Prostituição';

  @override
  String get supportMod_crew => 'Crew';

  @override
  String get supportMod_friends => 'Amigos/jogadores';

  @override
  String get supportMod_hitlist => 'Lista de sucessos';

  @override
  String get supportMod_security => 'Segurança/FBI';

  @override
  String get supportMod_prison => 'Prisão / tribunal';

  @override
  String get supportMod_casino => 'Cassino';

  @override
  String get supportMod_school => 'Escola / treinamento';

  @override
  String get supportMod_achievements => 'Conquistas';

  @override
  String get supportMod_profile => 'Perfil';

  @override
  String get supportMod_settings => 'Configurações';

  @override
  String get supportMod_events => 'Eventos / tabela de classificação';

  @override
  String get supportMod_other => 'Outra';

  @override
  String get gameEventDefaultTitle => 'Evento';

  @override
  String get gameEventStatusActive => 'Ativa';

  @override
  String get gameEventStatusScheduled => 'Agendada';

  @override
  String get gameEventStatusCompleted => 'Concluída';

  @override
  String get gameEventStatusDraft => 'Rascunho';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntTitle =>
      'Caça semanal ao roubo';

  @override
  String get gameEventTmplWeeklyVehicleTheftHuntDesc =>
      'Roube o máximo de veículos que puder durante a janela do evento.';

  @override
  String get gameEventTmplSmugglingSurgeTitle => 'Onda de contrabando';

  @override
  String get gameEventTmplSmugglingSurgeDesc =>
      'Mova o contrabando mais contrabandeado nesta rodada.';

  @override
  String get gameEventTmplLabOutputChallengeTitle =>
      'Desafio de resultados de laboratório';

  @override
  String get gameEventTmplLabOutputChallengeDesc =>
      'Produza o máximo de resultados enquanto o evento estiver ao vivo.';

  @override
  String get gameEventTmplStreetCrimeSpreeTitle => 'Onda de crimes nas ruas';

  @override
  String get gameEventTmplStreetCrimeSpreeDesc =>
      'Complete tantos crimes quanto possível na janela ao vivo.';

  @override
  String get gameScreenLoadError => 'Não foi possível carregar eventos.';

  @override
  String get gameScreenDetailsLoadError =>
      'Não foi possível carregar os detalhes do evento.';

  @override
  String get gameScreenSectionLive => 'Eventos ao vivo';

  @override
  String get gameScreenNoActive => 'Não há eventos ativos no momento.';

  @override
  String get gameScreenSectionUpcoming => 'Próximos eventos';

  @override
  String get gameScreenNoUpcoming => 'Não há eventos programados.';

  @override
  String gameScreenStatusPrefix(String value) {
    return 'Status: $value';
  }

  @override
  String gameScreenStartLine(String date) {
    return 'Início: $date';
  }

  @override
  String gameScreenEndLine(String date) {
    return 'Fim: $date';
  }

  @override
  String get gameScreenYourProgress => 'Seu progresso';

  @override
  String gameScreenScore(String value) {
    return 'Pontuação: $value';
  }

  @override
  String gameScreenRank(String value) {
    return 'Classificação: $value';
  }

  @override
  String get gameScreenLeaderboard => 'Tabela de classificação (10 primeiros)';

  @override
  String get gameScreenNoLeaderboard =>
      'Ainda não há dados da tabela de classificação.';

  @override
  String get gameScreenUnknownPlayer => 'Desconhecida';

  @override
  String get gameScreenDash => '-';

  @override
  String get gameCardActive => 'Ativa';

  @override
  String get gameCardScheduled => 'Planejada';

  @override
  String gameCardYourScore(String value) {
    return 'Sua pontuação: $value';
  }

  @override
  String gameCardYourRank(String value) {
    return 'Sua classificação: $value';
  }

  @override
  String get gameCardTapDetails => 'Toque para ver detalhes e placar';

  @override
  String get eventFeedDisconnected => 'Desconectado do stream de eventos';

  @override
  String get eventFeedReconnecting => 'Reconectando...';

  @override
  String get eventFeedConnectedWaiting => 'Conectado – aguardando eventos…';

  @override
  String get eventFeedConnecting => 'Conectando-se ao stream do evento…';

  @override
  String get evStreamConnectionEstablished => 'Conectado ao stream do evento';

  @override
  String get evStreamAuthRegistered => 'Conta criada com sucesso.';

  @override
  String get evStreamAuthLogin => 'Bem vindo de volta.';

  @override
  String evStreamCrimeSuccess(
    String crimeName,
    String reward,
    String xpGained,
  ) {
    return 'Concluído com sucesso $crimeName! +EUR $reward, +$xpGained XP';
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
    return 'Concluído $crimeName com sucesso! +EUR $reward, +$xpGained XP — mas preso! $_temp0.';
  }

  @override
  String get evStreamCrimeSeizedVehicle =>
      'Seu veículo foi apreendido pela polícia.';

  @override
  String get evStreamCrimeSeizedWeapon =>
      'Sua arma foi confiscada pela polícia.';

  @override
  String evStreamCrimeSuccessCleared(
    String crimeName,
    int count,
    String xpGained,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condenações',
      one: '1 condenação',
    );
    return 'Concluído $crimeName com sucesso! Registo limpo: $_temp0 removidas. +$xpGained XP';
  }

  @override
  String evStreamCrimeFailedArrested(String authority, String crimeName) {
    return 'Preso por $authority durante uma tentativa de $crimeName.';
  }

  @override
  String evStreamCrimeFailedJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return 'Pego em $crimeName! Preso $_temp0.';
  }

  @override
  String evStreamCrimeFailedBase(String crimeName) {
    return 'Falha ao concluir $crimeName';
  }

  @override
  String evStreamChaseDamage(String pct) {
    return 'Seu veículo sofreu $pct% de dano durante a perseguição.';
  }

  @override
  String evStreamCrimeJailed(String crimeName, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return 'Pego em $crimeName! Preso $_temp0.';
  }

  @override
  String evStreamJobSuccess(String jobName, String earnings, String xpGained) {
    return 'Trabalho concluído como $jobName! +€$earnings, +$xpGained XP';
  }

  @override
  String evStreamJobSuccessEdu(String pct) {
    return '(Bônus educacional +$pct%)';
  }

  @override
  String evStreamJobFailedXp(String jobName, String xpLost) {
    return 'Falha ao concluir o trabalho como $jobName. −${xpLost}XP';
  }

  @override
  String evStreamJobFailed(String jobName) {
    return 'Falha ao concluir o trabalho como $jobName';
  }

  @override
  String get evStreamJobErrorInvalid => 'Trabalho inválido';

  @override
  String get evStreamJobErrorLevel =>
      'Sua classificação é muito baixa para este trabalho';

  @override
  String evStreamJobErrorCooldown(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes mais minutos',
      one: 'mais 1 minuto',
    );
    return 'Este trabalho está em cooldown. Espera $_temp0';
  }

  @override
  String evStreamJobErrorGeneric(String reason) {
    return 'Erro de trabalho: $reason';
  }

  @override
  String evStreamTravelDeparted(String dest, String cost) {
    return 'Voando para $dest… −€$cost';
  }

  @override
  String evStreamTravelArrived(String country) {
    return 'Chegou em $country.';
  }

  @override
  String evStreamBankDeposit(String amount) {
    return 'Depositado €$amount no banco';
  }

  @override
  String evStreamBankWithdraw(String amount) {
    return 'Retirou €$amount do banco';
  }

  @override
  String evStreamCryptoBuy(String quantity, String symbol, String total) {
    return 'Comprei $quantity $symbol por €$total';
  }

  @override
  String evStreamCryptoSell(
    String quantity,
    String symbol,
    String total,
    String pnl,
  ) {
    return 'Vendido $quantity $symbol por €$total (P&L €$pnl)';
  }

  @override
  String evStreamCryptoAlert(String symbol, String price, String chg) {
    return '$symbol alerta: €$price ($chg% 24h)';
  }

  @override
  String evStreamCryptoOrderFilled(
    String order,
    String side,
    String quantity,
    String symbol,
    String price,
  ) {
    return '$order $side preenchido: $quantity $symbol a €$price';
  }

  @override
  String evStreamCryptoOrderTriggered(
    String trig,
    String symbol,
    String price,
  ) {
    return '$trig acionado por $symbol a €$price';
  }

  @override
  String evStreamCryptoRegime(String regime, String move) {
    return 'Regime de mercado alterado para $regime ($move% 24h)';
  }

  @override
  String evStreamCryptoNews(String sentiment, String headline) {
    return '$sentiment notícias: $headline';
  }

  @override
  String evStreamCryptoMissionDaily(String title, String reward) {
    return 'Missão diária concluída: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoMissionWeekly(String title, String reward) {
    return 'Missão semanal concluída: $title (+EUR $reward)';
  }

  @override
  String evStreamCryptoLeaderboard(String rank, String reward) {
    return 'Recompensa da tabela de classificação criptográfica: #$rank (+EUR $reward)';
  }

  @override
  String get evStreamRegimeBull => 'otimista';

  @override
  String get evStreamRegimeBear => 'grosseira';

  @override
  String get evStreamRegimeSideways => 'lateralmente';

  @override
  String get evStreamImpactBull => 'Alta';

  @override
  String get evStreamImpactBear => 'Grosseira';

  @override
  String get evStreamImpactNeutral => 'Neutra';

  @override
  String evStreamPropertyBought(String name, String cost) {
    return 'Comprou $name por €$cost';
  }

  @override
  String evStreamCrewCreated(String name) {
    return 'Crew criada: $name';
  }

  @override
  String evStreamCrewJoined(String name) {
    return 'Crew ingressada: $name';
  }

  @override
  String evStreamCrewWarDeclared(String a, String b, String type) {
    return 'Guerra da Crew declarada: #$a vs #$b ($type)';
  }

  @override
  String evStreamCrewWarStarted(String a, String b) {
    return 'A guerra da Crew começou: #$a vs #$b';
  }

  @override
  String evStreamCrewLockdown(String id) {
    return 'A guerra da Crew #$id está bloqueada';
  }

  @override
  String evStreamCrewResolved(String id, String winner) {
    return 'Guerra de Crew #$id resolvida. Vencedor: Crew #$winner';
  }

  @override
  String evStreamCrewAction(String action, String points) {
    return 'Ação de guerra da Crew: $action (+$points pt)';
  }

  @override
  String evStreamHeistOk(String name, String money) {
    return 'Assalto “$name” bem-sucedido! +€$money';
  }

  @override
  String evStreamHeistFail(String name) {
    return 'O assalto “$name” falhou.';
  }

  @override
  String evStreamHospital(String hp, String cost) {
    return 'Tratado no hospital! +$hp saúde, −€$cost';
  }

  @override
  String evStreamPoliceArrested(String mins) {
    return 'Preso! Preso por $mins minutos';
  }

  @override
  String get evStreamPoliceEscaped => 'Você escapou da polícia.';

  @override
  String get evStreamFbiRaid =>
      'Ataque do FBI! Você perdeu propriedades e dinheiro.';

  @override
  String get evStreamErrInsufficientFunds => 'Não há dinheiro suficiente';

  @override
  String get evStreamErrInsufficientHealth =>
      'Saúde insuficiente para esta ação';

  @override
  String evStreamErrInsufficientRank(String rank) {
    return 'Requer classificação $rank';
  }

  @override
  String evStreamErrJailed(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '1 minuto',
    );
    return 'Estás preso ainda $_temp0';
  }

  @override
  String get evStreamErrNoHealthDefault =>
      'Você precisa descansar e recuperar sua saúde';

  @override
  String evStreamErrCooldown(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds segundos',
      one: '1 segundo',
    );
    return 'Aguarda $_temp0 antes de tentar novamente';
  }

  @override
  String get evStreamErrRescuerJailed =>
      'Você não pode ajudar os outros enquanto estiver na prisão';

  @override
  String get evStreamErrTargetNotJailed => 'Esse jogador não está na prisão';

  @override
  String get evStreamErrCannotRescueSelf => 'Você não pode se libertar';

  @override
  String get evStreamJailbreakOk =>
      'Jailbreak bem-sucedido! O jogador é gratuito.';

  @override
  String get evStreamJailbreakFail =>
      'Falha no jailbreak! O jogador ainda está preso.';

  @override
  String evStreamJailbreakCaught(String mins) {
    return 'Falha no jailbreak! Você foi pego e preso por $mins minutos.';
  }

  @override
  String evStreamBailPaid(String amount) {
    return 'Fiança paga: €$amount. Você está livre.';
  }

  @override
  String get evStreamErrInternal =>
      'Algo deu errado. Por favor, tente novamente.';

  @override
  String evStreamTest(String msg) {
    return 'Teste: $msg';
  }

  @override
  String get evStreamNoCriminalRecord =>
      'Você não tem antecedentes criminais para limpar';

  @override
  String get evStreamWeaponSelectRequired =>
      'Selecione uma arma do crime antes de cometer este crime';

  @override
  String evStreamWeaponNotSuitable(String types) {
    return 'Você precisa de uma arma adequada: $types';
  }

  @override
  String get evStreamJobFallbackName => 'trabalho';

  @override
  String evStreamUnknownKey(String key) {
    return '$key';
  }

  @override
  String get connectionErrorGeneric => 'Erro de conexão';

  @override
  String get crimeWeaponSectionTitle => 'Arma do crime';

  @override
  String get crimeWeaponInstruction =>
      'Escolha qual arma portada você usa por padrão para crimes que exigem uma.';

  @override
  String get crimeWeaponEmptyInventoryHelp =>
      'Compre ou mova primeiro uma arma utilizável para o seu inventário.';

  @override
  String get crimeWeaponSelectHint => 'Selecione uma arma para crimes';

  @override
  String get crimeWeaponNoSelectionNote =>
      'Sem uma seleção, os crimes baseados em armas não começarão.';

  @override
  String crimeWeaponSelectedStatus(String weaponLine) {
    return 'Selecionado: $weaponLine. Alguns crimes ainda exigem um tipo de arma correspondente.';
  }

  @override
  String get crimeSetWeaponFailed => 'Falha ao definir a arma do crime.';

  @override
  String get crimeChooseWeaponBeforeCommit =>
      'Escolha uma arma do crime no topo desta tela ou primeiro através do Inventário.';

  @override
  String get crimeWeaponFooterNote =>
      'Crimes baseados em armas usam a arma do crime selecionada acima.';

  @override
  String crimeTrainingBonusStrip(String strengthPct, String accuracyPct) {
    return 'Training bonuses on success chance: +$strengthPct% strength, +$accuracyPct% accuracy.';
  }

  @override
  String crimeTrainingComboStrip(String pct) {
    return 'Combo no mesmo dia (academia + campo de treinamento, calendário UTC): +$pct% chance extra de sucesso no crime.';
  }

  @override
  String get crimeCriminalRecordWipeDesc =>
      'Forje arquivos judiciais e limpe todo o seu registro criminal se a operação for bem-sucedida.';

  @override
  String crimeCardSuccessChance(int percent) {
    return '$percent% de chance de sucesso';
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
      'Algo deu errado. Por favor, tente novamente.';

  @override
  String get cooldownTimeLeft => 'Tempo restante';

  @override
  String get cooldownMustWaitExplanation =>
      'Você deve esperar antes de executar esta ação novamente.';

  @override
  String get cooldownAlreadyFinished => 'O resfriamento já terminou.';

  @override
  String get cooldownNotEnoughCredits => 'Créditos insuficientes.';

  @override
  String get cooldownNoActiveToReset =>
      'Nenhum resfriamento ativo para redefinir.';

  @override
  String get cooldownNotAvailableNow => 'Não disponível no momento.';

  @override
  String get cooldownRedeemFailed => 'Falha ao acelerar com créditos.';

  @override
  String get cooldownFinishedInstantly =>
      'O resfriamento terminou instantaneamente.';

  @override
  String cooldownSpeedUpNow(int cost) {
    return 'Acelere agora (-$cost créditos)';
  }

  @override
  String cooldownCreditBalanceLine(int balance) {
    return 'Saldo: $balance créditos';
  }

  @override
  String get cooldownLoadingCreditOptions => 'Carregando opções de crédito…';

  @override
  String get cooldownWaitCrime => 'O calor está muito alto…';

  @override
  String get cooldownWaitJob => 'Descansar antes de poder trabalhar novamente';

  @override
  String get cooldownWaitTravel => 'O próximo voo parte em';

  @override
  String get cooldownWaitHeist => 'Planejando o assalto…';

  @override
  String get cooldownWaitAppeal => 'O tribunal está ocupado…';

  @override
  String get cooldownWaitSchool => 'Recupere o fôlego antes da próxima lição…';

  @override
  String get cooldownWaitDefault => 'Por favor, aguarde…';

  @override
  String get weaponLabelKnife => 'Faca';

  @override
  String get weaponLabelHandgun9mm => 'Pistola (9mm)';

  @override
  String get weaponLabelHandgunHeavy => 'Pistola Pesada (.45)';

  @override
  String get weaponLabelSmgCompact => 'Submetralhadora Compacta';

  @override
  String get weaponLabelShotgunPump => 'Espingarda (bomba)';

  @override
  String get weaponLabelMolotov => 'Coquetel molotov';

  @override
  String get weaponLabelSmgSuppressed => 'Submetralhadora suprimida';

  @override
  String get weaponLabelShotgunTactical => 'Espingarda Tática';

  @override
  String get weaponLabelAssaultRifle => 'Fuzil de assalto (AK-47)';

  @override
  String get weaponLabelGrenadeFlash => 'Granada instantânea';

  @override
  String get weaponLabelGrenadeFrag => 'Granada de fragmentação';

  @override
  String get weaponLabelSniperStandard => 'Rifle de atirador';

  @override
  String get weaponLabelAssaultRifleVip => 'Fuzil de assalto de elite';

  @override
  String get weaponLabelSniperVip => 'Rifle de atirador de elite';

  @override
  String get cooldownTitleCrime => 'Recarga do crime';

  @override
  String get cooldownTitleJob => 'Tempo de espera do trabalho';

  @override
  String get cooldownTitleTravel => 'Recarga de viagem';

  @override
  String get cooldownTitleHeist => 'Tempo de espera do assalto';

  @override
  String get cooldownTitleAppeal => 'Recarga de recurso';

  @override
  String get cooldownTitleSchool => 'Tempo de espera da escola';

  @override
  String get cooldownTitleGeneric => 'Esfriar';

  @override
  String get crimeOutcomeDefaultTitle => 'Resultado do crime';

  @override
  String get territoryContestStatusPreparing => 'Preparação';

  @override
  String get territoryContestStatusActive => 'Ativa';

  @override
  String get territoryContestStatusLockdown => 'Confinamento';

  @override
  String get territoryContestStatusResolved => 'Resolvida';

  @override
  String get territoryContestStatusCancelled => 'Cancelada';

  @override
  String get territoryContestHintPreparing =>
      'Este concurso está atualmente em preparação. Assim que o tempo de preparação terminar, a região se tornará automaticamente ativa e as ações serão desbloqueadas.';

  @override
  String get territoryContestHintLockdown =>
      'Este concurso está bloqueado. Nenhuma nova ação pode ser tomada agora; o resultado é resolvido automaticamente.';

  @override
  String get territoryNow => 'Agora';

  @override
  String get territoryRoleAttacker => 'Atacante';

  @override
  String get territoryRoleDefender => 'Defensora';

  @override
  String get territoryValueLow => 'Baixo';

  @override
  String get territoryValueAverage => 'Média';

  @override
  String get territoryValueHigh => 'Alta';

  @override
  String get territoryValueTop => 'Principal';

  @override
  String get territoryTagCapital => 'Centro administrativo';

  @override
  String get territoryTagHarbor => 'Porto';

  @override
  String get territoryTagIndustry => 'Indústria';

  @override
  String get territoryTagBorder => 'Região fronteiriça';

  @override
  String get territoryTagLogistics => 'Centro logístico';

  @override
  String get territoryActionPatrol => 'Patrulha';

  @override
  String get territoryActionIntelScan => 'Varredura Intel';

  @override
  String get territoryActionSabotage => 'Sabotar';

  @override
  String get territoryActionSupplyRun => 'Execução de abastecimento';

  @override
  String get territoryActionRaid => 'Ataque';

  @override
  String get territoryActionDefense => 'Defesa';

  @override
  String get territoryBonusStrategicRegion => 'Região estratégica';

  @override
  String get territoryBonusAdjacentSupport => 'Suporte adjacente';

  @override
  String get territoryBonusWarPressure => 'Pressão de guerra';

  @override
  String get territoryBonusHqLevel => 'Nível de QG';

  @override
  String get territoryBonusCrewMissionLevel => 'Nível de missão da Crew';

  @override
  String get territoryBonusCrewBuildings => 'Edifícios laterais da Crew';

  @override
  String get territoryBonusOther => 'Outra';

  @override
  String territoryPointsLogicLine(
    int basePoints,
    int bonusPoints,
    int totalPoints,
  ) {
    return 'base $basePoints + bônus $bonusPoints = $totalPoints pontos de concurso';
  }

  @override
  String get territoryErrorNotInCrew =>
      'Você deve se juntar a uma Crew antes de poder atacar o território.';

  @override
  String get territoryErrorContestAlreadyActive =>
      'Já está em andamento um concurso para esta região. Atualizando o mapa para o estado mais recente.';

  @override
  String get territoryErrorCrewContestLimit =>
      'Sua Crew já atingiu o limite de competição simultânea.';

  @override
  String get territoryErrorRegionsCap =>
      'Sua Crew já possui o número máximo de regiões.';

  @override
  String get territoryErrorContestNotActive =>
      'Este concurso ainda não está ativo. Aguarde o término da fase de preparação.';

  @override
  String get territoryErrorActionCooldown =>
      'Você precisa esperar antes de realizar outra ação territorial.';

  @override
  String get territoryErrorActionRoleMismatch =>
      'Esta ação pertence ao outro lado da competição.';

  @override
  String get territoryErrorHqLevelRequired =>
      'O nível do seu QG é muito baixo para esta ação territorial.';

  @override
  String get territoryErrorDailyCap =>
      'Você atingiu seu limite diário de ações territoriais.';

  @override
  String get territoryErrorWrongCountry =>
      'Você pode visualizar todos os países, mas as ações territoriais só funcionam no país onde você está atualmente.';

  @override
  String get territoryErrorUnknown => 'Erro de território desconhecido.';

  @override
  String get territoryLegendUnderContest => 'Em concurso';

  @override
  String get territoryLegendNeutral => 'Neutra';

  @override
  String get territoryTabMap => 'Mapa';

  @override
  String get territoryTabLeaderboard => 'Tabela de classificação';

  @override
  String get territoryTabSeason => 'Temporada';

  @override
  String get territorySelectCountryTooltip => 'Selecione o país';

  @override
  String get territoryUnavailableMessage =>
      'O território está indisponível no momento.';

  @override
  String get territoryMapHintTapMain =>
      'Toque em uma região no mapa para abrir as informações do território e o botão de ataque em um modal.';

  @override
  String get territoryMapHintTapPanel =>
      'Toque em uma região para abrir diretamente o modal com informações de território e ações de ataque.';

  @override
  String get territoryMapHintMobile =>
      'No celular, você pode aproximar e afastar dois dedos e arrastar o mapa ampliado diretamente para regiões menores.';

  @override
  String get territoryMapHintColors =>
      'As cores da região mostram propriedade; laranja = concurso ativo.';

  @override
  String territoryMapOverviewTitle(String country) {
    return '$country mapa (controle da Crew)';
  }

  @override
  String get territoryLegendTitle => 'Lenda';

  @override
  String territoryYourCrewLine(String name) {
    return 'Sua Crew: $name';
  }

  @override
  String get territoryDetailRegionPreviewTitle => 'Visualização da região';

  @override
  String get territoryDetailRegionPreviewSubtitle =>
      'Somente a região selecionada, sem o restante do mapa.';

  @override
  String get territoryNeutralTerritory => 'Território neutro';

  @override
  String get territoryDetailOwner => 'Proprietária';

  @override
  String get territoryDetailNeutral => 'Neutra';

  @override
  String get territoryDetailStability => 'Estabilidade';

  @override
  String get territoryDetailEffectiveStability => 'Estabilidade eficaz';

  @override
  String get territoryDetailControl => 'Controlar';

  @override
  String get territoryDetailValueTier => 'Camada de valor';

  @override
  String get territoryDetailPayout => 'Pagamento';

  @override
  String get territoryDetailStrategicRole => 'Papel estratégico';

  @override
  String get territoryDetailAdjacentOwned =>
      'Regiões de propriedade adjacentes';

  @override
  String get territoryDetailActionBonuses => 'Bônus de ação';

  @override
  String get territoryDetailBonusInfo => 'Informações bônus';

  @override
  String get territoryDetailBonusInfoBody =>
      'Esses bônus apenas aumentam seus pontos de competição por ação. O pagamento de € por região permanece o mesmo.';

  @override
  String get territoryDetailWarPressure => 'Pressão de guerra';

  @override
  String get territoryDetailAttackPressure => 'pressão de ataque';

  @override
  String get territoryDetailStabilityWord => 'estabilidade';

  @override
  String get territoryWarRoleTheater => 'região do teatro';

  @override
  String get territoryWarRoleAdjacent => 'região adjacente';

  @override
  String get territoryWarRoleTarget => 'região alvo';

  @override
  String get territoryWarPressureEndsIn => 'A pressão da guerra termina em';

  @override
  String get territoryDetailIncomeHour => 'Renda por hora';

  @override
  String get territoryDetailIncomeDay => 'Renda por dia';

  @override
  String get territoryDetailYourCrew => 'Sua Crew';

  @override
  String get territoryDetailContestStatus => 'Status do concurso';

  @override
  String get territoryDetailYourRole => 'Seu papel';

  @override
  String get territoryDetailYourHqLevel => 'Seu nível de QG';

  @override
  String get territoryDetailActionsUnlockIn => 'Ações desbloqueadas em';

  @override
  String get territoryDetailActionsCloseIn => 'Ações se aproximam';

  @override
  String get territoryDetailContestEndsIn => 'O concurso termina em';

  @override
  String get territoryDetailCooldownPerAction => 'Tempo de espera por ação';

  @override
  String get territoryDetailYourCooldown => 'Seu tempo de espera';

  @override
  String get territoryNoticeCrewOnly =>
      'O território só pode ser jogado por membros da Crew. Crie ou junte-se a uma Crew primeiro, depois você poderá atacar regiões neutras.';

  @override
  String territoryNoticeWrongCountry(
    String viewingCountry,
    String playerCountry,
  ) {
    return 'Você está visualizando $viewingCountry, mas atualmente está em $playerCountry. Você pode navegar neste mapa, mas ataques e ações de contestação só serão desbloqueados depois que você viajar para este país.';
  }

  @override
  String get territoryNoticeOwnRegion => 'Sua Crew já controla esta região.';

  @override
  String get territoryNoticeDefenderPrep =>
      'Sua Crew está defendendo esta região. Assim que a fase ativa começar, você verá apenas ações defensivas.';

  @override
  String get territoryConfirmDefense => 'Confirmar defesa';

  @override
  String get territoryAttack => 'Ataque';

  @override
  String get territoryAttackerActions => 'Ações do invasor';

  @override
  String get territoryDefenderActions => 'Ações do defensor';

  @override
  String get territoryContestActions => 'Ações do concurso';

  @override
  String get territoryIntelShort => 'Varredura Intel';

  @override
  String get territoryRequiresHqShort => 'requer sede';

  @override
  String territoryHqLockedNotice(String actions) {
    return 'Nível de QG mais alto necessário para: $actions.';
  }

  @override
  String get territoryNotInContestNotice =>
      'Você não faz parte deste concurso, portanto não pode realizar ações aqui.';

  @override
  String territoryContestOtherCountryNotice(String country) {
    return 'Este concurso está acontecendo em outro país. Você pode acompanhá-lo, mas só poderá entrar quando estiver fisicamente em $country.';
  }

  @override
  String get territoryLeaderboardEmpty => 'Nenhum território controlado ainda.';

  @override
  String territoryLeaderboardRegionsCount(int count) {
    return '$count regiões';
  }

  @override
  String get territorySeasonNone => 'Nenhuma temporada ativa encontrada.';

  @override
  String get territorySeasonCurrent => 'Temporada atual';

  @override
  String get territorySeasonKey => 'Chave';

  @override
  String get territorySeasonStatus => 'Status';

  @override
  String get territorySeasonStart => 'Começar';

  @override
  String get territorySeasonEnd => 'Fim';

  @override
  String get territoryDialogAttackTitle => 'Ataque?';

  @override
  String territoryDialogAttackBody(String regionKey) {
    return 'Iniciar um concurso por $regionKey?';
  }

  @override
  String get territorySnackJoinCrewFirst =>
      'Junte-se primeiro a uma Crew para atacar o território.';

  @override
  String territorySnackContestStarted(String status) {
    return 'Concurso iniciado. Status: $status. Aguarde o término da fase de preparação antes de tomar medidas.';
  }

  @override
  String territorySnackContestAlreadyLive(String status) {
    return 'O concurso já começou e o mapa foi atualizado. Status: $status.';
  }

  @override
  String territoryPointsDelta(String points) {
    return '+$points pontos!';
  }

  @override
  String get territorySnackDefenseConfirmed =>
      'Defesa confirmada. Assim que a fase ativa começar, você poderá realizar ações defensivas.';

  @override
  String get territorySnackContestRefreshed =>
      'O estado do concurso foi atualizado. Agora você pode ver imediatamente a fase de defesa atual.';

  @override
  String territoryHqTooltipLocked(int required, int current) {
    return 'Requer nível de QG $required. Nível atual do QG: $current.';
  }

  @override
  String territoryHqButtonLocked(String label, int level) {
    return '$label (requer QG $level)';
  }

  @override
  String get smugglingHubTitle => 'Centro de contrabando';

  @override
  String get smugglingHubSubtitle =>
      'Um sistema para drogas, mercadorias comerciais, veículos, armas e munições. Viaje vazio e recupere com segurança no depósito.';

  @override
  String get smugglingClaimPersonal => 'Reivindicar pessoal';

  @override
  String get smugglingClaimCrew => 'Reivindicar Crew';

  @override
  String get smugglingNewShipment => 'Nova remessa';

  @override
  String get smugglingCategoryDrug => 'Drogas';

  @override
  String get smugglingCategoryTrade => 'Mercadorias comerciais';

  @override
  String get smugglingCategoryVehicle => 'Veículos';

  @override
  String get smugglingCategoryWeapon => 'Armas';

  @override
  String get smugglingCategoryAmmo => 'Munição';

  @override
  String get smugglingNoItemsInCategory =>
      'Não há itens disponíveis nesta categoria.';

  @override
  String get smugglingFieldItem => 'Item';

  @override
  String get smugglingFieldDestination => 'Destino';

  @override
  String get smugglingTransport => 'Transporte';

  @override
  String get smugglingCommercialChannel => 'Canal comercial';

  @override
  String get smugglingOwnedVehicleAircraft => 'Veículo/aeronave de propriedade';

  @override
  String get smugglingNoOwnedTransportInCountry =>
      'Você não possui um veículo ou aeronave própria disponível para contrabando neste país.';

  @override
  String get smugglingOwnedTransportFieldLabel => 'Transporte próprio';

  @override
  String smugglingOwnedTransportCapacityLine(int slots, String percent) {
    return 'Capacidade: $slots slots • Confisco em caso de falha: $percent%';
  }

  @override
  String smugglingOwnedTransportDropdownRow(
    String label,
    int slots,
    String riskReduction,
  ) {
    return '$label • $slots vagas • -$riskReduction%';
  }

  @override
  String get smugglingNetwork => 'Rede';

  @override
  String get smugglingPersonal => 'Pessoal';

  @override
  String get smugglingCrew => 'Crew';

  @override
  String get smugglingChannelField => 'Canal de contrabando';

  @override
  String get smugglingQuantity => 'Quantidade';

  @override
  String get smugglingVehiclesOneByOne => 'Os veículos são enviados um por um';

  @override
  String smugglingMaxQuantity(int max) {
    return 'Máx.: $max';
  }

  @override
  String get smugglingStartSmuggling => 'Comece o contrabando';

  @override
  String get smugglingSelectItemDestination => 'Selecione o item e o destino';

  @override
  String get smugglingCrewTradeNotAvailable =>
      'O contrabando de Crew para mercadorias comerciais ainda não está disponível';

  @override
  String get smugglingSelectOwnedTransportFirst =>
      'Selecione primeiro um veículo ou aeronave própria';

  @override
  String get smugglingInvalidQuantity => 'Quantidade inválida';

  @override
  String get smugglingActionProcessed => 'Ação processada';

  @override
  String smugglingQuoteSummaryLine(String fee, int etaMinutes, String risk) {
    return '€$fee • $etaMinutes min • $risk% de risco';
  }

  @override
  String smugglingSeizureRiskPercent(String percent) {
    return '$percent% de risco';
  }

  @override
  String get smugglingQuotePrompt =>
      'Selecione o item e o destino para uma cotação ao vivo.';

  @override
  String get smugglingQuoteLiveTitle => 'Citação ao vivo';

  @override
  String smugglingOwnedTransportCaption(String label) {
    return 'Transporte próprio: $label';
  }

  @override
  String smugglingCargoSlotsLine(int required, int available) {
    return 'Slots de carga: $required / $available';
  }

  @override
  String smugglingCooldownActive(String duration) {
    return 'Tempo de espera ativo: $duration';
  }

  @override
  String smugglingRecommendedChannel(String channel) {
    return 'Canal recomendado: $channel';
  }

  @override
  String get smugglingInsufficientCash =>
      'Dinheiro insuficiente para esta remessa';

  @override
  String get smugglingDepotsTitle => 'Depósitos de países';

  @override
  String get smugglingDepotsEmpty => 'Nenhum pacote pronto nos depósitos.';

  @override
  String smugglingDepotLine(int packages, int totalQuantity) {
    return '$packages pacotes • $totalQuantity unidades';
  }

  @override
  String get smugglingClaimHere => 'Reivindique aqui';

  @override
  String get smugglingStatusTitle => 'Situação de contrabando';

  @override
  String get smugglingNoShipmentsYet => 'Ainda não há remessas.';

  @override
  String get smugglingStatusInTransit => 'Em trânsito';

  @override
  String get smugglingStatusReady => 'Preparar';

  @override
  String get smugglingStatusSeized => 'Apreendida';

  @override
  String get smugglingStatusClaimed => 'Reivindicada';

  @override
  String get smugglingStatusUnknown => 'Desconhecida';

  @override
  String get smugglingChannelPackage => 'Pacote';

  @override
  String get smugglingChannelCourier => 'Correio';

  @override
  String get smugglingChannelContainer => 'Recipiente';

  @override
  String get smugglingChannelOwned => 'Transporte próprio';

  @override
  String get smugglingHintOwnedTransport =>
      'O transporte próprio reduz custos e riscos, mas pode ser confiscado em caso de falha na operação.';

  @override
  String get smugglingHintVehiclesChannel =>
      'Dica: os veículos funcionam melhor com Courier ou Container.';

  @override
  String get smugglingHintWeaponsChannel =>
      'Dica: cargas maiores de armas são melhores via Container.';

  @override
  String get smugglingHintAmmoChannel =>
      'Dica: munição a granel via Container para menor risco.';

  @override
  String get smugglingHintDrugsChannel =>
      'Dica: pequenos lotes via Package, a granel via Container.';

  @override
  String get smugglingHintCompareChannels =>
      'Dica: compare os canais com a cotação ao vivo.';

  @override
  String get smugglingQuoteBoatCannotFit =>
      'Um barco não cabe em uma aeronave.';

  @override
  String get smugglingQuoteCargoOverflow =>
      'A capacidade de carga de transporte de sua propriedade é muito pequena.';

  @override
  String get smugglingQuoteUnavailable => 'Cotação indisponível';

  @override
  String get smugglingApiInvalidChannel => 'Canal de contrabando inválido';

  @override
  String get smugglingApiInvalidNetwork => 'Escolha de rede inválida';

  @override
  String get smugglingApiInvalidQuantity => 'Quantidade inválida';

  @override
  String get smugglingApiInvalidDestination => 'O país de destino não existe';

  @override
  String get smugglingApiPlayerNotFound => 'Jogador não encontrado';

  @override
  String get smugglingApiSameCountryInventory =>
      'Use o inventário local para o mesmo país';

  @override
  String get smugglingApiNotInCrew => 'Você não está em uma Crew';

  @override
  String get smugglingApiCrewTradeUnavailable =>
      'O contrabando de Crew para mercadorias comerciais ainda não está disponível';

  @override
  String get smugglingApiOwnedVehiclesPersonalOnly =>
      'Veículos próprios só funcionam para contrabando pessoal';

  @override
  String get smugglingApiChooseOwnedTransport =>
      'Escolha um veículo ou aeronave própria';

  @override
  String get smugglingApiChosenOwnedTransportUnavailable =>
      'O veículo de propriedade selecionado não está disponível';

  @override
  String get smugglingApiSameVehicleCargoConflict =>
      'Você não pode usar o mesmo veículo como carga e transporte';

  @override
  String get smugglingApiCarCannotCarryOtherVehicle =>
      'Um carro ou moto não pode transportar outro veículo';

  @override
  String get smugglingApiVehiclesCannotUsePackageChannel =>
      'Veículos não podem usar o canal de pacotes';

  @override
  String get smugglingApiBoatCannotFit => 'Um barco não cabe em uma aeronave.';

  @override
  String get smugglingApiCargoOverflow =>
      'A capacidade de carga de transporte de sua propriedade é muito pequena.';

  @override
  String smugglingApiCooldownWait(int seconds, String channel) {
    return 'Aguarde ${seconds}s antes de outra remessa de $channel';
  }

  @override
  String get smugglingApiInsufficientMoney =>
      'Não há dinheiro suficiente para taxas de contrabando';

  @override
  String get smugglingApiInsufficientDrugsCrew =>
      'Não há medicamentos suficientes no inventário da Crew';

  @override
  String get smugglingApiInsufficientDrugs =>
      'Não há medicamentos suficientes no estoque';

  @override
  String get smugglingApiInsufficientTradeGoods =>
      'Não há bens comerciais suficientes no estoque';

  @override
  String get smugglingApiInsufficientWeaponsCrew =>
      'Armas insuficientes no inventário da Crew';

  @override
  String get smugglingApiInsufficientWeapons =>
      'Armas insuficientes no inventário';

  @override
  String get smugglingApiInsufficientAmmoCrew =>
      'Munição insuficiente no inventário da Crew';

  @override
  String get smugglingApiInsufficientAmmo =>
      'Munição insuficiente no inventário';

  @override
  String get smugglingApiInvalidCrewVehicle => 'Veículo de Crew inválido';

  @override
  String get smugglingApiCrewBoatUnavailable =>
      'Barco da Crew não está disponível para contrabando';

  @override
  String get smugglingApiCrewMotorcycleUnavailable =>
      'Motocicleta da Crew não está disponível para contrabando';

  @override
  String get smugglingApiCrewCarUnavailable =>
      'Carro da Crew não está disponível para contrabando';

  @override
  String get smugglingApiInvalidVehicleKey => 'Veículo inválido';

  @override
  String get smugglingApiVehicleUnavailableForSmuggling =>
      'Veículo não disponível para contrabando';

  @override
  String get smugglingApiInsufficientStockForShipment =>
      'Estoque insuficiente para esta remessa';

  @override
  String get smugglingApiDepotNoShipmentsReady =>
      'Nenhuma remessa pronta neste depósito nacional';

  @override
  String smugglingApiQuantityTooHighForChannel(String channel, int max) {
    return 'Quantidade muito alta para $channel. Máx.: $max';
  }

  @override
  String smugglingApiShipmentStarted(String channel, String destination) {
    return 'Remessa de contrabando ($channel) para $destination iniciada';
  }

  @override
  String smugglingApiClaimedPersonal(int count, String country) {
    return 'Recolhidas $count remessa(s) em $country';
  }

  @override
  String smugglingApiClaimedCrew(int count, String country) {
    return 'Recolheu $count remessa(s) de Crew em $country';
  }

  @override
  String get smugglingClientShipmentFailed => 'Falha no envio';

  @override
  String get smugglingClientQuoteFailed => 'Falha na cotação';

  @override
  String get smugglingClientClaimFailed => 'Falha na reivindicação';

  @override
  String smugglingClientErrorPrefix(String detail) {
    return 'Erro: $detail';
  }

  @override
  String get cryptoMarketNoData =>
      'Nenhum dado de mercado criptográfico disponível';

  @override
  String get cryptoMarketTitle => 'Mercado criptográfico';

  @override
  String cryptoMarketOpenOrdersCount(int count) {
    return 'Pedidos abertos: $count';
  }

  @override
  String get cryptoRegimeBull => 'Mercado em alta';

  @override
  String get cryptoRegimeBear => 'Mercado baixista';

  @override
  String get cryptoRegimeSideways => 'Lateralmente';

  @override
  String cryptoOwnedAmountLine(String amount) {
    return 'Propriedade: $amount';
  }

  @override
  String get cryptoPortfolioTitle => 'Portfólio';

  @override
  String get cryptoLabelValue => 'Valor';

  @override
  String get cryptoLabelCostBasis => 'Base de custo';

  @override
  String get cryptoLabelUnrealized => 'Não realizado';

  @override
  String get cryptoLabelRealized => 'Percebeu';

  @override
  String get cryptoNoPositionsYet => 'Ainda não há vagas';

  @override
  String get cryptoChartDataUnavailable => 'Dados do gráfico indisponíveis';

  @override
  String get cryptoUnknownTime => 'Desconhecida';

  @override
  String get cryptoOrderTypeStopLoss => 'Stop Loss';

  @override
  String get cryptoOrderTypeTakeProfit => 'Obter lucro';

  @override
  String get cryptoOrderTypeLimit => 'Limite';

  @override
  String get cryptoSideBuy => 'Comprar';

  @override
  String get cryptoSideSell => 'Vender';

  @override
  String get cryptoInvalidQuantity => 'Quantidade inválida';

  @override
  String get cryptoPurchaseCompleted => 'Compra concluída';

  @override
  String get cryptoSaleCompleted => 'Venda concluída';

  @override
  String get cryptoActionProcessed => 'Ação processada';

  @override
  String get cryptoInvalidTargetPrice => 'Preço alvo inválido';

  @override
  String get cryptoCannotSellMoreThanOwned =>
      'Você não pode vender mais do que possui.';

  @override
  String get cryptoOpenOrderPlaced => 'Pedido aberto feito';

  @override
  String get cryptoOpenOrderFailed => 'Falha ao fazer o pedido';

  @override
  String get cryptoOrderCancelled => 'Pedido cancelado';

  @override
  String get cryptoCancelOrderFailed => 'Falha ao cancelar pedido';

  @override
  String get cryptoDirectTradeTitle => 'Comércio direto';

  @override
  String get cryptoLabelQuantity => 'Quantidade';

  @override
  String cryptoDirectTradeHelperWithAvgAndAll(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Preço atual: $currentPrice€ • Compra média: $avgBuy€ \nUse ALL para vender sua posição completa instantaneamente.';
  }

  @override
  String cryptoDirectTradeHelperWithAvgOnly(
    String currentPrice,
    String avgBuy,
  ) {
    return 'Preço atual: $currentPrice€ • Compra média: $avgBuy€';
  }

  @override
  String cryptoDirectTradeHelperPriceAndAll(String currentPrice) {
    return 'Preço atual: €$currentPrice \nUse ALL para vender sua posição completa instantaneamente.';
  }

  @override
  String cryptoDirectTradeHelperPriceOnly(String currentPrice) {
    return 'Preço atual: €$currentPrice';
  }

  @override
  String cryptoYourHistoryForSymbol(String symbol) {
    return 'Sua história para $symbol';
  }

  @override
  String get cryptoLabelAvgBuy => 'Média de compra';

  @override
  String get cryptoLabelLastBuy => 'Última compra';

  @override
  String get cryptoLabelBuyVolume => 'Volume de compra';

  @override
  String get cryptoLabelSellVolume => 'Volume de vendas';

  @override
  String cryptoLastBuyAt(String when) {
    return 'Última compra em $when';
  }

  @override
  String get cryptoNoTradesForCoinYet =>
      'Nenhuma negociação para esta moeda ainda.';

  @override
  String cryptoOpenOrdersForSymbol(String symbol) {
    return 'Pedidos abertos para $symbol';
  }

  @override
  String get cryptoOpenOrdersSectionHint =>
      'Pedidos abertos usam sua própria quantidade abaixo. Preencha a quantidade e o preço alvo nesta seção.';

  @override
  String get cryptoLabelOrderType => 'Tipo de pedido';

  @override
  String get cryptoLabelSide => 'Lado';

  @override
  String get cryptoLabelOrderQuantity => 'Quantidade do pedido';

  @override
  String cryptoOrderQtyHelperOwned(String quantity) {
    return 'Esta ordem é vendida a partir da sua posição atual. Propriedade: $quantity';
  }

  @override
  String get cryptoOrderQtyHelperStandalone =>
      'Esta quantidade é separada do comércio direto acima.';

  @override
  String get cryptoLabelTargetPrice => 'Preço alvo';

  @override
  String get cryptoTargetPriceHelperLimit =>
      'Limite a compra abaixo do preço, limite a venda acima do preço';

  @override
  String get cryptoTargetPriceHelperStopLoss =>
      'Executa quando o preço cai para este nível';

  @override
  String get cryptoTargetPriceHelperTakeProfit =>
      'Executa quando o preço sobe para este nível';

  @override
  String get cryptoPlaceOpenOrder => 'Fazer pedido aberto';

  @override
  String get cryptoNoOpenOrdersYet =>
      'Você ainda não tem nenhum pedido aberto para esta moeda.';

  @override
  String get cryptoLabelCancel => 'Cancelar';

  @override
  String cryptoDetailsTitleWithSymbol(String symbol) {
    return 'Detalhes da criptografia • $symbol';
  }

  @override
  String get cryptoLabelCoin => 'Moeda';

  @override
  String get cryptoLabelPrice => 'Preço';

  @override
  String get cryptoLabelOwned => 'Controlada';

  @override
  String get cryptoLabelOpenOrders => 'Pedidos abertos';

  @override
  String get cryptoNotEnoughHistory => 'Ainda não há história suficiente';

  @override
  String get cryptoChartPointsWord => 'pontos';

  @override
  String get cryptoChartHourAbbrev => 'h';

  @override
  String cryptoChartDataCaptionFullHistory(int count, String points) {
    return '$count $points • histórico completo';
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
  String get cryptoChartRangeAll => 'Todos';

  @override
  String get cryptoChartLive1h => 'Ao vivo • última 1h';

  @override
  String get cryptoChartLive4h => 'Ao vivo • últimas 4h';

  @override
  String get cryptoChartLive8h => 'Ao vivo • últimas 8h';

  @override
  String get cryptoChartLive24h => 'Ao vivo • últimas 24h';

  @override
  String get cryptoChartLive7d => 'Ao vivo • últimos 7 dias';

  @override
  String get cryptoChartLive30d => 'Ao vivo • últimos 30 dias';

  @override
  String get cryptoChartLiveAll => 'Ao vivo • histórico completo';

  @override
  String get cryptoLabelTotal => 'Total';

  @override
  String get cryptoApiCouldNotLoadMarket =>
      'Não foi possível carregar o mercado criptográfico.';

  @override
  String get cryptoApiAssetNotFound => 'Criptografia não encontrada.';

  @override
  String get cryptoApiCouldNotLoadChart =>
      'Não foi possível carregar os dados do gráfico criptográfico.';

  @override
  String get cryptoApiNotLoggedIn => 'Não logado.';

  @override
  String get cryptoApiCouldNotLoadPortfolio =>
      'Não foi possível carregar o portfólio.';

  @override
  String get cryptoApiCouldNotLoadTransactions =>
      'Não foi possível carregar o histórico de transações criptográficas.';

  @override
  String get cryptoApiInvalidQuantity => 'Quantidade inválida.';

  @override
  String get cryptoApiInsufficientFunds => 'Não há dinheiro suficiente.';

  @override
  String get cryptoApiPurchaseFailed => 'A compra falhou.';

  @override
  String get cryptoApiNotEnoughCrypto => 'Não há criptografia suficiente.';

  @override
  String get cryptoApiSellFailed => 'A venda falhou.';

  @override
  String get cryptoApiCouldNotLoadOrders =>
      'Não foi possível carregar pedidos criptográficos.';

  @override
  String get cryptoApiInvalidTargetPrice => 'Preço alvo inválido.';

  @override
  String get cryptoApiInvalidOrderType => 'Tipo de pedido inválido.';

  @override
  String get cryptoApiInvalidOrderSide => 'Lado do pedido inválido.';

  @override
  String get cryptoApiInvalidOrderCombination =>
      'Este tipo de pedido e combinação de lados não são permitidos.';

  @override
  String get cryptoApiPlaceOrderFailed => 'Falha ao fazer o pedido.';

  @override
  String get cryptoApiPlayerNotFound => 'Jogador não encontrado.';

  @override
  String get cryptoApiInvalidOrderId => 'ID de pedido inválido.';

  @override
  String get cryptoApiOrderNotFoundOrClosed =>
      'Pedido não encontrado ou não está mais ativo.';

  @override
  String get cryptoApiCancelOrderFailed => 'Falha ao cancelar o pedido.';

  @override
  String cryptoApiBuySuccess(String quantity, String symbol, String total) {
    return 'Você comprou $quantity $symbol por €$total.';
  }

  @override
  String cryptoApiSellSuccess(String quantity, String symbol, String total) {
    return 'Você vendeu $quantity $symbol por €$total.';
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
    return 'Erro: $detail';
  }

  @override
  String drugsClientErrorLoading(String error) {
    return 'Erro ao carregar: $error';
  }

  @override
  String drugsFacilitiesErrorLoading(String error) {
    return 'Erro ao carregar recursos: $error';
  }

  @override
  String get drugsInvTitle => 'Inventário de Medicamentos';

  @override
  String get drugsInvKpiGramsLabel => 'inventário';

  @override
  String get drugsCutQualityDCannotCut =>
      'A qualidade D não pode ser mais reduzida.';

  @override
  String get drugsCutFailed => 'Falha no corte';

  @override
  String get drugsSellFailed => 'Falha na venda';

  @override
  String drugsSellDialogTitle(String name) {
    return 'Vender $name';
  }

  @override
  String drugsInvAvailableQty(String qty) {
    return 'Disponível: $qty g';
  }

  @override
  String drugsQualityWithGrade(String grade) {
    return 'Qualidade: $grade';
  }

  @override
  String drugsCurrentPricePerGram(String price) {
    return 'Preço atual: €$price por grama';
  }

  @override
  String get drugsPricesByCountry => 'Preços por país:';

  @override
  String get drugsQuantityGramsField => 'Quantidade (gramas)';

  @override
  String drugsInvTotalLine(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsInvalidQuantity => 'Quantidade inválida';

  @override
  String get drugsSellAction => 'Vender';

  @override
  String get drugsInvEmptyTitle => 'Não há medicamentos em estoque';

  @override
  String get drugsInvEmptySubtitle =>
      'Inicie a produção para criar medicamentos';

  @override
  String get drugsInvSectionHeader => 'Estoque e distribuição';

  @override
  String get drugsInvSectionBody =>
      'Vender medicamentos por qualidade e usar diferenças de preços entre países.';

  @override
  String drugsInvCurrentLocation(String place) {
    return 'Localização atual: $place';
  }

  @override
  String drugsInvStockLine(String qty) {
    return 'Inventário: ${qty}g';
  }

  @override
  String drugsInvCurrentValue(String amount) {
    return 'Valor atual: €$amount';
  }

  @override
  String drugsInvMarketLine(String emoji, String pct) {
    return 'Mercado: $emoji $pct%';
  }

  @override
  String get drugsCutDialogTitle => 'Cortar drogas';

  @override
  String drugsCutQualityBanner(String fromQ, String toQ, String pct) {
    return 'Qualidade $fromQ → $toQ: +$pct% mais unidades';
  }

  @override
  String drugsCutResultLine(
    String qty,
    String qFrom,
    String result,
    String qTo,
  ) {
    return 'Resultado: ${qty}g $qFrom → ${result}g $qTo';
  }

  @override
  String get drugsCutAction => 'Corte';

  @override
  String get drugsSlotsLabel => 'slots';

  @override
  String get drugsFacilitiesTitle => 'Instalações de drogas';

  @override
  String get drugsFacilitiesHeroTitle =>
      'Gerencie suas instalações de medicamentos';

  @override
  String get drugsFacilitiesHeroBody =>
      'Instalações como estufa, fazenda de cogumelos, laboratório de drogas, cozinha de crack e loja darkweb determinam quais drogas você pode produzir, quantos slots você tem e quão forte é sua qualidade, rendimento e velocidade.';

  @override
  String get drugsFacCurrentProductions => 'Produções atuais';

  @override
  String get drugsFacUnknownFacility => 'Instalação desconhecida';

  @override
  String get drugsFacUnknownMessage => 'Mensagem desconhecida';

  @override
  String get drugsFacUpgradeLockedTitle =>
      '🔒 Atualização de medicamento bloqueada';

  @override
  String get drugsFacUpgradeLockedBody =>
      'Primeiro, você precisa dos níveis e certificações corretos de educação em Narcóticos.';

  @override
  String get drugsFacEquipLockedTitle =>
      '🔒 Atualização de equipamento bloqueada';

  @override
  String get drugsFacEquipLockedBody =>
      'Treine primeiro sua trilha de Narcóticos para desbloquear o próximo nível de atualização.';

  @override
  String get drugsFacBuy => 'Comprar';

  @override
  String get drugsFacOwned => 'Controlada';

  @override
  String get drugsFacPrice => 'Preço';

  @override
  String get drugsFacRank => 'Classificação';

  @override
  String get drugsFacDrugTypes => 'Drogas';

  @override
  String get drugsFacSlots => 'Caça-níqueis';

  @override
  String get drugsFacQuality => 'Qualidade';

  @override
  String get drugsFacYield => 'Colheita';

  @override
  String get drugsFacSpeed => 'Velocidade';

  @override
  String get drugsFacMaxSlots => 'Slots máximos';

  @override
  String drugsFacUpgradeSlots(String cost) {
    return 'Slots de atualização (€$cost)';
  }

  @override
  String get drugsFacEquipmentUpgrades => 'Atualizações de equipamentos';

  @override
  String get drugsFacMax => 'Máx.';

  @override
  String drugsFacLvlPrice(String level, String price) {
    return 'Nível $level (€$price)';
  }

  @override
  String get drugsHubTitle => 'Ambiente de drogas';

  @override
  String get drugsSubviewProduction => 'Produção de Medicamentos';

  @override
  String get drugsSubviewFacilities => 'Instalações de drogas';

  @override
  String get drugsSubviewInventory => 'Inventário de Medicamentos';

  @override
  String get drugsTagUndergroundOps => 'Operações Subterrâneas';

  @override
  String get drugsTagMobileOptimized => 'Otimizado para celular';

  @override
  String get drugsTagQualityDriven => 'Orientado para a qualidade';

  @override
  String get drugsEmpireTitle => 'Império das Drogas';

  @override
  String get drugsHubIntro =>
      'Gerencie produção, instalações e estoque aqui. Compre materiais no Mercado Negro enquanto o resto funciona em seu próprio ambiente de drogas.';

  @override
  String get drugsStatMaterialFlow => 'Fluxo de materiais';

  @override
  String get drugsStatBlackMarket => 'Mercado negro';

  @override
  String get drugsStatProductionChain => 'Cadeia produtiva';

  @override
  String get drugsStatProductionChainValue =>
      'Estufa + Laboratório + Cozinha + Darkweb';

  @override
  String get drugsStatSalesModel => 'Modelo de vendas';

  @override
  String get drugsStatPerQuality => 'Por qualidade';

  @override
  String get drugsMetricActiveBatches => 'Lotes ativos';

  @override
  String get drugsMetricSlotUsage => 'Uso de slots';

  @override
  String get drugsMetricInventoryValue => 'Valor do estoque';

  @override
  String get drugsMetricInventoryGrams => 'Gramas de estoque';

  @override
  String get drugsMetricEfficiency => 'Eficiência';

  @override
  String get drugsMetricPoliceHeat => 'Calor Policial';

  @override
  String get drugsSectionOperations => 'Operações';

  @override
  String get drugsSectionOperationsSubtitle =>
      'Escolha um ramo do seu império das drogas';

  @override
  String get drugsCardFacilitiesEyebrow => 'Infraestrutura';

  @override
  String get drugsCardFacilitiesTitle => 'Instalações';

  @override
  String get drugsCardFacilitiesBody =>
      'Compre e atualize estufa, laboratório de drogas, cozinha de crack e loja darkweb para obter mais slots, velocidade e qualidade.';

  @override
  String get drugsCardProductionEyebrow => 'Gasoduto';

  @override
  String get drugsCardProductionTitle => 'Produção';

  @override
  String get drugsCardProductionBody =>
      'Inicie lotes, monitore cronômetros e colete resultados com rolos de qualidade.';

  @override
  String get drugsCardInventoryEyebrow => 'Distribuição';

  @override
  String get drugsCardInventoryTitle => 'Inventário';

  @override
  String get drugsCardInventoryBody =>
      'Visualize as pilhas por qualidade e venda pelo melhor valor de mercado.';

  @override
  String get drugsQualityDistribution => 'Distribuição de qualidade';

  @override
  String get drugsQualityGradeSuperior => 'Superiora';

  @override
  String get drugsQualityGradeHigh => 'Alta';

  @override
  String get drugsQualityGradeStandardPlus => 'Padrão+';

  @override
  String get drugsQualityGradeStandard => 'Padrão';

  @override
  String get drugsQualityGradeLow => 'Baixo';

  @override
  String get drugsHeatLevelLow => 'Baixo';

  @override
  String get drugsHeatLevelMedium => 'Média';

  @override
  String get drugsHeatLevelHigh => 'Alta';

  @override
  String get drugsHeatLevelCritical => 'Crítica';

  @override
  String get drugsProdTitle => 'Produção de Medicamentos';

  @override
  String get drugsProdLineTitle => 'Linha de produção';

  @override
  String get drugsProdLineSubtitle =>
      'Inicie lotes, monitore a capacidade dos slots e ajuste a qualidade por meio de atualizações de estufas e laboratórios.';

  @override
  String get drugsProdActiveProductions => 'Produções Ativas';

  @override
  String get drugsProdIncidentLegend => 'Legenda do incidente';

  @override
  String get drugsProdHide => 'Esconder';

  @override
  String get drugsProdShow => 'Mostrar';

  @override
  String get drugsProdLegendDelay => 'Atraso';

  @override
  String get drugsProdLegendContamination => 'Contaminação';

  @override
  String get drugsProdLegendYieldLoss => 'Perda de rendimento';

  @override
  String get drugsProdLegendInstability => 'Instabilidade';

  @override
  String get drugsProdLegendCombined => 'Problema combinado';

  @override
  String get drugsProdCollect => 'Coletar';

  @override
  String get drugsProdAvailableDrugs => 'Medicamentos Disponíveis';

  @override
  String get drugsProdNoDrugs => 'Não há medicamentos disponíveis';

  @override
  String get drugsProdAutoCollectOn => 'Coleta automática ativada (VIP)';

  @override
  String get drugsProdAutoCollectOff => 'Coleta automática desativada (VIP)';

  @override
  String get drugsProdVipMaterialsOk => 'Todos os materiais disponíveis';

  @override
  String get drugsProdVipBuyMissing =>
      'VIP: compre materiais que faltam com um clique';

  @override
  String drugsProdTimeYieldLine(String time, String yield) {
    return 'Horário: $time | Rendimento: ${yield}g';
  }

  @override
  String drugsProdSlotsUsedLine(String facility, String used, String total) {
    return '$facility: $used/$total slots usados';
  }

  @override
  String drugsProdFacilityRequired(String facility) {
    return '$facility obrigatório';
  }

  @override
  String drugsProdRankRequired(String rank) {
    return 'Classificação $rank necessária';
  }

  @override
  String get drugsProdNoFreeSlot =>
      'Nenhum slot de produção gratuito disponível';

  @override
  String get drugsProdOpenFacilities => 'Instalações abertas';

  @override
  String get drugsProdStartProduction => 'Iniciar produção';

  @override
  String get drugsProdAutoCollectUpdated => 'Coleta automática atualizada';

  @override
  String get drugsProdKpiActive => 'ativa';

  @override
  String get drugsProdKpiReady => 'preparar';

  @override
  String drugsProdYieldGrams(String qty) {
    return 'Rendimento: $qty gramas';
  }

  @override
  String get drugsTimeMinSuffix => 'min';

  @override
  String drugsFmtMinutes(String minutes) {
    return '$minutes minutos';
  }

  @override
  String drugsFmtHoursOnly(String hours) {
    return '$hours horas';
  }

  @override
  String drugsFmtHoursMinutes(String hours, String minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get drugsTimeHourEn => 'horas';

  @override
  String get drugsProdConfirmTitle => 'Tem certeza?';

  @override
  String drugsProdConfirmBody(String drugName) {
    return 'Iniciar $drugName produção?';
  }

  @override
  String drugsProdTimeLine(String time) {
    return 'Horário: $time';
  }

  @override
  String drugsProdYieldLine(String yield) {
    return 'Rendimento: $yield gramas';
  }

  @override
  String get drugsProdRiskNote =>
      'A produção às vezes pode sofrer contratempos. Melhores atualizações reduzem o risco, o alto calor da droga aumenta-o.';

  @override
  String get drugsProdRequiredMaterialsHeader => 'Materiais necessários:';

  @override
  String get drugsProdStartProductionButton => 'Iniciar produção';

  @override
  String get drugsProdFailed => 'Falha na produção';

  @override
  String get drugsProdCollectFailed => 'Falha na coleta';

  @override
  String drugsProdNeedRank(String rank) {
    return 'Você precisa de classificação $rank';
  }

  @override
  String get drugsProdMissingPrefix => 'Ausente';

  @override
  String get drugsFacilityGreenhouse => 'Estufa';

  @override
  String get drugsFacilityCrackKitchen => 'Cozinha Rachadura';

  @override
  String get drugsFacilityDarkweb => 'Vitrine Darkweb';

  @override
  String get drugsFacilityMushroomFarm => 'Fazenda de Cogumelos';

  @override
  String get drugsFacilityDrugLab => 'Laboratório de Drogas';

  @override
  String get drugsVipQuickBuyTitle => 'Compra rápida VIP';

  @override
  String drugsVipAlreadyEnough(String name) {
    return 'Você já tem materiais suficientes para $name';
  }

  @override
  String drugsVipBuyPrompt(String name) {
    return 'Comprar todos os materiais que faltam por $name com um clique?';
  }

  @override
  String drugsVipTotal(String amount) {
    return 'Total: €$amount';
  }

  @override
  String get drugsPurchaseCompleted => 'Compra concluída';

  @override
  String get drugsPurchaseFailed => 'Falha na compra';

  @override
  String get drugsServiceErrorGeneric => 'Erro';

  @override
  String get drugsApiFailedBuyMaterial => 'Não consegui comprar material';

  @override
  String get drugsApiFailedStartProduction => 'Falha ao iniciar a produção';

  @override
  String get drugsApiFailedCollect => 'Falha ao coletar a produção';

  @override
  String get drugsApiFailedSell => 'Não conseguiu vender drogas';

  @override
  String get drugsApiFailedCut => 'Não conseguiu cortar as drogas';

  @override
  String get drugsApiFailedShipment => 'Falha ao enviar remessa';

  @override
  String get drugsApiFailedClaim => 'Falha ao reivindicar remessas de depósito';

  @override
  String get helpTopicDashboardCategory => 'Essencial';

  @override
  String get helpTopicDashboardTitle => 'Painel';

  @override
  String get helpTopicDashboardSummary =>
      'Sua visão geral central com todas as suas estatísticas, tempos de espera ativos, eventos ao vivo e atalhos para todas as partes do jogo.';

  @override
  String get helpTopicDashboardHow =>
      'A barra superior mostra: Dinheiro, Classificação, Saúde (0-100 HP), Nível de Procurado (0-100) e FBI Heat (0-100). \nA cada 5 minutos um tick automático é acionado: a fome cai -2, a sede -3, você cura passivamente +5 HP (se HP > 0), o nível de procurado cai ligeiramente quando abaixo de 10 (juros bancários estão atualmente desativados). \nSe a fome ou a sede chegar a 0 você morre e fica 3 horas na UTI. Coma e beba na hora certa! \nOs blocos de ação rápida à direita são atalhos para crimes, roubo de carro, roubo de barco, trabalho, cassino, banco e escola. \nOs temporizadores de resfriamento por seção mostram quanto tempo até que sua próxima ação esteja disponível. O cronômetro se adapta para mostrar a unidade mais relevante: minutos, horas ou dias. \nO cartão de estatísticas agora usa contadores reais ao vivo para fugas, assassinatos, contratos de lista de alvos, viagens e balas, em vez de marcadores de zero fixos. \nO painel agora também tem uma seção de economia expandida com dinheiro, banco, criptografia, valor do veículo, valor da propriedade, patrimônio líquido e tendência de fluxo de caixa de 24 horas. \nO bloco de operações agora mostra a produção ativa, o tempo de espera mais longo, o status do veículo (ativo/listado/em trânsito) e os temporizadores da próxima produção/evento. \nQuando os eventos dos jogadores são ao vivo (por exemplo, competições semanais), o mesmo painel direito lista brevemente seus títulos e links para a página Eventos. Você pode ativar ou desativar o push para início/fim da rodada em Configurações → Eventos do jogador (além de permissões do dispositivo e outras categorias de push). \nNotificações e riscos agora incluem mensagens diretas não lidas, tickets de suporte aguardando sua resposta, eventos das últimas 24 horas e uma pontuação de risco compacta (procurado + FBI). \nQuando sua Crew está envolvida em Crew Wars, o painel também mostra um resumo do Crew Wars com status, oponente, pontos de Crew, classificação da temporada e o tempo restante na fase atual. \nO painel agora também inclui uma visão geral das operações de veículos por carro/motocicleta/barco com chips de resfriamento ao vivo (ponto de acesso, Crew, partida de Crew, corte, contrato e contador), além de calor/reputação, contagem de contratos e reivindicações e pontos de temporada. \nOs eventos ao vivo aparecem quando outros jogadores realizam ações importantes, quando você é atacado ou quando ocorrem movimentos no mercado global. \nO selo de mensagem mostra mensagens não lidas do sistema e mensagens pessoais. \nO menu de navegação à esquerda dá acesso a todas as seções do jogo agrupadas por categoria: Ações, Mundo, Social, Economia, Império e Ativos.';

  @override
  String get helpTopicDashboardTips =>
      'Abra o painel primeiro após cada login para ver o que mudou enquanto você estava ausente. \nMantenha o nível de procurado abaixo de 10 para que a decadência automática funcione e as chances de prisão permaneçam baixas. \nVerifique as mensagens não lidas antes de iniciar ações arriscadas: recompensas, atendimentos de pedidos e eventos do sistema aparecem na sua caixa de entrada.';

  @override
  String get helpTopicCrimesCategory => 'Ações';

  @override
  String get helpTopicCrimesTitle => 'Crimes';

  @override
  String get helpTopicCrimesSummary =>
      'Cometa ações ilegais por dinheiro e XP, mas cada tentativa corre o risco de danos, prisão ou Nível de Procurado extra. O crime de limpeza de registro criminal no final do jogo remove todo o seu registro criminal em caso de sucesso, mas precisa de ferramentas pesadas e acarreta alto risco federal.';

  @override
  String get helpTopicCrimesHow =>
      'Os tempos de espera para crimes agora aumentam com o pagamento potencial: crimes de baixo rendimento permanecem rápidos, enquanto crimes de alto rendimento têm tempos de espera claramente mais longos. \nDiretriz por nível de recompensa: até € 500 ≈ 1,5 min, até € 2.000 ≈ 5 min, até € 10.000 ≈ 15 min, até € 30.000 ≈ 30 min, acima disso ≈ 60 min. \nNão existe um limite diário rígido para os crimes; jogadores ativos podem continuar jogando desde que gerenciem tempos de espera, riscos e recursos. \nCrimes com \'arma necessária\' usam a arma do crime selecionada. Agora você pode escolhê-lo diretamente no topo da tela Crimes ou através do Inventário. \nSeus bônus ativos de academia e campo de tiro (até +8% cada) aparecem na tela Crimes; eles aumentam a chance de sucesso como o servidor calcula (treine mais no Centro de treinamento / academia + campo de tiro). \nSe você completar pelo menos uma sessão na academia e uma no campo de tiro no mesmo dia civil UTC, o servidor soma +0,5% de chance extra de sucesso em crimes. A tela Crimes mostra quando o combo está ativo. \nCrimes com exigência de veículo usam o veículo do crime selecionado na Garagem ou Marina. Somente conta um veículo que esteja realmente em seu país atual e não em trânsito ou listado para venda. \nAs necessidades de drogas em crimes são mostradas em gramas e seguem as mesmas quantidades do seu estoque e armazenamento de drogas. \nSe um crime não puder ser iniciado devido ao desaparecimento de um veículo, da arma errada ou da falta de munição, a mensagem de erro deverá agora mostrar a causa real em vez de uma nova tentativa genérica. \nCada tentativa de crime: você sofre de 5 a 15 pontos de dano de HP e o Nível de Procurado aumenta de 1 a 4 pontos, dependendo do sucesso ou do fracasso. \nA chance de prisão aumenta rapidamente com o Nível de Procurado: Procurado 5 = 25%, Procurado 10 = 50%, Procurado 18+ = máximo 90%. \nAo ser preso você vai para a prisão. Frase = máximo (nível de procurado × 10, 5) minutos. Fiança = nível de procurado × € 1.000. Mesmo que um crime pareça inicialmente bem-sucedido, mas você seja pego logo depois, o resultado final ainda conta como uma prisão: as ferramentas necessárias são confiscadas, a arma do crime usada é perdida e os veículos também podem ser apreendidos. \nAlguns crimes exigem veículo, ferramenta ou classificação mínima. Perdê-los impedirá o início do crime. \nA XP ganha aumenta sua classificação, desbloqueando crimes melhores e recompensas maiores. \nFBI Heat aumenta com crimes mais pesados. Acima da bateria 50, o FBI torna-se ativo com chances de prisão ainda maiores.';

  @override
  String get helpTopicCrimesTips =>
      'Use crimes rápidos para iniciantes para construir XP enquanto espera por grandes tempos de espera. \nSempre resgate se o seu nível de procurado for alto – ficar na prisão bloqueia todos os seus loops. \nMantenha HP acima de 30 antes de iniciar uma operação criminosa: cada tentativa custa HP e com 0 HP você passa 3 horas na UTI.';

  @override
  String get helpTopicJobsCategory => 'Ações';

  @override
  String get helpTopicJobsTitle => 'Empregos';

  @override
  String get helpTopicJobsSummary =>
      'Ganhe dinheiro legal sem risco de nível de procurado. Os empregos são mais seguros do que os crimes, mas os pagamentos são mais baixos.';

  @override
  String get helpTopicJobsHow =>
      'Os empregos disponíveis variam de acordo com a classificação e a educação: empregos melhores pagam mais, mas também têm tempos de espera mais longos. \nOs tempos de espera do trabalho aumentam de acordo com o pagamento máximo: trabalhos de nível inferior em torno de 3 a 5 minutos, de nível intermediário em torno de 8 a 12 minutos, de nível superior em torno de 17 a 22 minutos. \nOs empregos têm uma taxa de sucesso alta, mas não perfeita; em caso de falha, você não perde dinheiro ou HP, mas perde algum XP. \nRequisitos por trabalho: mínimo 10 HP, fome > 20, sede > 20, não estar preso, não estar em UTI. \nNão existe um limite diário rígido para os empregos; a progressão é controlada por tempo de espera, chance e pagamento, em vez de um bloqueio diário. \nA remuneração do trabalho varia de acordo com o tipo de trabalho e a categoria. A educação (escola) pode desbloquear posições mais altas. \nVocê também ganha XP por trabalho, embora menos do que crimes comparáveis. \nUse os empregos como uma base confiável de fluxo de caixa, especialmente quando seu nível de procurado for muito alto para crimes seguros.';

  @override
  String get helpTopicJobsTips =>
      'Combine empregos e escola: a educação abre melhores empregos com pagamentos mais elevados. \nQuando o Nível de Procurado estiver acima de 8 ou você estiver se recuperando da UTI, use empregos em vez de crimes. \nEvite que a fome e a sede caiam muito: um trabalho com estatísticas abaixo de 20 simplesmente não será iniciado.';

  @override
  String get helpTopicTravelCategory => 'Mundo';

  @override
  String get helpTopicTravelTitle => 'Viagem';

  @override
  String get helpTopicTravelSummary =>
      'Mova-se entre países para obter melhores preços de mercado, oportunidades únicas e acesso a sistemas internacionais.';

  @override
  String get helpTopicTravelHow =>
      'Países disponíveis: Holanda (início), Bélgica, Alemanha, França, Reino Unido, Espanha, Itália, Suíça, EUA, México, Colômbia, Brasil. \nCustos de viagem: país vizinho entre 500 e 2.000 euros, Europa → Américas entre 5.000 e 10.000 euros, longa distância entre 10.000 e 20.000 euros. \nRequisitos de viagem: não estar na prisão, não estar na UTI, mínimo de 20 HP, fundos para viagem disponíveis. \nAs quantidades de medicamentos em seu inventário contam como gramas reais para peso de transporte e verificações de viagem; 500 significa 500g e não 50kg. \nCada país tem preços de mercado diferentes (diferença de preço de até 300%), diferentes pagamentos de crimes e itens comerciais exclusivos. \nRisco de transporte: a polícia pode apreender mercadorias com base no Nível de Procurado (chance = procurado × 2%, máximo 80%). O FBI pode confiscar tudo internacionalmente se a temperatura estiver alta. \nA inspeção alfandegária tem uma chance básica de 10%. Você pode subornar (1.000€-5.000€) ou ser pego perdendo 50% dos bens. \nApós a chegada, todas as ações ficam imediatamente disponíveis no novo país. Os mercados e a velocidade do crime variam de acordo com o local.';

  @override
  String get helpTopicTravelTips =>
      'Combine sempre viagens com comércio, drogas ou contrabando – viagens vazias desperdiçam dinheiro. \nReduza o seu nível de procurado antes da partida: um nível de procurado elevado aumenta muito o risco de confisco no caminho. \nPlaneje sua viagem de volta com antecedência para já saber o que levar na chegada.';

  @override
  String get helpTopicCrewCategory => 'Social';

  @override
  String get helpTopicCrewTitle => 'Crew';

  @override
  String get helpTopicCrewSummary =>
      'Comece uma equipe ou junte-se a jogadores existentes para realizar assaltos juntos, compartilhar armazenamento e se tornar uma unidade mais forte.';

  @override
  String get helpTopicCrewHow =>
      'Criar uma Crew custa 10.000€. O Quartel-General da Crew determina quantos membros sua Crew pode acomodar e chega a 150 membros. O líder pode convidar, chutar e iniciar assaltos. \nBenefícios da Crew: acesso a grandes assaltos, armazenamento compartilhado, bônus de trabalho em equipe (+10% de sucesso por membro extra, máximo de +30%) e bate-papo em grupo. \nNovas equipes agora começam com o QG da Crew nível 1 e todos os edifícios de armazenamento no nível 1, incluindo armazenamento de dinheiro, para que o banco da Crew e o armazenamento compartilhado funcionem imediatamente. \nO armazenamento de carros da Crew agora também aceita motocicletas, para que os veículos terrestres possam ser gerenciados juntos a partir do mesmo armazenamento compartilhado da Crew. \nQuando um membro da Crew é preso, os membros da Crew agora recebem uma notificação push de que o jogador está preso e esperando por ajuda. \nA tela da Crew agora está agrupada em Visão Geral, QG e Atualizações, Armazenamento, Membros, Sala de Guerra, Missões da Crew, Tripulações e Bate-papo para que o gerenciamento fique mais calmo e profissional. \nCrew Missions mostra modelos de níveis, um cartão de execução ativa e execuções recentes. Os líderes/colíderes podem começar e resolver; a reivindicação de recompensa e a aceleração do resfriamento são tratadas na mesma guia. \nExistem missões extras de Crew com operações temáticas de banco (depósito noturno, rede skim, rota blindada, cofre subsidiário, cofre de reserva e câmara de compensação). Não há uma segunda missão da Crew do cassino além do Casino Ledger Raid. \nAs recompensas das missões da Crew vêm da economia da missão do lado do servidor; os saldos bancários de outros jogadores não são debitados para estes pagamentos. \nAo iniciar uma missão, agora você pode atribuir uma função por membro da Crew (Planejador, Executor, Logística, Técnico) para obter bônus de equipe. \nCartas de missão ativas e recentes agora também mostram contribuições de função por jogador com pontuação e qualquer multiplicador de pagamento. \nOs membros da Crew agora também recebem alertas push/no aplicativo para o início da missão, o resultado da missão e quando o tempo de espera da missão fica pronto novamente. \nEnquanto o tempo de espera da missão estiver ativo, você não poderá iniciar uma nova missão; primeiro espere pelo tempo de espera restante ou acelere com créditos. \nPara acelerar o resfriamento, você primeiro vê o custo exato do crédito e os minutos restantes antes de confirmar. \nCrew Wars tem sua própria aba War Room dentro da tela da Crew. Apenas os líderes podem declarar guerra e pelo menos 3 tripulantes são obrigados a participar. \nTipos de guerra: Guerra Mortal, Guerra Econômica, Guerra Territorial e Guerra Total. Cada guerra passa por preparação, fase ativa, bloqueio e resolução. \nDurante uma guerra ativa, os participantes podem realizar ações como mortes, assaltos, sabotagem, informações, ataques, escudos, reforços e reivindicações de território. As ações direcionadas agora permitem que você escolha diretamente de uma lista de membros da Crew adversária, em vez de digitar o ID do jogador manualmente. \nOs pontos da temporada são agregados na tabela de classificação do Crew Wars. A Sala de Guerra também mostra classificações, ações recentes e guerras recentes para sua Crew. \nEm Territory War e Total War agora você reivindica regiões territoriais reais do sistema territorial em vez de alvos genéricos de espaço reservado. \nEssas regiões de guerra agora também mostram seu valor estratégico na Sala de Guerra: reivindique bônus, pontos de escala e etiquetas como porto, capital ou logística. Isto torna imediatamente claro quais regiões valem mais do que uma simples troca de propriedade. \nCrew Wars não escolhe mais alvos territoriais apenas com base no nível de valor, mas também com base em tags estratégicas e pressão adjacente do território atacante ou defensor. Isso faz com que a Guerra Territorial e a Guerra Total pareçam mais uma verdadeira linha de frente do que três reivindicações aleatórias. \nAssaltos: Small Bank (2 jogadores, 40%, € 10.000 - € 30.000, 30 min de recarga), Joalheria (3 jogadores, 35%, € 20.000 - € 50.000, 45 min), Casino Heist (4 jogadores, 25%, € 50.000 - € 150.000, 2 horas), Federal Reserve (5 jogadores, 15%, €100.000-€500.000, 6 horas, +20 FBI Heat). \nPara um assalto, todos os membros devem estar online no início. Se alguém estiver ausente, o roubo falha. \nAssalto fracassado: pena de prisão para todos, Nível de Procurado +5, sem recompensa. \nA recompensa do assalto é dividida igualmente entre todos os membros participantes. \nO bate-papo da Crew está disponível para coordenação rápida. \nProgressão do QG da Crew: quanto mais longa e ativa a Crew, mais atualizações e buffs compartilhados serão desbloqueados.';

  @override
  String get helpTopicCrewTips =>
      'Novas equipes podem depositar dinheiro e usar o armazenamento compartilhado imediatamente; depois disso, concentre-se em atualizações para obter mais capacidade, em vez de uma compra inicial separada. \nVerifique primeiro a Sala de Guerra para ver se sua Crew ainda está em espera antes de tentar declarar uma nova guerra. \nCoordene as chamadas de alvo no bate-papo da Crew para não continuar atacando o mesmo oponente e tropeçando na guarda anti-fazenda. \nCoordene os horários de início do assalto no bate-papo da equipe para que todos estejam online e ninguém esteja na prisão. \nEscolha uma equipe no mesmo fuso horário ou padrão de atividade para obter melhores taxas de sucesso de assalto. \nUse o armazenamento compartilhado da Crew para separar mercadorias de risco do seu inventário pessoal.';

  @override
  String get helpTopicFriendsCategory => 'Social';

  @override
  String get helpTopicFriendsTitle => 'Amigas';

  @override
  String get helpTopicFriendsSummary =>
      'Gerencie sua lista de amigos para coordenação mais rápida, navegação de perfil e feedback social.';

  @override
  String get helpTopicFriendsHow =>
      'A página de amigos mostra três listas: amigos atuais, solicitações enviadas e solicitações recebidas. \nDe um amigo você pode enviar uma mensagem diretamente, visualizar seu perfil ou iniciar uma colaboração. \nVocê pode ver quando os amigos estão ativos no jogo, o que ajuda a planejar assaltos ou negociações. \nOs pedidos de amizade não expiram automaticamente; mantenha a lista organizada para que as solicitações pendentes não o distraiam. \nAmigos fora da sua Crew são valiosos para fugas da prisão (um amigo pode ajudá-lo a escapar) e para compartilhar informações. \nQuando um amigo é preso, os amigos aceitos agora também recebem uma notificação push de que o jogador está aguardando ajuda na prisão.';

  @override
  String get helpTopicFriendsTips =>
      'Adicione amigos que compartilhem seu estilo de jogo: parceiros de assalto, redes de comerciantes ou apoio ao crime. \nUm amigo que foge da prisão ganha uma recompensa de 500 a 2.000 euros em caso de sucesso. Organize isso para emergências.';

  @override
  String get helpTopicMessagesCategory => 'Social';

  @override
  String get helpTopicMessagesTitle => 'Mensagens';

  @override
  String get helpTopicMessagesSummary =>
      'Sua caixa de entrada com mensagens pessoais dos jogadores e mensagens do sistema sobre recompensas, pedidos e eventos do jogo.';

  @override
  String get helpTopicMessagesHow =>
      'As mensagens são divididas em conversas pessoais e threads do sistema The Mob State. \nAs mensagens do sistema são enviadas automaticamente para: negociações de criptografia, atendimento de pedidos, pagamentos de tabelas de classificação, resultados de assaltos, fugas de prisão e emblemas de conquista. \nVocê pode enviar mensagens para outros jogadores, desde que suas configurações de privacidade permitam. \nAs mensagens não lidas aparecem como um emblema no ícone da mensagem e são visíveis no painel. \nAs mensagens não expiram e são mantidas como um registro histórico de eventos da conta. \nUse o registro da caixa de entrada em caso de dúvida sobre um pagamento, um pedido perdido ou uma alteração inesperada no saldo.';

  @override
  String get helpTopicMessagesTips =>
      'Verifique sua caixa de entrada após longos períodos off-line: recompensas, atendimentos de pedidos e eventos são todos registrados lá. \nConfigure as preferências de notificação em Configurações para receber apenas alertas push para eventos realmente importantes.';

  @override
  String get helpTopicInventoryCategory => 'Gerenciamento';

  @override
  String get helpTopicInventoryTitle => 'Inventário';

  @override
  String get helpTopicInventorySummary =>
      'Gerencie tudo o que você carrega, armazena e equipa: armas, ferramentas, veículos, drogas e mercadorias comerciais.';

  @override
  String get helpTopicInventoryHow =>
      'O inventário é dividido em itens transportados (em você), itens armazenados (armazém/armazenamento da Crew) e carregamentos ativos. \nO peso determina sua capacidade de carga. Alguns crimes ou viagens bloqueiam se você estiver sobrecarregado. \nOs medicamentos são armazenados e apresentados no inventário e armazenamento em gramas; 351 significa 351g. \nA condição do item degrada com o uso. Armas em más condições têm pior desempenho e as ferramentas podem quebrar. \nNo topo do Inventário você também pode escolher sua arma do crime padrão. Somente armas transportadas e utilizáveis ​​contam para essa seleção. \nOs loadouts permitem que você alterne rapidamente entre um conjunto de crime (ferramenta + arma) e um conjunto de viagem (leve, objetos de valor mínimos). \nApós a prisão, a polícia pode confiscar itens. Não carregue objetos de valor com alto nível de procurado. \nAs drogas em estoque aumentam a chance de intervenção do FBI durante viagens internacionais. \nO armazenamento da Crew é um local seguro para manter itens fora do risco de transporte pessoal.';

  @override
  String get helpTopicInventoryTips =>
      'Mantenha sua carga leve ao viajar ou realizar uma onda de crimes com alto risco de prisão. \nUse loadouts para ter sempre o equipamento certo equipado para cada cenário. \nVerifique regularmente a condição dos itens: ferramentas quebradas bloqueiam crimes silenciosamente sem uma mensagem de erro clara.';

  @override
  String get helpTopicPropertiesCategory => 'Economia';

  @override
  String get helpTopicPropertiesTitle => 'Propriedades';

  @override
  String get helpTopicPropertiesSummary =>
      'Compre imóveis para ampliar o armazenamento, a capacidade habitacional e o acesso a determinados sistemas como a boate.';

  @override
  String get helpTopicPropertiesHow =>
      'Cada imóvel tem a sua função: espaço de arrumação, capacidade habitacional ou acesso a um módulo de acompanhamento como a discoteca. \nAs atualizações do armazém aumentam sua capacidade de armazenamento de itens e outros estoques. \nCasas e apartamentos aumentam a capacidade habitacional; Além disso, os jogadores VIP recebem slots extras. \nAlgumas propriedades são exclusivas ou estão bloqueadas pelo país: você deve estar no país correto para comprá-las ou gerenciá-las. \nA venda rende 70% do preço de compra. Não há tempo de espera na venda, é instantâneo. \nUma boate comprada abre uma tela separada de gerenciamento de boate; esse módulo trata do gerenciamento e da receita, não da visão geral das propriedades.';

  @override
  String get helpTopicPropertiesTips =>
      'Invista em um armazém com antecedência se precisar de mais espaço de armazenamento para seus outros sistemas. \nEscolha casas e apartamentos quando quiser construir mais capacidade habitacional para sistemas de jogo relacionados. \nNão venda muito rapidamente: 70% representa uma grande redução do preço de compra.';

  @override
  String get helpTopicBankCategory => 'Economia';

  @override
  String get helpTopicBankTitle => 'Banco';

  @override
  String get helpTopicBankSummary =>
      'Deposite dinheiro para manter o numerário fora do alcance dos confiscos policiais. Os juros bancários estão atualmente desativados.';

  @override
  String get helpTopicBankHow =>
      'Os juros bancários estão atualmente desativados (sem juros passivos por tick).\nDepósitos e levantamentos são grátis e instantâneos, sem mínimo nem máximo.\nDinheiro no banco está protegido contra confiscos policiais. Só o dinheiro em mão pode ser perdido numa prisão.\nO histórico de transações mostra todos os fluxos com carimbo de data/hora, montante, contraparte e descrição opcional.\nCrime Assalto ao banco: 30% de sucesso e rouba 10–30% do saldo bancário de outro jogador aleatório. Alto risco de Wanted Level.\nTransferências para outros jogadores são possíveis. Descrição opcional também visível para o destinatário. Confirme montante e destinatário antes de enviar.';

  @override
  String get helpTopicBankTips =>
      'Envie grandes montantes para o banco de imediato — o dinheiro em mão está em risco em cada tentativa de crime.\nUse o banco como armazenamento seguro contra confisco, não como quinta de juros (juros desativados).\nMantenha um pequeno capital de trabalho em dinheiro para despesas diretas (caução, viagem, ferramentas).';

  @override
  String get helpTopicCasinoCategory => 'Economia';

  @override
  String get helpTopicCasinoTitle => 'Cassino';

  @override
  String get helpTopicCasinoSummary =>
      'Jogue com dinheiro em caça-níqueis, blackjack, roleta, dados, bacará e vídeo pôquer. Alta variação: você pode ganhar ou perder grandes quantias rapidamente.';

  @override
  String get helpTopicCasinoHow =>
      'Jogos disponíveis: Slots (aposta baixa, pagamento aleatório), Blackjack (questões de estratégia), Roleta (apostas externas/internas com probabilidades próprias), Dados (alta variância), Bacará (jogador/banca/empate), Vídeo Poker (pagamentos de classificação de mão de 5 cartas). \nCada jogo tem uma aposta mínima. As taxas de pagamento diferem por tipo de jogo (por exemplo, aposta externa de roleta ~ 1,97x, número único 35x). \nO cassino usa apenas dinheiro, não seu saldo bancário. Certifique-se de ter dinheiro antes de jogar. \nNão há tempo de espera entre as rodadas: você pode jogar o mais rápido que quiser. \nGrandes vitórias acima de um limite podem desencadear um evento visível para outros jogadores. \nAs apostas perdidas desaparecem permanentemente; não há seguro ou recompra.';

  @override
  String get helpTopicCasinoTips =>
      'Sempre estabeleça um limite de banca para a sessão: nunca mais do que 10% do dinheiro total por sessão. \nO Blackjack tem as melhores probabilidades para um jogador habilidoso. Aprenda a estratégia básica antes de apostar alto. \nTrate o cassino como entretenimento, não como receita: a vantagem da casa garante perdas a longo prazo.';

  @override
  String get helpTopicBlackMarketCategory => 'Economia';

  @override
  String get helpTopicBlackMarketTitle => 'Mercado negro';

  @override
  String get helpTopicBlackMarketSummary =>
      'Um centro: primeiro mercadorias contrabandeadas (flores, eletrônicos, diamantes, armas, produtos farmacêuticos), depois a guia Mercado para veículos de jogador para jogador, ferramentas transportadas, lotes de drogas, lotes de criptomoedas, pilhas de mercadorias comerciais e itens de eventos transferíveis, além de mochilas, materiais, mercado de armas e munições.';

  @override
  String get helpTopicBlackMarketHow =>
      'Guia de mercadorias comerciais: uma rolagem contínua – primeiro as cinco linhas de contrabando (preços, limites, fichas de risco: deterioração, volatilidade, danos de viagem, apreensão) e, em seguida, seu estoque para vender. Compra/venda usa a API /trade; falhas de carga parcial mostram um banner de aviso. \nO mercado negro é dividido em submercados: Materiais (matérias-primas), Armas (armas de fogo e facas), Munições (munições por calibre), Veículos (veículos ilegais). \nOs preços e a disponibilidade variam muito de acordo com o país e o horário. Uma listagem pode esgotar rapidamente. \nAs transações no mercado negro não deixam rastros oficiais, mas aumentam o FBI Heat para grandes compras. \nAs armas compradas aqui podem ser usadas em crimes, PvP e segurança. Armas melhores proporcionam maiores danos e chances de sucesso. \nFiltros por categoria (tipo, país, preço, disponibilidade) ajudam você a encontrar rapidamente a listagem certa. \nVocê pode postar suas próprias listagens como vendedor, incluindo preço e quantidade. Outros jogadores compram de você. \nAs listagens expiram após um certo tempo se não forem vendidas. Monitore suas próprias ofertas através do seu perfil. \nGuia Marketplace: negociações em dinheiro peer-to-player. Um feed mostra veículos e listagens de jogadores para ferramentas transportadas, pilhas de drogas (gramas + qualidade), ativos criptográficos e estoque de mercadorias comerciais. Use Vender para escolher um tipo, definir quantidade e preço. Minhas listagens cobrem seus anúncios ativos. Você não pode comprar seu próprio anúncio. O compromisso remove o estoque até comprar ou excluir.';

  @override
  String get helpTopicBlackMarketTips =>
      'Guia Trade: puxe para atualizar se um segmento falhar; observe fichas de risco e Procurado antes de contrabando arriscado. \nCompre armas e munições a granel quando os preços estiverem baixos: a disponibilidade é temporária. \nEvite grandes compras no mercado negro quando o FBI Heat já estiver acima de 30. \nMarketplace: atualização após listagem; liste apenas o que você possui – as ferramentas devem ser transportadas, drogas/criptomoedas/mercadorias comerciais vêm de seu inventário/arquivos. Excluir restaura o depósito.';

  @override
  String get helpTopicDrugsCategory => 'Império';

  @override
  String get helpTopicDrugsTitle => 'Drogas';

  @override
  String get helpTopicDrugsSummary =>
      'Construa uma operação completa de medicamentos, desde a matéria-prima até o produto acabado. Administre cadeias de produção, gerencie o armazenamento e venda com margens elevadas, mas com sérios riscos.';

  @override
  String get helpTopicDrugsHow =>
      'O sistema de medicamentos consiste em: Hub (visão geral e estatísticas), Instalações (atualização da capacidade de produção), Produção (linhas de produção ativas com cronômetro) e Inventário (produtos acabados e matérias-primas). \nCompre matérias-primas através do mercado negro ou comércio. Combine-os em uma instalação para produzir drogas. \nOs cronômetros de produção são executados enquanto você está offline. Não é necessário clicar ativamente: verifique novamente quando o cronômetro terminar. \nA produção finalizada permanece visível na Produção e mantém o espaço da instalação ocupado até você coletá-la; A coleta automática VIP processa a saída automaticamente em segundo plano. \nA capacidade de armazenamento é limitada por instalação. Quando o armazenamento está cheio, a produção para automaticamente. \nUma loja darkweb ou outra instalação não vende automaticamente a produção final: a venda ainda acontece manualmente por meio do fluxo de venda pretendido. \nVenda drogas no mercado negro, na Colômbia ou em outros locais de vendas especiais pela margem mais alta. \nO FBI Heat aumenta a cada ciclo de produção e ainda mais em grandes vendas. O calor elevado leva a eventos de invasão que podem encerrar sua operação. \nAs atualizações das instalações reduzem o tempo de produção, aumentam a produção e expandem a capacidade de armazenamento. \nOs jogadores VIP recebem um botão relâmpago nas cartas de produção: após um modal de confirmação, você pode comprar todos os materiais do lote faltantes com um clique. \nAs atualizações avançadas de slots e equipamentos estão vinculadas ao novo curso de educação sobre Narcóticos (Especialista em Hidroponia, Especialista em Eletricidade de Processo, Químico Clandestino). Sem o nível/certificação exigido, você não poderá avançar para o próximo nível de atualização. \nAs drogas em inventário aumentam o risco de confisco durante viagens e verificações policiais.';

  @override
  String get helpTopicDrugsTips =>
      'Atualize o armazenamento antes da produção: o armazenamento completo interrompe a produção e você perde esse tempo de produção. \nMantenha o FBI Heat abaixo de 50: acima desse limite você é ativamente caçado com grandes chances de ataques que fecham tudo. \nCombine a venda de drogas com o contrabando para obter margens mais altas e risco distribuído.';

  @override
  String get helpTopicNightclubCategory => 'Império';

  @override
  String get helpTopicNightclubTitle => 'Boate';

  @override
  String get helpTopicNightclubSummary =>
      'Administre uma boate como parte de seu império criminoso. Gerencie equipe, segurança e suprimentos para obter renda passiva e ativa com um placar de temporada dedicado.';

  @override
  String get helpTopicNightclubHow =>
      'Na parte inferior você agora usa um Centro de Comando de Gerenciamento de Boate com zonas para Crew, Armazenamento de Drogas, Comando de DJ, Unidade de Segurança e Laboratório de Operações; todas as zonas são executadas em um fluxo de página contínuo sem rolagem interna extra. \nA tela da boate agora inclui uma seção central de Inteligência que combina visão geral, tendências de receita e registros de risco sem alternar entre guias. \nO Ops Lab agora inclui 11 sistemas: DJ residente, calendário de eventos dinâmico, árvore de atualização, resposta policial a incidentes/calor, contratos de fornecedores, perfis de promotores, clientela VIP + características da equipe, rotas de contrabando, gerenciamento de bar e cozinha (bebidas/comida) com preços, sabotagem rival + contra-inteligência e um cronograma de operações. \nAs rotas de contrabando agora têm um tempo de espera de execução (Porto 60 min, Pista de pouso 90 min, Borderline 120 min), forçando o planejamento de risco/tempo em vez de spam infinito. \nA árvore de atualização é interativa: escolha explicitamente Sound Rig, VIP Lounge ou Surveillance e compre o próximo nível diretamente com custos de atualização visíveis. \nA receita é gerada por tick com base na qualidade do DJ, ocupação e disponibilidade de fornecimento. A falta de oferta reduz diretamente a renda. \nOs contratos de DJ terminam automaticamente no horário de término configurado; depois disso, você deve reservar novamente para novos reforços. \nIncidentes (brigas, roubos) podem ocorrer quando a segurança é insuficiente. Isso prejudica a pontuação e a receita do visitante. \nCada temporada tem uma tabela de classificação. Os jogadores com maior receita total em casas noturnas ganham recompensas da temporada. \nSinergia com medicamentos: a produção própria de medicamentos pode servir de abastecimento, aumentando as margens. \nO armazenamento de medicamentos é baseado em gramas: cada seleção mostra os gramas disponíveis antes de você transferir o estoque para o inventário da boate. \nAs ações rivais são baseadas em nomes: você pesquisa clubes rivais pelo nome do jogador antes de selecionar uma ação (não é necessário ID do jogador). \nSinergia com a prostituição: eventos em locais combinados proporcionam visitantes extras e receitas maiores. \nAs atualizações melhoram a capacidade, o armazenamento de suprimentos e o número máximo de DJs e guardas que você pode implantar.';

  @override
  String get helpTopicNightclubTips =>
      'Mantenha sempre os suprimentos estocados: um tick sem abastecimento pode desencadear uma queda de visitantes da qual é difícil se recuperar. \nContrate o melhor DJ que você puder pagar: a qualidade do DJ tem o maior impacto direto na receita por tick. \nVerifique a tabela de classificação da temporada diariamente e aumente a oferta e os DJs se quiser terminar entre os 10 primeiros.';

  @override
  String get helpTopicCryptoCategory => 'Economia';

  @override
  String get helpTopicCryptoTitle => 'Criptografia';

  @override
  String get helpTopicCryptoSummary =>
      'Negocie 30 criptomoedas reais. Compre e venda diretamente ou automatize por meio de ordens de limite, stop-loss e take-profit. Os preços agora seguem âncoras de mercado ao vivo com regimes e notícias extras no jogo, e o pop-up da moeda usa campos separados para negociações diretas e pedidos abertos.';

  @override
  String get helpTopicCryptoHow =>
      'A lista de criptografia mostra 30 moedas com preço atual, porcentagem de 24 horas e sua participação atual por moeda. A base de preços segue dados de mercado em tempo real, mas ainda é influenciada pelos regimes e notícias do jogo. \nClique em uma moeda para abrir o pop-up com: gráfico ao vivo (filtros de tempo 1h, 4h, 8h, 24h, 7d, 30d, Todos), histórico de compras, preço médio de compra e formulário de compra/venda. \nNegociação direta: insira a quantidade e clique em Comprar ou Vender. Ao vender você pode pressionar `ALL` para preencher instantaneamente toda a sua posição. A execução é imediata ao preço atual de mercado. \nOrdens abertas: Limite (compra/venda a um preço-alvo exato), Stop-loss (venda automática quando o preço cai para um limite), Take-profit (venda automática quando o preço sobe para um limite). Esta seção agora possui seu próprio campo de quantidade e seu próprio campo de preço-alvo. \nAs ordens abertas são executadas automaticamente pelo backend assim que o preço de mercado atinge a meta. Você não precisa estar on-line. \nOs regimes de mercado (Touro/Urso/Sideways) e eventos noticiosos influenciam os movimentos de preços. Você recebe notificações de regime via push quando ativado. \nTabela de classificação criptográfica semanal: o jogador com o maior ganho realizado naquela semana ganha uma recompensa em dinheiro. \nMissões diárias e semanais (por exemplo, 3 negociações lucrativas, diversificando em 5 moedas) oferecem recompensas extras na conclusão. \nA visão geral do portfólio mostra: valor total, valor investido, lucros/perdas não realizados e realizados.';

  @override
  String get helpTopicCryptoTips =>
      'Verifique seu histórico de compras antes de fazer um pedido de venda: o pop-up mostra seu preço médio de compra para que você não venda acidentalmente com prejuízo. \nUse ordens de stop-loss em todas as posições que você não está monitorando ativamente: elas protegem você automaticamente quando você está offline. \nFiltros de tempo de troca no gráfico: 1h e 4h mostram a tendência de curto prazo, 7d e 30d mostram o quadro geral.';

  @override
  String get helpTopicSmugglingCategory => 'Império';

  @override
  String get helpTopicSmugglingTitle => 'Contrabando';

  @override
  String get helpTopicSmugglingSummary =>
      'Mova mercadorias e veículos ilegais entre países. Escolha um canal comercial ou use seu próprio veículo ou aeronave para obter custos mais baixos e aumentar o risco de confisco.';

  @override
  String get helpTopicSmugglingHow =>
      'Escolha uma categoria, o item específico, o destino e depois decida entre um canal comercial ou seu próprio transporte. \nCarros, motocicletas, barcos e aeronaves próprias agora mostram cotação em tempo real com slots de carga, menor custo e redução de risco. \nUm barco pode transportar carros e motos; uma aeronave não pode transportar um barco e retornará um erro imediato. \nA chance de sucesso depende do canal selecionado ou do transporte de sua propriedade, do seu nível de procurado atual e do tamanho da remessa. \nEm caso de falha, você perde toda a remessa. Sem reembolso. Os custos de carga e transporte desapareceram. \nQuando você usa transporte próprio e a execução falha, o próprio ativo de transporte também pode ser confiscado. \nAs remessas ativas são rastreadas ao vivo em uma visão geral. Após a chegada a carga chega em um depósito pronto para coleta. \nA rede de Crew permanece disponível para remessas de Crew comercial, mas o transporte próprio é apenas pessoal.';

  @override
  String get helpTopicSmugglingTips =>
      'Nunca envie todo o seu estoque em uma única remessa: divida-o em várias cargas menores para limitar perdas catastróficas. \nReduza o nível de procurado e o calor do FBI ao mínimo antes de iniciar uma grande operação de contrabando. \nUse sua melhor aeronave ou barco para viagens caras: o custo mais baixo ajuda, mas os slots de carga e a chance de confisco ainda decidem o risco. \nSempre colete depósitos ativos o mais rápido possível: o conteúdo expirado do depósito é perdido permanentemente.';

  @override
  String get helpTopicToolsCategory => 'Gerenciamento';

  @override
  String get helpTopicToolsTitle => 'Ferramentas';

  @override
  String get helpTopicToolsSummary =>
      'Compre e gerencie ferramentas necessárias para crimes específicos. Boas ferramentas aumentam suas chances de sucesso, ferramentas usadas diminuem.';

  @override
  String get helpTopicToolsHow =>
      'A loja de ferramentas mostra todos os itens disponíveis com preço, classificação de condição e tipo de crime para o qual são necessários. \nCada categoria de crime tem ferramentas preferidas: o roubo requer pé-de-cabra ou picaretas, o roubo de carro requer um kit de ligação direta, o roubo requer uma arma de fogo. \nAs ferramentas têm uma classificação de condição (0-100%). Cada crime bem-sucedido ou fracassado reduz a condição em alguns por cento. \nAbaixo da condição de 20%, o bônus de chance de sucesso da ferramenta cai drasticamente. Abaixo de 5% a ferramenta quase não tem efeito. \nFerramentas reparadas na loja custam uma fração do preço de compra. A substituição às vezes é mais barata do que o reparo de ferramentas muito desgastadas. \nAs ferramentas ficam visíveis na guia do seu inventário. Você pode manter várias cópias do mesmo tipo como backup.';

  @override
  String get helpTopicToolsTips =>
      'Compre ferramentas a granel quando elas são baratas no mercado negro: você economiza em comparação com a loja. \nDefina um limite pessoal: sempre substitua as ferramentas quando a condição cair abaixo de 25% para manter estáveis ​​as chances de sucesso.';

  @override
  String get helpTopicCourtCategory => 'Risco';

  @override
  String get helpTopicCourtTitle => 'Tribunal';

  @override
  String get helpTopicCourtSummary =>
      'Durante a sentença, você pode entrar com recurso ou tentar subornar o juiz para ser libertado mais cedo.';

  @override
  String get helpTopicCourtHow =>
      'Quando preso, a tela do tribunal mostra sua condenação ativa com tempo restante, crime e perfil do juiz. \nUm recurso custa dinheiro com base na duração atual da sentença. Se concedida, sua sentença geralmente é reduzida em cerca de 20-40%. \nVocê pode recorrer apenas uma vez por condenação e um período de espera se aplica a novas tentativas rápidas. \nO suborno usa uma quantia selecionada pelo jogador. Esse valor é sempre descontado, mesmo quando a tentativa falha. \nUm valor de suborno maior aumenta as chances de sucesso. Em caso de sucesso, você é liberado imediatamente. \nSeu registro criminal mantém condenações anteriores com datas e detalhes do histórico judicial, mesmo quando você não está mais preso. \nO suborno de um juiz bem-sucedido remove apenas a condenação atual do seu registo criminal. \nSe quiser limpar todo o seu registro criminal, você deve fazê-lo fora do tribunal, por meio do crime Wipe Criminal Record, no final do jogo.';

  @override
  String get helpTopicCourtTips =>
      'Use apelos em sentenças longas primeiro: o tempo esperado economizado é maior nessas situações. \nUse suborno apenas com reserva de dinheiro suficiente, porque o pagamento é sempre deduzido.';

  @override
  String get helpTopicHitlistCategory => 'Risco';

  @override
  String get helpTopicHitlistTitle => 'Lista de sucessos';

  @override
  String get helpTopicHitlistSummary =>
      'Coloque uma recompensa por um inimigo ou aceite um contrato de ataque. Elimine seu alvo no mesmo país para receber o pagamento integral.';

  @override
  String get helpTopicHitlistHow =>
      'Através da lista de hits você adiciona um jogador definindo uma recompensa. A recompensa mínima é de € 5.000. O pagador perde esse dinheiro imediatamente. \nSe uma recompensa for colocada em você, você receberá imediatamente uma notificação push e uma mensagem na caixa de entrada do Hitlist Bureau. \nOs golpes ativos são visíveis para todos os jogadores. Quanto maior a recompensa, mais atenção o contrato atrai. \nAs investigações de detetives não retornam mais informações instantâneas: os relatórios chegam mais tarde por meio de uma mensagem do Detective Bureau (Rápido 1 hora € 1.000.000, Padrão 6 horas € 500.000, Lento 24 horas € 250.000). \nSe você for morto pela lista de alvos, receberá uma mensagem do Hitlist Bureau com um botão para iniciar uma investigação do assassino em 24 horas. \nSe você solicitar essa investigação logo após o assassinato, o relatório do detetive chegará mais rápido. Esperar mais significa um atraso maior no relatório. \nPara executar um golpe você deve estar no mesmo país que seu alvo. Você ataca através do perfil do jogador. \nO combate é calculado automaticamente com base em: armas, armaduras, estatísticas (força, reflexos), bônus da Crew e nível ativo. \nNa eliminação bem-sucedida, você recebe a recompensa completa. Se o ataque falhar, você perde HP e o alvo sobrevive. \nEm caso de sucesso, o alvo recebe uma reinicialização total do progresso da conta: os recursos e a progressão são redefinidos para o status inicial, enquanto o saldo bancário e a liderança da Crew são preservados. Você recebe uma parte do saque disponível além da recompensa. \nApós uma morte bem-sucedida, você receberá imediatamente uma mensagem na caixa de entrada do Hitlist Bureau com um detalhamento da recompensa e do saque (dinheiro + itens). \nAlvos com guarda-costas ativos ou proteção de segurança são mais difíceis de atingir. \nVocê pode remover seu próprio nome da lista de alvos pagando ao colocador ou comprando a recompensa você mesmo.';

  @override
  String get helpTopicHitlistTips =>
      'Verifique a lista de alvos diariamente: recompensas altas para jogadores fracos geram lucro rápido se você estiver no mesmo país. \nSó coloque uma recompensa em um jogador quando você tiver motivos para acreditar que ele está offline ou com pouco HP.';

  @override
  String get helpTopicSecurityCategory => 'Risco';

  @override
  String get helpTopicSecurityTitle => 'Segurança';

  @override
  String get helpTopicSecuritySummary =>
      'Proteja seu personagem e império com armaduras, guarda-costas e segurança de instalação. Melhor segurança significa menos danos sofridos durante os ataques.';

  @override
  String get helpTopicSecurityHow =>
      'Tipos de armadura em força ascendente: Armadura Leve → Armadura Pesada → Colete à Prova de Balas → Roupa Tática. \nVocê só pode usar 1 armadura por vez; se você comprar outro colete, ele substituirá imediatamente sua armadura atual. \nCada classe de armadura reduz o dano recebido por ataque em uma porcentagem fixa. Melhor armadura = mais sobrevivência em PvP e ataques. \nA armadura fica danificada após um ataque e perde eficácia. Quanto menor a condição, menos proteção sua armadura atual oferece. \nCom 100% de dano sua armadura é destruída e desaparece completamente; você precisa comprar um novo conjunto para recuperar a proteção. \nOs guarda-costas dão +10 de defesa cada, mas a cada 24 horas cobram um salário diário de € 10.000 por guarda-costas. \nSe você não puder pagar o salário diário de guarda-costas, todos eles vão embora e você perde a proteção imediatamente. \nA segurança da instalação (para boates, instalações de drogas, etc.) reduz a chance de ataques e incidentes naquele local específico. \nQuanto maior o seu nível de procurado, mais frequentemente você será atacado ou invadido. Uma melhor segurança compensa isso diretamente. \nOs membros da Crew podem dividir as funções de segurança para que vários locais sejam cobertos simultaneamente.';

  @override
  String get helpTopicSecurityTips =>
      'Sempre carregue pelo menos armadura leve quando o nível de procurado for 2 ou superior: a economia nas contas do hospital compensa rapidamente o preço de compra. \nVerifique o estado da sua armadura após cada ataque: um colete danificado fornece apenas parte da sua proteção original. \nMantenha apenas quantos guarda-costas você ainda puder pagar amanhã; equipes grandes tornam-se caras na manutenção diária rapidamente.';

  @override
  String get helpTopicHospitalCategory => 'Recuperação';

  @override
  String get helpTopicHospitalTitle => 'Hospital';

  @override
  String get helpTopicHospitalSummary =>
      'Recupere HP após brigas, crimes fracassados ​​ou ataques. O hospital oferece atendimento de emergência gratuito e tratamentos pagos para uma recuperação mais rápida.';

  @override
  String get helpTopicHospitalHow =>
      'Cair abaixo de 10 HP e você será automaticamente internado no Pronto Socorro (ER). Isso é gratuito, mas leva mais tempo. \nO tratamento pago custa 10.000€ por sessão e restaura +30 HP. Cooldown: 60 minutos entre tratamentos pagos. \nA UTI (Terapia Intensiva) é o tratamento mais pesado para danos críticos. Tempo de espera: 180 minutos. Os custos são mais elevados, mas a recuperação é mais completa. \nCom HP mais alto (50+) você ainda pode realizar ações, mas fica mais vulnerável a ataques. \nOs tratamentos hospitalares são bloqueados enquanto você está na prisão. Saia primeiro e depois procure tratamento. \nCertificado escolar em Medicina reduz custos hospitalares e acelera tempos de recuperação. \nMédicos da Crew ou habilidades médicas podem restaurar HP fora do hospital como recuperação de emergência.';

  @override
  String get helpTopicHospitalTips =>
      'Nunca se recupere no meio do caminho: espere o HP total antes de praticar PvP ou crimes de alto risco. \nTratamentos pagos por tempo próximo ao tempo de espera: inicie um tratamento logo antes de ficar off-line para voltar a ficar on-line com HP total.';

  @override
  String get helpTopicPrisonCategory => 'Recuperação';

  @override
  String get helpTopicPrisonTitle => 'Prisão';

  @override
  String get helpTopicPrisonSummary =>
      'Cumpra sua sentença de prisão, pague fiança ou tente escapar. Quanto maior o seu Nível de Procurado, mais longa e mais cara será a sua sentença.';

  @override
  String get helpTopicPrisonHow =>
      'Após a prisão, um cronômetro é iniciado com base no nível de procurado. Procurado Nível 1 = sentença curta (minutos), Procurado Nível 5+ = horas de prisão. \nA fiança aumenta com a sentença restante e nunca cai abaixo do Nível de Procurado × € 1.000. Portanto, sentenças mais longas custam mais para serem compradas imediatamente. \nFuga: você pode tentar fugir da prisão, mas a chance de sucesso é baixa. A falha estende sua sentença por um valor fixo. \nNa lista de prisão e sobreposição de prisão, você sempre pode pagar sua própria fiança e também tentar escapar enquanto ainda está preso. \nOs membros da Crew podem visitá-lo e fornecer pequenos benefícios (estatísticas, moral) enquanto você estiver preso. \nAo serem presos, seus amigos e membros da Crew agora recebem uma notificação push de que você foi pego e está aguardando ajuda. \nArmas e armaduras são confiscadas na prisão se você não tiver cobertura legal para elas. \nOpção judicial: recorrer ao tribunal para obter redução da pena através de um advogado (ver Tribunal). \nEnquanto os cronômetros de produção bloqueados (drogas, fábrica de munições) continuam funcionando. Seu império funciona sem você. \nVocê não pode visitar o hospital enquanto estiver trancado. A recuperação da HP espera até que você esteja livre.';

  @override
  String get helpTopicPrisonTips =>
      'Verifique a fiança imediatamente após a prisão: o botão deve permanecer visível enquanto você ainda estiver preso, mesmo que seu nível de procurado já tenha caído. \nInicie os cronômetros de produção logo antes de executar uma operação criminosa de alto risco: se você for pego, a produção continuará funcionando de qualquer maneira.';

  @override
  String get helpTopicVaultCategory => 'Eventos';

  @override
  String get helpTopicVaultTitle => 'Quebrar o cofre';

  @override
  String get helpTopicVaultSummary =>
      'Temporada mensal de cofres: insira um código de 4 dígitos e aposte créditos para ter a chance de ganhar grandes prêmios.';

  @override
  String get helpTopicVaultHow =>
      'Cada mês uma nova temporada começa no dia 1º e termina no último dia do mês. \nEscolha uma aposta (por exemplo, 1/3/5 créditos) e insira um código de 4 dígitos. \nVocê também pode inserir o código usando o teclado na tela (botões numéricos). \nCada tentativa custa créditos. Se você acertar, você ganha um prêmio. \nApostas mais altas significam prêmios maiores; às vezes, uma recompensa VIP pode cair. \nSe você já é VIP, uma recompensa VIP é convertida em créditos. \nVocê pode ver seus códigos errados para este mês. A lista é redefinida automaticamente com o novo mês.';

  @override
  String get helpTopicVaultTips =>
      'Escolha uma aposta que corresponda ao seu saldo de créditos: você pode tentar quantas vezes quiser, mas cada tentativa custa créditos. \nUse a lista de códigos errados para evitar tentar novamente o mesmo código.';

  @override
  String get helpTopicGarageCategory => 'Ativas';

  @override
  String get helpTopicGarageTitle => 'Garagem';

  @override
  String get helpTopicGarageSummary =>
      'Roube e gerencie carros e motos para crimes e contrabando. A garagem cuida da propriedade, reparos cronometrados, venda e desmantelamento; o transporte passa pelo Centro de Contrabando.';

  @override
  String get helpTopicGarageHow =>
      'Sua garagem mostra carros e motocicletas com condições (0-100%), combustível, valor de mercado, raridade e status mundial. \nO armazenamento de carros e o armazenamento de motocicletas agora estão separados: os carros utilizam a capacidade da garagem, as motocicletas utilizam a capacidade de armazenamento das motocicletas. \nAs atualizações de armazenamento de carros e motocicletas são independentes por país: a atualização de carros não aumenta a capacidade das motocicletas (e vice-versa). As atualizações são controladas por classificação; quando sua classificação é muito baixa, você vê um cadeado/dica. No nível 5, o botão de atualização está oculto. \nUsando o botão de catálogo, você pode ver todos os carros e motocicletas que podem ser roubados, incluindo o país mais comum e a lista completa de países de spawn. \nO roubo é por veículo com requisitos de classificação e tempos de espera. Quanto mais caro e raro, menor será sua chance de sucesso. \nSe o limite mundial de um modelo estiver cheio, você não poderá roubar esse modelo temporariamente. Quando uma cópia é vendida ou descartada, 1 vaga é reaberta imediatamente. \nO roubo fracassado aumenta o nível de procurado e pode desencadear a prisão. Se a polícia o pegar durante a fuga, você será preso e o veículo recém-roubado será confiscado imediatamente. \nOs reparos são cronometrados: você paga adiantado, o veículo entra em reparo e só retorna após o término do cronômetro. \nOs reparos simultâneos são limitados a carros, motos e barcos: sem VIP max 1 ativo, com VIP max 2 ativo. \nO desmantelamento é uma alternativa à venda: você recebe valor residual (35% do valor base), escalonado por condição e bônus de atualização de garagem. \nVehicle Ops Intelligence adiciona 6 opções extras. Resumindo: \n1) Execução do Hotspot: uma ação rápida para obter dinheiro direto, com seu próprio tempo de espera e risco adicional. \n2) Mercado de peças: preços de peças vivas por tipo (carro/moto/barco) para tuning; os preços são atualizados periodicamente. \n3) Operação de Crew: uma ação cooperativa com sua Crew para ganhos/vantagens extras (somente se você estiver em uma Crew). \n4) Calor: por tipo (carro/moto/barco) um medidor de “atenção”; o calor mais alto torna as ações mais arriscadas e diminui as chances de sucesso. O calor decai lentamente. \n5) Chop Contract: entregue um veículo elegível do seu inventário por um pagamento fixo do contrato. \n6) Padrão policial: padrões horários podem aumentar as verificações; isso afeta o risco (por exemplo, greve/bloqueio no porto para barcos). \nEm Vehicle Heist, Carro/Motocicleta/Barco agora usam uma camada de comando: selecione a categoria através das três cartas de pista na parte superior, sem uma segunda linha de aba extra. \nCada carta de pista inclui ações rápidas diretas para roubo e atualizações de armazenamento, então você não precisa rolar para separar os subbotões primeiro. \nEnquanto um tempo de espera de roubo está em execução, um ícone de relâmpago aparece próximo ao cronômetro: toque nele para gastar créditos e limpar o tempo de espera. Você pode desligar a caixa de diálogo de confirmação; ative-o novamente em Configurações em tempo de espera para roubo (créditos). \nAs cartas de pista agora também mostram a capacidade por tipo diretamente (usado/total + nível de atualização). \nVeículos roubados agora são renderizados como cartões responsivos: dispositivos móveis mostram um por linha, tablets/desktop mostram vários cartões lado a lado. \nNova camada de operações: janelas de interceptação PvP para pontos de acesso, bônus de função de Crew em operações de Crew, desbloqueio de reputação por tipo de veículo, eventos regionais de lista negra e contratos de seguro de contrabando. \nNovas expansões de operações de veículos: missões de contra-interceptação, combinação de Crew com escada sazonal, modificadores de país (inflação/corrupção/greve no porto) e um quadro de contratos com contratos lendários semanais. \nOperações agora mostra tempos de espera ao vivo por ação. Os temporizadores fazem contagem regressiva visível e são atualizados automaticamente. \nAs ações da Crew (Crew Op e Crew Match) só estão disponíveis quando você está em uma equipe; sem uma Crew, você obtém uma dica clara de desbloqueio. \nAções operacionais bem-sucedidas pagam dinheiro diretamente em sua carteira. A visão geral da ação mostra o tipo de pagamento esperado por botão. \nOs sinistros de seguros agora são analisados ​​primeiro; usar a disputa de reivindicação permite que você conteste um pagamento extra com risco de rejeição. \nO calor de categoria superior reduz as chances de sucesso de roubo e aumenta o risco de hotspot. O calor diminui gradualmente a cada hora. \nOs Contratos Chop-Shop exigem um veículo elegível do seu inventário; alegar que consome aquele veículo e paga o dinheiro do contrato. \nO transporte de veículos não acontece mais na Garagem; use o fluxo do Centro de Contrabando. \nA revenda e o desmantelamento liberam a capacidade de carros ou motocicletas e podem reabrir vagas de capitalização mundial para esse modelo. \nVeículos exclusivos para eventos, como interceptadores policiais, ficam trancados fora das janelas do evento.';

  @override
  String get helpTopicGarageTips =>
      'Roube veículos ativamente quando o Nível de Procurado estiver baixo: Procurado mais alto = maior chance de falha ao roubar. \nMantenha sempre pelo menos um veículo confiável em boas condições para o contrabando: um veículo quebrado reduz pela metade suas chances de sucesso. \nUse o desmantelamento de veículos muito danificados como uma redefinição rápida de capacidade; vender geralmente é melhor em condições elevadas.';

  @override
  String get helpTopicMarinaCategory => 'Ativas';

  @override
  String get helpTopicMarinaTitle => 'Marina';

  @override
  String get helpTopicMarinaSummary =>
      'Gerencie barcos com raridade, limites mundiais e cronômetros de reparo para rotas de contrabando marítimo. Marina concentra-se em propriedade, manutenção, venda e sucateamento; o transporte passa pelo Centro de Contrabando.';

  @override
  String get helpTopicMarinaHow =>
      'A marina mostra seus barcos com condição, combustível, valor de mercado, raridade e status mundial por modelo. \nUsando o botão de catálogo você pode ver todos os barcos que podem ser roubados, incluindo os países mais comuns e a lista completa de países de spawn. \nO roubo de barco tem seus próprios portões e tempos de espera. Barcos mais caros são mais difíceis de roubar, mas podem ser mais lucrativos. \nSe o limite mundial de um modelo de barco estiver cheio, ele desaparece temporariamente da lista disponível. Venda/sucateamento reabre vagas. \nOs reparos são cronometrados: você paga adiantado e o barco fica indisponível até que o cronômetro termine. \nOs reparos simultâneos são limitados a carros, motos e barcos: sem VIP max 1 ativo, com VIP max 2 ativo. \nO desmantelamento concede valor residual (35% do valor base), escalonado com condição e bônus de atualização da marina. \nMarina gerencia apenas propriedade e manutenção; a rota de transporte real acontece no Smuggling Hub. \nOs barcos da polícia exclusivos para eventos são para eventos temporários e permanecem trancados fora das janelas do evento.';

  @override
  String get helpTopicMarinaTips =>
      'Invista na marina se as suas rotas de contrabando passam regularmente pela água: o menor interesse da polícia pode aumentar significativamente as hipóteses de sucesso. \nMantenha uma lancha em condições elevadas como uma alternativa rápida quando as rotas de fuga terrestres estiverem bloqueadas. \nDescarte barcos fortemente danificados com baixo valor de revenda para liberar espaço de capital mundial e capacidade da marina com mais rapidez.';

  @override
  String get helpTopicTuneshopCategory => 'Ativas';

  @override
  String get helpTopicTuneshopTitle => 'Loja de músicas';

  @override
  String get helpTopicTuneshopSummary =>
      'Use peças recuperadas para atualizar veículos por categoria. Melhore a velocidade, a furtividade e a armadura com custos de nível crescentes e tempos de recarga de categoria.';

  @override
  String get helpTopicTuneshopHow =>
      'Você ganha peças desmantelando veículos: peças de automóveis, peças de motocicletas e peças de barcos. \nAs peças são agrupadas por categoria: qualquer veículo da mesma categoria utiliza o mesmo estoque de peças. \nCada atualização custa peças e dinheiro. Os custos monetários são baseados em categorias e aumentam por nível de ajuste. \nVocê pode atualizar três estatísticas: velocidade, furtividade e armadura. \nO ajuste é feito por veículo em seu inventário. Novos veículos começam no nível 0 novamente. \nApós cada música, há um tempo de espera por veículo: carro 180s, motocicleta 120s, barco 240s. \nO ajuste simultâneo é limitado: sem VIP no máximo 1 veículo ativo no tempo de espera do ajuste, com VIP no máximo 5. \nVeículos ajustados geram maior valor de venda e salvamento. \nO ajuste é bloqueado enquanto um veículo está em reparo ou transporte.';

  @override
  String get helpTopicTuneshopTips =>
      'Descarte primeiro os veículos fortemente danificados para construir as peças rapidamente. \nInvista cedo em stealth para reduzir o risco de captura em execuções de alto risco. \nUse atualizações de armadura em veículos que você posiciona repetidamente em circuitos perigosos.';

  @override
  String get helpTopicShootingRangeCategory => 'Treinamento';

  @override
  String get helpTopicShootingRangeTitle => 'Campo de tiro';

  @override
  String get helpTopicShootingRangeSummary =>
      'Melhore sua precisão e habilidade com armas por meio de exercícios de tiro estruturados. Estatísticas mais altas aumentam o dano e a chance de acerto em PvP e crimes.';

  @override
  String get helpTopicShootingRangeHow =>
      'O campo de tiro oferece múltiplas disciplinas: pistola, rifle, espingarda e tiro automático. Cada um treina uma habilidade de arma separada. \nCada sessão de treinamento tem um tempo de espera de 30 minutos. Você não pode treinar indefinidamente por dia. \nMaior precisão aumenta sua chance de acerto em lutas PvP e diminui a chance de você mesmo ser atingido. \nA habilidade com a arma também determina quais armas você pode usar de forma eficaz: um rifle de precisão requer uma certa habilidade antes de você obter o bônus total. \nOs resultados do treinamento se acumulam cumulativamente. Não há reinicialização, a menos que você receba uma penalidade pesada no tribunal. \nCertificado escolar O Treinamento Militar dá um bônus permanente a cada sessão de tiro.';

  @override
  String get helpTopicShootingRangeTips =>
      'Treine o campo de tiro todos os dias: pequenos bônus cumulativos tornam-se visíveis nos resultados do PvP dentro de uma semana. \nTreine o tipo de arma que você mais usa em crimes e PvP para obter o máximo retorno do investimento.';

  @override
  String get helpTopicGymCategory => 'Treinamento';

  @override
  String get helpTopicGymTitle => 'Academia';

  @override
  String get helpTopicGymSummary =>
      'Treine força, velocidade e resistência para obter melhores estatísticas em PvP, crimes e pool de HP. O treinamento diário é a chave para o rápido crescimento das estatísticas.';

  @override
  String get helpTopicGymHow =>
      'A academia oferece três categorias de treinamento: Força (mais dano por ataque), Velocidade (maiores reflexos, menos golpes sofridos), Vigor (maior HP máximo). \nCada treinamento tem um cooldown de 1 hora. Máximo de 6 a 8 sessões por dia, dependendo do seu certificado escolar. \nA Força aumenta o dano direto tanto no PvP quanto em certos tipos de crimes (roubo, briga). \nA velocidade aumenta a chance de se esquivar de um ataque e diminui a chance de ser pego em caso de falha no crime. \nA resistência aumenta seu conjunto máximo de HP. Mais HP = sobreviver mais tempo no PvP e mais espaço para crimes de risco. \nCertificado escolar de Treinamento Físico dá bônus de +15% em todas as sessões de ginástica.';

  @override
  String get helpTopicGymTips =>
      'Priorize o treinamento de resistência: um conjunto de HP mais alto melhora todos os seus outros sistemas porque você permanece ativo por mais tempo. \nCombine academia com campo de tiro: Força + Precisão é a combinação PvP mais forte.';

  @override
  String get helpTopicAmmoFactoryCategory => 'Império';

  @override
  String get helpTopicAmmoFactoryTitle => 'Fábrica de munição';

  @override
  String get helpTopicAmmoFactorySummary =>
      'Produza munição para uso pessoal e gerencie sua produção na fábrica. A compra e venda de munição ocorre através do Mercado Negro, e não diretamente da tela da fábrica.';

  @override
  String get helpTopicAmmoFactoryHow =>
      'A fábrica de munição possui níveis de produção (Nível 1 a 5). Nível mais alto = mais rodadas por reclamação e melhor qualidade. \nDurante uma sessão ativa, você reivindica produção a cada 20 minutos (até 8 horas de backlog nessa sessão). \nA produção continua aumentando enquanto você está off-line: quando você retornar, poderá reivindicar várias vezes até que o backlog seja recuperado. \nSimplesmente ver a fábrica de munição ou viajar de ida e volta não deve mudar de propriedade; uma fábrica não deve mudar para “à venda” só porque a tela foi aberta. \nA munição produzida é usada pessoalmente em crimes e PvP. Para comprar e vender munição, passe pelo Mercado Negro; a própria tela de fábrica não vende balas diretamente. \nAs atualizações de produção aumentam as rodadas por reivindicação; atualizações de qualidade melhoram o valor de mercado. \nO preço de mercado da munição flutua com a demanda. Estocar quando os preços estiverem baixos e vender quando os preços estiverem altos. \nDurante uma invasão à fábrica, você perde parte da produção armazenada. A segurança reduz esse risco.';

  @override
  String get helpTopicAmmoFactoryTips =>
      'Atualize sua fábrica para o nível 3 o mais rápido possível: a produção duplicada em comparação com o nível 1 a torna autossuficiente em munição. \nSempre mantenha 2-3 rodadas de produção em reserva como buffer para que você nunca fique sem munição durante o PvP.';

  @override
  String get helpTopicSchoolCategory => 'Treinamento';

  @override
  String get helpTopicSchoolTitle => 'Escola';

  @override
  String get helpTopicSchoolSummary =>
      'Siga cursos em diversas trilhas para desbloquear bônus, reduzir custos e abrir novos sistemas. A escola é um multiplicador de tudo que você faz.';

  @override
  String get helpTopicSchoolHow =>
      'A escola oferece faixas por domínio: Criminal (melhores estatísticas de criminalidade), Economia (menores custos comerciais e bancários), Militar (bônus de combate), Medicina (menores custos hospitalares), Direito (menores custos com advogados), Técnico (melhores fábricas e produção de medicamentos). \nCada lição tem um tempo de estudo de 15 a 60 minutos dependendo do nível. Níveis mais altos demoram mais. \nDepois de concluir uma lição, você recebe um certificado para esse nível de curso. Este certificado é permanente e concede o bônus imediatamente. \nVocê só pode acompanhar uma lição por vez. Planeje seus estudos com cuidado quando precisar urgentemente de um certificado específico. \nOs custos escolares aumentam por nível. O ensino superior exige a conclusão de níveis anteriores do mesmo curso. \nAlguns recursos avançados do jogo estão bloqueados por um certificado escolar: por ex. acesso a determinados empregos, níveis mais altos de fábrica, eventos em boates VIP e níveis mais altos de atualização de instalações de drogas. \nOs certificados nunca são redefinidos, a menos que sua conta receba uma penalidade pesada.';

  @override
  String get helpTopicSchoolTips =>
      'Sempre comece com a trilha Criminal: os bônus nas chances de sucesso no crime reembolsam os custos do estudo em poucas sessões. \nAgende estudos longos (60 min+) antes de dormir: você acorda com um novo certificado sem perder tempo ativo.';

  @override
  String get helpTopicTerritoryCategory => 'Império';

  @override
  String get helpTopicTerritoryTitle => 'Território';

  @override
  String get helpTopicTerritorySummary =>
      'Reivindique e controle regiões geográficas para obter renda passiva, prestígio da Crew e bônus regionais estratégicos. Território combina controle de mapa com concursos e recompensas sazonais.';

  @override
  String get helpTopicTerritoryHow =>
      'A visão geral do território mostra todos os países e regiões disponíveis por país. Clique em um país para ver o mapa interativo. \nTodos os países apoiados são agora totalmente navegáveis ​​através do mesmo fluxo de mapas interactivos que os Países Baixos. \nToque em uma região no mapa interativo para abrir um modal com informações sobre o território e o botão de ataque. As cartas de região separadas abaixo do mapa não são mais necessárias. \nA visualização é permitida em qualquer lugar, mas ataques, defesas e ações de contestação só funcionam no país onde seu personagem está atualmente localizado. \nNo celular agora você pode aproximar e afastar dois dedos e arrastar o mapa ampliado diretamente, facilitando o toque em regiões menores sem botões extras no mapa. \nO território é baseado em Crew: você deve criar ou ingressar em uma Crew antes que o botão de ataque fique disponível para regiões neutras ou hostis. \nCada região pode ser controlada por no máximo uma Crew por vez. A propriedade concede renda passiva por hora, mas o Território para de pagar ao banco da Crew assim que o limite de armazenamento de dinheiro for atingido. \nInicie um concurso em uma região não reivindicada usando o botão do concurso. O concurso progride automaticamente através de preparação (tempo de preparação), ativo (ações) e bloqueio (resolução). \nDurante uma competição ativa, o modal de região agora também mostra quando as ações são desbloqueadas, quando a competição termina, qual é o tempo de espera por ação e o valor real em dinheiro que a região paga por pagamento, por hora e por dia. \nAs regiões agora também têm papéis estratégicos, como porto, indústria, capital, região fronteiriça ou centro logístico. Essa função determina quais ações podem ganhar pontos extras. \nAs regiões adjacentes que já pertencem à sua Crew agora fornecem suporte extra durante as ações do concurso. O modal de região mostra quais bônus estratégicos estão ativos e quanto apoio adjacente sua Crew tem naquela área. \nOs bônus de ação agora também podem vir da progressão da Crew: nível de QG, nível de missão da Crew e edifícios secundários relevantes (armas/munições/carros/barcos/armazenamento de drogas). Esses bônus apenas aumentam os pontos do concurso, e não o dinheiro passivo da região. \nAlgumas ações de concurso avançadas são controladas pelo QG: se o nível do seu QG for muito baixo, o botão de ação mostra “requer nível de QG X” imediatamente. \nO território não usa mais um limite máximo de ação diária por padrão (limite de tempo de execução 0 = desativado). O equilíbrio permanece controlado através de cooldowns, anti-farm e escolhas de ação estratégica. \nVencer uma Guerra Territorial ou uma Guerra Total agora pode deixar uma pressão de guerra temporária nas regiões reais do Território ao redor dessa linha de frente. O modal da região mostra qual Crew mantém a pressão, o quanto a estabilidade efetiva é reduzida e quando o rescaldo expira. \nQuando um concurso acabou de começar ou um concurso mais antigo ainda não tinha campos de tempo, a tela agora preenche esses cronômetros imediatamente e atualiza o modal para o estado do concurso mais recente, sem exigir que você saia primeiro. \nOs atacantes só veem as ações do atacante (inteligência, sabotagem, ataque) e os defensores só veem as ações dos defensores (patrulha, corrida de suprimentos, defesa), então o modal não mostra mais botões mistos confusos. \nUma região agora também mostra o rendimento real do Território. Os líderes da Crew também veem quantas regiões e países sua Crew controla no painel, quanto a Crew está ganhando atualmente e quanto o Território ganhou no total até agora. \nOs concursos resultam em transferência de propriedade e recompensas (dinheiro, XP, prestígio). Os perdedores também recebem XP parcial pela participação. \nGrandes regiões (portos, capitais) proporcionam mais renda passiva, mas também desencadeiam mais oponentes e tentativas de ataque. \nOs eventos sazonais oferecem recompensas bônus e desafios especiais por grupo de região. \nEvite impasses: sua Crew não pode atacar imediatamente o mesmo oponente após uma derrota; espere o resfriamento. \nAs verificações antiabuso evitam que uma Crew ataque o mesmo alvo repetidamente em curtos intervalos de tempo.';

  @override
  String get helpTopicTerritoryTips =>
      'Comece num país equilibrado com regiões de dimensão média: menos concorrência do que os países grandes, mas um rendimento passivo razoável. \nConcentre-se primeiro em um país onde sua equipe é forte: melhor conhecimento leva a uma melhor estratégia de competição do que um controle superficial em muitos países. \nUse as temporadas como reinicializações estratégicas: se você perder em uma estação seca, sempre haverá uma temporada melhor para a recuperação.';

  @override
  String get helpTopicProstitutionCategory => 'Império';

  @override
  String get helpTopicProstitutionTitle => 'Prostituição';

  @override
  String get helpTopicProstitutionSummary =>
      'Construa uma rede de prostituição com recrutas, eventos e clientes VIP. Uma rede bem gerida gera rendimentos passivos, mas requer uma gestão activa para controlar a rivalidade e a atenção da polícia.';

  @override
  String get helpTopicProstitutionHow =>
      'Você gerencia recrutas, cada um com suas próprias estatísticas (experiência, popularidade, disponibilidade). Mais recrutas = maior renda passiva. \nOs turnos de trabalho duram 8 horas por recruta: após um turno, esse recruta precisa de um tempo de descanso antes de poder começar novamente. \nO gerenciamento de localização é flexível: você pode mover os recrutas entre a rua, o Red Light District e a boate usando os botões de ação em cada cartão. \nOs eventos são impulsionadores temporários: shows especiais, noites VIP e festas aumentam a receita por tick durante o evento. \nRivalidade: outros jogadores ou competidores NPC podem roubar seus recrutas ou sabotar eventos. Maior segurança reduz esse risco. \nOs clientes VIP pagam consideravelmente mais, mas exigem recrutas com alta popularidade (80+) e uma localização segura. \nA atenção da polícia (calor) aumenta com grandes transações e batidas. O calor elevado leva ao confisco de rendimentos ou ao encerramento temporário. \nCombinação com discoteca: uma discoteca oferece cobertura legal para atividades que provocam um aumento mais lento do calor. \nUse o painel de informações de ganhos na parte superior para comparar rapidamente a produção por hora de rua, RLD e boate. \nTabela de classificação: o maior faturamento semanal total ganha uma recompensa semanal em dinheiro e um distintivo.';

  @override
  String get helpTopicProstitutionTips =>
      'Invista cedo em segurança: um ataque de rivalidade que persiga o seu melhor recruta custa mais do que o investimento em segurança. \nOrganize eventos VIP apenas quando os recrutas estiverem acima de 80 de popularidade: abaixo desse limite, os clientes VIP simplesmente pagam a taxa padrão.';

  @override
  String get helpTopicRedLightDistrictsCategory => 'Império';

  @override
  String get helpTopicRedLightDistrictsTitle => 'Distritos da Luz Vermelha';

  @override
  String get helpTopicRedLightDistrictsSummary =>
      'Reivindique e gerencie distritos territoriais por país. Possuir um distrito proporciona renda passiva e controle sobre as atividades de prostituição naquela região.';

  @override
  String get helpTopicRedLightDistrictsHow =>
      'Cada país tem um ou mais Distritos da Luz Vermelha que podem ser reivindicados. Reivindique um distrito pagando um valor de compra definido. \nComo proprietário de um distrito, você recebe uma porcentagem de toda a renda da prostituição naquele país – inclusive de outros jogadores que operam lá. \nOutros jogadores podem atacar o seu distrito para assumir a propriedade. Maior segurança diminui a chance de ataque. \nAs atualizações distritais (segurança, marketing, infraestrutura) aumentam a porcentagem de sua renda e reduzem a chance de perder a propriedade. \nVocê pode possuir até 3 distritos simultaneamente. A escolha estratégica do país é essencial. \nOs países mais movimentados (Colômbia, Dubai, Japão) proporcionam o rendimento passivo mais elevado, mas são também os mais contestados. \nPerder um distrito não reembolsa o preço de compra: ele será perdido permanentemente se um inimigo o reivindicar com sucesso.';

  @override
  String get helpTopicRedLightDistrictsTips =>
      'Comece com um país menos popular para o seu primeiro distrito: menor pressão de ataque lhe dá tempo para atualizar a segurança antes da competição real. \nAtualize a segurança de cada distrito imediatamente após a compra: as primeiras 24 horas são as mais vulneráveis ​​a uma aquisição.';

  @override
  String get helpTopicAchievementsCategory => 'meta';

  @override
  String get helpTopicAchievementsTitle => 'Conquistas';

  @override
  String get helpTopicAchievementsSummary =>
      'Ganhe distintivos ao atingir marcos em todos os sistemas de jogo. As conquistas oferecem recompensas, aumentam seu perfil de status e mostram seu progresso por categoria.';

  @override
  String get helpTopicAchievementsHow =>
      'As conquistas são agrupadas em categorias: Crimes, Império, PvP, Economia, Treinamento, Social e Meta. \nCada conquista tem vários níveis (Bronze, Silver, Gold, Platinum). Cada nível oferece uma recompensa maior e um emblema mais impressionante. \nAs recompensas por conquista incluem: dinheiro, XP, itens especiais, bônus permanentes ou títulos exclusivos para o seu perfil. \nO progresso é rastreado automaticamente. Você não precisa ativar nada: alcance o limite e o selo será concedido imediatamente. \nAlgumas conquistas ficam ocultas até que você as conclua parcialmente – elas aparecem com seu nome real e requisitos. \nOs selos de conquista ficam visíveis em seu perfil público. Eles mostram a outros jogadores suas especializações e experiência. \nConquistas em cadeia: alguns emblemas estão ligados em uma corrente. O ouro requer que a prata já tenha sido obtida. Planeje com antecedência para níveis mais altos.';

  @override
  String get helpTopicAchievementsTips =>
      'Verifique diariamente suas conquistas quase concluídas: um pequeno esforço extra pode ganhar um distintivo e uma recompensa em dinheiro que, de outra forma, seria adiada por meses. \nConcentre-se desde o início nas categorias Economia e Crime: elas oferecem mais recompensas em dinheiro e são mais fáceis de combinar com o jogo normal.';

  @override
  String get helpTopicSupportTicketsCategory => 'Suporte';

  @override
  String get helpTopicSupportTicketsTitle => 'Relatórios e tickets';

  @override
  String get helpTopicSupportTicketsSummary =>
      'Relate bugs, dúvidas ou comentários por meio do sistema de tickets. O suporte e os administradores podem responder, gerenciar o acompanhamento interno e enviar atualizações por meio da própria conversa de suporte e de notificações push opcionais.';

  @override
  String get helpTopicSupportTicketsHow =>
      'Abra o item de menu separado `Suporte` para revisar seus tickets ou criar um novo. \nEscolha uma categoria (bug, pergunta, feedback ou outro), selecione o módulo relacionado, se necessário, e descreva seu problema da forma mais específica possível. \nOpcionalmente, você pode adicionar uma referência, como ID do pedido, nome de tela ou contexto curto, além de uma captura de tela, se isso ajudar. \nApós o envio, você recebe imediatamente um número de ticket e seu ticket aparece na visão geral do suporte, onde o suporte pode responder e criar tarefas internas. \nQuando as respostas do suporte ou o status do ticket mudam, você vê isso diretamente na mesma conversa de suporte e pode, opcionalmente, receber uma notificação push (se as notificações estiverem habilitadas). \nO item de menu Suporte mostra um selo assim que um ticket recebe uma nova resposta de suporte ou atualização de status desde sua última visita à visão geral do suporte. \nO suporte utiliza status como novo, triagem, em andamento, aguardando jogador, bloqueado e resolvido para rastrear seu relato internamente.';

  @override
  String get helpTopicSupportTicketsTips =>
      'Sempre inclua seu país, ação e mensagem de erro exata; isso acelera as correções para os desenvolvedores. \nUse um ticket por tipo de problema para que a lista de tarefas e o acompanhamento fiquem claros.';

  @override
  String get helpTopicSettingsCategory => 'Essencial';

  @override
  String get helpTopicSettingsTitle => 'Configurações';

  @override
  String get helpTopicSettingsSummary =>
      'Gerencie todas as configurações da conta: idioma, avatar, privacidade, preferências de notificação por sistema e opções de segurança. As configurações afetam diretamente sua experiência de jogo.';

  @override
  String get helpTopicSettingsHow =>
      'Idioma: alterne entre holandês e inglês. Todos os textos da interface do usuário, mensagens do sistema e notificações são atualizados imediatamente. \nAvatar: carregue ou selecione uma imagem de perfil visível para outros jogadores em seu perfil público e nas listas de Crew. \nPrivacidade: defina quem pode ver seu status online, localização (país atual) e estatísticas – somente você, sua equipe, amigos ou todos. \nNotificações push: alterne por sistema. Categorias: Crimes, Negociação de criptografia, Alertas de preços, Pedidos, eventos de jogadores ao vivo (competição), Regime de mercado, Assalto, Boate, mensagens gerais. \nSe o push já tiver sido permitido, a versão web/PWA se reconectará automaticamente ao token do dispositivo atual após uma atualização; você só precisa reativá-lo em Configurações quando o próprio navegador bloquear notificações. \nAs preferências de notificação criptográfica permanecem salvas após sair das Configurações e abri-las novamente mais tarde. \nNotificações no aplicativo: configuráveis ​​separadamente do push. O aplicativo mostra alertas dentro do aplicativo sem enviar uma notificação do sistema. \nSegurança: altere a senha, configure a autenticação de dois fatores e visualize as sessões ativas. \nPreferência de notificação por sistema: ajuste para não receber uma tempestade de notificações de sistemas que você não está jogando ativamente.';

  @override
  String get helpTopicSettingsTips =>
      'Habilite notificações push para pedidos criptográficos e eventos de assalto: esses são sistemas de tempo crítico onde a reação rápida é importante. \nDefina a privacidade como somente Crew para localização quando você estiver ativo na lista de alvos: caso contrário, outros jogadores poderão localizá-lo com exatidão.';

  @override
  String get helpTopicPremiumCategory => 'Essencial';

  @override
  String get helpTopicPremiumTitle => 'Prêmio e Créditos';

  @override
  String get helpTopicPremiumSummary =>
      'Compre e gerencie Player VIP, Crew VIP e pacotes de créditos aqui. Esta visão geral também mostra seu saldo de crédito e todos os itens de crédito disponíveis que você pode usar direta ou contextualmente.';

  @override
  String get helpTopicPremiumHow =>
      'Abra a página separada `Prêmio e Créditos` no menu lateral para visualizar seu status VIP, datas de validade, saldo de crédito e opções de compra. \nEm cada bloco de compra, toque/clique no ícone `i` no canto superior esquerdo para obter todos os detalhes e benefícios; o bloco em si mostra intencionalmente apenas informações básicas curtas e o botão de compra. \nO VIP do jogador é pessoal. Crew VIP aplica-se à sua Crew e só tem valor quando você já faz parte de uma Crew. \nO Jogador VIP oferece tempos limite de ação 10% mais curtos (o tempo de prisão permanece inalterado), 100 créditos semanais, um botão VIP de compra com um clique para materiais perdidos na Produção de Medicamentos (após confirmação de custo) e uma redefinição de morte mais suave: banco/cripto/educação/conquistas permanecem, enquanto ativos, inventário e estoque de drogas são removidos. \nA finalização da compra VIP abre a página de pagamento e depois retorna para a seção `Premium & Credits` do jogo, para que você veja imediatamente se a compra foi bem-sucedida e por quanto tempo seu VIP é válido. \nOs pacotes de crédito são comprados com dinheiro real. Após um pagamento bem-sucedido, os créditos aparecem imediatamente na visão geral da sua carteira. \nO Event Pass (7 dias, dinheiro real) está listado na grade de ofertas únicas: +10% de pontuação em eventos de jogadores ao vivo, além de um pequeno bônus de crédito após a compra. É um nível secundário: não um combate direto ou reforço de PvP; ajuda principalmente nos resultados da tabela de classificação durante eventos em execução. \nOs itens de crédito utilizam créditos de carteira em vez de euros. Pense em proteção contra golpes, redefinições de tempo de espera, aumentos de eventos ou pacotes de dinheiro, dependendo de qual administrador ativou atualmente. \nNas telas de tempo limite suportadas (como crimes, empregos, roubo de veículos/barcos e escola), você também recebe um botão de aceleração direto para recargas ativas, então você não precisa voltar primeiro para Premium e Créditos. \nAlguns itens de crédito funcionam diretamente nesta tela. Em vez disso, itens vinculados ao contexto, como certas ações do veículo, são usados ​​na tela correta do veículo ou da garagem (veículos danificados mostram um botão de reparo instantâneo diretamente no cartão). \nPara botões contextuais, como aceleração de reparo, o custo de crédito atual é mostrado diretamente no botão/dica. \nPreços e itens disponíveis são gerenciados ao vivo no administrador. Isso significa que os preços VIP, os custos de crédito e a oferta disponível podem mudar sem uma atualização do aplicativo.';

  @override
  String get helpTopicPremiumTips =>
      'Verifique seu saldo de crédito e prazo de validade antes de comprar novamente; estender geralmente é melhor do que empilhar às cegas. \nUse créditos principalmente em reforços ou proteção urgentes, não automaticamente em cada pequeno atalho. \nSe você ainda não faz parte de uma equipe, comece com Player VIP ou um pacote de créditos antes de Crew VIP.';

  @override
  String get landingHeroTitle => 'O Estado da Máfia';

  @override
  String get landingHeroSubtitle =>
      'Um jogo de estratégia criminal baseado em texto profundo no seu navegador. Construa seu império, administre equipes, negocie, lute por território – e suba na hierarquia.';

  @override
  String get landingAboutTitle => 'O que espera por você';

  @override
  String get landingAboutBody =>
      'Gerencie negócios, execute trabalhos e assaltos, desenvolva seu personagem por meio de certificados escolares, compita em eventos ao vivo e coordene-se com sua equipe no mapa mundial. Regras competitivas justas, progressão a longo prazo e atualizações regulares de conteúdo.';

  @override
  String get landingTopPlayersTitle => 'Melhores jogadores';

  @override
  String get landingTopCrewsTitle => 'Principais equipes (território)';

  @override
  String get landingRankLabel => 'Classificação';

  @override
  String get landingRegionsLabel => 'Regiões';

  @override
  String get landingLoadError =>
      'Não foi possível carregar as classificações no momento.';

  @override
  String get landingEmptyLeaderboard => 'Nenhuma entrada ainda.';

  @override
  String get landingCtaLogin => 'Conecte-se';

  @override
  String get landingCtaRegister => 'Criar uma conta';

  @override
  String get landingFooterPrivacy => 'política de Privacidade';

  @override
  String get landingFooterTerms => 'Termos de serviço';

  @override
  String get landingFooterDigitalGoods => 'Compra de bens digitais';

  @override
  String get landingFooterLanguage => 'Linguagem';

  @override
  String landingCopyright(int year) {
    return '© $year O Estado da Máfia. Todos os direitos reservados.';
  }

  @override
  String get legalPrivacyTitle => 'política de Privacidade';

  @override
  String get legalPrivacyLastUpdated => 'Última atualização: maio de 2026';

  @override
  String get legalPrivacyIntro =>
      'Esta Política de Privacidade explica como The Mob State (\"nós\", \"nos\") trata os dados pessoais quando você usa nosso site, jogos na web e serviços relacionados. Ao jogar ou navegar, você concorda com esta política onde a lei aplicável permitir.';

  @override
  String get legalPrivacySection01Title => 'Quem somos';

  @override
  String get legalPrivacySection01Body =>
      'The Mob State é um jogo online operado como um serviço digital. Para solicitações de privacidade, você pode entrar em contato conosco através do sistema de tickets de suporte do jogo após o registro ou através dos canais de contato do site oficial, se publicado.';

  @override
  String get legalPrivacySection02Title => 'Dados que coletamos';

  @override
  String get legalPrivacySection02Body =>
      'Podemos processar dados da conta (nome de usuário, e-mail, se fornecido, senha com hash), dados de jogo e progressão, registros técnicos (endereço IP, tipo de dispositivo/navegador, carimbos de data/hora), referências relacionadas a pagamentos de nossos provedores de pagamento (não armazenamos números completos de cartão) e comunicações que você envia ao suporte.';

  @override
  String get legalPrivacySection03Title => 'Finalidades';

  @override
  String get legalPrivacySection03Body =>
      'Usamos dados para fornecer o jogo, proteger contas, prevenir abusos e fraudes, processar compras, melhorar o desempenho, comunicar mensagens de serviço e cumprir obrigações legais.';

  @override
  String get legalPrivacySection04Title => 'Bases jurídicas (EEE/Reino Unido)';

  @override
  String get legalPrivacySection04Body =>
      'Quando o GDPR se aplica, contamos com a execução de um contrato (fornecimento do jogo), interesses legítimos (segurança, análise, melhoria do produto equilibrada com os seus direitos), consentimento quando necessário (por exemplo, determinados cookies de marketing ou comunicações opcionais) e obrigações legais.';

  @override
  String get legalPrivacySection05Title => 'Cookies e armazenamento local';

  @override
  String get legalPrivacySection05Body =>
      'Usamos cookies e tecnologias semelhantes para mantê-lo conectado, lembrar preferências, medir o uso básico e fornecer funcionalidades essenciais. Você pode controlar muitos cookies através das configurações do seu navegador.';

  @override
  String get legalPrivacySection06Title => 'Retenção';

  @override
  String get legalPrivacySection06Body =>
      'Retemos informações pelo tempo necessário para operar o serviço e atender aos requisitos legais, fiscais e contábeis. Alguns registros podem ser mantidos por um período de segurança limitado. Quando os dados não são mais necessários, nós os excluímos ou anonimizamos sempre que possível.';

  @override
  String get legalPrivacySection07Title => 'Compartilhamento';

  @override
  String get legalPrivacySection07Body =>
      'Compartilhamos dados com infraestrutura e processadores de pagamento estritamente conforme necessário para executar o serviço, sob acordos apropriados. Não vendemos os seus dados pessoais. Poderemos divulgar informações se exigido por lei ou para proteger direitos e segurança.';

  @override
  String get legalPrivacySection08Title => 'Transferências internacionais';

  @override
  String get legalPrivacySection08Body =>
      'Os seus dados podem ser processados ​​no Espaço Económico Europeu e/ou outras regiões onde nós ou os nossos fornecedores operamos. Utilizamos salvaguardas, como cláusulas contratuais padrão, quando necessário.';

  @override
  String get legalPrivacySection09Title => 'Seus direitos';

  @override
  String get legalPrivacySection09Body =>
      'Dependendo da sua localização, poderá ter direitos de acesso, retificação, apagamento, restrição ou oposição a determinados tratamentos e à portabilidade de dados. Você pode apresentar uma reclamação a uma autoridade supervisora. Contate-nos via suporte para exercício de direitos; podemos precisar verificar sua identidade.';

  @override
  String get legalPrivacySection10Title => 'Crianças';

  @override
  String get legalPrivacySection10Body =>
      'O jogo não é direcionado a crianças menores de idade onde o consentimento dos pais é necessário para o processamento em sua região. Se você acredita que uma criança forneceu dados indevidamente, entre em contato conosco e tomaremos as medidas adequadas.';

  @override
  String get legalDigitalGoodsTitle => 'Compra de bens digitais';

  @override
  String get legalDigitalGoodsLastUpdated => 'Última atualização: maio de 2026';

  @override
  String get legalDigitalGoodsIntro =>
      'Esta política descreve compras de conteúdo e serviços digitais no The Mob State (por exemplo, créditos premium, tempo VIP ou outros itens virtuais). Ao concluir uma compra, você concorda com estes termos, juntamente com quaisquer termos de finalização da compra mostrados no momento do pagamento.';

  @override
  String get legalDigitalGoodsSection01Title => 'Natureza das compras digitais';

  @override
  String get legalDigitalGoodsSection01Body =>
      'Todas as compras são pagamentos para acesso a recursos online adicionais e itens virtuais dentro do The Mob State. Eles são entregues digitalmente no jogo e não possuem forma física.';

  @override
  String get legalDigitalGoodsSection02Title =>
      'Entrega e retirada imediata (Reino Unido/UE)';

  @override
  String get legalDigitalGoodsSection02Body =>
      'Quando se aplicarem os Regulamentos de Contratos do Consumidor de 2013 (Reino Unido) ou regras equivalentes da UE, você reconhece que o conteúdo digital é fornecido imediatamente após a compra e, quando a lei permitir, você poderá perder o direito legal de rescisão de 14 dias após o início da entrega com seu consentimento prévio e expresso.';

  @override
  String get legalDigitalGoodsSection03Title => 'Reembolsos e estornos';

  @override
  String get legalDigitalGoodsSection03Body =>
      'Os bens digitais geralmente não são reembolsáveis ​​depois de entregues, exceto quando a legislação do consumidor exigir o contrário. Estornos ou disputas de pagamento após a entrega podem levar à suspensão ou encerramento de contas relacionadas; entre em contato com o suporte primeiro para que possamos ajudar a resolver problemas de faturamento.';

  @override
  String get legalDigitalGoodsSection04Title => 'Permissão e idade';

  @override
  String get legalDigitalGoodsSection04Body =>
      'Você deve estar autorizado a usar o método de pagamento escolhido. Se você tiver menos de 18 anos, precisará da permissão dos pais ou responsável para fazer compras ou usar serviços pagos.';

  @override
  String get legalDigitalGoodsSection05Title => 'Canais de pagamento e taxas';

  @override
  String get legalDigitalGoodsSection05Body =>
      'Os preços podem ser apresentados em euros ou na moeda do seu fornecedor. As operadoras móveis ou plataformas de pagamento podem adicionar suas próprias taxas; verifique com seu provedor antes de confirmar pagamentos de operadora ou carteira.';

  @override
  String get legalDigitalGoodsSection06Title => 'Disponibilidade';

  @override
  String get legalDigitalGoodsSection06Body =>
      'Os recursos pagos são entregues virtualmente por meio de nossos servidores e podem mudar com o tempo. Podemos ajustar, suspender ou retirar itens, pacotes ou preços específicos para equilibrar o jogo ou por motivos técnicos.';

  @override
  String get legalDigitalGoodsSection07Title =>
      'Nenhum valor em dinheiro no mundo real';

  @override
  String get legalDigitalGoodsSection07Body =>
      'Itens e moedas virtuais não têm valor monetário fora do jogo, não são transferíveis por dinheiro real e podem ser alterados ou removidos como parte de atualizações, aplicação de conta ou descontinuação de serviço, exceto quando a lei exigir compensação.';

  @override
  String get legalDigitalGoodsSection08Title => 'Uso comercial proibido';

  @override
  String get legalDigitalGoodsSection08Body =>
      'Você não pode usar o The Mob State para operar negociações não autorizadas com dinheiro real, incluindo compra ou venda de contas, moeda do jogo, códigos ou ativos virtuais por dinheiro ou serviços externos fora de nossos fluxos de pagamento oficiais.';

  @override
  String get legalDigitalGoodsSection09Title => 'Mudanças de serviço';

  @override
  String get legalDigitalGoodsSection09Body =>
      'Poderemos atualizar esta política e as descrições de compras no jogo. O uso continuado após as alterações constitui aceitação dos termos revisados ​​quando permitido por lei.';

  @override
  String get legalDigitalGoodsSection10Title => 'Lei aplicável';

  @override
  String get legalDigitalGoodsSection10Body =>
      'A menos que a lei local obrigatória estabeleça o contrário, esta política é regida pelas leis da Inglaterra e do País de Gales e as disputas estarão sujeitas à jurisdição exclusiva dos tribunais da Inglaterra e do País de Gales.';

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
  String get helpTopicTrainingHubCategory => 'Treinamento';

  @override
  String get helpTopicTrainingHubTitle => 'Centro de treinamento';

  @override
  String get helpTopicTrainingHubSummary =>
      'Ginásio (força) e campo de tiro (precisão) em um só lugar. Ambos os bônus aumentam sua chance de sucesso no crime; a precisão do tiro também é usada em ações de lista de acertos. Cada faixa tem seu próprio tempo de espera e um limite de 100 sessões.';

  @override
  String get helpTopicTrainingHubHow =>
      'Ginásio: cada sessão aumenta seu bônus permanente de força em até +8% do total (100 sessões). O tempo de espera entre as sessões é de 1 hora (o VIP pode encurtá-lo).\nCampo de tiro: cada sessão aumenta seu bônus permanente de precisão em até +10% do total (100 sessões). O tempo de espera entre as sessões é de 1 hora (o VIP pode encurtá-lo).\nAmbos os bônus são adicionados pelo servidor aos cálculos de sucesso do crime.\nVocê treina cada faixa separadamente: dois temporizadores e dois botões de trem – uma tela.\nO progresso não é reiniciado a menos que a equipe aplique uma penalidade pesada.';

  @override
  String get helpTopicTrainingHubTips =>
      'Programe ambas as trilhas diariamente: pequenos passos se acumulam em uma vantagem clara nos crimes.\nRevise os crimes onde você mais falha: força e precisão se complementam – eles não são a mesma estatística.';

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
  String get territoryProjectStart => 'Start safehouse project';

  @override
  String get territoryProjectContribute => 'Supply project';

  @override
  String territoryProjectHqRequired(int level) {
    return 'Requires HQ level $level';
  }

  @override
  String get territoryProjectHint =>
      'A safehouse network boosts passive income. Sabotage damages it in contests; supply runs repair or advance it.';

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
  String launderSeizeChance(String chance) {
    return 'Estimated seize chance: $chance%';
  }

  @override
  String launderActiveJob(String amount) {
    return 'Wash in progress. Bank payout if successful: €$amount';
  }

  @override
  String get launderAmountLabel => 'Amount to wash';

  @override
  String get launderStartButton => 'Start wash';

  @override
  String get launderStartedSuccess => 'Laundering started.';

  @override
  String get launderErrorCooldown => 'Laundering is on cooldown.';

  @override
  String get launderErrorActive => 'A wash job is already running.';

  @override
  String get launderErrorTooLow => 'Amount is below the minimum.';

  @override
  String get launderErrorTooHigh => 'Amount is above the maximum.';

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
  String get propertyDevelopAction => 'Develop';

  @override
  String get propertyDevelopedSuccess => 'Property development complete.';

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
}
