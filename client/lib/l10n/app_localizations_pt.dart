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
  String get dashboardTimeoutAmmo => 'Compre balas';

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
  String get crew => 'Equipe';

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
  String get messages => 'Mensagens';

  @override
  String get helpAndGuide => 'Ajuda e Guia';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get liveEvents => 'Eventos ao vivo';

  @override
  String get support => 'Apoiar';

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
  String get tuneShop => 'Loja de músicas';

  @override
  String get territory => 'Território';

  @override
  String get achievements => 'Conquistas';

  @override
  String get menuCrackVault => 'Quebrar o cofre';

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
  String get crewWars => 'Guerras de tripulação';

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
  String get dashboardCrewWars => 'Guerras de tripulação';

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
  String get crewRoleLeader => 'Líder';

  @override
  String get crewRoleCoLeader => 'Co-líder';

  @override
  String get crewRoleMember => 'Membro';

  @override
  String get vehicleOpsHotspot => 'Ponto de acesso';

  @override
  String get vehicleOpsCrew => 'Equipe';

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
  String get appeal => 'Apelo';

  @override
  String get submitAppeal => 'Enviar recurso';

  @override
  String get bribeJudge => 'Juiz de suborno';

  @override
  String get bribe => 'Suborno';

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
      'Produção iniciada: ativa por 8 horas, reivindicação a cada 10 minutos';

  @override
  String get ammoFactoryTitle => 'Fábrica de munição';

  @override
  String get ammoFactoryIntro =>
      'Produz em lotes; você reivindica a cada 10 minutos (até 8 horas de pendências por sessão).';

  @override
  String get ammoFactoryWhatYouCanDo => 'O que você pode fazer:';

  @override
  String get ammoFactoryActionBuy => 'Compre uma fábrica em seu país atual';

  @override
  String get ammoFactoryActionProduce =>
      'Produção de reclamações (intervalo: 10 minutos, backlog máximo: 8 horas por sessão)';

  @override
  String get ammoFactoryActionOutput =>
      'Atualize a produção para o nível 5 para mais rodadas por reivindicação';

  @override
  String get ammoFactoryActionQuality =>
      'Atualize a qualidade para preços de mercado mais fortes';

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
  String get factoryProduceStatusLabel => 'Status do produto';

  @override
  String get factoryProduceStatusReady => 'Preparar';

  @override
  String get factoryProduceStatusCooldown => 'Esfriar';

  @override
  String get factorySessionActive =>
      'Janela de produção: ativa (intervalo de 10 minutos)';

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
  String get shootingTrainSuccess => 'Treinamento concluído';

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
  String get shootingTrain => 'Trem';

  @override
  String get gym => 'Academia';

  @override
  String get gymTrainSuccess => 'Treinamento concluído';

  @override
  String gymSessions(String count) {
    return 'Sessões: $count/100';
  }

  @override
  String gymStrengthBonus(String bonus) {
    return 'Bônus de força: $bonus%';
  }

  @override
  String gymCooldown(String time) {
    return 'Próxima sessão às $time';
  }

  @override
  String get gymTrain => 'Trem';

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
  String get prostitutionMoveToRedLight => 'Mude para o sinal vermelho';

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
  String get educationTrackNameIt => 'ISTO';

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
  String schoolTrackCooldownActive(int seconds) {
    return 'Cooldown ativo: ${seconds}s restantes';
  }

  @override
  String get schoolTrackMaxLevelReached => 'A trilha já está no nível máximo';

  @override
  String get schoolTrackStartFailed => 'Falha ao iniciar o treinamento';

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
      'Insira um ID de jogador para iniciar uma rivalidade.';

  @override
  String get rivalryPlayerIdHint => 'ID do jogador';

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
  String get nightclubSelectCrewMember => 'Selecione o membro da tripulação';

  @override
  String get nightclubAssignShift => 'Atribuir ao turno da boate';

  @override
  String get nightclubTabActive => 'Ativa';

  @override
  String get nightclubTabHistory => 'História';

  @override
  String get nightclubNoCrewAssigned => 'Nenhuma tripulação designada ainda';

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
  String get nightclubAssignCrewSuccess => 'Membro da tripulação designado';

  @override
  String get nightclubRemoveCrewSuccess => 'Membro da tripulação removido';

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
}
