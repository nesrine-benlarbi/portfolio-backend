import * as contactService from '../services/contact.service.js';

export const sendContact = async (req, res, next) => {
  try {
    // 1. Extraire les données du corps de la requête
    const { subject, name, email, message } = req.body;

    // 2. Appeler le service pour envoyer l'email
    await contactService.sendContactEmail({ subject, name, email, message });

    // 3. Répondre au client en cas de succès
    res.json({ message: 'Message envoyé avec succès' });
  } catch (error) {
    // Transmettre l'erreur au middleware de gestion d'erreurs
    next(error);
  }
};