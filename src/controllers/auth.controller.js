import * as authService from '../services/auth.service.js';

export const login = async (req, res, next) => {
  try {
    // 1. Extrait email et password de req.body
    const { email, password } = req.body;

    // 2. Appelle authService.loginUser(...)
    const token = await authService.loginUser({ email, password });

    // 3. Renvoie res.json({ token }) en cas de succès
    res.json({ token });
  } catch (error) {
    // Transmet l'erreur (comme 'Identifiants invalides') à errorHandler.js
    next(error); 
  }
};
