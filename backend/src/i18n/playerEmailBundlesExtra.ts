/**
 * Transactional email HTML strings for player languages de, fr, es, it, pl, pt.
 * EN/NL live in translationService.ts; merged in translationService.getTranslations.
 */
import type { SupportedPlayerLanguage } from '../config/supportedLanguages';
import type { Translations } from '../services/translationService';

export type EmailCommonOverride = Pick<Translations['common'], 'footer' | 'automatedMessage'>;

export type EmailBundleExtra = {
  email: Translations['email'];
  common: EmailCommonOverride;
};

const emailDE: Translations['email'] = {
  verification: {
    subject: 'E-Mail bestätigen - The Mob State',
    title: 'E-Mail bestätigen',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Willkommen bei The Mob State! Bevor du dein kriminelles Imperium aufbauen kannst, müssen wir deine E-Mail-Adresse bestätigen. Klicke auf die Schaltfläche unten, um dein Konto zu aktivieren:',
    buttonText: 'E-MAIL BESTÄTIGEN',
    expiryNote: 'Aus Sicherheitsgründen läuft dieser Link in 24 Stunden ab.',
    ignoreNote: 'Wenn du kein Konto erstellt hast, kannst du diese E-Mail ignorieren.',
    securityLabel: 'Hinweis',
    copyLinkHint: 'Oder kopiere diesen Link und füge ihn in deinen Browser ein:',
  },
  passwordReset: {
    subject: 'Passwort zurücksetzen - The Mob State',
    title: 'Passwort zurücksetzen',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Wir haben eine Anfrage erhalten, dein Passwort zurückzusetzen. Klicke auf die Schaltfläche unten, um ein neues Passwort festzulegen:',
    buttonText: 'PASSWORT ZURÜCKSETZEN',
    expiryNote: 'Aus Sicherheitsgründen läuft dieser Link in 1 Stunde ab.',
    ignoreNote: 'Wenn du das nicht angefordert hast, bleibt dein Passwort unverändert.',
    securityLabel: 'Hinweis',
    copyLinkHint: 'Oder kopiere diesen Link und füge ihn in deinen Browser ein:',
  },
  friendRequest: {
    subject: '🤝 Neue Freundschaftsanfrage - The Mob State',
    title: '🤝 Neue Freundschaftsanfrage',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> möchte sich mit dir in The Mob State verbinden. Baut euer Netzwerk aus und dominiert die Unterwelt gemeinsam!`,
    buttonText: 'ANFRAGE ANSEHEN',
    settingsNote: 'Freundschaftsanfragen und Benachrichtigungen kannst du im Spiel verwalten.',
  },
  friendAccepted: {
    subject: '🎉 Freundschaftsanfrage angenommen - The Mob State',
    title: '🎉 Freundschaftsanfrage angenommen',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `Gute Neuigkeiten! <strong style="color: #D4A574;">${acceptorUsername}</strong> hat deine Freundschaftsanfrage angenommen. Dein Netzwerk wächst!`,
    buttonText: 'FREUNDE ANSEHEN',
    settingsNote: 'Freunde und Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewJoinRequest: {
    subject: '👥 Crew-Beitrittsanfrage - The Mob State',
    title: '👥 Crew-Beitrittsanfrage',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> möchte deiner Crew <strong style="color: #D4A574;">${crewName}</strong> beitreten.`,
    buttonText: 'ANFRAGE PRÜFEN',
    settingsNote: 'Crew-Anfragen und Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewJoinApproved: {
    subject: '✅ Crew-Beitritt bestätigt - The Mob State',
    title: '✅ Crew-Beitritt bestätigt',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `Dein Beitritt zu <strong style="color: #D4A574;">${crewName}</strong> wurde bestätigt. Willkommen an Bord!`,
    buttonText: 'CREW ÖFFNEN',
    settingsNote: 'Crew-Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewJoinRejected: {
    subject: '❌ Crew-Beitritt abgelehnt - The Mob State',
    title: '❌ Crew-Beitritt abgelehnt',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Dein Beitritt zu <strong style="color: #D4A574;">${crewName}</strong> wurde abgelehnt.`,
    buttonText: 'CREWS SUCHEN',
    settingsNote: 'Crew-Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewKicked: {
    subject: '⚠️ Aus Crew entfernt - The Mob State',
    title: '⚠️ Aus Crew entfernt',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Du wurdest aus <strong style="color: #D4A574;">${crewName}</strong> entfernt.`,
    buttonText: 'CREWS SUCHEN',
    settingsNote: 'Crew-Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewRoleChanged: {
    subject: '⭐ Crew-Rolle geändert - The Mob State',
    title: '⭐ Crew-Rolle geändert',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `Deine Rolle in <strong style="color: #D4A574;">${crewName}</strong> ist jetzt <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'CREW ÖFFNEN',
    settingsNote: 'Crew-Benachrichtigungen kannst du im Spiel verwalten.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Crew-Überfall erfolgreich - The Mob State' : '🚨 Crew-Überfall fehlgeschlagen - The Mob State',
    title: (success) => (success ? '💰 Crew-Überfall erfolgreich' : '🚨 Crew-Überfall fehlgeschlagen'),
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `Deine Crew <strong style="color: #D4A574;">${crewName}</strong> hat <strong style="color: #D4A574;">${heistName}</strong> erfolgreich abgeschlossen.`
        : `Deine Crew <strong style="color: #D4A574;">${crewName}</strong> ist bei <strong style="color: #D4A574;">${heistName}</strong> gescheitert.`,
    buttonText: 'CREW ANSEHEN',
    settingsNote: 'Crew-Benachrichtigungen kannst du im Spiel verwalten.',
  },
  casinoLowBalance: {
    subject: '⚠️ Casino: niedriges Guthaben - The Mob State',
    title: '⚠️ Casino: niedriges Guthaben',
    greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `Dein Casino <strong style="color: #D4A574;">${casinoName}</strong> hat wenig Guthaben. Aktueller Stand: <strong style="color: #ff4444;">€${currentBalance}</strong>. Zahle mehr ein, um es betriebsbereit zu halten (Minimum: €${threshold}).`,
    buttonText: 'CASINO VERWALTEN',
    settingsNote: 'Casino und Benachrichtigungen kannst du im Spiel verwalten.',
  },
};

const commonDE: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Alle Rechte vorbehalten.',
  automatedMessage: 'Dies ist eine automatische Nachricht; bitte antworte nicht.',
};

const emailFR: Translations['email'] = {
  verification: {
    subject: 'Confirmez votre e-mail - The Mob State',
    title: 'Confirmez votre e-mail',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Bienvenue sur The Mob State ! Avant de bâtir ton empire, nous devons vérifier ton adresse e-mail. Clique sur le bouton ci-dessous pour confirmer ton compte :',
    buttonText: 'VÉRIFIER L’E-MAIL',
    expiryNote: 'Pour des raisons de sécurité, ce lien expire dans 24 heures.',
    ignoreNote: 'Si tu n’as pas créé de compte, tu peux ignorer cet e-mail.',
    securityLabel: 'Remarque',
    copyLinkHint: 'Ou copie-colle ce lien dans ton navigateur :',
  },
  passwordReset: {
    subject: 'Réinitialiser le mot de passe - The Mob State',
    title: 'Réinitialiser le mot de passe',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Nous avons reçu une demande de réinitialisation de ton mot de passe. Clique sur le bouton ci-dessous pour en créer un nouveau :',
    buttonText: 'RÉINITIALISER',
    expiryNote: 'Pour des raisons de sécurité, ce lien expire dans 1 heure.',
    ignoreNote: 'Si tu n’as pas fait cette demande, ton mot de passe reste inchangé.',
    securityLabel: 'Remarque',
    copyLinkHint: 'Ou copie-colle ce lien dans ton navigateur :',
  },
  friendRequest: {
    subject: '🤝 Nouvelle demande d’ami - The Mob State',
    title: '🤝 Nouvelle demande d’ami',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> souhaite te connecter sur The Mob State. Étoffez votre réseau et dominez la pègre ensemble !`,
    buttonText: 'VOIR LA DEMANDE',
    settingsNote: 'Tu peux gérer tes demandes d’ami et notifications dans le jeu.',
  },
  friendAccepted: {
    subject: '🎉 Demande d’ami acceptée - The Mob State',
    title: '🎉 Demande d’ami acceptée',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `Bonne nouvelle ! <strong style="color: #D4A574;">${acceptorUsername}</strong> a accepté ta demande d’ami. Ton réseau s’agrandit !`,
    buttonText: 'VOIR LES AMIS',
    settingsNote: 'Tu peux gérer tes amis et notifications dans le jeu.',
  },
  crewJoinRequest: {
    subject: '👥 Demande d’adhésion à la crew - The Mob State',
    title: '👥 Demande d’adhésion à la crew',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> souhaite rejoindre ta crew <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'EXAMINER',
    settingsNote: 'Tu peux gérer les demandes crew et les notifications dans le jeu.',
  },
  crewJoinApproved: {
    subject: '✅ Adhésion crew acceptée - The Mob State',
    title: '✅ Adhésion crew acceptée',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `Ta demande pour rejoindre <strong style="color: #D4A574;">${crewName}</strong> a été acceptée. Bienvenue !`,
    buttonText: 'OUVRIR LA CREW',
    settingsNote: 'Tu peux gérer les notifications crew dans le jeu.',
  },
  crewJoinRejected: {
    subject: '❌ Adhésion crew refusée - The Mob State',
    title: '❌ Adhésion crew refusée',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Ta demande pour rejoindre <strong style="color: #D4A574;">${crewName}</strong> a été refusée.`,
    buttonText: 'TROUVER DES CREWS',
    settingsNote: 'Tu peux gérer les notifications crew dans le jeu.',
  },
  crewKicked: {
    subject: '⚠️ Exclu de la crew - The Mob State',
    title: '⚠️ Exclu de la crew',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Tu as été retiré de <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'TROUVER DES CREWS',
    settingsNote: 'Tu peux gérer les notifications crew dans le jeu.',
  },
  crewRoleChanged: {
    subject: '⭐ Rôle crew mis à jour - The Mob State',
    title: '⭐ Rôle crew mis à jour',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `Ton rôle dans <strong style="color: #D4A574;">${crewName}</strong> est maintenant <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'OUVRIR LA CREW',
    settingsNote: 'Tu peux gérer les notifications crew dans le jeu.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Braquage crew réussi - The Mob State' : '🚨 Braquage crew échoué - The Mob State',
    title: (success) => (success ? '💰 Braquage crew réussi' : '🚨 Braquage crew échoué'),
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `Ta crew <strong style="color: #D4A574;">${crewName}</strong> a réussi <strong style="color: #D4A574;">${heistName}</strong>.`
        : `Ta crew <strong style="color: #D4A574;">${crewName}</strong> a échoué sur <strong style="color: #D4A574;">${heistName}</strong>.`,
    buttonText: 'VOIR LA CREW',
    settingsNote: 'Tu peux gérer les notifications crew dans le jeu.',
  },
  casinoLowBalance: {
    subject: '⚠️ Casino : solde bas - The Mob State',
    title: '⚠️ Casino : solde bas',
    greeting: (username) => `Salut <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `Ton casino <strong style="color: #D4A574;">${casinoName}</strong> manque de fonds. Solde actuel : <strong style="color: #ff4444;">€${currentBalance}</strong>. Dépose plus pour rester opérationnel (minimum : €${threshold}).`,
    buttonText: 'GÉRER LE CASINO',
    settingsNote: 'Tu peux gérer le casino et les notifications dans le jeu.',
  },
};

const commonFR: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Tous droits réservés.',
  automatedMessage: 'Ceci est un message automatique ; merci de ne pas répondre.',
};

const emailES: Translations['email'] = {
  verification: {
    subject: 'Verifica tu correo - The Mob State',
    title: 'Verifica tu correo',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: '¡Bienvenido a The Mob State! Antes de empezar a construir tu imperio, debemos verificar tu correo. Pulsa el botón de abajo para confirmar tu cuenta:',
    buttonText: 'VERIFICAR CORREO',
    expiryNote: 'Por seguridad, este enlace caduca en 24 horas.',
    ignoreNote: 'Si no creaste una cuenta, puedes ignorar este mensaje.',
    securityLabel: 'Aviso',
    copyLinkHint: 'O copia y pega este enlace en tu navegador:',
  },
  passwordReset: {
    subject: 'Restablecer contraseña - The Mob State',
    title: 'Restablecer contraseña',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Hemos recibido una solicitud para restablecer tu contraseña. Pulsa el botón de abajo para crear una nueva:',
    buttonText: 'RESTABLECER',
    expiryNote: 'Por seguridad, este enlace caduca en 1 hora.',
    ignoreNote: 'Si no solicitaste esto, tu contraseña no cambia.',
    securityLabel: 'Aviso',
    copyLinkHint: 'O copia y pega este enlace en tu navegador:',
  },
  friendRequest: {
    subject: '🤝 Nueva solicitud de amistad - The Mob State',
    title: '🤝 Nueva solicitud de amistad',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> quiere conectar contigo en The Mob State. ¡Haced crecer vuestra red y dominad el bajo mundo juntos!`,
    buttonText: 'VER SOLICITUD',
    settingsNote: 'Puedes gestionar solicitudes y notificaciones en el juego.',
  },
  friendAccepted: {
    subject: '🎉 Solicitud aceptada - The Mob State',
    title: '🎉 Solicitud aceptada',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `¡Buenas noticias! <strong style="color: #D4A574;">${acceptorUsername}</strong> ha aceptado tu solicitud de amistad. ¡Tu red crece!`,
    buttonText: 'VER AMIGOS',
    settingsNote: 'Puedes gestionar amigos y notificaciones en el juego.',
  },
  crewJoinRequest: {
    subject: '👥 Solicitud de crew - The Mob State',
    title: '👥 Solicitud de crew',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> quiere unirse a tu crew <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'REVISAR',
    settingsNote: 'Puedes gestionar solicitudes de crew y notificaciones en el juego.',
  },
  crewJoinApproved: {
    subject: '✅ Unión a crew aprobada - The Mob State',
    title: '✅ Unión a crew aprobada',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `Tu solicitud para unirte a <strong style="color: #D4A574;">${crewName}</strong> ha sido aprobada. ¡Bienvenido a bordo!`,
    buttonText: 'ABRIR CREW',
    settingsNote: 'Puedes gestionar notificaciones de crew en el juego.',
  },
  crewJoinRejected: {
    subject: '❌ Unión a crew rechazada - The Mob State',
    title: '❌ Unión a crew rechazada',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Tu solicitud para unirte a <strong style="color: #D4A574;">${crewName}</strong> ha sido rechazada.`,
    buttonText: 'BUSCAR CREWS',
    settingsNote: 'Puedes gestionar notificaciones de crew en el juego.',
  },
  crewKicked: {
    subject: '⚠️ Expulsado de la crew - The Mob State',
    title: '⚠️ Expulsado de la crew',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Has sido expulsado de <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'BUSCAR CREWS',
    settingsNote: 'Puedes gestionar notificaciones de crew en el juego.',
  },
  crewRoleChanged: {
    subject: '⭐ Rol de crew actualizado - The Mob State',
    title: '⭐ Rol de crew actualizado',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `Tu rol en <strong style="color: #D4A574;">${crewName}</strong> es ahora <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'ABRIR CREW',
    settingsNote: 'Puedes gestionar notificaciones de crew en el juego.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Atraco de crew conseguido - The Mob State' : '🚨 Atraco de crew fallido - The Mob State',
    title: (success) => (success ? '💰 Atraco de crew conseguido' : '🚨 Atraco de crew fallido'),
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `Tu crew <strong style="color: #D4A574;">${crewName}</strong> completó con éxito <strong style="color: #D4A574;">${heistName}</strong>.`
        : `Tu crew <strong style="color: #D4A574;">${crewName}</strong> falló en <strong style="color: #D4A574;">${heistName}</strong>.`,
    buttonText: 'VER CREW',
    settingsNote: 'Puedes gestionar notificaciones de crew en el juego.',
  },
  casinoLowBalance: {
    subject: '⚠️ Casino: saldo bajo - The Mob State',
    title: '⚠️ Casino: saldo bajo',
    greeting: (username) => `Hola <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `Tu casino <strong style="color: #D4A574;">${casinoName}</strong> tiene poco saldo. Saldo actual: <strong style="color: #ff4444;">€${currentBalance}</strong>. Ingresa más para mantenerlo operativo (mínimo: €${threshold}).`,
    buttonText: 'GESTIONAR CASINO',
    settingsNote: 'Puedes gestionar el casino y las notificaciones en el juego.',
  },
};

const commonES: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Todos los derechos reservados.',
  automatedMessage: 'Este es un mensaje automático; por favor no respondas.',
};

const emailIT: Translations['email'] = {
  verification: {
    subject: 'Verifica la tua email - The Mob State',
    title: 'Verifica la tua email',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Benvenuto in The Mob State! Prima di costruire il tuo impero dobbiamo verificare il tuo indirizzo email. Clicca il pulsante qui sotto per confermare l’account:',
    buttonText: 'VERIFICA EMAIL',
    expiryNote: 'Per motivi di sicurezza questo link scade tra 24 ore.',
    ignoreNote: 'Se non hai creato un account, puoi ignorare questa email.',
    securityLabel: 'Avviso',
    copyLinkHint: 'Oppure copia e incolla questo link nel browser:',
  },
  passwordReset: {
    subject: 'Reimposta password - The Mob State',
    title: 'Reimposta password',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Abbiamo ricevuto una richiesta di reimpostazione password. Clicca il pulsante qui sotto per crearne una nuova:',
    buttonText: 'REIMPOSTA PASSWORD',
    expiryNote: 'Per motivi di sicurezza questo link scade tra 1 ora.',
    ignoreNote: 'Se non hai richiesto tu, la password resta invariata.',
    securityLabel: 'Avviso',
    copyLinkHint: 'Oppure copia e incolla questo link nel browser:',
  },
  friendRequest: {
    subject: '🤝 Nuova richiesta di amicizia - The Mob State',
    title: '🤝 Nuova richiesta di amicizia',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> vuole connettersi con te su The Mob State. Espandi la vostra rete e dominate insieme!`,
    buttonText: 'VEDI RICHIESTA',
    settingsNote: 'Puoi gestire richieste e notifiche nel gioco.',
  },
  friendAccepted: {
    subject: '🎉 Richiesta accettata - The Mob State',
    title: '🎉 Richiesta accettata',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `Ottime notizie! <strong style="color: #D4A574;">${acceptorUsername}</strong> ha accettato la tua richiesta di amicizia. La tua rete cresce!`,
    buttonText: 'VEDI AMICI',
    settingsNote: 'Puoi gestire amici e notifiche nel gioco.',
  },
  crewJoinRequest: {
    subject: '👥 Richiesta ingresso crew - The Mob State',
    title: '👥 Richiesta ingresso crew',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> vuole unirsi alla tua crew <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'ESAMINA',
    settingsNote: 'Puoi gestire richieste crew e notifiche nel gioco.',
  },
  crewJoinApproved: {
    subject: '✅ Ingresso crew approvato - The Mob State',
    title: '✅ Ingresso crew approvato',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `La tua richiesta di unirti a <strong style="color: #D4A574;">${crewName}</strong> è stata approvata. Benvenuto a bordo!`,
    buttonText: 'APRI CREW',
    settingsNote: 'Puoi gestire le notifiche crew nel gioco.',
  },
  crewJoinRejected: {
    subject: '❌ Ingresso crew rifiutato - The Mob State',
    title: '❌ Ingresso crew rifiutato',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `La tua richiesta di unirti a <strong style="color: #D4A574;">${crewName}</strong> è stata rifiutata.`,
    buttonText: 'TROVA CREW',
    settingsNote: 'Puoi gestire le notifiche crew nel gioco.',
  },
  crewKicked: {
    subject: '⚠️ Rimosso dalla crew - The Mob State',
    title: '⚠️ Rimosso dalla crew',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Sei stato rimosso da <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'TROVA CREW',
    settingsNote: 'Puoi gestire le notifiche crew nel gioco.',
  },
  crewRoleChanged: {
    subject: '⭐ Ruolo crew aggiornato - The Mob State',
    title: '⭐ Ruolo crew aggiornato',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `Il tuo ruolo in <strong style="color: #D4A574;">${crewName}</strong> è ora <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'APRI CREW',
    settingsNote: 'Puoi gestire le notifiche crew nel gioco.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Colpo crew riuscito - The Mob State' : '🚨 Colpo crew fallito - The Mob State',
    title: (success) => (success ? '💰 Colpo crew riuscito' : '🚨 Colpo crew fallito'),
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `La tua crew <strong style="color: #D4A574;">${crewName}</strong> ha completato <strong style="color: #D4A574;">${heistName}</strong> con successo.`
        : `La tua crew <strong style="color: #D4A574;">${crewName}</strong> ha fallito <strong style="color: #D4A574;">${heistName}</strong>.`,
    buttonText: 'VEDI CREW',
    settingsNote: 'Puoi gestire le notifiche crew nel gioco.',
  },
  casinoLowBalance: {
    subject: '⚠️ Casino: saldo basso - The Mob State',
    title: '⚠️ Casino: saldo basso',
    greeting: (username) => `Ciao <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `Il tuo casino <strong style="color: #D4A574;">${casinoName}</strong> ha pochi fondi. Saldo attuale: <strong style="color: #ff4444;">€${currentBalance}</strong>. Deposita altro per restare operativo (minimo: €${threshold}).`,
    buttonText: 'GESTISCI CASINO',
    settingsNote: 'Puoi gestire casino e notifiche nel gioco.',
  },
};

const commonIT: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Tutti i diritti riservati.',
  automatedMessage: 'Questo è un messaggio automatico; non rispondere.',
};

const emailPL: Translations['email'] = {
  verification: {
    subject: 'Potwierdź e-mail - The Mob State',
    title: 'Potwierdź e-mail',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Witaj w The Mob State! Zanim zaczniesz budować imperium, musimy zweryfikować Twój adres e-mail. Kliknij przycisk poniżej, aby potwierdzić konto:',
    buttonText: 'POTWIERDŹ E-MAIL',
    expiryNote: 'Ze względów bezpieczeństwa link wygaśnie za 24 godziny.',
    ignoreNote: 'Jeśli nie zakładałeś konta, zignoruj tę wiadomość.',
    securityLabel: 'Uwaga',
    copyLinkHint: 'Lub skopiuj link i wklej go w przeglądarce:',
  },
  passwordReset: {
    subject: 'Reset hasła - The Mob State',
    title: 'Reset hasła',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Otrzymaliśmy prośbę o zresetowanie hasła. Kliknij przycisk poniżej, aby ustawić nowe:',
    buttonText: 'RESETUJ HASŁO',
    expiryNote: 'Ze względów bezpieczeństwa link wygaśnie za 1 godzinę.',
    ignoreNote: 'Jeśli to nie Ty, hasło pozostaje bez zmian.',
    securityLabel: 'Uwaga',
    copyLinkHint: 'Lub skopiuj link i wklej go w przeglądarce:',
  },
  friendRequest: {
    subject: '🤝 Nowe zaproszenie do znajomych - The Mob State',
    title: '🤝 Nowe zaproszenie do znajomych',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> chce połączyć się z Tobą w The Mob State. Rozbudujcie sieć i razem zdominujcie półświatek!`,
    buttonText: 'ZOBACZ PROŚBĘ',
    settingsNote: 'Zaproszenia i powiadomienia zarządzasz w grze.',
  },
  friendAccepted: {
    subject: '🎉 Zaproszenie przyjęte - The Mob State',
    title: '🎉 Zaproszenie przyjęte',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `Świetna wiadomość! <strong style="color: #D4A574;">${acceptorUsername}</strong> przyjął Twoje zaproszenie. Twoja sieć rośnie!`,
    buttonText: 'ZNAJOMI',
    settingsNote: 'Znajomych i powiadomienia zarządzasz w grze.',
  },
  crewJoinRequest: {
    subject: '👥 Prośba o dołączenie do crew - The Mob State',
    title: '👥 Prośba o dołączenie do crew',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> chce dołączyć do Twojej crew <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'SPRAWDŹ',
    settingsNote: 'Prośby crew i powiadomienia zarządzasz w grze.',
  },
  crewJoinApproved: {
    subject: '✅ Dołączenie zaakceptowane - The Mob State',
    title: '✅ Dołączenie zaakceptowane',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `Twoja prośba o dołączenie do <strong style="color: #D4A574;">${crewName}</strong> została zaakceptowana. Witamy na pokładzie!`,
    buttonText: 'OTWÓRZ CREW',
    settingsNote: 'Powiadomienia crew zarządzasz w grze.',
  },
  crewJoinRejected: {
    subject: '❌ Dołączenie odrzucone - The Mob State',
    title: '❌ Dołączenie odrzucone',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Twoja prośba o dołączenie do <strong style="color: #D4A574;">${crewName}</strong> została odrzucona.`,
    buttonText: 'SZUKAJ CREW',
    settingsNote: 'Powiadomienia crew zarządzasz w grze.',
  },
  crewKicked: {
    subject: '⚠️ Usunięto z crew - The Mob State',
    title: '⚠️ Usunięto z crew',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Zostałeś usunięty z <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'SZUKAJ CREW',
    settingsNote: 'Powiadomienia crew zarządzasz w grze.',
  },
  crewRoleChanged: {
    subject: '⭐ Zmiana roli w crew - The Mob State',
    title: '⭐ Zmiana roli w crew',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `Twoja rola w <strong style="color: #D4A574;">${crewName}</strong> to teraz <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'OTWÓRZ CREW',
    settingsNote: 'Powiadomienia crew zarządzasz w grze.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Napad crew udany - The Mob State' : '🚨 Napad crew nieudany - The Mob State',
    title: (success) => (success ? '💰 Napad crew udany' : '🚨 Napad crew nieudany'),
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `Twoja crew <strong style="color: #D4A574;">${crewName}</strong> ukończyła <strong style="color: #D4A574;">${heistName}</strong>.`
        : `Twoja crew <strong style="color: #D4A574;">${crewName}</strong> nie ukończyła <strong style="color: #D4A574;">${heistName}</strong>.`,
    buttonText: 'ZOBACZ CREW',
    settingsNote: 'Powiadomienia crew zarządzasz w grze.',
  },
  casinoLowBalance: {
    subject: '⚠️ Kasyno: niskie saldo - The Mob State',
    title: '⚠️ Kasyno: niskie saldo',
    greeting: (username) => `Cześć <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `Twoje kasyno <strong style="color: #D4A574;">${casinoName}</strong> ma mało środków. Saldo: <strong style="color: #ff4444;">€${currentBalance}</strong>. Wpłać więcej, aby działało (minimum: €${threshold}).`,
    buttonText: 'ZARZĄDZAJ KASYNEM',
    settingsNote: 'Kasyno i powiadomienia zarządzasz w grze.',
  },
};

const commonPL: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Wszelkie prawa zastrzeżone.',
  automatedMessage: 'To wiadomość automatyczna; nie odpowiadaj.',
};

const emailPT: Translations['email'] = {
  verification: {
    subject: 'Confirma o teu email - The Mob State',
    title: 'Confirma o teu email',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Bem-vindo ao The Mob State! Antes de construíres o teu império, precisamos de verificar o teu email. Clica no botão abaixo para confirmares a conta:',
    buttonText: 'VERIFICAR EMAIL',
    expiryNote: 'Por segurança, este link expira em 24 horas.',
    ignoreNote: 'Se não criaste conta, podes ignorar este email.',
    securityLabel: 'Aviso',
    copyLinkHint: 'Ou copia e cola este link no teu browser:',
  },
  passwordReset: {
    subject: 'Repor palavra-passe - The Mob State',
    title: 'Repor palavra-passe',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: 'Recebemos um pedido para repor a tua palavra-passe. Clica no botão abaixo para criares uma nova:',
    buttonText: 'REPOR PALAVRA-PASSE',
    expiryNote: 'Por segurança, este link expira em 1 hora.',
    ignoreNote: 'Se não foste tu, a palavra-passe mantém-se.',
    securityLabel: 'Aviso',
    copyLinkHint: 'Ou copia e cola este link no teu browser:',
  },
  friendRequest: {
    subject: '🤝 Novo pedido de amizade - The Mob State',
    title: '🤝 Novo pedido de amizade',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (senderUsername) =>
      `<strong style="color: #D4A574;">${senderUsername}</strong> quer conectar contigo no The Mob State. Expande a vossa rede e dominem juntos!`,
    buttonText: 'VER PEDIDO',
    settingsNote: 'Podes gerir pedidos e notificações no jogo.',
  },
  friendAccepted: {
    subject: '🎉 Pedido aceite - The Mob State',
    title: '🎉 Pedido aceite',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (acceptorUsername) =>
      `Boas notícias! <strong style="color: #D4A574;">${acceptorUsername}</strong> aceitou o teu pedido de amizade. A tua rede cresce!`,
    buttonText: 'VER AMIGOS',
    settingsNote: 'Podes gerir amigos e notificações no jogo.',
  },
  crewJoinRequest: {
    subject: '👥 Pedido para entrar na crew - The Mob State',
    title: '👥 Pedido para entrar na crew',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (requesterUsername, crewName) =>
      `<strong style="color: #D4A574;">${requesterUsername}</strong> quer juntar-se à tua crew <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'REVISAR',
    settingsNote: 'Podes gerir pedidos de crew e notificações no jogo.',
  },
  crewJoinApproved: {
    subject: '✅ Entrada na crew aprovada - The Mob State',
    title: '✅ Entrada na crew aprovada',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) =>
      `O teu pedido para entrar em <strong style="color: #D4A574;">${crewName}</strong> foi aprovado. Bem-vindo a bordo!`,
    buttonText: 'ABRIR CREW',
    settingsNote: 'Podes gerir notificações de crew no jogo.',
  },
  crewJoinRejected: {
    subject: '❌ Entrada na crew recusada - The Mob State',
    title: '❌ Entrada na crew recusada',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `O teu pedido para entrar em <strong style="color: #D4A574;">${crewName}</strong> foi recusado.`,
    buttonText: 'PROCURAR CREWS',
    settingsNote: 'Podes gerir notificações de crew no jogo.',
  },
  crewKicked: {
    subject: '⚠️ Removido da crew - The Mob State',
    title: '⚠️ Removido da crew',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName) => `Foste removido de <strong style="color: #D4A574;">${crewName}</strong>.`,
    buttonText: 'PROCURAR CREWS',
    settingsNote: 'Podes gerir notificações de crew no jogo.',
  },
  crewRoleChanged: {
    subject: '⭐ Função na crew atualizada - The Mob State',
    title: '⭐ Função na crew atualizada',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, role) =>
      `A tua função em <strong style="color: #D4A574;">${crewName}</strong> é agora <strong style="color: #D4A574;">${role}</strong>.`,
    buttonText: 'ABRIR CREW',
    settingsNote: 'Podes gerir notificações de crew no jogo.',
  },
  crewHeistResult: {
    subject: (success) =>
      success ? '💰 Assalto da crew com sucesso - The Mob State' : '🚨 Assalto da crew falhou - The Mob State',
    title: (success) => (success ? '💰 Assalto da crew com sucesso' : '🚨 Assalto da crew falhou'),
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (crewName, heistName, success) =>
      success
        ? `A tua crew <strong style="color: #D4A574;">${crewName}</strong> completou <strong style="color: #D4A574;">${heistName}</strong> com sucesso.`
        : `A tua crew <strong style="color: #D4A574;">${crewName}</strong> falhou <strong style="color: #D4A574;">${heistName}</strong>.`,
    buttonText: 'VER CREW',
    settingsNote: 'Podes gerir notificações de crew no jogo.',
  },
  casinoLowBalance: {
    subject: '⚠️ Casino: saldo baixo - The Mob State',
    title: '⚠️ Casino: saldo baixo',
    greeting: (username) => `Olá <strong style="color: #D4A574;">${username}</strong>,`,
    body: (casinoName, currentBalance, threshold) =>
      `O teu casino <strong style="color: #D4A574;">${casinoName}</strong> está com poucos fundos. Saldo atual: <strong style="color: #ff4444;">€${currentBalance}</strong>. Deposita mais para manter ativo (mínimo: €${threshold}).`,
    buttonText: 'GERIR CASINO',
    settingsNote: 'Podes gerir o casino e notificações no jogo.',
  },
};

const commonPT: EmailCommonOverride = {
  footer: '© 2026 The Mob State. Todos os direitos reservados.',
  automatedMessage: 'Esta é uma mensagem automática; por favor não respondas.',
};

export const EMAIL_BUNDLES_I18N: Partial<Record<SupportedPlayerLanguage, EmailBundleExtra>> = {
  de: { email: emailDE, common: commonDE },
  fr: { email: emailFR, common: commonFR },
  es: { email: emailES, common: commonES },
  it: { email: emailIT, common: commonIT },
  pl: { email: emailPL, common: commonPL },
  pt: { email: emailPT, common: commonPT },
};
