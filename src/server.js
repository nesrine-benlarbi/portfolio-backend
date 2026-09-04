import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import errorHandler from './middlewares/errorHandler.js';
import authRoutes from './routes/auth.routes.js';
import contactRoutes from './routes/contact.routes.js';
import projectRoutes from './routes/project.routes.js';
import referenceRoutes from './routes/reference.routes.js';
import { importerSchema } from './seed.js';

const app = express();
const PORT = process.env.PORT || 3001;


app.use(
  cors({
    origin: process.env.CORS_ORIGIN,
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(express.json());

// Routes API
app.use('/api/auth', authRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api', referenceRoutes); // /api/categories et /api/technologies

// Gestionnaire d'erreurs (toujours en dernier)
app.use(errorHandler);

// Lancement du serveur
app.listen(PORT, async () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);

  // Import ponctuel du schéma, uniquement si SEED_ON_BOOT vaut "true".
  // Sert à initialiser une base distante dont le port est inaccessible
  // depuis le poste de développement.
  await importerSchema();
});