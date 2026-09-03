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

  // Catégorie saisie sous forme de libellé : elle est retrouvée ou créée
  // par le modèle. La longueur est bornée par la colonne `categories.name`.
  body('category')
    .optional({ checkFalsy: true })
    .trim()
    .isLength({ max: 80 }).withMessage('La catégorie ne peut pas dépasser 80 caractères'),

  // Technologies : chaîne saisie à la main (« React, Node.js »), ou
  // tableau si l'interface évolue. Le service se charge du découpage.
  body('technologies')
    .optional({ checkFalsy: true })
    .custom((value) => {
      if (Array.isArray(value)) return true;
      if (typeof value === 'string') {
        if (value.length > 255) throw new Error('La liste des technologies ne peut pas dépasser 255 caractères');
        return true;
      }
      throw new Error('Le format des technologies est invalide');
    }),

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
