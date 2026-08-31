import { body } from 'express-validator';

/**
 * Règles de validation pour la connexion (login)
 */
export const validateAuth = [
  body('email')
    .trim() // Nettoie les espaces inutiles
    .notEmpty().withMessage('L’email est obligatoire').bail()
    .isEmail().withMessage('Format d’email invalide').bail()
    .normalizeEmail(), // Met l'email en minuscules, etc.

  body('password')
    .notEmpty().withMessage('Le mot de passe est obligatoire').bail()
];