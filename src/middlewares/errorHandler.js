import AppError from "../errors/AppError.js";

const errorHandler = (err, req, res, next) => {
  // 🎯 On ajoute un "return" pour stopper le code immédiatement si c'est une erreur contrôlée
  if (err instanceof AppError) {
    return res.status(err.status).json({
      message: err.message
    });
  }

  // Si le code arrive ici, c'est que c'est une vraie erreur imprévue (Bug, crash BDD, etc.)
  console.error(" ERREUR SERVEUR INDÉTERMINÉE :", err.stack);

  res.status(500).json({
    status: 'error',
    message: 'Erreur interne du serveur'
  });
};

export default errorHandler;