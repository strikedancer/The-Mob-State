import 'package:flutter/material.dart';

class HelpTopic {
  const HelpTopic({
    required this.id,
    required this.categoryNl,
    required this.categoryEn,
    required this.icon,
    required this.titleNl,
    required this.titleEn,
    required this.summaryNl,
    required this.summaryEn,
    required this.howNl,
    required this.howEn,
    required this.tipsNl,
    required this.tipsEn,
    required this.protocolPath,
  });

  final String id;
  final String categoryNl;
  final String categoryEn;
  final IconData icon;
  final String titleNl;
  final String titleEn;
  final String summaryNl;
  final String summaryEn;
  final List<String> howNl;
  final List<String> howEn;
  final List<String> tipsNl;
  final List<String> tipsEn;
  final String protocolPath;

  String category(bool isNl) => isNl ? categoryNl : categoryEn;
  String title(bool isNl) => isNl ? titleNl : titleEn;
  String summary(bool isNl) => isNl ? summaryNl : summaryEn;
  List<String> howItWorks(bool isNl) => isNl ? howNl : howEn;
  List<String> tips(bool isNl) => isNl ? tipsNl : tipsEn;

  String searchableText(bool isNl) {
    final buffer = StringBuffer()
      ..write(title(isNl))
      ..write(' ')
      ..write(summary(isNl))
      ..write(' ')
      ..write(category(isNl));

    for (final item in howItWorks(isNl)) {
      buffer
        ..write(' ')
        ..write(item);
    }
    for (final item in tips(isNl)) {
      buffer
        ..write(' ')
        ..write(item);
    }

    return buffer.toString().toLowerCase();
  }
}

const List<HelpTopic> helpTopics = [
  HelpTopic(
    id: 'dashboard',
    categoryNl: 'Basis',
    categoryEn: 'Core',
    icon: Icons.dashboard,
    titleNl: 'Dashboard',
    titleEn: 'Dashboard',
    summaryNl:
        'Je centrale overzicht met al je stats, actieve cooldowns, live events en snelkoppelingen naar elk onderdeel van het spel.',
    summaryEn:
        'Your central overview with all your stats, active cooldowns, live events and shortcuts to every part of the game.',
    howNl: [
      'Bovenbalk toont: Cash (contant), Rang, Gezondheid (0-100 HP), Wanted Level (0-100) en FBI Heat (0-100).',
      'Elke 5 minuten loopt een automatische tick: je honger daalt -2, dorst -3, je heelt passief +5 HP (als HP > 0), je bankrekening ontvangt rente (0.5%) en je wanted level daalt licht als het onder 10 staat.',
      'Als honger of dorst op 0 zakt ga je dood en beland je 3 uur in de ICU. Eet en drink op tijd!',
      'De Quick Actions blokken rechts zijn snelkoppelingen naar Misdaden, Auto Stelen, Boot Stelen, Werk, Casino, Bank en School.',
      'Timeouts per onderdeel tonen hoelang je nog moet wachten voor een actie beschikbaar is. De timer toont automatisch de meest relevante eenheid: minuten, uren of dagen.',
      'Live events verschijnen als andere spelers grote acties uitvoeren, jij wordt aangevallen, of globale marktbewegingen plaatsvinden.',
      'Berichten-badge toont het aantal ongelezen systeemberichten en persoonlijke berichten.',
      'Navigatiemenu links geeft toegang tot alle spelonderdelen, gegroepeerd per categorie: Acties, Wereld, Sociaal, Economie, Empire en Assets.',
    ],
    howEn: [
      'Top bar shows: Cash, Rank, Health (0-100 HP), Wanted Level (0-100) and FBI Heat (0-100).',
      'Every 5 minutes an automatic tick fires: hunger drops -2, thirst -3, you heal passively +5 HP (if HP > 0), bank interest is added (0.5%) and wanted level drops slightly when below 10.',
      'If hunger or thirst reaches 0 you die and spend 3 hours in ICU. Eat and drink on time!',
      'Quick Action blocks on the right are shortcuts to Crimes, Car Theft, Boat Theft, Work, Casino, Bank and School.',
      'Cooldown timers per section show how long until your next action is available. The timer adapts to show the most relevant unit: minutes, hours or days.',
      'Live events appear when other players perform major actions, when you are attacked, or when global market movements occur.',
      'Message badge shows unread system messages and personal messages.',
      'Left navigation menu grants access to all game sections grouped by category: Actions, World, Social, Economy, Empire and Assets.',
    ],
    tipsNl: [
      'Open het dashboard als eerste na elke login om te zien wat er is veranderd terwijl je weg was.',
      'Houd je wanted level onder 10 om automatisch decay te laten werken en arrestatiekansen laag te houden.',
      'Controleer unread berichten voor je risicoacties start: beloningen, order-fills en system events staan allemaal in je inbox.',
    ],
    tipsEn: [
      'Open the dashboard first after every login to see what changed while you were away.',
      'Keep wanted level below 10 so automatic decay works and arrest chances stay low.',
      'Check unread messages before starting risky actions: rewards, order fills and system events all appear in your inbox.',
    ],
    protocolPath: 'docs/module-protocols/dashboard.md',
  ),
  HelpTopic(
    id: 'crimes',
    categoryNl: 'Acties',
    categoryEn: 'Actions',
    icon: Icons.warning,
    titleNl: 'Misdaden',
    titleEn: 'Crimes',
    summaryNl:
        'Pleeg illegale acties voor cash en XP, maar elke poging brengt kans op schade, arrestatie of extra Wanted Level mee.',
    summaryEn:
        'Commit illegal actions for cash and XP, but every attempt risks damage, arrest or extra Wanted Level.',
    howNl: [
      'Beginner crimes (Rang 1): Zakkenrollen €50-€200 (70% slagingskans, cooldown 30s), Winkeldiefstal €100-€300 (65%, cooldown 30s).',
      'Medium crimes (Rang 5-10): Inbraak €300-€800 (55%, cooldown 1 min), Auto Diefstal €500-€1.500 (50%, cooldown 1 min, voertuig nodig).',
      'Advanced crimes (Rang 15+): Gewapende Overval €1.000-€3.000 (45%, cooldown 2 min), Bankoverval €5.000-€15.000 (30%, cooldown 5 min).',
      'Bij elke crime poging: je neemt 5-15 HP schade en je Wanted Level stijgt 1-4 punten afhankelijk van succes of falen.',
      'Arrestatiekans stijgt snel met Wanted Level: bij Wanted 5 is het 25%, bij Wanted 10 al 50%, bij Wanted 18+ maximaal 90%.',
      'Bij arrestatie beland je in de gevangenis. Gevangenisstraf duurt maximaal(wanted level × 10) minuten, minimaal 5 minuten. Borg kost wanted level × €1.000.',
      'Sommige crimes vereisen een voertuig, tool of minimale rang. Mis je dit dan start de crime niet.',
      'XP die je verdient gebruik je om rang te stijgen, waardoor betere crimes en hogere beloningen vrijkomen.',
      'FBI Heat stijgt bij zwaardere crimes. Als heat boven 50 komt wordt de FBI actief met nog hogere arrestatiekansen.',
    ],
    howEn: [
      'Beginner crimes (Rank 1): Pickpocket €50-€200 (70% success, 30s cooldown), Shoplift €100-€300 (65%, 30s cooldown).',
      'Medium crimes (Rank 5-10): Burglary €300-€800 (55%, 1 min cooldown), Car Theft €500-€1.500 (50%, 1 min cooldown, vehicle needed).',
      'Advanced crimes (Rank 15+): Armed Robbery €1.000-€3.000 (45%, 2 min cooldown), Bank Robbery €5.000-€15.000 (30%, 5 min cooldown).',
      'Every crime attempt: you take 5-15 HP damage and Wanted Level rises by 1-4 points depending on success or failure.',
      'Arrest chance scales fast with Wanted Level: Wanted 5 = 25%, Wanted 10 = 50%, Wanted 18+ = maximum 90%.',
      'On arrest you go to prison. Sentence = max(wanted level × 10, 5) minutes. Bail = wanted level × €1.000.',
      'Some crimes require a vehicle, tool or minimum rank. Missing these will prevent the crime from starting.',
      'XP earned raises your rank, unlocking better crimes and higher rewards.',
      'FBI Heat rises with heavier crimes. Above heat 50 the FBI becomes active with even higher arrest chances.',
    ],
    tipsNl: [
      'Gebruik snelle beginner crimes om XP op te bouwen terwijl je grote cooldowns afwacht.',
      'Borg jezelf altijd uit als je Wanted Level hoog staat — lang in de cel zitten blokkeert al je loops.',
      'Houd HP boven 30 voor je aan een reeks crimes begint: elke poging kost HP en bij 0 HP beland je 3 uur in de ICU.',
    ],
    tipsEn: [
      'Use fast beginner crimes to build XP while waiting for big cooldowns.',
      'Always bail out if your Wanted Level is high — sitting in jail blocks all your loops.',
      'Keep HP above 30 before starting a crime run: every attempt costs HP and at 0 HP you spend 3 hours in ICU.',
    ],
    protocolPath: 'docs/module-protocols/crimes.md',
  ),
  HelpTopic(
    id: 'jobs',
    categoryNl: 'Acties',
    categoryEn: 'Actions',
    icon: Icons.work,
    titleNl: 'Banen',
    titleEn: 'Jobs',
    summaryNl:
        'Verdien legaal geld zonder Wanted Level-risico. Jobs zijn altijd succesvol maar lopen minder hoog op dan crimes.',
    summaryEn:
        'Earn legal money without Wanted Level risk. Jobs always succeed but pay less than crimes at their peak.',
    howNl: [
      'Beschikbare jobs per rang: Magazijnmedewerker €100-€300 (cooldown 10 min), Bezorger €200-€500, Beveiliger €300-€700, Boekhouder €500-€1.200, Manager €800-€2.000.',
      'Jobs hebben een slagingskans van 100%; je verliest nooit geld of HP en je Wanted Level stijgt niet.',
      'Vereisten voor elke job: minimaal 10 HP, honger > 20, dorst > 20, niet in de cel, niet in de ICU.',
      'Cooldown na elke job is standaard 10 minuten. Hogere rang of betere opleiding kan dit verlagen of de beloning verhogen.',
      'Jobbonen varieert per job-type en rang. Opleiding (School) kan hogere functies ontgrendelen.',
      'Je verdient ook XP per uitgevoerde job, maar minder dan bij comparabele crimes.',
      'Gebruik jobs als betrouwbare cashflow-basis, zeker als je Wanted Level te hoog is om veilig crimes te plegen.',
    ],
    howEn: [
      'Available jobs by rank: Warehouse Worker €100-€300 (10 min cooldown), Delivery Driver €200-€500, Security Guard €300-€700, Accountant €500-€1.200, Manager €800-€2.000.',
      'Jobs have a 100% success rate; you never lose money or HP and Wanted Level does not rise.',
      'Requirements per job: minimum 10 HP, hunger > 20, thirst > 20, not in jail, not in ICU.',
      'Cooldown after every job is 10 minutes by default. Higher rank or education can lower this or raise the reward.',
      'Job pay varies per job type and rank. Education (School) can unlock higher positions.',
      'You also earn XP per job, though less than comparable crimes.',
      'Use jobs as a reliable cash flow base, especially when your Wanted Level is too high for safe crimes.',
    ],
    tipsNl: [
      'Combineer jobs en school: opleiding ontgrendelt betere jobs met hogere uitbetalingen.',
      'Als je Wanted Level boven 8 staat of je bent herstellende van ICU, gebruik dan jobs in plaats van crimes.',
      'Zorg dat honger en dorst niet te laag zakken: een job met stats < 20 begint gewoon niet.',
    ],
    tipsEn: [
      'Combine jobs and school: education unlocks better jobs with higher payouts.',
      'When Wanted Level is above 8 or you are recovering from ICU, use jobs instead of crimes.',
      'Keep hunger and thirst from dropping too low: a job with stats below 20 simply will not start.',
    ],
    protocolPath: 'docs/module-protocols/jobs.md',
  ),
  HelpTopic(
    id: 'travel',
    categoryNl: 'Wereld',
    categoryEn: 'World',
    icon: Icons.flight,
    titleNl: 'Reizen',
    titleEn: 'Travel',
    summaryNl:
        'Verplaats je tussen landen voor betere marktprijzen, unieke kansen en toegang tot internationale systemen.',
    summaryEn:
        'Move between countries for better market prices, unique opportunities and access to international systems.',
    howNl: [
      'Beschikbare landen: Nederland (startland), België, Duitsland, Frankrijk, Verenigd Koninkrijk, Spanje, Italië, Zwitserland, USA, Mexico, Colombia, Brazilië.',
      'Reiskosten: buurland €500-€2.000, Europa → Amerika €5.000-€10.000, lange afstand €10.000-€20.000.',
      'Vereisten voor reizen: niet in de cel, niet in ICU, minimaal 20 HP, reiskosten beschikbaar.',
      'Elk land heeft andere marktprijzen voor handelsgoederen (tot 300% prijsverschil), andere crime-opbrengsten en unieke trade items.',
      'Risico tijdens transport: politie kan goederen confisqueren op basis van je Wanted Level (kans = wanted × 2%, max 80%). FBI kan internationaal alles in beslag nemen als heat hoog is.',
      'Douane-inspectie heeft 10% basiskans. Je kunt steekpenningen betalen (€1.000-€5.000) of gepakt worden voor 50% goederen-verlies.',
      'Na aankomst zijn al je acties direct beschikbaar in het nieuwe land. Markten en crimesnelheid variëren per locatie.',
    ],
    howEn: [
      'Available countries: Netherlands (start), Belgium, Germany, France, United Kingdom, Spain, Italy, Switzerland, USA, Mexico, Colombia, Brazil.',
      'Travel costs: neighboring country €500-€2.000, Europe → Americas €5.000-€10.000, long distance €10.000-€20.000.',
      'Travel requirements: not in jail, not in ICU, minimum 20 HP, travel funds available.',
      'Each country has different market prices (up to 300% price difference), different crime payouts and unique trade items.',
      'Transport risk: police can seize goods based on Wanted Level (chance = wanted × 2%, max 80%). FBI can seize everything internationally if heat is high.',
      'Customs inspection has a 10% base chance. You can bribe (€1.000-€5.000) or get caught losing 50% of goods.',
      'After arrival all actions are immediately available in the new country. Markets and crime speed vary by location.',
    ],
    tipsNl: [
      'Plan reizen altijd samen met trade, drugs of smokkel — een lege reis is weggegooid geld.',
      'Verlaag je Wanted Level voor vertrek: hoog wanted vergroot de kans op confiscatie onderweg sterk.',
      'Combineer heen- en terugreis zodat je bij aankomst al weet wat je meebrengt op de terugweg.',
    ],
    tipsEn: [
      'Always combine travel with trade, drugs or smuggling — empty travel wastes money.',
      'Lower your Wanted Level before departure: high wanted greatly increases confiscation risk en route.',
      'Plan your return trip in advance so you already know what to bring back on arrival.',
    ],
    protocolPath: 'docs/module-protocols/travel.md',
  ),
  HelpTopic(
    id: 'crew',
    categoryNl: 'Sociaal',
    categoryEn: 'Social',
    icon: Icons.groups,
    titleNl: 'Crew',
    titleEn: 'Crew',
    summaryNl:
        'Richt een crew op of sluit je aan bij bestaande spelers om samen heists te plegen, opslag te delen en sterker te staan.',
    summaryEn:
        'Start a crew or join existing players to pull off heists together, share storage and become stronger as a unit.',
    howNl: [
      'Crew aanmaken kost €10.000. Elke crew heeft max 10 leden. De leader kan leden uitnodigen, kicken en heists starten.',
      'Crew-voordelen: toegang tot grote heists, gedeelde opslag, teamwork-bonus (+10% slagingskans per extra lid, max +30%) en groepschat.',
      'Heists: Small Bank Heist (2 spelers, 40% kans, €10.000-€30.000, cooldown 30 min), Sieradenzaak (3 spelers, 35%, €20.000-€50.000, 45 min), Casino Heist (4 spelers, 25%, €50.000-€150.000, 2 uur), Federal Reserve (5 spelers, 15%, €100.000-€500.000, 6 uur, +20 FBI Heat).',
      'Bij een heist moeten alle leden online zijn bij de start. Is iemand afwezig dan mislukt de heist.',
      'Bij mislukte heist: jail time voor alle leden, Wanted Level +5, geen beloning.',
      'De reward bij een geslaagde heist wordt gelijk verdeeld over alle deelnemende leden.',
      'Crew-chat is beschikbaar voor snelle coördinatie zonder extra apps.',
      'Crew HQ-progressie: hoe langer en actiever de crew, hoe meer gezamenlijke upgrades en buffs vrijkomen.',
    ],
    howEn: [
      'Creating a crew costs €10.000. Each crew has max 10 members. Leader can invite, kick and start heists.',
      'Crew benefits: access to large heists, shared storage, teamwork bonus (+10% success per extra member, max +30%) and group chat.',
      'Heists: Small Bank (2 players, 40%, €10.000-€30.000, 30 min cooldown), Jewelry Store (3 players, 35%, €20.000-€50.000, 45 min), Casino Heist (4 players, 25%, €50.000-€150.000, 2 hrs), Federal Reserve (5 players, 15%, €100.000-€500.000, 6 hrs, +20 FBI Heat).',
      'For a heist all members must be online at start. If someone is absent the heist fails.',
      'Failed heist: jail time for everyone, Wanted Level +5, no reward.',
      'Heist reward is split equally among all participating members.',
      'Crew chat is available for fast coordination.',
      'Crew HQ progression: the longer and more active the crew, the more shared upgrades and buffs unlock.',
    ],
    tipsNl: [
      'Coördineer heist-starttijden in de crew-chat zodat iedereen online is en niemand in de cel zit.',
      'Kies een crew die in dezelfde tijdzone of activiteitspatroon zit als jij voor betere heist-success rates.',
      'Gebruik gedeelde crew-opslag om risicovolle goederen los te koppelen van je persoonlijke inventaris.',
    ],
    tipsEn: [
      'Coordinate heist start times in crew chat so everyone is online and nobody is in jail.',
      'Choose a crew in the same timezone or activity pattern for better heist success rates.',
      'Use shared crew storage to separate risky goods from your personal inventory.',
    ],
    protocolPath: 'docs/module-protocols/crew.md',
  ),
  HelpTopic(
    id: 'friends',
    categoryNl: 'Sociaal',
    categoryEn: 'Social',
    icon: Icons.group,
    titleNl: 'Vrienden',
    titleEn: 'Friends',
    summaryNl:
        'Beheer je vriendenlijst voor snellere samenwerking, profieldoorzoeken en social feedback.',
    summaryEn:
        'Manage your friends list for faster coordination, profile browsing and social feedback.',
    howNl: [
      'Vriendenpagina toont drie lijsten: huidige vrienden, verstuurde verzoeken en ontvangen verzoeken.',
      'Je kunt vanuit een vriend direct een bericht sturen, profiel bekijken of samenwerking starten.',
      'Vrienden zien elke keer als ze actief zijn in het spel. Dat helpt bij planning van gezamenlijke heists of trades.',
      'Vriendverzoeken verlopen niet automatisch; houd de lijst actueel zodat ongewenste verzoeken je niet afleiden.',
      'Vrienden buiten je crew zijn waardevol voor jail-escapes (een vriend kan je helpen ontsnappen) en voor informatie-uitwisseling.',
    ],
    howEn: [
      'Friends page shows three lists: current friends, sent requests and received requests.',
      'From a friend you can directly send a message, view their profile or start a collaboration.',
      'You can see when friends are active in the game, which helps planning heists or trades.',
      'Friend requests do not expire automatically; keep the list tidy so pending requests do not distract you.',
      'Friends outside your crew are valuable for jail escapes (a friend can help you break out) and information sharing.',
    ],
    tipsNl: [
      'Voeg vrienden toe die in dezelfde speelstijl zitten: heist-partners, trader-netwerk of crime-support.',
      'Een vriend die een jail-escape doet krijgt €500-€2.000 beloning als het lukt. Spreek dit af voor noodsituaties.',
    ],
    tipsEn: [
      'Add friends who share your play style: heist partners, trader networks or crime support.',
      'A friend who executes a jail escape earns €500-€2.000 reward on success. Arrange this for emergencies.',
    ],
    protocolPath: 'docs/module-protocols/friends.md',
  ),
  HelpTopic(
    id: 'messages',
    categoryNl: 'Sociaal',
    categoryEn: 'Social',
    icon: Icons.chat,
    titleNl: 'Berichten',
    titleEn: 'Messages',
    summaryNl:
        'Je inbox met persoonlijke berichten van andere spelers en systeemberichten over beloningen, orders en game-events.',
    summaryEn:
        'Your inbox with personal player messages and system messages about rewards, orders and game events.',
    howNl: [
      'Berichten zijn onderverdeeld in persoonlijke gesprekken en The Mob State systeemberg.',
      'Systeemberichten worden automatisch gestuurd bij: crypto trades, order fills, leaderboard uitkeringen, heist-resultaten, jail-escapes en achievement-badges.',
      'Je kunt berichten sturen naar andere spelers zolang hun privacy-instellingen dat toestaan.',
      'Unread berichten tonen als badge op het berichtenicoontje en zijn zichtbaar vanuit het dashboard.',
      'Berichten hebben geen vervaldatum en blijven bewaard als historisch log van account-events.',
      'Gebruik het inbox-log bij twijfel over een uitbetaling, een gemiste order-fill of een onverwachte balanswijziging.',
    ],
    howEn: [
      'Messages are split into personal conversations and The Mob State system thread.',
      'System messages are sent automatically for: crypto trades, order fills, leaderboard payouts, heist results, jail escapes and achievement badges.',
      'You can send messages to other players as long as their privacy settings allow it.',
      'Unread messages appear as a badge on the message icon and are visible from the dashboard.',
      'Messages do not expire and are kept as a historical log of account events.',
      'Use the inbox log when in doubt about a payout, a missed order fill or an unexpected balance change.',
    ],
    tipsNl: [
      'Check je inbox na lang offline zijn: beloningen, order-fills en events zijn er allemaal terug te vinden.',
      'Stel notificatievoorkeuren in via Instellingen zodat je alleen bij echt belangrijke events een pushmelding krijgt.',
    ],
    tipsEn: [
      'Check your inbox after long offline periods: rewards, order fills and events are all recorded there.',
      'Configure notification preferences via Settings so you only receive push alerts for truly important events.',
    ],
    protocolPath: 'docs/module-protocols/messages.md',
  ),
  HelpTopic(
    id: 'inventory',
    categoryNl: 'Beheer',
    categoryEn: 'Management',
    icon: Icons.inventory,
    titleNl: 'Inventaris',
    titleEn: 'Inventory',
    summaryNl:
        'Beheer alles wat je draagt, opslaat en inzet: wapens, tools, voertuigen, drugs en handelsgoederen.',
    summaryEn:
        'Manage everything you carry, store and equip: weapons, tools, vehicles, drugs and trade goods.',
    howNl: [
      'Je inventaris is verdeeld in carried items (bij je), opgeslagen items (in warehouse/crew storage) en actieve loadouts.',
      'Gewicht bepaalt je draagcapaciteit. Sommige crimes of reizen blokkeren als je te zwaar bent.',
      'Item-conditie verslechtert bij gebruik. Wapens in slechte conditie presteren minder goed en tools kunnen kapotgaan.',
      'Loadouts laten je snel wisselen tussen een "crime set" (tool + weapon) en een "travel set" (licht, waardevolle goederen min).',
      'Bij arrestatie kan de politie items confisqueren. Draag geen waardevolle goederen als je een hoog Wanted Level hebt.',
      'Drugs in je inventaris verhogen de kans op FBI-interventie bij internationale reizen.',
      'Crew-opslag is een veilige bewaarplaats buiten je persoonlijke carrying-risico.',
    ],
    howEn: [
      'Inventory is split into carried items (on you), stored items (warehouse/crew storage) and active loadouts.',
      'Weight determines your carrying capacity. Some crimes or travel block if you are overloaded.',
      'Item condition degrades with use. Weapons in poor condition perform worse and tools can break.',
      'Loadouts let you switch quickly between a crime set (tool + weapon) and a travel set (light, minimal valuables).',
      'On arrest police can confiscate items. Do not carry valuables with a high Wanted Level.',
      'Drugs in inventory increase the chance of FBI intervention during international travel.',
      'Crew storage is a safe place to keep items outside your personal carrying risk.',
    ],
    tipsNl: [
      'Hou je carrying load licht als je gaat reizen of een hogere crime-serie plant met arrestatierisico.',
      'Gebruik loadouts zodat je voor elk scenario snel de juiste gear aan hebt.',
      'Check item-conditie regelmatig: kapotte tools blokkeren crimes stil, zonder duidelijke foutmelding.',
    ],
    tipsEn: [
      'Keep your carrying load light when traveling or running a high-arrest-risk crime spree.',
      'Use loadouts so you always have the right gear equipped for each scenario.',
      'Check item condition regularly: broken tools silently block crimes without a clear error message.',
    ],
    protocolPath: 'docs/module-protocols/inventory.md',
  ),
  HelpTopic(
    id: 'properties',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.business,
    titleNl: 'Eigendommen',
    titleEn: 'Properties',
    summaryNl:
        'Koop onroerend goed en assets voor passief inkomen per tick. Hoe meer je investeert, hoe groter je structurele cashflow.',
    summaryEn:
        'Buy real estate and assets for passive income every tick. The more you invest the larger your structural cash flow.',
    howNl: [
      'Inkomsten worden elke tick (elke 5 minuten) automatisch bijgeschreven op je account.',
      'Low-end: Garage €50.000 (€100/tick), Klein appartement €75.000 (€150/tick), Winkel €100.000 (€200/tick).',
      'Mid-range: Groot appartement €250.000 (€500/tick), Restaurant €400.000 (€800/tick), Warehouse €600.000 (€1.200/tick).',
      'High-end: Kantoorgebouw €1.000.000 (€2.500/tick), Nachtclub €1.500.000 (€4.000/tick), Casino €3.000.000 (€8.000/tick), Landhuis €5.000.000 (€15.000/tick).',
      'Je kunt onbeperkt eigendommen combineren; meer bezit = meer passieve inkomstenstroom.',
      'Verkopen levert 70% van de aankoopprijs op. Geen cooldown op verkopen, dit is direct.',
      'Sommige eigendommen zijn landgebonden: je moet op dat land zijn om ze te kopen of te beheren.',
      'Terugverdientijd: Garage ~8 uur, Mid-range ~5-8 uur, High-end ~14-24 uur bij 100% actieve ticks.',
    ],
    howEn: [
      'Income is credited automatically every tick (every 5 minutes).',
      'Low-end: Garage €50.000 (€100/tick), Small Apartment €75.000 (€150/tick), Store €100.000 (€200/tick).',
      'Mid-range: Large Apartment €250.000 (€500/tick), Restaurant €400.000 (€800/tick), Warehouse €600.000 (€1.200/tick).',
      'High-end: Office Building €1.000.000 (€2.500/tick), Nightclub €1.500.000 (€4.000/tick), Casino €3.000.000 (€8.000/tick), Mansion €5.000.000 (€15.000/tick).',
      'You can own unlimited properties; more properties means a larger passive income stream.',
      'Selling yields 70% of purchase price. No cooldown on selling, it is instant.',
      'Some properties are country locked: you must be in that country to buy or manage them.',
      'Payback time: Garage ~8 hrs, Mid-range ~5-8 hrs, High-end ~14-24 hrs at 100% active ticks.',
    ],
    tipsNl: [
      'Investeer als eerste in een Warehouse (€600.000, €1.200/tick) als je snel een terugverdientijd wil combineren met opslag.',
      'Houd elke dag inkomsten bij: bij 288 ticks per dag verdient het dure Casino €2.304.000 per dag.',
      'Verkoop niet te snel: 70% is een serieuze afschrijving ten opzichte van aankooprijs.',
    ],
    tipsEn: [
      'Invest in a Warehouse (€600.000, €1.200/tick) first if you want to combine fast payback with storage.',
      'Track daily income: at 288 ticks per day the expensive Casino earns €2.304.000 daily.',
      'Do not sell too quickly: 70% represents a serious markdown from purchase price.',
    ],
    protocolPath: 'docs/module-protocols/properties.md',
  ),
  HelpTopic(
    id: 'bank',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.account_balance,
    titleNl: 'Bank',
    titleEn: 'Bank',
    summaryNl:
        'Zet geld op je bankrekening om rente te verdienen en cash buiten bereik van politie-confiscaties te houden.',
    summaryEn:
        'Deposit money to earn interest and keep cash beyond the reach of police confiscations.',
    howNl: [
      'Rente: 0.5% van je banksaldo per tick (elke 5 minuten). Voorbeeld: €10.000 op bank = €50 rente per tick = €600 per uur = €14.400 per dag.',
      'Storten en opnemen zijn allebei gratis en direct, zonder minimum of maximum limiet.',
      'Geld op de bank is beschermd tegen politie-confiscaties. Alleen contant cash kan je verliezen bij arrestatie.',
      'Transactiehistorie toont alle in- en uitgaande stromen met tijdstip en bedrag.',
      'Bank Robbery crime: slaagt bij 30% kans en steelt 10-30% van het banksaldo van een willekeurig andere speler. Hoog Wanted Level risico.',
      'Geld overmaken naar andere spelers is mogelijk. Check de prijzen en bevestig bedrag twee keer voordat je verstuurt.',
    ],
    howEn: [
      'Interest: 0.5% of your bank balance per tick (every 5 minutes). Example: €10.000 in bank = €50 interest per tick = €600 per hour = €14.400 per day.',
      'Deposits and withdrawals are both free and instant with no minimum or maximum limit.',
      'Money in the bank is protected from police confiscations. Only cash on hand can be lost at arrest.',
      'Transaction history shows all incoming and outgoing flows with timestamp and amount.',
      'Bank Robbery crime: succeeds at 30% and steals 10-30% of a random other player\'s bank balance. High Wanted Level risk.',
      'Transferring money to other players is possible. Double-check amounts before confirming.',
    ],
    tipsNl: [
      'Stuur grote bedragen meteen naar de bank — contant cash is kwetsbaar bij elke crimeworp.',
      'Zet rente-inkomsten automatisch bij door grote bedragen spaarsgewijs op te bouwen op de bank.',
      'Houd altijd een klein werkkapitaal contant voor directe uitgaven (borg, reizen, tools).',
    ],
    tipsEn: [
      'Send large amounts to the bank immediately — cash on hand is at risk with every crime attempt.',
      'Grow interest returns by building large amounts steadily in the bank.',
      'Keep a small working capital as cash for direct expenses (bail, travel, tools).',
    ],
    protocolPath: 'docs/module-protocols/bank.md',
  ),
  HelpTopic(
    id: 'casino',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.casino,
    titleNl: 'Casino',
    titleEn: 'Casino',
    summaryNl:
        'Gok met contant geld op slots, blackjack, roulette en dice. Hoge variantie: je kunt snel veel winnen of verliezen.',
    summaryEn:
        'Gamble with cash on slots, blackjack, roulette and dice. High variance: you can win or lose large amounts fast.',
    howNl: [
      'Beschikbare spellen: Slots (lage inzet, willekeurige uitbetaling), Blackjack (strategie telt), Roulette (buiten/binnenkansen met eigen odds), Dice (hoge variantie).',
      'Elke game heeft een minimum inzet. Uitkeringsratio verschilt per speltype (bijv. roulette buiten kans ~1.97x, vol getal 35x).',
      'Casino gebruikt alleen contant geld, niet je banksaldo. Zorg dat je cash bij je hebt voor je speelt.',
      'Er is geen cooldown tussen rondes: je kunt onbeperkt snel achter elkaar spelen.',
      'Grote winsten boven een drempelwaarde kunnen een event triggeren zichtbaar voor andere spelers.',
      'Verloren inzetten zijn definitief weg; er is geen verzekering of terugkoop.',
    ],
    howEn: [
      'Available games: Slots (low stake, random payout), Blackjack (strategy matters), Roulette (outside/inside bets with own odds), Dice (high variance).',
      'Each game has a minimum bet. Payout ratios differ per game type (e.g. roulette outside bet ~1.97x, single number 35x).',
      'Casino uses cash only, not your bank balance. Make sure you have cash before you play.',
      'There is no cooldown between rounds: you can play as fast as you want.',
      'Large wins above a threshold can trigger an event visible to other players.',
      'Lost bets are permanently gone; there is no insurance or buyback.',
    ],
    tipsNl: [
      'Stel altijd een maximale sessie-bankroll in: nooit meer dan 10% van je totale cash per sessie.',
      'Blackjack heeft de beste kansen voor een vaardige speler. Leer basis-strategie voor je grote bedragen inzet.',
      'Zie casino als entertainment, niet als inkomstenbron: de house edge zorgt op lange termijn voor verlies.',
    ],
    tipsEn: [
      'Always set a session bankroll limit: never more than 10% of total cash per session.',
      'Blackjack has the best odds for a skilled player. Learn basic strategy before betting large.',
      'Treat casino as entertainment, not income: the house edge ensures long-term loss.',
    ],
    protocolPath: 'docs/module-protocols/casino.md',
  ),
  HelpTopic(
    id: 'trade',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.shopping_bag,
    titleNl: 'Handelswaar',
    titleEn: 'Trade Goods',
    summaryNl:
        'Koop goederen goedkoop in het ene land en verkoop duur in een ander. Prijsverschillen tot 300% zijn mogelijk.',
    summaryEn:
        'Buy goods cheap in one country and sell expensive in another. Price differences up to 300% are possible.',
    howNl: [
      'Elk land heeft unieke handelsgoederen met eigen basisprijzen: Diamanten (Zuid-Afrika), Drugs (Colombia), Wapens (USA), Kunst (Frankrijk), Elektronica (Japan), Alcohol (Schotland).',
      'Marktprijzen fluctueren elke tick (5 minuten) tussen 0.5x en 2.0x de basisprijs. Prijzen kunnen dalen terwijl je onderweg bent.',
      'Kopen kan alleen in het land waar het goed beschikbaar is. Verkopen is het meest waard in een ander land.',
      'Risico bij transport: politie confisqueert bij hoog Wanted Level (kans = wanted × 2%, max 80%); FBI raidt internationaal op basis van heat + goederenwaarde.',
      'Douane heeft 10% basiskans bij grensovergang. Betaal €1.000-€5.000 steekpenning of verlies 50% van de lading.',
      'Combineer trade met smokkelen voor hogere marges maar ook hoger risico op inbeslagname.',
      'Je kunt onbeperkte hoeveelheden kopen zolang je genoeg cash hebt en inventaristruimte beschikbaar is.',
    ],
    howEn: [
      'Each country has unique trade goods with own base prices: Diamonds (South Africa), Drugs (Colombia), Weapons (USA), Art (France), Electronics (Japan), Alcohol (Scotland).',
      'Market prices fluctuate every tick (5 minutes) between 0.5x and 2.0x base price. Prices can drop while you are traveling.',
      'Buying is only possible in the country where the good is available. Selling is most valuable in a different country.',
      'Transport risk: police confiscate at high Wanted Level (chance = wanted × 2%, max 80%); FBI raids internationally based on heat + goods value.',
      'Customs has a 10% base chance at border crossings. Pay €1.000-€5.000 bribe or lose 50% of cargo.',
      'Combine trade with smuggling for higher margins but also higher seizure risk.',
      'You can buy unlimited quantities as long as you have enough cash and inventory space.',
    ],
    tipsNl: [
      'Monitor marktprijzen vlak voor vertrek en niet eerder — prijzen bewegen elke 5 minuten.',
      'Verlaag Wanted Level voor elke trade-reis: confiscatie van een volle lading is een catastrofaal verlies.',
      'Kalkuleer altijd reiskosten, douane-risico en tijdverlies mee in je winstberekening.',
    ],
    tipsEn: [
      'Check market prices right before departure, not earlier — prices move every 5 minutes.',
      'Lower Wanted Level before every trade trip: confiscation of a full cargo is a catastrophic loss.',
      'Always include travel costs, customs risk and time loss in your profit calculation.',
    ],
    protocolPath: 'docs/module-protocols/trade.md',
  ),
  HelpTopic(
    id: 'black-market',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.store,
    titleNl: 'Zwarte Markt',
    titleEn: 'Black Market',
    summaryNl:
        'Koop en verkoop illegale en schaarse goederen: wapens, munitie, drugs en materials die nergens anders verkrijgbaar zijn.',
    summaryEn:
        'Buy and sell illegal and scarce goods: weapons, ammo, drugs and materials unavailable elsewhere.',
    howNl: [
      'De zwarte markt is onderverdeeld in submarkten: Materials (grondstoffen), Weapons (vuurwapens en messen), Ammo (munitie per kaliber), Vehicles (illegale voertuigen).',
      'Prijzen en beschikbaarheid variëren sterk per land en per tijdstip. Een listing kan snel leeg zijn.',
      'Zwarte markt transacties laten geen officieel spoor achter maar verhogen FBI Heat bij grote aankopen.',
      'Wapens die je hier koopt kun je inzetten bij crimes, PvP en beveiliging. Betere wapens geven hogere beschadiging en succes-kans.',
      'Filters per categorie (type, land, prijs, beschikbaarheid) helpen je snel de juiste listing te vinden.',
      'Je kunt zelf listings plaatsen als verkoper, inclusief prijs en hoeveelheid. Andere spelers kopen dan van jou.',
      'Listings verlopen na bepaalde tijd als ze niet worden gekocht. Monitor je eigen aanbiedingen via je profiel.',
    ],
    howEn: [
      'The black market is divided into submarkets: Materials (raw materials), Weapons (firearms and knives), Ammo (ammo per caliber), Vehicles (illegal vehicles).',
      'Prices and availability vary heavily by country and time. A listing can sell out fast.',
      'Black market transactions leave no official trail but increase FBI Heat for large purchases.',
      'Weapons bought here can be used in crimes, PvP and security. Better weapons give higher damage and success chance.',
      'Filters by category (type, country, price, availability) help you quickly find the right listing.',
      'You can post your own listings as a seller, including price and quantity. Other players buy from you.',
      'Listings expire after a certain time if unsold. Monitor your own offers via your profile.',
    ],
    tipsNl: [
      'Controleer altijd of de zwarte marktprijs lager is dan het open trade alternatief inclusief reiskosten.',
      'Koop wapens en ammo in bulk als de prijs laag staat: beschikbaarheid is tijdelijk.',
      'Vermijd grote zwarte markt aankopen als je FBI Heat al boven 30 zit.',
    ],
    tipsEn: [
      'Always check whether the black market price is lower than the open trade alternative including travel.',
      'Buy weapons and ammo in bulk when prices are low: availability is temporary.',
      'Avoid large black market purchases when FBI Heat is already above 30.',
    ],
    protocolPath: 'docs/module-protocols/black-market.md',
  ),
  HelpTopic(
    id: 'drugs',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.local_pharmacy,
    titleNl: 'Drugs',
    titleEn: 'Drugs',
    summaryNl:
        'Bouw een complete drugsoperatie van grondstoffen tot eindproduct. Draai productieketens, beheer opslag en verkoop voor hoge marges maar ook serieuze risico\'s.',
    summaryEn:
        'Build a complete drug operation from raw materials to finished product. Run production chains, manage storage and sell for high margins but serious risks.',
    howNl: [
      'Het drugsysteem bestaat uit: Hub (overzicht en stats), Faciliteiten (upgrade productiecapaciteit), Productie (actieve productielijnen met timer) en Inventaris (eindproduct en grondstoffen).',
      'Grondstoffen koop je via de zwarte markt of handel. Combineer ze in een faciliteit om drugs te produceren.',
      'Productietimers lopen door terwijl je offline bent. Je hoeft niet actief te klikken: check terug als de timer klaar is.',
      'Opslagcapaciteit is beperkt per faciliteit. Als je opslag vol is stopt de productie automatisch.',
      'Drugs verkopen kan via de zwarte markt, via Colombia of andere speciale verkooplocaties voor de hoogste marge.',
      'FBI Heat stijgt bij elke productieronde en extra bij grote verkopen. Hoge heat leidt tot raid-events die je operatie kunnen stilleggen.',
      'Faciliteit-upgrades verlagen productietime, verhogen output en vergroten opslagcapaciteit.',
      'Drugs in je inventaris verhogen het risico op confiscatie bij reizen en politiecontroles.',
    ],
    howEn: [
      'The drug system consists of: Hub (overview and stats), Facilities (upgrade production capacity), Production (active production lines with timer) and Inventory (finished products and raw materials).',
      'Buy raw materials via the black market or trade. Combine them in a facility to produce drugs.',
      'Production timers run while you are offline. No active clicking needed: check back when the timer finishes.',
      'Storage capacity is limited per facility. When storage is full production stops automatically.',
      'Sell drugs via the black market, Colombia or other special sales locations for the highest margin.',
      'FBI Heat rises every production cycle and extra on large sales. High heat leads to raid events that can shut down your operation.',
      'Facility upgrades reduce production time, increase output and expand storage capacity.',
      'Drugs in inventory increase confiscation risk during travel and police checks.',
    ],
    tipsNl: [
      'Upgrade opslag voor productie: volle opslag stopt je productie en je verliest die productietime.',
      'Houd FBI Heat onder 50: boven dat niveau word je actief gestalkt met zware raid-kansen die alles stilleggen.',
      'Combineer drugsverkoop met smokkelen voor hogere marges en verspreide risico\'s.',
    ],
    tipsEn: [
      'Upgrade storage before production: full storage stops production and you lose that production time.',
      'Keep FBI Heat below 50: above that threshold you are actively hunted with heavy raid chances that shut everything down.',
      'Combine drug sales with smuggling for higher margins and distributed risk.',
    ],
    protocolPath: 'docs/module-protocols/drugs.md',
  ),
  HelpTopic(
    id: 'nightclub',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.nightlife,
    titleNl: 'Nachtclub',
    titleEn: 'Nightclub',
    summaryNl:
        'Run een nachtclub als onderdeel van je criminele empire. Beheer personeel, beveiliging en supply voor passief en actief inkomen met een eigen seizoensleaderboard.',
    summaryEn:
        'Run a nightclub as part of your criminal empire. Manage staff, security and supply for passive and active income with a dedicated season leaderboard.',
    howNl: [
      'De nachtclub heeft meerdere schermen: Hub (overzicht revenue en bezoekers), DJs (boek entertainers voor hogere bezoekerscores), Beveiliging (bewakers verlagen incidentrisico), Supply (alcohol en andere voorraden) en Season Summary.',
      'Revenue wordt gegenereerd per tick op basis van DJ-kwaliteit, bezettingsgraad en supply-beschikbaarheid. Mis je supply dan daalt je inkomst direct.',
      'Incidenten (vechtpartijen, diefstal) kunnen optreden als je beveiliging tekortschiet. Dit schaadt bezoekers-score en inkomst.',
      'Elk seizoen heeft een leaderboard. Spelers met de hoogste totale nachtclub-revenue winnen seizoensbeloningen.',
      'Synergie met drugs: eigen drugs-productie kan als supply dienen, wat margins verhoogt.',
      'Synergie met prostitution: gecombineerde venue events geven extra bezoekers en hogere revenue.',
      'Upgrades verbeteren capaciteit, supply-opslag en het maximale aantal DJs en bewakers dat je kunt inzetten.',
    ],
    howEn: [
      'The nightclub has multiple screens: Hub (revenue and visitor overview), DJs (book entertainers for higher visitor scores), Security (guards lower incident risk), Supply (alcohol and other stock) and Season Summary.',
      'Revenue is generated per tick based on DJ quality, occupancy and supply availability. Missing supply directly reduces income.',
      'Incidents (fights, theft) can occur when security is insufficient. This damages visitor score and income.',
      'Each season has a leaderboard. Players with the highest total nightclub revenue win season rewards.',
      'Synergy with drugs: own drug production can serve as supply, raising margins.',
      'Synergy with prostitution: combined venue events give extra visitors and higher revenue.',
      'Upgrades improve capacity, supply storage and the maximum number of DJs and guards you can deploy.',
    ],
    tipsNl: [
      'Zorg altijd dat supply niet leeg raakt: één tick zonder supply kan een bezoekersdip veroorzaken die moeilijk te herstellen is.',
      'Boek de beste DJ die je je kunt veroorloven: DJ-kwaliteit heeft de grootste directe impact op revenue per tick.',
      'Check het seizoensleaderboard elke dag en schaal supply en DJs op als je in top-10 wilt eindigen.',
    ],
    tipsEn: [
      'Always keep supply stocked: one tick without supply can trigger a visitor dip that is hard to recover from.',
      'Book the best DJ you can afford: DJ quality has the biggest direct impact on revenue per tick.',
      'Check the season leaderboard daily and scale up supply and DJs if you want to finish in the top 10.',
    ],
    protocolPath: 'docs/module-protocols/nightclub.md',
  ),
  HelpTopic(
    id: 'crypto',
    categoryNl: 'Economie',
    categoryEn: 'Economy',
    icon: Icons.currency_bitcoin,
    titleNl: 'Crypto',
    titleEn: 'Crypto',
    summaryNl:
        'Handel in 30 echte cryptocurrencies. Koop en verkoop direct, of automatiseer via limit-, stop-loss- en take-profit orders. Volg live grafieken en beheer je positie via de coin-popup.',
    summaryEn:
        'Trade 30 real cryptocurrencies. Buy and sell directly or automate via limit, stop-loss and take-profit orders. Follow live charts and manage your position via the coin popup.',
    howNl: [
      'De cryptolijst toont 30 coins met actuele prijs, 24-uurs percentage en je huidige bezit per coin.',
      'Klik op een coin om de popup te openen met: live grafiek (tijdfilters 1u, 4u, 8u, 24u, 7d, 30d, Alles), koopgeschiedenis, gemiddelde aankoopprijs en koop/verkoop formulier.',
      'Directe trade: kies hoeveelheid en klik Koop of Verkoop. Uitvoering is onmiddellijk tegen de actuele marktprijs.',
      'Open orders: Limit (koop/verkoop op exacte doelprijs), Stop-loss (automatisch verkopen als koers daalt tot een grens), Take-profit (automatisch verkopen als koers stijgt tot een doel).',
      'Open orders worden automatisch uitgevoerd door de backend zodra de marktprijs de doelprijs bereikt. Je hoeft niet online te zijn.',
      'Marktregimes (Bull/Bear/Sideways) en nieuwsevents beïnvloeden prijsbewegingen. Regime-notificaties ontvang je via push als je dat hebt ingesteld.',
      'Weekelijks crypto-leaderboard: de speler met de hoogste gerealiseerde winst van die week wint een geldbedrag-beloning.',
      'Dagelijkse en wekelijkse missies (bijv. 3 winstgevende trades, diversifieer over 5 coins) geven extra beloningen bij voltooiing.',
      'Portfolio overzicht toont: totale waarde, inleg, ongerealiseerde en gerealiseerde winst/verlies.',
    ],
    howEn: [
      'The crypto list shows 30 coins with current price, 24-hour percentage and your current holding per coin.',
      'Click a coin to open the popup with: live chart (time filters 1h, 4h, 8h, 24h, 7d, 30d, All), purchase history, average buy price and buy/sell form.',
      'Direct trade: enter quantity and click Buy or Sell. Execution is immediate at the current market price.',
      'Open orders: Limit (buy/sell at an exact target price), Stop-loss (auto sell when price drops to a threshold), Take-profit (auto sell when price rises to a target).',
      'Open orders are executed automatically by the backend as soon as the market price hits the target. You do not need to be online.',
      'Market regimes (Bull/Bear/Sideways) and news events influence price movements. You receive regime notifications via push when enabled.',
      'Weekly crypto leaderboard: the player with the highest realized gain that week wins a cash reward.',
      'Daily and weekly missions (e.g. 3 profitable trades, diversify across 5 coins) give extra rewards on completion.',
      'Portfolio overview shows: total value, invested amount, unrealized and realized profit/loss.',
    ],
    tipsNl: [
      'Bekijk je koopgeschiedenis voor je een sell order plaatst: de popup toont je gemiddelde aankoopprijs, zodat je niet per ongeluk met verlies verkoopt.',
      'Gebruik stop-loss orders op elke positie die je niet actief volgt: ze beschermen je automatisch als je offline bent.',
      'Wissel tijdfilters in de grafiek: 1u en 4u tonen kortetermijntrend, 7d en 30d tonen groter plaatje.',
    ],
    tipsEn: [
      'Check your purchase history before placing a sell order: the popup shows your average buy price so you do not accidentally sell at a loss.',
      'Use stop-loss orders on every position you are not actively watching: they protect you automatically when you are offline.',
      'Switch time filters in the chart: 1h and 4h show short-term trend, 7d and 30d show the bigger picture.',
    ],
    protocolPath: 'docs/module-protocols/crypto.md',
  ),
  HelpTopic(
    id: 'smuggling',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.local_shipping,
    titleNl: 'Smokkelen',
    titleEn: 'Smuggling',
    summaryNl:
        'Verplaats illegale goederen tussen landen voor hoge marges. Kies route, kanaal en timing zorgvuldig want een mislukte smokkelpoging kost je de hele lading.',
    summaryEn:
        'Move illegal goods between countries for high margins. Choose route, channel and timing carefully because a failed smuggling attempt costs you the entire shipment.',
    howNl: [
      'Kies categorie (drugs, wapens, materials), het specifieke item, de bestemming en het transportkanaal (auto, boot, vliegtuig, crew-netwerk).',
      'De quote toont: transportkosten, geschatte opbrengst op bestemming, slagingskans en verwachte nettomarge.',
      'Slagingskans hangt af van: transportkanaal, je huidige Wanted Level, FBI Heat en de gekozen route (korte routes zijn veiliger).',
      'Bij mislukking verlies je de volledige lading. Je krijgt geen vergoeding. Lading en transportkosten zijn weg.',
      'Actieve shipments worden live gevolgd in een overzicht. Na aankomst verschijnt de lading in een depot klaar voor ophalen.',
      'Depot-inhoud vervalt na een bepaalde tijd als je niet ophaalt. Check je actieve shipments regelmatig.',
      'Crew-netwerk als kanaal verhoogt slagingskans maar vereist dat meerdere crew-leden actief zijn.',
      'Hoge marges zijn mogelijk door goedkoop in te kopen (Colombia voor drugs, zwarte markt voor wapens) en duur te verkopen op de bestemming.',
    ],
    howEn: [
      'Choose category (drugs, weapons, materials), the specific item, the destination and the transport channel (car, boat, plane, crew network).',
      'The quote shows: transport cost, estimated value at destination, success chance and expected net margin.',
      'Success chance depends on: transport channel, your current Wanted Level, FBI Heat and chosen route (short routes are safer).',
      'On failure you lose the entire shipment. No refund. Cargo and transport costs are gone.',
      'Active shipments are tracked live in an overview. After arrival the cargo appears in a depot ready for collection.',
      'Depot contents expire after a set time if not collected. Check your active shipments regularly.',
      'Crew network as channel increases success chance but requires multiple active crew members.',
      'High margins are possible by buying cheap (Colombia for drugs, black market for weapons) and selling high at destination.',
    ],
    tipsNl: [
      'Stuur nooit je volledige voorraad in één shipment: verdeel over meerdere kleinere ladingen om catastrofaal verlies te beperken.',
      'Verlaag Wanted Level en FBI Heat tot een minimum voor je een grote smokkelrun start.',
      'Haal altijd actieve depots zo snel mogelijk op: verlopen depot-inhoud is definitief verloren.',
    ],
    tipsEn: [
      'Never send your entire stock in one shipment: split across multiple smaller loads to limit catastrophic loss.',
      'Lower Wanted Level and FBI Heat to a minimum before starting a large smuggling run.',
      'Always collect active depots as fast as possible: expired depot contents are permanently lost.',
    ],
    protocolPath: 'docs/module-protocols/smuggling.md',
  ),
  HelpTopic(
    id: 'tools',
    categoryNl: 'Beheer',
    categoryEn: 'Management',
    icon: Icons.build,
    titleNl: 'Gereedschap',
    titleEn: 'Tools',
    summaryNl:
        'Koop en beheer gereedschappen die nodig zijn voor specifieke misdaden. Goede tools verhogen je slagingskans, versleten tools verlagen hem.',
    summaryEn:
        'Buy and manage tools required for specific crimes. Good tools raise your success chance, worn tools lower it.',
    howNl: [
      'De tool-shop toont alle beschikbare items met prijs, conditie-rating en het type crime waarvoor ze vereist zijn.',
      'Elke crimecategorie heeft voorkeur-tools: inbraak vereist breekijzer of picks, autodiefstal vereist hotwire-kit, beroving vereist vuurwapen.',
      'Tools hebben een conditie (0-100%). Elke succesvolle of mislukte crime verlaagt conditie met een paar procent.',
      'Onder 20% conditie daalt de slagingskansbonus van de tool drastisch. Onder 5% heeft de tool nauwelijks meer effect.',
      'Gerepareerde tools via de shop kosten een fractie van de aanschafprijs. Vervangen is soms goedkoper dan repareren bij zware slijtage.',
      'Tools zijn zichtbaar in je inventaris-tab. Je kunt meerdere exemplaren van hetzelfde type bewaren als backup.',
    ],
    howEn: [
      'The tool shop shows all available items with price, condition rating and the crime type they are required for.',
      'Each crime category has preferred tools: burglary requires crowbar or picks, car theft requires a hotwire kit, robbery requires a firearm.',
      'Tools have a condition rating (0-100%). Each successful or failed crime lowers condition by a few percent.',
      'Below 20% condition the tool\'s success chance bonus drops drastically. Below 5% the tool has almost no effect.',
      'Repaired tools through the shop cost a fraction of the purchase price. Replacement is sometimes cheaper than repair for heavily worn tools.',
      'Tools are visible in your inventory tab. You can keep multiple copies of the same type as backup.',
    ],
    tipsNl: [
      'Koop tools in bulk als ze laag geprijsd zijn op de zwarte markt: je bespaart t.o.v. de shop.',
      'Stel een persoonlijke drempel in: vervang tools altijd als conditie onder 25% daalt om slagingskans stabiel te houden.',
    ],
    tipsEn: [
      'Buy tools in bulk when they are cheap on the black market: you save compared to the shop.',
      'Set a personal threshold: always replace tools when condition drops below 25% to keep success chances stable.',
    ],
    protocolPath: 'docs/module-protocols/tools.md',
  ),
  HelpTopic(
    id: 'court',
    categoryNl: 'Risico',
    categoryEn: 'Risk',
    icon: Icons.gavel,
    titleNl: 'Rechtbank',
    titleEn: 'Court',
    summaryNl:
        'Tijdens je straf kun je hoger beroep indienen of de rechter proberen om te kopen om sneller vrij te komen.',
    summaryEn:
        'During your sentence you can file an appeal or try to bribe the judge to get released sooner.',
    howNl: [
      'Als je vastzit zie je in de rechtbank je actieve veroordeling met resterende tijd, delict en rechterprofiel.',
      'Hoger beroep kost geld op basis van je huidige strafduur. Bij toekenning wordt je straf meestal met ongeveer 20-40% verlaagd.',
      'Hoger beroep kun je maar een keer per veroordeling doen en er zit een cooldown op herhaald indienen.',
      'Omkoping werkt met een zelfgekozen bedrag. Dat bedrag wordt altijd afgeschreven, ook wanneer de poging mislukt.',
      'Een hogere omkoopsom geeft een betere slagingskans. Bij succes word je direct vrijgelaten.',
      'Je strafblad blijft zichtbaar, ook als je niet meer vastzit.',
    ],
    howEn: [
      'When jailed, the court screen shows your active conviction with remaining time, crime and judge profile.',
      'An appeal costs money based on your current sentence length. If granted, your sentence is usually reduced by about 20-40%.',
      'You can appeal only once per conviction and a cooldown applies to rapid retries.',
      'Bribery uses a player-selected amount. That amount is always deducted, even when the attempt fails.',
      'A higher bribe amount increases success chance. On success, you are released immediately.',
      'Your criminal record remains visible even when you are no longer jailed.',
    ],
    tipsNl: [
      'Gebruik hoger beroep bij lange straffen: de verwachte tijdswinst is dan het grootst.',
      'Gebruik omkoping alleen met voldoende buffer, omdat je in alle gevallen betaalt.',
    ],
    tipsEn: [
      'Use appeals on long sentences first: expected time saved is highest there.',
      'Use bribery only with enough cash buffer, because payment is always deducted.',
    ],
    protocolPath: 'docs/module-protocols/court.md',
  ),
  HelpTopic(
    id: 'hitlist',
    categoryNl: 'Risico',
    categoryEn: 'Risk',
    icon: Icons.gps_fixed,
    titleNl: 'Hitlist',
    titleEn: 'Hitlist',
    summaryNl:
        'Zet een bounty op een vijand of neem een hitcontract aan. Elimineer je doelwit in hetzelfde land voor de volledige payout.',
    summaryEn:
        'Place a bounty on an enemy or accept a hit contract. Eliminate your target in the same country for the full payout.',
    howNl: [
      'Via de hitlist kun je een speler toevoegen door een bounty in te stellen. Minimumbounty is €5.000. De betaler verliest dit geld direct.',
      'Actieve hits zijn zichtbaar voor alle spelers. Hoe hoger de bounty, hoe meer aandacht het contract trekt.',
      'Om een hit uit te voeren moet je in hetzelfde land zijn als je doelwit. Je valt aan via het spelersprofiel.',
      'Gevecht wordt automatisch berekend op basis van: bewapening, armor, stats (kracht, reflexen), crew-bonussen en actief niveau.',
      'Bij een succesvolle eliminatie ontvang je de volledige bounty. Mislukt de aanval dan verlies je HP en het doelwit blijft leven.',
      'Doelwitten met een actieve bodyguard of bewakingsbeveiliging zijn moeilijker te raken.',
      'Je kunt je eigen naam van de hitlist verwijderen door de plaatser te betalen of de bounty zelf over te nemen.',
    ],
    howEn: [
      'Via the hitlist you add a player by setting a bounty. Minimum bounty is €5,000. The payer loses this money immediately.',
      'Active hits are visible to all players. The higher the bounty, the more attention the contract attracts.',
      'To execute a hit you must be in the same country as your target. You attack via the player profile.',
      'Combat is auto-calculated based on: weapons, armor, stats (strength, reflexes), crew bonuses and active level.',
      'On successful elimination you receive the full bounty. If the attack fails you lose HP and the target survives.',
      'Targets with an active bodyguard or security protection are harder to hit.',
      'You can remove your own name from the hitlist by paying the placer or buying out the bounty yourself.',
    ],
    tipsNl: [
      'Check de hitlist dagelijks: hoge bounties op zwakke spelers zijn snelle winst als je in hetzelfde land zit.',
      'Leg een bounty alleen op een speler als je aanwijzingen hebt dat ze offline zijn of laag in HP.',
    ],
    tipsEn: [
      'Check the hitlist daily: high bounties on weak players are quick profit if you are in the same country.',
      'Only place a bounty on a player when you have reason to believe they are offline or low on HP.',
    ],
    protocolPath: 'docs/module-protocols/hitlist.md',
  ),
  HelpTopic(
    id: 'security',
    categoryNl: 'Risico',
    categoryEn: 'Risk',
    icon: Icons.shield,
    titleNl: 'Beveiliging',
    titleEn: 'Security',
    summaryNl:
        'Bescherm je karakter en empire met armor, bodyguards en installatiebeveiliging. Hoe beter je beveiliging, hoe minder schade je oploopt bij aanvallen.',
    summaryEn:
        'Protect your character and empire with armor, bodyguards and installation security. Better security means less damage taken during attacks.',
    howNl: [
      'Armor-types in oplopende sterkte: Geen armor → Kevlar Vest → Militair Vest → Titanium Plating → Speciale gepantserde harnas.',
      'Elke armor-klasse verlaagt inkomende schade per aanval met een vast percentage. Betere armor = meer overleving bij PvP en raids.',
      'Armor raakt na een aanval beschadigd en verliest effectiviteit. Check conditie regelmatig en vervang of repareer op tijd.',
      'Bodyguards blokkeren een deel van hitlist-aanvallen automatisch: ze absorberen de eerste klap of laten de aanval mislukken.',
      'Installatiebeveiliging (voor nightclub, drugs-faciliteit, etc.) verlaagt kans op raids en incidenten bij die locatie.',
      'Hoe hoger je Wanted Level hoe vaker je wordt aangevallen of geraided. Betere beveiliging compenseert dit direct.',
      'Crew-leden kunnen beveiligingsrollen verdelen zodat meerdere locaties gelijktijdig gedekt zijn.',
    ],
    howEn: [
      'Armor types in ascending strength: No armor → Kevlar Vest → Military Vest → Titanium Plating → Special armored harness.',
      'Each armor class reduces incoming damage per attack by a fixed percentage. Better armor = more survival in PvP and raids.',
      'Armor gets damaged after an attack and loses effectiveness. Check condition regularly and replace or repair in time.',
      'Bodyguards automatically block a portion of hitlist attacks: they absorb the first hit or cause the attack to fail entirely.',
      'Installation security (for nightclub, drug facility, etc.) lowers raid and incident chance at that specific location.',
      'The higher your Wanted Level the more often you are attacked or raided. Better security compensates for this directly.',
      'Crew members can split security roles so multiple locations are covered simultaneously.',
    ],
    tipsNl: [
      'Draag altijd minimaal een Kevlar Vest als je Wanted Level 2 of hoger is: besparing op ziekenhuisrekeningen compenseert de aanschafprijs snel.',
      'Repareer armor na elk zwaar gevecht: een beschadigd vest geeft maar 30-40% van de originele bescherming.',
    ],
    tipsEn: [
      'Always carry at least a Kevlar Vest when Wanted Level is 2 or higher: savings on hospital bills quickly offset the purchase price.',
      'Repair armor after every heavy fight: a damaged vest provides only 30-40% of its original protection.',
    ],
    protocolPath: 'docs/module-protocols/security.md',
  ),
  HelpTopic(
    id: 'hospital',
    categoryNl: 'Recovery',
    categoryEn: 'Recovery',
    icon: Icons.local_hospital,
    titleNl: 'Ziekenhuis',
    titleEn: 'Hospital',
    summaryNl:
        'Herstel HP na gevechten, mislukte crimes of raids. Het ziekenhuis biedt gratis spoedzorg en betaalde behandelingen voor sneller herstel.',
    summaryEn:
        'Recover HP after fights, failed crimes or raids. The hospital offers free emergency care and paid treatments for faster recovery.',
    howNl: [
      'Val je onder 10 HP dan word je automatisch opgenomen op de Eerste Hulp (ER). Dit is gratis maar duurt langer.',
      'Betaalde behandeling kost €10.000 per sessie en herstelt +30 HP. Cooldown: 60 minuten tussen twee betaalde behandelingen.',
      'ICU (Intensive Care) is de zwaarste behandeling voor kritieke schade. Cooldown: 180 minuten. Kosten zijn hoger maar herstel is completer.',
      'Bij hogere HP (50+) kun je gewoon acties uitvoeren maar ben je kwetsbaarder bij aanvallen.',
      'Hospital-behandelingen zijn geblokkeerd terwijl je in de gevangenis zit. Eerst vrijkomen, dan behandeling.',
      'School-certificaat Geneeskunde verlaagt ziekenhuiskosten en versnelt hersteltijden.',
      'Crew-medics of Medic-skills kunnen HP herstellen buiten het ziekenhuis om als extra noodherstel.',
    ],
    howEn: [
      'Fall below 10 HP and you are automatically admitted to the Emergency Room (ER). This is free but takes longer.',
      'Paid treatment costs €10,000 per session and restores +30 HP. Cooldown: 60 minutes between paid treatments.',
      'ICU (Intensive Care) is the heaviest treatment for critical damage. Cooldown: 180 minutes. Costs are higher but recovery is more complete.',
      'With higher HP (50+) you can still perform actions but are more vulnerable to attacks.',
      'Hospital treatments are blocked while you are in prison. Get out first, then seek treatment.',
      'School certificate in Medicine lowers hospital costs and speeds up recovery times.',
      'Crew medics or medic skills can restore HP outside the hospital as emergency recovery.',
    ],
    tipsNl: [
      'Herstel nooit half: wacht tot je full HP bent voor je PvP of gevaarlijke crimes uitvoert.',
      'Plan betaalde behandelingen rond de cooldown: start een behandeling vlak voordat je offline gaat zodat je online komt met vol HP.',
    ],
    tipsEn: [
      'Never recover halfway: wait for full HP before doing PvP or high-risk crimes.',
      'Time paid treatments around cooldown: start a treatment just before going offline so you come back online at full HP.',
    ],
    protocolPath: 'docs/module-protocols/hospital.md',
  ),
  HelpTopic(
    id: 'prison',
    categoryNl: 'Recovery',
    categoryEn: 'Recovery',
    icon: Icons.gpp_bad,
    titleNl: 'Gevangenis',
    titleEn: 'Prison',
    summaryNl:
        'Zit je gevangenisstraf uit, betaal borgtocht of probeer te ontsnappen. Hoe hoger je Wanted Level, hoe langer en duurder je straf.',
    summaryEn:
        'Serve your prison sentence, pay bail or attempt to escape. The higher your Wanted Level the longer and more expensive your sentence.',
    howNl: [
      'Na arrestatie start een timer op basis van Wanted Level. Wanted Level 1 = korte straf (minuten), Wanted Level 5+ = uren gevangenisstraf.',
      'Borgtocht: Wanted Level × €1.000. Betaal dit bedrag om direct vrij te komen. Bij Wanted 5 kost borgtocht €5.000.',
      'Ontsnappen: je kunt een ontsnappingspoging wagen maar de slagingskans is laag. Mislukking verlengt je straftijd met een vast bedrag.',
      'Crewleden kunnen je bezoeken en kleine voordelen geven (stats, moreel) terwijl je vastzit.',
      'Wapen- en armor-bezit wordt geconfisceerd bij arrest als je er geen legale dekking voor hebt.',
      'Rechtbank-optie: ga naar de rechtbank voor strafvermindering via advocaat (zie Rechtbank).',
      'Terwijl je vastzit lopen productie-timers (drugs, ammo-factory) gewoon door. Je empire werkt zonder je.',
      'Je kunt het ziekenhuis niet bezoeken terwijl je vastzit. HP-herstel wacht tot je vrij bent.',
    ],
    howEn: [
      'After arrest a timer starts based on Wanted Level. Wanted Level 1 = short sentence (minutes), Wanted Level 5+ = hours in prison.',
      'Bail: Wanted Level × €1,000. Pay this amount to be released immediately. At Wanted 5 bail costs €5,000.',
      'Escape: you can attempt a prison break but success chance is low. Failure extends your sentence by a fixed amount.',
      'Crew members can visit you and provide small benefits (stats, morale) while you are locked up.',
      'Weapons and armor are confiscated on arrest if you have no legal cover for them.',
      'Court option: go to court for a sentence reduction via a lawyer (see Court).',
      'While locked up production timers (drugs, ammo factory) keep running. Your empire works without you.',
      'You cannot visit the hospital while locked up. HP recovery waits until you are free.',
    ],
    tipsNl: [
      'Betaal altijd borgtocht als de timer langer dan 30 minuten is: de kosten zijn laag en de tijdsbesparing is groot.',
      'Start productie-timers vlak voordat je een gevaarlijke crimerun doet: als je gepakt wordt loopt de productie in ieder geval door.',
    ],
    tipsEn: [
      'Always pay bail when the timer is longer than 30 minutes: the cost is low and the time saved is significant.',
      'Start production timers just before doing a high-risk crime run: if you get caught production keeps running anyway.',
    ],
    protocolPath: 'docs/module-protocols/prison.md',
  ),
  HelpTopic(
    id: 'garage',
    categoryNl: 'Assets',
    categoryEn: 'Assets',
    icon: Icons.directions_car,
    titleNl: 'Garage',
    titleEn: 'Garage',
    summaryNl:
        'Steel en beheer auto\'s en motoren voor crimes en smokkelen. In Garage beheer je bezit, timed repairs, verkoop en sloop; transport loopt via Smuggling Hub.',
    summaryEn:
        'Steal and manage cars and motorcycles for crimes and smuggling. Garage handles ownership, timed repairs, selling and scrapping; transport runs through Smuggling Hub.',
    howNl: [
      'Je garage toont auto\'s en motoren met conditie (0-100%), brandstof, marktwaarde, zeldzaamheid en world-cap status.',
      'Via de catalogus-knop zie je alle steelbare auto\'s en motoren, inclusief in welk land ze het meest voorkomen en in welke landen ze kunnen spawnen.',
      'Diefstal werkt per voertuig met rank-eisen en cooldown. Hoe duurder en zeldzamer, hoe lager de kans op succes.',
      'Als de world-cap van een model vol is, kun je dat model tijdelijk niet stelen. Bij verkoop of sloop van dat model komt er direct weer 1 slot vrij.',
      'Mislukte diefstal verhoogt Wanted Level en kan arrestatie triggeren. Plan diefstal daarom bij lage heat.',
      'Reparatie is getimed: je betaalt direct, het voertuig gaat in reparatie en komt pas terug na de timer.',
      'Gelijktijdige reparaties zijn beperkt: zonder VIP max 1 actief, met VIP max 5 actief.',
      'Sloop is een alternatief voor verkoop: je krijgt schrootwaarde (35% van basiswaarde), geschaald door conditie en garage-upgrade bonus.',
      'Transport van voertuigen gebeurt niet in Garage maar via Smuggling Hub.',
      'Doorverkoop en sloop maken ruimte vrij in je garagecapaciteit en openen mogelijk world-cap slots voor dat model.',
      'Event-only voertuigen zoals politie-interceptor blijven normaal vergrendeld buiten eventvensters.',
    ],
    howEn: [
      'Your garage shows cars and motorcycles with condition (0-100%), fuel, market value, rarity and world-cap status.',
      'Using the catalog button you can view all stealable cars and motorcycles, including their most common country and full spawn country list.',
      'Theft is per vehicle with rank requirements and cooldowns. The more expensive and rare, the lower your success chance.',
      'If a model world-cap is full, you cannot steal that model temporarily. When a copy is sold or scrapped, 1 slot reopens immediately.',
      'Failed theft increases Wanted Level and can trigger arrest. Plan theft attempts when heat is low.',
      'Repairs are timed: you pay upfront, the vehicle enters repair and only returns after the timer finishes.',
      'Concurrent repairs are limited: without VIP max 1 active, with VIP max 5 active.',
      'Scrapping is an alternative to selling: you receive salvage value (35% of base value), scaled by condition and garage upgrade bonus.',
      'Vehicle transport no longer happens in Garage; use the Smuggling Hub flow.',
      'Resale and scrapping free garage capacity and may reopen world-cap slots for that model.',
      'Event-only vehicles such as police interceptors stay locked outside event windows.',
    ],
    tipsNl: [
      'Steel voertuigen actief als je Wanted Level laag is: hogere Wanted = hogere mislukkingskans bij diefstal.',
      'Houd altijd minimaal één betrouwbaar voertuig op hoge conditie voor smokkelen: een kapot voertuig halveeert je slagingskans.',
      'Gebruik sloop voor zwaar beschadigde voertuigen als snelle capaciteit-reset; verkoop is vaak beter bij hoge conditie.',
    ],
    tipsEn: [
      'Steal vehicles actively when Wanted Level is low: higher Wanted = higher failure chance when stealing.',
      'Always keep at least one reliable vehicle at high condition for smuggling: a broken vehicle halves your success chance.',
      'Use scrapping for heavily damaged vehicles as a fast capacity reset; selling is often better at high condition.',
    ],
    protocolPath: 'docs/module-protocols/garage.md',
  ),
  HelpTopic(
    id: 'marina',
    categoryNl: 'Assets',
    categoryEn: 'Assets',
    icon: Icons.directions_boat,
    titleNl: 'Marina',
    titleEn: 'Marina',
    summaryNl:
        'Beheer boten met zeldzaamheid, world-cap en reparatietimers voor maritieme smokkelroutes. Marina richt zich op bezit, onderhoud, verkoop en sloop; transport loopt via Smuggling Hub.',
    summaryEn:
        'Manage boats with rarity, world caps and repair timers for maritime smuggling routes. Marina focuses on ownership, maintenance, selling and scrapping; transport runs through Smuggling Hub.',
    howNl: [
      'De marina toont je boten met conditie, brandstof, marktwaarde, zeldzaamheid en world-cap status per model.',
      'Via de catalogus-knop zie je alle steelbare boten, inclusief meest voorkomend land en volledige landenlijst.',
      'Bootdiefstal heeft eigen rank-eisen en cooldowns. Duurdere boten zijn lastiger te stelen maar leveren meer op.',
      'Als de world-cap van een boottype vol is, verdwijnt dat type tijdelijk uit de beschikbare lijst. Verkoop/sloop opent weer slots.',
      'Reparatie is getimed: je betaalt direct en de boot blijft onbruikbaar tot de timer voltooid is.',
      'Gelijktijdige reparaties zijn beperkt: zonder VIP max 1 actief, met VIP max 5 actief.',
      'Sloop geeft schrootwaarde (35% van basiswaarde), geschaald met conditie en marina-upgrade bonus.',
      'Marina beheert alleen bezit en onderhoud; daadwerkelijke transportkeuzes gebeuren in Smuggling Hub.',
      'Event-only politieboten zijn bedoeld voor tijdelijke events en blijven buiten events vergrendeld.',
    ],
    howEn: [
      'The marina shows your boats with condition, fuel, market value, rarity and world-cap status per model.',
      'Using the catalog button you can view all stealable boats, including most common country and full spawn country list.',
      'Boat theft has its own rank gates and cooldowns. More expensive boats are harder to steal but can be more profitable.',
      'If a boat model world-cap is full, it temporarily disappears from the available list. Selling/scrapping reopens slots.',
      'Repairs are timed: you pay upfront and the boat is unavailable until the timer completes.',
      'Concurrent repairs are limited: without VIP max 1 active, with VIP max 5 active.',
      'Scrapping grants salvage value (35% of base value), scaled with condition and marina upgrade bonus.',
      'Marina manages ownership and maintenance only; actual transport routing happens in Smuggling Hub.',
      'Event-only police boats are for temporary events and remain locked outside event windows.',
    ],
    tipsNl: [
      'Investeer in de marina als je smokkelroutes regelmatig via water lopen: lagere politie-interest kan de kans op succes significant verhogen.',
      'Houd een speedboot op hoge conditie als snel alternatief wanneer vluchtroutes over land geblokkeerd zijn.',
      'Sloop vooral zwaar beschadigde boten met lage verkoopwaarde, zodat je sneller world-cap ruimte en havencapaciteit vrijmaakt.',
    ],
    tipsEn: [
      'Invest in the marina if your smuggling routes regularly go via water: lower police interest can significantly boost success chance.',
      'Keep a speedboat at high condition as a quick alternative when land escape routes are blocked.',
      'Scrap heavily damaged boats with low resale value to free world-cap room and marina capacity faster.',
    ],
    protocolPath: 'docs/module-protocols/marina.md',
  ),
  HelpTopic(
    id: 'tuneshop',
    categoryNl: 'Assets',
    categoryEn: 'Assets',
    icon: Icons.tune,
    titleNl: 'TuneShop',
    titleEn: 'Tune Shop',
    summaryNl:
        'Gebruik onderdelen uit sloop om voertuigen per categorie te upgraden. Verbeter snelheid, stealth en pantser met oplopende levelkosten en category-cooldowns.',
    summaryEn:
        'Use salvaged parts to upgrade vehicles by category. Improve speed, stealth and armor with scaling level costs and category cooldowns.',
    howNl: [
      'Je verdient onderdelen door voertuigen te slopen: auto-onderdelen, motor-onderdelen en boot-onderdelen.',
      'Onderdelen zijn category-pooled: elk voertuig in dezelfde categorie gebruikt dezelfde parts-voorraad.',
      'Elke upgrade kost onderdelen én geld. Geldkosten zijn category-based en stijgen per tuninglevel.',
      'Je kunt drie stats upgraden: snelheid, stealth en pantser.',
      'Tuning is per voertuig in je inventory. Nieuwe voertuigen starten weer op level 0.',
      'Na elke tune geldt een cooldown per voertuig: auto 180s, motor 120s, boot 240s.',
      'Gelijktijdige tuning is beperkt: zonder VIP max 1 actief voertuig in tuning-cooldown, met VIP max 5.',
      'Getunede voertuigen leveren hogere verkoop- en schrootwaarde op.',
      'Tunen is geblokkeerd als een voertuig in reparatie of transport staat.',
    ],
    howEn: [
      'You earn parts by scrapping vehicles: car parts, motorcycle parts and boat parts.',
      'Parts are category pooled: any vehicle in the same category uses the same parts stock.',
      'Each upgrade costs parts and money. Money costs are category based and increase per tuning level.',
      'You can upgrade three stats: speed, stealth and armor.',
      'Tuning is per vehicle in your inventory. New vehicles start at level 0 again.',
      'After each tune there is a per-vehicle cooldown: car 180s, motorcycle 120s, boat 240s.',
      'Concurrent tuning is limited: without VIP max 1 active vehicle in tuning cooldown, with VIP max 5.',
      'Tuned vehicles yield higher sell and salvage value.',
      'Tuning is blocked while a vehicle is in repair or transport.',
    ],
    tipsNl: [
      'Sloop zwaar beschadigde voertuigen eerst om snel onderdelen op te bouwen.',
      'Investeer vroeg in stealth voor lagere pakkans tijdens risicovolle runs.',
      'Gebruik pantser-upgrades op voertuigen die je vaak in gevaarlijke loops inzet.',
    ],
    tipsEn: [
      'Scrap heavily damaged vehicles first to build parts quickly.',
      'Invest in stealth early for lower capture risk on high-risk runs.',
      'Use armor upgrades on vehicles you repeatedly deploy in dangerous loops.',
    ],
    protocolPath: 'docs/module-protocols/tuneshop.md',
  ),
  HelpTopic(
    id: 'shooting-range',
    categoryNl: 'Training',
    categoryEn: 'Training',
    icon: Icons.gps_fixed,
    titleNl: 'Schietschool',
    titleEn: 'Shooting Range',
    summaryNl:
        'Verbeter je nauwkeurigheid en wapenvaardigheid via gestructureerde schietoefeningen. Hogere stats verhogen schade en trefkans in PvP en crimes.',
    summaryEn:
        'Improve your accuracy and weapon skill through structured shooting drills. Higher stats increase damage and hit chance in PvP and crimes.',
    howNl: [
      'De schietschool biedt meerdere disciplines: pistool, geweer, shotgun en automatisch vuur. Elk traint een aparte wapenvaardigheid.',
      'Elke trainingssessie heeft een cooldown van 30 minuten. Je kunt niet onbeperkt trainen per dag.',
      'Hogere nauwkeurigheid verhoogt je trefkans in PvP gevechten en verlaagt de kans dat je zelf geraakt wordt.',
      'Wapenvaardigheid bepaalt ook welke wapens je effectief kunt gebruiken: een sniper rifle vereist een bepaalde skill voordat je zijn volle bonus benut.',
      'Trainingsresultaten stapelen cumulatief op. Er is geen reset tenzij je een zware boete via de rechtbank krijgt.',
      'School-certificaat Militair Training geeft een permanente bonus op elke schietschool-sessie.',
    ],
    howEn: [
      'The shooting range offers multiple disciplines: pistol, rifle, shotgun and automatic fire. Each trains a separate weapon skill.',
      'Each training session has a cooldown of 30 minutes. You cannot train endlessly per day.',
      'Higher accuracy increases your hit chance in PvP fights and lowers the chance of being hit yourself.',
      'Weapon skill also determines which weapons you can use effectively: a sniper rifle requires a certain skill before you get its full bonus.',
      'Training results stack cumulatively. There is no reset unless you receive a heavy penalty via the court.',
      'School certificate Military Training gives a permanent bonus to each shooting range session.',
    ],
    tipsNl: [
      'Train de schietschool elke dag: kleine cumulatieve bonussen worden na een week al merkbaar in PvP-uitkomsten.',
      'Train het wapen-type dat je het meest gebruikt in crimes en PvP voor maximale return on investment.',
    ],
    tipsEn: [
      'Train the shooting range every day: small cumulative bonuses become noticeable in PvP outcomes within a week.',
      'Train the weapon type you use most in crimes and PvP for maximum return on investment.',
    ],
    protocolPath: 'docs/module-protocols/shooting-range.md',
  ),
  HelpTopic(
    id: 'gym',
    categoryNl: 'Training',
    categoryEn: 'Training',
    icon: Icons.fitness_center,
    titleNl: 'Sportschool',
    titleEn: 'Gym',
    summaryNl:
        'Train kracht, snelheid en uithoudingsvermogen voor betere stats in PvP, crimes en HP-pool. Dagelijkse training is de sleutel tot snelle stat-groei.',
    summaryEn:
        'Train strength, speed and stamina for better stats in PvP, crimes and HP pool. Daily training is key to fast stat growth.',
    howNl: [
      'De sportschool biedt drie trainingscategorieën: Kracht (meer schade per aanval), Snelheid (hogere reflexen, minder geraakt worden), Uithoudingsvermogen (hogere max HP).',
      'Elke training heeft een cooldown van 1 uur. Maximaal 6-8 sessies per dag afhankelijk van je school-certificaat.',
      'Kracht verhoogt directe schade in zowel PvP als bepaalde crime-typen (beroving, vechtpartij).',
      'Snelheid verhoogt de kans om een aanval te ontwijken en verlaagt de kans dat je gevangen wordt bij crime-mislukking.',
      'Uithoudingsvermogen verhoogt je max HP-pool. Meer HP = langer overleven in PvP en meer ruimte voor risicovolle crimes.',
      'School-certificaat Lichaamstraining geeft +15% bonus op alle gym-sessies.',
    ],
    howEn: [
      'The gym offers three training categories: Strength (more damage per attack), Speed (higher reflexes, less hits taken), Stamina (higher max HP).',
      'Each training has a 1 hour cooldown. Maximum 6-8 sessions per day depending on your school certificate.',
      'Strength increases direct damage in both PvP and certain crime types (robbery, brawl).',
      'Speed increases the chance to dodge an attack and lowers the chance of being caught on crime failure.',
      'Stamina increases your max HP pool. More HP = surviving longer in PvP and more room for risky crimes.',
      'School certificate Physical Training gives +15% bonus to all gym sessions.',
    ],
    tipsNl: [
      'Train Uithoudingsvermogen als prioriteit: een hogere HP-pool verbetert al je andere systems because je langer actief blijft.',
      'Combineer gym met schietschool: Kracht + Nauwkeurigheid is de sterkste PvP-combinatie.',
    ],
    tipsEn: [
      'Prioritize Stamina training: a higher HP pool improves all your other systems because you stay active longer.',
      'Combine gym with shooting range: Strength + Accuracy is the strongest PvP combination.',
    ],
    protocolPath: 'docs/module-protocols/gym.md',
  ),
  HelpTopic(
    id: 'ammo-factory',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.factory,
    titleNl: 'Ammo Factory',
    titleEn: 'Ammo Factory',
    summaryNl:
        'Produceer munitie voor eigen gebruik of verkoop via de markt. Een goed gerunde ammo-factory is een stabiele inkomstenstroom en vermindert je afhankelijkheid van de zwarte markt.',
    summaryEn:
        'Produce ammunition for personal use or market sale. A well-run ammo factory is a stable income stream and reduces your dependency on the black market.',
    howNl: [
      'De ammo-factory heeft productieniveaus (Level 1 t/m 5). Hoger level = meer output per productieronde en betere kwaliteit.',
      'Je hebt grondstoffen nodig (metalen, chemicaliën) die je via de zwarte markt of handel aanschaft.',
      'Productietimers lopen door terwijl je offline bent. Check terug als de timer klaar is om output te verzamelen.',
      'Je kunt geproduceerde munitie: zelf gebruiken bij crimes en PvP, verkopen op de zwarte markt of trade aan crewleden.',
      'Upgrades kopen verhoogt output-volume, verlaagt productietimer en opent hogere kalibers (meer waarde per eenheid).',
      'Marktprijs van ammo fluctueert met vraag. Sla ammo op als de prijs laag is en verkoop als de prijs hoog is.',
      'Bij een raid op je factory verlies je een deel van de opgeslagen output. Beveiliging verlaagt dit risico.',
    ],
    howEn: [
      'The ammo factory has production levels (Level 1 through 5). Higher level = more output per production round and better quality.',
      'You need raw materials (metals, chemicals) purchased via the black market or trade.',
      'Production timers run while you are offline. Check back when the timer finishes to collect output.',
      'Produced ammo can be: used personally in crimes and PvP, sold on the black market or traded to crew members.',
      'Buying upgrades increases output volume, reduces production timer and unlocks higher calibres (more value per unit).',
      'Ammo market price fluctuates with demand. Stock up when prices are low and sell when prices are high.',
      'During a factory raid you lose part of stored output. Security lowers this risk.',
    ],
    tipsNl: [
      'Upgrade je factory zo snel mogelijk naar Level 3: de output-verdubbeling t.o.v. Level 1 maakt het zelfvoorzienend in ammo.',
      'Houd altijd 2-3 productieronden aan output in reserve als buffer zodat je nooit zonder ammo valt tijdens PvP.',
    ],
    tipsEn: [
      'Upgrade your factory to Level 3 as soon as possible: the doubled output compared to Level 1 makes it self-sufficient for ammo.',
      'Always keep 2-3 production rounds of output in reserve as a buffer so you never run out of ammo during PvP.',
    ],
    protocolPath: 'docs/module-protocols/ammo-factory.md',
  ),
  HelpTopic(
    id: 'school',
    categoryNl: 'Training',
    categoryEn: 'Training',
    icon: Icons.school,
    titleNl: 'School',
    titleEn: 'School',
    summaryNl:
        'Volg opleidingen in meerdere tracks om bonussen te ontgrendelen, kosten te verlagen en nieuwe systemen te openen. School is een multiplier op alles wat je doet.',
    summaryEn:
        'Follow courses in multiple tracks to unlock bonuses, reduce costs and open new systems. School is a multiplier on everything you do.',
    howNl: [
      'School biedt tracks per domein: Crimineel (betere crime stats), Economie (lagere handels- en bankkosten), Militair (combat bonussen), Geneeskunde (lagere ziekenhuiskosten), Rechten (lagere advocaatkosten), Technisch (betere factory en drugproductie).',
      'Elke les heeft een studietime van 15-60 minuten afhankelijk van het level. Hogere levels duren langer.',
      'Na het voltooien van een les ontvang je een certificaat voor dat track-level. Dit certificaat is permanent en geeft de bonus direct.',
      'Je kunt maar één les tegelijk volgen. Plan je studies zorgvuldig als je snel een specifiek certificaat nodig hebt.',
      'Schoolkosten stijgen per level. Hoger onderwijs vereist dat eerdere niveaus in hetzelfde track zijn voltooid.',
      'Sommige geavanceerde game-features zijn vergrendeld achter een schoolcertificaat: bv. toegang tot bepaalde jobs, hogere factory levels, VIP nightclub events.',
      'Certifcaten worden nooit gereset tenzij je account een zware straf ontvangt.',
    ],
    howEn: [
      'School offers tracks per domain: Criminal (better crime stats), Economy (lower trade and bank costs), Military (combat bonuses), Medicine (lower hospital costs), Law (lower lawyer costs), Technical (better factory and drug production).',
      'Each lesson has a study time of 15-60 minutes depending on level. Higher levels take longer.',
      'After completing a lesson you receive a certificate for that track level. This certificate is permanent and grants the bonus immediately.',
      'You can only follow one lesson at a time. Plan your studies carefully when you urgently need a specific certificate.',
      'School costs increase per level. Higher education requires earlier levels in the same track to be completed.',
      'Some advanced game features are locked behind a school certificate: e.g. access to certain jobs, higher factory levels, VIP nightclub events.',
      'Certificates are never reset unless your account receives a heavy penalty.',
    ],
    tipsNl: [
      'Start altijd met het Crimineel-track: de bonussen op crime-slagingskansen betalen de leerkosten binnen een paar sessies terug.',
      'Plan lange studies (60 min+) voor je gaat slapen: je wake-up met een nieuw certificaat zonder gemiste actietijd.',
    ],
    tipsEn: [
      'Always start with the Criminal track: bonuses to crime success chances pay back the study costs within a few sessions.',
      'Schedule long studies (60 min+) before going to sleep: you wake up with a new certificate without missing active time.',
    ],
    protocolPath: 'docs/module-protocols/school.md',
  ),
  HelpTopic(
    id: 'prostitution',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.favorite,
    titleNl: 'Prostitutie',
    titleEn: 'Prostitution',
    summaryNl:
        'Bouw een prostitutie-netwerk met recruits, events en VIP-klanten. Een goed gerund netwerk genereert passief geld maar vereist actief management om rivaliteit en politie-aandacht te beheersen.',
    summaryEn:
        'Build a prostitution network with recruits, events and VIP clients. A well-run network generates passive income but requires active management to control rivalry and police attention.',
    howNl: [
      'Je beheert recruits met elk hun eigen stats (ervaring, populariteit, beschikbaarheid). Meer recruits = hoger passief inkomen.',
      'Events zijn tijdelijke boosters: speciale optredens, VIP-avonden en feesten verhogen het inkomen per tick voor de duur van het event.',
      'Rivaliteit: andere spelers of NPC-concurrenten kunnen je recruits afpakken of events saboteren. Hogere beveiliging verlaagt dit risico.',
      'VIP-klanten betalen aanzienlijk meer maar vereisen recruits met hoge populariteit (80+) en een beveiligde locatie.',
      'Politie-aandacht (heat) stijgt bij grote transacties en raids. Hoge heat leidt tot confiscatie van inkomen of tijdelijke sluiting.',
      'Combinatie met nightclub: een nightclub biedt een legale dekking voor de activiteiten wat heat langzamer laat stijgen.',
      'Leaderboard: hoogste totale weekomzet wint een wekelijkse geldbeloning en een badge.',
    ],
    howEn: [
      'You manage recruits each with their own stats (experience, popularity, availability). More recruits = higher passive income.',
      'Events are temporary boosters: special shows, VIP nights and parties raise income per tick for the duration of the event.',
      'Rivalry: other players or NPC competitors can poach your recruits or sabotage events. Higher security lowers this risk.',
      'VIP clients pay considerably more but require recruits with high popularity (80+) and a secured location.',
      'Police attention (heat) rises with large transactions and raids. High heat leads to income confiscation or temporary shutdown.',
      'Combination with nightclub: a nightclub provides legal cover for activities making heat rise more slowly.',
      'Leaderboard: highest total weekly turnover wins a weekly cash reward and a badge.',
    ],
    tipsNl: [
      'Investeer vroeg in beveiliging: een rivaliteits-aanval die je beste recruit wegpakt kost je meer dan de beveiligingskosten.',
      'Organiseer VIP-events alleen als je recruits boven 80 populariteit hebt: onder die drempel betalen VIP-klanten gewoon normaaltarief.',
    ],
    tipsEn: [
      'Invest early in security: a rivalry attack that poaches your best recruit costs more than the security investment.',
      'Only organise VIP events when recruits are above 80 popularity: below that threshold VIP clients simply pay the standard rate.',
    ],
    protocolPath: 'docs/module-protocols/prostitution.md',
  ),
  HelpTopic(
    id: 'red-light-districts',
    categoryNl: 'Empire',
    categoryEn: 'Empire',
    icon: Icons.storefront,
    titleNl: 'Red Light Districts',
    titleEn: 'Red Light Districts',
    summaryNl:
        'Claim en beheer territoriale districten per land. Eigenaarschap van een district geeft passief inkomen en controle over prostitutie-activiteiten in die regio.',
    summaryEn:
        'Claim and manage territorial districts per country. Owning a district gives passive income and control over prostitution activities in that region.',
    howNl: [
      'Elk land heeft één of meerdere Red Light Districts die geclaimd kunnen worden. Claim een district door een vastgesteld aankoopbedrag te betalen.',
      'Als eigenaar van een district ontvang je een percentage van alle prostitutie-inkomsten in dat land — ook van andere spelers die er opereren.',
      'Andere spelers kunnen jouw district aanvallen om de ownership over te nemen. Hogere beveiliging verlaagt de aanvalskans.',
      'District-upgrades (beveiliging, marketing, infrastructuur) verhogen je inkomenspercentage en verlagen de kans op verlies van ownership.',
      'Je kunt maximaal 3 districten tegelijk bezitten. Strategische keuze per land is essentieel.',
      'Drukste landen (Colombia, Dubai, Japan) geven het hoogste passieve inkomen maar zijn ook het vaakst omstreden.',
      'Verlies van een district kost je het aankoopbedrag niet terug: het is definitief verloren als een vijand succesvol claimt.',
    ],
    howEn: [
      'Each country has one or more Red Light Districts that can be claimed. Claim a district by paying a set purchase amount.',
      'As owner of a district you receive a percentage of all prostitution income in that country — including from other players operating there.',
      'Other players can attack your district to take over ownership. Higher security lowers the attack chance.',
      'District upgrades (security, marketing, infrastructure) raise your income percentage and lower the chance of losing ownership.',
      'You can own up to 3 districts simultaneously. Strategic country choice is essential.',
      'Busiest countries (Colombia, Dubai, Japan) give the highest passive income but are also the most contested.',
      'Losing a district does not refund the purchase price: it is permanently lost if an enemy successfully claims it.',
    ],
    tipsNl: [
      'Begin met een minder populair land voor je eerste district: lagere aanvalsdruk geeft je tijd om security te upgraden voor het echte werk.',
      'Upgrade beveiliging van elk district direct na aankoop: de eerste 24 uur zijn het kwetsbaarst voor een takeover.',
    ],
    tipsEn: [
      'Start with a less popular country for your first district: lower attack pressure gives you time to upgrade security before the real competition.',
      'Upgrade security of each district immediately after purchase: the first 24 hours are the most vulnerable to a takeover.',
    ],
    protocolPath: 'docs/module-protocols/red-light-districts.md',
  ),
  HelpTopic(
    id: 'achievements',
    categoryNl: 'Meta',
    categoryEn: 'Meta',
    icon: Icons.emoji_events,
    titleNl: 'Prestaties',
    titleEn: 'Achievements',
    summaryNl:
        'Verdien badges door mijlpalen te bereiken in alle spelsystemen. Achievements geven beloningen, verhogen je statusprofiel en tonen je voortgang per categorie.',
    summaryEn:
        'Earn badges by reaching milestones across all game systems. Achievements give rewards, raise your status profile and show your progress per category.',
    howNl: [
      'Achievements zijn gegroepeerd in categorieën: Crimes, Empire, PvP, Economie, Training, Sociaal en Meta.',
      'Elke achievement heeft meerdere tiers (Brons, Zilver, Goud, Platina). Elk tier geeft een hogere beloning en een meer indrukwekkende badge.',
      'Beloningen per achievement zijn: cash, XP, speciale items, permanente bonussen of unieke titels voor je profiel.',
      'Progress wordt automatisch bijgehouden. Je hoeft niets te activeren: bereik de drempel en de badge wordt direct uitgedeeld.',
      'Sommige achievements zijn verborgen totdat je ze deels hebt voltooid — ze verschijnen dan met hun echte naam en eisen.',
      'Achievement-badges zijn zichtbaar op je openbare profiel. Ze tonen andere spelers je specialisaties en ervaring.',
      'Chain-achievements: sommige badges zijn gekoppeld in een keten. Goud vereist dat Zilver al behaald is. Plan vroeg voor de hogere tiers.',
    ],
    howEn: [
      'Achievements are grouped in categories: Crimes, Empire, PvP, Economy, Training, Social and Meta.',
      'Each achievement has multiple tiers (Bronze, Silver, Gold, Platinum). Each tier gives a higher reward and a more impressive badge.',
      'Rewards per achievement include: cash, XP, special items, permanent bonuses or unique titles for your profile.',
      'Progress is tracked automatically. You do not need to activate anything: reach the threshold and the badge is awarded immediately.',
      'Some achievements are hidden until you partially complete them — they then appear with their real name and requirements.',
      'Achievement badges are visible on your public profile. They show other players your specializations and experience.',
      'Chain achievements: some badges are linked in a chain. Gold requires Silver to be already obtained. Plan early for higher tiers.',
    ],
    tipsNl: [
      'Bekijk je bijna-voltooide achievements dagelijks: een kleine extra inspanning kan een badge en cash-beloning opleveren die anders maanden uitgesteld wordt.',
      'Richt je vroeg op de Economie- en Crime-categorieën: deze hebben de meeste cash-beloningen en zijn het makkelijkst te combineren met je normale gameplay.',
    ],
    tipsEn: [
      'Check your nearly-completed achievements daily: a small extra effort can earn a badge and cash reward that would otherwise be delayed for months.',
      'Focus early on Economy and Crime categories: these have the most cash rewards and are easiest to combine with your normal gameplay.',
    ],
    protocolPath: 'docs/module-protocols/achievements.md',
  ),
  HelpTopic(
    id: 'settings',
    categoryNl: 'Basis',
    categoryEn: 'Core',
    icon: Icons.settings,
    titleNl: 'Instellingen',
    titleEn: 'Settings',
    summaryNl:
        'Beheer alle accountinstellingen: taal, avatar, privacy, notificatievoorkeuren per systeem en beveiligingsopties. Instellingen zijn direct van invloed op je spelervaring.',
    summaryEn:
        'Manage all account settings: language, avatar, privacy, notification preferences per system and security options. Settings directly affect your gameplay experience.',
    howNl: [
      'Taal: schakel tussen Nederlands en Engels. Alle UI-teksten, systeemberichten en notificaties worden direct bijgewerkt.',
      'Avatar: upload of selecteer een profielafbeelding die zichtbaar is voor andere spelers op je openbare profiel en in crew-lijsten.',
      'Privacy: stel in wie je online-status, locatie (huidig land) en statistieken kan zien — alleen jezelf, crew, vrienden of iedereen.',
      'Push-notificaties: schakel per systeem in/uit. Categorieën: Crimes, Crypto-handel, Prijsalerts, Orders, Marktregime, Heist, Nightclub, algemene berichten.',
      'In-app notificaties: apart instelbaar naast push. In-app toont meldingen in de app zonder een systeemnotificatie te sturen.',
      'Beveiliging: verander wachtwoord, stel twee-factor authenticatie in en bekijk actieve sessies.',
      'Notificatie-voorkeur per systeem: stel scherpte af zodat je geen meldingen-storm krijgt van systemen die je niet actief speelt.',
    ],
    howEn: [
      'Language: switch between Dutch and English. All UI texts, system messages and notifications update immediately.',
      'Avatar: upload or select a profile image visible to other players on your public profile and in crew lists.',
      'Privacy: set who can see your online status, location (current country) and statistics — only you, crew, friends or everyone.',
      'Push notifications: toggle per system. Categories: Crimes, Crypto trading, Price alerts, Orders, Market regime, Heist, Nightclub, general messages.',
      'In-app notifications: configurable separately from push. In-app shows alerts inside the app without sending a system notification.',
      'Security: change password, set up two-factor authentication and view active sessions.',
      'Per-system notification preference: fine tune so you do not get a notification storm from systems you are not actively playing.',
    ],
    tipsNl: [
      'Schakel push-notificaties in voor Crypto Orders en Heist Events: dit zijn tijdkritische systemen waar je snel moet reageren.',
      'Zet privacy op crew-only voor locatie als je actief bent op de hitlist: andere spelers kunnen je anders exact pinpointen.',
    ],
    tipsEn: [
      'Enable push notifications for Crypto Orders and Heist Events: these are time-critical systems where quick reaction matters.',
      'Set privacy to crew-only for location when you are active on the hitlist: other players can otherwise pinpoint you exactly.',
    ],
    protocolPath: 'docs/module-protocols/settings.md',
  ),
];
