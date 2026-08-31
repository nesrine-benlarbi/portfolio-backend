import { body } from 'express-validator';

/**
 * Règles de validation pour le formulaire de contact
 */
export const validateContact = [
  body('name')
    .notEmpty().withMessage('Le nom est obligatoire')
    .isLength({ min: 2, max: 100 }).withMessage('Le nom doit contenir entre 2 et 100 caractères'),

  body('email')
    .notEmpty().withMessage("L'email est obligatoire")
    .isEmail().withMessage('Format d’email invalide'),

  body('message')
    .notEmpty().withMessage('Le message ne peut pas être vide')
    .isLength({ min: 10, max: 2000 }).withMessage('Le message doit contenir entre 10 et 2000 caractères')
];