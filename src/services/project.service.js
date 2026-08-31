import * as projectModel from '../models/project.model.js';
import AppError from '../errors/AppError.js';

/**
 * Récupère tous les projets non archivés
 */
export const getAllProjects = async () => {
    // Optimisé : MySQL s'occupe déjà de filtrer les 'deleted_at IS NULL'
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
    return await projectModel.create(data, userId);
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

  return await projectModel.update(cleanId, data);
};

/**
 * Archive un projet (Soft Delete sécurisé)
 */
export const deleteProject = async (id) => {
  const cleanId = parseInt(id, 10);

  if (isNaN(cleanId)) {
    throw new AppError('Identifiant de projet invalide', 400);
  }

  // Appelle la méthode remove() du modèle qui exécute l'UPDATE avec la date actuelle
  const isArchived = await projectModel.remove(cleanId);
  
  if (!isArchived) {
    throw new AppError('Projet introuvable ou déjà supprimé', 404);
  }
};