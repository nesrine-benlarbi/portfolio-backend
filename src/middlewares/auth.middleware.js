import jwt from 'jsonwebtoken';
import AppError from '../errors/AppError.js';

const authenticate = (req, res, next) => {
  // 1. Lire le header Authorization
  const authHeader = req.headers.authorization;

  // 2. Vérifier s'il est présent et s'il commence par 'Bearer '
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // Si pas de token, on renvoie une erreur 401 via notre gestionnaire centralisé
    return next(new AppError('Authentification requise : Token manquant', 401));
  }

  // 3. Extraire le token (on retire 'Bearer ' qui fait 7 caractères)
  const token = authHeader.split(' ')[1];

  try {
    // 4. Vérifier le token avec la clé secrète du .env
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 5. Stocker le payload décodé (id, email, role) dans req.user
    // Cela permet aux routes suivantes de savoir QUI est connecté
    req.user = decoded;

    // 6. On laisse passer à l'étape suivante (le contrôleur ou un autre middleware)
    next();
  } catch (error) {
    // Si le token est expiré ou invalide, jwt.verify lance une erreur
    next(new AppError('Session expirée ou token invalide', 401));
  }
};

export default authenticate;