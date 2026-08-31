import { Router } from 'express';
import * as contactController from '../controllers/contact.controller.js';
import validate from '../middlewares/validate.middleware.js';
import { body } from 'express-validator';
import { validateContact } from '../validators/contact.validator.js';

const router = Router();

// Optionnel : Un petit validateur rapide pour s'assurer que les champs sont remplis

router.post('/', validateContact, validate, contactController.sendContact);

export default router;
