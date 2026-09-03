import * as projectModel from '../models/project.model.js';
import AppError from '../errors/AppError.js';

/**
 * Normalise la liste des technologies reçue du client.
 *
 * Le formulaire d'administration envoie une chaîne saisie à la main
 * (« React, Node.js, MySQL »). On la découpe ici, une bonne fois pour
 * toutes, avant que le modèle n'écrive dans la table de liaison :
 *  - suppression des espaces superflus ;
 *  - suppression des entrées vides (double virgule, virgule finale) ;
 *  - suppression des doublons, insensible à la casse, pour éviter
 *    d'enregistrer « React » et « react » comme deux technologies.
 *
 * Un tableau est également accepté, si l'interface évolue un jour vers
 * une liste à cocher.
 */
const parseTechnologies = (value) => {
    if (value === undefined || value === null) return [];

    const brut = Array.isArray(value) ? value : String(value).split(',');
    const vues = new Map();

    for (const item of brut) {
        const nom = String(item).trim();
        if (!nom) continue;
        const cle = nom.toLowerCase();
        if (!vues.has(cle)) vues.set(cle, nom);
    }

    return Array.from(vues.values());
};

/**
 * Prépare les données d'un projet avant écriture.
 *
 * La catégorie est transmise sous forme de libellé, comme les technologies :
 * le modèle la retrouve ou la crée. L'administratrice peut ainsi introduire
 * une nouvelle catégorie depuis le formulaire, sans écrire une ligne de SQL.
 */
const prepare = (data) => ({
    ...data,
    category: typeof data.category === 'string' ? data.category.trim() : null,
    technologies: parseTechnologies(data.technologies),
});

/**
 * Récupère tous les projets non archivés
 */
export const getAllProjects = async () => {
    return await projectModel.findAll();
};

/**
 * Récupère un projet par son ID s'il n'est pas archivé
 */
export const getProjectById = async (id) => {
    // SÉCURITÉ : On force la conversion de l'ID en nombre entier
    const cleanId = parseInt(id, 10);

    if (isNaN(cleanId)) {
        throw new AppError('Identifiant de projet invalide', 400);
    }

    const project = await projectModel.findById(cleanId);

    if (!project) {
        throw new AppError('Projet introuvable ou archivé', 404);
    }

    return project;
};

/**
 * Crée un nouveau projet rattaché à l'administrateur connecté (userId)
 */
export const createProject = async (data, userId) => {
    return await projectModel.create(prepare(data), userId);
};

/**
 * Met à jour un projet existant
 */
export const updateProject = async (id, data) => {
    const cleanId = parseInt(id, 10);

    if (isNaN(cleanId)) {
        throw new AppError('Identifiant de projet invalide', 400);
    }

    // On vérifie d'abord si le projet existe et n'est pas archivé
    const project = await projectModel.findById(cleanId);
    if (!project) {
        throw new AppError('Projet introuvable ou archivé', 404);
    }

    return await projectModel.update(cleanId, prepare(data));
};

/**
 * Archive un projet (Soft Delete sécurisé)
 */
export const deleteProject = async (id) => {
    const cleanId = parseInt(id, 10);

    if (isNaN(cleanId)) {
        throw new AppError('Identifiant de projet invalide', 400);
    }

    const isArchived = await projectModel.remove(cleanId);

    if (!isArchived) {
        throw new AppError('Projet introuvable ou déjà supprimé', 404);
    }
};
