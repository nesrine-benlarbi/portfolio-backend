import * as projectService from '../services/project.service.js';

// Récupérer tous les projets actifs (Non archivés)
export const getAllProjects = async (req, res, next) => {
  try {
    const projects = await projectService.getAllProjects();
    res.json(projects || []);
  } catch (error) {
    next(error);
  }
};

// Récupérer un projet spécifique par son ID
export const getProjectById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const project = await projectService.getProjectById(id);
    res.json(project);
  } catch (error) {
    next(error);
  }
};

// Créer un nouveau projet
export const createProject = async (req, res, next) => {
  try {
    // req.user est injecté par le middleware authenticate (payload du JWT)
    const project = await projectService.createProject(req.body, req.user.id);
    res.status(201).json(project);
  } catch (error) {
    next(error);
  }
};

// Mettre à jour un projet existant
export const updateProject = async (req, res, next) => {
  try {
    const { id } = req.params;
    const project = await projectService.updateProject(id, req.body);
    res.json(project);
  } catch (error) {
    next(error);
  }
};

// Retirer un projet (Soft Delete sécurisé)
export const deleteProject = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    // Le service va exécuter la requête UPDATE pour mettre la date dans 'deleted_at'
    await projectService.deleteProject(id);
    
    // On renvoie un statut 200 (OK) avec un JSON pour que le Front-End reçoive la confirmation
    res.status(200).json({ 
      success: true,
      message: "Le projet a été retiré de l'inventaire et archivé avec succès." 
    });
  } catch (error) {
    next(error);
  }
};