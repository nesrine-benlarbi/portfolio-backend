import { Router } from 'express';
import * as authController from '../controllers/auth.controller.js';
import { validateAuth } from '../validators/auth.validator.js';
import validate from '../middlewares/validate.middleware.js';

 const router = Router();

// Route : POST /api/auth/login
// L'ordre est crucial : Validation des données -> Vérification des erreurs -> Logique métier
router.post('/login', validateAuth, validate, authController.login);

export default router;