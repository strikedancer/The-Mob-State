export const LANGS = ['nl', 'en', 'de', 'fr', 'es', 'it', 'pl', 'pt'];

export const LANG_LABEL = {
  nl: 'Nederlands',
  en: 'English',
  de: 'Deutsch',
  fr: 'Français',
  es: 'Español',
  it: 'Italiano',
  pl: 'Polski',
  pt: 'Português',
};

const pack = (nl, en, de, fr, es, it, pl, pt) => ({ nl, en, de, fr, es, it, pl, pt });

export const UI = {
  siteTitle: pack('Almanak', 'Almanac', 'Almanach', 'Almanach', 'Almanaque', 'Almanacco', 'Almanach', 'Almanaque'),
  brand: pack('The Mob State', 'The Mob State', 'The Mob State', 'The Mob State', 'The Mob State', 'The Mob State', 'The Mob State', 'The Mob State'),
  seoDocumentTitle: pack(
    'The Mob State — text-based mafia game',
    'The Mob State — text-based mafia game',
    'The Mob State — textbasiertes Mafia-Spiel',
    'The Mob State — jeu de mafia textuel',
    'The Mob State — juego de mafia de texto',
    'The Mob State — gioco mafia testuale',
    'The Mob State — tekstowa gra mafijna',
    'The Mob State — jogo de máfia em texto'
  ),
  seoDocumentDescription: pack(
    'Officiële almanak van The Mob State, een text-based mafia game: handleiding, landen, voertuigen, wapens en meer.',
    'Official almanac of The Mob State, a text-based mafia game: handbook, countries, vehicles, weapons and more.',
    'Offizieller Almanach von The Mob State, einem text-based mafia game: Handbuch, Länder, Fahrzeuge, Waffen und mehr.',
    'Almanach officiel de The Mob State, un text-based mafia game : manuel, pays, véhicules, armes et plus.',
    'Almanaque oficial de The Mob State, un text-based mafia game: manual, países, vehículos, armas y más.',
    'Almanacco ufficiale di The Mob State, un text-based mafia game: manuale, paesi, veicoli, armi e altro.',
    'Oficjalny almanach The Mob State, text-based mafia game: poradnik, kraje, pojazdy, broń i więcej.',
    'Almanaque oficial de The Mob State, um text-based mafia game: manual, países, veículos, armas e mais.'
  ),
  search: pack('Zoek in de almanak…', 'Search the almanac…', 'Almanach durchsuchen…', 'Rechercher l’almanach…', 'Buscar en el almanaque…', 'Cerca nell’almanacco…', 'Szukaj w almanachu…', 'Pesquisar o almanaque…'),
  play: pack('Speel nu', 'Play now', 'Jetzt spielen', 'Jouer', 'Jugar ahora', 'Gioca ora', 'Graj teraz', 'Jogar agora'),
  home: pack('Overzicht', 'Overview', 'Übersicht', 'Aperçu', 'Resumen', 'Panoramica', 'Przegląd', 'Visão geral'),
  countries: pack('Landen', 'Countries', 'Länder', 'Pays', 'Países', 'Paesi', 'Kraje', 'Países'),
  trade: pack('Handelswaren', 'Contraband', 'Schmuggelware', 'Contrebande', 'Contrabando', 'Contrabbando', 'Kontrabanda', 'Contrabando'),
  vehicles: pack('Voertuigen', 'Vehicles', 'Fahrzeuge', 'Véhicules', 'Vehículos', 'Veicoli', 'Pojazdy', 'Veículos'),
  cars: pack('Auto’s', 'Cars', 'Autos', 'Voitures', 'Coches', 'Auto', 'Samochody', 'Carros'),
  boats: pack('Boten', 'Boats', 'Boote', 'Bateaux', 'Barcos', 'Barche', 'Łodzie', 'Barcos'),
  motorcycles: pack('Motoren', 'Motorcycles', 'Motorräder', 'Motos', 'Motos', 'Moto', 'Motocykle', 'Motos'),
  weapons: pack('Wapens', 'Weapons', 'Waffen', 'Armes', 'Armas', 'Armi', 'Broń', 'Armas'),
  ammo: pack('Munitie', 'Ammunition', 'Munition', 'Munitions', 'Munición', 'Munizioni', 'Amunicja', 'Munição'),
  security: pack('Beveiliging', 'Security', 'Schutz', 'Sécurité', 'Seguridad', 'Sicurezza', 'Ochrona', 'Segurança'),
  drugs: pack('Drugs', 'Drugs', 'Drogen', 'Drogues', 'Drogas', 'Droga', 'Narkotyki', 'Drogas'),
  materials: pack('Materialen', 'Materials', 'Materialien', 'Matériaux', 'Materiales', 'Materiali', 'Materiały', 'Materiais'),
  facilities: pack('Faciliteiten', 'Facilities', 'Anlagen', 'Installations', 'Instalaciones', 'Impianti', 'Obiekty', 'Instalações'),
  properties: pack('Eigendommen', 'Properties', 'Immobilien', 'Propriétés', 'Propiedades', 'Proprietà', 'Nieruchomości', 'Propriedades'),
  aircraft: pack('Vliegtuigen', 'Aircraft', 'Flugzeuge', 'Avions', 'Aeronaves', 'Aerei', 'Samoloty', 'Aeronaves'),
  backpacks: pack('Rugzakken', 'Backpacks', 'Rucksäcke', 'Sacs', 'Mochilas', 'Zaini', 'Plecaki', 'Mochilas'),
  travel: pack('Reizen', 'Travel', 'Reisen', 'Voyage', 'Viajes', 'Viaggi', 'Podróże', 'Viagens'),
  crimes: pack('Misdaden', 'Crimes', 'Verbrechen', 'Crimes', 'Crímenes', 'Crimini', 'Przestępstwa', 'Crimes'),
  jobs: pack('Banen', 'Jobs', 'Jobs', 'Emplois', 'Trabajos', 'Lavori', 'Prace', 'Empregos'),
  crew: pack('Crew-gebouwen', 'Crew buildings', 'Crew-Gebäude', 'Bâtiments d’équipage', 'Edificios de crew', 'Edifici crew', 'Budynki załogi', 'Edifícios da crew'),
  school: pack('School', 'School', 'Schule', 'École', 'Escuela', 'Scuola', 'Szkoła', 'Escola'),
  guide: pack('Handleiding', 'Handbook', 'Handbuch', 'Manuel', 'Manual', 'Manuale', 'Poradnik', 'Manual'),
  guideLead: pack(
    'De complete handleiding bij elk scherm — Don, races, profiel, avatar wisselen en een portret maken van een foto of selfie.',
    'The complete handbook for every screen — Don, races, profile, changing your avatar and turning a photo or selfie into a portrait.',
    'Das komplette Handbuch zu jedem Bildschirm — Don, Rennen, Profil, Avatar wechseln und Porträt aus Foto oder Selfie.',
    'Le manuel complet de chaque écran — Don, courses, profil, changement d’avatar et portrait à partir d’une photo ou d’un selfie.',
    'El manual completo de cada pantalla — Don, carreras, perfil, cambiar avatar y retrato desde foto o selfie.',
    'Il manuale completo di ogni schermata — Don, gare, profilo, cambio avatar e ritratto da foto o selfie.',
    'Kompletny poradnik do każdego ekranu — Don, wyścigi, profil, zmiana awatara i portret ze zdjęcia lub selfie.',
    'O manual completo de cada ecrã — Don, corridas, perfil, mudar o avatar e retrato a partir de foto ou selfie.'
  ),
  guideFeatured: pack('Uitgelicht', 'Featured', 'Empfohlen', 'À la une', 'Destacado', 'In evidenza', 'Wyróżnione', 'Destaques'),
  howItWorks: pack('Hoe het werkt', 'How it works', 'So funktioniert es', 'Comment ça marche', 'Cómo funciona', 'Come funziona', 'Jak to działa', 'Como funciona'),
  tips: pack('Tips', 'Tips', 'Tipps', 'Conseils', 'Consejos', 'Consigli', 'Wskazówki', 'Dicas'),
  heroKicker: pack('Officiële speler-almanak', 'Official player almanac', 'Offizieller Spieleralmanach', 'Almanach officiel', 'Almanaque oficial', 'Almanacco ufficiale', 'Oficjalny almanach', 'Almanaque oficial'),
  heroTitle: pack('De wereld van The Mob State', 'The world of The Mob State', 'Die Welt von The Mob State', 'Le monde de The Mob State', 'El mundo de The Mob State', 'Il mondo di The Mob State', 'Świat The Mob State', 'O mundo de The Mob State'),
  heroLead: pack(
    'Handleiding én catalogus: hoe het spel werkt, plus landen, handelswaren, voertuigen, wapens en meer — met de originele game-beelden. Geen live koersen.',
    'Handbook and catalogue: how the game works, plus countries, contraband, vehicles, weapons and more — with original game art. No live prices.',
    'Handbuch und Katalog: wie das Spiel funktioniert, plus Länder, Schmuggelware, Fahrzeuge, Waffen und mehr — mit Originalbildern. Keine Live-Kurse.',
    'Manuel et catalogue : le fonctionnement du jeu, plus pays, contrebande, véhicules, armes et plus — avec les visuels du jeu. Pas de cours en direct.',
    'Manual y catálogo: cómo funciona el juego, más países, contrabando, vehículos, armas y más — con el arte original. Sin precios en vivo.',
    'Manuale e catalogo: come funziona il gioco, più paesi, contrabbando, veicoli, armi e altro — con le immagini originali. Nessun prezzo live.',
    'Poradnik i katalog: jak działa gra, plus kraje, kontrabanda, pojazdy, broń i więcej — z oryginalnymi grafikami. Bez żywych kursów.',
    'Manual e catálogo: como o jogo funciona, mais países, contrabando, veículos, armas e mais — com a arte original. Sem preços ao vivo.'
  ),
  liveNotice: pack(
    'Straatprijzen bewegen. De tabellen tonen de vaste landfactor (lager = doorgaans goedkoper kopen, hoger = doorgaans duurdere straat). Live koers zie je in de Zwarte Markt.',
    'Street prices move. Tables show the fixed country factor (lower = typically cheaper to buy, higher = typically dearer). Live quotes live on the Black Market.',
    'Straßenpreise schwanken. Tabellen zeigen den festen Landesfaktor (niedriger = typisch günstiger, höher = typisch teurer). Live-Kurse gibt es auf dem Schwarzmarkt.',
    'Les prix bougent. Les tableaux montrent le facteur pays fixe (plus bas = souvent moins cher, plus haut = souvent plus cher). Les cours live sont sur le marché noir.',
    'Los precios se mueven. Las tablas muestran el factor de país fijo (más bajo = suele ser más barato, más alto = más caro). Los precios en vivo están en el mercado negro.',
    'I prezzi si muovono. Le tabelle mostrano il fattore paese fisso (più basso = di solito più economico, più alto = più caro). I prezzi live sono sul mercato nero.',
    'Ceny uliczne się zmieniają. Tabele pokazują stały mnożnik kraju (niższy = zwykle taniej, wyższy = zwykle drożej). Na żywo: czarny rynek.',
    'Os preços mudam. As tabelas mostram o fator fixo do país (mais baixo = em geral mais barato, mais alto = mais caro). Cotações ao vivo ficam no mercado negro.'
  ),
  sourceCountries: pack('Koopbaar in', 'Buyable in', 'Kaufbar in', 'Achetable à', 'Comprable en', 'Acquistabile in', 'Do kupienia w', 'Comprável em'),
  typicalCheap: pack('Doorgaans lager', 'Typically lower', 'Typisch niedriger', 'Habituellement plus bas', 'Habitualmente más bajo', 'Di solito più basso', 'Zwykle niższy', 'Normalmente mais baixo'),
  typicalDear: pack('Doorgaans hoger', 'Typically higher', 'Typisch höher', 'Habituellement plus haut', 'Habitualmente más alto', 'Di solito più alto', 'Zwykle wyższy', 'Normalmente mais alto'),
  factor: pack('Landfactor', 'Country factor', 'Landesfaktor', 'Facteur pays', 'Factor de país', 'Fattore paese', 'Mnożnik kraju', 'Fator do país'),
  rank: pack('Rang', 'Rank', 'Rang', 'Rang', 'Rango', 'Grado', 'Ranga', 'Patente'),
  price: pack('Catalogusprijs', 'Catalog price', 'Katalogpreis', 'Prix catalogue', 'Precio de catálogo', 'Prezzo di catalogo', 'Cena katalogowa', 'Preço de catálogo'),
  slots: pack('Vakken', 'Slots', 'Slots', 'Emplacements', 'Ranuras', 'Slot', 'Sloty', 'Espaços'),
  vip: pack('Alleen VIP', 'VIP only', 'Nur VIP', 'VIP uniquement', 'Solo VIP', 'Solo VIP', 'Tylko VIP', 'Apenas VIP'),
  cargo: pack('Lading', 'Cargo', 'Ladung', 'Cargaison', 'Carga', 'Carico', 'Ładunek', 'Carga'),
  speed: pack('Snelheid', 'Speed', 'Tempo', 'Vitesse', 'Velocidad', 'Velocità', 'Prędkość', 'Velocidade'),
  armor: pack('Pantser', 'Armor', 'Panzerung', 'Blindage', 'Blindaje', 'Corazza', 'Pancerz', 'Blindagem'),
  stealth: pack('Stealth', 'Stealth', 'Tarnung', 'Discrétion', 'Sigilo', 'Furtività', 'Skradanie', 'Furtividade'),
  damage: pack('Schade', 'Damage', 'Schaden', 'Dégâts', 'Daño', 'Danno', 'Obrażenia', 'Dano'),
  intimidation: pack('Intimidatie', 'Intimidation', 'Einschüchterung', 'Intimidation', 'Intimidación', 'Intimidazione', 'Zastraszenie', 'Intimidação'),
  travelCost: pack('Reiskosten', 'Travel cost', 'Reisekosten', 'Coût de voyage', 'Coste de viaje', 'Costo viaggio', 'Koszt podróży', 'Custo de viagem'),
  hubs: pack('Reis-hubs', 'Travel hubs', 'Reise-Hubs', 'Hubs de voyage', 'Hubs de viaje', 'Hub di viaggio', 'Huby podróży', 'Hubs de viagem'),
  direct: pack('Directe routes', 'Direct routes', 'Direktverbindungen', 'Liaisons directes', 'Rutas directas', 'Rotte dirette', 'Połączenia bezpośrednie', 'Rotas diretas'),
  all: pack('Alles', 'All', 'Alle', 'Tout', 'Todo', 'Tutto', 'Wszystko', 'Tudo'),
  empty: pack('Niets gevonden.', 'Nothing found.', 'Nichts gefunden.', 'Rien trouvé.', 'Nada encontrado.', 'Nessun risultato.', 'Nic nie znaleziono.', 'Nada encontrado.'),
  askOpen: pack('Vraag de Almanak', 'Ask the Almanac', 'Almanach fragen', 'Demander à l’almanach', 'Preguntar al almanaque', 'Chiedi all’almanacco', 'Zapytaj almanach', 'Perguntar ao almanaque'),
  askTitle: pack('Almanak-hulp', 'Almanac help', 'Almanach-Hilfe', 'Aide de l’almanach', 'Ayuda del almanaque', 'Aiuto almanacco', 'Pomoc almanachu', 'Ajuda do almanaque'),
  askKicker: pack('Automatische antwoorden', 'Automatic answers', 'Automatische Antworten', 'Réponses automatiques', 'Respuestas automáticas', 'Risposte automatiche', 'Automatyczne odpowiedzi', 'Respostas automáticas'),
  askWelcome: pack(
    'Stel een vraag over het spel. Ik zoek het antwoord in de handleiding en catalogus. Geen live prijzen en geen accountgegevens.',
    'Ask a question about the game. I look up the answer in the handbook and catalogue. No live prices and no account data.',
    'Stell eine Frage zum Spiel. Ich suche die Antwort in Handbuch und Katalog. Keine Live-Preise und keine Kontodaten.',
    'Posez une question sur le jeu. Je cherche la réponse dans le manuel et le catalogue. Pas de prix live ni de données de compte.',
    'Haz una pregunta sobre el juego. Busco la respuesta en el manual y el catálogo. Sin precios en vivo ni datos de cuenta.',
    'Fai una domanda sul gioco. Cerco la risposta nel manuale e nel catalogo. Niente prezzi live né dati account.',
    'Zadaj pytanie o grę. Szukam odpowiedzi w poradniku i katalogu. Bez żywych cen i danych konta.',
    'Faça uma pergunta sobre o jogo. Procuro a resposta no manual e no catálogo. Sem preços ao vivo nem dados de conta.'
  ),
  askPlaceholder: pack('Bijvoorbeeld: hoe werkt Don?', 'For example: how does Don work?', 'Zum Beispiel: wie funktioniert Don?', 'Par exemple : comment marche Don ?', 'Por ejemplo: ¿cómo funciona Don?', 'Ad esempio: come funziona Don?', 'Na przykład: jak działa Don?', 'Por exemplo: como funciona o Don?'),
  askSend: pack('Vraag', 'Ask', 'Fragen', 'Demander', 'Preguntar', 'Chiedi', 'Pytaj', 'Perguntar'),
  askClose: pack('Sluiten', 'Close', 'Schließen', 'Fermer', 'Cerrar', 'Chiudi', 'Zamknij', 'Fechar'),
  askRead: pack('Lees verder', 'Read more', 'Weiterlesen', 'Lire la suite', 'Leer más', 'Leggi di più', 'Czytaj dalej', 'Ler mais'),
  askMore: pack('Gerelateerd', 'Related', 'Verwandt', 'Lié', 'Relacionado', 'Correlati', 'Powiązane', 'Relacionado'),
  askEmpty: pack(
    'Daar staat nog niets over in de Almanak. Probeer andere woorden, of open de Handleiding.',
    'The Almanac has nothing on that yet. Try different words, or open the Handbook.',
    'Dazu steht noch nichts im Almanach. Versuche andere Wörter oder öffne das Handbuch.',
    'L’almanach n’a encore rien là-dessus. Essayez d’autres mots, ou ouvrez le manuel.',
    'El almanaque aún no tiene nada sobre eso. Prueba otras palabras o abre el manual.',
    'L’almanacco non ha ancora nulla su questo. Prova altre parole, o apri il manuale.',
    'Almanach nie ma jeszcze nic na ten temat. Spróbuj innych słów albo otwórz poradnik.',
    'O almanaque ainda não tem nada sobre isso. Tente outras palavras, ou abra o manual.'
  ),
  askSuggest: pack(
    'Hoe werkt Don?|Wat is de crew-bank?|Hoe werkt de rugzak?|Hoe kom ik uit de gevangenis?',
    'How does Don work?|What is the crew bank?|How does the backpack work?|How do I get out of prison?',
    'Wie funktioniert Don?|Was ist die Crew-Bank?|Wie funktioniert der Rucksack?|Wie komme ich aus dem Gefängnis?',
    'Comment marche Don ?|Qu’est-ce que la banque d’équipage ?|Comment marche le sac ?|Comment sortir de prison ?',
    '¿Cómo funciona Don?|¿Qué es el banco de crew?|¿Cómo funciona la mochila?|¿Cómo salgo de la cárcel?',
    'Come funziona Don?|Cos’è la banca della crew?|Come funziona lo zaino?|Come esco di prigione?',
    'Jak działa Don?|Czym jest bank załogi?|Jak działa plecak?|Jak wyjść z więzienia?',
    'Como funciona o Don?|O que é o banco da crew?|Como funciona a mochila?|Como saio da prisão?'
  ),
  footer: pack(
    'Gegenereerd uit de game-catalogus. © The Mob State',
    'Generated from the game catalogue. © The Mob State',
    'Erzeugt aus dem Spielkatalog. © The Mob State',
    'Généré depuis le catalogue du jeu. © The Mob State',
    'Generado desde el catálogo del juego. © The Mob State',
    'Generato dal catalogo di gioco. © The Mob State',
    'Wygenerowano z katalogu gry. © The Mob State',
    'Gerado a partir do catálogo do jogo. © The Mob State'
  ),
  browse: pack('Bladeren', 'Browse', 'Stöbern', 'Parcourir', 'Explorar', 'Sfoglia', 'Przeglądaj', 'Explorar'),
  overviewLead: pack(
    'Begin bij de handleiding, of blader door de catalogus. Elk item gebruikt dezelfde afbeelding als in het spel.',
    'Start with the handbook, or browse the catalogue. Every item uses the same artwork as in the game.',
    'Starte mit dem Handbuch oder stöbere im Katalog. Jedes Item nutzt dasselbe Artwork wie im Spiel.',
    'Commencez par le manuel, ou parcourez le catalogue. Chaque fiche utilise les visuels du jeu.',
    'Empieza por el manual o explora el catálogo. Cada ficha usa el mismo arte que en el juego.',
    'Inizia dal manuale o sfoglia il catalogo. Ogni scheda usa le stesse immagini del gioco.',
    'Zacznij od poradnika albo przeglądaj katalog. Każda karta używa tej samej grafiki co w grze.',
    'Comece pelo manual ou explore o catálogo. Cada ficha usa a mesma arte do jogo.'
  ),
  availableIn: pack('Beschikbaar in', 'Available in', 'Verfügbar in', 'Disponible à', 'Disponible en', 'Disponibile in', 'Dostępne w', 'Disponível em'),
  yield: pack('Opbrengst', 'Yield', 'Ertrag', 'Rendement', 'Rendimiento', 'Resa', 'Plon', 'Rendimento'),
  storage: pack('Opslag', 'Storage', 'Lager', 'Stockage', 'Almacenamiento', 'Magazzino', 'Magazyn', 'Armazenamento'),
  income: pack('Inkomen', 'Income', 'Einkommen', 'Revenu', 'Ingresos', 'Reddito', 'Przychód', 'Rendimento'),
  range: pack('Bereik', 'Range', 'Reichweite', 'Portée', 'Alcance', 'Autonomia', 'Zasięg', 'Alcance'),
  ammoType: pack('Munitietype', 'Ammo type', 'Munitionstyp', 'Type de munition', 'Tipo de munición', 'Tipo di munizione', 'Typ amunicji', 'Tipo de munição'),
  category: pack('Categorie', 'Category', 'Kategorie', 'Catégorie', 'Categoría', 'Categoria', 'Kategoria', 'Categoria'),
  starter: pack('Starter', 'Starter', 'Starter', 'Débutant', 'Inicial', 'Starter', 'Startowy', 'Inicial'),
  bulk: pack('Bulk', 'Bulk', 'Masse', 'Volume', 'Granel', 'Volume', 'Hurt', 'Volume'),
  luxury: pack('Luxe', 'Luxury', 'Luxus', 'Luxe', 'Lujo', 'Lusso', 'Luksus', 'Luxo'),
  dangerous: pack('Gevaarlijk', 'Dangerous', 'Gefährlich', 'Dangereux', 'Peligroso', 'Pericoloso', 'Niebezpieczny', 'Perigoso'),
  noImage: pack('Geen beeld', 'No image', 'Kein Bild', 'Pas d’image', 'Sin imagen', 'Nessuna immagine', 'Brak obrazu', 'Sem imagem'),
  related: pack('Gerelateerd', 'Related', 'Verwandt', 'Lié', 'Relacionado', 'Correlati', 'Powiązane', 'Relacionado'),
  filterType: pack('Type', 'Type', 'Typ', 'Type', 'Tipo', 'Tipo', 'Typ', 'Tipo'),
};

export const COUNTRY = {
  netherlands: pack('Nederland', 'Netherlands', 'Niederlande', 'Pays-Bas', 'Países Bajos', 'Paesi Bassi', 'Holandia', 'Países Baixos'),
  belgium: pack('België', 'Belgium', 'Belgien', 'Belgique', 'Bélgica', 'Belgio', 'Belgia', 'Bélgica'),
  germany: pack('Duitsland', 'Germany', 'Deutschland', 'Allemagne', 'Alemania', 'Germania', 'Niemcy', 'Alemanha'),
  france: pack('Frankrijk', 'France', 'Frankreich', 'France', 'Francia', 'Francia', 'Francja', 'França'),
  spain: pack('Spanje', 'Spain', 'Spanien', 'Espagne', 'España', 'Spagna', 'Hiszpania', 'Espanha'),
  italy: pack('Italië', 'Italy', 'Italien', 'Italie', 'Italia', 'Italia', 'Włochy', 'Itália'),
  uk: pack('Verenigd Koninkrijk', 'United Kingdom', 'Vereinigtes Königreich', 'Royaume-Uni', 'Reino Unido', 'Regno Unito', 'Wielka Brytania', 'Reino Unido'),
  switzerland: pack('Zwitserland', 'Switzerland', 'Schweiz', 'Suisse', 'Suiza', 'Svizzera', 'Szwajcaria', 'Suíça'),
  usa: pack('Verenigde Staten', 'United States', 'Vereinigte Staaten', 'États-Unis', 'Estados Unidos', 'Stati Uniti', 'Stany Zjednoczone', 'Estados Unidos'),
  mexico: pack('Mexico', 'Mexico', 'Mexiko', 'Mexique', 'México', 'Messico', 'Meksyk', 'México'),
  colombia: pack('Colombia', 'Colombia', 'Kolumbien', 'Colombie', 'Colombia', 'Colombia', 'Kolumbia', 'Colômbia'),
  brazil: pack('Brazilië', 'Brazil', 'Brasilien', 'Brésil', 'Brasil', 'Brasile', 'Brazylia', 'Brasil'),
  argentina: pack('Argentinië', 'Argentina', 'Argentinien', 'Argentine', 'Argentina', 'Argentina', 'Argentyna', 'Argentina'),
  japan: pack('Japan', 'Japan', 'Japan', 'Japon', 'Japón', 'Giappone', 'Japonia', 'Japão'),
  china: pack('China', 'China', 'China', 'Chine', 'China', 'Cina', 'Chiny', 'China'),
  russia: pack('Rusland', 'Russia', 'Russland', 'Russie', 'Rusia', 'Russia', 'Rosja', 'Rússia'),
  turkey: pack('Turkije', 'Turkey', 'Türkei', 'Turquie', 'Turquía', 'Turchia', 'Turcja', 'Turquia'),
  united_arab_emirates: pack('Verenigde Arabische Emiraten', 'United Arab Emirates', 'Vereinigte Arabische Emirate', 'Émirats arabes unis', 'Emiratos Árabes Unidos', 'Emirati Arabi Uniti', 'Zjednoczone Emiraty Arabskie', 'Emirados Árabes Unidos'),
  south_africa: pack('Zuid-Afrika', 'South Africa', 'Südafrika', 'Afrique du Sud', 'Sudáfrica', 'Sudafrica', 'Południowa Afryka', 'África do Sul'),
  australia: pack('Australië', 'Australia', 'Australien', 'Australie', 'Australia', 'Australia', 'Australia', 'Austrália'),
};

export function ui(lang, key) {
  const row = UI[key];
  if (!row) return key;
  return row[lang] || row.en || key;
}

export function countryName(lang, id) {
  const row = COUNTRY[id];
  if (!row) return id;
  return row[lang] || row.en || id;
}

export function tPick(row, lang, fallback) {
  if (!row) return fallback;
  if (typeof row === 'string') return row;
  return row[lang] || row.en || row.nl || fallback;
}
