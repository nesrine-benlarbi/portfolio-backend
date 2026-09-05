import dotenv from 'dotenv';
import AppError from '../errors/AppError.js';

dotenv.config();

// 1. Transport : API HTTP de Resend plutôt que SMTP.
//
// Pourquoi : en production, la connexion a smtp.gmail.com:465 n'aboutissait
// jamais — les journaux montraient un ETIMEDOUT au bout de deux minutes, soit
// le delai par defaut de Nodemailer, pendant lesquelles le formulaire restait
// en attente. Les hebergeurs mutualises filtrent couramment les ports SMTP
// sortants pour empecher le spam. L'API de Resend passe en HTTPS sur le port
// 443, et fonctionne depuis cet environnement.
//
// RESEND_API_KEY : clé créée sur resend.com, fournie par variable d'environnement.
// MAIL_FROM      : expéditeur. Sans nom de domaine vérifié, Resend impose son
//                  adresse de démarrage, qui n'écrit qu'au titulaire du compte —
//                  ce qui suffit ici, le formulaire m'écrit à moi.
// MAIL_TO        : destinataire des notifications.
const RESEND_URL = 'https://api.resend.com/emails';
const MAIL_FROM = process.env.MAIL_FROM || "L'Atelier <onboarding@resend.dev>";
const MAIL_TO = process.env.MAIL_TO || 'n.benlarbi3@gmail.com';

// 2. Échappement des données du formulaire avant insertion dans le HTML.
// Le formulaire est public : sans ça, n'importe qui peut injecter du balisage
// dans l'e-mail de notification.
const escapeHtml = (value) =>
  String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

// 3. Fonction d'envoi synchronisée avec le contrôleur
export const sendContactEmail = async ({ subject, name, email, message }) => {
  const safeName = escapeHtml(name);
  const safeEmail = escapeHtml(email);
  const safeSubject = escapeHtml(subject || 'Étude de projet web');
  const safeMessage = escapeHtml(message);

  const mailOptions = {
    from: MAIL_FROM,
    to: [MAIL_TO],
    // Permet de répondre directement au visiteur depuis la boîte de réception
    reply_to: email,
    subject: `[L'Atelier] ${subject || 'Demande de projet'} - ${name}`,
    text: `Nouveau message reçu depuis le formulaire.\n\nNom : ${name}\nEmail : ${email}\n\nMessage :\n${message}`,
    html: `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Notification de nouveau message - L'Atelier</title>
  <style>
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; padding: 10px !important; }
      .email-body { padding: 25px 20px !important; }
      .header-title { font-size: 20px !important; }
      .info-card { padding: 16px !important; }
      .btn-responsive { width: 100% !important; display: block !important; text-align: center !important; box-sizing: border-box; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #faf9f5; font-family: 'Segoe UI', Arial, sans-serif; -webkit-text-size-adjust: 100%;">
  
  <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color: #faf9f5; padding: 30px 10px;">
    <tr>
      <td align="center">
        
        <table role="presentation" class="email-container" width="600" border="0" cellspacing="0" cellpadding="0" style="width: 600px; background-color: #ffffff; border-radius: 12px; overflow: hidden; border: 1px solid #e6e2da; box-shadow: 0 4px 12px rgba(44, 62, 43, 0.03);">
          
          <tr>
            <td style="background-color: #5b8266; background: linear-gradient(135deg, #5b8266 0%, #3d5a45 100%); padding: 35px 30px; text-align: center;">
              <span style="color: #ffffff; text-transform: uppercase; font-size: 10px; letter-spacing: 0.25em; font-weight: 800; display: block; margin-bottom: 6px;">Espace Administration</span>
              <h1 class="header-title" style="margin: 0; color: #ffffff; font-size: 22px; font-family: Georgia, serif; font-weight: normal; letter-spacing: 0.02em;">Nouvelle demande de contact</h1>
            </td>
          </tr>
          
          <tr>
            <td class="email-body" style="padding: 40px 35px;">
              <p style="margin: 0 0 25px 0; color: #2c3e2b; font-size: 14px; line-height: 1.6;">
                Bonjour Nesrine,<br><br>
                Une nouvelle demande d'étude de besoins a été déposée depuis le formulaire de contact de <strong>L'Atelier</strong>. Voici les éléments transmis :
              </p>
              
              <table role="presentation" class="info-card" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color: #faf9f5; border-radius: 8px; padding: 24px; margin-bottom: 30px; border-left: 3px solid #c2a679; border-top: 1px solid #e6e2da; border-right: 1px solid #e6e2da; border-bottom: 1px solid #e6e2da;">
                <tr>
                  <td style="padding-bottom: 4px; font-size: 9px; color: #8c6239; font-weight: 700; text-transform: uppercase; letter-spacing: 0.15em;">Expéditeur</td>
                </tr>
                <tr>
                  <td style="font-size: 15px; color: #1c281b; font-weight: 600; padding-bottom: 16px; font-family: Georgia, serif;">
                    ${safeName}
                    <br>
                    <span style="font-weight: normal; font-size: 12px; font-family: sans-serif;">
                      <a href="mailto:${encodeURIComponent(email ?? '')}" style="color: #5b8266; text-decoration: underline;">${safeEmail}</a>
                    </span>
                  </td>
                </tr>
                
                <tr>
                  <td style="padding-bottom: 4px; font-size: 9px; color: #8c6239; font-weight: 700; text-transform: uppercase; letter-spacing: 0.15em;">Sujet du message</td>
                </tr>
                <tr>
                  <td style="font-size: 13px; color: #1c281b; font-weight: 600; padding-bottom: 16px;">
                    ${safeSubject}
                  </td>
                </tr>
                
                <tr>
                  <td style="padding-bottom: 6px; font-size: 9px; color: #8c6239; font-weight: 700; text-transform: uppercase; letter-spacing: 0.15em;">Description du besoin</td>
                </tr>
                <tr>
                  <td style="font-size: 13px; color: #4a5549; line-height: 1.6; white-space: pre-wrap; background-color: #ffffff; padding: 12px; border: 1px solid #e6e2da; border-radius: 4px;">
                    "${safeMessage}"
                  </td>
                </tr>
              </table>
              
              <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="center">
              <a href="mailto:${encodeURIComponent(email ?? '')}" class="btn-responsive" style="display: inline-block; background-color: #5b8266; color: #ffffff; font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; padding: 14px 24px; text-decoration: none; border-radius: 4px; transition: background-color 0.3s;">
                Répondre par e-mail
              </a>
                  </td>
                </tr>
              </table>

            </td>
          </tr>
          
          <tr>
            <td style="background-color: #faf9f5; padding: 24px; text-align: center; border-top: 1px solid #e6e2da; font-size: 11px; color: #6b7264; line-height: 1.5;">
              <strong>L'Atelier — Nesrine Benlarbi</strong>
              <br>
              <span style="font-size: 10px; color: #a39683; display: block; margin-top: 4px;">Rigueur · Structure · Autonomie • Notification Automatique</span>
            </td>
          </tr>
          
        </table>
        
      </td>
    </tr>
  </table>
</body>
</html>`
  };

  try {
    if (!process.env.RESEND_API_KEY) {
      throw new Error("RESEND_API_KEY absente : le service d'envoi n'est pas configuré.");
    }

    // Délai explicite : sans lui, une panne réseau laisserait le visiteur
    // devant un formulaire qui tourne indéfiniment. Dix secondes suffisent.
    const reponse = await fetch(RESEND_URL, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(mailOptions),
      signal: AbortSignal.timeout(10000),
    });

    if (!reponse.ok) {
      throw new Error(`Resend a répondu ${reponse.status} : ${await reponse.text()}`);
    }

    return await reponse.json();
  } catch (error) {
    // Le détail technique (clé d'API, réponse de Resend…) reste côté serveur,
    // on ne renvoie au visiteur qu'un message générique.
    console.error("💥 ERREUR CRITIQUE ENVOI E-MAIL :", error.message);
    throw new AppError(
      "L'envoi du message a échoué. Veuillez réessayer plus tard ou me contacter directement par e-mail.",
      500
    );
  }
};