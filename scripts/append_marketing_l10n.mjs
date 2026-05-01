/**
 * One-shot: merge marketing + legal keys into app_en.arb (and can copy to nl).
 * Run: node scripts/append_marketing_l10n.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const enPath = path.join(root, 'client', 'lib', 'l10n', 'app_en.arb');

const extra = {
  landingHeroTitle: 'The Mob State',
  landingHeroSubtitle:
    'A deep text-based crime strategy game in your browser. Build your empire, run crews, trade, fight for territory — and climb the ranks.',
  landingAboutTitle: 'What awaits you',
  landingAboutBody:
    'Manage businesses, execute jobs and heists, develop your character through school certificates, compete in live events, and coordinate with your crew on the world map. Fair competitive rules, long-term progression, and regular content updates.',
  landingTopPlayersTitle: 'Top players',
  landingTopCrewsTitle: 'Top crews (territory)',
  landingRankLabel: 'Rank',
  landingRegionsLabel: 'Regions',
  landingLoadError: 'Could not load rankings right now.',
  landingEmptyLeaderboard: 'No entries yet.',
  landingCtaLogin: 'Log in',
  landingCtaRegister: 'Create account',
  landingFooterPrivacy: 'Privacy Policy',
  landingFooterDigitalGoods: 'Purchase of Digital Goods',
  landingFooterLanguage: 'Language',
  '@landingCopyright': {
    description: 'Footer copyright; year is injected from the app clock.',
    placeholders: { year: { type: 'int' } },
  },
  landingCopyright: '© {year} The Mob State. All rights reserved.',

  legalPrivacyTitle: 'Privacy Policy',
  legalPrivacyLastUpdated: 'Last updated: May 2026',
  legalPrivacyIntro:
    'This Privacy Policy explains how The Mob State ("we", "us") handles personal data when you use our website, web game and related services. By playing or browsing you agree to this policy where applicable law allows.',
  legalPrivacySection01Title: 'Who we are',
  legalPrivacySection01Body:
    'The Mob State is an online game operated as a digital service. For privacy requests you can contact us through the in-game support ticket system after registration, or via the official website contact channels if published.',
  legalPrivacySection02Title: 'Data we collect',
  legalPrivacySection02Body:
    'We may process account data (username, email if provided, hashed password), gameplay and progression data, technical logs (IP address, device/browser type, timestamps), payment-related references from our payment providers (we do not store full card numbers), and communications you send to support.',
  legalPrivacySection03Title: 'Purposes',
  legalPrivacySection03Body:
    'We use data to provide the game, secure accounts, prevent abuse and fraud, process purchases, improve performance, communicate service messages, and comply with legal obligations.',
  legalPrivacySection04Title: 'Legal bases (EEA/UK)',
  legalPrivacySection04Body:
    'Where GDPR applies we rely on performance of a contract (providing the game), legitimate interests (security, analytics, product improvement balanced against your rights), consent where required (e.g. certain marketing cookies or optional communications), and legal obligations.',
  legalPrivacySection05Title: 'Cookies and local storage',
  legalPrivacySection05Body:
    'We use cookies and similar technologies to keep you signed in, remember preferences, measure basic usage, and deliver essential functionality. You can control many cookies through your browser settings.',
  legalPrivacySection06Title: 'Retention',
  legalPrivacySection06Body:
    'We retain information as long as needed to operate the service and meet legal, tax, and accounting requirements. Some logs may be kept for a limited security window. When data is no longer needed we delete or anonymise it where feasible.',
  legalPrivacySection07Title: 'Sharing',
  legalPrivacySection07Body:
    'We share data with infrastructure and payment processors strictly as needed to run the service, under appropriate agreements. We do not sell your personal data. We may disclose information if required by law or to protect rights and safety.',
  legalPrivacySection08Title: 'International transfers',
  legalPrivacySection08Body:
    'Your data may be processed in the European Economic Area and/or other regions where we or our providers operate. We use safeguards such as standard contractual clauses where required.',
  legalPrivacySection09Title: 'Your rights',
  legalPrivacySection09Body:
    'Depending on your location you may have rights to access, rectify, erase, restrict or object to certain processing, and to data portability. You may lodge a complaint with a supervisory authority. Contact us via support to exercise rights; we may need to verify your identity.',
  legalPrivacySection10Title: 'Children',
  legalPrivacySection10Body:
    'The game is not directed to children under the age where parental consent is required for processing in your region. If you believe a child provided data improperly, contact us and we will take appropriate steps.',

  legalDigitalGoodsTitle: 'Purchase of Digital Goods',
  legalDigitalGoodsLastUpdated: 'Last updated: May 2026',
  legalDigitalGoodsIntro:
    'This policy describes purchases of digital content and services in The Mob State (for example premium credits, VIP time, or other virtual items). By completing a purchase you agree to these terms together with any checkout terms shown at payment.',
  legalDigitalGoodsSection01Title: 'Nature of digital purchases',
  legalDigitalGoodsSection01Body:
    'All purchases are payments for access to additional online features and virtual items within The Mob State. They are delivered digitally in-game and have no physical form.',
  legalDigitalGoodsSection02Title: 'Immediate delivery and withdrawal (UK/EU)',
  legalDigitalGoodsSection02Body:
    'Where the Consumer Contracts Regulations 2013 (UK) or equivalent EU rules apply, you acknowledge that digital content is supplied immediately after purchase and, where the law permits, you may lose the statutory 14-day right of withdrawal once delivery has begun with your prior express consent.',
  legalDigitalGoodsSection03Title: 'Refunds and chargebacks',
  legalDigitalGoodsSection03Body:
    'Digital goods are generally non-refundable once delivered except where mandatory consumer law requires otherwise. Chargebacks or payment disputes after delivery may lead to suspension or termination of related accounts; please contact support first so we can help resolve billing issues.',
  legalDigitalGoodsSection04Title: 'Permission and age',
  legalDigitalGoodsSection04Body:
    'You must be authorised to use the chosen payment method. If you are under 18, you need permission from a parent or guardian to make purchases or use paid services.',
  legalDigitalGoodsSection05Title: 'Payment channels and fees',
  legalDigitalGoodsSection05Body:
    'Prices may be shown in euros or your provider currency. Mobile carriers or payment platforms may add their own fees; check with your provider before confirming carrier or wallet payments.',
  legalDigitalGoodsSection06Title: 'Availability',
  legalDigitalGoodsSection06Body:
    'Paid features are delivered virtually through our servers and may change over time. We may adjust, suspend or retire specific items, bundles, or pricing to balance the game or for technical reasons.',
  legalDigitalGoodsSection07Title: 'No real-world cash value',
  legalDigitalGoodsSection07Body:
    'Virtual items and currencies have no monetary value outside the game, are non-transferable for real money, and may be altered or removed as part of updates, account enforcement, or service discontinuation except where law requires compensation.',
  legalDigitalGoodsSection08Title: 'Prohibited commercial use',
  legalDigitalGoodsSection08Body:
    'You may not use The Mob State to operate unauthorised real-money trading, including buying or selling accounts, in-game currency, codes, or virtual assets for cash or external services outside our official payment flows.',
  legalDigitalGoodsSection09Title: 'Service changes',
  legalDigitalGoodsSection09Body:
    'We may update this policy and in-game purchase descriptions. Continued use after changes constitutes acceptance of the revised terms where permitted by law.',
  legalDigitalGoodsSection10Title: 'Governing law',
  legalDigitalGoodsSection10Body:
    'Unless mandatory local law provides otherwise, this policy is governed by the laws of England and Wales and disputes shall be subject to the exclusive jurisdiction of the courts of England and Wales.',
};

const raw = fs.readFileSync(enPath, 'utf8');
const data = JSON.parse(raw);
for (const [k, v] of Object.entries(extra)) {
  data[k] = v;
}
fs.writeFileSync(enPath, `${JSON.stringify(data, null, 2)}\n`, 'utf8');
console.log('Merged', Object.keys(extra).length, 'keys into app_en.arb');

const nlPath = path.join(root, 'client', 'lib', 'l10n', 'app_nl.arb');
const nlExtra = {
  landingHeroTitle: 'The Mob State',
  landingHeroSubtitle:
    'Een diepe text-based misdaadstrategiespel in je browser. Bouw je imperium, run crews, handel, vecht om territorium — en klim in de ranglijsten.',
  landingAboutTitle: 'Wat je te wachten staat',
  landingAboutBody:
    'Beheer bedrijven, voer jobs en overvallen uit, ontwikkel je personage via schoolcertificaten, doe mee aan live events en coördineer met je crew op de wereldkaart. Eerlijke competitie, langetermijnprogressie en regelmatige updates.',
  landingTopPlayersTitle: 'Top spelers',
  landingTopCrewsTitle: 'Top crews (territorium)',
  landingRankLabel: 'Rang',
  landingRegionsLabel: 'Regio’s',
  landingLoadError: 'Ranglijsten konden nu niet worden geladen.',
  landingEmptyLeaderboard: 'Nog geen invoer.',
  landingCtaLogin: 'Inloggen',
  landingCtaRegister: 'Account aanmaken',
  landingFooterPrivacy: 'Privacybeleid',
  landingFooterDigitalGoods: 'Aankoop digitale goederen',
  landingFooterLanguage: 'Taal',
  '@landingCopyright': {
    description: 'Footer copyright; year is injected from the app clock.',
    placeholders: { year: { type: 'int' } },
  },
  landingCopyright: '© {year} The Mob State. Alle rechten voorbehouden.',

  legalPrivacyTitle: 'Privacybeleid',
  legalPrivacyLastUpdated: 'Laatst bijgewerkt: mei 2026',
  legalPrivacyIntro:
    'Dit privacybeleid legt uit hoe The Mob State (“wij”) persoonsgegevens verwerkt wanneer je onze website, webgame en gerelateerde diensten gebruikt. Door te spelen of te browsen ga je akkoord met dit beleid voor zover de wet dat toelaat.',
  legalPrivacySection01Title: 'Wie wij zijn',
  legalPrivacySection01Body:
    'The Mob State is een online game als digitale dienst. Voor privacyverzoeken kun je na registratie contact opnemen via het supportticketssysteem in het spel, of via officiële contactkanalen op de website indien gepubliceerd.',
  legalPrivacySection02Title: 'Gegevens die we verwerken',
  legalPrivacySection02Body:
    'We kunnen accountgegevens (gebruikersnaam, e-mail indien opgegeven, gehasht wachtwoord), gameplay- en voortgangsdaten, technische logs (IP-adres, apparaat/browsertype, tijdstempels), betalingsreferenties van betaalproviders (geen volledige kaartnummers) en door jou naar support gestuurde berichten verwerken.',
  legalPrivacySection03Title: 'Doeleinden',
  legalPrivacySection03Body:
    'We gebruiken gegevens om de game te leveren, accounts te beveiligen, misbruik en fraude te voorkomen, aankopen af te handelen, prestaties te verbeteren, servicemeldingen te sturen en aan wettelijke verplichtingen te voldoen.',
  legalPrivacySection04Title: 'Rechtsgronden (EER/VK)',
  legalPrivacySection04Body:
    'Waar de AVG geldt steunen we op uitvoering van een overeenkomst (de game leveren), gerechtvaardigde belangen (beveiliging, basis analytics, productverbetering afgewogen tegen jouw rechten), toestemming waar nodig, en wettelijke verplichtingen.',
  legalPrivacySection05Title: 'Cookies en lokale opslag',
  legalPrivacySection05Body:
    'We gebruiken cookies en vergelijkbare technieken om je ingelogd te houden, voorkeuren te onthouden, basisgebruik te meten en essentiële functionaliteit te leveren. Je kunt veel cookies via je browser beheren.',
  legalPrivacySection06Title: 'Bewaartermijnen',
  legalPrivacySection06Body:
    'We bewaren informatie zolang nodig is voor de dienst en voor fiscale/juridische eisen. Sommige logs worden beperkt bewaard voor beveiliging. Waar mogelijk wissen of anonimiseren we gegevens die niet meer nodig zijn.',
  legalPrivacySection07Title: 'Delen',
  legalPrivacySection07Body:
    'We delen gegevens met infrastructuur- en betaalpartners voor zover nodig om de dienst te draaien, met passende afspraken. We verkopen geen persoonsgegevens. We kunnen informatie verstrekken indien de wet dat vereist of om rechten en veiligheid te beschermen.',
  legalPrivacySection08Title: 'Internationale doorgifte',
  legalPrivacySection08Body:
    'Gegevens kunnen in de EER en/of andere regio’s worden verwerkt. Waar nodig gebruiken we waarborgen zoals standaardcontractbepalingen.',
  legalPrivacySection09Title: 'Jouw rechten',
  legalPrivacySection09Body:
    'Je kunt rechten hebben op inzage, correctie, verwijdering, beperking of bezwaar, en op gegevensoverdraagbaarheid. Je kunt een klacht indienen bij een toezichthouder. Neem via support contact op om rechten uit te oefenen; we kunnen je identiteit verifiëren.',
  legalPrivacySection10Title: 'Kinderen',
  legalPrivacySection10Body:
    'De game richt zich niet op kinderen onder de leeftijd waar ouderlijke toestemming vereist is. Neem contact op als je denkt dat een kind onterecht gegevens heeft verstrekt.',

  legalDigitalGoodsTitle: 'Aankoop van digitale goederen',
  legalDigitalGoodsLastUpdated: 'Laatst bijgewerkt: mei 2026',
  legalDigitalGoodsIntro:
    'Dit beleid beschrijft aankopen van digitale inhoud en diensten in The Mob State (zoals premium credits, VIP-tijd of andere virtuele items). Door te betalen ga je akkoord met deze voorwaarden en met eventuele checkoutteksten bij de betaling.',
  legalDigitalGoodsSection01Title: 'Aard van digitale aankopen',
  legalDigitalGoodsSection01Body:
    'Alle aankopen zijn betalingen voor extra online functies en virtuele items binnen The Mob State. Ze worden digitaal in-game geleverd en hebben geen fysieke vorm.',
  legalDigitalGoodsSection02Title: 'Directe levering en herroeping (VK/EU)',
  legalDigitalGoodsSection02Body:
    'Waar de Consumer Contracts Regulations 2013 (VK) of vergelijkbare EU-regels gelden, erken je dat digitale inhoud direct na aankoop wordt geleverd en dat je wettelijke herroepingsrecht van 14 dagen kan vervallen zodra levering met jouw uitdrukkelijke voorafgaande toestemming is begonnen, voor zover de wet dat toestaat.',
  legalDigitalGoodsSection03Title: 'Terugbetalingen en chargebacks',
  legalDigitalGoodsSection03Body:
    'Digitale goederen zijn in principe niet terugbetaalbaar na levering, behalve waar dwingend consumentenrecht anders voorschrijft. Chargebacks na levering kunnen leiden tot schorsing of beëindiging van gerelateerde accounts; neem eerst contact op met support.',
  legalDigitalGoodsSection04Title: 'Toestemming en leeftijd',
  legalDigitalGoodsSection04Body:
    'Je moet gemachtigd zijn om de gekozen betaalmethode te gebruiken. Ben je onder de 18, dan is toestemming van ouder/voogd nodig voor betalingen of betaalde diensten.',
  legalDigitalGoodsSection05Title: 'Betaalkanalen en kosten',
  legalDigitalGoodsSection05Body:
    'Prijzen kunnen in euro’s of de valuta van je provider worden getoond. Mobiele providers of platforms kunnen eigen kosten rekenen; controleer dit vóór bevestiging.',
  legalDigitalGoodsSection06Title: 'Beschikbaarheid',
  legalDigitalGoodsSection06Body:
    'Betaalde functies worden virtueel via onze servers geleverd en kunnen in de loop van de tijd veranderen. We kunnen items, bundels of prijzen aanpassen, opschorten of laten vervallen voor balans of technische redenen.',
  legalDigitalGoodsSection07Title: 'Geen contante waarde',
  legalDigitalGoodsSection07Body:
    'Virtuele items en valuta’s hebben geen geldwaarde buiten de game, zijn niet inwisselbaar voor echt geld en kunnen worden gewijzigd of verwijderd bij updates, handhaving of beëindiging van de dienst, behalve waar de wet compensatie vereist.',
  legalDigitalGoodsSection08Title: 'Verboden commercieel gebruik',
  legalDigitalGoodsSection08Body:
    'Je mag The Mob State niet gebruiken voor ongeautoriseerde handel met echt geld, waaronder verkoop van accounts, in-game valuta, codes of virtuele assets buiten onze officiële betaalstromen.',
  legalDigitalGoodsSection09Title: 'Wijzigingen van de dienst',
  legalDigitalGoodsSection09Body:
    'We kunnen dit beleid en in-game aankoopbeschrijvingen bijwerken. Voortgezet gebruik na wijzigingen betekent acceptatie voor zover de wet dat toelaat.',
  legalDigitalGoodsSection10Title: 'Toepasselijk recht',
  legalDigitalGoodsSection10Body:
    'Tenzij dwingend lokaal recht anders bepaalt, wordt dit beleid beheerst door het recht van Engeland en Wales en zijn geschillen onderworpen aan de exclusieve jurisdictie van de rechtbanken van Engeland en Wales.',
};

const nlRaw = fs.readFileSync(nlPath, 'utf8');
const nlData = JSON.parse(nlRaw);
for (const [k, v] of Object.entries(nlExtra)) {
  nlData[k] = v;
}
fs.writeFileSync(nlPath, `${JSON.stringify(nlData, null, 2)}\n`, 'utf8');
console.log('Merged', Object.keys(nlExtra).length, 'keys into app_nl.arb');
