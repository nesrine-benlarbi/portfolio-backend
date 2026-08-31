import AppError from '../errors/AppError.js';

/**
 * Factory middleware pour vérifier les permissions
 * @param {...string} roles - Liste des rôles autorisés (ex: 'admin', 'user')
 */
const authorize = (...roles) => {
  return (req, res, next) => {
    // 1. On vérifie si l'utilisateur existe (injecté par le middleware authenticate)
    if (!req.user) {
      return next(new AppError('Authentification requise', 401));
    }

    // 2. On vérifie si le rôle de l'utilisateur est dans la liste des rôles permis
    if (!roles.includes(req.user.role)) {
      return next(new AppError("Accès refusé : vous n'avez pas les permissions nécessaires", 403));
    }

    // 3. Si tout est bon, on passe à la suite
    next();
  };

};

export default authorize;
