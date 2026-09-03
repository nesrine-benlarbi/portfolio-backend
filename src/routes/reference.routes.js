import { Router } from 'express';
import * as referenceController from '../controllers/reference.controller.js';

const router = Router();

// GET /api/categories   — liste des catégories de projet
router.get('/categories', referenceController.getCategories);

// GET /api/technologies — liste des technologies déjà enregistrées
router.get('/technologies', referenceController.getTechnologies);

export default router;
