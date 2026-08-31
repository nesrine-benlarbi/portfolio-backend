import { Router } from 'express';
import * as projectController from '../controllers/project.controller.js';
import authenticate from '../middlewares/auth.middleware.js';
import authorize from '../middlewares/authorize.middleware.js';
import { validateProject } from '../validators/project.validator.js';
import validate from '../middlewares/validate.middleware.js';



const router = Router();


router.get('/', projectController.getAllProjects);
router.get('/:id', projectController.getProjectById);

// POST /api/projects
router.post('/',
    authenticate,
    authorize('admin'),
    validateProject,
    validate,
    projectController.createProject
);

// PUT /api/projects/:id (Privé - Admin)
router.put('/:id', 
  authenticate, 
  authorize('admin'), 
  validateProject, 
  validate, 
  projectController.updateProject
);

// DELETE /api/projects/:id (Privé - Admin)
router.delete('/:id', 
  authenticate, 
  authorize('admin'), 
  projectController.deleteProject
);



export default router;