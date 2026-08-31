import { body } from 'express-validator';

/**
 * Règles de validation pour la création et modification d'un projet
 */
export const validateProject = [
  body('title')
    .trim()
    .notEmpty().withMessage('Le titre est obligatoire')
    .isLength({ min: 2, max: 150 }).withMessage('Le titre doit faire entre 2 et 150 caractères'),

  body('description')
    .optional()
    .trim()
    .isString()
    .isLength({ max: 2000 }).withMessage('La description ne peut pas dépasser 2000 caractères'),

  body('tech_stack')
    .optional()
    .trim()
    .isString()
    .isLength({ max: 255 }).withMessage('La stack technique ne peut pas dépasser 255 caractères'),

  body('github_url')
    .optional({ checkFalsy: true }) // Permet d'accepter une chaîne vide comme "valide"
    .trim()
    .isURL().withMessage('Le lien GitHub doit être une URL valide'),

  body('demo_url')
    .optional({ checkFalsy: true })
    .trim()
    .isURL().withMessage('Le lien de démo doit être une URL valide'),

  body('image_url')
    .optional({ checkFalsy: true })
    .trim()
    .isURL().withMessage("L'URL de l'image doit être valide")
];