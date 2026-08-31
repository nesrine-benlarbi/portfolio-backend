import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import errorHandler from './middlewares/errorHandler.js';
import authRoutes from './routes/auth.routes.js';
import contactRoutes from './routes/contact.routes.js';
import projectRoutes from './routes/project.routes.js';

const app = express();
const PORT = process.env.PORT || 3001;

// Middlewares globaux
app.use(
  cors({
    origin: process.env.CLIENT_URL || 'http://localhost:5173',
  })
);

app.use(express.json());

// Routes API
app.use('/api/auth', authRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/contact', contactRoutes);

// Gestionnaire d'erreurs (toujours en dernier)
app.use(errorHandler);

// Lancement du serveur
app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});