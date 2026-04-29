#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const l10nDir = path.join(__dirname, '..', 'client', 'lib', 'l10n');

const nl = {
  connectionErrorGeneric: 'Verbindingsfout',
  crimeWeaponSectionTitle: 'Crime-wapen',
  crimeWeaponInstruction:
    'Kies hier welk gedragen wapen je standaard gebruikt voor crimes die een wapen vereisen.',
  crimeWeaponEmptyInventoryHelp:
    'Koop of verplaats eerst een bruikbaar wapen naar je carried inventory.',
  crimeWeaponSelectHint: 'Selecteer een wapen voor crimes',
  crimeWeaponNoSelectionNote:
    'Zonder selectie starten gewapende crimes niet.',
  crimeWeaponSelectedStatus:
    'Geselecteerd: {weaponLine}. Sommige crimes eisen daarnaast nog een passend wapentype.',
  crimeSetWeaponFailed: 'Instellen van crime-wapen mislukt.',
  crimeChooseWeaponBeforeCommit:
    'Kies eerst een crime-wapen bovenaan dit scherm of via Inventaris.',
  crimeWeaponFooterNote:
    'Gewapende crimes gebruiken het geselecteerde crime-wapen hierboven.',
  crimeCriminalRecordWipeDesc:
    'Verval dossiers en wis je volledige strafblad als de operatie slaagt.',
  crimeCardSuccessChance: '{percent}% kans',
  cooldownTimeLeft: 'Resterende tijd',
  cooldownMustWaitExplanation:
    'Je moet wachten voordat je deze actie opnieuw kunt uitvoeren.',
  cooldownAlreadyFinished: 'Cooldown is al klaar.',
  cooldownNotEnoughCredits: 'Onvoldoende credits.',
  cooldownNoActiveToReset: 'Geen actieve cooldown om te resetten.',
  cooldownNotAvailableNow: 'Nu niet beschikbaar.',
  cooldownRedeemFailed: 'Versnellen met credits mislukt.',
  cooldownFinishedInstantly: 'Cooldown direct afgerond.',
  cooldownSpeedUpNow: 'Versnel nu (-{cost} credits)',
  cooldownCreditBalanceLine: 'Saldo: {balance} credits',
  cooldownLoadingCreditOptions: 'Credits-opties laden...',
  cooldownWaitCrime: 'De heat is te hoog...',
  cooldownWaitJob: 'Neemt rust voordat je weer kan werken',
  cooldownWaitTravel: 'Volgende vlucht vertrekt over',
  cooldownWaitHeist: 'Plan wordt voorbereid...',
  cooldownWaitAppeal: 'Rechtbank is bezet...',
  cooldownWaitDefault: 'Even geduld...',
  cooldownTitleCrime: 'Misdaad cooldown',
  cooldownTitleJob: 'Werk cooldown',
  cooldownTitleTravel: 'Reizen cooldown',
  cooldownTitleHeist: 'Overval cooldown',
  cooldownTitleAppeal: 'Hoger beroep cooldown',
  cooldownTitleSchool: 'Opleiding cooldown',
  cooldownTitleGeneric: 'Cooldown',
  crimeOutcomeDefaultTitle: 'Crime-resultaat',
  weaponLabelKnife: 'Mes',
  weaponLabelHandgun9mm: 'Pistool (9mm)',
  weaponLabelHandgunHeavy: 'Zwaar Pistool (.45)',
  weaponLabelSmgCompact: 'Compacte SMG',
  weaponLabelShotgunPump: 'Shotgun (Pump)',
  weaponLabelMolotov: 'Molotovcocktail',
  weaponLabelSmgSuppressed: 'SMG (Suppressor)',
  weaponLabelShotgunTactical: 'Tactische Shotgun',
  weaponLabelAssaultRifle: 'Aanvalsgeweer (AK-47)',
  weaponLabelGrenadeFlash: 'Flashbang',
  weaponLabelGrenadeFrag: 'Fragmentatiegranaat',
  weaponLabelSniperStandard: 'Sluipschuttersgeweer',
  weaponLabelAssaultRifleVip: 'Aanvalsgeweer Elite',
  weaponLabelSniperVip: 'Sluipschutter Elite',
};

const es = {
  connectionErrorGeneric: 'Error de conexión',
  crimeWeaponSectionTitle: 'Arma para crímenes',
  crimeWeaponInstruction:
    'Elige qué arma llevada usas por defecto en crímenes que requieren una.',
  crimeWeaponEmptyInventoryHelp:
    'Compra o mueve primero un arma utilizable a tu inventario portátil.',
  crimeWeaponSelectHint: 'Selecciona un arma para crímenes',
  crimeWeaponNoSelectionNote:
    'Sin selección, los crímenes con arma no se pueden iniciar.',
  crimeWeaponSelectedStatus:
    'Seleccionado: {weaponLine}. Algunos crímenes exigen además un tipo de arma compatible.',
  crimeSetWeaponFailed: 'No se pudo guardar el arma para crímenes.',
  crimeChooseWeaponBeforeCommit:
    'Elige primero un arma arriba o desde el inventario.',
  crimeWeaponFooterNote:
    'Los crímenes con arma usan el arma seleccionada arriba.',
  crimeCriminalRecordWipeDesc:
    'Falsifica expedientes y borra tu historial criminal completo si la operación tiene éxito.',
  crimeCardSuccessChance: '{percent}% de éxito',
  cooldownTimeLeft: 'Tiempo restante',
  cooldownMustWaitExplanation:
    'Debes esperar antes de volver a realizar esta acción.',
  cooldownAlreadyFinished: 'El tiempo de espera ya terminó.',
  cooldownNotEnoughCredits: 'Créditos insuficientes.',
  cooldownNoActiveToReset: 'No hay tiempo de espera activo que reiniciar.',
  cooldownNotAvailableNow: 'No disponible ahora.',
  cooldownRedeemFailed: 'No se pudo acelerar con créditos.',
  cooldownFinishedInstantly: 'Tiempo de espera terminado al instante.',
  cooldownSpeedUpNow: 'Acelerar ahora (-{cost} créditos)',
  cooldownCreditBalanceLine: 'Saldo: {balance} créditos',
  cooldownLoadingCreditOptions: 'Cargando opciones de créditos…',
  cooldownWaitCrime: 'La policía está muy alerta…',
  cooldownWaitJob: 'Descansando antes de volver a trabajar',
  cooldownWaitTravel: 'El próximo vuelo sale en',
  cooldownWaitHeist: 'Preparando el golpe…',
  cooldownWaitAppeal: 'El tribunal está ocupado…',
  cooldownWaitDefault: 'Un momento…',
  cooldownTitleCrime: 'Tiempo de espera: crímenes',
  cooldownTitleJob: 'Tiempo de espera: trabajo',
  cooldownTitleTravel: 'Tiempo de espera: viaje',
  cooldownTitleHeist: 'Tiempo de espera: golpe',
  cooldownTitleAppeal: 'Tiempo de espera: apelación',
  cooldownTitleSchool: 'Tiempo de espera: escuela',
  cooldownTitleGeneric: 'Tiempo de espera',
  crimeOutcomeDefaultTitle: 'Resultado del crimen',
  weaponLabelKnife: 'Cuchillo',
  weaponLabelHandgun9mm: 'Pistola (9 mm)',
  weaponLabelHandgunHeavy: 'Pistola pesada (.45)',
  weaponLabelSmgCompact: 'Subfusil compacto',
  weaponLabelShotgunPump: 'Escopeta (bomba)',
  weaponLabelMolotov: 'Cóctel molotov',
  weaponLabelSmgSuppressed: 'Subfusil con silenciador',
  weaponLabelShotgunTactical: 'Escopeta táctica',
  weaponLabelAssaultRifle: 'Fusil de asalto (AK-47)',
  weaponLabelGrenadeFlash: 'Granada aturdidora',
  weaponLabelGrenadeFrag: 'Granada de fragmentación',
  weaponLabelSniperStandard: 'Rifle de francotirador',
  weaponLabelAssaultRifleVip: 'Fusil de asalto de élite',
  weaponLabelSniperVip: 'Francotirador de élite',
};

function apply(file, map) {
  const p = path.join(l10nDir, file);
  const j = JSON.parse(fs.readFileSync(p, 'utf8'));
  let n = 0;
  for (const [k, v] of Object.entries(map)) {
    if (k in j) {
      j[k] = v;
      n += 1;
    }
  }
  fs.writeFileSync(p, JSON.stringify(j, null, 2) + '\n', 'utf8');
  console.log(`${file}: updated ${n} keys`);
}

apply('app_nl.arb', nl);
apply('app_es.arb', es);
